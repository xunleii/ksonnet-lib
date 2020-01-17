package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"

	"github.com/go-openapi/spec"
	"github.com/google/go-jsonnet/parser"

	"github.com/ksonnet/ksonnet-lib/ksonnet-gen/ksonnet"
	"github.com/ksonnet/ksonnet-lib/ksonnet-gen/printer"
)

func genAst() {
	//file, _ := ioutil.ReadFile("expected.libsonnet")
	file, _ := ioutil.ReadFile("k8s.libsonnet")
	//file, _ := ioutil.ReadFile("mixinInstance.jsonnet")

	tokens, _ := parser.Lex("", string(file))
	node, _ := parser.Parse(tokens)

	var buf bytes.Buffer
	_ = printer.Fprint(&buf, node)
	fmt.Println(buf.String())
}

func emit() {
	file, _ := ioutil.ReadFile("swagger.json")

	var fullSpec spec.Swagger
	err := json.Unmarshal(file, &fullSpec)

	limitedSpec := spec.Swagger{
		SwaggerProps: spec.SwaggerProps{
			ID:          fullSpec.ID,
			Info:        fullSpec.Info,
			Definitions: fullSpec.Definitions,
			Tags:        fullSpec.Tags,
		},
	}

	_ = limitedSpec
	sha := ""
	_, _, err = ksonnet.Emit(&limitedSpec, &sha, &sha)

	if err != nil {
		fmt.Fprintln(os.Stderr, err)
	} else {
		//fmt.Println(k8s.String())
	}
}

func main() {
	//genAst()
	emit()
}
