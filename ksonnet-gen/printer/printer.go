package printer

import (
	"bytes"

	"github.com/google/go-jsonnet/ast"
)

type astPrinter struct {
	Config
	output bytes.Buffer
}

func (printer *astPrinter) print(node ast.Node) error {
	if node == nil {
		return nil
	}

	switch _ := node.(type) {
	case *ast.Object:
	case *ast.Local:
	case *ast.ArrayComp, *ast.ObjectComp:
		// TODO: ignore theses types (not required to generates API)
	}
}
