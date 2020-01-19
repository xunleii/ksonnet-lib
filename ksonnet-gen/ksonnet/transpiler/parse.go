package transpiler

import (
	"fmt"
	"strings"

	"github.com/go-openapi/spec"

	"github.com/ksonnet/ksonnet-lib/ksonnet-gen/ksonnet/transpiler/iast"
)

// parseAPISpec extracts all API specification of the Swagger object and returns
// a list of iast.APINode, which can be translated into a Jsonnet ast.
func parseAPISpec(spec *spec.Swagger, config Config) (map[string]*iast.APINode, error) {
	if spec == nil {
		return nil, fmt.Errorf("spec.Swagger provided cannot be nil")
	}

	var apis = map[string]*iast.APINode{}
	for api, schema := range spec.SwaggerProps.Definitions {
		definition, err := iast.APIDefinitionFromAPIName(api)
		if err != nil {
			return nil, fmt.Errorf("failed to parse API object '%s': %w", api, err)
		}

		var node iast.Node
		if config.blacklistedAPIs.Contains(api) {
			// blacklisted API is used as scalar type in order to avoid
			// breaking dependencies.
			node = parseScalarSchema("", &schema, nil)
		} else {
			node, err = parseSchema("", &schema, nil, config, config.APIsSpec[api])
			if err != nil {
				return nil, fmt.Errorf("failed to parse API object '%s': %w", api, err)
			}
		}

		apis[api] = &iast.APINode{Definition: definition, Description: schema.Description, Node: node}
	}

	return apis, nil
}

// parseSchema converts an API schema to an iast.Node, according
// to the schema type.
func parseSchema(name string, schema *spec.Schema, parent iast.Node, config Config, spec APISpec) (iast.Node, error) {
	if schema.Type == nil {
		// schema.Type is nil and schema.Ref.HasFragmentOnly == true is valid
		// when schema is a reference
		if schema.Ref.HasFragmentOnly == true {
			return parseReferenceSchema(name, schema, parent)
		}

		// in this case, we manage the unknown schema as scalar object
		// (generally JSON properties)
		return parseScalarSchema(name, schema, parent), nil
	}

	if len(schema.Type) == 0 {
		return nil, fmt.Errorf("failed to build node '%s': no schema.Type provided", name)
	}

	switch schema.Type[0] {
	case "object":
		return parseObjectSchema(name, schema, parent, config, spec)
	case "array":
		return parseArraySchema(name, schema, parent, config, spec)
	case "boolean", "integer", "number", "string":
		return parseScalarSchema(name, schema, parent), nil
	default:
		return nil, fmt.Errorf("failed to build node '%s': unknown schema.Type '%s'", name, schema.Type[0])
	}
}

// parseObjectSchema creates an iast.Object node from a schema object.
func parseObjectSchema(name string, schema *spec.Schema, parent iast.Node, config Config, spec APISpec) (iast.Node, error) {
	// object without properties must be managed as a scalar type
	if len(schema.Properties) == 0 {
		return parseScalarSchema(name, schema, parent), nil
	}

	node := &iast.Object{
		NodeBase: iast.NewNodeBase(name, schema.Description, parent),
		Fields:   map[string]iast.Node{},
	}

	for key, prop := range schema.Properties {
		// ignore if the key must be ignored
		if config.ignoredFieldsMap.Contains(key) {
			continue
		}

		if renameWith := spec.RenameFields[key]; renameWith != "" {
			key = renameWith
		}

		field, err := parseSchema(key, &prop, node, config, spec)
		if err != nil {
			return nil, fmt.Errorf("failed to create node field '%s' of %s: %w", key, name, err)
		}

		node.Fields[key] = field
	}

	return node, nil
}

// parseArraySchema creates an iast.Array node from a schema array.
// WARN: An array must have only one item type.
func parseArraySchema(name string, schema *spec.Schema, parent iast.Node, config Config, spec APISpec) (iast.Node, error) {
	if schema.Items.Len() != 1 {
		return nil, fmt.Errorf("invalid array '%s': it must contains one and only one inner type", name)
	}

	var err error
	innerType, err := parseSchema("", schema.Items.Schema, nil, config, spec)
	if err != nil {
		return nil, err
	}

	return &iast.Array{
		NodeBase: iast.NewNodeBase(name, schema.Description, parent),
		ItemType: innerType,
	}, nil
}

// parseScalarSchema creates an ist.Scalar node, representing a node
// other than object, reference or array.
func parseScalarSchema(name string, schema *spec.Schema, parent iast.Node) (node iast.Node) {
	return &iast.Scalar{
		NodeBase: iast.NewNodeBase(name, schema.Description, parent),
	}
}

// parseReferenceSchema creates an ist.Ref node, a reference link to
// another node.
func parseReferenceSchema(name string, schema *spec.Schema, parent iast.Node) (iast.Node, error) {
	var reference string
	if schema.Ref.GetPointer() != nil {
		parts := strings.Split(schema.Ref.GetPointer().String(), "/")
		reference = parts[len(parts)-1]
	}

	// if there is no type and no reference, we manage is has scalar type
	if reference == "" {
		return &iast.Scalar{NodeBase: iast.NewNodeBase(name, schema.Description, parent)}, nil
	}

	return &iast.Reference{
		NodeBase:    iast.NewNodeBase(name, schema.Description, parent),
		ReferenceTo: reference,
	}, nil
}
