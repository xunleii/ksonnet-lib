package transpiler

import (
	"path"

	"github.com/google/go-jsonnet/ast"

	"github.com/ksonnet/ksonnet-lib/ksonnet-gen/ksonnet/transpiler/iast"
)

// TODO: put this directly in Transpile
func transformAPIsTrees(publicTree, definitionTree iast.APITree, config Config) (ast.Node, error) {
	// TODO: Needs the __ksonnet / __kubernetes object

	publicAPIFields, err := transformPublicTree(publicTree, config)
	if err != nil {
		return nil, err
	}

	definitionAPIObject, err := transformHiddenTree(definitionTree, config)
	if err != nil {
		return nil, err
	}

	return &ast.Object{
		Fields: append(
			publicAPIFields,
			ast.ObjectField{
				Kind:  ast.ObjectLocal,
				Hide:  ast.ObjectFieldVisible,
				Id:    newIdentifier("definition"),
				Expr2: definitionAPIObject,
			},
		),
		TrailingComma: true,
	}, nil
}

// transformPublicTree create all fields accessible by the end user of the
// jsonnet library. It uses a reference to the right hidden object and add
// the kind & apiVersion to the constructor.
func transformPublicTree(publicTree iast.APITree, config Config) ([]ast.ObjectField, error) {
	var fields []ast.ObjectField

	for _, group := range publicTree.Groups {
		var groupFields []ast.ObjectField
		for _, version := range group.Versions {
			// add local apiVersion field
			// JSONNET: local apiVersion = { apiVersion: groupName+"/"+versionName },
			localApiVersion := ast.ObjectField{
				Kind: ast.ObjectLocal,
				Hide: ast.ObjectFieldHidden,
				Id:   newIdentifier("apiVersion"),
				Expr2: &ast.Object{
					NodeBase: inlineObject,
					Fields: []ast.ObjectField{
						{
							Kind: ast.ObjectFieldID, Hide: ast.ObjectFieldInherit,
							Id:    newIdentifier("apiVersion"),
							Expr2: &ast.LiteralString{Value: path.Join(group.Name, version.Name)},
						},
					},
				},
			}

			versionFields := []ast.ObjectField{localApiVersion}
			for _, kind := range version.APIs {
				apiKind := formatKind(kind.Definition.Kind)

				// add local kind field
				// JSONNET: local kind = { kind: apiName },
				localKind := ast.ObjectField{
					Kind: ast.ObjectLocal,
					Hide: ast.ObjectFieldHidden,
					Id:   newIdentifier("kind"),
					Expr2: &ast.Object{
						NodeBase: inlineObject,
						Fields: []ast.ObjectField{
							{
								Kind: ast.ObjectFieldID, Hide: ast.ObjectFieldInherit,
								Id:    newIdentifier("kind"),
								Expr2: &ast.LiteralString{Value: kind.Definition.Kind},
							},
						},
					},
				}

				ctor := newPublicCtor(config.APIsSpec[kind.Definition.Fullname].Ctor)

				fields := append(
					newAstComment(kind.Description),
					ast.ObjectField{
						Kind: ast.ObjectFieldID,
						Hide: ast.ObjectFieldHidden,
						Id:   newIdentifier(apiKind),
						Expr2: &ast.Binary{
							Left:  newReferencePtr(apiKind, kind, false),
							Op:    ast.BopPlus,
							Right: &ast.Object{Fields: []ast.ObjectField{localKind, ctor}},
						},
					},
				)

				versionFields = append(versionFields, fields...)
			}

			groupFields = append(
				groupFields,
				ast.ObjectField{
					Kind:  ast.ObjectFieldID,
					Hide:  ast.ObjectFieldHidden,
					Id:    newIdentifier(version.Name),
					Expr2: &ast.Object{Fields: versionFields},
				},
			)
		}

		fields = append(
			fields,
			ast.ObjectField{
				Kind:  ast.ObjectFieldID,
				Hide:  ast.ObjectFieldHidden,
				Id:    newIdentifier(group.Name),
				Expr2: &ast.Object{Fields: groupFields},
			},
		)
	}

	return fields, nil
}

func transformHiddenTree(hiddenTree iast.APITree, config Config) (*ast.Object, error) {
	var fields []ast.ObjectField

	for _, group := range hiddenTree.Groups {
		var groupFields []ast.ObjectField
		for _, version := range group.Versions {
			var versionFields []ast.ObjectField
			for _, kind := range version.APIs {
				apiKind := formatKind(kind.Definition.Kind)
				objFields, err := transformAPINode(kind, config.APIsSpec[kind.Definition.Fullname])
				if err != nil {
					return nil, err // TODO: Better error management
				}

				fnc := &ast.Function{
					Parameters: ast.Parameters{Required: []ast.Identifier{"mixinInstance"}},
					Body:       objFields,
				}

				fields := append(
					newAstComment(kind.Description),
					ast.ObjectField{
						Kind:   ast.ObjectFieldID,
						Hide:   ast.ObjectFieldHidden,
						Method: fnc,
						Id:     newIdentifier(apiKind),
						Params: &fnc.Parameters,
						Expr2:  fnc.Body,
					},
				)

				versionFields = append(versionFields, fields...)
			}

			groupFields = append(
				groupFields,
				ast.ObjectField{
					Kind:  ast.ObjectFieldID,
					Hide:  ast.ObjectFieldHidden,
					Id:    newIdentifier(version.Name),
					Expr2: &ast.Object{Fields: versionFields},
				},
			)
		}

		fields = append(
			fields,
			ast.ObjectField{
				Kind:  ast.ObjectFieldID,
				Hide:  ast.ObjectFieldHidden,
				Id:    newIdentifier(group.Name),
				Expr2: &ast.Object{Fields: groupFields},
			},
		)
	}

	return &ast.Object{Fields: fields}, nil
}
