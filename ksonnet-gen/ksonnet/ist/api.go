package ist

import (
	"fmt"

	"github.com/google/go-jsonnet/ast"
)

var (
	ignoredFields = map[string]interface{}{"kind": nil, "apiVersion": nil}
)

type (
	// APIDefinition contains elements common with all "root" API object
	// (like Deployment, Statefulset, Node, etc...).
	APIDefinition struct {
		Group   string
		Version string
		Kind    string
	}

	// APINode represents a "root" API object (like Deployment, Statefulset,
	// Node, etc...). It is represented in the Jsonnet AST by a Json object
	// with a constructor and sometimes a `mixin` object containing
	// referenced fields.
	APINode struct {
		Definition APIDefinition
		Node
	}
)

func (d APIDefinition) APIPath() []string {
	if d.Version == "" {
		return []string{d.Group, d.Kind}
	}
	return []string{d.Group, d.Version, d.Kind}
}

func (api APINode) ToObject() *ast.Object {
	// TODO: manage constructor here
	switch n := api.Node.(type) {
	case *Object:
		return fromObjectToAst(api.Definition, n)
	default:
		panic(fmt.Sprintf("APINode %s not managed currently: not handled type %T", api, n))
	}
}

func fromObjectToAst(api APIDefinition, obj *Object) *ast.Object {
	kindId := ast.Identifier("kind")
	mixinId := ast.Identifier("mixin")

	var objectFields []ast.ObjectField
	for _, field := range sortFieldIds(*obj) {
		if _, ignored := ignoredFields[field]; ignored {
			continue
		}

		fieldId := ast.Identifier(field)
		fieldNode := obj.Fields[field]

		// because the current node (API Node) is not considered as
		// a "true" ist.Node, we need to remove the link between
		// the later and its field.
		fieldNode.Unlink()

		objectFields = append(objectFields, obj.Fields[field].ToObjectFields(fieldId)...)
	}

	return &ast.Object{
		Fields: []ast.ObjectField{
			{
				Kind: ast.ObjectLocal,
				Hide: ast.ObjectFieldHidden,
				Id:   &kindId,
				Expr2: &ast.Object{
					NodeBase: oneLiner,
					Fields: []ast.ObjectField{
						{
							Kind: ast.ObjectFieldID,
							Hide: ast.ObjectFieldInherit,
							Id:   &kindId,
							Expr2: &ast.LiteralString{
								Value: api.Kind,
							},
						},
					},
				},
			},
			{
				Kind:  ast.ObjectFieldID,
				Hide:  ast.ObjectFieldHidden,
				Id:    &mixinId,
				Expr2: &ast.Object{Fields: objectFields},
			},
		},
	}
}
