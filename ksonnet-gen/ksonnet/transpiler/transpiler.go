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

type Config struct {
	PublicAPIs       []string
	IgnoredFields    []string
	ignoredFieldsMap map[string]struct{}
}

// TODO(perf): generation tooks too much RAM to creates the Jsonnet AST
// TODO(bug): API object function mustn't use self.mixinInstance (not exists). Example: gcePersistentDiskVolumeSource.withFsType
// TODO(bug): local kind mustn't be used in hidden API object
// TODO(bug): ref in API object are not in mixin object. Example: flexVolume.secretRef
// TODO(bug): ref need refType field. Example: flexVolume.secretRef
// TODO(bug): ignore mixinFnc if there is no mixin object
// TODO(bug): mixin must contain only object
// TODO(feature): Add field filtering
// TODO(feature): Use references on non object API must be use as inner field
// TODO(feature): Add API Node constructor (`new():: {},` by default)

func Transpile(schema *spec.Swagger, config Config) (ast.Node, error) {
	sort.Strings(config.PublicAPIs)
	config.ignoredFieldsMap = stringSliceToMap(config.IgnoredFields)

	apis, err := parseAPISpec(schema, config)
	if err != nil {
		return nil, fmt.Errorf("failed to parse API specs: %w", err)
	}

	// tag all public apis
	for _, api := range config.PublicAPIs {
		if node, exist := apis[api]; exist {
			node.AddTag(iast.PublicNodeTag)
		} else {
			return nil, fmt.Errorf("failed to tag API '%s': unknown API object", api)
		}
	}

	// resolve all public API references
	for api, node := range apis {
		// ignore hidden API
		if !node.HasTag(iast.PublicNodeTag) {
			continue
		}

		node.AddTag(iast.ReferencedTag) // avoid referencing loop
		if err := resolveReferences(apis, node.Node); err != nil {
			return nil, fmt.Errorf("failed to resolve references of API '%s': %w", api, err)
		}
	}

	// generate public and hidden api trees by filtering, sorting and grouping
	// API Nodes by their definitions.
	publicAPITree, hiddenAPITree := iast.APITree{}, iast.APITree{}
	for _, api := range sortAPIMapKeys(apis) {
		node := apis[api]

		// ignore unresolved API
		if !node.HasTag(iast.ReferencedTag) {
			continue
		}

		// add the API object in the right tree
		group, version := node.Definition.Group, node.Definition.Version
		tree := hiddenAPITree
		if node.HasTag(iast.PublicNodeTag) {
			tree = publicAPITree
		}

		if tree[group] == nil {
			tree[group] = &iast.APIGroup{
				Name:     group,
				Versions: map[string]*iast.APIVersion{},
			}
		}

		if tree[group].Versions[version] == nil {
			tree[group].Versions[version] = &iast.APIVersion{
				Parent: tree[group],
				Name:   version,
				APIs:   map[string]*iast.APINode{},
			}
		}

		tree[group].Versions[version].APIs[api] = node
	}

	// transform the final trees to Jsonnet AST
	jsonnetAst, err := transformAPIsTrees(publicAPITree, hiddenAPITree, config)
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

// sortAPIMapKeys returns a list of sorted keys
func sortAPIMapKeys(apis map[string]*iast.APINode) []string {
	var keys = make([]string, 0, len(apis))
	for api := range apis {
		keys = append(keys, api)
	}

	sort.Strings(keys)
	return keys
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

func stringSliceToMap(arr []string) map[string]struct{} {
	smap := map[string]struct{}{}
	for _, str := range arr {
		smap[str] = struct{}{}
	}
	return smap
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
