package ist

import (
	"fmt"
	"path"

	"github.com/google/go-jsonnet/ast"
)

type (
	// WARN: the 8 first bits must be reserved for this package
	// (start custom tags at 0x0100)
	NodeTag uint64

	// Node represents a node in the IST. It convert a simplified API
	// node tree into a Jsonnet AST node.
	Node interface {
		fmt.Stringer

		// Base returns information common with all nodes.
		Base() NodeBase
		// AddTag adds a tag to the current node.
		AddTag(tag NodeTag)
		// HasTag returns true if the given current node as the given tag.
		HasTag(tag NodeTag) bool
		// ToObjectFields converts an ist.Node to a list of jsonnet object
		// field. This is the main function used to generate the full ast
		// from the API definition.
		ToObjectFields(id ast.Identifier) []ast.ObjectField
		// Unlink removes the existing link of a parent node.
		Unlink()
	}

	// NodeBase contains elements shared by all Node implementations.
	NodeBase struct {
		Parent  Node
		Name    string
		Comment string
		Tags    NodeTag
	}
)

const (
	PublicNodeTag NodeTag = 1 << iota
	ReferencedTag
)

func (n NodeBase) Base() NodeBase          { return n }
func (n *NodeBase) AddTag(tag NodeTag)     { n.Tags |= tag }
func (n NodeBase) HasTag(tag NodeTag) bool { return (n.Tags & tag) == tag }
func (n NodeBase) String() string          { return path.Join(n.Parent.String(), n.Name) }
func (n *NodeBase) Unlink()                { n.Parent = nil }

// Object represents an API object component. It is represented in the
// Jsonnet AST by a simple JSON object with a local method __mixinName
// and a method mixinInstance.
type Object struct {
	NodeBase
	Type   *APINode
	Fields map[string]Node
}

func (o Object) ToObjectFields(id ast.Identifier) []ast.ObjectField {
	var mixinFncs []ast.ObjectField

	// The Parent is nil when the current node is a root object (APINode or
	// first child of the mixin object).
	if o.Parent == nil {
		mixinFncs = buildLocalMixinFnc(id, "")
	} else {
		mixinFncs = buildLocalMixinFnc(id, ast.Identifier(o.Parent.Base().Name))
	}

	mixinFncs = append(mixinFncs, buildSelfMixinFnc(id)...)

	var innerFields []ast.ObjectField
	for _, fieldId := range sortFieldIds(o) {
		innerFields = append(innerFields, o.Fields[fieldId].ToObjectFields(ast.Identifier(fieldId))...)
	}

	return []ast.ObjectField{
		buildComment(o.Comment),
		{
			Kind:  ast.ObjectFieldID,
			Hide:  ast.ObjectFieldHidden,
			Id:    &id,
			Expr2: &ast.Object{Fields: append(mixinFncs, innerFields...)},
		},
		buildRefType(id, o.Type),
	}

}

// Array represents an API array component. It is represented in the
// Jsonnet AST by two functions (with... and with...Mixin) and the
// type if ItemType is not scalar.
type Array struct {
	NodeBase
	ItemType Node
}

func (a Array) ToObjectFields(id ast.Identifier) []ast.ObjectField {
	fields := []ast.ObjectField{
		buildComment(a.Comment),
		buildWithArrayFnc(id),
		buildComment(a.Comment),
		buildWithMixinArrayFnc(id),
	}

	if _, isRef := a.ItemType.(*Ref); isRef {
		fields = append(fields, buildRefType(id, nil))
	}
	return fields
}

type (
	// Scalar represents all component that are not Object nor Array.
	// It is represented in the Jsonnet AST by a function starting
	// with `with...`.
	Scalar struct {
		NodeBase
	}
)

func (s Scalar) ToObjectFields(id ast.Identifier) []ast.ObjectField {
	return []ast.ObjectField{
		buildComment(s.Comment),
		buildWithScalarFnc(id),
	}
}
