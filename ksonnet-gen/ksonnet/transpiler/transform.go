package transpiler

import (
	"fmt"
	"path"

	"github.com/google/go-jsonnet/ast"

	"github.com/ksonnet/ksonnet-lib/ksonnet-gen/ksonnet/transpiler/iast"
)

var (
	ignoredFields = map[string]interface{}{"kind": nil, "apiVersion": nil}
)

func transformAPIsTrees(publicAPITree, hiddenAPITree iast.APITree, config Config) (ast.Node, error) {
	// TODO: Needs the __ksonnet object

	publicObject, err := transformAPITree(publicAPITree, config)
	if err != nil {
		return nil, err
	}

	hiddenObject, err := transformAPITree(hiddenAPITree, config)
	if err != nil {
		return nil, err
	}

	rootObjectFields := append(
		publicObject.Fields,
		ast.ObjectField{
			Kind:  ast.ObjectLocal,
			Hide:  ast.ObjectFieldVisible,
			Id:    newIdentifier("hidden"),
			Expr2: hiddenObject,
		},
	)

	return &ast.Object{
		Fields:        rootObjectFields,
		TrailingComma: true,
	}, nil
}

func transformAPITree(tree iast.APITree, config Config) (*ast.Object, error) {
	groups := make([]ast.ObjectField, 0, len(tree))

	for group, groupNode := range tree {
		groupObj, err := transformAPIGroup(groupNode, config)
		if err != nil {
			return nil, err
		}

		groups = append(
			groups,
			ast.ObjectField{
				Kind:  ast.ObjectFieldID,
				Hide:  ast.ObjectFieldHidden,
				Id:    newIdentifier(group),
				Expr2: groupObj,
			},
		)
	}

	return &ast.Object{Fields: groups}, nil
}

func transformAPIGroup(group *iast.APIGroup, config Config) (*ast.Object, error) {
	versions := make([]ast.ObjectField, 0, len(group.Versions))

	for version, versionNode := range group.Versions {
		versionObj, err := transformAPIVersion(versionNode, config)
		if err != nil {
			return nil, err
		}

		// the version name is empty when the API URL is GROUP.KIND
		// (like resource.Quantity). To manage this issue, we
		// ignore the Version object.
		if version == "" {
			// versionObj = append(versionObj, version...)
			continue
		}

		versions = append(
			versions,
			ast.ObjectField{
				Kind:  ast.ObjectFieldID,
				Hide:  ast.ObjectFieldHidden,
				Id:    newIdentifier(version),
				Expr2: versionObj,
			},
		)
	}

	return &ast.Object{Fields: versions}, nil
}

func transformAPIVersion(version *iast.APIVersion, config Config) (*ast.Object, error) {
	apis := make([]ast.ObjectField, 0, len(version.APIs)+1)

	// add local apiVersion field
	// JSONNET: local apiVersion = { "apiVersion": groupName+"/"+versionName },
	apiVersion := path.Join(version.Parent.Name, version.Name)
	if version.Parent.Name == "core" {
		apiVersion = version.Name
	}
	apis = append(
		apis,
		ast.ObjectField{
			Kind: ast.ObjectLocal,
			Hide: ast.ObjectFieldVisible,
			Id:   newIdentifier("apiVersion"),
			Expr2: &ast.Object{
				NodeBase: inlineObject,
				Fields: []ast.ObjectField{
					{
						Kind:  ast.ObjectFieldID,
						Hide:  ast.ObjectFieldInherit,
						Id:    newIdentifier("apiVersion"),
						Expr2: &ast.LiteralString{Value: apiVersion},
					},
				},
				TrailingComma: false,
			},
		},
	)

	for _, apiNode := range version.APIs {
		kindObj, err := transformAPINode(apiNode, config)
		if err != nil {
			return nil, err
		}

		apis = append(apis, newAstComment(apiNode.Description)...)
		apis = append(
			apis,
			ast.ObjectField{
				Kind:  ast.ObjectFieldID,
				Hide:  ast.ObjectFieldHidden,
				Id:    newIdentifier(formatKind(apiNode.Definition.Kind)),
				Expr2: kindObj,
			},
		)
	}

	return &ast.Object{Fields: apis}, nil
}

func transformAPINode(api *iast.APINode, config Config) (*ast.Object, error) {
	// TODO: Manage constructor here
	switch n := api.Node.(type) {
	case *iast.Object:
		var objectFields []ast.ObjectField
		var mixinObjectFields []ast.ObjectField

		objectFields = append(
			objectFields,
			// local kind = { "kind": kindName },
			ast.ObjectField{
				Kind: ast.ObjectLocal, Hide: ast.ObjectFieldHidden, Id: newIdentifier("kind"),
				Expr2: &ast.Object{
					NodeBase: inlineObject,
					Fields: []ast.ObjectField{
						{
							Kind: ast.ObjectFieldID, Hide: ast.ObjectFieldInherit,
							Id: newIdentifier("kind"), Expr2: &ast.LiteralString{Value: api.Definition.Kind},
						},
					},
				},
			})

		for _, field := range sortObjectFields(n.Fields) {
			if _, ignored := ignoredFields[field]; ignored {
				continue
			}

			innerFields, err := transformNode(n.Fields[field], field)
			if err != nil {
				return nil, err // TODO: Manage this error
			}

			switch n.Fields[field].(type) {
			case *iast.Object, *iast.Reference:
				mixinObjectFields = append(mixinObjectFields, innerFields...)
			case *iast.Array, *iast.Scalar:
				objectFields = append(objectFields, innerFields...)
			}
		}

		objectFields = append(
			objectFields,
			// mixin:: {...}
			ast.ObjectField{
				Kind: ast.ObjectFieldID, Hide: ast.ObjectFieldHidden,
				Id: newIdentifier("mixin"), Expr2: &ast.Object{Fields: mixinObjectFields},
			},
		)

		return &ast.Object{Fields: objectFields}, nil
	case *iast.Scalar: // ignore scalar API node
	default:
		panic(fmt.Sprintf("APINode %s not managed currently: not handled type %T", api.Definition, n))
	}

	return &ast.Object{}, nil
}

func transformNode(node iast.Node, field string) ([]ast.ObjectField, error) {
	switch n := node.(type) {
	case *iast.Object:
		return transformObjectNode(n, field)
	case *iast.Array:
		return transformArrayNode(n, field)
	case *iast.Scalar:
		return transformScalarNode(n, field)
	case *iast.Reference:
		return transformReferenceNode(n, field)
	default:
		return nil, fmt.Errorf("unknown iast.Node type '%T'", node)
	}
}

func transformObjectNode(obj *iast.Object, name string) ([]ast.ObjectField, error) {
	var mixinFncs []ast.ObjectField

	// The Parent is nil when the current node is a root object (APINode or
	// first child of the mixin object).
	if obj.Parent() == nil {
		mixinFncs = newLocalMixinFnc(name, "")
	} else {
		mixinFncs = newLocalMixinFnc(name, obj.Parent().Name())
	}

	mixinFncs = append(mixinFncs, newSelfMixinFnc(name)...)

	var objectFields []ast.ObjectField
	for _, field := range sortObjectFields(obj.Fields) {
		innerFields, err := transformNode(obj.Fields[field], field)
		if err != nil {
			return nil, err // TODO: Manage this error
		}

		objectFields = append(objectFields, innerFields...)
	}

	return append(
		newAstComment(obj.Description()),
		ast.ObjectField{
			Kind:
			ast.ObjectFieldID, Hide: ast.ObjectFieldHidden,
			Id:                      newIdentifier(name), Expr2: &ast.Object{Fields: append(mixinFncs, objectFields...)},
		},
		//newReferenceType(name, obj.),
	), nil
}

func transformArrayNode(arr *iast.Array, name string) ([]ast.ObjectField, error) {
	var fields []ast.ObjectField

	fields = append(fields, newAstComment(arr.Description())...)
	fields = append(fields, newWithArrayFnc(name))
	fields = append(fields, newAstComment(arr.Description())...)
	fields = append(fields, newWithMixinArrayFnc(name))

	if ref, isRef := arr.ItemType.(*iast.Reference); isRef {
		api := ref.LinkedTo()
		if api == nil {
			return nil, fmt.Errorf("failed to transform array type of '%s': unlinked reference cannot be transformed", name)
		}

		fields = append(fields, newReferenceType(name, api))
	}
	return fields, nil
}

func transformScalarNode(scalar *iast.Scalar, name string) ([]ast.ObjectField, error) {
	return append(
		newAstComment(scalar.Description()),
		newWithScalarFnc(name),
	), nil
}

func transformReferenceNode(ref *iast.Reference, name string) ([]ast.ObjectField, error) {
	api := ref.LinkedTo()
	if api == nil {
		return nil, fmt.Errorf("failed to transform reference '%s' to '%s': unlinked reference cannot be transformed", name, ref.ReferenceTo)
	}

	switch n := api.Node.(type) {
	case *iast.Object:
		return transformObjectNode(&iast.Object{
			NodeBase: iast.NewNodeBase(name, ref.Description(), ref.Parent()),
			Fields:   n.Fields,
		}, name)
	case *iast.Array:
		return transformArrayNode(&iast.Array{
			NodeBase: iast.NewNodeBase(name, ref.Description(), ref.Parent()),
			ItemType: n.ItemType,
		}, name)
	case *iast.Scalar:
		return transformScalarNode(&iast.Scalar{
			NodeBase: iast.NewNodeBase(name, ref.Description(), ref.Parent()),
		}, name)
	case *iast.Reference:
		nref := &iast.Reference{
			NodeBase:    iast.NewNodeBase(name, ref.Description(), ref.Parent()),
			ReferenceTo: n.ReferenceTo,
		}
		nref.LinkTo(n.LinkedTo())

		return transformReferenceNode(nref, name)
	default:
		return nil, fmt.Errorf("unknown iast.Node type '%T'", api.Node)
	}
}
