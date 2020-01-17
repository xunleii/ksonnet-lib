// Package iast declares the types used to represent the Intermediate Abstract Syntax Trees. This IAST is used to
// converts the Swapper 2 API definition into a Jsonnet AST.
package iast

import (
	"fmt"
	"path"
	"regexp"
)

// WARN: the 8 first bits must be reserved for this package
// (start custom tags at 0x0100)
type NodeTag uint64

const (
	PublicNodeTag NodeTag = 1 << iota
	ReferencedTag
)

type (
	// All node types implement this interface.
	Node interface {
		fmt.Stringer

		// Name returns the node name
		Name() string
		// Description returns the API description of the node. It is used
		// to add comments in the Jsonnet library.
		Description() string

		// Parent returns the parent node, which can be nil if it is
		// an orphan node.
		Parent() Node

		// AddTag adds a tag to the current node.
		AddTag(tag NodeTag)
		// HasTag returns true if the given current node as the given tag.
		HasTag(tag NodeTag) bool
	}

	// Object represents an API object component.
	Object struct {
		NodeBase
		Fields map[string]Node
	}

	// Array represents an API array component.
	Array struct {
		NodeBase
		ItemType Node
	}

	// Reference represents a reference to an API object.
	Reference struct {
		NodeBase
		ReferenceTo string
		link        *APINode
	}

	// Scalar represents all component that are not Object nor Array.
	Scalar struct{ NodeBase }

	// NodeBase contains elements shared by all Node implementations.
	NodeBase struct {
		name        string
		description string
		parent      Node
		tags        NodeTag
	}
)

func NewNodeBase(name, description string, parent Node) NodeBase {
	return NodeBase{name: name, description: description, parent: parent}
}

func (n NodeBase) Name() string            { return n.name }
func (n NodeBase) Description() string     { return n.description }
func (n NodeBase) Parent() Node            { return n.parent }
func (n *NodeBase) AddTag(tag NodeTag)     { n.tags |= tag }
func (n NodeBase) HasTag(tag NodeTag) bool { return (n.tags & tag) == tag }
func (n NodeBase) String() string {
	if n.parent == nil {
		return ""
	}
	return path.Join(n.parent.String(), n.name)
}

// LinkTo adds the referenced api pointer to the current instances, in order
// to easily access after tree resolution.
func (r *Reference) LinkTo(api *APINode) { r.link = api }

// LinkedTo returns the referenced API node pointer.
func (r Reference) LinkedTo() *APINode { return r.link }

var (
	rxApiValues = regexp.MustCompile(`(?:(?P<group>\w+)\.(?P<version>v\d+(?:(?:alpha|beta)\d+)?)\.(?P<kind>\w+)$)|(?:(?P<group_spe>\w+)\.(?P<kind_spe>\w+)$)`)
)

const (
	_ int = iota
	rxIdGroup
	rxIdVersion
	rxIdKind
	rxIdGroupSpe
	rxIdKindSpe
)
