package transpiler

import (
	"fmt"
	"sort"
	"strings"
	"unicode"

	"github.com/go-openapi/spec"
	"github.com/google/go-jsonnet/ast"

	"github.com/ksonnet/ksonnet-lib/ksonnet-gen/ksonnet/transpiler/iast"
)

type Ctor struct {
	Params map[string]interface{}
	Body   map[string]string
}

type APISpec struct {
	Ctor         Ctor
	RenameFields map[string]string
}

type Config struct {
	PublicAPIs []string
	publicAPIs rxRegistry

	APIsSpec map[string]APISpec

	IgnoredFields    []string
	ignoredFieldsMap rxRegistry

	BlacklistedAPIs []string
	blacklistedAPIs rxRegistry
}

// TODO(feature): Add API Node constructor (`new():: {},` by default)

func Transpile(schema *spec.Swagger, config Config) (ast.Node, error) {
	var err error

	// prepare transpiler configurations
	config.publicAPIs, err = newRxRegistry(config.PublicAPIs)
	if err != nil {
		return nil, fmt.Errorf("invalid PublicAPIs values: %w", err)
	}

	config.ignoredFieldsMap, err = newRxRegistry(config.IgnoredFields)
	if err != nil {
		return nil, fmt.Errorf("invalid IgnoredFields values: %w", err)
	}

	config.blacklistedAPIs, err = newRxRegistry(config.BlacklistedAPIs)
	if err != nil {
		return nil, fmt.Errorf("invalid BlacklistedAPIs values: %w", err)
	}

	// parse API specifications
	apis, err := parseAPISpec(schema, config)
	if err != nil {
		return nil, fmt.Errorf("failed to parse API specs: %w", err)
	}

	// resolve all public API references
	for api, node := range apis {
		// ignore hidden API
		if !config.publicAPIs.Contains(api) {
			continue
		}

		node.AddTag(iast.PublicNodeTag)
		node.AddTag(iast.ReferencedTag) // avoid referencing loop
		if err := resolveReferences(apis, node.Node); err != nil {
			return nil, fmt.Errorf("failed to resolve references of API '%s': %w", api, err)
		}
	}

	// generate public and hidden api trees by filtering, sorting and grouping
	// API Nodes by their definitions.
	publicTree, hiddenTree := iast.APITree{}, iast.APITree{}
	for _, api := range sortAPIMap(apis) {
		node := apis[api]

		// ignore unresolved API
		if !node.HasTag(iast.ReferencedTag) {
			continue
		}

		hiddenTree.AddAPI(node)
		if node.HasTag(iast.PublicNodeTag) {
			publicTree.AddAPI(node)
		}
	}

	// transform the final trees to Jsonnet AST
	jsonnetAst, err := transformAPIsTrees(publicTree, hiddenTree, config)
	if err != nil {
		return nil, fmt.Errorf("failed to transform parsed API nodes to Jsonnet AST: %w", err)
	}
	return jsonnetAst, nil
}

// resolveReferences resolves all references recursively.
func resolveReferences(apis map[string]*iast.APINode, node iast.Node) error {
	switch n := node.(type) {
	case *iast.Reference:
		api, exists := apis[n.ReferenceTo]
		if !exists {
			return fmt.Errorf("invalid reference '%s' in %s: unknown API object", n.ReferenceTo, n)
		}

		n.LinkTo(api)

		// avoid to resolve an api already resolved
		if !api.HasTag(iast.ReferencedTag) {
			api.AddTag(iast.ReferencedTag)
			return resolveReferences(apis, api.Node)
		}
	case *iast.Object:
		for _, field := range n.Fields {
			if err := resolveReferences(apis, field); err != nil {
				return err
			}
		}
	case *iast.Array:
		return resolveReferences(apis, n.ItemType)
	case *iast.Scalar:
	default:
		return fmt.Errorf("unknown node type '%T'", n)
	}
	return nil
}

type apiNodeMapping []struct {
	key  string
	node *iast.APINode
}

func (a apiNodeMapping) Len() int      { return len(a) }
func (a apiNodeMapping) Swap(i, j int) { a[i], a[j] = a[j], a[i] }
func (a apiNodeMapping) Less(i, j int) bool {
	lnode, rnode := a[i].node.Definition, a[j].node.Definition
	if lnode.Group == rnode.Group {
		if lnode.Version == rnode.Version {
			return lnode.Kind < rnode.Kind
		}
		return lnode.Version < rnode.Version
	}
	return lnode.Group < rnode.Group
}
func (a apiNodeMapping) ToAPIList() []string {
	var keys = make([]string, 0, len(a))
	for _, s := range a {
		keys = append(keys, s.key)
	}
	return keys
}

// sortAPIMap returns a list of sorted API node
func sortAPIMap(apis map[string]*iast.APINode) []string {
	var nodes = make(apiNodeMapping, 0, len(apis))
	for api, node := range apis {
		nodes = append(nodes, struct {
			key  string
			node *iast.APINode
		}{key: api, node: node})
	}

	sort.Sort(nodes)
	return nodes.ToAPIList()
}

// sortObjectFields returns a list of sorted fields
func sortObjectFields(apis map[string]iast.Node) []string {
	var keys = make([]string, 0, len(apis))
	for api := range apis {
		keys = append(keys, api)
	}

	sort.Strings(keys)
	return keys
}

func formatKind(str string) string {
	// case: already formatted
	if !unicode.IsUpper(rune(str[0])) {
		return str
	}

	if unicode.IsUpper(rune(str[1])) {
		// case: ISCSIVolumeSource -> iscsiVolumeSource
		var i int
		for i = 1; i+1 < len(str) && unicode.IsUpper(rune(str[i+1])); i++ {
		}
		return strings.ToLower(str[:i]) + str[i:]
	} else {
		// case: FlexVolumeSource -> flexVolumeSource
		return strings.ToLower(str[:1]) + str[1:]
	}
}
