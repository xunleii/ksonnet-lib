package ist

import (
	"strings"

	"github.com/google/go-jsonnet/ast"
)

var (
	oneLiner = ast.NewNodeBaseLoc(ast.LocationRange{Begin: ast.Location{Line: 1}, End: ast.Location{Line: 1}})

	mixinInstanceFncId = ast.Identifier("mixinInstance")
)

// buildComment generetes a jsonnet comment from the given value.
func buildComment(comment string) ast.ObjectField {
	return ast.ObjectField{
		Kind:  ObjectComment,
		Expr1: &Comment{Content: comment},
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
