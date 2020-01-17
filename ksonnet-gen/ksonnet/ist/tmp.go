package ist

import (
	"github.com/google/go-jsonnet/ast"
)

func (o Object) ToJsonnetAst() ast.Node {
	return &ast.Object{
		Fields: o.ToObjectFields(ast.Identifier(o.Name)),
	}
}

func (r Ref) ToJsonnetAst() ast.Node {
	//switch n := r.targetNode.(type) {
	//case *Object:
	//	return Object{
	//		NodeBase: NodeBase{
	//			Parent:  r.Parent,
	//			Name:    r.Name,
	//			Comment: r.Comment,
	//			Tags:    n.Tags,
	//		},
	//		Fields: n.Fields,
	//	}.ToJsonnetAst()
	//case *Array:
	//	return Array{
	//		NodeBase: NodeBase{
	//			Parent:  r.Parent,
	//			Name:    r.Name,
	//			Comment: r.Comment,
	//			Tags:    n.Tags,
	//		},
	//		ItemType: n.ItemType,
	//	}.ToJsonnetAst()
	//case *Scalar:
	//	return Scalar{
	//		NodeBase: NodeBase{
	//			Parent:  r.Parent,
	//			Name:    r.Name,
	//			Comment: r.Comment,
	//			Tags:    n.Tags,
	//		},
	//		Type: n.Type,
	//	}.ToJsonnetAst()
	//case *Ref:
	//	return n.ToJsonnetAst()
	//default:
	//	panic(fmt.Sprintf("invalid ist.Node implementation: unknown %T type", r.targetNode))
	//}
	return nil
}
