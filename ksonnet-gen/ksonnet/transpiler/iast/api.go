package iast

import "fmt"

type (
	// APITree is a specific node representing a collection of API Groups.
	APITree struct {
		Groups   []*APIGroup
		groupIdx map[string]int
	}

	// APIVersion is a specific node representing a collection of API Versions
	// grouped by the same Group.
	APIGroup struct {
		Name       string
		Versions   []*APIVersion
		versionIdx map[string]int
	}

	// APIVersion is a specific node representing a collection of API APIs
	// grouped by the same Group and Version.
	APIVersion struct {
		Name string
		APIs []*APINode
	}

	// APINode is a wrapper extending the Node type in order to add some
	// information about the API Object, like its kind or group.
	APINode struct {
		Definition  APIDefinition
		Description string
		Node        Node
		tags        NodeTag
	}

	// APIDefinition contains elements common with all API Object
	// (like Deployment, Statefulset, Node, etc...).
	APIDefinition struct {
		Fullname string
		Group    string
		Version  string
		Kind     string
	}
)

func (tree *APITree) AddAPI(node *APINode) {
	group, version := node.Definition.Group, node.Definition.Version
	if tree.groupIdx == nil {
		tree.groupIdx = map[string]int{}
	}

	if _, exists := tree.groupIdx[group]; !exists {
		tree.groupIdx[group] = len(tree.Groups)
		tree.Groups = append(
			tree.Groups,
			&APIGroup{
				Name:       group,
				versionIdx: map[string]int{},
			},
		)
	}
	groupTree := tree.Groups[tree.groupIdx[group]]

	if _, exists := groupTree.versionIdx[version]; !exists {
		groupTree.versionIdx[version] = len(groupTree.Versions)
		groupTree.Versions = append(
			groupTree.Versions,
			&APIVersion{
				Name: version,
			},
		)
	}
	versionTree := groupTree.Versions[groupTree.versionIdx[version]]
	versionTree.APIs = append(versionTree.APIs, node)
}

// APIDefinitionFromAPIName creates an APIDefinition based on the API fullname.
func APIDefinitionFromAPIName(fullname string) (APIDefinition, error) {
	submatch := rxApiValues.FindStringSubmatch(fullname)
	if len(submatch) == 0 {
		return APIDefinition{}, fmt.Errorf("invalid API object '%s': must match the regex '%s'", fullname, rxApiValues)
	}

	if submatch[rxIdGroup] != "" {
		return APIDefinition{
			Fullname: fullname,
			Group:    submatch[rxIdGroup],
			Version:  submatch[rxIdVersion],
			Kind:     submatch[rxIdKind],
		}, nil
	} else {
		return APIDefinition{
			Fullname: fullname,
			Group:    "core",
			Version:  submatch[rxIdGroupSpe],
			Kind:     submatch[rxIdKindSpe],
		}, nil
	}
}

// AddTag adds a tag to the current node.
func (n *APINode) AddTag(tag NodeTag) { n.tags |= tag }

// HasTag returns true if the given current node as the given tag.
func (n APINode) HasTag(tag NodeTag) bool { return (n.tags & tag) == tag }
