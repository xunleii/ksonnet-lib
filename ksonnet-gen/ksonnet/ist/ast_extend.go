package ist

import (
	"github.com/google/go-jsonnet/ast"
)

const (
	ObjectComment ast.ObjectFieldKind = iota + 0x10
)

type Comment struct {
	ast.NodeBase
	Content string
}
