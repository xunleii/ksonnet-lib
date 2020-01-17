package ist

import (
	"fmt"

	"github.com/google/go-jsonnet/ast"
)

// Ref represents an API object reference.
type Ref struct {
	NodeBase
	ReferenceTo string
}

// ResolveNode returns a copy of the referenced node
// with base information of the actual node.
func (r *Ref) ResolveNode(nodes map[string]*APINode) (Node, error) {
	apiNode, exists := nodes[r.ReferenceTo]
	if !exists {
		return nil, fmt.Errorf("failed to resolve reference %s: unknown APINode '%s'", r.Name, r.ReferenceTo)
	}

	// we add this tag in order to known which node API is required to use
	// the current reference, even if it is not a public object.
	apiNode.AddTag(ReferencedTag)

	base := NodeBase{
		Parent:  r.Parent,
		Name:    apiNode.Base().Name,
		Comment: apiNode.Base().Comment,
		Tags:    apiNode.Base().Tags,
	}

	switch n := apiNode.Node.(type) {
	case *Object:
		return &Object{NodeBase: base, Fields: n.Fields}, nil
	case *Array:
		return &Array{NodeBase: base, ItemType: n.ItemType}, nil
	case *Scalar:
		return &Scalar{NodeBase: base}, nil
	case *Ref:
		return n.ResolveNode(nodes)
	default:
		panic(fmt.Sprintf("impossible to resolve %s: unknown reference type %T", r.Name, n))
	}
}

func (r Ref) ToObjectFields(id ast.Identifier) []ast.ObjectField {
	panic("ist.Ref.ToObjectFields must not be used")
}
