package printer

import "bytes"

type astPrinter struct {
	Config
	output bytes.Buffer
}

