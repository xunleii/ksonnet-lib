package ksonnet

import (
	"fmt"
	"sort"
	"strings"

	"github.com/go-openapi/spec"

	"github.com/ksonnet/ksonnet-lib/ksonnet-gen/ksonnet/ist"
)

// apiDefinitionFromApiName creates an APIDefinition based on the API fullname.
func apiDefinitionFromApiName(fullname string) ist.APIDefinition {
	var def ist.APIDefinition

	apiObj := sort.StringSlice(strings.Split(fullname, "."))
	switch len(apiObj) {
	case 0, 1, 2, 3, 4:
		// Unknown... ignored
	case 5:
		// io.k8s.api.GROUP.KIND
		def.Kind = apiObj[4]
		def.Group = apiObj[3]
	default:
		// io.k8s.api(...).GROUP.VERSION.KIND
		def.Kind = apiObj[len(apiObj)-1]
		def.Version = apiObj[len(apiObj)-2]
		def.Group = apiObj[len(apiObj)-3]
	}
	return def
}

// apiNodeFromSchema creates an APINode based on its Kubernetes API schema.
func apiNodeFromSchema(fullname string, schema *spec.Schema) (*ist.APINode, error) {
	definition := apiDefinitionFromApiName(fullname)

	nodeName := definition.Kind
	if nodeName == "" {
		apiNameParts := strings.Split(fullname, ".")
		if len(apiNameParts) == 0 {
			return nil, fmt.Errorf("invalid API object name '%s'", fullname)
		}
		nodeName = apiNameParts[len(apiNameParts)-1]
	}

	node, err := nodeBuilderFactory(schema.Type)(nodeName, (*spec.Schema)(schema), nil)
	if err != nil {
		return nil, err
	}

	return &ist.APINode{Definition: definition, Node: node}, nil
}
