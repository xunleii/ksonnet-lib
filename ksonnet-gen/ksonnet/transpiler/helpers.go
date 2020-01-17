package transpiler

import (
	"strings"

	"github.com/google/go-jsonnet/ast"

	"github.com/ksonnet/ksonnet-lib/ksonnet-gen/ksonnet/transpiler/iast"
)

var inlineObject = ast.NewNodeBaseLoc(ast.LocationRange{Begin: ast.Location{Line: 1}, End: ast.Location{Line: 1}})

func newIdentifier(name string) *ast.Identifier {
	id := ast.Identifier(name)
	return &id
}

// AstComment is an extension of the jsonnet ast.Node, allowing us to
// manage comments.
type AstComment struct {
	ast.NodeBase
	Content string
}

const ObjectComment ast.ObjectFieldKind = iota + 0x10

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

// newReferenceType generates a jsonnet object field containing a link to
// the referenced API object.
// JSONNET: nameType:: hidden.refGroup.refVersion.refKind
func newReferenceType(name string, ref *iast.APINode) ast.ObjectField {
	typeName := name + "Type"
	group, version, kind := ref.Definition.Group, ref.Definition.Version, ref.Definition.Kind

	var index ast.Node = &ast.Var{Id: "hidden"}
	if group != "core" {
		index = &ast.Index{Target: index, Id: newIdentifier(group)}
	}
	index = &ast.Index{Target: index, Id: newIdentifier(version)}
	index = &ast.Index{Target: index, Id: newIdentifier(kind)}

	return ast.ObjectField{
		Kind:  ast.ObjectFieldID,
		Hide:  ast.ObjectFieldHidden,
		Id:    newIdentifier(typeName),
		Expr2: index,
	}
}

// newWithArrayGenericFnc helps to generate a jsonnet method more easily.
func newWithGenericFnc(fnc, param string, op ast.Node) ast.ObjectField {
	// fncId(paramId):: self + op
	astFnc := ast.Function{
		Parameters: ast.Parameters{Required: []ast.Identifier{ast.Identifier(param)}},
		// self + op
		Body: &ast.Binary{
			Left:  &ast.Self{},
			Op:    ast.BopPlus,
			Right: op,
		},
	}

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
// JSONNET: withName(name):: self + self.mixinInstance({ name: name }
func newWithScalarFnc(name string) ast.ObjectField {
	// self.mixinInstance({ name: name })
	op := &ast.Apply{
		Target: &ast.Index{
			Target: &ast.Self{},
			Id:     newIdentifier("mixinInstance"),
		},
		Arguments: ast.Arguments{
			Positional: []ast.Node{
				// { name: name }
				&ast.Object{
					NodeBase: inlineObject,
					Fields: []ast.ObjectField{
						{
							Kind:  ast.ObjectFieldID,
							Hide:  ast.ObjectFieldInherit,
							Id:    newIdentifier(name),
							Expr2: &ast.Var{Id: ast.Identifier(name)},
						},
					},
				},
			},
		},
	}
	return newWithGenericFnc("with"+strings.Title(name), name, op)
}

// newWithArrayGenericFnc helps to generates the array method more
// easily (the ast condition is too heavy to be written several times).
func newWithArrayGenericFnc(fnc, param string, objTrue, objFalse ast.ObjectField) ast.ObjectField {
	// if std.type(param) == 'array' then self.mixinInstance(objTrue) else self.mixinInstance(objFalse)
	op := &ast.Conditional{
		// std.type(param) == 'array'
		Cond: &ast.Binary{
			Left: &ast.Apply{
				Target:    &ast.Index{Target: &ast.Var{Id: "std"}, Id: newIdentifier("type")},
				Arguments: ast.Arguments{Positional: []ast.Node{&ast.Var{Id: ast.Identifier(param)}}},
			},
			Op:    ast.BopManifestEqual,
			Right: &ast.LiteralString{Value: "array"},
		},
		// self.mixinInstance(objTrue)
		BranchTrue: &ast.Apply{
			Target:    &ast.Index{Target: &ast.Self{}, Id: newIdentifier("mixinInstance")},
			Arguments: ast.Arguments{Positional: []ast.Node{&ast.Object{NodeBase: inlineObject, Fields: []ast.ObjectField{objTrue}}}},
		},
		// self.mixinInstance(objFalse)
		BranchFalse: &ast.Apply{
			Target:    &ast.Index{Target: &ast.Self{}, Id: newIdentifier("mixinInstance")},
			Arguments: ast.Arguments{Positional: []ast.Node{&ast.Object{NodeBase: inlineObject, Fields: []ast.ObjectField{objFalse}}}},
		},
	}
	return newWithGenericFnc(fnc, param, op)
}

// newWithArrayFnc generates the jsonnet method that add an array to an
// object field.
// JSONNET: withName(name):: self + if std.type(name) == 'array' then
// self.mixinInstance({ name: name }) else self.mixinInstance({ name: [name] }
func newWithArrayFnc(name string) ast.ObjectField {
	// name: name
	objTrue := ast.ObjectField{
		Kind: ast.ObjectFieldID, Hide: ast.ObjectFieldInherit,
		Id: newIdentifier(name), Expr2: &ast.Var{Id: ast.Identifier(name)},
	}
	// name: [name]
	objFalse := ast.ObjectField{
		Kind: ast.ObjectFieldID, Hide: ast.ObjectFieldInherit,
		Id: newIdentifier(name), Expr2: &ast.Array{Elements: []ast.Node{&ast.Var{Id: ast.Identifier(name)}}},
	}

	return newWithArrayGenericFnc("with"+strings.Title(name), name, objTrue, objFalse)
}

// newWithMixinArrayFnc generates the jsonnet method that merge an array with an
// object field.
// JSONNET: withNameMixin(name):: self + if std.type(name) == 'array' then
// self.mixinInstance({ name+: name }) else self.mixinInstance({ name+: [name] }
func newWithMixinArrayFnc(name string) ast.ObjectField {
	// name+: name
	objTrue := ast.ObjectField{
		Kind: ast.ObjectFieldID, Hide: ast.ObjectFieldInherit, SuperSugar: true,
		Id: newIdentifier(name), Expr2: &ast.Var{Id: ast.Identifier(name)},
	}
	// name+: [name]
	objFalse := ast.ObjectField{
		Kind: ast.ObjectFieldID, Hide: ast.ObjectFieldInherit, SuperSugar: true,
		Id: newIdentifier(name), Expr2: &ast.Array{Elements: []ast.Node{&ast.Var{Id: ast.Identifier(name)}}},
	}

	return newWithArrayGenericFnc("with"+strings.Title(name)+"Mixin", name, objTrue, objFalse)
}

// newLocalMixinFnc generates the jsonnet local method "__mixinName",
// common with all k8s.libsonnet objects.
// JSONNET: local __mixinName(name) = __mixinParentName({ name+: name })
// or
// JSONNET: local __mixinName(name) = { name+: name }
func newLocalMixinFnc(name, upperMethod string) []ast.ObjectField {
	// { name+: name }
	var localFncBody ast.Node = &ast.Object{
		NodeBase: inlineObject,
		Fields: []ast.ObjectField{
			{
				Kind: ast.ObjectFieldID, Hide: ast.ObjectFieldInherit, SuperSugar: true,
				Id: newIdentifier(name), Expr2: &ast.Var{Id: ast.Identifier(name)},
			},
		},
	}

	// If upperMethod exists, we need to call it.
	if upperMethod != "" {
		// __mixinParentName({ name+: name })
		localFncBody = &ast.Apply{
			Target:    &ast.Var{Id: ast.Identifier("__mixin" + strings.Title(upperMethod))},
			Arguments: ast.Arguments{Positional: []ast.Node{localFncBody}},
		}
	}

	localMixinFnc := ast.Function{
		Parameters: ast.Parameters{Required: []ast.Identifier{ast.Identifier(name)}},
		Body:       localFncBody,
	}

	return []ast.ObjectField{
		{
			Kind: ast.ObjectLocal, Hide: ast.ObjectFieldVisible, Id: newIdentifier("__mixin" + strings.Title(name)),
			MethodSugar: true, Method: &localMixinFnc, Params: &localMixinFnc.Parameters, Expr2: localMixinFnc.Body,
		},
	}
}

// newSelfMixinFnc generates the jsonnet methods "mixinInstance",
// common with all k8s.libsonnet objects.
// JSONNET: mixinInstance(name) = __mixinName(name)
func newSelfMixinFnc(name string) []ast.ObjectField {
	// mixinInstance(name):: __mixinName(name)
	selfMixinFnc := ast.Function{
		Parameters: ast.Parameters{Required: []ast.Identifier{ast.Identifier(name)}},
		// __mixinName(name)
		Body: &ast.Apply{
			Target:    &ast.Var{Id: ast.Identifier("__mixin" + strings.Title(name))},
			Arguments: ast.Arguments{Positional: []ast.Node{&ast.Var{Id: ast.Identifier(name)}}},
		},
	}

	return []ast.ObjectField{
		{
			Kind: ast.ObjectFieldID, Hide: ast.ObjectFieldHidden, Id: newIdentifier("mixinInstance"),
			MethodSugar: true, Method: &selfMixinFnc, Params: &selfMixinFnc.Parameters, Expr2: selfMixinFnc.Body,
		},
	}
}
