module github.com/ksonnet/ksonnet-lib/ksonnet-gen

go 1.13

require (
	github.com/blang/semver v3.5.1+incompatible
	github.com/go-openapi/spec v0.19.5
	github.com/go-openapi/swag v0.19.6
	github.com/google/go-jsonnet v0.10.0
	github.com/google/go-jsonnet-latest v0.0.0-00010101000000-000000000000
	github.com/pkg/errors v0.8.1
	github.com/stretchr/testify v1.3.0
)

replace github.com/google/go-jsonnet-latest => github.com/google/go-jsonnet v0.14.0
