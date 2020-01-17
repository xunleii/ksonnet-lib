package ist

import (
	"sort"
	"strings"

	"github.com/google/go-jsonnet/ast"
)

var (
	oneLiner = ast.NewNodeBaseLoc(ast.LocationRange{Begin: ast.Location{Line: 1}, End: ast.Location{Line: 1}})
	emptyId  = ast.Identifier("")
)

// sortFieldIds create a sorted list of the object field name.
func sortFieldIds(obj Object) []string {
	ids := make([]string, len(obj.Fields))
	i := 0

	for id := range obj.Fields {
		ids[i] = id
		i++
	}
	sort.Strings(ids)
	return ids
}

// buildComment generates a jsonnet comment from the given value.
func buildComment(comment string) ast.ObjectField {
	return ast.ObjectField{
		Kind:  ObjectComment,
		Expr1: &Comment{Content: comment},
	}
}

// buildRefType generates a jsonnet object field containing a link to
// the referenced API object.
// JSONNET: nameType:: hidden.refGroup.refVersion.refKind
// (or nameType:: $.refGroup.refVersion.refKind is ref is public)
func buildRefType(name ast.Identifier, ref *APINode) ast.ObjectField {
	typeId := name + "Type"
	refPath := ref.Definition.APIPath()

	var index ast.Node = &ast.Var{Id: "hidden"}
	if ref.HasTag(PublicNodeTag) {
		index = &ast.Dollar{}
	}

	for _, path := range refPath {
		id := ast.Identifier(path)
		index = &ast.Index{Target: index, Id: &id}
	}

	return ast.ObjectField{
		Kind:  ast.ObjectFieldID,
		Hide:  ast.ObjectFieldHidden,
		Id:    &typeId,
		Expr2: index,
	}
}

// buildWithArrayGenericFnc helps to generate a jsonnet method more easily.
func buildWithGenericFnc(fncId, paramId ast.Identifier, op ast.Node) ast.ObjectField {
	// fncId(paramId):: self + op
	fnc := ast.Function{
		Parameters: ast.Parameters{Required: []ast.Identifier{paramId}},
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
		Method:      &fnc,
		Id:          &fncId,
		Params:      &fnc.Parameters,
		Expr2:       fnc.Body,
	}
}

// buildWithScalarFnc generates the jsonnet method that add a scalar value to
// an object field.
// JSONNET: withName(name):: self + self.mixinInstance({ name: name }
func buildWithScalarFnc(name ast.Identifier) ast.ObjectField {
	mixinInstanceFncId := ast.Identifier("mixinInstance")
	fncId := ast.Identifier("with" + strings.Title(string(name)))

	// self.mixinInstance({ name: name })
	op := &ast.Apply{
		Target: &ast.Index{
			Target: &ast.Self{},
			Id:     &mixinInstanceFncId,
		},
		Arguments: ast.Arguments{
			Positional: []ast.Node{
				// { name: name }
				&ast.Object{
					NodeBase: oneLiner,
					Fields: []ast.ObjectField{
						{Kind: ast.ObjectFieldID, Hide: ast.ObjectFieldInherit, Id: &name, Expr2: &ast.Var{Id: name}},
					},
				},
			},
		},
	}
	return buildWithGenericFnc(fncId, name, op)
}

// buildWithArrayGenericFnc helps to generates the array method more
// easily (the ast condition is too heavy to be written several times).
func buildWithArrayGenericFnc(fncId, paramId ast.Identifier, objTrue, objFalse ast.ObjectField) ast.ObjectField {
	mixinInstanceFncId := ast.Identifier("mixinInstance")
	stdId, typeFnId := ast.Identifier("std"), ast.Identifier("type")

	// if std.type(paramId) == 'array' then self.mixinInstance(objTrue) else self.mixinInstance(objFalse)
	op := &ast.Conditional{
		// std.type(paramId) == 'array'
		Cond: &ast.Binary{
			Left: &ast.Apply{
				Target:    &ast.Index{Target: &ast.Var{Id: stdId}, Id: &typeFnId},
				Arguments: ast.Arguments{Positional: []ast.Node{&ast.Var{Id: paramId}}},
			},
			Op:    ast.BopManifestEqual,
			Right: &ast.LiteralString{Value: "array"},
		},
		// self.mixinInstance(objTrue)
		BranchTrue: &ast.Apply{
			Target:    &ast.Index{Target: &ast.Self{}, Id: &mixinInstanceFncId},
			Arguments: ast.Arguments{Positional: []ast.Node{&ast.Object{NodeBase: oneLiner, Fields: []ast.ObjectField{objTrue}}}},
		},
		// self.mixinInstance(objFalse)
		BranchFalse: &ast.Apply{
			Target:    &ast.Index{Target: &ast.Self{}, Id: &mixinInstanceFncId},
			Arguments: ast.Arguments{Positional: []ast.Node{&ast.Object{NodeBase: oneLiner, Fields: []ast.ObjectField{objFalse}}}},
		},
	}
	return buildWithGenericFnc(fncId, paramId, op)
}

// buildWithArrayFnc generates the jsonnet method that add an array to an
// object field.
// JSONNET: withName(name):: self + if std.type(name) == 'array' then
// self.mixinInstance({ name: name }) else self.mixinInstance({ name: [name] }
func buildWithArrayFnc(name ast.Identifier) ast.ObjectField {
	fncId := ast.Identifier("with" + strings.Title(string(name)))

	// name: name
	objTrue := ast.ObjectField{Kind: ast.ObjectFieldID, Hide: ast.ObjectFieldInherit, Id: &name, Expr2: &ast.Var{Id: name}}
	// name: [name]
	objFalse := ast.ObjectField{Kind: ast.ObjectFieldID, Hide: ast.ObjectFieldInherit, Id: &name, Expr2: &ast.Array{Elements: []ast.Node{&ast.Var{Id: name}}}}

	return buildWithArrayGenericFnc(fncId, name, objTrue, objFalse)
}

// buildWithMixinArrayFnc generates the jsonnet method that merge an array with an
// object field.
// JSONNET: withNameMixin(name):: self + if std.type(name) == 'array' then
// self.mixinInstance({ name+: name }) else self.mixinInstance({ name+: [name] }
func buildWithMixinArrayFnc(name ast.Identifier) ast.ObjectField {
	fncId := ast.Identifier("with" + strings.Title(string(name)) + "Mixin")

	// name+: name
	objTrue := ast.ObjectField{Kind: ast.ObjectFieldID, Hide: ast.ObjectFieldInherit, SuperSugar: true, Id: &name, Expr2: &ast.Var{Id: name}}
	// name+: [name]
	objFalse := ast.ObjectField{Kind: ast.ObjectFieldID, Hide: ast.ObjectFieldInherit, SuperSugar: true, Id: &name, Expr2: &ast.Array{Elements: []ast.Node{&ast.Var{Id: name}}}}

	return buildWithArrayGenericFnc(fncId, name, objTrue, objFalse)
}

// buildLocalMixinFnc generates the jsonnet local method "__mixinName",
// common with all k8s.libsonnet objects.
// JSONNET: local __mixinName(name) = __mixinParentName({ name+: name })
// or
// JSONNET: local __mixinName(name) = { name+: name }
func buildLocalMixinFnc(name ast.Identifier, upperMethod ast.Identifier) []ast.ObjectField {
	mixinSelfFncId := ast.Identifier("__mixin" + strings.Title(string(name)))
	mixinParentFncId := ast.Identifier("__mixin" + strings.Title(string(upperMethod)))

	// { name+: name }
	var localFncBody ast.Node = &ast.Object{
		NodeBase: oneLiner,
		Fields: []ast.ObjectField{
			{Kind: ast.ObjectFieldID, Hide: ast.ObjectFieldInherit, SuperSugar: true, Id: &name, Expr2: &ast.Var{Id: name}},
		},
	}

	// If upperMethod exists, we need to call it.
	if upperMethod != emptyId {
		// __mixinParentName({ name+: name })
		localFncBody = &ast.Apply{
			Target:    &ast.Var{Id: mixinParentFncId},
			Arguments: ast.Arguments{Positional: []ast.Node{localFncBody}},
		}
	}

	localMixinFnc := ast.Function{
		Parameters: ast.Parameters{Required: []ast.Identifier{name}},
		Body:       localFncBody,
	}

	return []ast.ObjectField{
		{
			Kind: ast.ObjectLocal, Hide: ast.ObjectFieldVisible, Id: &mixinSelfFncId,
			MethodSugar: true, Method: &localMixinFnc, Params: &localMixinFnc.Parameters, Expr2: localMixinFnc.Body,
		},
	}
}

// buildSelfMixinFnc generates the jsonnet methods "mixinInstance",
// common with all k8s.libsonnet objects.
// JSONNET: mixinInstance(name) = __mixinName(name)
func buildSelfMixinFnc(name ast.Identifier) []ast.ObjectField {
	mixinInstanceFncId := ast.Identifier("mixinInstance")
	mixinSelfFncId := ast.Identifier("__mixin" + strings.Title(string(name)))

	// mixinInstance(name):: __mixinName(name)
	selfMixinFnc := ast.Function{
		Parameters: ast.Parameters{Required: []ast.Identifier{name}},
		// __mixinName(name)
		Body: &ast.Apply{
			Target:    &ast.Var{Id: mixinSelfFncId},
			Arguments: ast.Arguments{Positional: []ast.Node{&ast.Var{Id: name}}},
		},
	}

	return []ast.ObjectField{
		{
			Kind: ast.ObjectFieldID, Hide: ast.ObjectFieldHidden, Id: &mixinInstanceFncId,
			MethodSugar: true, Method: &selfMixinFnc, Params: &selfMixinFnc.Parameters, Expr2: selfMixinFnc.Body,
		},
	}
}
