package transpiler

import (
	"fmt"
	"strconv"
	"strings"

	"github.com/google/go-jsonnet/ast"
)

func defaultCtor(ctor *Ctor) {
	if ctor.Params == nil {
		ctor.Params = map[string]interface{}{}
	}
	if ctor.Body == nil {
		ctor.Body = map[string]string{}
	}
}

func newCtor(ctor Ctor, body ast.Node) ast.ObjectField {
	fncCtor := &ast.Function{
		Parameters: newCtorParams(ctor),
		Body:       body,
	}

	return ast.ObjectField{
		Kind:   ast.ObjectFieldID,
		Hide:   ast.ObjectFieldHidden,
		Id:     newIdentifier("new"),
		Method: fncCtor,
		Params: &fncCtor.Parameters,
		Expr2:  fncCtor.Body,
	}
}

func newPublicCtor(ctor Ctor) ast.ObjectField {
	defaultCtor(&ctor)

	apiVersionVar := &ast.Var{Id: ast.Identifier("apiVersion")}
	kindVar := &ast.Var{Id: ast.Identifier("kind")}

	var newArguments []ast.Node
	for name := range ctor.Params {
		newArguments = append(newArguments, &ast.Var{Id: ast.Identifier(name)})
	}

	superNew := &ast.Apply{
		Target: &ast.SuperIndex{Id: newIdentifier("new")},
		Arguments: ast.Arguments{
			Positional: newArguments,
		},
	}

	bodyCtor := &ast.Binary{
		Left: apiVersionVar,
		Op:   ast.BopPlus,
		Right: &ast.Binary{
			Left:  kindVar,
			Op:    ast.BopPlus,
			Right: superNew,
		},
	}

	return newCtor(ctor, bodyCtor)
}

func newHiddenCtor(ctor Ctor) (ast.ObjectField, error) {
	defaultCtor(&ctor)

	bodyCtor, err := newCtorBody(ctor)
	if err != nil {
		return ast.ObjectField{}, fmt.Errorf("failed to create constructor body: %w", err)
	}

	return newCtor(ctor, bodyCtor), nil
}

func newCtorParams(ctor Ctor) ast.Parameters {
	var params ast.Parameters
	for name, value := range ctor.Params {
		if value == nil {
			params.Required = append(params.Required, ast.Identifier(name))
			continue
		}

		var defaultValue ast.Node
		switch v := value.(type) {
		case int:
			defaultValue = &ast.LiteralNumber{Value: float64(v), OriginalString: strconv.Itoa(v)}
		case float64:
			defaultValue = &ast.LiteralNumber{Value: v, OriginalString: strconv.Itoa(int(v))}
		case string:
			defaultValue = &ast.LiteralString{Value: v}
		case bool:
			defaultValue = &ast.LiteralBoolean{Value: v}
		default:
			defaultValue = &ast.LiteralNull{}
		}

		params.Optional = append(params.Optional, ast.NamedParameter{Name: ast.Identifier(name), DefaultArg: defaultValue})
	}

	return params
}

func newCtorBody(ctor Ctor) (ast.Node, error) {
	if len(ctor.Body) == 0 {
		return &ast.Object{}, nil
	}

	var bodyCtor ast.Node
	for apply, arg := range ctor.Body {
		if _, exists := ctor.Params[arg]; !exists {
			return nil, fmt.Errorf("unknown paramter '%s' used in '%s'", arg, apply)
		}

		keys := strings.Split(apply, ".")
		if len(keys) == 0 {
			return nil, fmt.Errorf("constructor body must contain a method")
		}

		var target ast.Node = &ast.Self{}
		for _, key := range keys {
			target = &ast.Index{Target: target, Id: newIdentifier(key)}
		}

		applyCtor := &ast.Apply{
			Target:        target,
			Arguments:     ast.Arguments{Positional: []ast.Node{&ast.Var{Id: ast.Identifier(arg)}}},
			TrailingComma: false,
			TailStrict:    false,
		}

		if bodyCtor == nil {
			bodyCtor = applyCtor
		} else {
			bodyCtor = &ast.Binary{
				Left:  applyCtor,
				Op:    ast.BopPlus,
				Right: bodyCtor,
			}
		}
	}

	return bodyCtor, nil
}
