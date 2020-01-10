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

		AddTag(tag NodeTag)
		HasTag(tag NodeTag) bool
		ToObjectFields(id ast.Identifier) []ast.ObjectField
	}

	// NodeBase contains elements shared by all Node implementations.
	NodeBase struct {
		Parent  Node
		Name    string
		Comment string
		Tags    NodeTag
	}
)

func (n *NodeBase) AddTag(tag NodeTag)     { n.Tags |= tag }
func (n NodeBase) HasTag(tag NodeTag) bool { return (n.Tags & tag) == tag }
func (n NodeBase) String() string          { return path.Join(n.Parent.String(), n.Name) }

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

func (o APINode) ToObjectFields(ast.Identifier) []ast.ObjectField { panic("implement me") }

// Object represents an API object component. It is represented in the
// Jsonnet AST by a simple JSON object.
type Object struct {
	NodeBase
	Fields map[string]Node
}

func (o Object) ToObjectFields(ast.Identifier) []ast.ObjectField { panic("implement me") }

// Array represents an API array component. It is represented in the
// Jsonnet AST by two functions (with... and with...Mixin) and the
// type if ItemType is not scalar.
type Array struct {
	NodeBase
	ItemType Node
}

func (a Array) ToObjectFields(ast.Identifier) []ast.ObjectField { panic("implement me") }

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
		buildWithScalarFn(id),
	}
}

// Ref represents an API object reference.
type Ref struct {
	NodeBase
	ReferenceTo string

	targetNode Node
}

func (r *Ref) ReferenceTargetNode(target *APINode) { r.targetNode = target.Node }
func (r Ref) TargetNode() Node                     { return r.targetNode }

func (r Ref) ToObjectFields(ast.Identifier) []ast.ObjectField { panic("implement me") }
