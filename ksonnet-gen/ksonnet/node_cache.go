package ksonnet

import (
	"fmt"

	"github.com/ksonnet/ksonnet-lib/ksonnet-gen/ksonnet/ist"
)

type istNodeCache map[string]*ist.APINode

// WhitelistAPI keep all cached nodes (and their linked references) listed
// in apiWhitelist. It removes all unnecessary nodes in order to lightweight
// the Jsonnet library.
func (cache istNodeCache) WhitelistAPI(apiWhitelist []string) (istNodeCache, error) {
	whitelistedCache := istNodeCache{}

	for _, api := range apiWhitelist {
		if _, exists := cache[api]; !exists {
			return nil, fmt.Errorf("failed to whitelist API '%s': unknown API Node", api)
		}

		cache[api].AddTag(ist.PublicNodeTag)
		cache[api].AddTag(ist.ReferencedTag)
		if err := cache.markAsWhitelisted(cache[api]); err != nil {
			return nil, fmt.Errorf("failed to whitelist '%s': %w", api, err)
		}
	}

	for api, node := range cache {
		if node.HasTag(ist.ReferencedTag) {
			whitelistedCache[api] = node
		}
	}
	return whitelistedCache, nil
}

// markAsWhitelisted tag an ist.APINode and all of their references with
// the ReferencedTag tag.
func (cache istNodeCache) markAsWhitelisted(node ist.Node) error {
	switch n := node.(type) {
	case *ist.Ref:
		cached, exists := cache[n.ReferenceTo]
		if !exists {
			return fmt.Errorf("invalid reference '%s' in %s: unknown API Node", n.ReferenceTo, n)
		}

		//n.ResolveNode(cached)

		if !cached.HasTag(ist.ReferencedTag) {
			cached.AddTag(ist.ReferencedTag)
			return cache.markAsWhitelisted(cached)
		}
	case *ist.APINode:
		return cache.markAsWhitelisted(n.Node)
	case *ist.Object:
		for _, field := range n.Fields {
			if err := cache.markAsWhitelisted(field); err != nil {
				return err
			}
		}
	case *ist.Array:
		return cache.markAsWhitelisted(n.ItemType)
	}
	return nil
}
