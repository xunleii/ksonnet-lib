package printer

import (
	"io"

	"github.com/google/go-jsonnet/ast"
	"github.com/pkg/errors"
)

// IndentMode is the indent mode for Config.
type IndentMode int

const (
	// IndentModeSpace indents with spaces.
	IndentModeSpace IndentMode = iota
	// IndentModeTab indents with tabs.
	IndentModeTab
)

// Config is a configuration for the old_printer.
type Config struct {
	IndentSize  int
	IndentMode  IndentMode
	PadArrays   bool
	PadObjects  bool
	SortImports bool
}

// DefaultConfig is a default configuration.
var DefaultConfig = Config{
	IndentSize:  2,
	IndentMode:  IndentModeSpace,
	PadArrays:   false,
	PadObjects:  true,
	SortImports: true,
}

// Fprint prints a node to the supplied writer using the default
// configuration.
func Fprint(output io.Writer, node ast.Node) error {
	return DefaultConfig.Fprint(output, node)
}

// Fprint prints a node to the supplied writer.
func (c *Config) Fprint(output io.Writer, node ast.Node) error {
	p := old_printer{cfg: *c}

	p.print(node)

	if p.err != nil {
		return errors.Wrap(p.err, "output")
	}

	_, err := output.Write(p.output)
	return err
}
