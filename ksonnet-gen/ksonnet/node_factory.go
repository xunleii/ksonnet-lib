package ksonnet

import (
	"fmt"
	"strings"

	"github.com/go-openapi/spec"

	"github.com/ksonnet/ksonnet-lib/ksonnet-gen/ksonnet/ist"
)

func init() {
	istNodeBuilderMap = map[string]istNodeBuilder{
		"boolean": scalarNodeBuilder,
		"integer": scalarNodeBuilder,
		"number":  scalarNodeBuilder,
		"string":  scalarNodeBuilder,
		"array":   arrayNodeBuilder,
		"object":  objectNodeBuilder,
	}
}

// istNodeBuilder build a create a correct ist.Node, according to the given schema.
type istNodeBuilder func(name string, schema *spec.Schema, parent ist.Node) (ist.Node, error)

// nodeBuilderFactory return the right istNodeBuilder to be used according
// the given type.
func nodeBuilderFactory(t spec.StringOrArray) istNodeBuilder {
	// t == nil when the object refers to another API object
	if t == nil {
		return refNodeBuilder
	}

	specType := []string(t)
	if len(specType) == 0 {
		return dummyNodeBuilder
	}

	builder, exists := istNodeBuilderMap[specType[0]]
	if !exists {
		return func(string, *spec.Schema, ist.Node) (node ist.Node, err error) {
			return nil, fmt.Errorf("unknown schema.Type '%s'", specType[0])
		}
	}
	return builder
}

var (
	dummyNodeBuilder  istNodeBuilder = func(string, *spec.Schema, ist.Node) (ist.Node, error) { return nil, nil }
	istNodeBuilderMap                = map[string]istNodeBuilder{}
)

// refNodeStringer converts a spec.Ref to an usable string.
type refNodeStringer spec.Ref

func (r refNodeStringer) String() string {
	if r.GetPointer() == nil {
		return ""
	}

	parts := strings.Split(r.GetPointer().String(), "/")
	return parts[len(parts)-1]
}

// refNodeBuilder creates an ist.Ref node, a reference link to
// another node.
func refNodeBuilder(name string, schema *spec.Schema, parent ist.Node) (ist.Node, error) {
	return &ist.Ref{
		NodeBase: ist.NodeBase{
			Parent:  parent,
			Name:    name,
			Comment: schema.Description,
		},
		ReferenceTo: refNodeStringer(schema.Ref).String(),
	}, nil
}

// objectNodeBuilder creates an ist.Object node from a schema object.
func objectNodeBuilder(name string, schema *spec.Schema, parent ist.Node) (ist.Node, error) {
	// object without properties must be managed as a scalar type
	if len(schema.Properties) == 0 {
		return scalarNodeBuilder(name, schema, parent)
	}

	node := &ist.Object{
		NodeBase: ist.NodeBase{
			Parent:  parent,
			Name:    name,
			Comment: schema.Description,
		},
		Fields: map[string]ist.Node{},
	}

	for key, prop := range schema.Properties {
		fieldNode, err := nodeBuilderFactory(prop.Type)(key, &prop, node)
		if err != nil {
			return nil, fmt.Errorf("failed to create node field '%s' of %s: %w", key, name, err)
		}

		node.Fields[key] = fieldNode
	}

	return node, nil
}

// arrayNodeBuilder creates an ist.Array node from a schema array.
// WARN: An array must have only one item type.
func arrayNodeBuilder(name string, schema *spec.Schema, parent ist.Node) (ist.Node, error) {
	if schema.Items.Len() != 1 {
		return nil, fmt.Errorf("invalid array '%s': it must contains one and only one inner type", name)
	}

	node := &ist.Array{
		NodeBase: ist.NodeBase{
			Parent:  parent,
			Name:    name,
			Comment: schema.Description,
		},
	}

	var err error
	node.ItemType, err = nodeBuilderFactory(schema.Items.Schema.Type)("::inner::", schema.Items.Schema, node)
	if err != nil {
		return nil, err
	}

	return node, nil
}

// scalarNodeBuilder creates an ist.Scalar node, representing a node
// other than object, ref or array.
func scalarNodeBuilder(name string, schema *spec.Schema, parent ist.Node) (node ist.Node, err error) {
	return &ist.Scalar{
		NodeBase: ist.NodeBase{
			Parent:  parent,
			Name:    name,
			Comment: schema.Description,
		},
	}, nil
}
