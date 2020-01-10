package ist

import (
	"fmt"
	"sort"
	"strings"

	"github.com/google/go-jsonnet/ast"
)

var (
	oneLiner = ast.NewNodeBaseLoc(ast.LocationRange{Begin: ast.Location{Line: 1}, End: ast.Location{Line: 1}})

	mixinInstanceFncId = ast.Identifier("mixinInstance")
)

// sortFieldIds create a sorted list of the object field name.
// TODO: use a generic function instead (map key sort)
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
func buildRefType(name ast.Identifier, ref *Ref) ast.ObjectField {
	if ref.targetNode == nil {
		panic(fmt.Sprintf("invalid reference %s: all references must be already linked", ref.ReferenceTo))
	}

	typeId := name + "Type"
	refPath := ref.TargetNode().Definition.APIPath()

	var index ast.Node = &ast.Var{Id: "hidden"}
	if ref.TargetNode().HasTag(PublicNodeTag) {
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

// buildMixinInstanceFn generates the jsonnet method "mixinInstance", common
// with all k8s.libsonnet objects.
// JSONNET: mixinInstance(object):: super.mixinInstance({ object+: object })
func buildMixinInstanceFn(target ast.Identifier) ast.ObjectField {
	// mixinInstance(target):: super.mixinInstance({ target+: target })
	fnc := ast.Function{
		Parameters: ast.Parameters{
			Required: []ast.Identifier{target},
		},
		// super.mixinInstance({ target+: target })
		Body: &ast.Apply{
			Target: &ast.SuperIndex{Id: &mixinInstanceFncId},
			Arguments: ast.Arguments{
				Positional: []ast.Node{
					// { target+: target }
					&ast.Object{
						NodeBase: oneLiner,
						Fields: []ast.ObjectField{
							{Kind: ast.ObjectFieldID, Hide: ast.ObjectFieldInherit, SuperSugar: true, Id: &target, Expr2: &ast.Var{Id: target}},
						},
					},
				},
			},
		},
	}

	return ast.ObjectField{
		Kind:        ast.ObjectFieldID,
		Hide:        ast.ObjectFieldHidden,
		MethodSugar: true,
		Method:      &fnc,
		Id:          &mixinInstanceFncId,
		Params:      &fnc.Parameters,
		Expr2:       fnc.Body,
	}
}

// buildWithArrayGenericFn helps to generate a jsonnet method more easily.
func buildWithGenericFn(fncId, paramId ast.Identifier, op ast.Node) ast.ObjectField {
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

// buildWithScalarFn generates the jsonnet method that add a scalar value to
// an object field.
// JSONNET: withName(name):: self + self.mixinInstance({ name: name }
func buildWithScalarFn(name ast.Identifier) ast.ObjectField {
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
	return buildWithGenericFn(fncId, name, op)
}

// buildWithArrayGenericFn helps to generates the array method more
// easily (the ast condition is too heavy to be written several times).
func buildWithArrayGenericFn(fncId, paramId ast.Identifier, objTrue, objFalse ast.ObjectField) ast.ObjectField {
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
	return buildWithGenericFn(fncId, paramId, op)
}

// buildWithArrayFn generates the jsonnet method that add an array to an
// object field.
// JSONNET: withName(name):: self + if std.type(name) == 'array' then
// self.mixinInstance({ name: name }) else self.mixinInstance({ name: [name] }
func buildWithArrayFn(name ast.Identifier) ast.ObjectField {
	fncId := ast.Identifier("with" + strings.Title(string(name)))

	// name: name
	objTrue := ast.ObjectField{Kind: ast.ObjectFieldID, Hide: ast.ObjectFieldInherit, Id: &name, Expr2: &ast.Var{Id: name}}
	// name: [name]
	objFalse := ast.ObjectField{Kind: ast.ObjectFieldID, Hide: ast.ObjectFieldInherit, Id: &name, Expr2: &ast.Array{Elements: []ast.Node{&ast.Var{Id: name}}}}

	return buildWithArrayGenericFn(fncId, name, objTrue, objFalse)
}

// buildWithMixinArrayFn generates the jsonnet method that merge an array with an
// object field.
// JSONNET: withNameMixin(name):: self + if std.type(name) == 'array' then
// self.mixinInstance({ name+: name }) else self.mixinInstance({ name+: [name] }
func buildWithMixinArrayFn(name ast.Identifier) ast.ObjectField {
	fncId := ast.Identifier("with" + strings.Title(string(name)) + "Mixin")

	// name+: name
	objTrue := ast.ObjectField{Kind: ast.ObjectFieldID, Hide: ast.ObjectFieldInherit, SuperSugar: true, Id: &name, Expr2: &ast.Var{Id: name}}
	// name+: [name]
	objFalse := ast.ObjectField{Kind: ast.ObjectFieldID, Hide: ast.ObjectFieldInherit, SuperSugar: true, Id: &name, Expr2: &ast.Array{Elements: []ast.Node{&ast.Var{Id: name}}}}

	return buildWithArrayGenericFn(fncId, name, objTrue, objFalse)
}
