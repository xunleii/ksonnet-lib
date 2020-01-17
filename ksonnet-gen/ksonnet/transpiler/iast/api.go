package iast

import "fmt"

type (
	// APITree is a specific node representing a collection of API Groups.
	APITree map[string]*APIGroup

	// APIVersion is a specific node representing a collection of API Versions
	// grouped by the same Group.
	APIGroup struct {
		Name     string
		Versions map[string]*APIVersion
	}

	// APIVersion is a specific node representing a collection of API APIs
	// grouped by the same Group and Version.
	APIVersion struct {
		Parent *APIGroup
		Name   string
		APIs   map[string]*APINode
	}

	// APINode is a wrapper extending the Node type in order to add some
	// information about the API Object, like its kind or group.
	APINode struct {
		Parent      *APIVersion
		Definition  APIDefinition
		Description string
		Node        Node
		tags        NodeTag
	}

	// APIDefinition contains elements common with all API Object
	// (like Deployment, Statefulset, Node, etc...).
	APIDefinition struct {
		Group   string
		Version string
		Kind    string
	}
)

// APIDefinitionFromAPIName creates an APIDefinition based on the API fullname.
func APIDefinitionFromAPIName(fullname string) (APIDefinition, error) {
	submatch := rxApiValues.FindStringSubmatch(fullname)
	if len(submatch) == 0 {
		return APIDefinition{}, fmt.Errorf("invalid API object '%s': must match the regex '%s'", fullname, rxApiValues)
	}

	if submatch[rxIdGroup] != "" {
		return APIDefinition{
			Group:   submatch[rxIdGroup],
			Version: submatch[rxIdVersion],
			Kind:    submatch[rxIdKind],
		}, nil
	} else {
		return APIDefinition{
			Group:   "core",
			Version: submatch[rxIdGroupSpe],
			Kind:    submatch[rxIdKindSpe],
		}, nil
	}
}

// AddTag adds a tag to the current node.
func (n *APINode) AddTag(tag NodeTag) { n.tags |= tag }

// HasTag returns true if the given current node as the given tag.
func (n APINode) HasTag(tag NodeTag) bool { return (n.tags & tag) == tag }
