package transpiler

import (
	"strings"

	"github.com/google/go-jsonnet/ast"

	"github.com/ksonnet/ksonnet-lib/ksonnet-gen/ksonnet/transpiler/iast"
)

var (
	inlineObject = ast.NewNodeBaseLoc(ast.LocationRange{Begin: ast.Location{Line: 1}, End: ast.Location{Line: 1}})
)

// AstComment is an extension of the jsonnet ast.Node, allowing us to
// manage comments.
type AstComment struct {
	ast.NodeBase
	Content string
}

const ObjectComment ast.ObjectFieldKind = iota + 0x10

// newAstComment creates a new comment based on the AstComment extension.
func newAstComment(comment string) []ast.ObjectField {
	var astComments []ast.ObjectField

	for _, line := range strings.Split(comment, "\n") {
		astComments = append(astComments, ast.ObjectField{
			Kind:  ObjectComment,
			Expr1: &AstComment{Content: line},
		})
	}
	return astComments
}

// newIdentifier returns a simple ast.Identifier pointer.
func newIdentifier(name string) *ast.Identifier {
	id := ast.Identifier(name)
	return &id
}

// newReferencePtr generates a jsonnet object field linking to an hidden API object.
// JSONNET: definitions.refGroup.refVersion.refKind(function(name) name)
// or, if useMixinInstance is true
// JSONNET: definitions.refGroup.refVersion.refKind(function(name) self.mixinInstance({name+: name}))
func newReferencePtr(name string, ref *iast.APINode, useMixinInstance bool) ast.Node {
	group, version, kind := ref.Definition.Group, ref.Definition.Version, ref.Definition.Kind

	// JSONNET: definitions.refGroup.refVersion.refKind
	index := &ast.Index{
		Target: &ast.Index{
			Target: &ast.Index{
				Target: &ast.Var{Id: "definition"},
				Id:     newIdentifier(group),
			},
			Id: newIdentifier(version),
		},
		Id: newIdentifier(formatKind(kind)),
	}

	// JSONNET: name
	var paramFncBody ast.Node = &ast.Var{Id: ast.Identifier(name)}

	if useMixinInstance {
		// JSONNET: mixinInstance({name+: name})
		paramFncBody = &ast.Apply{
			Target: &ast.Var{Id: "mixinInstance"},
			Arguments: ast.Arguments{Positional: []ast.Node{
				&ast.Object{
					NodeBase: inlineObject,
					Fields: []ast.ObjectField{
						{
							Kind: ast.ObjectFieldID, Hide: ast.ObjectFieldInherit, SuperSugar: true,
							Id: newIdentifier(name), Expr2: paramFncBody,
						},
					},
				},
			}},
		}
	}

	// JSONNET: function(name) name
	// or, if useMixinInstance is true
	// JSONNET: function(name) self.mixinInstance({name+: name})
	paramFnc := &ast.Function{
		Parameters: ast.Parameters{Required: []ast.Identifier{ast.Identifier(name)}},
		Body:       paramFncBody,
	}

	// JSONNET: definitions.refGroup.refVersion.refKind(function(name) name)
	// or, if useMixinInstance is true
	// JSONNET: definitions.refGroup.refVersion.refKind(function(name) mixinInstance({name+: name}))
	return &ast.Apply{
		Target:    index,
		Arguments: ast.Arguments{Positional: []ast.Node{paramFnc}},
	}
}

// newReferenceType generates a jsonnet object field containing a link to
// the referenced API object.
// JSONNET: nameType:: definitions.refGroup.refVersion.refKind(function(name) name)
func newReferenceType(name string, ref *iast.APINode) ast.ObjectField {
	return ast.ObjectField{
		Kind: ast.ObjectFieldID, Hide: ast.ObjectFieldHidden,
		Id: newIdentifier(name + "Type"), Expr2: newReferencePtr(name, ref, false),
	}
}

// newReferenceMixin generates a jsonnet object field linking to a mixin field.
// JSONNET: name:: self.mixin.name
func newReferenceMixin(name string) ast.ObjectField {
	return ast.ObjectField{
		Kind: ast.ObjectFieldID, Hide: ast.ObjectFieldHidden,
		Id:    newIdentifier(name),
		Expr2: &ast.Index{Target: &ast.Index{Target: &ast.Self{}, Id: newIdentifier("mixin")}, Id: newIdentifier(name)},
	}
}

// newWithArrayGenericFnc helps to generate a jsonnet method more easily.
func newWithGenericFnc(fnc, param string, op ast.Node) ast.ObjectField {
	// JSONNET: (param):: self + op
	astFnc := ast.Function{
		Parameters: ast.Parameters{Required: []ast.Identifier{ast.Identifier(param)}},
		// JSONNET: self + op
		Body: &ast.Binary{
			Left:  &ast.Self{},
			Op:    ast.BopPlus,
			Right: op,
		},
	}

	// JSONNET: fnc(param):: self + op
	return ast.ObjectField{
		Kind:        ast.ObjectFieldID,
		Hide:        ast.ObjectFieldHidden,
		MethodSugar: true,
		Method:      &astFnc,
		Id:          newIdentifier(fnc),
		Params:      &astFnc.Parameters,
		Expr2:       astFnc.Body,
	}
}

// newWithScalarFnc generates the jsonnet method that add a scalar value to
// an object field.
// JSONNET: withName(name):: self + {name: name}
// or, if useMixinInstance == true
// JSONNET: withName(name):: self + mixinInstance({name: name})
func newWithScalarFnc(name string, useMixinInstance bool) ast.ObjectField {
	// JSONNET: {name: name}
	var op ast.Node = &ast.Object{
		NodeBase: inlineObject,
		Fields: []ast.ObjectField{
			{
				Kind:  ast.ObjectFieldID,
				Hide:  ast.ObjectFieldInherit,
				Id:    newIdentifier(name),
				Expr2: &ast.Var{Id: ast.Identifier(name)},
			},
		},
	}

	if useMixinInstance {
		// JSONNET: self.mixinInstance({name: name})
		op = &ast.Apply{
			Target: &ast.Var{Id: "mixinInstance"},
			Arguments: ast.Arguments{
				Positional: []ast.Node{op},
			},
		}
	}
	return newWithGenericFnc("with"+strings.Title(name), name, op)
}

// newWithArrayGenericFnc helps to generates the array method more
// easily (the ast condition is too heavy to be written several times).
func newWithArrayGenericFnc(fnc, param string, branchTrue, branchFalse ast.Node) ast.ObjectField {
	// JSONNET: if std.type(param) == 'array' then branchTrue else branchFalse
	op := &ast.Conditional{
		// JSONNET: std.type(param) == 'array'
		Cond: &ast.Binary{
			Left: &ast.Apply{
				Target:    &ast.Index{Target: &ast.Var{Id: "std"}, Id: newIdentifier("type")},
				Arguments: ast.Arguments{Positional: []ast.Node{&ast.Var{Id: ast.Identifier(param)}}},
			},
			Op:    ast.BopManifestEqual,
			Right: &ast.LiteralString{Value: "array"},
		},
		// JSONNET: branchTrue
		BranchTrue: branchTrue,
		// JSONNET: branchFalse
		BranchFalse: branchFalse,
	}
	return newWithGenericFnc(fnc, param, op)
}

// newWithArrayFnc generates the jsonnet method that add an array to an
// object field.
// JSONNET: withName(name):: self + if std.type(name) == 'array' then {name: name} else {name: [name]}
// or, if useMixinInstance is true
// JSONNET: withName(name):: self + if std.type(name) == 'array' then mixinInstance({name: name}) else mixinInstance({name: [name]})
func newWithArrayFnc(name string, useMixinInstance bool) ast.ObjectField {
	// JSONNET: { name: name }
	var simpleObj ast.Node = &ast.Object{
		NodeBase: inlineObject,
		Fields: []ast.ObjectField{
			{
				Kind: ast.ObjectFieldID, Hide: ast.ObjectFieldInherit,
				Id: newIdentifier(name), Expr2: &ast.Var{Id: ast.Identifier(name)},
			},
		},
	}

	// JSONNET: {name: [name]}
	var arrObj ast.Node = &ast.Object{
		NodeBase: inlineObject,
		Fields: []ast.ObjectField{
			{
				Kind: ast.ObjectFieldID, Hide: ast.ObjectFieldInherit,
				Id: newIdentifier(name), Expr2: &ast.Array{Elements: []ast.Node{&ast.Var{Id: ast.Identifier(name)}}},
			},
		},
	}

	if useMixinInstance {
		// JSONNET: mixinInstance({name: name})
		simpleObj = &ast.Apply{
			Target:    &ast.Var{Id: "mixinInstance"},
			Arguments: ast.Arguments{Positional: []ast.Node{simpleObj}},
		}
		arrObj = &ast.Apply{
			Target:    &ast.Var{Id: "mixinInstance"},
			Arguments: ast.Arguments{Positional: []ast.Node{arrObj}},
		}
	}

	return newWithArrayGenericFnc("with"+strings.Title(name), name, simpleObj, arrObj)
}

// newWithMixinArrayFnc generates the jsonnet method that merge an array with an
// object field.
// JSONNET: withNameMixin(name):: self + if std.type(name) == 'array' then { name+: name } else { name+: [name] }
// or, if useMixinInstance is true
// JSONNET: withNameMixin(name):: self + if std.type(name) == 'array' then mixinInstance({ name+: name }) else mixinInstance({ name+: [name] })
func newWithMixinArrayFnc(name string, useMixinInstance bool) ast.ObjectField {
	// JSONNET: { name+: name }
	var simpleObj ast.Node = &ast.Object{
		NodeBase: inlineObject,
		Fields: []ast.ObjectField{
			{
				Kind: ast.ObjectFieldID, Hide: ast.ObjectFieldInherit, SuperSugar: true,
				Id: newIdentifier(name), Expr2: &ast.Var{Id: ast.Identifier(name)},
			},
		},
	}

	// JSONNET: { name+: [name] }
	var arrObj ast.Node = &ast.Object{
		NodeBase: inlineObject,
		Fields: []ast.ObjectField{
			{
				Kind: ast.ObjectFieldID, Hide: ast.ObjectFieldInherit, SuperSugar: true,
				Id: newIdentifier(name), Expr2: &ast.Array{Elements: []ast.Node{&ast.Var{Id: ast.Identifier(name)}}},
			},
		},
	}

	if useMixinInstance {
		simpleObj = &ast.Apply{
			Target:    &ast.Var{Id: "mixinInstance"},
			Arguments: ast.Arguments{Positional: []ast.Node{simpleObj}},
		}
		arrObj = &ast.Apply{
			Target:    &ast.Var{Id: "mixinInstance"},
			Arguments: ast.Arguments{Positional: []ast.Node{simpleObj}},
		}
	}

	return newWithArrayGenericFnc("with"+strings.Title(name)+"Mixin", name, simpleObj, arrObj)
}

// newSelfMixinFnc generates the jsonnet methods "mixinInstance",
// common with all k8s.libsonnet objects.
// JSONNET: mixinInstance(__self):: mixinInstance(__self)
func newSelfMixinFnc() ast.ObjectField {
	// JSONNET: mixinInstance(name):: mixinInstance(name)
	selfMixinFnc := ast.Function{
		Parameters: ast.Parameters{Required: []ast.Identifier{ast.Identifier("_self_")}},
		// JSONNET: mixinInstance(name)
		Body: &ast.Apply{
			Target:    &ast.Var{Id: ast.Identifier("mixinInstance")},
			Arguments: ast.Arguments{Positional: []ast.Node{&ast.Var{Id: ast.Identifier("_self_")}}},
		},
	}

	return ast.ObjectField{
		Kind: ast.ObjectFieldID, Hide: ast.ObjectFieldHidden, Id: newIdentifier("mixinInstance"),
		MethodSugar: true, Method: &selfMixinFnc, Params: &selfMixinFnc.Parameters, Expr2: selfMixinFnc.Body,
	}
}
