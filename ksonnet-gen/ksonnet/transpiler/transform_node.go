package transpiler

import (
	"fmt"

	"github.com/google/go-jsonnet/ast"

	"github.com/ksonnet/ksonnet-lib/ksonnet-gen/ksonnet/transpiler/iast"
)

func transformAPINode(api *iast.APINode, spec APISpec) (*ast.Object, error) {
	switch n := api.Node.(type) {
	case *iast.Scalar:
		ctor, _ := newHiddenCtor(Ctor{})
		return &ast.Object{Fields: []ast.ObjectField{ctor}}, nil
	case *iast.Object:
		var fields, mixinFields []ast.ObjectField
		var referenceFields []string

		ctor, err := newHiddenCtor(spec.Ctor)
		if err != nil {
			return nil, err // TODO: Better error
		}
		fields = append(fields, ctor)
		fields = append(fields, newSelfMixinFnc())

		for _, field := range sortObjectFields(n.Fields) {
			if _, isReference := n.Fields[field].(*iast.Reference); isReference {
				referenceFields = append(referenceFields, field)
				continue
			}

			// generate basic fields (with*)
			innerfields, err := transformNode(n.Fields[field], field)
			if err != nil {
				return nil, err // TODO: better error management
			}

			fields = append(fields, innerfields...)
		}

		// generate mixin fields
		for _, field := range referenceFields {
			// create self link to mixin
			fields = append(fields, newAstComment(n.Fields[field].Description())...)
			fields = append(fields, newReferenceMixin(field))
			mixinFields = append(mixinFields, newAstComment(n.Fields[field].Description())...)
			mixinFields = append(
				mixinFields,
				ast.ObjectField{
					Kind: ast.ObjectFieldID, Hide: ast.ObjectFieldHidden,
					Id: newIdentifier(field), Expr2: newReferencePtr(field, n.Fields[field].(*iast.Reference).LinkedTo(), true),
				},
				ast.ObjectField{
					Kind: ast.ObjectFieldID, Hide: ast.ObjectFieldHidden,
					Id: newIdentifier(field + "Type"), Expr2: newReferencePtr(field, n.Fields[field].(*iast.Reference).LinkedTo(), false),
				},
			)
		}

		fields = append(fields, ast.ObjectField{
			Kind:  ast.ObjectFieldID,
			Hide:  ast.ObjectFieldHidden,
			Id:    newIdentifier("mixin"),
			Expr2: &ast.Object{Fields: mixinFields},
		})

		return &ast.Object{Fields: fields}, nil

	default:
		return nil, fmt.Errorf("unmanaged iast.APINode.Node type '%T'", n)
	}
}

func transformNode(node iast.Node, field string) ([]ast.ObjectField, error) {
	switch n := node.(type) {
	case *iast.Array:
		return transformArrayNode(n, field)
	case *iast.Scalar:
		return transformScalarNode(n, field)
	default:
		return nil, fmt.Errorf("unmanaged iast.Node type '%T'", node)
	}
}

func transformArrayNode(arr *iast.Array, name string) ([]ast.ObjectField, error) {
	var fields []ast.ObjectField

	fields = append(fields, newAstComment(arr.Description())...)
	fields = append(fields, newWithArrayFnc(name, true))
	fields = append(fields, newAstComment(arr.Description())...)
	fields = append(fields, newWithMixinArrayFnc(name, true))

	if ref, isRef := arr.ItemType.(*iast.Reference); isRef {
		api := ref.LinkedTo()
		if api == nil {
			return nil, fmt.Errorf("failed to transform array type of '%s': unlinked reference cannot be transformed", name)
		}

		fields = append(fields, newReferenceType(name, api))
	}
	return fields, nil
}

func transformScalarNode(scalar *iast.Scalar, name string) ([]ast.ObjectField, error) {
	return append(
		newAstComment(scalar.Description()),
		newWithScalarFnc(name, true),
	), nil
}
