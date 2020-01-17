{
  core:: {
    v1:: {
      local apiVersion = { apiVersion: 'v1' },
      // Pod is a collection of containers that can run on a host. This resource is created by clients and scheduled onto hosts.
      pod:: {
        local kind = { kind: 'Pod' },
        mixin:: {
          // Standard object's metadata. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata
          metadata:: {
            local __mixinMetadata(metadata) = { metadata+: metadata },
            mixinInstance(metadata):: __mixinMetadata(metadata),
            // Annotations is an unstructured key value map stored with a resource that may be set by external tools to store and retrieve arbitrary metadata. They are not queryable and should be preserved when modifying objects. More info: http://kubernetes.io/docs/user-guide/annotations
            withAnnotations(annotations):: self + self.mixinInstance({ annotations: annotations }),
            // The name of the cluster which the object belongs to. This is used to distinguish resources with same name and namespace in different clusters. This field is not set anywhere right now and apiserver is going to ignore it if set in create or update request.
            withClusterName(clusterName):: self + self.mixinInstance({ clusterName: clusterName }),
            // CreationTimestamp is a timestamp representing the server time when this object was created. It is not guaranteed to be set in happens-before order across separate operations. Clients may not set this value. It is represented in RFC3339 form and is in UTC.
            //
            // Populated by the system. Read-only. Null for lists. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata
            withCreationTimestamp(creationTimestamp):: self + self.mixinInstance({ creationTimestamp: creationTimestamp }),
            // Number of seconds allowed for this object to gracefully terminate before it will be removed from the system. Only set when deletionTimestamp is also set. May only be shortened. Read-only.
            withDeletionGracePeriodSeconds(deletionGracePeriodSeconds):: self + self.mixinInstance({ deletionGracePeriodSeconds: deletionGracePeriodSeconds }),
            // DeletionTimestamp is RFC 3339 date and time at which this resource will be deleted. This field is set by the server when a graceful deletion is requested by the user, and is not directly settable by a client. The resource is expected to be deleted (no longer visible from resource lists, and not reachable by name) after the time in this field, once the finalizers list is empty. As long as the finalizers list contains items, deletion is blocked. Once the deletionTimestamp is set, this value may not be unset or be set further into the future, although it may be shortened or the resource may be deleted prior to this time. For example, a user may request that a pod is deleted in 30 seconds. The Kubelet will react by sending a graceful termination signal to the containers in the pod. After that 30 seconds, the Kubelet will send a hard termination signal (SIGKILL) to the container and after cleanup, remove the pod from the API. In the presence of network partitions, this object may still exist after this timestamp, until an administrator or automated process can determine the resource is fully terminated. If not set, graceful deletion of the object has not been requested.
            //
            // Populated by the system when a graceful deletion is requested. Read-only. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata
            withDeletionTimestamp(deletionTimestamp):: self + self.mixinInstance({ deletionTimestamp: deletionTimestamp }),
            // Must be empty before the object is deleted from the registry. Each entry is an identifier for the responsible component that will remove the entry from the list. If the deletionTimestamp of the object is non-nil, entries in this list can only be removed. Finalizers may be processed and removed in any order.  Order is NOT enforced because it introduces significant risk of stuck finalizers. finalizers is a shared field, any actor with permission can reorder it. If the finalizer list is processed in order, then this can lead to a situation in which the component responsible for the first finalizer in the list is waiting for a signal (field value, external system, or other) produced by a component responsible for a finalizer later in the list, resulting in a deadlock. Without enforced ordering finalizers are free to order amongst themselves and are not vulnerable to ordering changes in the list.
            withFinalizers(finalizers):: self + if std.type(finalizers) == 'array' then self.mixinInstance({ finalizers: finalizers }) else self.mixinInstance({ finalizers: [finalizers] }),
            // Must be empty before the object is deleted from the registry. Each entry is an identifier for the responsible component that will remove the entry from the list. If the deletionTimestamp of the object is non-nil, entries in this list can only be removed. Finalizers may be processed and removed in any order.  Order is NOT enforced because it introduces significant risk of stuck finalizers. finalizers is a shared field, any actor with permission can reorder it. If the finalizer list is processed in order, then this can lead to a situation in which the component responsible for the first finalizer in the list is waiting for a signal (field value, external system, or other) produced by a component responsible for a finalizer later in the list, resulting in a deadlock. Without enforced ordering finalizers are free to order amongst themselves and are not vulnerable to ordering changes in the list.
            withFinalizersMixin(finalizers):: self + if std.type(finalizers) == 'array' then self.mixinInstance({ finalizers+: finalizers }) else self.mixinInstance({ finalizers+: [finalizers] }),
            // GenerateName is an optional prefix, used by the server, to generate a unique name ONLY IF the Name field has not been provided. If this field is used, the name returned to the client will be different than the name passed. This value will also be combined with a unique suffix. The provided value has the same validation rules as the Name field, and may be truncated by the length of the suffix required to make the value unique on the server.
            //
            // If this field is specified and the generated name exists, the server will NOT return a 409 - instead, it will either return 201 Created or 500 with Reason ServerTimeout indicating a unique name could not be found in the time allotted, and the client should retry (optionally after the time indicated in the Retry-After header).
            //
            // Applied only if Name is not specified. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#idempotency
            withGenerateName(generateName):: self + self.mixinInstance({ generateName: generateName }),
            // A sequence number representing a specific generation of the desired state. Populated by the system. Read-only.
            withGeneration(generation):: self + self.mixinInstance({ generation: generation }),
            // Map of string keys and values that can be used to organize and categorize (scope and select) objects. May match selectors of replication controllers and services. More info: http://kubernetes.io/docs/user-guide/labels
            withLabels(labels):: self + self.mixinInstance({ labels: labels }),
            // ManagedFields maps workflow-id and version to the set of fields that are managed by that workflow. This is mostly for internal housekeeping, and users typically shouldn't need to set or understand this field. A workflow can be the user's name, a controller's name, or the name of a specific apply path like "ci-cd". The set of fields is always in the version that the workflow used when modifying the object.
            withManagedFields(managedFields):: self + if std.type(managedFields) == 'array' then self.mixinInstance({ managedFields: managedFields }) else self.mixinInstance({ managedFields: [managedFields] }),
            // ManagedFields maps workflow-id and version to the set of fields that are managed by that workflow. This is mostly for internal housekeeping, and users typically shouldn't need to set or understand this field. A workflow can be the user's name, a controller's name, or the name of a specific apply path like "ci-cd". The set of fields is always in the version that the workflow used when modifying the object.
            withManagedFieldsMixin(managedFields):: self + if std.type(managedFields) == 'array' then self.mixinInstance({ managedFields+: managedFields }) else self.mixinInstance({ managedFields+: [managedFields] }),
            managedFieldsType:: hidden.meta.v1.ManagedFieldsEntry,
            // Name must be unique within a namespace. Is required when creating resources, although some resources may allow a client to request the generation of an appropriate name automatically. Name is primarily intended for creation idempotence and configuration definition. Cannot be updated. More info: http://kubernetes.io/docs/user-guide/identifiers#names
            withName(name):: self + self.mixinInstance({ name: name }),
            // Namespace defines the space within each name must be unique. An empty namespace is equivalent to the "default" namespace, but "default" is the canonical representation. Not all objects are required to be scoped to a namespace - the value of this field for those objects will be empty.
            //
            // Must be a DNS_LABEL. Cannot be updated. More info: http://kubernetes.io/docs/user-guide/namespaces
            withNamespace(namespace):: self + self.mixinInstance({ namespace: namespace }),
            // List of objects depended by this object. If ALL objects in the list have been deleted, this object will be garbage collected. If this object is managed by a controller, then an entry in this list will point to this controller, with the controller field set to true. There cannot be more than one managing controller.
            withOwnerReferences(ownerReferences):: self + if std.type(ownerReferences) == 'array' then self.mixinInstance({ ownerReferences: ownerReferences }) else self.mixinInstance({ ownerReferences: [ownerReferences] }),
            // List of objects depended by this object. If ALL objects in the list have been deleted, this object will be garbage collected. If this object is managed by a controller, then an entry in this list will point to this controller, with the controller field set to true. There cannot be more than one managing controller.
            withOwnerReferencesMixin(ownerReferences):: self + if std.type(ownerReferences) == 'array' then self.mixinInstance({ ownerReferences+: ownerReferences }) else self.mixinInstance({ ownerReferences+: [ownerReferences] }),
            ownerReferencesType:: hidden.meta.v1.OwnerReference,
            // An opaque value that represents the internal version of this object that can be used by clients to determine when objects have changed. May be used for optimistic concurrency, change detection, and the watch operation on a resource or set of resources. Clients must treat these values as opaque and passed unmodified back to the server. They may only be valid for a particular resource or set of resources.
            //
            // Populated by the system. Read-only. Value must be treated as opaque by clients and . More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#concurrency-control-and-consistency
            withResourceVersion(resourceVersion):: self + self.mixinInstance({ resourceVersion: resourceVersion }),
            // SelfLink is a URL representing this object. Populated by the system. Read-only.
            //
            // DEPRECATED Kubernetes will stop propagating this field in 1.20 release and the field is planned to be removed in 1.21 release.
            withSelfLink(selfLink):: self + self.mixinInstance({ selfLink: selfLink }),
            // UID is the unique in time and space value for this object. It is typically generated by the server on successful creation of a resource and is not allowed to change on PUT operations.
            //
            // Populated by the system. Read-only. More info: http://kubernetes.io/docs/user-guide/identifiers#uids
            withUid(uid):: self + self.mixinInstance({ uid: uid }),
          },
          // Specification of the desired behavior of the pod. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#spec-and-status
          spec:: {
            local __mixinSpec(spec) = { spec+: spec },
            mixinInstance(spec):: __mixinSpec(spec),
            // Optional duration in seconds the pod may be active on the node relative to StartTime before the system will actively try to mark it failed and kill associated containers. Value must be a positive integer.
            withActiveDeadlineSeconds(activeDeadlineSeconds):: self + self.mixinInstance({ activeDeadlineSeconds: activeDeadlineSeconds }),
            // If specified, the pod's scheduling constraints
            affinity:: {
              local __mixinAffinity(affinity) = { affinity+: affinity },
              mixinInstance(affinity):: __mixinAffinity(affinity),
              // Describes node affinity scheduling rules for the pod.
              nodeAffinity:: {
                local __mixinNodeAffinity(nodeAffinity) = { nodeAffinity+: nodeAffinity },
                mixinInstance(nodeAffinity):: __mixinNodeAffinity(nodeAffinity),
                // The scheduler will prefer to schedule pods to nodes that satisfy the affinity expressions specified by this field, but it may choose a node that violates one or more of the expressions. The node that is most preferred is the one with the greatest sum of weights, i.e. for each node that meets all of the scheduling requirements (resource request, requiredDuringScheduling affinity expressions, etc.), compute a sum by iterating through the elements of this field and adding "weight" to the sum if the node matches the corresponding matchExpressions; the node(s) with the highest sum are the most preferred.
                withPreferredDuringSchedulingIgnoredDuringExecution(preferredDuringSchedulingIgnoredDuringExecution):: self + if std.type(preferredDuringSchedulingIgnoredDuringExecution) == 'array' then self.mixinInstance({ preferredDuringSchedulingIgnoredDuringExecution: preferredDuringSchedulingIgnoredDuringExecution }) else self.mixinInstance({ preferredDuringSchedulingIgnoredDuringExecution: [preferredDuringSchedulingIgnoredDuringExecution] }),
                // The scheduler will prefer to schedule pods to nodes that satisfy the affinity expressions specified by this field, but it may choose a node that violates one or more of the expressions. The node that is most preferred is the one with the greatest sum of weights, i.e. for each node that meets all of the scheduling requirements (resource request, requiredDuringScheduling affinity expressions, etc.), compute a sum by iterating through the elements of this field and adding "weight" to the sum if the node matches the corresponding matchExpressions; the node(s) with the highest sum are the most preferred.
                withPreferredDuringSchedulingIgnoredDuringExecutionMixin(preferredDuringSchedulingIgnoredDuringExecution):: self + if std.type(preferredDuringSchedulingIgnoredDuringExecution) == 'array' then self.mixinInstance({ preferredDuringSchedulingIgnoredDuringExecution+: preferredDuringSchedulingIgnoredDuringExecution }) else self.mixinInstance({ preferredDuringSchedulingIgnoredDuringExecution+: [preferredDuringSchedulingIgnoredDuringExecution] }),
                preferredDuringSchedulingIgnoredDuringExecutionType:: hidden.v1.PreferredSchedulingTerm,
                // If the affinity requirements specified by this field are not met at scheduling time, the pod will not be scheduled onto the node. If the affinity requirements specified by this field cease to be met at some point during pod execution (e.g. due to an update), the system may or may not try to eventually evict the pod from its node.
                requiredDuringSchedulingIgnoredDuringExecution:: {
                  local __mixinRequiredDuringSchedulingIgnoredDuringExecution(requiredDuringSchedulingIgnoredDuringExecution) = { requiredDuringSchedulingIgnoredDuringExecution+: requiredDuringSchedulingIgnoredDuringExecution },
                  mixinInstance(requiredDuringSchedulingIgnoredDuringExecution):: __mixinRequiredDuringSchedulingIgnoredDuringExecution(requiredDuringSchedulingIgnoredDuringExecution),
                  // Required. A list of node selector terms. The terms are ORed.
                  withNodeSelectorTerms(nodeSelectorTerms):: self + if std.type(nodeSelectorTerms) == 'array' then self.mixinInstance({ nodeSelectorTerms: nodeSelectorTerms }) else self.mixinInstance({ nodeSelectorTerms: [nodeSelectorTerms] }),
                  // Required. A list of node selector terms. The terms are ORed.
                  withNodeSelectorTermsMixin(nodeSelectorTerms):: self + if std.type(nodeSelectorTerms) == 'array' then self.mixinInstance({ nodeSelectorTerms+: nodeSelectorTerms }) else self.mixinInstance({ nodeSelectorTerms+: [nodeSelectorTerms] }),
                  nodeSelectorTermsType:: hidden.v1.NodeSelectorTerm,
                },
              },
              // Describes pod affinity scheduling rules (e.g. co-locate this pod in the same node, zone, etc. as some other pod(s)).
              podAffinity:: {
                local __mixinPodAffinity(podAffinity) = { podAffinity+: podAffinity },
                mixinInstance(podAffinity):: __mixinPodAffinity(podAffinity),
                // The scheduler will prefer to schedule pods to nodes that satisfy the affinity expressions specified by this field, but it may choose a node that violates one or more of the expressions. The node that is most preferred is the one with the greatest sum of weights, i.e. for each node that meets all of the scheduling requirements (resource request, requiredDuringScheduling affinity expressions, etc.), compute a sum by iterating through the elements of this field and adding "weight" to the sum if the node has pods which matches the corresponding podAffinityTerm; the node(s) with the highest sum are the most preferred.
                withPreferredDuringSchedulingIgnoredDuringExecution(preferredDuringSchedulingIgnoredDuringExecution):: self + if std.type(preferredDuringSchedulingIgnoredDuringExecution) == 'array' then self.mixinInstance({ preferredDuringSchedulingIgnoredDuringExecution: preferredDuringSchedulingIgnoredDuringExecution }) else self.mixinInstance({ preferredDuringSchedulingIgnoredDuringExecution: [preferredDuringSchedulingIgnoredDuringExecution] }),
                // The scheduler will prefer to schedule pods to nodes that satisfy the affinity expressions specified by this field, but it may choose a node that violates one or more of the expressions. The node that is most preferred is the one with the greatest sum of weights, i.e. for each node that meets all of the scheduling requirements (resource request, requiredDuringScheduling affinity expressions, etc.), compute a sum by iterating through the elements of this field and adding "weight" to the sum if the node has pods which matches the corresponding podAffinityTerm; the node(s) with the highest sum are the most preferred.
                withPreferredDuringSchedulingIgnoredDuringExecutionMixin(preferredDuringSchedulingIgnoredDuringExecution):: self + if std.type(preferredDuringSchedulingIgnoredDuringExecution) == 'array' then self.mixinInstance({ preferredDuringSchedulingIgnoredDuringExecution+: preferredDuringSchedulingIgnoredDuringExecution }) else self.mixinInstance({ preferredDuringSchedulingIgnoredDuringExecution+: [preferredDuringSchedulingIgnoredDuringExecution] }),
                preferredDuringSchedulingIgnoredDuringExecutionType:: hidden.v1.WeightedPodAffinityTerm,
                // If the affinity requirements specified by this field are not met at scheduling time, the pod will not be scheduled onto the node. If the affinity requirements specified by this field cease to be met at some point during pod execution (e.g. due to a pod label update), the system may or may not try to eventually evict the pod from its node. When there are multiple elements, the lists of nodes corresponding to each podAffinityTerm are intersected, i.e. all terms must be satisfied.
                withRequiredDuringSchedulingIgnoredDuringExecution(requiredDuringSchedulingIgnoredDuringExecution):: self + if std.type(requiredDuringSchedulingIgnoredDuringExecution) == 'array' then self.mixinInstance({ requiredDuringSchedulingIgnoredDuringExecution: requiredDuringSchedulingIgnoredDuringExecution }) else self.mixinInstance({ requiredDuringSchedulingIgnoredDuringExecution: [requiredDuringSchedulingIgnoredDuringExecution] }),
                // If the affinity requirements specified by this field are not met at scheduling time, the pod will not be scheduled onto the node. If the affinity requirements specified by this field cease to be met at some point during pod execution (e.g. due to a pod label update), the system may or may not try to eventually evict the pod from its node. When there are multiple elements, the lists of nodes corresponding to each podAffinityTerm are intersected, i.e. all terms must be satisfied.
                withRequiredDuringSchedulingIgnoredDuringExecutionMixin(requiredDuringSchedulingIgnoredDuringExecution):: self + if std.type(requiredDuringSchedulingIgnoredDuringExecution) == 'array' then self.mixinInstance({ requiredDuringSchedulingIgnoredDuringExecution+: requiredDuringSchedulingIgnoredDuringExecution }) else self.mixinInstance({ requiredDuringSchedulingIgnoredDuringExecution+: [requiredDuringSchedulingIgnoredDuringExecution] }),
                requiredDuringSchedulingIgnoredDuringExecutionType:: hidden.v1.PodAffinityTerm,
              },
              // Describes pod anti-affinity scheduling rules (e.g. avoid putting this pod in the same node, zone, etc. as some other pod(s)).
              podAntiAffinity:: {
                local __mixinPodAntiAffinity(podAntiAffinity) = { podAntiAffinity+: podAntiAffinity },
                mixinInstance(podAntiAffinity):: __mixinPodAntiAffinity(podAntiAffinity),
                // The scheduler will prefer to schedule pods to nodes that satisfy the anti-affinity expressions specified by this field, but it may choose a node that violates one or more of the expressions. The node that is most preferred is the one with the greatest sum of weights, i.e. for each node that meets all of the scheduling requirements (resource request, requiredDuringScheduling anti-affinity expressions, etc.), compute a sum by iterating through the elements of this field and adding "weight" to the sum if the node has pods which matches the corresponding podAffinityTerm; the node(s) with the highest sum are the most preferred.
                withPreferredDuringSchedulingIgnoredDuringExecution(preferredDuringSchedulingIgnoredDuringExecution):: self + if std.type(preferredDuringSchedulingIgnoredDuringExecution) == 'array' then self.mixinInstance({ preferredDuringSchedulingIgnoredDuringExecution: preferredDuringSchedulingIgnoredDuringExecution }) else self.mixinInstance({ preferredDuringSchedulingIgnoredDuringExecution: [preferredDuringSchedulingIgnoredDuringExecution] }),
                // The scheduler will prefer to schedule pods to nodes that satisfy the anti-affinity expressions specified by this field, but it may choose a node that violates one or more of the expressions. The node that is most preferred is the one with the greatest sum of weights, i.e. for each node that meets all of the scheduling requirements (resource request, requiredDuringScheduling anti-affinity expressions, etc.), compute a sum by iterating through the elements of this field and adding "weight" to the sum if the node has pods which matches the corresponding podAffinityTerm; the node(s) with the highest sum are the most preferred.
                withPreferredDuringSchedulingIgnoredDuringExecutionMixin(preferredDuringSchedulingIgnoredDuringExecution):: self + if std.type(preferredDuringSchedulingIgnoredDuringExecution) == 'array' then self.mixinInstance({ preferredDuringSchedulingIgnoredDuringExecution+: preferredDuringSchedulingIgnoredDuringExecution }) else self.mixinInstance({ preferredDuringSchedulingIgnoredDuringExecution+: [preferredDuringSchedulingIgnoredDuringExecution] }),
                preferredDuringSchedulingIgnoredDuringExecutionType:: hidden.v1.WeightedPodAffinityTerm,
                // If the anti-affinity requirements specified by this field are not met at scheduling time, the pod will not be scheduled onto the node. If the anti-affinity requirements specified by this field cease to be met at some point during pod execution (e.g. due to a pod label update), the system may or may not try to eventually evict the pod from its node. When there are multiple elements, the lists of nodes corresponding to each podAffinityTerm are intersected, i.e. all terms must be satisfied.
                withRequiredDuringSchedulingIgnoredDuringExecution(requiredDuringSchedulingIgnoredDuringExecution):: self + if std.type(requiredDuringSchedulingIgnoredDuringExecution) == 'array' then self.mixinInstance({ requiredDuringSchedulingIgnoredDuringExecution: requiredDuringSchedulingIgnoredDuringExecution }) else self.mixinInstance({ requiredDuringSchedulingIgnoredDuringExecution: [requiredDuringSchedulingIgnoredDuringExecution] }),
                // If the anti-affinity requirements specified by this field are not met at scheduling time, the pod will not be scheduled onto the node. If the anti-affinity requirements specified by this field cease to be met at some point during pod execution (e.g. due to a pod label update), the system may or may not try to eventually evict the pod from its node. When there are multiple elements, the lists of nodes corresponding to each podAffinityTerm are intersected, i.e. all terms must be satisfied.
                withRequiredDuringSchedulingIgnoredDuringExecutionMixin(requiredDuringSchedulingIgnoredDuringExecution):: self + if std.type(requiredDuringSchedulingIgnoredDuringExecution) == 'array' then self.mixinInstance({ requiredDuringSchedulingIgnoredDuringExecution+: requiredDuringSchedulingIgnoredDuringExecution }) else self.mixinInstance({ requiredDuringSchedulingIgnoredDuringExecution+: [requiredDuringSchedulingIgnoredDuringExecution] }),
                requiredDuringSchedulingIgnoredDuringExecutionType:: hidden.v1.PodAffinityTerm,
              },
            },
            // AutomountServiceAccountToken indicates whether a service account token should be automatically mounted.
            withAutomountServiceAccountToken(automountServiceAccountToken):: self + self.mixinInstance({ automountServiceAccountToken: automountServiceAccountToken }),
            // List of containers belonging to the pod. Containers cannot currently be added or removed. There must be at least one container in a Pod. Cannot be updated.
            withContainers(containers):: self + if std.type(containers) == 'array' then self.mixinInstance({ containers: containers }) else self.mixinInstance({ containers: [containers] }),
            // List of containers belonging to the pod. Containers cannot currently be added or removed. There must be at least one container in a Pod. Cannot be updated.
            withContainersMixin(containers):: self + if std.type(containers) == 'array' then self.mixinInstance({ containers+: containers }) else self.mixinInstance({ containers+: [containers] }),
            containersType:: hidden.v1.Container,
            // Specifies the DNS parameters of a pod. Parameters specified here will be merged to the generated DNS configuration based on DNSPolicy.
            dnsConfig:: {
              local __mixinDnsConfig(dnsConfig) = { dnsConfig+: dnsConfig },
              mixinInstance(dnsConfig):: __mixinDnsConfig(dnsConfig),
              // A list of DNS name server IP addresses. This will be appended to the base nameservers generated from DNSPolicy. Duplicated nameservers will be removed.
              withNameservers(nameservers):: self + if std.type(nameservers) == 'array' then self.mixinInstance({ nameservers: nameservers }) else self.mixinInstance({ nameservers: [nameservers] }),
              // A list of DNS name server IP addresses. This will be appended to the base nameservers generated from DNSPolicy. Duplicated nameservers will be removed.
              withNameserversMixin(nameservers):: self + if std.type(nameservers) == 'array' then self.mixinInstance({ nameservers+: nameservers }) else self.mixinInstance({ nameservers+: [nameservers] }),
              // A list of DNS resolver options. This will be merged with the base options generated from DNSPolicy. Duplicated entries will be removed. Resolution options given in Options will override those that appear in the base DNSPolicy.
              withOptions(options):: self + if std.type(options) == 'array' then self.mixinInstance({ options: options }) else self.mixinInstance({ options: [options] }),
              // A list of DNS resolver options. This will be merged with the base options generated from DNSPolicy. Duplicated entries will be removed. Resolution options given in Options will override those that appear in the base DNSPolicy.
              withOptionsMixin(options):: self + if std.type(options) == 'array' then self.mixinInstance({ options+: options }) else self.mixinInstance({ options+: [options] }),
              optionsType:: hidden.v1.PodDNSConfigOption,
              // A list of DNS search domains for host-name lookup. This will be appended to the base search paths generated from DNSPolicy. Duplicated search paths will be removed.
              withSearches(searches):: self + if std.type(searches) == 'array' then self.mixinInstance({ searches: searches }) else self.mixinInstance({ searches: [searches] }),
              // A list of DNS search domains for host-name lookup. This will be appended to the base search paths generated from DNSPolicy. Duplicated search paths will be removed.
              withSearchesMixin(searches):: self + if std.type(searches) == 'array' then self.mixinInstance({ searches+: searches }) else self.mixinInstance({ searches+: [searches] }),
            },
            // Set DNS policy for the pod. Defaults to "ClusterFirst". Valid values are 'ClusterFirstWithHostNet', 'ClusterFirst', 'Default' or 'None'. DNS parameters given in DNSConfig will be merged with the policy selected with DNSPolicy. To have DNS options set along with hostNetwork, you have to specify DNS policy explicitly to 'ClusterFirstWithHostNet'.
            withDnsPolicy(dnsPolicy):: self + self.mixinInstance({ dnsPolicy: dnsPolicy }),
            // EnableServiceLinks indicates whether information about services should be injected into pod's environment variables, matching the syntax of Docker links. Optional: Defaults to true.
            withEnableServiceLinks(enableServiceLinks):: self + self.mixinInstance({ enableServiceLinks: enableServiceLinks }),
            // List of ephemeral containers run in this pod. Ephemeral containers may be run in an existing pod to perform user-initiated actions such as debugging. This list cannot be specified when creating a pod, and it cannot be modified by updating the pod spec. In order to add an ephemeral container to an existing pod, use the pod's ephemeralcontainers subresource. This field is alpha-level and is only honored by servers that enable the EphemeralContainers feature.
            withEphemeralContainers(ephemeralContainers):: self + if std.type(ephemeralContainers) == 'array' then self.mixinInstance({ ephemeralContainers: ephemeralContainers }) else self.mixinInstance({ ephemeralContainers: [ephemeralContainers] }),
            // List of ephemeral containers run in this pod. Ephemeral containers may be run in an existing pod to perform user-initiated actions such as debugging. This list cannot be specified when creating a pod, and it cannot be modified by updating the pod spec. In order to add an ephemeral container to an existing pod, use the pod's ephemeralcontainers subresource. This field is alpha-level and is only honored by servers that enable the EphemeralContainers feature.
            withEphemeralContainersMixin(ephemeralContainers):: self + if std.type(ephemeralContainers) == 'array' then self.mixinInstance({ ephemeralContainers+: ephemeralContainers }) else self.mixinInstance({ ephemeralContainers+: [ephemeralContainers] }),
            ephemeralContainersType:: hidden.v1.EphemeralContainer,
            // HostAliases is an optional list of hosts and IPs that will be injected into the pod's hosts file if specified. This is only valid for non-hostNetwork pods.
            withHostAliases(hostAliases):: self + if std.type(hostAliases) == 'array' then self.mixinInstance({ hostAliases: hostAliases }) else self.mixinInstance({ hostAliases: [hostAliases] }),
            // HostAliases is an optional list of hosts and IPs that will be injected into the pod's hosts file if specified. This is only valid for non-hostNetwork pods.
            withHostAliasesMixin(hostAliases):: self + if std.type(hostAliases) == 'array' then self.mixinInstance({ hostAliases+: hostAliases }) else self.mixinInstance({ hostAliases+: [hostAliases] }),
            hostAliasesType:: hidden.v1.HostAlias,
            // Use the host's ipc namespace. Optional: Default to false.
            withHostIPC(hostIPC):: self + self.mixinInstance({ hostIPC: hostIPC }),
            // Host networking requested for this pod. Use the host's network namespace. If this option is set, the ports that will be used must be specified. Default to false.
            withHostNetwork(hostNetwork):: self + self.mixinInstance({ hostNetwork: hostNetwork }),
            // Use the host's pid namespace. Optional: Default to false.
            withHostPID(hostPID):: self + self.mixinInstance({ hostPID: hostPID }),
            // Specifies the hostname of the Pod If not specified, the pod's hostname will be set to a system-defined value.
            withHostname(hostname):: self + self.mixinInstance({ hostname: hostname }),
            // ImagePullSecrets is an optional list of references to secrets in the same namespace to use for pulling any of the images used by this PodSpec. If specified, these secrets will be passed to individual puller implementations for them to use. For example, in the case of docker, only DockerConfig type secrets are honored. More info: https://kubernetes.io/docs/concepts/containers/images#specifying-imagepullsecrets-on-a-pod
            withImagePullSecrets(imagePullSecrets):: self + if std.type(imagePullSecrets) == 'array' then self.mixinInstance({ imagePullSecrets: imagePullSecrets }) else self.mixinInstance({ imagePullSecrets: [imagePullSecrets] }),
            // ImagePullSecrets is an optional list of references to secrets in the same namespace to use for pulling any of the images used by this PodSpec. If specified, these secrets will be passed to individual puller implementations for them to use. For example, in the case of docker, only DockerConfig type secrets are honored. More info: https://kubernetes.io/docs/concepts/containers/images#specifying-imagepullsecrets-on-a-pod
            withImagePullSecretsMixin(imagePullSecrets):: self + if std.type(imagePullSecrets) == 'array' then self.mixinInstance({ imagePullSecrets+: imagePullSecrets }) else self.mixinInstance({ imagePullSecrets+: [imagePullSecrets] }),
            imagePullSecretsType:: hidden.v1.LocalObjectReference,
            // List of initialization containers belonging to the pod. Init containers are executed in order prior to containers being started. If any init container fails, the pod is considered to have failed and is handled according to its restartPolicy. The name for an init container or normal container must be unique among all containers. Init containers may not have Lifecycle actions, Readiness probes, Liveness probes, or Startup probes. The resourceRequirements of an init container are taken into account during scheduling by finding the highest request/limit for each resource type, and then using the max of of that value or the sum of the normal containers. Limits are applied to init containers in a similar fashion. Init containers cannot currently be added or removed. Cannot be updated. More info: https://kubernetes.io/docs/concepts/workloads/pods/init-containers/
            withInitContainers(initContainers):: self + if std.type(initContainers) == 'array' then self.mixinInstance({ initContainers: initContainers }) else self.mixinInstance({ initContainers: [initContainers] }),
            // List of initialization containers belonging to the pod. Init containers are executed in order prior to containers being started. If any init container fails, the pod is considered to have failed and is handled according to its restartPolicy. The name for an init container or normal container must be unique among all containers. Init containers may not have Lifecycle actions, Readiness probes, Liveness probes, or Startup probes. The resourceRequirements of an init container are taken into account during scheduling by finding the highest request/limit for each resource type, and then using the max of of that value or the sum of the normal containers. Limits are applied to init containers in a similar fashion. Init containers cannot currently be added or removed. Cannot be updated. More info: https://kubernetes.io/docs/concepts/workloads/pods/init-containers/
            withInitContainersMixin(initContainers):: self + if std.type(initContainers) == 'array' then self.mixinInstance({ initContainers+: initContainers }) else self.mixinInstance({ initContainers+: [initContainers] }),
            initContainersType:: hidden.v1.Container,
            // NodeName is a request to schedule this pod onto a specific node. If it is non-empty, the scheduler simply schedules this pod onto that node, assuming that it fits resource requirements.
            withNodeName(nodeName):: self + self.mixinInstance({ nodeName: nodeName }),
            // NodeSelector is a selector which must be true for the pod to fit on a node. Selector which must match a node's labels for the pod to be scheduled on that node. More info: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/
            withNodeSelector(nodeSelector):: self + self.mixinInstance({ nodeSelector: nodeSelector }),
            // Overhead represents the resource overhead associated with running a pod for a given RuntimeClass. This field will be autopopulated at admission time by the RuntimeClass admission controller. If the RuntimeClass admission controller is enabled, overhead must not be set in Pod create requests. The RuntimeClass admission controller will reject Pod create requests which have the overhead already set. If RuntimeClass is configured and selected in the PodSpec, Overhead will be set to the value defined in the corresponding RuntimeClass, otherwise it will remain unset and treated as zero. More info: https://git.k8s.io/enhancements/keps/sig-node/20190226-pod-overhead.md This field is alpha-level as of Kubernetes v1.16, and is only honored by servers that enable the PodOverhead feature.
            withOverhead(overhead):: self + self.mixinInstance({ overhead: overhead }),
            // PreemptionPolicy is the Policy for preempting pods with lower priority. One of Never, PreemptLowerPriority. Defaults to PreemptLowerPriority if unset. This field is alpha-level and is only honored by servers that enable the NonPreemptingPriority feature.
            withPreemptionPolicy(preemptionPolicy):: self + self.mixinInstance({ preemptionPolicy: preemptionPolicy }),
            // The priority value. Various system components use this field to find the priority of the pod. When Priority Admission Controller is enabled, it prevents users from setting this field. The admission controller populates this field from PriorityClassName. The higher the value, the higher the priority.
            withPriority(priority):: self + self.mixinInstance({ priority: priority }),
            // If specified, indicates the pod's priority. "system-node-critical" and "system-cluster-critical" are two special keywords which indicate the highest priorities with the former being the highest priority. Any other name must be defined by creating a PriorityClass object with that name. If not specified, the pod priority will be default or zero if there is no default.
            withPriorityClassName(priorityClassName):: self + self.mixinInstance({ priorityClassName: priorityClassName }),
            // If specified, all readiness gates will be evaluated for pod readiness. A pod is ready when all its containers are ready AND all conditions specified in the readiness gates have status equal to "True" More info: https://git.k8s.io/enhancements/keps/sig-network/0007-pod-ready%2B%2B.md
            withReadinessGates(readinessGates):: self + if std.type(readinessGates) == 'array' then self.mixinInstance({ readinessGates: readinessGates }) else self.mixinInstance({ readinessGates: [readinessGates] }),
            // If specified, all readiness gates will be evaluated for pod readiness. A pod is ready when all its containers are ready AND all conditions specified in the readiness gates have status equal to "True" More info: https://git.k8s.io/enhancements/keps/sig-network/0007-pod-ready%2B%2B.md
            withReadinessGatesMixin(readinessGates):: self + if std.type(readinessGates) == 'array' then self.mixinInstance({ readinessGates+: readinessGates }) else self.mixinInstance({ readinessGates+: [readinessGates] }),
            readinessGatesType:: hidden.v1.PodReadinessGate,
            // Restart policy for all containers within the pod. One of Always, OnFailure, Never. Default to Always. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#restart-policy
            withRestartPolicy(restartPolicy):: self + self.mixinInstance({ restartPolicy: restartPolicy }),
            // RuntimeClassName refers to a RuntimeClass object in the node.k8s.io group, which should be used to run this pod.  If no RuntimeClass resource matches the named class, the pod will not be run. If unset or empty, the "legacy" RuntimeClass will be used, which is an implicit class with an empty definition that uses the default runtime handler. More info: https://git.k8s.io/enhancements/keps/sig-node/runtime-class.md This is a beta feature as of Kubernetes v1.14.
            withRuntimeClassName(runtimeClassName):: self + self.mixinInstance({ runtimeClassName: runtimeClassName }),
            // If specified, the pod will be dispatched by specified scheduler. If not specified, the pod will be dispatched by default scheduler.
            withSchedulerName(schedulerName):: self + self.mixinInstance({ schedulerName: schedulerName }),
            // SecurityContext holds pod-level security attributes and common container settings. Optional: Defaults to empty.  See type description for default values of each field.
            securityContext:: {
              local __mixinSecurityContext(securityContext) = { securityContext+: securityContext },
              mixinInstance(securityContext):: __mixinSecurityContext(securityContext),
              // A special supplemental group that applies to all containers in a pod. Some volume types allow the Kubelet to change the ownership of that volume to be owned by the pod:
              //
              // 1. The owning GID will be the FSGroup 2. The setgid bit is set (new files created in the volume will be owned by FSGroup) 3. The permission bits are OR'd with rw-rw----
              //
              // If unset, the Kubelet will not modify the ownership and permissions of any volume.
              withFsGroup(fsGroup):: self + self.mixinInstance({ fsGroup: fsGroup }),
              // The GID to run the entrypoint of the container process. Uses runtime default if unset. May also be set in SecurityContext.  If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence for that container.
              withRunAsGroup(runAsGroup):: self + self.mixinInstance({ runAsGroup: runAsGroup }),
              // Indicates that the container must run as a non-root user. If true, the Kubelet will validate the image at runtime to ensure that it does not run as UID 0 (root) and fail to start the container if it does. If unset or false, no such validation will be performed. May also be set in SecurityContext.  If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence.
              withRunAsNonRoot(runAsNonRoot):: self + self.mixinInstance({ runAsNonRoot: runAsNonRoot }),
              // The UID to run the entrypoint of the container process. Defaults to user specified in image metadata if unspecified. May also be set in SecurityContext.  If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence for that container.
              withRunAsUser(runAsUser):: self + self.mixinInstance({ runAsUser: runAsUser }),
              // The SELinux context to be applied to all containers. If unspecified, the container runtime will allocate a random SELinux context for each container.  May also be set in SecurityContext.  If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence for that container.
              seLinuxOptions:: {
                local __mixinSeLinuxOptions(seLinuxOptions) = { seLinuxOptions+: seLinuxOptions },
                mixinInstance(seLinuxOptions):: __mixinSeLinuxOptions(seLinuxOptions),
                // Level is SELinux level label that applies to the container.
                withLevel(level):: self + self.mixinInstance({ level: level }),
                // Role is a SELinux role label that applies to the container.
                withRole(role):: self + self.mixinInstance({ role: role }),
                // Type is a SELinux type label that applies to the container.
                withType(type):: self + self.mixinInstance({ type: type }),
                // User is a SELinux user label that applies to the container.
                withUser(user):: self + self.mixinInstance({ user: user }),
              },
              // A list of groups applied to the first process run in each container, in addition to the container's primary GID.  If unspecified, no groups will be added to any container.
              withSupplementalGroups(supplementalGroups):: self + if std.type(supplementalGroups) == 'array' then self.mixinInstance({ supplementalGroups: supplementalGroups }) else self.mixinInstance({ supplementalGroups: [supplementalGroups] }),
              // A list of groups applied to the first process run in each container, in addition to the container's primary GID.  If unspecified, no groups will be added to any container.
              withSupplementalGroupsMixin(supplementalGroups):: self + if std.type(supplementalGroups) == 'array' then self.mixinInstance({ supplementalGroups+: supplementalGroups }) else self.mixinInstance({ supplementalGroups+: [supplementalGroups] }),
              // Sysctls hold a list of namespaced sysctls used for the pod. Pods with unsupported sysctls (by the container runtime) might fail to launch.
              withSysctls(sysctls):: self + if std.type(sysctls) == 'array' then self.mixinInstance({ sysctls: sysctls }) else self.mixinInstance({ sysctls: [sysctls] }),
              // Sysctls hold a list of namespaced sysctls used for the pod. Pods with unsupported sysctls (by the container runtime) might fail to launch.
              withSysctlsMixin(sysctls):: self + if std.type(sysctls) == 'array' then self.mixinInstance({ sysctls+: sysctls }) else self.mixinInstance({ sysctls+: [sysctls] }),
              sysctlsType:: hidden.v1.Sysctl,
              // The Windows specific settings applied to all containers. If unspecified, the options within a container's SecurityContext will be used. If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence.
              windowsOptions:: {
                local __mixinWindowsOptions(windowsOptions) = { windowsOptions+: windowsOptions },
                mixinInstance(windowsOptions):: __mixinWindowsOptions(windowsOptions),
                // GMSACredentialSpec is where the GMSA admission webhook (https://github.com/kubernetes-sigs/windows-gmsa) inlines the contents of the GMSA credential spec named by the GMSACredentialSpecName field. This field is alpha-level and is only honored by servers that enable the WindowsGMSA feature flag.
                withGmsaCredentialSpec(gmsaCredentialSpec):: self + self.mixinInstance({ gmsaCredentialSpec: gmsaCredentialSpec }),
                // GMSACredentialSpecName is the name of the GMSA credential spec to use. This field is alpha-level and is only honored by servers that enable the WindowsGMSA feature flag.
                withGmsaCredentialSpecName(gmsaCredentialSpecName):: self + self.mixinInstance({ gmsaCredentialSpecName: gmsaCredentialSpecName }),
                // The UserName in Windows to run the entrypoint of the container process. Defaults to the user specified in image metadata if unspecified. May also be set in PodSecurityContext. If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence. This field is beta-level and may be disabled with the WindowsRunAsUserName feature flag.
                withRunAsUserName(runAsUserName):: self + self.mixinInstance({ runAsUserName: runAsUserName }),
              },
            },
            // DeprecatedServiceAccount is a depreciated alias for ServiceAccountName. Deprecated: Use serviceAccountName instead.
            withServiceAccount(serviceAccount):: self + self.mixinInstance({ serviceAccount: serviceAccount }),
            // ServiceAccountName is the name of the ServiceAccount to use to run this pod. More info: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/
            withServiceAccountName(serviceAccountName):: self + self.mixinInstance({ serviceAccountName: serviceAccountName }),
            // Share a single process namespace between all of the containers in a pod. When this is set containers will be able to view and signal processes from other containers in the same pod, and the first process in each container will not be assigned PID 1. HostPID and ShareProcessNamespace cannot both be set. Optional: Default to false.
            withShareProcessNamespace(shareProcessNamespace):: self + self.mixinInstance({ shareProcessNamespace: shareProcessNamespace }),
            // If specified, the fully qualified Pod hostname will be "<hostname>.<subdomain>.<pod namespace>.svc.<cluster domain>". If not specified, the pod will not have a domainname at all.
            withSubdomain(subdomain):: self + self.mixinInstance({ subdomain: subdomain }),
            // Optional duration in seconds the pod needs to terminate gracefully. May be decreased in delete request. Value must be non-negative integer. The value zero indicates delete immediately. If this value is nil, the default grace period will be used instead. The grace period is the duration in seconds after the processes running in the pod are sent a termination signal and the time when the processes are forcibly halted with a kill signal. Set this value longer than the expected cleanup time for your process. Defaults to 30 seconds.
            withTerminationGracePeriodSeconds(terminationGracePeriodSeconds):: self + self.mixinInstance({ terminationGracePeriodSeconds: terminationGracePeriodSeconds }),
            // If specified, the pod's tolerations.
            withTolerations(tolerations):: self + if std.type(tolerations) == 'array' then self.mixinInstance({ tolerations: tolerations }) else self.mixinInstance({ tolerations: [tolerations] }),
            // If specified, the pod's tolerations.
            withTolerationsMixin(tolerations):: self + if std.type(tolerations) == 'array' then self.mixinInstance({ tolerations+: tolerations }) else self.mixinInstance({ tolerations+: [tolerations] }),
            tolerationsType:: hidden.v1.Toleration,
            // TopologySpreadConstraints describes how a group of pods ought to spread across topology domains. Scheduler will schedule pods in a way which abides by the constraints. This field is alpha-level and is only honored by clusters that enables the EvenPodsSpread feature. All topologySpreadConstraints are ANDed.
            withTopologySpreadConstraints(topologySpreadConstraints):: self + if std.type(topologySpreadConstraints) == 'array' then self.mixinInstance({ topologySpreadConstraints: topologySpreadConstraints }) else self.mixinInstance({ topologySpreadConstraints: [topologySpreadConstraints] }),
            // TopologySpreadConstraints describes how a group of pods ought to spread across topology domains. Scheduler will schedule pods in a way which abides by the constraints. This field is alpha-level and is only honored by clusters that enables the EvenPodsSpread feature. All topologySpreadConstraints are ANDed.
            withTopologySpreadConstraintsMixin(topologySpreadConstraints):: self + if std.type(topologySpreadConstraints) == 'array' then self.mixinInstance({ topologySpreadConstraints+: topologySpreadConstraints }) else self.mixinInstance({ topologySpreadConstraints+: [topologySpreadConstraints] }),
            topologySpreadConstraintsType:: hidden.v1.TopologySpreadConstraint,
            // List of volumes that can be mounted by containers belonging to the pod. More info: https://kubernetes.io/docs/concepts/storage/volumes
            withVolumes(volumes):: self + if std.type(volumes) == 'array' then self.mixinInstance({ volumes: volumes }) else self.mixinInstance({ volumes: [volumes] }),
            // List of volumes that can be mounted by containers belonging to the pod. More info: https://kubernetes.io/docs/concepts/storage/volumes
            withVolumesMixin(volumes):: self + if std.type(volumes) == 'array' then self.mixinInstance({ volumes+: volumes }) else self.mixinInstance({ volumes+: [volumes] }),
            volumesType:: hidden.v1.Volume,
          },
          // Most recently observed status of the pod. This data may not be up to date. Populated by the system. Read-only. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#spec-and-status
          status:: {
            local __mixinStatus(status) = { status+: status },
            mixinInstance(status):: __mixinStatus(status),
            // Current service state of pod. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#pod-conditions
            withConditions(conditions):: self + if std.type(conditions) == 'array' then self.mixinInstance({ conditions: conditions }) else self.mixinInstance({ conditions: [conditions] }),
            // Current service state of pod. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#pod-conditions
            withConditionsMixin(conditions):: self + if std.type(conditions) == 'array' then self.mixinInstance({ conditions+: conditions }) else self.mixinInstance({ conditions+: [conditions] }),
            conditionsType:: hidden.v1.PodCondition,
            // The list has one entry per container in the manifest. Each entry is currently the output of `docker inspect`. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#pod-and-container-status
            withContainerStatuses(containerStatuses):: self + if std.type(containerStatuses) == 'array' then self.mixinInstance({ containerStatuses: containerStatuses }) else self.mixinInstance({ containerStatuses: [containerStatuses] }),
            // The list has one entry per container in the manifest. Each entry is currently the output of `docker inspect`. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#pod-and-container-status
            withContainerStatusesMixin(containerStatuses):: self + if std.type(containerStatuses) == 'array' then self.mixinInstance({ containerStatuses+: containerStatuses }) else self.mixinInstance({ containerStatuses+: [containerStatuses] }),
            containerStatusesType:: hidden.v1.ContainerStatus,
            // Status for any ephemeral containers that have run in this pod. This field is alpha-level and is only populated by servers that enable the EphemeralContainers feature.
            withEphemeralContainerStatuses(ephemeralContainerStatuses):: self + if std.type(ephemeralContainerStatuses) == 'array' then self.mixinInstance({ ephemeralContainerStatuses: ephemeralContainerStatuses }) else self.mixinInstance({ ephemeralContainerStatuses: [ephemeralContainerStatuses] }),
            // Status for any ephemeral containers that have run in this pod. This field is alpha-level and is only populated by servers that enable the EphemeralContainers feature.
            withEphemeralContainerStatusesMixin(ephemeralContainerStatuses):: self + if std.type(ephemeralContainerStatuses) == 'array' then self.mixinInstance({ ephemeralContainerStatuses+: ephemeralContainerStatuses }) else self.mixinInstance({ ephemeralContainerStatuses+: [ephemeralContainerStatuses] }),
            ephemeralContainerStatusesType:: hidden.v1.ContainerStatus,
            // IP address of the host to which the pod is assigned. Empty if not yet scheduled.
            withHostIP(hostIP):: self + self.mixinInstance({ hostIP: hostIP }),
            // The list has one entry per init container in the manifest. The most recent successful init container will have ready = true, the most recently started container will have startTime set. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#pod-and-container-status
            withInitContainerStatuses(initContainerStatuses):: self + if std.type(initContainerStatuses) == 'array' then self.mixinInstance({ initContainerStatuses: initContainerStatuses }) else self.mixinInstance({ initContainerStatuses: [initContainerStatuses] }),
            // The list has one entry per init container in the manifest. The most recent successful init container will have ready = true, the most recently started container will have startTime set. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#pod-and-container-status
            withInitContainerStatusesMixin(initContainerStatuses):: self + if std.type(initContainerStatuses) == 'array' then self.mixinInstance({ initContainerStatuses+: initContainerStatuses }) else self.mixinInstance({ initContainerStatuses+: [initContainerStatuses] }),
            initContainerStatusesType:: hidden.v1.ContainerStatus,
            // A human readable message indicating details about why the pod is in this condition.
            withMessage(message):: self + self.mixinInstance({ message: message }),
            // nominatedNodeName is set only when this pod preempts other pods on the node, but it cannot be scheduled right away as preemption victims receive their graceful termination periods. This field does not guarantee that the pod will be scheduled on this node. Scheduler may decide to place the pod elsewhere if other nodes become available sooner. Scheduler may also decide to give the resources on this node to a higher priority pod that is created after preemption. As a result, this field may be different than PodSpec.nodeName when the pod is scheduled.
            withNominatedNodeName(nominatedNodeName):: self + self.mixinInstance({ nominatedNodeName: nominatedNodeName }),
            // The phase of a Pod is a simple, high-level summary of where the Pod is in its lifecycle. The conditions array, the reason and message fields, and the individual container status arrays contain more detail about the pod's status. There are five possible phase values:
            //
            // Pending: The pod has been accepted by the Kubernetes system, but one or more of the container images has not been created. This includes time before being scheduled as well as time spent downloading images over the network, which could take a while. Running: The pod has been bound to a node, and all of the containers have been created. At least one container is still running, or is in the process of starting or restarting. Succeeded: All containers in the pod have terminated in success, and will not be restarted. Failed: All containers in the pod have terminated, and at least one container has terminated in failure. The container either exited with non-zero status or was terminated by the system. Unknown: For some reason the state of the pod could not be obtained, typically due to an error in communicating with the host of the pod.
            //
            // More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#pod-phase
            withPhase(phase):: self + self.mixinInstance({ phase: phase }),
            // IP address allocated to the pod. Routable at least within the cluster. Empty if not yet allocated.
            withPodIP(podIP):: self + self.mixinInstance({ podIP: podIP }),
            // podIPs holds the IP addresses allocated to the pod. If this field is specified, the 0th entry must match the podIP field. Pods may be allocated at most 1 value for each of IPv4 and IPv6. This list is empty if no IPs have been allocated yet.
            withPodIPs(podIPs):: self + if std.type(podIPs) == 'array' then self.mixinInstance({ podIPs: podIPs }) else self.mixinInstance({ podIPs: [podIPs] }),
            // podIPs holds the IP addresses allocated to the pod. If this field is specified, the 0th entry must match the podIP field. Pods may be allocated at most 1 value for each of IPv4 and IPv6. This list is empty if no IPs have been allocated yet.
            withPodIPsMixin(podIPs):: self + if std.type(podIPs) == 'array' then self.mixinInstance({ podIPs+: podIPs }) else self.mixinInstance({ podIPs+: [podIPs] }),
            podIPsType:: hidden.v1.PodIP,
            // The Quality of Service (QOS) classification assigned to the pod based on resource requirements See PodQOSClass type for available QOS classes More info: https://git.k8s.io/community/contributors/design-proposals/node/resource-qos.md
            withQosClass(qosClass):: self + self.mixinInstance({ qosClass: qosClass }),
            // A brief CamelCase message indicating details about why the pod is in this state. e.g. 'Evicted'
            withReason(reason):: self + self.mixinInstance({ reason: reason }),
            // RFC 3339 date and time at which the object was acknowledged by the Kubelet. This is before the Kubelet pulled the container image(s) for the pod.
            withStartTime(startTime):: self + self.mixinInstance({ startTime: startTime }),
          },
        },
      },
    },
  },
  local hidden = {
    core:: {
      v1:: {
        local apiVersion = { apiVersion: 'v1' },
        // ContainerStateTerminated is a terminated state of a container.
        containerStateTerminated:: {
          local kind = { kind: 'ContainerStateTerminated' },
          // Container's ID in the format 'docker://<container_id>'
          withContainerID(containerID):: self + self.mixinInstance({ containerID: containerID }),
          // Exit status from the last termination of the container
          withExitCode(exitCode):: self + self.mixinInstance({ exitCode: exitCode }),
          // Message regarding the last termination of the container
          withMessage(message):: self + self.mixinInstance({ message: message }),
          // (brief) reason from the last termination of the container
          withReason(reason):: self + self.mixinInstance({ reason: reason }),
          // Signal from the last termination of the container
          withSignal(signal):: self + self.mixinInstance({ signal: signal }),
          mixin:: {
            // Time at which the container last terminated
            withFinishedAt(finishedAt):: self + self.mixinInstance({ finishedAt: finishedAt }),
            // Time at which previous execution of the container started
            withStartedAt(startedAt):: self + self.mixinInstance({ startedAt: startedAt }),
          },
        },
        // Represents a Persistent Disk resource in Google Compute Engine.
        //
        // A GCE PD must exist before mounting to a container. The disk must also be in the same GCE project and zone as the kubelet. A GCE PD can only be mounted as read/write once or read-only many times. GCE PDs support ownership management and SELinux relabeling.
        gcePersistentDiskVolumeSource:: {
          local kind = { kind: 'GCEPersistentDiskVolumeSource' },
          // Filesystem type of the volume that you want to mount. Tip: Ensure that the filesystem type is supported by the host operating system. Examples: "ext4", "xfs", "ntfs". Implicitly inferred to be "ext4" if unspecified. More info: https://kubernetes.io/docs/concepts/storage/volumes#gcepersistentdisk
          withFsType(fsType):: self + self.mixinInstance({ fsType: fsType }),
          // The partition in the volume that you want to mount. If omitted, the default is to mount by volume name. Examples: For volume /dev/sda1, you specify the partition as "1". Similarly, the volume partition for /dev/sda is "0" (or you can leave the property empty). More info: https://kubernetes.io/docs/concepts/storage/volumes#gcepersistentdisk
          withPartition(partition):: self + self.mixinInstance({ partition: partition }),
          // Unique name of the PD resource in GCE. Used to identify the disk in GCE. More info: https://kubernetes.io/docs/concepts/storage/volumes#gcepersistentdisk
          withPdName(pdName):: self + self.mixinInstance({ pdName: pdName }),
          // ReadOnly here will force the ReadOnly setting in VolumeMounts. Defaults to false. More info: https://kubernetes.io/docs/concepts/storage/volumes#gcepersistentdisk
          withReadOnly(readOnly):: self + self.mixinInstance({ readOnly: readOnly }),
          mixin:: {},
        },
        // HTTPGetAction describes an action based on HTTP Get requests.
        httpGetAction:: {
          local kind = { kind: 'HTTPGetAction' },
          // Host name to connect to, defaults to the pod IP. You probably want to set "Host" in httpHeaders instead.
          withHost(host):: self + self.mixinInstance({ host: host }),
          // Custom headers to set in the request. HTTP allows repeated headers.
          withHttpHeaders(httpHeaders):: self + if std.type(httpHeaders) == 'array' then self.mixinInstance({ httpHeaders: httpHeaders }) else self.mixinInstance({ httpHeaders: [httpHeaders] }),
          // Custom headers to set in the request. HTTP allows repeated headers.
          withHttpHeadersMixin(httpHeaders):: self + if std.type(httpHeaders) == 'array' then self.mixinInstance({ httpHeaders+: httpHeaders }) else self.mixinInstance({ httpHeaders+: [httpHeaders] }),
          httpHeadersType:: hidden.v1.HTTPHeader,
          // Path to access on the HTTP server.
          withPath(path):: self + self.mixinInstance({ path: path }),
          // Scheme to use for connecting to the host. Defaults to HTTP.
          withScheme(scheme):: self + self.mixinInstance({ scheme: scheme }),
          mixin:: {
            // Name or number of the port to access on the container. Number must be in the range 1 to 65535. Name must be an IANA_SVC_NAME.
            withPort(port):: self + self.mixinInstance({ port: port }),
          },
        },
        // A node selector requirement is a selector that contains values, a key, and an operator that relates the key and values.
        nodeSelectorRequirement:: {
          local kind = { kind: 'NodeSelectorRequirement' },
          // The label key that the selector applies to.
          withKey(key):: self + self.mixinInstance({ key: key }),
          // Represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists, DoesNotExist. Gt, and Lt.
          withOperator(operator):: self + self.mixinInstance({ operator: operator }),
          // An array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. If the operator is Gt or Lt, the values array must have a single element, which will be interpreted as an integer. This array is replaced during a strategic merge patch.
          withValues(values):: self + if std.type(values) == 'array' then self.mixinInstance({ values: values }) else self.mixinInstance({ values: [values] }),
          // An array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. If the operator is Gt or Lt, the values array must have a single element, which will be interpreted as an integer. This array is replaced during a strategic merge patch.
          withValuesMixin(values):: self + if std.type(values) == 'array' then self.mixinInstance({ values+: values }) else self.mixinInstance({ values+: [values] }),
          mixin:: {},
        },
        // ObjectFieldSelector selects an APIVersioned field of an object.
        objectFieldSelector:: {
          local kind = { kind: 'ObjectFieldSelector' },
          // Path of the field to select in the specified API version.
          withFieldPath(fieldPath):: self + self.mixinInstance({ fieldPath: fieldPath }),
          mixin:: {},
        },
        // PodDNSConfigOption defines DNS resolver options of a pod.
        podDNSConfigOption:: {
          local kind = { kind: 'PodDNSConfigOption' },
          // Required.
          withName(name):: self + self.mixinInstance({ name: name }),
          //
          withValue(value):: self + self.mixinInstance({ value: value }),
          mixin:: {},
        },
        // Represents a projected volume source
        projectedVolumeSource:: {
          local kind = { kind: 'ProjectedVolumeSource' },
          // Mode bits to use on created files by default. Must be a value between 0 and 0777. Directories within the path are not affected by this setting. This might be in conflict with other options that affect the file mode, like fsGroup, and the result can be other mode bits set.
          withDefaultMode(defaultMode):: self + self.mixinInstance({ defaultMode: defaultMode }),
          // list of volume projections
          withSources(sources):: self + if std.type(sources) == 'array' then self.mixinInstance({ sources: sources }) else self.mixinInstance({ sources: [sources] }),
          // list of volume projections
          withSourcesMixin(sources):: self + if std.type(sources) == 'array' then self.mixinInstance({ sources+: sources }) else self.mixinInstance({ sources+: [sources] }),
          sourcesType:: hidden.v1.VolumeProjection,
          mixin:: {},
        },
        // Represents a Ceph Filesystem mount that lasts the lifetime of a pod Cephfs volumes do not support ownership management or SELinux relabeling.
        cephFSVolumeSource:: {
          local kind = { kind: 'CephFSVolumeSource' },
          // Required: Monitors is a collection of Ceph monitors More info: https://examples.k8s.io/volumes/cephfs/README.md#how-to-use-it
          withMonitors(monitors):: self + if std.type(monitors) == 'array' then self.mixinInstance({ monitors: monitors }) else self.mixinInstance({ monitors: [monitors] }),
          // Required: Monitors is a collection of Ceph monitors More info: https://examples.k8s.io/volumes/cephfs/README.md#how-to-use-it
          withMonitorsMixin(monitors):: self + if std.type(monitors) == 'array' then self.mixinInstance({ monitors+: monitors }) else self.mixinInstance({ monitors+: [monitors] }),
          // Optional: Used as the mounted root, rather than the full Ceph tree, default is /
          withPath(path):: self + self.mixinInstance({ path: path }),
          // Optional: Defaults to false (read/write). ReadOnly here will force the ReadOnly setting in VolumeMounts. More info: https://examples.k8s.io/volumes/cephfs/README.md#how-to-use-it
          withReadOnly(readOnly):: self + self.mixinInstance({ readOnly: readOnly }),
          // Optional: SecretFile is the path to key ring for User, default is /etc/ceph/user.secret More info: https://examples.k8s.io/volumes/cephfs/README.md#how-to-use-it
          withSecretFile(secretFile):: self + self.mixinInstance({ secretFile: secretFile }),
          // Optional: User is the rados user name, default is admin More info: https://examples.k8s.io/volumes/cephfs/README.md#how-to-use-it
          withUser(user):: self + self.mixinInstance({ user: user }),
          mixin:: {
            // Optional: SecretRef is reference to the authentication secret for User, default is empty. More info: https://examples.k8s.io/volumes/cephfs/README.md#how-to-use-it
            secretRef:: {
              local __mixinSecretRef(secretRef) = { secretRef+: secretRef },
              mixinInstance(secretRef):: __mixinSecretRef(secretRef),
              // Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
              withName(name):: self + self.mixinInstance({ name: name }),
            },
          },
        },
        // TCPSocketAction describes an action based on opening a socket
        tcpSocketAction:: {
          local kind = { kind: 'TCPSocketAction' },
          // Optional: Host name to connect to, defaults to the pod IP.
          withHost(host):: self + self.mixinInstance({ host: host }),
          mixin:: {
            // Number or name of the port to access on the container. Number must be in the range 1 to 65535. Name must be an IANA_SVC_NAME.
            withPort(port):: self + self.mixinInstance({ port: port }),
          },
        },
        // Adapts a ConfigMap into a projected volume.
        //
        // The contents of the target ConfigMap's Data field will be presented in a projected volume as files using the keys in the Data field as the file names, unless the items element is populated with specific mappings of keys to paths. Note that this is identical to a configmap volume source without the default mode.
        configMapProjection:: {
          local kind = { kind: 'ConfigMapProjection' },
          // If unspecified, each key-value pair in the Data field of the referenced ConfigMap will be projected into the volume as a file whose name is the key and content is the value. If specified, the listed keys will be projected into the specified paths, and unlisted keys will not be present. If a key is specified which is not present in the ConfigMap, the volume setup will error unless it is marked optional. Paths must be relative and may not contain the '..' path or start with '..'.
          withItems(items):: self + if std.type(items) == 'array' then self.mixinInstance({ items: items }) else self.mixinInstance({ items: [items] }),
          // If unspecified, each key-value pair in the Data field of the referenced ConfigMap will be projected into the volume as a file whose name is the key and content is the value. If specified, the listed keys will be projected into the specified paths, and unlisted keys will not be present. If a key is specified which is not present in the ConfigMap, the volume setup will error unless it is marked optional. Paths must be relative and may not contain the '..' path or start with '..'.
          withItemsMixin(items):: self + if std.type(items) == 'array' then self.mixinInstance({ items+: items }) else self.mixinInstance({ items+: [items] }),
          itemsType:: hidden.v1.KeyToPath,
          // Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
          withName(name):: self + self.mixinInstance({ name: name }),
          // Specify whether the ConfigMap or its keys must be defined
          withOptional(optional):: self + self.mixinInstance({ optional: optional }),
          mixin:: {},
        },
        // DownwardAPIVolumeFile represents information to create the file containing the pod field
        downwardAPIVolumeFile:: {
          local kind = { kind: 'DownwardAPIVolumeFile' },
          // Optional: mode bits to use on this file, must be a value between 0 and 0777. If not specified, the volume defaultMode will be used. This might be in conflict with other options that affect the file mode, like fsGroup, and the result can be other mode bits set.
          withMode(mode):: self + self.mixinInstance({ mode: mode }),
          // Required: Path is  the relative path name of the file to be created. Must not be absolute or contain the '..' path. Must be utf-8 encoded. The first item of the relative path must not start with '..'
          withPath(path):: self + self.mixinInstance({ path: path }),
          mixin:: {
            // Required: Selects a field of the pod: only annotations, labels, name and namespace are supported.
            fieldRef:: {
              local __mixinFieldRef(fieldRef) = { fieldRef+: fieldRef },
              mixinInstance(fieldRef):: __mixinFieldRef(fieldRef),
              // Version of the schema the FieldPath is written in terms of, defaults to "v1".
              withApiVersion(apiVersion):: self + self.mixinInstance({ apiVersion: apiVersion }),
              // Path of the field to select in the specified API version.
              withFieldPath(fieldPath):: self + self.mixinInstance({ fieldPath: fieldPath }),
            },
            // Selects a resource of the container: only resources limits and requests (limits.cpu, limits.memory, requests.cpu and requests.memory) are currently supported.
            resourceFieldRef:: {
              local __mixinResourceFieldRef(resourceFieldRef) = { resourceFieldRef+: resourceFieldRef },
              mixinInstance(resourceFieldRef):: __mixinResourceFieldRef(resourceFieldRef),
              // Container name: required for volumes, optional for env vars
              withContainerName(containerName):: self + self.mixinInstance({ containerName: containerName }),
              // Specifies the output format of the exposed resources, defaults to "1"
              withDivisor(divisor):: self + self.mixinInstance({ divisor: divisor }),
              // Required: resource to select
              withResource(resource):: self + self.mixinInstance({ resource: resource }),
            },
          },
        },
        // Represents a Photon Controller persistent disk resource.
        photonPersistentDiskVolumeSource:: {
          local kind = { kind: 'PhotonPersistentDiskVolumeSource' },
          // Filesystem type to mount. Must be a filesystem type supported by the host operating system. Ex. "ext4", "xfs", "ntfs". Implicitly inferred to be "ext4" if unspecified.
          withFsType(fsType):: self + self.mixinInstance({ fsType: fsType }),
          // ID that identifies Photon Controller persistent disk
          withPdID(pdID):: self + self.mixinInstance({ pdID: pdID }),
          mixin:: {},
        },
        // Adds and removes POSIX capabilities from running containers.
        capabilities:: {
          local kind = { kind: 'Capabilities' },
          // Added capabilities
          withAdd(add):: self + if std.type(add) == 'array' then self.mixinInstance({ add: add }) else self.mixinInstance({ add: [add] }),
          // Added capabilities
          withAddMixin(add):: self + if std.type(add) == 'array' then self.mixinInstance({ add+: add }) else self.mixinInstance({ add+: [add] }),
          // Removed capabilities
          withDrop(drop):: self + if std.type(drop) == 'array' then self.mixinInstance({ drop: drop }) else self.mixinInstance({ drop: [drop] }),
          // Removed capabilities
          withDropMixin(drop):: self + if std.type(drop) == 'array' then self.mixinInstance({ drop+: drop }) else self.mixinInstance({ drop+: [drop] }),
          mixin:: {},
        },
        // LocalObjectReference contains enough information to let you locate the referenced object inside the same namespace.
        localObjectReference:: {
          local kind = { kind: 'LocalObjectReference' },
          // Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
          withName(name):: self + self.mixinInstance({ name: name }),
          mixin:: {},
        },
        // A null or empty node selector term matches no objects. The requirements of them are ANDed. The TopologySelectorTerm type implements a subset of the NodeSelectorTerm.
        nodeSelectorTerm:: {
          local kind = { kind: 'NodeSelectorTerm' },
          // A list of node selector requirements by node's labels.
          withMatchExpressions(matchExpressions):: self + if std.type(matchExpressions) == 'array' then self.mixinInstance({ matchExpressions: matchExpressions }) else self.mixinInstance({ matchExpressions: [matchExpressions] }),
          // A list of node selector requirements by node's labels.
          withMatchExpressionsMixin(matchExpressions):: self + if std.type(matchExpressions) == 'array' then self.mixinInstance({ matchExpressions+: matchExpressions }) else self.mixinInstance({ matchExpressions+: [matchExpressions] }),
          matchExpressionsType:: hidden.v1.NodeSelectorRequirement,
          // A list of node selector requirements by node's fields.
          withMatchFields(matchFields):: self + if std.type(matchFields) == 'array' then self.mixinInstance({ matchFields: matchFields }) else self.mixinInstance({ matchFields: [matchFields] }),
          // A list of node selector requirements by node's fields.
          withMatchFieldsMixin(matchFields):: self + if std.type(matchFields) == 'array' then self.mixinInstance({ matchFields+: matchFields }) else self.mixinInstance({ matchFields+: [matchFields] }),
          matchFieldsType:: hidden.v1.NodeSelectorRequirement,
          mixin:: {},
        },
        // ContainerPort represents a network port in a single container.
        containerPort:: {
          local kind = { kind: 'ContainerPort' },
          // Number of port to expose on the pod's IP address. This must be a valid port number, 0 < x < 65536.
          withContainerPort(containerPort):: self + self.mixinInstance({ containerPort: containerPort }),
          // What host IP to bind the external port to.
          withHostIP(hostIP):: self + self.mixinInstance({ hostIP: hostIP }),
          // Number of port to expose on the host. If specified, this must be a valid port number, 0 < x < 65536. If HostNetwork is specified, this must match ContainerPort. Most containers do not need this.
          withHostPort(hostPort):: self + self.mixinInstance({ hostPort: hostPort }),
          // If specified, this must be an IANA_SVC_NAME and unique within the pod. Each named port in a pod must have a unique name. Name for the port that can be referred to by services.
          withName(name):: self + self.mixinInstance({ name: name }),
          // Protocol for port. Must be UDP, TCP, or SCTP. Defaults to "TCP".
          withProtocol(protocol):: self + self.mixinInstance({ protocol: protocol }),
          mixin:: {},
        },
        // A single application container that you want to run within a pod.
        container:: {
          local kind = { kind: 'Container' },
          // Arguments to the entrypoint. The docker image's CMD is used if this is not provided. Variable references $(VAR_NAME) are expanded using the container's environment. If a variable cannot be resolved, the reference in the input string will be unchanged. The $(VAR_NAME) syntax can be escaped with a double $$, ie: $$(VAR_NAME). Escaped references will never be expanded, regardless of whether the variable exists or not. Cannot be updated. More info: https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/#running-a-command-in-a-shell
          withArgs(args):: self + if std.type(args) == 'array' then self.mixinInstance({ args: args }) else self.mixinInstance({ args: [args] }),
          // Arguments to the entrypoint. The docker image's CMD is used if this is not provided. Variable references $(VAR_NAME) are expanded using the container's environment. If a variable cannot be resolved, the reference in the input string will be unchanged. The $(VAR_NAME) syntax can be escaped with a double $$, ie: $$(VAR_NAME). Escaped references will never be expanded, regardless of whether the variable exists or not. Cannot be updated. More info: https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/#running-a-command-in-a-shell
          withArgsMixin(args):: self + if std.type(args) == 'array' then self.mixinInstance({ args+: args }) else self.mixinInstance({ args+: [args] }),
          // Entrypoint array. Not executed within a shell. The docker image's ENTRYPOINT is used if this is not provided. Variable references $(VAR_NAME) are expanded using the container's environment. If a variable cannot be resolved, the reference in the input string will be unchanged. The $(VAR_NAME) syntax can be escaped with a double $$, ie: $$(VAR_NAME). Escaped references will never be expanded, regardless of whether the variable exists or not. Cannot be updated. More info: https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/#running-a-command-in-a-shell
          withCommand(command):: self + if std.type(command) == 'array' then self.mixinInstance({ command: command }) else self.mixinInstance({ command: [command] }),
          // Entrypoint array. Not executed within a shell. The docker image's ENTRYPOINT is used if this is not provided. Variable references $(VAR_NAME) are expanded using the container's environment. If a variable cannot be resolved, the reference in the input string will be unchanged. The $(VAR_NAME) syntax can be escaped with a double $$, ie: $$(VAR_NAME). Escaped references will never be expanded, regardless of whether the variable exists or not. Cannot be updated. More info: https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/#running-a-command-in-a-shell
          withCommandMixin(command):: self + if std.type(command) == 'array' then self.mixinInstance({ command+: command }) else self.mixinInstance({ command+: [command] }),
          // List of environment variables to set in the container. Cannot be updated.
          withEnv(env):: self + if std.type(env) == 'array' then self.mixinInstance({ env: env }) else self.mixinInstance({ env: [env] }),
          // List of environment variables to set in the container. Cannot be updated.
          withEnvMixin(env):: self + if std.type(env) == 'array' then self.mixinInstance({ env+: env }) else self.mixinInstance({ env+: [env] }),
          envType:: hidden.v1.EnvVar,
          // List of sources to populate environment variables in the container. The keys defined within a source must be a C_IDENTIFIER. All invalid keys will be reported as an event when the container is starting. When a key exists in multiple sources, the value associated with the last source will take precedence. Values defined by an Env with a duplicate key will take precedence. Cannot be updated.
          withEnvFrom(envFrom):: self + if std.type(envFrom) == 'array' then self.mixinInstance({ envFrom: envFrom }) else self.mixinInstance({ envFrom: [envFrom] }),
          // List of sources to populate environment variables in the container. The keys defined within a source must be a C_IDENTIFIER. All invalid keys will be reported as an event when the container is starting. When a key exists in multiple sources, the value associated with the last source will take precedence. Values defined by an Env with a duplicate key will take precedence. Cannot be updated.
          withEnvFromMixin(envFrom):: self + if std.type(envFrom) == 'array' then self.mixinInstance({ envFrom+: envFrom }) else self.mixinInstance({ envFrom+: [envFrom] }),
          envFromType:: hidden.v1.EnvFromSource,
          // Docker image name. More info: https://kubernetes.io/docs/concepts/containers/images This field is optional to allow higher level config management to default or override container images in workload controllers like Deployments and StatefulSets.
          withImage(image):: self + self.mixinInstance({ image: image }),
          // Image pull policy. One of Always, Never, IfNotPresent. Defaults to Always if :latest tag is specified, or IfNotPresent otherwise. Cannot be updated. More info: https://kubernetes.io/docs/concepts/containers/images#updating-images
          withImagePullPolicy(imagePullPolicy):: self + self.mixinInstance({ imagePullPolicy: imagePullPolicy }),
          // Name of the container specified as a DNS_LABEL. Each container in a pod must have a unique name (DNS_LABEL). Cannot be updated.
          withName(name):: self + self.mixinInstance({ name: name }),
          // List of ports to expose from the container. Exposing a port here gives the system additional information about the network connections a container uses, but is primarily informational. Not specifying a port here DOES NOT prevent that port from being exposed. Any port which is listening on the default "0.0.0.0" address inside a container will be accessible from the network. Cannot be updated.
          withPorts(ports):: self + if std.type(ports) == 'array' then self.mixinInstance({ ports: ports }) else self.mixinInstance({ ports: [ports] }),
          // List of ports to expose from the container. Exposing a port here gives the system additional information about the network connections a container uses, but is primarily informational. Not specifying a port here DOES NOT prevent that port from being exposed. Any port which is listening on the default "0.0.0.0" address inside a container will be accessible from the network. Cannot be updated.
          withPortsMixin(ports):: self + if std.type(ports) == 'array' then self.mixinInstance({ ports+: ports }) else self.mixinInstance({ ports+: [ports] }),
          portsType:: hidden.v1.ContainerPort,
          // Whether this container should allocate a buffer for stdin in the container runtime. If this is not set, reads from stdin in the container will always result in EOF. Default is false.
          withStdin(stdin):: self + self.mixinInstance({ stdin: stdin }),
          // Whether the container runtime should close the stdin channel after it has been opened by a single attach. When stdin is true the stdin stream will remain open across multiple attach sessions. If stdinOnce is set to true, stdin is opened on container start, is empty until the first client attaches to stdin, and then remains open and accepts data until the client disconnects, at which time stdin is closed and remains closed until the container is restarted. If this flag is false, a container processes that reads from stdin will never receive an EOF. Default is false
          withStdinOnce(stdinOnce):: self + self.mixinInstance({ stdinOnce: stdinOnce }),
          // Optional: Path at which the file to which the container's termination message will be written is mounted into the container's filesystem. Message written is intended to be brief final status, such as an assertion failure message. Will be truncated by the node if greater than 4096 bytes. The total message length across all containers will be limited to 12kb. Defaults to /dev/termination-log. Cannot be updated.
          withTerminationMessagePath(terminationMessagePath):: self + self.mixinInstance({ terminationMessagePath: terminationMessagePath }),
          // Indicate how the termination message should be populated. File will use the contents of terminationMessagePath to populate the container status message on both success and failure. FallbackToLogsOnError will use the last chunk of container log output if the termination message file is empty and the container exited with an error. The log output is limited to 2048 bytes or 80 lines, whichever is smaller. Defaults to File. Cannot be updated.
          withTerminationMessagePolicy(terminationMessagePolicy):: self + self.mixinInstance({ terminationMessagePolicy: terminationMessagePolicy }),
          // Whether this container should allocate a TTY for itself, also requires 'stdin' to be true. Default is false.
          withTty(tty):: self + self.mixinInstance({ tty: tty }),
          // volumeDevices is the list of block devices to be used by the container. This is a beta feature.
          withVolumeDevices(volumeDevices):: self + if std.type(volumeDevices) == 'array' then self.mixinInstance({ volumeDevices: volumeDevices }) else self.mixinInstance({ volumeDevices: [volumeDevices] }),
          // volumeDevices is the list of block devices to be used by the container. This is a beta feature.
          withVolumeDevicesMixin(volumeDevices):: self + if std.type(volumeDevices) == 'array' then self.mixinInstance({ volumeDevices+: volumeDevices }) else self.mixinInstance({ volumeDevices+: [volumeDevices] }),
          volumeDevicesType:: hidden.v1.VolumeDevice,
          // Pod volumes to mount into the container's filesystem. Cannot be updated.
          withVolumeMounts(volumeMounts):: self + if std.type(volumeMounts) == 'array' then self.mixinInstance({ volumeMounts: volumeMounts }) else self.mixinInstance({ volumeMounts: [volumeMounts] }),
          // Pod volumes to mount into the container's filesystem. Cannot be updated.
          withVolumeMountsMixin(volumeMounts):: self + if std.type(volumeMounts) == 'array' then self.mixinInstance({ volumeMounts+: volumeMounts }) else self.mixinInstance({ volumeMounts+: [volumeMounts] }),
          volumeMountsType:: hidden.v1.VolumeMount,
          // Container's working directory. If not specified, the container runtime's default will be used, which might be configured in the container image. Cannot be updated.
          withWorkingDir(workingDir):: self + self.mixinInstance({ workingDir: workingDir }),
          mixin:: {
            // Actions that the management system should take in response to container lifecycle events. Cannot be updated.
            lifecycle:: {
              local __mixinLifecycle(lifecycle) = { lifecycle+: lifecycle },
              mixinInstance(lifecycle):: __mixinLifecycle(lifecycle),
              // PostStart is called immediately after a container is created. If the handler fails, the container is terminated and restarted according to its restart policy. Other management of the container blocks until the hook completes. More info: https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/#container-hooks
              postStart:: {
                local __mixinPostStart(postStart) = { postStart+: postStart },
                mixinInstance(postStart):: __mixinPostStart(postStart),
                // One and only one of the following should be specified. Exec specifies the action to take.
                exec:: {
                  local __mixinExec(exec) = { exec+: exec },
                  mixinInstance(exec):: __mixinExec(exec),
                  // Command is the command line to execute inside the container, the working directory for the command  is root ('/') in the container's filesystem. The command is simply exec'd, it is not run inside a shell, so traditional shell instructions ('|', etc) won't work. To use a shell, you need to explicitly call out to that shell. Exit status of 0 is treated as live/healthy and non-zero is unhealthy.
                  withCommand(command):: self + if std.type(command) == 'array' then self.mixinInstance({ command: command }) else self.mixinInstance({ command: [command] }),
                  // Command is the command line to execute inside the container, the working directory for the command  is root ('/') in the container's filesystem. The command is simply exec'd, it is not run inside a shell, so traditional shell instructions ('|', etc) won't work. To use a shell, you need to explicitly call out to that shell. Exit status of 0 is treated as live/healthy and non-zero is unhealthy.
                  withCommandMixin(command):: self + if std.type(command) == 'array' then self.mixinInstance({ command+: command }) else self.mixinInstance({ command+: [command] }),
                },
                // HTTPGet specifies the http request to perform.
                httpGet:: {
                  local __mixinHttpGet(httpGet) = { httpGet+: httpGet },
                  mixinInstance(httpGet):: __mixinHttpGet(httpGet),
                  // Host name to connect to, defaults to the pod IP. You probably want to set "Host" in httpHeaders instead.
                  withHost(host):: self + self.mixinInstance({ host: host }),
                  // Custom headers to set in the request. HTTP allows repeated headers.
                  withHttpHeaders(httpHeaders):: self + if std.type(httpHeaders) == 'array' then self.mixinInstance({ httpHeaders: httpHeaders }) else self.mixinInstance({ httpHeaders: [httpHeaders] }),
                  // Custom headers to set in the request. HTTP allows repeated headers.
                  withHttpHeadersMixin(httpHeaders):: self + if std.type(httpHeaders) == 'array' then self.mixinInstance({ httpHeaders+: httpHeaders }) else self.mixinInstance({ httpHeaders+: [httpHeaders] }),
                  httpHeadersType:: hidden.v1.HTTPHeader,
                  // Path to access on the HTTP server.
                  withPath(path):: self + self.mixinInstance({ path: path }),
                  // Name or number of the port to access on the container. Number must be in the range 1 to 65535. Name must be an IANA_SVC_NAME.
                  withPort(port):: self + self.mixinInstance({ port: port }),
                  // Scheme to use for connecting to the host. Defaults to HTTP.
                  withScheme(scheme):: self + self.mixinInstance({ scheme: scheme }),
                },
                // TCPSocket specifies an action involving a TCP port. TCP hooks not yet supported
                tcpSocket:: {
                  local __mixinTcpSocket(tcpSocket) = { tcpSocket+: tcpSocket },
                  mixinInstance(tcpSocket):: __mixinTcpSocket(tcpSocket),
                  // Optional: Host name to connect to, defaults to the pod IP.
                  withHost(host):: self + self.mixinInstance({ host: host }),
                  // Number or name of the port to access on the container. Number must be in the range 1 to 65535. Name must be an IANA_SVC_NAME.
                  withPort(port):: self + self.mixinInstance({ port: port }),
                },
              },
              // PreStop is called immediately before a container is terminated due to an API request or management event such as liveness/startup probe failure, preemption, resource contention, etc. The handler is not called if the container crashes or exits. The reason for termination is passed to the handler. The Pod's termination grace period countdown begins before the PreStop hooked is executed. Regardless of the outcome of the handler, the container will eventually terminate within the Pod's termination grace period. Other management of the container blocks until the hook completes or until the termination grace period is reached. More info: https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/#container-hooks
              preStop:: {
                local __mixinPreStop(preStop) = { preStop+: preStop },
                mixinInstance(preStop):: __mixinPreStop(preStop),
                // One and only one of the following should be specified. Exec specifies the action to take.
                exec:: {
                  local __mixinExec(exec) = { exec+: exec },
                  mixinInstance(exec):: __mixinExec(exec),
                  // Command is the command line to execute inside the container, the working directory for the command  is root ('/') in the container's filesystem. The command is simply exec'd, it is not run inside a shell, so traditional shell instructions ('|', etc) won't work. To use a shell, you need to explicitly call out to that shell. Exit status of 0 is treated as live/healthy and non-zero is unhealthy.
                  withCommand(command):: self + if std.type(command) == 'array' then self.mixinInstance({ command: command }) else self.mixinInstance({ command: [command] }),
                  // Command is the command line to execute inside the container, the working directory for the command  is root ('/') in the container's filesystem. The command is simply exec'd, it is not run inside a shell, so traditional shell instructions ('|', etc) won't work. To use a shell, you need to explicitly call out to that shell. Exit status of 0 is treated as live/healthy and non-zero is unhealthy.
                  withCommandMixin(command):: self + if std.type(command) == 'array' then self.mixinInstance({ command+: command }) else self.mixinInstance({ command+: [command] }),
                },
                // HTTPGet specifies the http request to perform.
                httpGet:: {
                  local __mixinHttpGet(httpGet) = { httpGet+: httpGet },
                  mixinInstance(httpGet):: __mixinHttpGet(httpGet),
                  // Host name to connect to, defaults to the pod IP. You probably want to set "Host" in httpHeaders instead.
                  withHost(host):: self + self.mixinInstance({ host: host }),
                  // Custom headers to set in the request. HTTP allows repeated headers.
                  withHttpHeaders(httpHeaders):: self + if std.type(httpHeaders) == 'array' then self.mixinInstance({ httpHeaders: httpHeaders }) else self.mixinInstance({ httpHeaders: [httpHeaders] }),
                  // Custom headers to set in the request. HTTP allows repeated headers.
                  withHttpHeadersMixin(httpHeaders):: self + if std.type(httpHeaders) == 'array' then self.mixinInstance({ httpHeaders+: httpHeaders }) else self.mixinInstance({ httpHeaders+: [httpHeaders] }),
                  httpHeadersType:: hidden.v1.HTTPHeader,
                  // Path to access on the HTTP server.
                  withPath(path):: self + self.mixinInstance({ path: path }),
                  // Name or number of the port to access on the container. Number must be in the range 1 to 65535. Name must be an IANA_SVC_NAME.
                  withPort(port):: self + self.mixinInstance({ port: port }),
                  // Scheme to use for connecting to the host. Defaults to HTTP.
                  withScheme(scheme):: self + self.mixinInstance({ scheme: scheme }),
                },
                // TCPSocket specifies an action involving a TCP port. TCP hooks not yet supported
                tcpSocket:: {
                  local __mixinTcpSocket(tcpSocket) = { tcpSocket+: tcpSocket },
                  mixinInstance(tcpSocket):: __mixinTcpSocket(tcpSocket),
                  // Optional: Host name to connect to, defaults to the pod IP.
                  withHost(host):: self + self.mixinInstance({ host: host }),
                  // Number or name of the port to access on the container. Number must be in the range 1 to 65535. Name must be an IANA_SVC_NAME.
                  withPort(port):: self + self.mixinInstance({ port: port }),
                },
              },
            },
            // Periodic probe of container liveness. Container will be restarted if the probe fails. Cannot be updated. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes
            livenessProbe:: {
              local __mixinLivenessProbe(livenessProbe) = { livenessProbe+: livenessProbe },
              mixinInstance(livenessProbe):: __mixinLivenessProbe(livenessProbe),
              // One and only one of the following should be specified. Exec specifies the action to take.
              exec:: {
                local __mixinExec(exec) = { exec+: exec },
                mixinInstance(exec):: __mixinExec(exec),
                // Command is the command line to execute inside the container, the working directory for the command  is root ('/') in the container's filesystem. The command is simply exec'd, it is not run inside a shell, so traditional shell instructions ('|', etc) won't work. To use a shell, you need to explicitly call out to that shell. Exit status of 0 is treated as live/healthy and non-zero is unhealthy.
                withCommand(command):: self + if std.type(command) == 'array' then self.mixinInstance({ command: command }) else self.mixinInstance({ command: [command] }),
                // Command is the command line to execute inside the container, the working directory for the command  is root ('/') in the container's filesystem. The command is simply exec'd, it is not run inside a shell, so traditional shell instructions ('|', etc) won't work. To use a shell, you need to explicitly call out to that shell. Exit status of 0 is treated as live/healthy and non-zero is unhealthy.
                withCommandMixin(command):: self + if std.type(command) == 'array' then self.mixinInstance({ command+: command }) else self.mixinInstance({ command+: [command] }),
              },
              // Minimum consecutive failures for the probe to be considered failed after having succeeded. Defaults to 3. Minimum value is 1.
              withFailureThreshold(failureThreshold):: self + self.mixinInstance({ failureThreshold: failureThreshold }),
              // HTTPGet specifies the http request to perform.
              httpGet:: {
                local __mixinHttpGet(httpGet) = { httpGet+: httpGet },
                mixinInstance(httpGet):: __mixinHttpGet(httpGet),
                // Host name to connect to, defaults to the pod IP. You probably want to set "Host" in httpHeaders instead.
                withHost(host):: self + self.mixinInstance({ host: host }),
                // Custom headers to set in the request. HTTP allows repeated headers.
                withHttpHeaders(httpHeaders):: self + if std.type(httpHeaders) == 'array' then self.mixinInstance({ httpHeaders: httpHeaders }) else self.mixinInstance({ httpHeaders: [httpHeaders] }),
                // Custom headers to set in the request. HTTP allows repeated headers.
                withHttpHeadersMixin(httpHeaders):: self + if std.type(httpHeaders) == 'array' then self.mixinInstance({ httpHeaders+: httpHeaders }) else self.mixinInstance({ httpHeaders+: [httpHeaders] }),
                httpHeadersType:: hidden.v1.HTTPHeader,
                // Path to access on the HTTP server.
                withPath(path):: self + self.mixinInstance({ path: path }),
                // Name or number of the port to access on the container. Number must be in the range 1 to 65535. Name must be an IANA_SVC_NAME.
                withPort(port):: self + self.mixinInstance({ port: port }),
                // Scheme to use for connecting to the host. Defaults to HTTP.
                withScheme(scheme):: self + self.mixinInstance({ scheme: scheme }),
              },
              // Number of seconds after the container has started before liveness probes are initiated. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes
              withInitialDelaySeconds(initialDelaySeconds):: self + self.mixinInstance({ initialDelaySeconds: initialDelaySeconds }),
              // How often (in seconds) to perform the probe. Default to 10 seconds. Minimum value is 1.
              withPeriodSeconds(periodSeconds):: self + self.mixinInstance({ periodSeconds: periodSeconds }),
              // Minimum consecutive successes for the probe to be considered successful after having failed. Defaults to 1. Must be 1 for liveness and startup. Minimum value is 1.
              withSuccessThreshold(successThreshold):: self + self.mixinInstance({ successThreshold: successThreshold }),
              // TCPSocket specifies an action involving a TCP port. TCP hooks not yet supported
              tcpSocket:: {
                local __mixinTcpSocket(tcpSocket) = { tcpSocket+: tcpSocket },
                mixinInstance(tcpSocket):: __mixinTcpSocket(tcpSocket),
                // Optional: Host name to connect to, defaults to the pod IP.
                withHost(host):: self + self.mixinInstance({ host: host }),
                // Number or name of the port to access on the container. Number must be in the range 1 to 65535. Name must be an IANA_SVC_NAME.
                withPort(port):: self + self.mixinInstance({ port: port }),
              },
              // Number of seconds after which the probe times out. Defaults to 1 second. Minimum value is 1. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes
              withTimeoutSeconds(timeoutSeconds):: self + self.mixinInstance({ timeoutSeconds: timeoutSeconds }),
            },
            // Periodic probe of container service readiness. Container will be removed from service endpoints if the probe fails. Cannot be updated. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes
            readinessProbe:: {
              local __mixinReadinessProbe(readinessProbe) = { readinessProbe+: readinessProbe },
              mixinInstance(readinessProbe):: __mixinReadinessProbe(readinessProbe),
              // One and only one of the following should be specified. Exec specifies the action to take.
              exec:: {
                local __mixinExec(exec) = { exec+: exec },
                mixinInstance(exec):: __mixinExec(exec),
                // Command is the command line to execute inside the container, the working directory for the command  is root ('/') in the container's filesystem. The command is simply exec'd, it is not run inside a shell, so traditional shell instructions ('|', etc) won't work. To use a shell, you need to explicitly call out to that shell. Exit status of 0 is treated as live/healthy and non-zero is unhealthy.
                withCommand(command):: self + if std.type(command) == 'array' then self.mixinInstance({ command: command }) else self.mixinInstance({ command: [command] }),
                // Command is the command line to execute inside the container, the working directory for the command  is root ('/') in the container's filesystem. The command is simply exec'd, it is not run inside a shell, so traditional shell instructions ('|', etc) won't work. To use a shell, you need to explicitly call out to that shell. Exit status of 0 is treated as live/healthy and non-zero is unhealthy.
                withCommandMixin(command):: self + if std.type(command) == 'array' then self.mixinInstance({ command+: command }) else self.mixinInstance({ command+: [command] }),
              },
              // Minimum consecutive failures for the probe to be considered failed after having succeeded. Defaults to 3. Minimum value is 1.
              withFailureThreshold(failureThreshold):: self + self.mixinInstance({ failureThreshold: failureThreshold }),
              // HTTPGet specifies the http request to perform.
              httpGet:: {
                local __mixinHttpGet(httpGet) = { httpGet+: httpGet },
                mixinInstance(httpGet):: __mixinHttpGet(httpGet),
                // Host name to connect to, defaults to the pod IP. You probably want to set "Host" in httpHeaders instead.
                withHost(host):: self + self.mixinInstance({ host: host }),
                // Custom headers to set in the request. HTTP allows repeated headers.
                withHttpHeaders(httpHeaders):: self + if std.type(httpHeaders) == 'array' then self.mixinInstance({ httpHeaders: httpHeaders }) else self.mixinInstance({ httpHeaders: [httpHeaders] }),
                // Custom headers to set in the request. HTTP allows repeated headers.
                withHttpHeadersMixin(httpHeaders):: self + if std.type(httpHeaders) == 'array' then self.mixinInstance({ httpHeaders+: httpHeaders }) else self.mixinInstance({ httpHeaders+: [httpHeaders] }),
                httpHeadersType:: hidden.v1.HTTPHeader,
                // Path to access on the HTTP server.
                withPath(path):: self + self.mixinInstance({ path: path }),
                // Name or number of the port to access on the container. Number must be in the range 1 to 65535. Name must be an IANA_SVC_NAME.
                withPort(port):: self + self.mixinInstance({ port: port }),
                // Scheme to use for connecting to the host. Defaults to HTTP.
                withScheme(scheme):: self + self.mixinInstance({ scheme: scheme }),
              },
              // Number of seconds after the container has started before liveness probes are initiated. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes
              withInitialDelaySeconds(initialDelaySeconds):: self + self.mixinInstance({ initialDelaySeconds: initialDelaySeconds }),
              // How often (in seconds) to perform the probe. Default to 10 seconds. Minimum value is 1.
              withPeriodSeconds(periodSeconds):: self + self.mixinInstance({ periodSeconds: periodSeconds }),
              // Minimum consecutive successes for the probe to be considered successful after having failed. Defaults to 1. Must be 1 for liveness and startup. Minimum value is 1.
              withSuccessThreshold(successThreshold):: self + self.mixinInstance({ successThreshold: successThreshold }),
              // TCPSocket specifies an action involving a TCP port. TCP hooks not yet supported
              tcpSocket:: {
                local __mixinTcpSocket(tcpSocket) = { tcpSocket+: tcpSocket },
                mixinInstance(tcpSocket):: __mixinTcpSocket(tcpSocket),
                // Optional: Host name to connect to, defaults to the pod IP.
                withHost(host):: self + self.mixinInstance({ host: host }),
                // Number or name of the port to access on the container. Number must be in the range 1 to 65535. Name must be an IANA_SVC_NAME.
                withPort(port):: self + self.mixinInstance({ port: port }),
              },
              // Number of seconds after which the probe times out. Defaults to 1 second. Minimum value is 1. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes
              withTimeoutSeconds(timeoutSeconds):: self + self.mixinInstance({ timeoutSeconds: timeoutSeconds }),
            },
            // Compute Resources required by this container. Cannot be updated. More info: https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/
            resources:: {
              local __mixinResources(resources) = { resources+: resources },
              mixinInstance(resources):: __mixinResources(resources),
              // Limits describes the maximum amount of compute resources allowed. More info: https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/
              withLimits(limits):: self + self.mixinInstance({ limits: limits }),
              // Requests describes the minimum amount of compute resources required. If Requests is omitted for a container, it defaults to Limits if that is explicitly specified, otherwise to an implementation-defined value. More info: https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/
              withRequests(requests):: self + self.mixinInstance({ requests: requests }),
            },
            // Security options the pod should run with. More info: https://kubernetes.io/docs/concepts/policy/security-context/ More info: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/
            securityContext:: {
              local __mixinSecurityContext(securityContext) = { securityContext+: securityContext },
              mixinInstance(securityContext):: __mixinSecurityContext(securityContext),
              // AllowPrivilegeEscalation controls whether a process can gain more privileges than its parent process. This bool directly controls if the no_new_privs flag will be set on the container process. AllowPrivilegeEscalation is true always when the container is: 1) run as Privileged 2) has CAP_SYS_ADMIN
              withAllowPrivilegeEscalation(allowPrivilegeEscalation):: self + self.mixinInstance({ allowPrivilegeEscalation: allowPrivilegeEscalation }),
              // The capabilities to add/drop when running containers. Defaults to the default set of capabilities granted by the container runtime.
              capabilities:: {
                local __mixinCapabilities(capabilities) = { capabilities+: capabilities },
                mixinInstance(capabilities):: __mixinCapabilities(capabilities),
                // Added capabilities
                withAdd(add):: self + if std.type(add) == 'array' then self.mixinInstance({ add: add }) else self.mixinInstance({ add: [add] }),
                // Added capabilities
                withAddMixin(add):: self + if std.type(add) == 'array' then self.mixinInstance({ add+: add }) else self.mixinInstance({ add+: [add] }),
                // Removed capabilities
                withDrop(drop):: self + if std.type(drop) == 'array' then self.mixinInstance({ drop: drop }) else self.mixinInstance({ drop: [drop] }),
                // Removed capabilities
                withDropMixin(drop):: self + if std.type(drop) == 'array' then self.mixinInstance({ drop+: drop }) else self.mixinInstance({ drop+: [drop] }),
              },
              // Run container in privileged mode. Processes in privileged containers are essentially equivalent to root on the host. Defaults to false.
              withPrivileged(privileged):: self + self.mixinInstance({ privileged: privileged }),
              // procMount denotes the type of proc mount to use for the containers. The default is DefaultProcMount which uses the container runtime defaults for readonly paths and masked paths. This requires the ProcMountType feature flag to be enabled.
              withProcMount(procMount):: self + self.mixinInstance({ procMount: procMount }),
              // Whether this container has a read-only root filesystem. Default is false.
              withReadOnlyRootFilesystem(readOnlyRootFilesystem):: self + self.mixinInstance({ readOnlyRootFilesystem: readOnlyRootFilesystem }),
              // The GID to run the entrypoint of the container process. Uses runtime default if unset. May also be set in PodSecurityContext.  If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence.
              withRunAsGroup(runAsGroup):: self + self.mixinInstance({ runAsGroup: runAsGroup }),
              // Indicates that the container must run as a non-root user. If true, the Kubelet will validate the image at runtime to ensure that it does not run as UID 0 (root) and fail to start the container if it does. If unset or false, no such validation will be performed. May also be set in PodSecurityContext.  If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence.
              withRunAsNonRoot(runAsNonRoot):: self + self.mixinInstance({ runAsNonRoot: runAsNonRoot }),
              // The UID to run the entrypoint of the container process. Defaults to user specified in image metadata if unspecified. May also be set in PodSecurityContext.  If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence.
              withRunAsUser(runAsUser):: self + self.mixinInstance({ runAsUser: runAsUser }),
              // The SELinux context to be applied to the container. If unspecified, the container runtime will allocate a random SELinux context for each container.  May also be set in PodSecurityContext.  If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence.
              seLinuxOptions:: {
                local __mixinSeLinuxOptions(seLinuxOptions) = { seLinuxOptions+: seLinuxOptions },
                mixinInstance(seLinuxOptions):: __mixinSeLinuxOptions(seLinuxOptions),
                // Level is SELinux level label that applies to the container.
                withLevel(level):: self + self.mixinInstance({ level: level }),
                // Role is a SELinux role label that applies to the container.
                withRole(role):: self + self.mixinInstance({ role: role }),
                // Type is a SELinux type label that applies to the container.
                withType(type):: self + self.mixinInstance({ type: type }),
                // User is a SELinux user label that applies to the container.
                withUser(user):: self + self.mixinInstance({ user: user }),
              },
              // The Windows specific settings applied to all containers. If unspecified, the options from the PodSecurityContext will be used. If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence.
              windowsOptions:: {
                local __mixinWindowsOptions(windowsOptions) = { windowsOptions+: windowsOptions },
                mixinInstance(windowsOptions):: __mixinWindowsOptions(windowsOptions),
                // GMSACredentialSpec is where the GMSA admission webhook (https://github.com/kubernetes-sigs/windows-gmsa) inlines the contents of the GMSA credential spec named by the GMSACredentialSpecName field. This field is alpha-level and is only honored by servers that enable the WindowsGMSA feature flag.
                withGmsaCredentialSpec(gmsaCredentialSpec):: self + self.mixinInstance({ gmsaCredentialSpec: gmsaCredentialSpec }),
                // GMSACredentialSpecName is the name of the GMSA credential spec to use. This field is alpha-level and is only honored by servers that enable the WindowsGMSA feature flag.
                withGmsaCredentialSpecName(gmsaCredentialSpecName):: self + self.mixinInstance({ gmsaCredentialSpecName: gmsaCredentialSpecName }),
                // The UserName in Windows to run the entrypoint of the container process. Defaults to the user specified in image metadata if unspecified. May also be set in PodSecurityContext. If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence. This field is beta-level and may be disabled with the WindowsRunAsUserName feature flag.
                withRunAsUserName(runAsUserName):: self + self.mixinInstance({ runAsUserName: runAsUserName }),
              },
            },
            // StartupProbe indicates that the Pod has successfully initialized. If specified, no other probes are executed until this completes successfully. If this probe fails, the Pod will be restarted, just as if the livenessProbe failed. This can be used to provide different probe parameters at the beginning of a Pod's lifecycle, when it might take a long time to load data or warm a cache, than during steady-state operation. This cannot be updated. This is an alpha feature enabled by the StartupProbe feature flag. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes
            startupProbe:: {
              local __mixinStartupProbe(startupProbe) = { startupProbe+: startupProbe },
              mixinInstance(startupProbe):: __mixinStartupProbe(startupProbe),
              // One and only one of the following should be specified. Exec specifies the action to take.
              exec:: {
                local __mixinExec(exec) = { exec+: exec },
                mixinInstance(exec):: __mixinExec(exec),
                // Command is the command line to execute inside the container, the working directory for the command  is root ('/') in the container's filesystem. The command is simply exec'd, it is not run inside a shell, so traditional shell instructions ('|', etc) won't work. To use a shell, you need to explicitly call out to that shell. Exit status of 0 is treated as live/healthy and non-zero is unhealthy.
                withCommand(command):: self + if std.type(command) == 'array' then self.mixinInstance({ command: command }) else self.mixinInstance({ command: [command] }),
                // Command is the command line to execute inside the container, the working directory for the command  is root ('/') in the container's filesystem. The command is simply exec'd, it is not run inside a shell, so traditional shell instructions ('|', etc) won't work. To use a shell, you need to explicitly call out to that shell. Exit status of 0 is treated as live/healthy and non-zero is unhealthy.
                withCommandMixin(command):: self + if std.type(command) == 'array' then self.mixinInstance({ command+: command }) else self.mixinInstance({ command+: [command] }),
              },
              // Minimum consecutive failures for the probe to be considered failed after having succeeded. Defaults to 3. Minimum value is 1.
              withFailureThreshold(failureThreshold):: self + self.mixinInstance({ failureThreshold: failureThreshold }),
              // HTTPGet specifies the http request to perform.
              httpGet:: {
                local __mixinHttpGet(httpGet) = { httpGet+: httpGet },
                mixinInstance(httpGet):: __mixinHttpGet(httpGet),
                // Host name to connect to, defaults to the pod IP. You probably want to set "Host" in httpHeaders instead.
                withHost(host):: self + self.mixinInstance({ host: host }),
                // Custom headers to set in the request. HTTP allows repeated headers.
                withHttpHeaders(httpHeaders):: self + if std.type(httpHeaders) == 'array' then self.mixinInstance({ httpHeaders: httpHeaders }) else self.mixinInstance({ httpHeaders: [httpHeaders] }),
                // Custom headers to set in the request. HTTP allows repeated headers.
                withHttpHeadersMixin(httpHeaders):: self + if std.type(httpHeaders) == 'array' then self.mixinInstance({ httpHeaders+: httpHeaders }) else self.mixinInstance({ httpHeaders+: [httpHeaders] }),
                httpHeadersType:: hidden.v1.HTTPHeader,
                // Path to access on the HTTP server.
                withPath(path):: self + self.mixinInstance({ path: path }),
                // Name or number of the port to access on the container. Number must be in the range 1 to 65535. Name must be an IANA_SVC_NAME.
                withPort(port):: self + self.mixinInstance({ port: port }),
                // Scheme to use for connecting to the host. Defaults to HTTP.
                withScheme(scheme):: self + self.mixinInstance({ scheme: scheme }),
              },
              // Number of seconds after the container has started before liveness probes are initiated. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes
              withInitialDelaySeconds(initialDelaySeconds):: self + self.mixinInstance({ initialDelaySeconds: initialDelaySeconds }),
              // How often (in seconds) to perform the probe. Default to 10 seconds. Minimum value is 1.
              withPeriodSeconds(periodSeconds):: self + self.mixinInstance({ periodSeconds: periodSeconds }),
              // Minimum consecutive successes for the probe to be considered successful after having failed. Defaults to 1. Must be 1 for liveness and startup. Minimum value is 1.
              withSuccessThreshold(successThreshold):: self + self.mixinInstance({ successThreshold: successThreshold }),
              // TCPSocket specifies an action involving a TCP port. TCP hooks not yet supported
              tcpSocket:: {
                local __mixinTcpSocket(tcpSocket) = { tcpSocket+: tcpSocket },
                mixinInstance(tcpSocket):: __mixinTcpSocket(tcpSocket),
                // Optional: Host name to connect to, defaults to the pod IP.
                withHost(host):: self + self.mixinInstance({ host: host }),
                // Number or name of the port to access on the container. Number must be in the range 1 to 65535. Name must be an IANA_SVC_NAME.
                withPort(port):: self + self.mixinInstance({ port: port }),
              },
              // Number of seconds after which the probe times out. Defaults to 1 second. Minimum value is 1. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes
              withTimeoutSeconds(timeoutSeconds):: self + self.mixinInstance({ timeoutSeconds: timeoutSeconds }),
            },
          },
        },
        // ContainerStateRunning is a running state of a container.
        containerStateRunning:: {
          local kind = { kind: 'ContainerStateRunning' },
          mixin:: {
            // Time at which the container was last (re-)started
            withStartedAt(startedAt):: self + self.mixinInstance({ startedAt: startedAt }),
          },
        },
        // Represents downward API info for projecting into a projected volume. Note that this is identical to a downwardAPI volume source without the default mode.
        downwardAPIProjection:: {
          local kind = { kind: 'DownwardAPIProjection' },
          // Items is a list of DownwardAPIVolume file
          withItems(items):: self + if std.type(items) == 'array' then self.mixinInstance({ items: items }) else self.mixinInstance({ items: [items] }),
          // Items is a list of DownwardAPIVolume file
          withItemsMixin(items):: self + if std.type(items) == 'array' then self.mixinInstance({ items+: items }) else self.mixinInstance({ items+: [items] }),
          itemsType:: hidden.v1.DownwardAPIVolumeFile,
          mixin:: {},
        },
        // Represents a host path mapped into a pod. Host path volumes do not support ownership management or SELinux relabeling.
        hostPathVolumeSource:: {
          local kind = { kind: 'HostPathVolumeSource' },
          // Path of the directory on the host. If the path is a symlink, it will follow the link to the real path. More info: https://kubernetes.io/docs/concepts/storage/volumes#hostpath
          withPath(path):: self + self.mixinInstance({ path: path }),
          // Type for HostPath Volume Defaults to "" More info: https://kubernetes.io/docs/concepts/storage/volumes#hostpath
          withType(type):: self + self.mixinInstance({ type: type }),
          mixin:: {},
        },
        // Defines a set of pods (namely those matching the labelSelector relative to the given namespace(s)) that this pod should be co-located (affinity) or not co-located (anti-affinity) with, where co-located is defined as running on a node whose value of the label with key <topologyKey> matches that of any node on which a pod of the set of pods is running
        podAffinityTerm:: {
          local kind = { kind: 'PodAffinityTerm' },
          // namespaces specifies which namespaces the labelSelector applies to (matches against); null or empty list means "this pod's namespace"
          withNamespaces(namespaces):: self + if std.type(namespaces) == 'array' then self.mixinInstance({ namespaces: namespaces }) else self.mixinInstance({ namespaces: [namespaces] }),
          // namespaces specifies which namespaces the labelSelector applies to (matches against); null or empty list means "this pod's namespace"
          withNamespacesMixin(namespaces):: self + if std.type(namespaces) == 'array' then self.mixinInstance({ namespaces+: namespaces }) else self.mixinInstance({ namespaces+: [namespaces] }),
          // This pod should be co-located (affinity) or not co-located (anti-affinity) with the pods matching the labelSelector in the specified namespaces, where co-located is defined as running on a node whose value of the label with key topologyKey matches that of any node on which any of the selected pods is running. Empty topologyKey is not allowed.
          withTopologyKey(topologyKey):: self + self.mixinInstance({ topologyKey: topologyKey }),
          mixin:: {
            // A label query over a set of resources, in this case pods.
            labelSelector:: {
              local __mixinLabelSelector(labelSelector) = { labelSelector+: labelSelector },
              mixinInstance(labelSelector):: __mixinLabelSelector(labelSelector),
              // matchExpressions is a list of label selector requirements. The requirements are ANDed.
              withMatchExpressions(matchExpressions):: self + if std.type(matchExpressions) == 'array' then self.mixinInstance({ matchExpressions: matchExpressions }) else self.mixinInstance({ matchExpressions: [matchExpressions] }),
              // matchExpressions is a list of label selector requirements. The requirements are ANDed.
              withMatchExpressionsMixin(matchExpressions):: self + if std.type(matchExpressions) == 'array' then self.mixinInstance({ matchExpressions+: matchExpressions }) else self.mixinInstance({ matchExpressions+: [matchExpressions] }),
              matchExpressionsType:: hidden.meta.v1.LabelSelectorRequirement,
              // matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels map is equivalent to an element of matchExpressions, whose key field is "key", the operator is "In", and the values array contains only "value". The requirements are ANDed.
              withMatchLabels(matchLabels):: self + self.mixinInstance({ matchLabels: matchLabels }),
            },
          },
        },
        // PodCondition contains details for the current condition of this pod.
        podCondition:: {
          local kind = { kind: 'PodCondition' },
          // Human-readable message indicating details about last transition.
          withMessage(message):: self + self.mixinInstance({ message: message }),
          // Unique, one-word, CamelCase reason for the condition's last transition.
          withReason(reason):: self + self.mixinInstance({ reason: reason }),
          // Status is the status of the condition. Can be True, False, Unknown. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#pod-conditions
          withStatus(status):: self + self.mixinInstance({ status: status }),
          // Type is the type of the condition. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#pod-conditions
          withType(type):: self + self.mixinInstance({ type: type }),
          mixin:: {
            // Last time we probed the condition.
            withLastProbeTime(lastProbeTime):: self + self.mixinInstance({ lastProbeTime: lastProbeTime }),
            // Last time the condition transitioned from one status to another.
            withLastTransitionTime(lastTransitionTime):: self + self.mixinInstance({ lastTransitionTime: lastTransitionTime }),
          },
        },
        // IP address information for entries in the (plural) PodIPs field. Each entry includes:
        // IP: An IP address allocated to the pod. Routable at least within the cluster.
        podIP:: {
          local kind = { kind: 'PodIP' },
          // ip is an IP address (IPv4 or IPv6) assigned to the pod
          withIp(ip):: self + self.mixinInstance({ ip: ip }),
          mixin:: {},
        },
        // Represents a Persistent Disk resource in AWS.
        //
        // An AWS EBS disk must exist before mounting to a container. The disk must also be in the same AWS zone as the kubelet. An AWS EBS disk can only be mounted as read/write once. AWS EBS volumes support ownership management and SELinux relabeling.
        awsElasticBlockStoreVolumeSource:: {
          local kind = { kind: 'AWSElasticBlockStoreVolumeSource' },
          // Filesystem type of the volume that you want to mount. Tip: Ensure that the filesystem type is supported by the host operating system. Examples: "ext4", "xfs", "ntfs". Implicitly inferred to be "ext4" if unspecified. More info: https://kubernetes.io/docs/concepts/storage/volumes#awselasticblockstore
          withFsType(fsType):: self + self.mixinInstance({ fsType: fsType }),
          // The partition in the volume that you want to mount. If omitted, the default is to mount by volume name. Examples: For volume /dev/sda1, you specify the partition as "1". Similarly, the volume partition for /dev/sda is "0" (or you can leave the property empty).
          withPartition(partition):: self + self.mixinInstance({ partition: partition }),
          // Specify "true" to force and set the ReadOnly property in VolumeMounts to "true". If omitted, the default is "false". More info: https://kubernetes.io/docs/concepts/storage/volumes#awselasticblockstore
          withReadOnly(readOnly):: self + self.mixinInstance({ readOnly: readOnly }),
          // Unique ID of the persistent disk resource in AWS (Amazon EBS volume). More info: https://kubernetes.io/docs/concepts/storage/volumes#awselasticblockstore
          withVolumeID(volumeID):: self + self.mixinInstance({ volumeID: volumeID }),
          mixin:: {},
        },
        // volumeDevice describes a mapping of a raw block device within a container.
        volumeDevice:: {
          local kind = { kind: 'VolumeDevice' },
          // devicePath is the path inside of the container that the device will be mapped to.
          withDevicePath(devicePath):: self + self.mixinInstance({ devicePath: devicePath }),
          // name must match the name of a persistentVolumeClaim in the pod
          withName(name):: self + self.mixinInstance({ name: name }),
          mixin:: {},
        },
        // Represents a vSphere volume resource.
        vsphereVirtualDiskVolumeSource:: {
          local kind = { kind: 'VsphereVirtualDiskVolumeSource' },
          // Filesystem type to mount. Must be a filesystem type supported by the host operating system. Ex. "ext4", "xfs", "ntfs". Implicitly inferred to be "ext4" if unspecified.
          withFsType(fsType):: self + self.mixinInstance({ fsType: fsType }),
          // Storage Policy Based Management (SPBM) profile ID associated with the StoragePolicyName.
          withStoragePolicyID(storagePolicyID):: self + self.mixinInstance({ storagePolicyID: storagePolicyID }),
          // Storage Policy Based Management (SPBM) profile name.
          withStoragePolicyName(storagePolicyName):: self + self.mixinInstance({ storagePolicyName: storagePolicyName }),
          // Path that identifies vSphere volume vmdk
          withVolumePath(volumePath):: self + self.mixinInstance({ volumePath: volumePath }),
          mixin:: {},
        },
        // SecretEnvSource selects a Secret to populate the environment variables with.
        //
        // The contents of the target Secret's Data field will represent the key-value pairs as environment variables.
        secretEnvSource:: {
          local kind = { kind: 'SecretEnvSource' },
          // Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
          withName(name):: self + self.mixinInstance({ name: name }),
          // Specify whether the Secret must be defined
          withOptional(optional):: self + self.mixinInstance({ optional: optional }),
          mixin:: {},
        },
        // An EphemeralContainer is a container that may be added temporarily to an existing pod for user-initiated activities such as debugging. Ephemeral containers have no resource or scheduling guarantees, and they will not be restarted when they exit or when a pod is removed or restarted. If an ephemeral container causes a pod to exceed its resource allocation, the pod may be evicted. Ephemeral containers may not be added by directly updating the pod spec. They must be added via the pod's ephemeralcontainers subresource, and they will appear in the pod spec once added. This is an alpha feature enabled by the EphemeralContainers feature flag.
        ephemeralContainer:: {
          local kind = { kind: 'EphemeralContainer' },
          // Arguments to the entrypoint. The docker image's CMD is used if this is not provided. Variable references $(VAR_NAME) are expanded using the container's environment. If a variable cannot be resolved, the reference in the input string will be unchanged. The $(VAR_NAME) syntax can be escaped with a double $$, ie: $$(VAR_NAME). Escaped references will never be expanded, regardless of whether the variable exists or not. Cannot be updated. More info: https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/#running-a-command-in-a-shell
          withArgs(args):: self + if std.type(args) == 'array' then self.mixinInstance({ args: args }) else self.mixinInstance({ args: [args] }),
          // Arguments to the entrypoint. The docker image's CMD is used if this is not provided. Variable references $(VAR_NAME) are expanded using the container's environment. If a variable cannot be resolved, the reference in the input string will be unchanged. The $(VAR_NAME) syntax can be escaped with a double $$, ie: $$(VAR_NAME). Escaped references will never be expanded, regardless of whether the variable exists or not. Cannot be updated. More info: https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/#running-a-command-in-a-shell
          withArgsMixin(args):: self + if std.type(args) == 'array' then self.mixinInstance({ args+: args }) else self.mixinInstance({ args+: [args] }),
          // Entrypoint array. Not executed within a shell. The docker image's ENTRYPOINT is used if this is not provided. Variable references $(VAR_NAME) are expanded using the container's environment. If a variable cannot be resolved, the reference in the input string will be unchanged. The $(VAR_NAME) syntax can be escaped with a double $$, ie: $$(VAR_NAME). Escaped references will never be expanded, regardless of whether the variable exists or not. Cannot be updated. More info: https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/#running-a-command-in-a-shell
          withCommand(command):: self + if std.type(command) == 'array' then self.mixinInstance({ command: command }) else self.mixinInstance({ command: [command] }),
          // Entrypoint array. Not executed within a shell. The docker image's ENTRYPOINT is used if this is not provided. Variable references $(VAR_NAME) are expanded using the container's environment. If a variable cannot be resolved, the reference in the input string will be unchanged. The $(VAR_NAME) syntax can be escaped with a double $$, ie: $$(VAR_NAME). Escaped references will never be expanded, regardless of whether the variable exists or not. Cannot be updated. More info: https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/#running-a-command-in-a-shell
          withCommandMixin(command):: self + if std.type(command) == 'array' then self.mixinInstance({ command+: command }) else self.mixinInstance({ command+: [command] }),
          // List of environment variables to set in the container. Cannot be updated.
          withEnv(env):: self + if std.type(env) == 'array' then self.mixinInstance({ env: env }) else self.mixinInstance({ env: [env] }),
          // List of environment variables to set in the container. Cannot be updated.
          withEnvMixin(env):: self + if std.type(env) == 'array' then self.mixinInstance({ env+: env }) else self.mixinInstance({ env+: [env] }),
          envType:: hidden.v1.EnvVar,
          // List of sources to populate environment variables in the container. The keys defined within a source must be a C_IDENTIFIER. All invalid keys will be reported as an event when the container is starting. When a key exists in multiple sources, the value associated with the last source will take precedence. Values defined by an Env with a duplicate key will take precedence. Cannot be updated.
          withEnvFrom(envFrom):: self + if std.type(envFrom) == 'array' then self.mixinInstance({ envFrom: envFrom }) else self.mixinInstance({ envFrom: [envFrom] }),
          // List of sources to populate environment variables in the container. The keys defined within a source must be a C_IDENTIFIER. All invalid keys will be reported as an event when the container is starting. When a key exists in multiple sources, the value associated with the last source will take precedence. Values defined by an Env with a duplicate key will take precedence. Cannot be updated.
          withEnvFromMixin(envFrom):: self + if std.type(envFrom) == 'array' then self.mixinInstance({ envFrom+: envFrom }) else self.mixinInstance({ envFrom+: [envFrom] }),
          envFromType:: hidden.v1.EnvFromSource,
          // Docker image name. More info: https://kubernetes.io/docs/concepts/containers/images
          withImage(image):: self + self.mixinInstance({ image: image }),
          // Image pull policy. One of Always, Never, IfNotPresent. Defaults to Always if :latest tag is specified, or IfNotPresent otherwise. Cannot be updated. More info: https://kubernetes.io/docs/concepts/containers/images#updating-images
          withImagePullPolicy(imagePullPolicy):: self + self.mixinInstance({ imagePullPolicy: imagePullPolicy }),
          // Name of the ephemeral container specified as a DNS_LABEL. This name must be unique among all containers, init containers and ephemeral containers.
          withName(name):: self + self.mixinInstance({ name: name }),
          // Ports are not allowed for ephemeral containers.
          withPorts(ports):: self + if std.type(ports) == 'array' then self.mixinInstance({ ports: ports }) else self.mixinInstance({ ports: [ports] }),
          // Ports are not allowed for ephemeral containers.
          withPortsMixin(ports):: self + if std.type(ports) == 'array' then self.mixinInstance({ ports+: ports }) else self.mixinInstance({ ports+: [ports] }),
          portsType:: hidden.v1.ContainerPort,
          // Whether this container should allocate a buffer for stdin in the container runtime. If this is not set, reads from stdin in the container will always result in EOF. Default is false.
          withStdin(stdin):: self + self.mixinInstance({ stdin: stdin }),
          // Whether the container runtime should close the stdin channel after it has been opened by a single attach. When stdin is true the stdin stream will remain open across multiple attach sessions. If stdinOnce is set to true, stdin is opened on container start, is empty until the first client attaches to stdin, and then remains open and accepts data until the client disconnects, at which time stdin is closed and remains closed until the container is restarted. If this flag is false, a container processes that reads from stdin will never receive an EOF. Default is false
          withStdinOnce(stdinOnce):: self + self.mixinInstance({ stdinOnce: stdinOnce }),
          // If set, the name of the container from PodSpec that this ephemeral container targets. The ephemeral container will be run in the namespaces (IPC, PID, etc) of this container. If not set then the ephemeral container is run in whatever namespaces are shared for the pod. Note that the container runtime must support this feature.
          withTargetContainerName(targetContainerName):: self + self.mixinInstance({ targetContainerName: targetContainerName }),
          // Optional: Path at which the file to which the container's termination message will be written is mounted into the container's filesystem. Message written is intended to be brief final status, such as an assertion failure message. Will be truncated by the node if greater than 4096 bytes. The total message length across all containers will be limited to 12kb. Defaults to /dev/termination-log. Cannot be updated.
          withTerminationMessagePath(terminationMessagePath):: self + self.mixinInstance({ terminationMessagePath: terminationMessagePath }),
          // Indicate how the termination message should be populated. File will use the contents of terminationMessagePath to populate the container status message on both success and failure. FallbackToLogsOnError will use the last chunk of container log output if the termination message file is empty and the container exited with an error. The log output is limited to 2048 bytes or 80 lines, whichever is smaller. Defaults to File. Cannot be updated.
          withTerminationMessagePolicy(terminationMessagePolicy):: self + self.mixinInstance({ terminationMessagePolicy: terminationMessagePolicy }),
          // Whether this container should allocate a TTY for itself, also requires 'stdin' to be true. Default is false.
          withTty(tty):: self + self.mixinInstance({ tty: tty }),
          // volumeDevices is the list of block devices to be used by the container. This is a beta feature.
          withVolumeDevices(volumeDevices):: self + if std.type(volumeDevices) == 'array' then self.mixinInstance({ volumeDevices: volumeDevices }) else self.mixinInstance({ volumeDevices: [volumeDevices] }),
          // volumeDevices is the list of block devices to be used by the container. This is a beta feature.
          withVolumeDevicesMixin(volumeDevices):: self + if std.type(volumeDevices) == 'array' then self.mixinInstance({ volumeDevices+: volumeDevices }) else self.mixinInstance({ volumeDevices+: [volumeDevices] }),
          volumeDevicesType:: hidden.v1.VolumeDevice,
          // Pod volumes to mount into the container's filesystem. Cannot be updated.
          withVolumeMounts(volumeMounts):: self + if std.type(volumeMounts) == 'array' then self.mixinInstance({ volumeMounts: volumeMounts }) else self.mixinInstance({ volumeMounts: [volumeMounts] }),
          // Pod volumes to mount into the container's filesystem. Cannot be updated.
          withVolumeMountsMixin(volumeMounts):: self + if std.type(volumeMounts) == 'array' then self.mixinInstance({ volumeMounts+: volumeMounts }) else self.mixinInstance({ volumeMounts+: [volumeMounts] }),
          volumeMountsType:: hidden.v1.VolumeMount,
          // Container's working directory. If not specified, the container runtime's default will be used, which might be configured in the container image. Cannot be updated.
          withWorkingDir(workingDir):: self + self.mixinInstance({ workingDir: workingDir }),
          mixin:: {
            // Lifecycle is not allowed for ephemeral containers.
            lifecycle:: {
              local __mixinLifecycle(lifecycle) = { lifecycle+: lifecycle },
              mixinInstance(lifecycle):: __mixinLifecycle(lifecycle),
              // PostStart is called immediately after a container is created. If the handler fails, the container is terminated and restarted according to its restart policy. Other management of the container blocks until the hook completes. More info: https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/#container-hooks
              postStart:: {
                local __mixinPostStart(postStart) = { postStart+: postStart },
                mixinInstance(postStart):: __mixinPostStart(postStart),
                // One and only one of the following should be specified. Exec specifies the action to take.
                exec:: {
                  local __mixinExec(exec) = { exec+: exec },
                  mixinInstance(exec):: __mixinExec(exec),
                  // Command is the command line to execute inside the container, the working directory for the command  is root ('/') in the container's filesystem. The command is simply exec'd, it is not run inside a shell, so traditional shell instructions ('|', etc) won't work. To use a shell, you need to explicitly call out to that shell. Exit status of 0 is treated as live/healthy and non-zero is unhealthy.
                  withCommand(command):: self + if std.type(command) == 'array' then self.mixinInstance({ command: command }) else self.mixinInstance({ command: [command] }),
                  // Command is the command line to execute inside the container, the working directory for the command  is root ('/') in the container's filesystem. The command is simply exec'd, it is not run inside a shell, so traditional shell instructions ('|', etc) won't work. To use a shell, you need to explicitly call out to that shell. Exit status of 0 is treated as live/healthy and non-zero is unhealthy.
                  withCommandMixin(command):: self + if std.type(command) == 'array' then self.mixinInstance({ command+: command }) else self.mixinInstance({ command+: [command] }),
                },
                // HTTPGet specifies the http request to perform.
                httpGet:: {
                  local __mixinHttpGet(httpGet) = { httpGet+: httpGet },
                  mixinInstance(httpGet):: __mixinHttpGet(httpGet),
                  // Host name to connect to, defaults to the pod IP. You probably want to set "Host" in httpHeaders instead.
                  withHost(host):: self + self.mixinInstance({ host: host }),
                  // Custom headers to set in the request. HTTP allows repeated headers.
                  withHttpHeaders(httpHeaders):: self + if std.type(httpHeaders) == 'array' then self.mixinInstance({ httpHeaders: httpHeaders }) else self.mixinInstance({ httpHeaders: [httpHeaders] }),
                  // Custom headers to set in the request. HTTP allows repeated headers.
                  withHttpHeadersMixin(httpHeaders):: self + if std.type(httpHeaders) == 'array' then self.mixinInstance({ httpHeaders+: httpHeaders }) else self.mixinInstance({ httpHeaders+: [httpHeaders] }),
                  httpHeadersType:: hidden.v1.HTTPHeader,
                  // Path to access on the HTTP server.
                  withPath(path):: self + self.mixinInstance({ path: path }),
                  // Name or number of the port to access on the container. Number must be in the range 1 to 65535. Name must be an IANA_SVC_NAME.
                  withPort(port):: self + self.mixinInstance({ port: port }),
                  // Scheme to use for connecting to the host. Defaults to HTTP.
                  withScheme(scheme):: self + self.mixinInstance({ scheme: scheme }),
                },
                // TCPSocket specifies an action involving a TCP port. TCP hooks not yet supported
                tcpSocket:: {
                  local __mixinTcpSocket(tcpSocket) = { tcpSocket+: tcpSocket },
                  mixinInstance(tcpSocket):: __mixinTcpSocket(tcpSocket),
                  // Optional: Host name to connect to, defaults to the pod IP.
                  withHost(host):: self + self.mixinInstance({ host: host }),
                  // Number or name of the port to access on the container. Number must be in the range 1 to 65535. Name must be an IANA_SVC_NAME.
                  withPort(port):: self + self.mixinInstance({ port: port }),
                },
              },
              // PreStop is called immediately before a container is terminated due to an API request or management event such as liveness/startup probe failure, preemption, resource contention, etc. The handler is not called if the container crashes or exits. The reason for termination is passed to the handler. The Pod's termination grace period countdown begins before the PreStop hooked is executed. Regardless of the outcome of the handler, the container will eventually terminate within the Pod's termination grace period. Other management of the container blocks until the hook completes or until the termination grace period is reached. More info: https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/#container-hooks
              preStop:: {
                local __mixinPreStop(preStop) = { preStop+: preStop },
                mixinInstance(preStop):: __mixinPreStop(preStop),
                // One and only one of the following should be specified. Exec specifies the action to take.
                exec:: {
                  local __mixinExec(exec) = { exec+: exec },
                  mixinInstance(exec):: __mixinExec(exec),
                  // Command is the command line to execute inside the container, the working directory for the command  is root ('/') in the container's filesystem. The command is simply exec'd, it is not run inside a shell, so traditional shell instructions ('|', etc) won't work. To use a shell, you need to explicitly call out to that shell. Exit status of 0 is treated as live/healthy and non-zero is unhealthy.
                  withCommand(command):: self + if std.type(command) == 'array' then self.mixinInstance({ command: command }) else self.mixinInstance({ command: [command] }),
                  // Command is the command line to execute inside the container, the working directory for the command  is root ('/') in the container's filesystem. The command is simply exec'd, it is not run inside a shell, so traditional shell instructions ('|', etc) won't work. To use a shell, you need to explicitly call out to that shell. Exit status of 0 is treated as live/healthy and non-zero is unhealthy.
                  withCommandMixin(command):: self + if std.type(command) == 'array' then self.mixinInstance({ command+: command }) else self.mixinInstance({ command+: [command] }),
                },
                // HTTPGet specifies the http request to perform.
                httpGet:: {
                  local __mixinHttpGet(httpGet) = { httpGet+: httpGet },
                  mixinInstance(httpGet):: __mixinHttpGet(httpGet),
                  // Host name to connect to, defaults to the pod IP. You probably want to set "Host" in httpHeaders instead.
                  withHost(host):: self + self.mixinInstance({ host: host }),
                  // Custom headers to set in the request. HTTP allows repeated headers.
                  withHttpHeaders(httpHeaders):: self + if std.type(httpHeaders) == 'array' then self.mixinInstance({ httpHeaders: httpHeaders }) else self.mixinInstance({ httpHeaders: [httpHeaders] }),
                  // Custom headers to set in the request. HTTP allows repeated headers.
                  withHttpHeadersMixin(httpHeaders):: self + if std.type(httpHeaders) == 'array' then self.mixinInstance({ httpHeaders+: httpHeaders }) else self.mixinInstance({ httpHeaders+: [httpHeaders] }),
                  httpHeadersType:: hidden.v1.HTTPHeader,
                  // Path to access on the HTTP server.
                  withPath(path):: self + self.mixinInstance({ path: path }),
                  // Name or number of the port to access on the container. Number must be in the range 1 to 65535. Name must be an IANA_SVC_NAME.
                  withPort(port):: self + self.mixinInstance({ port: port }),
                  // Scheme to use for connecting to the host. Defaults to HTTP.
                  withScheme(scheme):: self + self.mixinInstance({ scheme: scheme }),
                },
                // TCPSocket specifies an action involving a TCP port. TCP hooks not yet supported
                tcpSocket:: {
                  local __mixinTcpSocket(tcpSocket) = { tcpSocket+: tcpSocket },
                  mixinInstance(tcpSocket):: __mixinTcpSocket(tcpSocket),
                  // Optional: Host name to connect to, defaults to the pod IP.
                  withHost(host):: self + self.mixinInstance({ host: host }),
                  // Number or name of the port to access on the container. Number must be in the range 1 to 65535. Name must be an IANA_SVC_NAME.
                  withPort(port):: self + self.mixinInstance({ port: port }),
                },
              },
            },
            // Probes are not allowed for ephemeral containers.
            livenessProbe:: {
              local __mixinLivenessProbe(livenessProbe) = { livenessProbe+: livenessProbe },
              mixinInstance(livenessProbe):: __mixinLivenessProbe(livenessProbe),
              // One and only one of the following should be specified. Exec specifies the action to take.
              exec:: {
                local __mixinExec(exec) = { exec+: exec },
                mixinInstance(exec):: __mixinExec(exec),
                // Command is the command line to execute inside the container, the working directory for the command  is root ('/') in the container's filesystem. The command is simply exec'd, it is not run inside a shell, so traditional shell instructions ('|', etc) won't work. To use a shell, you need to explicitly call out to that shell. Exit status of 0 is treated as live/healthy and non-zero is unhealthy.
                withCommand(command):: self + if std.type(command) == 'array' then self.mixinInstance({ command: command }) else self.mixinInstance({ command: [command] }),
                // Command is the command line to execute inside the container, the working directory for the command  is root ('/') in the container's filesystem. The command is simply exec'd, it is not run inside a shell, so traditional shell instructions ('|', etc) won't work. To use a shell, you need to explicitly call out to that shell. Exit status of 0 is treated as live/healthy and non-zero is unhealthy.
                withCommandMixin(command):: self + if std.type(command) == 'array' then self.mixinInstance({ command+: command }) else self.mixinInstance({ command+: [command] }),
              },
              // Minimum consecutive failures for the probe to be considered failed after having succeeded. Defaults to 3. Minimum value is 1.
              withFailureThreshold(failureThreshold):: self + self.mixinInstance({ failureThreshold: failureThreshold }),
              // HTTPGet specifies the http request to perform.
              httpGet:: {
                local __mixinHttpGet(httpGet) = { httpGet+: httpGet },
                mixinInstance(httpGet):: __mixinHttpGet(httpGet),
                // Host name to connect to, defaults to the pod IP. You probably want to set "Host" in httpHeaders instead.
                withHost(host):: self + self.mixinInstance({ host: host }),
                // Custom headers to set in the request. HTTP allows repeated headers.
                withHttpHeaders(httpHeaders):: self + if std.type(httpHeaders) == 'array' then self.mixinInstance({ httpHeaders: httpHeaders }) else self.mixinInstance({ httpHeaders: [httpHeaders] }),
                // Custom headers to set in the request. HTTP allows repeated headers.
                withHttpHeadersMixin(httpHeaders):: self + if std.type(httpHeaders) == 'array' then self.mixinInstance({ httpHeaders+: httpHeaders }) else self.mixinInstance({ httpHeaders+: [httpHeaders] }),
                httpHeadersType:: hidden.v1.HTTPHeader,
                // Path to access on the HTTP server.
                withPath(path):: self + self.mixinInstance({ path: path }),
                // Name or number of the port to access on the container. Number must be in the range 1 to 65535. Name must be an IANA_SVC_NAME.
                withPort(port):: self + self.mixinInstance({ port: port }),
                // Scheme to use for connecting to the host. Defaults to HTTP.
                withScheme(scheme):: self + self.mixinInstance({ scheme: scheme }),
              },
              // Number of seconds after the container has started before liveness probes are initiated. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes
              withInitialDelaySeconds(initialDelaySeconds):: self + self.mixinInstance({ initialDelaySeconds: initialDelaySeconds }),
              // How often (in seconds) to perform the probe. Default to 10 seconds. Minimum value is 1.
              withPeriodSeconds(periodSeconds):: self + self.mixinInstance({ periodSeconds: periodSeconds }),
              // Minimum consecutive successes for the probe to be considered successful after having failed. Defaults to 1. Must be 1 for liveness and startup. Minimum value is 1.
              withSuccessThreshold(successThreshold):: self + self.mixinInstance({ successThreshold: successThreshold }),
              // TCPSocket specifies an action involving a TCP port. TCP hooks not yet supported
              tcpSocket:: {
                local __mixinTcpSocket(tcpSocket) = { tcpSocket+: tcpSocket },
                mixinInstance(tcpSocket):: __mixinTcpSocket(tcpSocket),
                // Optional: Host name to connect to, defaults to the pod IP.
                withHost(host):: self + self.mixinInstance({ host: host }),
                // Number or name of the port to access on the container. Number must be in the range 1 to 65535. Name must be an IANA_SVC_NAME.
                withPort(port):: self + self.mixinInstance({ port: port }),
              },
              // Number of seconds after which the probe times out. Defaults to 1 second. Minimum value is 1. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes
              withTimeoutSeconds(timeoutSeconds):: self + self.mixinInstance({ timeoutSeconds: timeoutSeconds }),
            },
            // Probes are not allowed for ephemeral containers.
            readinessProbe:: {
              local __mixinReadinessProbe(readinessProbe) = { readinessProbe+: readinessProbe },
              mixinInstance(readinessProbe):: __mixinReadinessProbe(readinessProbe),
              // One and only one of the following should be specified. Exec specifies the action to take.
              exec:: {
                local __mixinExec(exec) = { exec+: exec },
                mixinInstance(exec):: __mixinExec(exec),
                // Command is the command line to execute inside the container, the working directory for the command  is root ('/') in the container's filesystem. The command is simply exec'd, it is not run inside a shell, so traditional shell instructions ('|', etc) won't work. To use a shell, you need to explicitly call out to that shell. Exit status of 0 is treated as live/healthy and non-zero is unhealthy.
                withCommand(command):: self + if std.type(command) == 'array' then self.mixinInstance({ command: command }) else self.mixinInstance({ command: [command] }),
                // Command is the command line to execute inside the container, the working directory for the command  is root ('/') in the container's filesystem. The command is simply exec'd, it is not run inside a shell, so traditional shell instructions ('|', etc) won't work. To use a shell, you need to explicitly call out to that shell. Exit status of 0 is treated as live/healthy and non-zero is unhealthy.
                withCommandMixin(command):: self + if std.type(command) == 'array' then self.mixinInstance({ command+: command }) else self.mixinInstance({ command+: [command] }),
              },
              // Minimum consecutive failures for the probe to be considered failed after having succeeded. Defaults to 3. Minimum value is 1.
              withFailureThreshold(failureThreshold):: self + self.mixinInstance({ failureThreshold: failureThreshold }),
              // HTTPGet specifies the http request to perform.
              httpGet:: {
                local __mixinHttpGet(httpGet) = { httpGet+: httpGet },
                mixinInstance(httpGet):: __mixinHttpGet(httpGet),
                // Host name to connect to, defaults to the pod IP. You probably want to set "Host" in httpHeaders instead.
                withHost(host):: self + self.mixinInstance({ host: host }),
                // Custom headers to set in the request. HTTP allows repeated headers.
                withHttpHeaders(httpHeaders):: self + if std.type(httpHeaders) == 'array' then self.mixinInstance({ httpHeaders: httpHeaders }) else self.mixinInstance({ httpHeaders: [httpHeaders] }),
                // Custom headers to set in the request. HTTP allows repeated headers.
                withHttpHeadersMixin(httpHeaders):: self + if std.type(httpHeaders) == 'array' then self.mixinInstance({ httpHeaders+: httpHeaders }) else self.mixinInstance({ httpHeaders+: [httpHeaders] }),
                httpHeadersType:: hidden.v1.HTTPHeader,
                // Path to access on the HTTP server.
                withPath(path):: self + self.mixinInstance({ path: path }),
                // Name or number of the port to access on the container. Number must be in the range 1 to 65535. Name must be an IANA_SVC_NAME.
                withPort(port):: self + self.mixinInstance({ port: port }),
                // Scheme to use for connecting to the host. Defaults to HTTP.
                withScheme(scheme):: self + self.mixinInstance({ scheme: scheme }),
              },
              // Number of seconds after the container has started before liveness probes are initiated. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes
              withInitialDelaySeconds(initialDelaySeconds):: self + self.mixinInstance({ initialDelaySeconds: initialDelaySeconds }),
              // How often (in seconds) to perform the probe. Default to 10 seconds. Minimum value is 1.
              withPeriodSeconds(periodSeconds):: self + self.mixinInstance({ periodSeconds: periodSeconds }),
              // Minimum consecutive successes for the probe to be considered successful after having failed. Defaults to 1. Must be 1 for liveness and startup. Minimum value is 1.
              withSuccessThreshold(successThreshold):: self + self.mixinInstance({ successThreshold: successThreshold }),
              // TCPSocket specifies an action involving a TCP port. TCP hooks not yet supported
              tcpSocket:: {
                local __mixinTcpSocket(tcpSocket) = { tcpSocket+: tcpSocket },
                mixinInstance(tcpSocket):: __mixinTcpSocket(tcpSocket),
                // Optional: Host name to connect to, defaults to the pod IP.
                withHost(host):: self + self.mixinInstance({ host: host }),
                // Number or name of the port to access on the container. Number must be in the range 1 to 65535. Name must be an IANA_SVC_NAME.
                withPort(port):: self + self.mixinInstance({ port: port }),
              },
              // Number of seconds after which the probe times out. Defaults to 1 second. Minimum value is 1. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes
              withTimeoutSeconds(timeoutSeconds):: self + self.mixinInstance({ timeoutSeconds: timeoutSeconds }),
            },
            // Resources are not allowed for ephemeral containers. Ephemeral containers use spare resources already allocated to the pod.
            resources:: {
              local __mixinResources(resources) = { resources+: resources },
              mixinInstance(resources):: __mixinResources(resources),
              // Limits describes the maximum amount of compute resources allowed. More info: https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/
              withLimits(limits):: self + self.mixinInstance({ limits: limits }),
              // Requests describes the minimum amount of compute resources required. If Requests is omitted for a container, it defaults to Limits if that is explicitly specified, otherwise to an implementation-defined value. More info: https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/
              withRequests(requests):: self + self.mixinInstance({ requests: requests }),
            },
            // SecurityContext is not allowed for ephemeral containers.
            securityContext:: {
              local __mixinSecurityContext(securityContext) = { securityContext+: securityContext },
              mixinInstance(securityContext):: __mixinSecurityContext(securityContext),
              // AllowPrivilegeEscalation controls whether a process can gain more privileges than its parent process. This bool directly controls if the no_new_privs flag will be set on the container process. AllowPrivilegeEscalation is true always when the container is: 1) run as Privileged 2) has CAP_SYS_ADMIN
              withAllowPrivilegeEscalation(allowPrivilegeEscalation):: self + self.mixinInstance({ allowPrivilegeEscalation: allowPrivilegeEscalation }),
              // The capabilities to add/drop when running containers. Defaults to the default set of capabilities granted by the container runtime.
              capabilities:: {
                local __mixinCapabilities(capabilities) = { capabilities+: capabilities },
                mixinInstance(capabilities):: __mixinCapabilities(capabilities),
                // Added capabilities
                withAdd(add):: self + if std.type(add) == 'array' then self.mixinInstance({ add: add }) else self.mixinInstance({ add: [add] }),
                // Added capabilities
                withAddMixin(add):: self + if std.type(add) == 'array' then self.mixinInstance({ add+: add }) else self.mixinInstance({ add+: [add] }),
                // Removed capabilities
                withDrop(drop):: self + if std.type(drop) == 'array' then self.mixinInstance({ drop: drop }) else self.mixinInstance({ drop: [drop] }),
                // Removed capabilities
                withDropMixin(drop):: self + if std.type(drop) == 'array' then self.mixinInstance({ drop+: drop }) else self.mixinInstance({ drop+: [drop] }),
              },
              // Run container in privileged mode. Processes in privileged containers are essentially equivalent to root on the host. Defaults to false.
              withPrivileged(privileged):: self + self.mixinInstance({ privileged: privileged }),
              // procMount denotes the type of proc mount to use for the containers. The default is DefaultProcMount which uses the container runtime defaults for readonly paths and masked paths. This requires the ProcMountType feature flag to be enabled.
              withProcMount(procMount):: self + self.mixinInstance({ procMount: procMount }),
              // Whether this container has a read-only root filesystem. Default is false.
              withReadOnlyRootFilesystem(readOnlyRootFilesystem):: self + self.mixinInstance({ readOnlyRootFilesystem: readOnlyRootFilesystem }),
              // The GID to run the entrypoint of the container process. Uses runtime default if unset. May also be set in PodSecurityContext.  If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence.
              withRunAsGroup(runAsGroup):: self + self.mixinInstance({ runAsGroup: runAsGroup }),
              // Indicates that the container must run as a non-root user. If true, the Kubelet will validate the image at runtime to ensure that it does not run as UID 0 (root) and fail to start the container if it does. If unset or false, no such validation will be performed. May also be set in PodSecurityContext.  If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence.
              withRunAsNonRoot(runAsNonRoot):: self + self.mixinInstance({ runAsNonRoot: runAsNonRoot }),
              // The UID to run the entrypoint of the container process. Defaults to user specified in image metadata if unspecified. May also be set in PodSecurityContext.  If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence.
              withRunAsUser(runAsUser):: self + self.mixinInstance({ runAsUser: runAsUser }),
              // The SELinux context to be applied to the container. If unspecified, the container runtime will allocate a random SELinux context for each container.  May also be set in PodSecurityContext.  If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence.
              seLinuxOptions:: {
                local __mixinSeLinuxOptions(seLinuxOptions) = { seLinuxOptions+: seLinuxOptions },
                mixinInstance(seLinuxOptions):: __mixinSeLinuxOptions(seLinuxOptions),
                // Level is SELinux level label that applies to the container.
                withLevel(level):: self + self.mixinInstance({ level: level }),
                // Role is a SELinux role label that applies to the container.
                withRole(role):: self + self.mixinInstance({ role: role }),
                // Type is a SELinux type label that applies to the container.
                withType(type):: self + self.mixinInstance({ type: type }),
                // User is a SELinux user label that applies to the container.
                withUser(user):: self + self.mixinInstance({ user: user }),
              },
              // The Windows specific settings applied to all containers. If unspecified, the options from the PodSecurityContext will be used. If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence.
              windowsOptions:: {
                local __mixinWindowsOptions(windowsOptions) = { windowsOptions+: windowsOptions },
                mixinInstance(windowsOptions):: __mixinWindowsOptions(windowsOptions),
                // GMSACredentialSpec is where the GMSA admission webhook (https://github.com/kubernetes-sigs/windows-gmsa) inlines the contents of the GMSA credential spec named by the GMSACredentialSpecName field. This field is alpha-level and is only honored by servers that enable the WindowsGMSA feature flag.
                withGmsaCredentialSpec(gmsaCredentialSpec):: self + self.mixinInstance({ gmsaCredentialSpec: gmsaCredentialSpec }),
                // GMSACredentialSpecName is the name of the GMSA credential spec to use. This field is alpha-level and is only honored by servers that enable the WindowsGMSA feature flag.
                withGmsaCredentialSpecName(gmsaCredentialSpecName):: self + self.mixinInstance({ gmsaCredentialSpecName: gmsaCredentialSpecName }),
                // The UserName in Windows to run the entrypoint of the container process. Defaults to the user specified in image metadata if unspecified. May also be set in PodSecurityContext. If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence. This field is beta-level and may be disabled with the WindowsRunAsUserName feature flag.
                withRunAsUserName(runAsUserName):: self + self.mixinInstance({ runAsUserName: runAsUserName }),
              },
            },
            // Probes are not allowed for ephemeral containers.
            startupProbe:: {
              local __mixinStartupProbe(startupProbe) = { startupProbe+: startupProbe },
              mixinInstance(startupProbe):: __mixinStartupProbe(startupProbe),
              // One and only one of the following should be specified. Exec specifies the action to take.
              exec:: {
                local __mixinExec(exec) = { exec+: exec },
                mixinInstance(exec):: __mixinExec(exec),
                // Command is the command line to execute inside the container, the working directory for the command  is root ('/') in the container's filesystem. The command is simply exec'd, it is not run inside a shell, so traditional shell instructions ('|', etc) won't work. To use a shell, you need to explicitly call out to that shell. Exit status of 0 is treated as live/healthy and non-zero is unhealthy.
                withCommand(command):: self + if std.type(command) == 'array' then self.mixinInstance({ command: command }) else self.mixinInstance({ command: [command] }),
                // Command is the command line to execute inside the container, the working directory for the command  is root ('/') in the container's filesystem. The command is simply exec'd, it is not run inside a shell, so traditional shell instructions ('|', etc) won't work. To use a shell, you need to explicitly call out to that shell. Exit status of 0 is treated as live/healthy and non-zero is unhealthy.
                withCommandMixin(command):: self + if std.type(command) == 'array' then self.mixinInstance({ command+: command }) else self.mixinInstance({ command+: [command] }),
              },
              // Minimum consecutive failures for the probe to be considered failed after having succeeded. Defaults to 3. Minimum value is 1.
              withFailureThreshold(failureThreshold):: self + self.mixinInstance({ failureThreshold: failureThreshold }),
              // HTTPGet specifies the http request to perform.
              httpGet:: {
                local __mixinHttpGet(httpGet) = { httpGet+: httpGet },
                mixinInstance(httpGet):: __mixinHttpGet(httpGet),
                // Host name to connect to, defaults to the pod IP. You probably want to set "Host" in httpHeaders instead.
                withHost(host):: self + self.mixinInstance({ host: host }),
                // Custom headers to set in the request. HTTP allows repeated headers.
                withHttpHeaders(httpHeaders):: self + if std.type(httpHeaders) == 'array' then self.mixinInstance({ httpHeaders: httpHeaders }) else self.mixinInstance({ httpHeaders: [httpHeaders] }),
                // Custom headers to set in the request. HTTP allows repeated headers.
                withHttpHeadersMixin(httpHeaders):: self + if std.type(httpHeaders) == 'array' then self.mixinInstance({ httpHeaders+: httpHeaders }) else self.mixinInstance({ httpHeaders+: [httpHeaders] }),
                httpHeadersType:: hidden.v1.HTTPHeader,
                // Path to access on the HTTP server.
                withPath(path):: self + self.mixinInstance({ path: path }),
                // Name or number of the port to access on the container. Number must be in the range 1 to 65535. Name must be an IANA_SVC_NAME.
                withPort(port):: self + self.mixinInstance({ port: port }),
                // Scheme to use for connecting to the host. Defaults to HTTP.
                withScheme(scheme):: self + self.mixinInstance({ scheme: scheme }),
              },
              // Number of seconds after the container has started before liveness probes are initiated. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes
              withInitialDelaySeconds(initialDelaySeconds):: self + self.mixinInstance({ initialDelaySeconds: initialDelaySeconds }),
              // How often (in seconds) to perform the probe. Default to 10 seconds. Minimum value is 1.
              withPeriodSeconds(periodSeconds):: self + self.mixinInstance({ periodSeconds: periodSeconds }),
              // Minimum consecutive successes for the probe to be considered successful after having failed. Defaults to 1. Must be 1 for liveness and startup. Minimum value is 1.
              withSuccessThreshold(successThreshold):: self + self.mixinInstance({ successThreshold: successThreshold }),
              // TCPSocket specifies an action involving a TCP port. TCP hooks not yet supported
              tcpSocket:: {
                local __mixinTcpSocket(tcpSocket) = { tcpSocket+: tcpSocket },
                mixinInstance(tcpSocket):: __mixinTcpSocket(tcpSocket),
                // Optional: Host name to connect to, defaults to the pod IP.
                withHost(host):: self + self.mixinInstance({ host: host }),
                // Number or name of the port to access on the container. Number must be in the range 1 to 65535. Name must be an IANA_SVC_NAME.
                withPort(port):: self + self.mixinInstance({ port: port }),
              },
              // Number of seconds after which the probe times out. Defaults to 1 second. Minimum value is 1. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes
              withTimeoutSeconds(timeoutSeconds):: self + self.mixinInstance({ timeoutSeconds: timeoutSeconds }),
            },
          },
        },
        // PodReadinessGate contains the reference to a pod condition
        podReadinessGate:: {
          local kind = { kind: 'PodReadinessGate' },
          // ConditionType refers to a condition in the pod's condition list with matching type.
          withConditionType(conditionType):: self + self.mixinInstance({ conditionType: conditionType }),
          mixin:: {},
        },
        // PortworxVolumeSource represents a Portworx volume resource.
        portworxVolumeSource:: {
          local kind = { kind: 'PortworxVolumeSource' },
          // FSType represents the filesystem type to mount Must be a filesystem type supported by the host operating system. Ex. "ext4", "xfs". Implicitly inferred to be "ext4" if unspecified.
          withFsType(fsType):: self + self.mixinInstance({ fsType: fsType }),
          // Defaults to false (read/write). ReadOnly here will force the ReadOnly setting in VolumeMounts.
          withReadOnly(readOnly):: self + self.mixinInstance({ readOnly: readOnly }),
          // VolumeID uniquely identifies a Portworx volume
          withVolumeID(volumeID):: self + self.mixinInstance({ volumeID: volumeID }),
          mixin:: {},
        },
        // Probe describes a health check to be performed against a container to determine whether it is alive or ready to receive traffic.
        probe:: {
          local kind = { kind: 'Probe' },
          // Minimum consecutive failures for the probe to be considered failed after having succeeded. Defaults to 3. Minimum value is 1.
          withFailureThreshold(failureThreshold):: self + self.mixinInstance({ failureThreshold: failureThreshold }),
          // Number of seconds after the container has started before liveness probes are initiated. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes
          withInitialDelaySeconds(initialDelaySeconds):: self + self.mixinInstance({ initialDelaySeconds: initialDelaySeconds }),
          // How often (in seconds) to perform the probe. Default to 10 seconds. Minimum value is 1.
          withPeriodSeconds(periodSeconds):: self + self.mixinInstance({ periodSeconds: periodSeconds }),
          // Minimum consecutive successes for the probe to be considered successful after having failed. Defaults to 1. Must be 1 for liveness and startup. Minimum value is 1.
          withSuccessThreshold(successThreshold):: self + self.mixinInstance({ successThreshold: successThreshold }),
          // Number of seconds after which the probe times out. Defaults to 1 second. Minimum value is 1. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes
          withTimeoutSeconds(timeoutSeconds):: self + self.mixinInstance({ timeoutSeconds: timeoutSeconds }),
          mixin:: {
            // One and only one of the following should be specified. Exec specifies the action to take.
            exec:: {
              local __mixinExec(exec) = { exec+: exec },
              mixinInstance(exec):: __mixinExec(exec),
              // Command is the command line to execute inside the container, the working directory for the command  is root ('/') in the container's filesystem. The command is simply exec'd, it is not run inside a shell, so traditional shell instructions ('|', etc) won't work. To use a shell, you need to explicitly call out to that shell. Exit status of 0 is treated as live/healthy and non-zero is unhealthy.
              withCommand(command):: self + if std.type(command) == 'array' then self.mixinInstance({ command: command }) else self.mixinInstance({ command: [command] }),
              // Command is the command line to execute inside the container, the working directory for the command  is root ('/') in the container's filesystem. The command is simply exec'd, it is not run inside a shell, so traditional shell instructions ('|', etc) won't work. To use a shell, you need to explicitly call out to that shell. Exit status of 0 is treated as live/healthy and non-zero is unhealthy.
              withCommandMixin(command):: self + if std.type(command) == 'array' then self.mixinInstance({ command+: command }) else self.mixinInstance({ command+: [command] }),
            },
            // HTTPGet specifies the http request to perform.
            httpGet:: {
              local __mixinHttpGet(httpGet) = { httpGet+: httpGet },
              mixinInstance(httpGet):: __mixinHttpGet(httpGet),
              // Host name to connect to, defaults to the pod IP. You probably want to set "Host" in httpHeaders instead.
              withHost(host):: self + self.mixinInstance({ host: host }),
              // Custom headers to set in the request. HTTP allows repeated headers.
              withHttpHeaders(httpHeaders):: self + if std.type(httpHeaders) == 'array' then self.mixinInstance({ httpHeaders: httpHeaders }) else self.mixinInstance({ httpHeaders: [httpHeaders] }),
              // Custom headers to set in the request. HTTP allows repeated headers.
              withHttpHeadersMixin(httpHeaders):: self + if std.type(httpHeaders) == 'array' then self.mixinInstance({ httpHeaders+: httpHeaders }) else self.mixinInstance({ httpHeaders+: [httpHeaders] }),
              httpHeadersType:: hidden.v1.HTTPHeader,
              // Path to access on the HTTP server.
              withPath(path):: self + self.mixinInstance({ path: path }),
              // Name or number of the port to access on the container. Number must be in the range 1 to 65535. Name must be an IANA_SVC_NAME.
              withPort(port):: self + self.mixinInstance({ port: port }),
              // Scheme to use for connecting to the host. Defaults to HTTP.
              withScheme(scheme):: self + self.mixinInstance({ scheme: scheme }),
            },
            // TCPSocket specifies an action involving a TCP port. TCP hooks not yet supported
            tcpSocket:: {
              local __mixinTcpSocket(tcpSocket) = { tcpSocket+: tcpSocket },
              mixinInstance(tcpSocket):: __mixinTcpSocket(tcpSocket),
              // Optional: Host name to connect to, defaults to the pod IP.
              withHost(host):: self + self.mixinInstance({ host: host }),
              // Number or name of the port to access on the container. Number must be in the range 1 to 65535. Name must be an IANA_SVC_NAME.
              withPort(port):: self + self.mixinInstance({ port: port }),
            },
          },
        },
        // SELinuxOptions are the labels to be applied to the container
        seLinuxOptions:: {
          local kind = { kind: 'SELinuxOptions' },
          // Level is SELinux level label that applies to the container.
          withLevel(level):: self + self.mixinInstance({ level: level }),
          // Role is a SELinux role label that applies to the container.
          withRole(role):: self + self.mixinInstance({ role: role }),
          // Type is a SELinux type label that applies to the container.
          withType(type):: self + self.mixinInstance({ type: type }),
          // User is a SELinux user label that applies to the container.
          withUser(user):: self + self.mixinInstance({ user: user }),
          mixin:: {},
        },
        // EnvVarSource represents a source for the value of an EnvVar.
        envVarSource:: {
          local kind = { kind: 'EnvVarSource' },
          mixin:: {
            // Selects a key of a ConfigMap.
            configMapKeyRef:: {
              local __mixinConfigMapKeyRef(configMapKeyRef) = { configMapKeyRef+: configMapKeyRef },
              mixinInstance(configMapKeyRef):: __mixinConfigMapKeyRef(configMapKeyRef),
              // The key to select.
              withKey(key):: self + self.mixinInstance({ key: key }),
              // Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
              withName(name):: self + self.mixinInstance({ name: name }),
              // Specify whether the ConfigMap or its key must be defined
              withOptional(optional):: self + self.mixinInstance({ optional: optional }),
            },
            // Selects a field of the pod: supports metadata.name, metadata.namespace, metadata.labels, metadata.annotations, spec.nodeName, spec.serviceAccountName, status.hostIP, status.podIP, status.podIPs.
            fieldRef:: {
              local __mixinFieldRef(fieldRef) = { fieldRef+: fieldRef },
              mixinInstance(fieldRef):: __mixinFieldRef(fieldRef),
              // Version of the schema the FieldPath is written in terms of, defaults to "v1".
              withApiVersion(apiVersion):: self + self.mixinInstance({ apiVersion: apiVersion }),
              // Path of the field to select in the specified API version.
              withFieldPath(fieldPath):: self + self.mixinInstance({ fieldPath: fieldPath }),
            },
            // Selects a resource of the container: only resources limits and requests (limits.cpu, limits.memory, limits.ephemeral-storage, requests.cpu, requests.memory and requests.ephemeral-storage) are currently supported.
            resourceFieldRef:: {
              local __mixinResourceFieldRef(resourceFieldRef) = { resourceFieldRef+: resourceFieldRef },
              mixinInstance(resourceFieldRef):: __mixinResourceFieldRef(resourceFieldRef),
              // Container name: required for volumes, optional for env vars
              withContainerName(containerName):: self + self.mixinInstance({ containerName: containerName }),
              // Specifies the output format of the exposed resources, defaults to "1"
              withDivisor(divisor):: self + self.mixinInstance({ divisor: divisor }),
              // Required: resource to select
              withResource(resource):: self + self.mixinInstance({ resource: resource }),
            },
            // Selects a key of a secret in the pod's namespace
            secretKeyRef:: {
              local __mixinSecretKeyRef(secretKeyRef) = { secretKeyRef+: secretKeyRef },
              mixinInstance(secretKeyRef):: __mixinSecretKeyRef(secretKeyRef),
              // The key of the secret to select from.  Must be a valid secret key.
              withKey(key):: self + self.mixinInstance({ key: key }),
              // Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
              withName(name):: self + self.mixinInstance({ name: name }),
              // Specify whether the Secret or its key must be defined
              withOptional(optional):: self + self.mixinInstance({ optional: optional }),
            },
          },
        },
        // Node affinity is a group of node affinity scheduling rules.
        nodeAffinity:: {
          local kind = { kind: 'NodeAffinity' },
          // The scheduler will prefer to schedule pods to nodes that satisfy the affinity expressions specified by this field, but it may choose a node that violates one or more of the expressions. The node that is most preferred is the one with the greatest sum of weights, i.e. for each node that meets all of the scheduling requirements (resource request, requiredDuringScheduling affinity expressions, etc.), compute a sum by iterating through the elements of this field and adding "weight" to the sum if the node matches the corresponding matchExpressions; the node(s) with the highest sum are the most preferred.
          withPreferredDuringSchedulingIgnoredDuringExecution(preferredDuringSchedulingIgnoredDuringExecution):: self + if std.type(preferredDuringSchedulingIgnoredDuringExecution) == 'array' then self.mixinInstance({ preferredDuringSchedulingIgnoredDuringExecution: preferredDuringSchedulingIgnoredDuringExecution }) else self.mixinInstance({ preferredDuringSchedulingIgnoredDuringExecution: [preferredDuringSchedulingIgnoredDuringExecution] }),
          // The scheduler will prefer to schedule pods to nodes that satisfy the affinity expressions specified by this field, but it may choose a node that violates one or more of the expressions. The node that is most preferred is the one with the greatest sum of weights, i.e. for each node that meets all of the scheduling requirements (resource request, requiredDuringScheduling affinity expressions, etc.), compute a sum by iterating through the elements of this field and adding "weight" to the sum if the node matches the corresponding matchExpressions; the node(s) with the highest sum are the most preferred.
          withPreferredDuringSchedulingIgnoredDuringExecutionMixin(preferredDuringSchedulingIgnoredDuringExecution):: self + if std.type(preferredDuringSchedulingIgnoredDuringExecution) == 'array' then self.mixinInstance({ preferredDuringSchedulingIgnoredDuringExecution+: preferredDuringSchedulingIgnoredDuringExecution }) else self.mixinInstance({ preferredDuringSchedulingIgnoredDuringExecution+: [preferredDuringSchedulingIgnoredDuringExecution] }),
          preferredDuringSchedulingIgnoredDuringExecutionType:: hidden.v1.PreferredSchedulingTerm,
          mixin:: {
            // If the affinity requirements specified by this field are not met at scheduling time, the pod will not be scheduled onto the node. If the affinity requirements specified by this field cease to be met at some point during pod execution (e.g. due to an update), the system may or may not try to eventually evict the pod from its node.
            requiredDuringSchedulingIgnoredDuringExecution:: {
              local __mixinRequiredDuringSchedulingIgnoredDuringExecution(requiredDuringSchedulingIgnoredDuringExecution) = { requiredDuringSchedulingIgnoredDuringExecution+: requiredDuringSchedulingIgnoredDuringExecution },
              mixinInstance(requiredDuringSchedulingIgnoredDuringExecution):: __mixinRequiredDuringSchedulingIgnoredDuringExecution(requiredDuringSchedulingIgnoredDuringExecution),
              // Required. A list of node selector terms. The terms are ORed.
              withNodeSelectorTerms(nodeSelectorTerms):: self + if std.type(nodeSelectorTerms) == 'array' then self.mixinInstance({ nodeSelectorTerms: nodeSelectorTerms }) else self.mixinInstance({ nodeSelectorTerms: [nodeSelectorTerms] }),
              // Required. A list of node selector terms. The terms are ORed.
              withNodeSelectorTermsMixin(nodeSelectorTerms):: self + if std.type(nodeSelectorTerms) == 'array' then self.mixinInstance({ nodeSelectorTerms+: nodeSelectorTerms }) else self.mixinInstance({ nodeSelectorTerms+: [nodeSelectorTerms] }),
              nodeSelectorTermsType:: hidden.v1.NodeSelectorTerm,
            },
          },
        },
        // HTTPHeader describes a custom header to be used in HTTP probes
        httpHeader:: {
          local kind = { kind: 'HTTPHeader' },
          // The header field name
          withName(name):: self + self.mixinInstance({ name: name }),
          // The header field value
          withValue(value):: self + self.mixinInstance({ value: value }),
          mixin:: {},
        },
        // A node selector represents the union of the results of one or more label queries over a set of nodes; that is, it represents the OR of the selectors represented by the node selector terms.
        nodeSelector:: {
          local kind = { kind: 'NodeSelector' },
          // Required. A list of node selector terms. The terms are ORed.
          withNodeSelectorTerms(nodeSelectorTerms):: self + if std.type(nodeSelectorTerms) == 'array' then self.mixinInstance({ nodeSelectorTerms: nodeSelectorTerms }) else self.mixinInstance({ nodeSelectorTerms: [nodeSelectorTerms] }),
          // Required. A list of node selector terms. The terms are ORed.
          withNodeSelectorTermsMixin(nodeSelectorTerms):: self + if std.type(nodeSelectorTerms) == 'array' then self.mixinInstance({ nodeSelectorTerms+: nodeSelectorTerms }) else self.mixinInstance({ nodeSelectorTerms+: [nodeSelectorTerms] }),
          nodeSelectorTermsType:: hidden.v1.NodeSelectorTerm,
          mixin:: {},
        },
        // PodSecurityContext holds pod-level security attributes and common container settings. Some fields are also present in container.securityContext.  Field values of container.securityContext take precedence over field values of PodSecurityContext.
        podSecurityContext:: {
          local kind = { kind: 'PodSecurityContext' },
          // A special supplemental group that applies to all containers in a pod. Some volume types allow the Kubelet to change the ownership of that volume to be owned by the pod:
          //
          // 1. The owning GID will be the FSGroup 2. The setgid bit is set (new files created in the volume will be owned by FSGroup) 3. The permission bits are OR'd with rw-rw----
          //
          // If unset, the Kubelet will not modify the ownership and permissions of any volume.
          withFsGroup(fsGroup):: self + self.mixinInstance({ fsGroup: fsGroup }),
          // The GID to run the entrypoint of the container process. Uses runtime default if unset. May also be set in SecurityContext.  If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence for that container.
          withRunAsGroup(runAsGroup):: self + self.mixinInstance({ runAsGroup: runAsGroup }),
          // Indicates that the container must run as a non-root user. If true, the Kubelet will validate the image at runtime to ensure that it does not run as UID 0 (root) and fail to start the container if it does. If unset or false, no such validation will be performed. May also be set in SecurityContext.  If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence.
          withRunAsNonRoot(runAsNonRoot):: self + self.mixinInstance({ runAsNonRoot: runAsNonRoot }),
          // The UID to run the entrypoint of the container process. Defaults to user specified in image metadata if unspecified. May also be set in SecurityContext.  If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence for that container.
          withRunAsUser(runAsUser):: self + self.mixinInstance({ runAsUser: runAsUser }),
          // A list of groups applied to the first process run in each container, in addition to the container's primary GID.  If unspecified, no groups will be added to any container.
          withSupplementalGroups(supplementalGroups):: self + if std.type(supplementalGroups) == 'array' then self.mixinInstance({ supplementalGroups: supplementalGroups }) else self.mixinInstance({ supplementalGroups: [supplementalGroups] }),
          // A list of groups applied to the first process run in each container, in addition to the container's primary GID.  If unspecified, no groups will be added to any container.
          withSupplementalGroupsMixin(supplementalGroups):: self + if std.type(supplementalGroups) == 'array' then self.mixinInstance({ supplementalGroups+: supplementalGroups }) else self.mixinInstance({ supplementalGroups+: [supplementalGroups] }),
          // Sysctls hold a list of namespaced sysctls used for the pod. Pods with unsupported sysctls (by the container runtime) might fail to launch.
          withSysctls(sysctls):: self + if std.type(sysctls) == 'array' then self.mixinInstance({ sysctls: sysctls }) else self.mixinInstance({ sysctls: [sysctls] }),
          // Sysctls hold a list of namespaced sysctls used for the pod. Pods with unsupported sysctls (by the container runtime) might fail to launch.
          withSysctlsMixin(sysctls):: self + if std.type(sysctls) == 'array' then self.mixinInstance({ sysctls+: sysctls }) else self.mixinInstance({ sysctls+: [sysctls] }),
          sysctlsType:: hidden.v1.Sysctl,
          mixin:: {
            // The SELinux context to be applied to all containers. If unspecified, the container runtime will allocate a random SELinux context for each container.  May also be set in SecurityContext.  If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence for that container.
            seLinuxOptions:: {
              local __mixinSeLinuxOptions(seLinuxOptions) = { seLinuxOptions+: seLinuxOptions },
              mixinInstance(seLinuxOptions):: __mixinSeLinuxOptions(seLinuxOptions),
              // Level is SELinux level label that applies to the container.
              withLevel(level):: self + self.mixinInstance({ level: level }),
              // Role is a SELinux role label that applies to the container.
              withRole(role):: self + self.mixinInstance({ role: role }),
              // Type is a SELinux type label that applies to the container.
              withType(type):: self + self.mixinInstance({ type: type }),
              // User is a SELinux user label that applies to the container.
              withUser(user):: self + self.mixinInstance({ user: user }),
            },
            // The Windows specific settings applied to all containers. If unspecified, the options within a container's SecurityContext will be used. If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence.
            windowsOptions:: {
              local __mixinWindowsOptions(windowsOptions) = { windowsOptions+: windowsOptions },
              mixinInstance(windowsOptions):: __mixinWindowsOptions(windowsOptions),
              // GMSACredentialSpec is where the GMSA admission webhook (https://github.com/kubernetes-sigs/windows-gmsa) inlines the contents of the GMSA credential spec named by the GMSACredentialSpecName field. This field is alpha-level and is only honored by servers that enable the WindowsGMSA feature flag.
              withGmsaCredentialSpec(gmsaCredentialSpec):: self + self.mixinInstance({ gmsaCredentialSpec: gmsaCredentialSpec }),
              // GMSACredentialSpecName is the name of the GMSA credential spec to use. This field is alpha-level and is only honored by servers that enable the WindowsGMSA feature flag.
              withGmsaCredentialSpecName(gmsaCredentialSpecName):: self + self.mixinInstance({ gmsaCredentialSpecName: gmsaCredentialSpecName }),
              // The UserName in Windows to run the entrypoint of the container process. Defaults to the user specified in image metadata if unspecified. May also be set in PodSecurityContext. If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence. This field is beta-level and may be disabled with the WindowsRunAsUserName feature flag.
              withRunAsUserName(runAsUserName):: self + self.mixinInstance({ runAsUserName: runAsUserName }),
            },
          },
        },
        // Adapts a Secret into a volume.
        //
        // The contents of the target Secret's Data field will be presented in a volume as files using the keys in the Data field as the file names. Secret volumes support ownership management and SELinux relabeling.
        secretVolumeSource:: {
          local kind = { kind: 'SecretVolumeSource' },
          // Optional: mode bits to use on created files by default. Must be a value between 0 and 0777. Defaults to 0644. Directories within the path are not affected by this setting. This might be in conflict with other options that affect the file mode, like fsGroup, and the result can be other mode bits set.
          withDefaultMode(defaultMode):: self + self.mixinInstance({ defaultMode: defaultMode }),
          // If unspecified, each key-value pair in the Data field of the referenced Secret will be projected into the volume as a file whose name is the key and content is the value. If specified, the listed keys will be projected into the specified paths, and unlisted keys will not be present. If a key is specified which is not present in the Secret, the volume setup will error unless it is marked optional. Paths must be relative and may not contain the '..' path or start with '..'.
          withItems(items):: self + if std.type(items) == 'array' then self.mixinInstance({ items: items }) else self.mixinInstance({ items: [items] }),
          // If unspecified, each key-value pair in the Data field of the referenced Secret will be projected into the volume as a file whose name is the key and content is the value. If specified, the listed keys will be projected into the specified paths, and unlisted keys will not be present. If a key is specified which is not present in the Secret, the volume setup will error unless it is marked optional. Paths must be relative and may not contain the '..' path or start with '..'.
          withItemsMixin(items):: self + if std.type(items) == 'array' then self.mixinInstance({ items+: items }) else self.mixinInstance({ items+: [items] }),
          itemsType:: hidden.v1.KeyToPath,
          // Specify whether the Secret or its keys must be defined
          withOptional(optional):: self + self.mixinInstance({ optional: optional }),
          // Name of the secret in the pod's namespace to use. More info: https://kubernetes.io/docs/concepts/storage/volumes#secret
          withSecretName(secretName):: self + self.mixinInstance({ secretName: secretName }),
          mixin:: {},
        },
        // VolumeMount describes a mounting of a Volume within a container.
        volumeMount:: {
          local kind = { kind: 'VolumeMount' },
          // Path within the container at which the volume should be mounted.  Must not contain ':'.
          withMountPath(mountPath):: self + self.mixinInstance({ mountPath: mountPath }),
          // mountPropagation determines how mounts are propagated from the host to container and the other way around. When not set, MountPropagationNone is used. This field is beta in 1.10.
          withMountPropagation(mountPropagation):: self + self.mixinInstance({ mountPropagation: mountPropagation }),
          // This must match the Name of a Volume.
          withName(name):: self + self.mixinInstance({ name: name }),
          // Mounted read-only if true, read-write otherwise (false or unspecified). Defaults to false.
          withReadOnly(readOnly):: self + self.mixinInstance({ readOnly: readOnly }),
          // Path within the volume from which the container's volume should be mounted. Defaults to "" (volume's root).
          withSubPath(subPath):: self + self.mixinInstance({ subPath: subPath }),
          // Expanded path within the volume from which the container's volume should be mounted. Behaves similarly to SubPath but environment variable references $(VAR_NAME) are expanded using the container's environment. Defaults to "" (volume's root). SubPathExpr and SubPath are mutually exclusive.
          withSubPathExpr(subPathExpr):: self + self.mixinInstance({ subPathExpr: subPathExpr }),
          mixin:: {},
        },
        // Adapts a ConfigMap into a volume.
        //
        // The contents of the target ConfigMap's Data field will be presented in a volume as files using the keys in the Data field as the file names, unless the items element is populated with specific mappings of keys to paths. ConfigMap volumes support ownership management and SELinux relabeling.
        configMapVolumeSource:: {
          local kind = { kind: 'ConfigMapVolumeSource' },
          // Optional: mode bits to use on created files by default. Must be a value between 0 and 0777. Defaults to 0644. Directories within the path are not affected by this setting. This might be in conflict with other options that affect the file mode, like fsGroup, and the result can be other mode bits set.
          withDefaultMode(defaultMode):: self + self.mixinInstance({ defaultMode: defaultMode }),
          // If unspecified, each key-value pair in the Data field of the referenced ConfigMap will be projected into the volume as a file whose name is the key and content is the value. If specified, the listed keys will be projected into the specified paths, and unlisted keys will not be present. If a key is specified which is not present in the ConfigMap, the volume setup will error unless it is marked optional. Paths must be relative and may not contain the '..' path or start with '..'.
          withItems(items):: self + if std.type(items) == 'array' then self.mixinInstance({ items: items }) else self.mixinInstance({ items: [items] }),
          // If unspecified, each key-value pair in the Data field of the referenced ConfigMap will be projected into the volume as a file whose name is the key and content is the value. If specified, the listed keys will be projected into the specified paths, and unlisted keys will not be present. If a key is specified which is not present in the ConfigMap, the volume setup will error unless it is marked optional. Paths must be relative and may not contain the '..' path or start with '..'.
          withItemsMixin(items):: self + if std.type(items) == 'array' then self.mixinInstance({ items+: items }) else self.mixinInstance({ items+: [items] }),
          itemsType:: hidden.v1.KeyToPath,
          // Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
          withName(name):: self + self.mixinInstance({ name: name }),
          // Specify whether the ConfigMap or its keys must be defined
          withOptional(optional):: self + self.mixinInstance({ optional: optional }),
          mixin:: {},
        },
        // PodStatus represents information about the status of a pod. Status may trail the actual state of a system, especially if the node that hosts the pod cannot contact the control plane.
        podStatus:: {
          local kind = { kind: 'PodStatus' },
          // Current service state of pod. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#pod-conditions
          withConditions(conditions):: self + if std.type(conditions) == 'array' then self.mixinInstance({ conditions: conditions }) else self.mixinInstance({ conditions: [conditions] }),
          // Current service state of pod. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#pod-conditions
          withConditionsMixin(conditions):: self + if std.type(conditions) == 'array' then self.mixinInstance({ conditions+: conditions }) else self.mixinInstance({ conditions+: [conditions] }),
          conditionsType:: hidden.v1.PodCondition,
          // The list has one entry per container in the manifest. Each entry is currently the output of `docker inspect`. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#pod-and-container-status
          withContainerStatuses(containerStatuses):: self + if std.type(containerStatuses) == 'array' then self.mixinInstance({ containerStatuses: containerStatuses }) else self.mixinInstance({ containerStatuses: [containerStatuses] }),
          // The list has one entry per container in the manifest. Each entry is currently the output of `docker inspect`. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#pod-and-container-status
          withContainerStatusesMixin(containerStatuses):: self + if std.type(containerStatuses) == 'array' then self.mixinInstance({ containerStatuses+: containerStatuses }) else self.mixinInstance({ containerStatuses+: [containerStatuses] }),
          containerStatusesType:: hidden.v1.ContainerStatus,
          // Status for any ephemeral containers that have run in this pod. This field is alpha-level and is only populated by servers that enable the EphemeralContainers feature.
          withEphemeralContainerStatuses(ephemeralContainerStatuses):: self + if std.type(ephemeralContainerStatuses) == 'array' then self.mixinInstance({ ephemeralContainerStatuses: ephemeralContainerStatuses }) else self.mixinInstance({ ephemeralContainerStatuses: [ephemeralContainerStatuses] }),
          // Status for any ephemeral containers that have run in this pod. This field is alpha-level and is only populated by servers that enable the EphemeralContainers feature.
          withEphemeralContainerStatusesMixin(ephemeralContainerStatuses):: self + if std.type(ephemeralContainerStatuses) == 'array' then self.mixinInstance({ ephemeralContainerStatuses+: ephemeralContainerStatuses }) else self.mixinInstance({ ephemeralContainerStatuses+: [ephemeralContainerStatuses] }),
          ephemeralContainerStatusesType:: hidden.v1.ContainerStatus,
          // IP address of the host to which the pod is assigned. Empty if not yet scheduled.
          withHostIP(hostIP):: self + self.mixinInstance({ hostIP: hostIP }),
          // The list has one entry per init container in the manifest. The most recent successful init container will have ready = true, the most recently started container will have startTime set. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#pod-and-container-status
          withInitContainerStatuses(initContainerStatuses):: self + if std.type(initContainerStatuses) == 'array' then self.mixinInstance({ initContainerStatuses: initContainerStatuses }) else self.mixinInstance({ initContainerStatuses: [initContainerStatuses] }),
          // The list has one entry per init container in the manifest. The most recent successful init container will have ready = true, the most recently started container will have startTime set. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#pod-and-container-status
          withInitContainerStatusesMixin(initContainerStatuses):: self + if std.type(initContainerStatuses) == 'array' then self.mixinInstance({ initContainerStatuses+: initContainerStatuses }) else self.mixinInstance({ initContainerStatuses+: [initContainerStatuses] }),
          initContainerStatusesType:: hidden.v1.ContainerStatus,
          // A human readable message indicating details about why the pod is in this condition.
          withMessage(message):: self + self.mixinInstance({ message: message }),
          // nominatedNodeName is set only when this pod preempts other pods on the node, but it cannot be scheduled right away as preemption victims receive their graceful termination periods. This field does not guarantee that the pod will be scheduled on this node. Scheduler may decide to place the pod elsewhere if other nodes become available sooner. Scheduler may also decide to give the resources on this node to a higher priority pod that is created after preemption. As a result, this field may be different than PodSpec.nodeName when the pod is scheduled.
          withNominatedNodeName(nominatedNodeName):: self + self.mixinInstance({ nominatedNodeName: nominatedNodeName }),
          // The phase of a Pod is a simple, high-level summary of where the Pod is in its lifecycle. The conditions array, the reason and message fields, and the individual container status arrays contain more detail about the pod's status. There are five possible phase values:
          //
          // Pending: The pod has been accepted by the Kubernetes system, but one or more of the container images has not been created. This includes time before being scheduled as well as time spent downloading images over the network, which could take a while. Running: The pod has been bound to a node, and all of the containers have been created. At least one container is still running, or is in the process of starting or restarting. Succeeded: All containers in the pod have terminated in success, and will not be restarted. Failed: All containers in the pod have terminated, and at least one container has terminated in failure. The container either exited with non-zero status or was terminated by the system. Unknown: For some reason the state of the pod could not be obtained, typically due to an error in communicating with the host of the pod.
          //
          // More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#pod-phase
          withPhase(phase):: self + self.mixinInstance({ phase: phase }),
          // IP address allocated to the pod. Routable at least within the cluster. Empty if not yet allocated.
          withPodIP(podIP):: self + self.mixinInstance({ podIP: podIP }),
          // podIPs holds the IP addresses allocated to the pod. If this field is specified, the 0th entry must match the podIP field. Pods may be allocated at most 1 value for each of IPv4 and IPv6. This list is empty if no IPs have been allocated yet.
          withPodIPs(podIPs):: self + if std.type(podIPs) == 'array' then self.mixinInstance({ podIPs: podIPs }) else self.mixinInstance({ podIPs: [podIPs] }),
          // podIPs holds the IP addresses allocated to the pod. If this field is specified, the 0th entry must match the podIP field. Pods may be allocated at most 1 value for each of IPv4 and IPv6. This list is empty if no IPs have been allocated yet.
          withPodIPsMixin(podIPs):: self + if std.type(podIPs) == 'array' then self.mixinInstance({ podIPs+: podIPs }) else self.mixinInstance({ podIPs+: [podIPs] }),
          podIPsType:: hidden.v1.PodIP,
          // The Quality of Service (QOS) classification assigned to the pod based on resource requirements See PodQOSClass type for available QOS classes More info: https://git.k8s.io/community/contributors/design-proposals/node/resource-qos.md
          withQosClass(qosClass):: self + self.mixinInstance({ qosClass: qosClass }),
          // A brief CamelCase message indicating details about why the pod is in this state. e.g. 'Evicted'
          withReason(reason):: self + self.mixinInstance({ reason: reason }),
          mixin:: {
            // RFC 3339 date and time at which the object was acknowledged by the Kubelet. This is before the Kubelet pulled the container image(s) for the pod.
            withStartTime(startTime):: self + self.mixinInstance({ startTime: startTime }),
          },
        },
        // The pod this Toleration is attached to tolerates any taint that matches the triple <key,value,effect> using the matching operator <operator>.
        toleration:: {
          local kind = { kind: 'Toleration' },
          // Effect indicates the taint effect to match. Empty means match all taint effects. When specified, allowed values are NoSchedule, PreferNoSchedule and NoExecute.
          withEffect(effect):: self + self.mixinInstance({ effect: effect }),
          // Key is the taint key that the toleration applies to. Empty means match all taint keys. If the key is empty, operator must be Exists; this combination means to match all values and all keys.
          withKey(key):: self + self.mixinInstance({ key: key }),
          // Operator represents a key's relationship to the value. Valid operators are Exists and Equal. Defaults to Equal. Exists is equivalent to wildcard for value, so that a pod can tolerate all taints of a particular category.
          withOperator(operator):: self + self.mixinInstance({ operator: operator }),
          // TolerationSeconds represents the period of time the toleration (which must be of effect NoExecute, otherwise this field is ignored) tolerates the taint. By default, it is not set, which means tolerate the taint forever (do not evict). Zero and negative values will be treated as 0 (evict immediately) by the system.
          withTolerationSeconds(tolerationSeconds):: self + self.mixinInstance({ tolerationSeconds: tolerationSeconds }),
          // Value is the taint value the toleration matches to. If the operator is Exists, the value should be empty, otherwise just a regular string.
          withValue(value):: self + self.mixinInstance({ value: value }),
          mixin:: {},
        },
        // The weights of all of the matched WeightedPodAffinityTerm fields are added per-node to find the most preferred node(s)
        weightedPodAffinityTerm:: {
          local kind = { kind: 'WeightedPodAffinityTerm' },
          // weight associated with matching the corresponding podAffinityTerm, in the range 1-100.
          withWeight(weight):: self + self.mixinInstance({ weight: weight }),
          mixin:: {
            // Required. A pod affinity term, associated with the corresponding weight.
            podAffinityTerm:: {
              local __mixinPodAffinityTerm(podAffinityTerm) = { podAffinityTerm+: podAffinityTerm },
              mixinInstance(podAffinityTerm):: __mixinPodAffinityTerm(podAffinityTerm),
              // A label query over a set of resources, in this case pods.
              labelSelector:: {
                local __mixinLabelSelector(labelSelector) = { labelSelector+: labelSelector },
                mixinInstance(labelSelector):: __mixinLabelSelector(labelSelector),
                // matchExpressions is a list of label selector requirements. The requirements are ANDed.
                withMatchExpressions(matchExpressions):: self + if std.type(matchExpressions) == 'array' then self.mixinInstance({ matchExpressions: matchExpressions }) else self.mixinInstance({ matchExpressions: [matchExpressions] }),
                // matchExpressions is a list of label selector requirements. The requirements are ANDed.
                withMatchExpressionsMixin(matchExpressions):: self + if std.type(matchExpressions) == 'array' then self.mixinInstance({ matchExpressions+: matchExpressions }) else self.mixinInstance({ matchExpressions+: [matchExpressions] }),
                matchExpressionsType:: hidden.meta.v1.LabelSelectorRequirement,
                // matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels map is equivalent to an element of matchExpressions, whose key field is "key", the operator is "In", and the values array contains only "value". The requirements are ANDed.
                withMatchLabels(matchLabels):: self + self.mixinInstance({ matchLabels: matchLabels }),
              },
              // namespaces specifies which namespaces the labelSelector applies to (matches against); null or empty list means "this pod's namespace"
              withNamespaces(namespaces):: self + if std.type(namespaces) == 'array' then self.mixinInstance({ namespaces: namespaces }) else self.mixinInstance({ namespaces: [namespaces] }),
              // namespaces specifies which namespaces the labelSelector applies to (matches against); null or empty list means "this pod's namespace"
              withNamespacesMixin(namespaces):: self + if std.type(namespaces) == 'array' then self.mixinInstance({ namespaces+: namespaces }) else self.mixinInstance({ namespaces+: [namespaces] }),
              // This pod should be co-located (affinity) or not co-located (anti-affinity) with the pods matching the labelSelector in the specified namespaces, where co-located is defined as running on a node whose value of the label with key topologyKey matches that of any node on which any of the selected pods is running. Empty topologyKey is not allowed.
              withTopologyKey(topologyKey):: self + self.mixinInstance({ topologyKey: topologyKey }),
            },
          },
        },
        // FlexVolume represents a generic volume resource that is provisioned/attached using an exec based plugin.
        flexVolumeSource:: {
          local kind = { kind: 'FlexVolumeSource' },
          // Driver is the name of the driver to use for this volume.
          withDriver(driver):: self + self.mixinInstance({ driver: driver }),
          // Filesystem type to mount. Must be a filesystem type supported by the host operating system. Ex. "ext4", "xfs", "ntfs". The default filesystem depends on FlexVolume script.
          withFsType(fsType):: self + self.mixinInstance({ fsType: fsType }),
          // Optional: Extra command options if any.
          withOptions(options):: self + self.mixinInstance({ options: options }),
          // Optional: Defaults to false (read/write). ReadOnly here will force the ReadOnly setting in VolumeMounts.
          withReadOnly(readOnly):: self + self.mixinInstance({ readOnly: readOnly }),
          mixin:: {
            // Optional: SecretRef is reference to the secret object containing sensitive information to pass to the plugin scripts. This may be empty if no secret object is specified. If the secret object contains more than one secret, all secrets are passed to the plugin scripts.
            secretRef:: {
              local __mixinSecretRef(secretRef) = { secretRef+: secretRef },
              mixinInstance(secretRef):: __mixinSecretRef(secretRef),
              // Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
              withName(name):: self + self.mixinInstance({ name: name }),
            },
          },
        },
        // ConfigMapEnvSource selects a ConfigMap to populate the environment variables with.
        //
        // The contents of the target ConfigMap's Data field will represent the key-value pairs as environment variables.
        configMapEnvSource:: {
          local kind = { kind: 'ConfigMapEnvSource' },
          // Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
          withName(name):: self + self.mixinInstance({ name: name }),
          // Specify whether the ConfigMap must be defined
          withOptional(optional):: self + self.mixinInstance({ optional: optional }),
          mixin:: {},
        },
        // Selects a key from a ConfigMap.
        configMapKeySelector:: {
          local kind = { kind: 'ConfigMapKeySelector' },
          // The key to select.
          withKey(key):: self + self.mixinInstance({ key: key }),
          // Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
          withName(name):: self + self.mixinInstance({ name: name }),
          // Specify whether the ConfigMap or its key must be defined
          withOptional(optional):: self + self.mixinInstance({ optional: optional }),
          mixin:: {},
        },
        // ExecAction describes a "run in container" action.
        execAction:: {
          local kind = { kind: 'ExecAction' },
          // Command is the command line to execute inside the container, the working directory for the command  is root ('/') in the container's filesystem. The command is simply exec'd, it is not run inside a shell, so traditional shell instructions ('|', etc) won't work. To use a shell, you need to explicitly call out to that shell. Exit status of 0 is treated as live/healthy and non-zero is unhealthy.
          withCommand(command):: self + if std.type(command) == 'array' then self.mixinInstance({ command: command }) else self.mixinInstance({ command: [command] }),
          // Command is the command line to execute inside the container, the working directory for the command  is root ('/') in the container's filesystem. The command is simply exec'd, it is not run inside a shell, so traditional shell instructions ('|', etc) won't work. To use a shell, you need to explicitly call out to that shell. Exit status of 0 is treated as live/healthy and non-zero is unhealthy.
          withCommandMixin(command):: self + if std.type(command) == 'array' then self.mixinInstance({ command+: command }) else self.mixinInstance({ command+: [command] }),
          mixin:: {},
        },
        // Represents an ISCSI disk. ISCSI volumes can only be mounted as read/write once. ISCSI volumes support ownership management and SELinux relabeling.
        iscsiVolumeSource:: {
          local kind = { kind: 'ISCSIVolumeSource' },
          // whether support iSCSI Discovery CHAP authentication
          withChapAuthDiscovery(chapAuthDiscovery):: self + self.mixinInstance({ chapAuthDiscovery: chapAuthDiscovery }),
          // whether support iSCSI Session CHAP authentication
          withChapAuthSession(chapAuthSession):: self + self.mixinInstance({ chapAuthSession: chapAuthSession }),
          // Filesystem type of the volume that you want to mount. Tip: Ensure that the filesystem type is supported by the host operating system. Examples: "ext4", "xfs", "ntfs". Implicitly inferred to be "ext4" if unspecified. More info: https://kubernetes.io/docs/concepts/storage/volumes#iscsi
          withFsType(fsType):: self + self.mixinInstance({ fsType: fsType }),
          // Custom iSCSI Initiator Name. If initiatorName is specified with iscsiInterface simultaneously, new iSCSI interface <target portal>:<volume name> will be created for the connection.
          withInitiatorName(initiatorName):: self + self.mixinInstance({ initiatorName: initiatorName }),
          // Target iSCSI Qualified Name.
          withIqn(iqn):: self + self.mixinInstance({ iqn: iqn }),
          // iSCSI Interface Name that uses an iSCSI transport. Defaults to 'default' (tcp).
          withIscsiInterface(iscsiInterface):: self + self.mixinInstance({ iscsiInterface: iscsiInterface }),
          // iSCSI Target Lun number.
          withLun(lun):: self + self.mixinInstance({ lun: lun }),
          // iSCSI Target Portal List. The portal is either an IP or ip_addr:port if the port is other than default (typically TCP ports 860 and 3260).
          withPortals(portals):: self + if std.type(portals) == 'array' then self.mixinInstance({ portals: portals }) else self.mixinInstance({ portals: [portals] }),
          // iSCSI Target Portal List. The portal is either an IP or ip_addr:port if the port is other than default (typically TCP ports 860 and 3260).
          withPortalsMixin(portals):: self + if std.type(portals) == 'array' then self.mixinInstance({ portals+: portals }) else self.mixinInstance({ portals+: [portals] }),
          // ReadOnly here will force the ReadOnly setting in VolumeMounts. Defaults to false.
          withReadOnly(readOnly):: self + self.mixinInstance({ readOnly: readOnly }),
          // iSCSI Target Portal. The Portal is either an IP or ip_addr:port if the port is other than default (typically TCP ports 860 and 3260).
          withTargetPortal(targetPortal):: self + self.mixinInstance({ targetPortal: targetPortal }),
          mixin:: {
            // CHAP Secret for iSCSI target and initiator authentication
            secretRef:: {
              local __mixinSecretRef(secretRef) = { secretRef+: secretRef },
              mixinInstance(secretRef):: __mixinSecretRef(secretRef),
              // Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
              withName(name):: self + self.mixinInstance({ name: name }),
            },
          },
        },
        // PodDNSConfig defines the DNS parameters of a pod in addition to those generated from DNSPolicy.
        podDNSConfig:: {
          local kind = { kind: 'PodDNSConfig' },
          // A list of DNS name server IP addresses. This will be appended to the base nameservers generated from DNSPolicy. Duplicated nameservers will be removed.
          withNameservers(nameservers):: self + if std.type(nameservers) == 'array' then self.mixinInstance({ nameservers: nameservers }) else self.mixinInstance({ nameservers: [nameservers] }),
          // A list of DNS name server IP addresses. This will be appended to the base nameservers generated from DNSPolicy. Duplicated nameservers will be removed.
          withNameserversMixin(nameservers):: self + if std.type(nameservers) == 'array' then self.mixinInstance({ nameservers+: nameservers }) else self.mixinInstance({ nameservers+: [nameservers] }),
          // A list of DNS resolver options. This will be merged with the base options generated from DNSPolicy. Duplicated entries will be removed. Resolution options given in Options will override those that appear in the base DNSPolicy.
          withOptions(options):: self + if std.type(options) == 'array' then self.mixinInstance({ options: options }) else self.mixinInstance({ options: [options] }),
          // A list of DNS resolver options. This will be merged with the base options generated from DNSPolicy. Duplicated entries will be removed. Resolution options given in Options will override those that appear in the base DNSPolicy.
          withOptionsMixin(options):: self + if std.type(options) == 'array' then self.mixinInstance({ options+: options }) else self.mixinInstance({ options+: [options] }),
          optionsType:: hidden.v1.PodDNSConfigOption,
          // A list of DNS search domains for host-name lookup. This will be appended to the base search paths generated from DNSPolicy. Duplicated search paths will be removed.
          withSearches(searches):: self + if std.type(searches) == 'array' then self.mixinInstance({ searches: searches }) else self.mixinInstance({ searches: [searches] }),
          // A list of DNS search domains for host-name lookup. This will be appended to the base search paths generated from DNSPolicy. Duplicated search paths will be removed.
          withSearchesMixin(searches):: self + if std.type(searches) == 'array' then self.mixinInstance({ searches+: searches }) else self.mixinInstance({ searches+: [searches] }),
          mixin:: {},
        },
        // ScaleIOVolumeSource represents a persistent ScaleIO volume
        scaleIOVolumeSource:: {
          local kind = { kind: 'ScaleIOVolumeSource' },
          // Filesystem type to mount. Must be a filesystem type supported by the host operating system. Ex. "ext4", "xfs", "ntfs". Default is "xfs".
          withFsType(fsType):: self + self.mixinInstance({ fsType: fsType }),
          // The host address of the ScaleIO API Gateway.
          withGateway(gateway):: self + self.mixinInstance({ gateway: gateway }),
          // The name of the ScaleIO Protection Domain for the configured storage.
          withProtectionDomain(protectionDomain):: self + self.mixinInstance({ protectionDomain: protectionDomain }),
          // Defaults to false (read/write). ReadOnly here will force the ReadOnly setting in VolumeMounts.
          withReadOnly(readOnly):: self + self.mixinInstance({ readOnly: readOnly }),
          // Flag to enable/disable SSL communication with Gateway, default false
          withSslEnabled(sslEnabled):: self + self.mixinInstance({ sslEnabled: sslEnabled }),
          // Indicates whether the storage for a volume should be ThickProvisioned or ThinProvisioned. Default is ThinProvisioned.
          withStorageMode(storageMode):: self + self.mixinInstance({ storageMode: storageMode }),
          // The ScaleIO Storage Pool associated with the protection domain.
          withStoragePool(storagePool):: self + self.mixinInstance({ storagePool: storagePool }),
          // The name of the storage system as configured in ScaleIO.
          withSystem(system):: self + self.mixinInstance({ system: system }),
          // The name of a volume already created in the ScaleIO system that is associated with this volume source.
          withVolumeName(volumeName):: self + self.mixinInstance({ volumeName: volumeName }),
          mixin:: {
            // SecretRef references to the secret for ScaleIO user and other sensitive information. If this is not provided, Login operation will fail.
            secretRef:: {
              local __mixinSecretRef(secretRef) = { secretRef+: secretRef },
              mixinInstance(secretRef):: __mixinSecretRef(secretRef),
              // Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
              withName(name):: self + self.mixinInstance({ name: name }),
            },
          },
        },
        // AzureDisk represents an Azure Data Disk mount on the host and bind mount to the pod.
        azureDiskVolumeSource:: {
          local kind = { kind: 'AzureDiskVolumeSource' },
          // Host Caching mode: None, Read Only, Read Write.
          withCachingMode(cachingMode):: self + self.mixinInstance({ cachingMode: cachingMode }),
          // The Name of the data disk in the blob storage
          withDiskName(diskName):: self + self.mixinInstance({ diskName: diskName }),
          // The URI the data disk in the blob storage
          withDiskURI(diskURI):: self + self.mixinInstance({ diskURI: diskURI }),
          // Filesystem type to mount. Must be a filesystem type supported by the host operating system. Ex. "ext4", "xfs", "ntfs". Implicitly inferred to be "ext4" if unspecified.
          withFsType(fsType):: self + self.mixinInstance({ fsType: fsType }),
          // Defaults to false (read/write). ReadOnly here will force the ReadOnly setting in VolumeMounts.
          withReadOnly(readOnly):: self + self.mixinInstance({ readOnly: readOnly }),
          mixin:: {},
        },
        // PersistentVolumeClaimVolumeSource references the user's PVC in the same namespace. This volume finds the bound PV and mounts that volume for the pod. A PersistentVolumeClaimVolumeSource is, essentially, a wrapper around another type of volume that is owned by someone else (the system).
        persistentVolumeClaimVolumeSource:: {
          local kind = { kind: 'PersistentVolumeClaimVolumeSource' },
          // ClaimName is the name of a PersistentVolumeClaim in the same namespace as the pod using this volume. More info: https://kubernetes.io/docs/concepts/storage/persistent-volumes#persistentvolumeclaims
          withClaimName(claimName):: self + self.mixinInstance({ claimName: claimName }),
          // Will force the ReadOnly setting in VolumeMounts. Default false.
          withReadOnly(readOnly):: self + self.mixinInstance({ readOnly: readOnly }),
          mixin:: {},
        },
        // WindowsSecurityContextOptions contain Windows-specific options and credentials.
        windowsSecurityContextOptions:: {
          local kind = { kind: 'WindowsSecurityContextOptions' },
          // GMSACredentialSpec is where the GMSA admission webhook (https://github.com/kubernetes-sigs/windows-gmsa) inlines the contents of the GMSA credential spec named by the GMSACredentialSpecName field. This field is alpha-level and is only honored by servers that enable the WindowsGMSA feature flag.
          withGmsaCredentialSpec(gmsaCredentialSpec):: self + self.mixinInstance({ gmsaCredentialSpec: gmsaCredentialSpec }),
          // GMSACredentialSpecName is the name of the GMSA credential spec to use. This field is alpha-level and is only honored by servers that enable the WindowsGMSA feature flag.
          withGmsaCredentialSpecName(gmsaCredentialSpecName):: self + self.mixinInstance({ gmsaCredentialSpecName: gmsaCredentialSpecName }),
          // The UserName in Windows to run the entrypoint of the container process. Defaults to the user specified in image metadata if unspecified. May also be set in PodSecurityContext. If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence. This field is beta-level and may be disabled with the WindowsRunAsUserName feature flag.
          withRunAsUserName(runAsUserName):: self + self.mixinInstance({ runAsUserName: runAsUserName }),
          mixin:: {},
        },
        // Represents an empty directory for a pod. Empty directory volumes support ownership management and SELinux relabeling.
        emptyDirVolumeSource:: {
          local kind = { kind: 'EmptyDirVolumeSource' },
          // What type of storage medium should back this directory. The default is "" which means to use the node's default medium. Must be an empty string (default) or Memory. More info: https://kubernetes.io/docs/concepts/storage/volumes#emptydir
          withMedium(medium):: self + self.mixinInstance({ medium: medium }),
          mixin:: {
            // Total amount of local storage required for this EmptyDir volume. The size limit is also applicable for memory medium. The maximum usage on memory medium EmptyDir would be the minimum value between the SizeLimit specified here and the sum of memory limits of all containers in a pod. The default is nil which means that the limit is undefined. More info: http://kubernetes.io/docs/user-guide/volumes#emptydir
            withSizeLimit(sizeLimit):: self + self.mixinInstance({ sizeLimit: sizeLimit }),
          },
        },
        // ContainerStatus contains details for the current status of this container.
        containerStatus:: {
          local kind = { kind: 'ContainerStatus' },
          // Container's ID in the format 'docker://<container_id>'.
          withContainerID(containerID):: self + self.mixinInstance({ containerID: containerID }),
          // The image the container is running. More info: https://kubernetes.io/docs/concepts/containers/images
          withImage(image):: self + self.mixinInstance({ image: image }),
          // ImageID of the container's image.
          withImageID(imageID):: self + self.mixinInstance({ imageID: imageID }),
          // This must be a DNS_LABEL. Each container in a pod must have a unique name. Cannot be updated.
          withName(name):: self + self.mixinInstance({ name: name }),
          // Specifies whether the container has passed its readiness probe.
          withReady(ready):: self + self.mixinInstance({ ready: ready }),
          // The number of times the container has been restarted, currently based on the number of dead containers that have not yet been removed. Note that this is calculated from dead containers. But those containers are subject to garbage collection. This value will get capped at 5 by GC.
          withRestartCount(restartCount):: self + self.mixinInstance({ restartCount: restartCount }),
          // Specifies whether the container has passed its startup probe. Initialized as false, becomes true after startupProbe is considered successful. Resets to false when the container is restarted, or if kubelet loses state temporarily. Is always true when no startupProbe is defined.
          withStarted(started):: self + self.mixinInstance({ started: started }),
          mixin:: {
            // Details about the container's last termination condition.
            lastState:: {
              local __mixinLastState(lastState) = { lastState+: lastState },
              mixinInstance(lastState):: __mixinLastState(lastState),
              // Details about a running container
              running:: {
                local __mixinRunning(running) = { running+: running },
                mixinInstance(running):: __mixinRunning(running),
                // Time at which the container was last (re-)started
                withStartedAt(startedAt):: self + self.mixinInstance({ startedAt: startedAt }),
              },
              // Details about a terminated container
              terminated:: {
                local __mixinTerminated(terminated) = { terminated+: terminated },
                mixinInstance(terminated):: __mixinTerminated(terminated),
                // Container's ID in the format 'docker://<container_id>'
                withContainerID(containerID):: self + self.mixinInstance({ containerID: containerID }),
                // Exit status from the last termination of the container
                withExitCode(exitCode):: self + self.mixinInstance({ exitCode: exitCode }),
                // Time at which the container last terminated
                withFinishedAt(finishedAt):: self + self.mixinInstance({ finishedAt: finishedAt }),
                // Message regarding the last termination of the container
                withMessage(message):: self + self.mixinInstance({ message: message }),
                // (brief) reason from the last termination of the container
                withReason(reason):: self + self.mixinInstance({ reason: reason }),
                // Signal from the last termination of the container
                withSignal(signal):: self + self.mixinInstance({ signal: signal }),
                // Time at which previous execution of the container started
                withStartedAt(startedAt):: self + self.mixinInstance({ startedAt: startedAt }),
              },
              // Details about a waiting container
              waiting:: {
                local __mixinWaiting(waiting) = { waiting+: waiting },
                mixinInstance(waiting):: __mixinWaiting(waiting),
                // Message regarding why the container is not yet running.
                withMessage(message):: self + self.mixinInstance({ message: message }),
                // (brief) reason the container is not yet running.
                withReason(reason):: self + self.mixinInstance({ reason: reason }),
              },
            },
            // Details about the container's current condition.
            state:: {
              local __mixinState(state) = { state+: state },
              mixinInstance(state):: __mixinState(state),
              // Details about a running container
              running:: {
                local __mixinRunning(running) = { running+: running },
                mixinInstance(running):: __mixinRunning(running),
                // Time at which the container was last (re-)started
                withStartedAt(startedAt):: self + self.mixinInstance({ startedAt: startedAt }),
              },
              // Details about a terminated container
              terminated:: {
                local __mixinTerminated(terminated) = { terminated+: terminated },
                mixinInstance(terminated):: __mixinTerminated(terminated),
                // Container's ID in the format 'docker://<container_id>'
                withContainerID(containerID):: self + self.mixinInstance({ containerID: containerID }),
                // Exit status from the last termination of the container
                withExitCode(exitCode):: self + self.mixinInstance({ exitCode: exitCode }),
                // Time at which the container last terminated
                withFinishedAt(finishedAt):: self + self.mixinInstance({ finishedAt: finishedAt }),
                // Message regarding the last termination of the container
                withMessage(message):: self + self.mixinInstance({ message: message }),
                // (brief) reason from the last termination of the container
                withReason(reason):: self + self.mixinInstance({ reason: reason }),
                // Signal from the last termination of the container
                withSignal(signal):: self + self.mixinInstance({ signal: signal }),
                // Time at which previous execution of the container started
                withStartedAt(startedAt):: self + self.mixinInstance({ startedAt: startedAt }),
              },
              // Details about a waiting container
              waiting:: {
                local __mixinWaiting(waiting) = { waiting+: waiting },
                mixinInstance(waiting):: __mixinWaiting(waiting),
                // Message regarding why the container is not yet running.
                withMessage(message):: self + self.mixinInstance({ message: message }),
                // (brief) reason the container is not yet running.
                withReason(reason):: self + self.mixinInstance({ reason: reason }),
              },
            },
          },
        },
        // Represents an NFS mount that lasts the lifetime of a pod. NFS volumes do not support ownership management or SELinux relabeling.
        nfsVolumeSource:: {
          local kind = { kind: 'NFSVolumeSource' },
          // Path that is exported by the NFS server. More info: https://kubernetes.io/docs/concepts/storage/volumes#nfs
          withPath(path):: self + self.mixinInstance({ path: path }),
          // ReadOnly here will force the NFS export to be mounted with read-only permissions. Defaults to false. More info: https://kubernetes.io/docs/concepts/storage/volumes#nfs
          withReadOnly(readOnly):: self + self.mixinInstance({ readOnly: readOnly }),
          // Server is the hostname or IP address of the NFS server. More info: https://kubernetes.io/docs/concepts/storage/volumes#nfs
          withServer(server):: self + self.mixinInstance({ server: server }),
          mixin:: {},
        },
        // ResourceFieldSelector represents container resources (cpu, memory) and their output format
        resourceFieldSelector:: {
          local kind = { kind: 'ResourceFieldSelector' },
          // Container name: required for volumes, optional for env vars
          withContainerName(containerName):: self + self.mixinInstance({ containerName: containerName }),
          // Required: resource to select
          withResource(resource):: self + self.mixinInstance({ resource: resource }),
          mixin:: {
            // Specifies the output format of the exposed resources, defaults to "1"
            withDivisor(divisor):: self + self.mixinInstance({ divisor: divisor }),
          },
        },
        // AzureFile represents an Azure File Service mount on the host and bind mount to the pod.
        azureFileVolumeSource:: {
          local kind = { kind: 'AzureFileVolumeSource' },
          // Defaults to false (read/write). ReadOnly here will force the ReadOnly setting in VolumeMounts.
          withReadOnly(readOnly):: self + self.mixinInstance({ readOnly: readOnly }),
          // the name of secret that contains Azure Storage Account Name and Key
          withSecretName(secretName):: self + self.mixinInstance({ secretName: secretName }),
          // Share Name
          withShareName(shareName):: self + self.mixinInstance({ shareName: shareName }),
          mixin:: {},
        },
        // EnvFromSource represents the source of a set of ConfigMaps
        envFromSource:: {
          local kind = { kind: 'EnvFromSource' },
          // An optional identifier to prepend to each key in the ConfigMap. Must be a C_IDENTIFIER.
          withPrefix(prefix):: self + self.mixinInstance({ prefix: prefix }),
          mixin:: {
            // The ConfigMap to select from
            configMapRef:: {
              local __mixinConfigMapRef(configMapRef) = { configMapRef+: configMapRef },
              mixinInstance(configMapRef):: __mixinConfigMapRef(configMapRef),
              // Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
              withName(name):: self + self.mixinInstance({ name: name }),
              // Specify whether the ConfigMap must be defined
              withOptional(optional):: self + self.mixinInstance({ optional: optional }),
            },
            // The Secret to select from
            secretRef:: {
              local __mixinSecretRef(secretRef) = { secretRef+: secretRef },
              mixinInstance(secretRef):: __mixinSecretRef(secretRef),
              // Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
              withName(name):: self + self.mixinInstance({ name: name }),
              // Specify whether the Secret must be defined
              withOptional(optional):: self + self.mixinInstance({ optional: optional }),
            },
          },
        },
        // Maps a string key to a path within a volume.
        keyToPath:: {
          local kind = { kind: 'KeyToPath' },
          // The key to project.
          withKey(key):: self + self.mixinInstance({ key: key }),
          // Optional: mode bits to use on this file, must be a value between 0 and 0777. If not specified, the volume defaultMode will be used. This might be in conflict with other options that affect the file mode, like fsGroup, and the result can be other mode bits set.
          withMode(mode):: self + self.mixinInstance({ mode: mode }),
          // The relative path of the file to map the key to. May not be an absolute path. May not contain the path element '..'. May not start with the string '..'.
          withPath(path):: self + self.mixinInstance({ path: path }),
          mixin:: {},
        },
        // PodSpec is a description of a pod.
        podSpec:: {
          local kind = { kind: 'PodSpec' },
          // Optional duration in seconds the pod may be active on the node relative to StartTime before the system will actively try to mark it failed and kill associated containers. Value must be a positive integer.
          withActiveDeadlineSeconds(activeDeadlineSeconds):: self + self.mixinInstance({ activeDeadlineSeconds: activeDeadlineSeconds }),
          // AutomountServiceAccountToken indicates whether a service account token should be automatically mounted.
          withAutomountServiceAccountToken(automountServiceAccountToken):: self + self.mixinInstance({ automountServiceAccountToken: automountServiceAccountToken }),
          // List of containers belonging to the pod. Containers cannot currently be added or removed. There must be at least one container in a Pod. Cannot be updated.
          withContainers(containers):: self + if std.type(containers) == 'array' then self.mixinInstance({ containers: containers }) else self.mixinInstance({ containers: [containers] }),
          // List of containers belonging to the pod. Containers cannot currently be added or removed. There must be at least one container in a Pod. Cannot be updated.
          withContainersMixin(containers):: self + if std.type(containers) == 'array' then self.mixinInstance({ containers+: containers }) else self.mixinInstance({ containers+: [containers] }),
          containersType:: hidden.v1.Container,
          // Set DNS policy for the pod. Defaults to "ClusterFirst". Valid values are 'ClusterFirstWithHostNet', 'ClusterFirst', 'Default' or 'None'. DNS parameters given in DNSConfig will be merged with the policy selected with DNSPolicy. To have DNS options set along with hostNetwork, you have to specify DNS policy explicitly to 'ClusterFirstWithHostNet'.
          withDnsPolicy(dnsPolicy):: self + self.mixinInstance({ dnsPolicy: dnsPolicy }),
          // EnableServiceLinks indicates whether information about services should be injected into pod's environment variables, matching the syntax of Docker links. Optional: Defaults to true.
          withEnableServiceLinks(enableServiceLinks):: self + self.mixinInstance({ enableServiceLinks: enableServiceLinks }),
          // List of ephemeral containers run in this pod. Ephemeral containers may be run in an existing pod to perform user-initiated actions such as debugging. This list cannot be specified when creating a pod, and it cannot be modified by updating the pod spec. In order to add an ephemeral container to an existing pod, use the pod's ephemeralcontainers subresource. This field is alpha-level and is only honored by servers that enable the EphemeralContainers feature.
          withEphemeralContainers(ephemeralContainers):: self + if std.type(ephemeralContainers) == 'array' then self.mixinInstance({ ephemeralContainers: ephemeralContainers }) else self.mixinInstance({ ephemeralContainers: [ephemeralContainers] }),
          // List of ephemeral containers run in this pod. Ephemeral containers may be run in an existing pod to perform user-initiated actions such as debugging. This list cannot be specified when creating a pod, and it cannot be modified by updating the pod spec. In order to add an ephemeral container to an existing pod, use the pod's ephemeralcontainers subresource. This field is alpha-level and is only honored by servers that enable the EphemeralContainers feature.
          withEphemeralContainersMixin(ephemeralContainers):: self + if std.type(ephemeralContainers) == 'array' then self.mixinInstance({ ephemeralContainers+: ephemeralContainers }) else self.mixinInstance({ ephemeralContainers+: [ephemeralContainers] }),
          ephemeralContainersType:: hidden.v1.EphemeralContainer,
          // HostAliases is an optional list of hosts and IPs that will be injected into the pod's hosts file if specified. This is only valid for non-hostNetwork pods.
          withHostAliases(hostAliases):: self + if std.type(hostAliases) == 'array' then self.mixinInstance({ hostAliases: hostAliases }) else self.mixinInstance({ hostAliases: [hostAliases] }),
          // HostAliases is an optional list of hosts and IPs that will be injected into the pod's hosts file if specified. This is only valid for non-hostNetwork pods.
          withHostAliasesMixin(hostAliases):: self + if std.type(hostAliases) == 'array' then self.mixinInstance({ hostAliases+: hostAliases }) else self.mixinInstance({ hostAliases+: [hostAliases] }),
          hostAliasesType:: hidden.v1.HostAlias,
          // Use the host's ipc namespace. Optional: Default to false.
          withHostIPC(hostIPC):: self + self.mixinInstance({ hostIPC: hostIPC }),
          // Host networking requested for this pod. Use the host's network namespace. If this option is set, the ports that will be used must be specified. Default to false.
          withHostNetwork(hostNetwork):: self + self.mixinInstance({ hostNetwork: hostNetwork }),
          // Use the host's pid namespace. Optional: Default to false.
          withHostPID(hostPID):: self + self.mixinInstance({ hostPID: hostPID }),
          // Specifies the hostname of the Pod If not specified, the pod's hostname will be set to a system-defined value.
          withHostname(hostname):: self + self.mixinInstance({ hostname: hostname }),
          // ImagePullSecrets is an optional list of references to secrets in the same namespace to use for pulling any of the images used by this PodSpec. If specified, these secrets will be passed to individual puller implementations for them to use. For example, in the case of docker, only DockerConfig type secrets are honored. More info: https://kubernetes.io/docs/concepts/containers/images#specifying-imagepullsecrets-on-a-pod
          withImagePullSecrets(imagePullSecrets):: self + if std.type(imagePullSecrets) == 'array' then self.mixinInstance({ imagePullSecrets: imagePullSecrets }) else self.mixinInstance({ imagePullSecrets: [imagePullSecrets] }),
          // ImagePullSecrets is an optional list of references to secrets in the same namespace to use for pulling any of the images used by this PodSpec. If specified, these secrets will be passed to individual puller implementations for them to use. For example, in the case of docker, only DockerConfig type secrets are honored. More info: https://kubernetes.io/docs/concepts/containers/images#specifying-imagepullsecrets-on-a-pod
          withImagePullSecretsMixin(imagePullSecrets):: self + if std.type(imagePullSecrets) == 'array' then self.mixinInstance({ imagePullSecrets+: imagePullSecrets }) else self.mixinInstance({ imagePullSecrets+: [imagePullSecrets] }),
          imagePullSecretsType:: hidden.v1.LocalObjectReference,
          // List of initialization containers belonging to the pod. Init containers are executed in order prior to containers being started. If any init container fails, the pod is considered to have failed and is handled according to its restartPolicy. The name for an init container or normal container must be unique among all containers. Init containers may not have Lifecycle actions, Readiness probes, Liveness probes, or Startup probes. The resourceRequirements of an init container are taken into account during scheduling by finding the highest request/limit for each resource type, and then using the max of of that value or the sum of the normal containers. Limits are applied to init containers in a similar fashion. Init containers cannot currently be added or removed. Cannot be updated. More info: https://kubernetes.io/docs/concepts/workloads/pods/init-containers/
          withInitContainers(initContainers):: self + if std.type(initContainers) == 'array' then self.mixinInstance({ initContainers: initContainers }) else self.mixinInstance({ initContainers: [initContainers] }),
          // List of initialization containers belonging to the pod. Init containers are executed in order prior to containers being started. If any init container fails, the pod is considered to have failed and is handled according to its restartPolicy. The name for an init container or normal container must be unique among all containers. Init containers may not have Lifecycle actions, Readiness probes, Liveness probes, or Startup probes. The resourceRequirements of an init container are taken into account during scheduling by finding the highest request/limit for each resource type, and then using the max of of that value or the sum of the normal containers. Limits are applied to init containers in a similar fashion. Init containers cannot currently be added or removed. Cannot be updated. More info: https://kubernetes.io/docs/concepts/workloads/pods/init-containers/
          withInitContainersMixin(initContainers):: self + if std.type(initContainers) == 'array' then self.mixinInstance({ initContainers+: initContainers }) else self.mixinInstance({ initContainers+: [initContainers] }),
          initContainersType:: hidden.v1.Container,
          // NodeName is a request to schedule this pod onto a specific node. If it is non-empty, the scheduler simply schedules this pod onto that node, assuming that it fits resource requirements.
          withNodeName(nodeName):: self + self.mixinInstance({ nodeName: nodeName }),
          // NodeSelector is a selector which must be true for the pod to fit on a node. Selector which must match a node's labels for the pod to be scheduled on that node. More info: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/
          withNodeSelector(nodeSelector):: self + self.mixinInstance({ nodeSelector: nodeSelector }),
          // Overhead represents the resource overhead associated with running a pod for a given RuntimeClass. This field will be autopopulated at admission time by the RuntimeClass admission controller. If the RuntimeClass admission controller is enabled, overhead must not be set in Pod create requests. The RuntimeClass admission controller will reject Pod create requests which have the overhead already set. If RuntimeClass is configured and selected in the PodSpec, Overhead will be set to the value defined in the corresponding RuntimeClass, otherwise it will remain unset and treated as zero. More info: https://git.k8s.io/enhancements/keps/sig-node/20190226-pod-overhead.md This field is alpha-level as of Kubernetes v1.16, and is only honored by servers that enable the PodOverhead feature.
          withOverhead(overhead):: self + self.mixinInstance({ overhead: overhead }),
          // PreemptionPolicy is the Policy for preempting pods with lower priority. One of Never, PreemptLowerPriority. Defaults to PreemptLowerPriority if unset. This field is alpha-level and is only honored by servers that enable the NonPreemptingPriority feature.
          withPreemptionPolicy(preemptionPolicy):: self + self.mixinInstance({ preemptionPolicy: preemptionPolicy }),
          // The priority value. Various system components use this field to find the priority of the pod. When Priority Admission Controller is enabled, it prevents users from setting this field. The admission controller populates this field from PriorityClassName. The higher the value, the higher the priority.
          withPriority(priority):: self + self.mixinInstance({ priority: priority }),
          // If specified, indicates the pod's priority. "system-node-critical" and "system-cluster-critical" are two special keywords which indicate the highest priorities with the former being the highest priority. Any other name must be defined by creating a PriorityClass object with that name. If not specified, the pod priority will be default or zero if there is no default.
          withPriorityClassName(priorityClassName):: self + self.mixinInstance({ priorityClassName: priorityClassName }),
          // If specified, all readiness gates will be evaluated for pod readiness. A pod is ready when all its containers are ready AND all conditions specified in the readiness gates have status equal to "True" More info: https://git.k8s.io/enhancements/keps/sig-network/0007-pod-ready%2B%2B.md
          withReadinessGates(readinessGates):: self + if std.type(readinessGates) == 'array' then self.mixinInstance({ readinessGates: readinessGates }) else self.mixinInstance({ readinessGates: [readinessGates] }),
          // If specified, all readiness gates will be evaluated for pod readiness. A pod is ready when all its containers are ready AND all conditions specified in the readiness gates have status equal to "True" More info: https://git.k8s.io/enhancements/keps/sig-network/0007-pod-ready%2B%2B.md
          withReadinessGatesMixin(readinessGates):: self + if std.type(readinessGates) == 'array' then self.mixinInstance({ readinessGates+: readinessGates }) else self.mixinInstance({ readinessGates+: [readinessGates] }),
          readinessGatesType:: hidden.v1.PodReadinessGate,
          // Restart policy for all containers within the pod. One of Always, OnFailure, Never. Default to Always. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#restart-policy
          withRestartPolicy(restartPolicy):: self + self.mixinInstance({ restartPolicy: restartPolicy }),
          // RuntimeClassName refers to a RuntimeClass object in the node.k8s.io group, which should be used to run this pod.  If no RuntimeClass resource matches the named class, the pod will not be run. If unset or empty, the "legacy" RuntimeClass will be used, which is an implicit class with an empty definition that uses the default runtime handler. More info: https://git.k8s.io/enhancements/keps/sig-node/runtime-class.md This is a beta feature as of Kubernetes v1.14.
          withRuntimeClassName(runtimeClassName):: self + self.mixinInstance({ runtimeClassName: runtimeClassName }),
          // If specified, the pod will be dispatched by specified scheduler. If not specified, the pod will be dispatched by default scheduler.
          withSchedulerName(schedulerName):: self + self.mixinInstance({ schedulerName: schedulerName }),
          // DeprecatedServiceAccount is a depreciated alias for ServiceAccountName. Deprecated: Use serviceAccountName instead.
          withServiceAccount(serviceAccount):: self + self.mixinInstance({ serviceAccount: serviceAccount }),
          // ServiceAccountName is the name of the ServiceAccount to use to run this pod. More info: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/
          withServiceAccountName(serviceAccountName):: self + self.mixinInstance({ serviceAccountName: serviceAccountName }),
          // Share a single process namespace between all of the containers in a pod. When this is set containers will be able to view and signal processes from other containers in the same pod, and the first process in each container will not be assigned PID 1. HostPID and ShareProcessNamespace cannot both be set. Optional: Default to false.
          withShareProcessNamespace(shareProcessNamespace):: self + self.mixinInstance({ shareProcessNamespace: shareProcessNamespace }),
          // If specified, the fully qualified Pod hostname will be "<hostname>.<subdomain>.<pod namespace>.svc.<cluster domain>". If not specified, the pod will not have a domainname at all.
          withSubdomain(subdomain):: self + self.mixinInstance({ subdomain: subdomain }),
          // Optional duration in seconds the pod needs to terminate gracefully. May be decreased in delete request. Value must be non-negative integer. The value zero indicates delete immediately. If this value is nil, the default grace period will be used instead. The grace period is the duration in seconds after the processes running in the pod are sent a termination signal and the time when the processes are forcibly halted with a kill signal. Set this value longer than the expected cleanup time for your process. Defaults to 30 seconds.
          withTerminationGracePeriodSeconds(terminationGracePeriodSeconds):: self + self.mixinInstance({ terminationGracePeriodSeconds: terminationGracePeriodSeconds }),
          // If specified, the pod's tolerations.
          withTolerations(tolerations):: self + if std.type(tolerations) == 'array' then self.mixinInstance({ tolerations: tolerations }) else self.mixinInstance({ tolerations: [tolerations] }),
          // If specified, the pod's tolerations.
          withTolerationsMixin(tolerations):: self + if std.type(tolerations) == 'array' then self.mixinInstance({ tolerations+: tolerations }) else self.mixinInstance({ tolerations+: [tolerations] }),
          tolerationsType:: hidden.v1.Toleration,
          // TopologySpreadConstraints describes how a group of pods ought to spread across topology domains. Scheduler will schedule pods in a way which abides by the constraints. This field is alpha-level and is only honored by clusters that enables the EvenPodsSpread feature. All topologySpreadConstraints are ANDed.
          withTopologySpreadConstraints(topologySpreadConstraints):: self + if std.type(topologySpreadConstraints) == 'array' then self.mixinInstance({ topologySpreadConstraints: topologySpreadConstraints }) else self.mixinInstance({ topologySpreadConstraints: [topologySpreadConstraints] }),
          // TopologySpreadConstraints describes how a group of pods ought to spread across topology domains. Scheduler will schedule pods in a way which abides by the constraints. This field is alpha-level and is only honored by clusters that enables the EvenPodsSpread feature. All topologySpreadConstraints are ANDed.
          withTopologySpreadConstraintsMixin(topologySpreadConstraints):: self + if std.type(topologySpreadConstraints) == 'array' then self.mixinInstance({ topologySpreadConstraints+: topologySpreadConstraints }) else self.mixinInstance({ topologySpreadConstraints+: [topologySpreadConstraints] }),
          topologySpreadConstraintsType:: hidden.v1.TopologySpreadConstraint,
          // List of volumes that can be mounted by containers belonging to the pod. More info: https://kubernetes.io/docs/concepts/storage/volumes
          withVolumes(volumes):: self + if std.type(volumes) == 'array' then self.mixinInstance({ volumes: volumes }) else self.mixinInstance({ volumes: [volumes] }),
          // List of volumes that can be mounted by containers belonging to the pod. More info: https://kubernetes.io/docs/concepts/storage/volumes
          withVolumesMixin(volumes):: self + if std.type(volumes) == 'array' then self.mixinInstance({ volumes+: volumes }) else self.mixinInstance({ volumes+: [volumes] }),
          volumesType:: hidden.v1.Volume,
          mixin:: {
            // If specified, the pod's scheduling constraints
            affinity:: {
              local __mixinAffinity(affinity) = { affinity+: affinity },
              mixinInstance(affinity):: __mixinAffinity(affinity),
              // Describes node affinity scheduling rules for the pod.
              nodeAffinity:: {
                local __mixinNodeAffinity(nodeAffinity) = { nodeAffinity+: nodeAffinity },
                mixinInstance(nodeAffinity):: __mixinNodeAffinity(nodeAffinity),
                // The scheduler will prefer to schedule pods to nodes that satisfy the affinity expressions specified by this field, but it may choose a node that violates one or more of the expressions. The node that is most preferred is the one with the greatest sum of weights, i.e. for each node that meets all of the scheduling requirements (resource request, requiredDuringScheduling affinity expressions, etc.), compute a sum by iterating through the elements of this field and adding "weight" to the sum if the node matches the corresponding matchExpressions; the node(s) with the highest sum are the most preferred.
                withPreferredDuringSchedulingIgnoredDuringExecution(preferredDuringSchedulingIgnoredDuringExecution):: self + if std.type(preferredDuringSchedulingIgnoredDuringExecution) == 'array' then self.mixinInstance({ preferredDuringSchedulingIgnoredDuringExecution: preferredDuringSchedulingIgnoredDuringExecution }) else self.mixinInstance({ preferredDuringSchedulingIgnoredDuringExecution: [preferredDuringSchedulingIgnoredDuringExecution] }),
                // The scheduler will prefer to schedule pods to nodes that satisfy the affinity expressions specified by this field, but it may choose a node that violates one or more of the expressions. The node that is most preferred is the one with the greatest sum of weights, i.e. for each node that meets all of the scheduling requirements (resource request, requiredDuringScheduling affinity expressions, etc.), compute a sum by iterating through the elements of this field and adding "weight" to the sum if the node matches the corresponding matchExpressions; the node(s) with the highest sum are the most preferred.
                withPreferredDuringSchedulingIgnoredDuringExecutionMixin(preferredDuringSchedulingIgnoredDuringExecution):: self + if std.type(preferredDuringSchedulingIgnoredDuringExecution) == 'array' then self.mixinInstance({ preferredDuringSchedulingIgnoredDuringExecution+: preferredDuringSchedulingIgnoredDuringExecution }) else self.mixinInstance({ preferredDuringSchedulingIgnoredDuringExecution+: [preferredDuringSchedulingIgnoredDuringExecution] }),
                preferredDuringSchedulingIgnoredDuringExecutionType:: hidden.v1.PreferredSchedulingTerm,
                // If the affinity requirements specified by this field are not met at scheduling time, the pod will not be scheduled onto the node. If the affinity requirements specified by this field cease to be met at some point during pod execution (e.g. due to an update), the system may or may not try to eventually evict the pod from its node.
                requiredDuringSchedulingIgnoredDuringExecution:: {
                  local __mixinRequiredDuringSchedulingIgnoredDuringExecution(requiredDuringSchedulingIgnoredDuringExecution) = { requiredDuringSchedulingIgnoredDuringExecution+: requiredDuringSchedulingIgnoredDuringExecution },
                  mixinInstance(requiredDuringSchedulingIgnoredDuringExecution):: __mixinRequiredDuringSchedulingIgnoredDuringExecution(requiredDuringSchedulingIgnoredDuringExecution),
                  // Required. A list of node selector terms. The terms are ORed.
                  withNodeSelectorTerms(nodeSelectorTerms):: self + if std.type(nodeSelectorTerms) == 'array' then self.mixinInstance({ nodeSelectorTerms: nodeSelectorTerms }) else self.mixinInstance({ nodeSelectorTerms: [nodeSelectorTerms] }),
                  // Required. A list of node selector terms. The terms are ORed.
                  withNodeSelectorTermsMixin(nodeSelectorTerms):: self + if std.type(nodeSelectorTerms) == 'array' then self.mixinInstance({ nodeSelectorTerms+: nodeSelectorTerms }) else self.mixinInstance({ nodeSelectorTerms+: [nodeSelectorTerms] }),
                  nodeSelectorTermsType:: hidden.v1.NodeSelectorTerm,
                },
              },
              // Describes pod affinity scheduling rules (e.g. co-locate this pod in the same node, zone, etc. as some other pod(s)).
              podAffinity:: {
                local __mixinPodAffinity(podAffinity) = { podAffinity+: podAffinity },
                mixinInstance(podAffinity):: __mixinPodAffinity(podAffinity),
                // The scheduler will prefer to schedule pods to nodes that satisfy the affinity expressions specified by this field, but it may choose a node that violates one or more of the expressions. The node that is most preferred is the one with the greatest sum of weights, i.e. for each node that meets all of the scheduling requirements (resource request, requiredDuringScheduling affinity expressions, etc.), compute a sum by iterating through the elements of this field and adding "weight" to the sum if the node has pods which matches the corresponding podAffinityTerm; the node(s) with the highest sum are the most preferred.
                withPreferredDuringSchedulingIgnoredDuringExecution(preferredDuringSchedulingIgnoredDuringExecution):: self + if std.type(preferredDuringSchedulingIgnoredDuringExecution) == 'array' then self.mixinInstance({ preferredDuringSchedulingIgnoredDuringExecution: preferredDuringSchedulingIgnoredDuringExecution }) else self.mixinInstance({ preferredDuringSchedulingIgnoredDuringExecution: [preferredDuringSchedulingIgnoredDuringExecution] }),
                // The scheduler will prefer to schedule pods to nodes that satisfy the affinity expressions specified by this field, but it may choose a node that violates one or more of the expressions. The node that is most preferred is the one with the greatest sum of weights, i.e. for each node that meets all of the scheduling requirements (resource request, requiredDuringScheduling affinity expressions, etc.), compute a sum by iterating through the elements of this field and adding "weight" to the sum if the node has pods which matches the corresponding podAffinityTerm; the node(s) with the highest sum are the most preferred.
                withPreferredDuringSchedulingIgnoredDuringExecutionMixin(preferredDuringSchedulingIgnoredDuringExecution):: self + if std.type(preferredDuringSchedulingIgnoredDuringExecution) == 'array' then self.mixinInstance({ preferredDuringSchedulingIgnoredDuringExecution+: preferredDuringSchedulingIgnoredDuringExecution }) else self.mixinInstance({ preferredDuringSchedulingIgnoredDuringExecution+: [preferredDuringSchedulingIgnoredDuringExecution] }),
                preferredDuringSchedulingIgnoredDuringExecutionType:: hidden.v1.WeightedPodAffinityTerm,
                // If the affinity requirements specified by this field are not met at scheduling time, the pod will not be scheduled onto the node. If the affinity requirements specified by this field cease to be met at some point during pod execution (e.g. due to a pod label update), the system may or may not try to eventually evict the pod from its node. When there are multiple elements, the lists of nodes corresponding to each podAffinityTerm are intersected, i.e. all terms must be satisfied.
                withRequiredDuringSchedulingIgnoredDuringExecution(requiredDuringSchedulingIgnoredDuringExecution):: self + if std.type(requiredDuringSchedulingIgnoredDuringExecution) == 'array' then self.mixinInstance({ requiredDuringSchedulingIgnoredDuringExecution: requiredDuringSchedulingIgnoredDuringExecution }) else self.mixinInstance({ requiredDuringSchedulingIgnoredDuringExecution: [requiredDuringSchedulingIgnoredDuringExecution] }),
                // If the affinity requirements specified by this field are not met at scheduling time, the pod will not be scheduled onto the node. If the affinity requirements specified by this field cease to be met at some point during pod execution (e.g. due to a pod label update), the system may or may not try to eventually evict the pod from its node. When there are multiple elements, the lists of nodes corresponding to each podAffinityTerm are intersected, i.e. all terms must be satisfied.
                withRequiredDuringSchedulingIgnoredDuringExecutionMixin(requiredDuringSchedulingIgnoredDuringExecution):: self + if std.type(requiredDuringSchedulingIgnoredDuringExecution) == 'array' then self.mixinInstance({ requiredDuringSchedulingIgnoredDuringExecution+: requiredDuringSchedulingIgnoredDuringExecution }) else self.mixinInstance({ requiredDuringSchedulingIgnoredDuringExecution+: [requiredDuringSchedulingIgnoredDuringExecution] }),
                requiredDuringSchedulingIgnoredDuringExecutionType:: hidden.v1.PodAffinityTerm,
              },
              // Describes pod anti-affinity scheduling rules (e.g. avoid putting this pod in the same node, zone, etc. as some other pod(s)).
              podAntiAffinity:: {
                local __mixinPodAntiAffinity(podAntiAffinity) = { podAntiAffinity+: podAntiAffinity },
                mixinInstance(podAntiAffinity):: __mixinPodAntiAffinity(podAntiAffinity),
                // The scheduler will prefer to schedule pods to nodes that satisfy the anti-affinity expressions specified by this field, but it may choose a node that violates one or more of the expressions. The node that is most preferred is the one with the greatest sum of weights, i.e. for each node that meets all of the scheduling requirements (resource request, requiredDuringScheduling anti-affinity expressions, etc.), compute a sum by iterating through the elements of this field and adding "weight" to the sum if the node has pods which matches the corresponding podAffinityTerm; the node(s) with the highest sum are the most preferred.
                withPreferredDuringSchedulingIgnoredDuringExecution(preferredDuringSchedulingIgnoredDuringExecution):: self + if std.type(preferredDuringSchedulingIgnoredDuringExecution) == 'array' then self.mixinInstance({ preferredDuringSchedulingIgnoredDuringExecution: preferredDuringSchedulingIgnoredDuringExecution }) else self.mixinInstance({ preferredDuringSchedulingIgnoredDuringExecution: [preferredDuringSchedulingIgnoredDuringExecution] }),
                // The scheduler will prefer to schedule pods to nodes that satisfy the anti-affinity expressions specified by this field, but it may choose a node that violates one or more of the expressions. The node that is most preferred is the one with the greatest sum of weights, i.e. for each node that meets all of the scheduling requirements (resource request, requiredDuringScheduling anti-affinity expressions, etc.), compute a sum by iterating through the elements of this field and adding "weight" to the sum if the node has pods which matches the corresponding podAffinityTerm; the node(s) with the highest sum are the most preferred.
                withPreferredDuringSchedulingIgnoredDuringExecutionMixin(preferredDuringSchedulingIgnoredDuringExecution):: self + if std.type(preferredDuringSchedulingIgnoredDuringExecution) == 'array' then self.mixinInstance({ preferredDuringSchedulingIgnoredDuringExecution+: preferredDuringSchedulingIgnoredDuringExecution }) else self.mixinInstance({ preferredDuringSchedulingIgnoredDuringExecution+: [preferredDuringSchedulingIgnoredDuringExecution] }),
                preferredDuringSchedulingIgnoredDuringExecutionType:: hidden.v1.WeightedPodAffinityTerm,
                // If the anti-affinity requirements specified by this field are not met at scheduling time, the pod will not be scheduled onto the node. If the anti-affinity requirements specified by this field cease to be met at some point during pod execution (e.g. due to a pod label update), the system may or may not try to eventually evict the pod from its node. When there are multiple elements, the lists of nodes corresponding to each podAffinityTerm are intersected, i.e. all terms must be satisfied.
                withRequiredDuringSchedulingIgnoredDuringExecution(requiredDuringSchedulingIgnoredDuringExecution):: self + if std.type(requiredDuringSchedulingIgnoredDuringExecution) == 'array' then self.mixinInstance({ requiredDuringSchedulingIgnoredDuringExecution: requiredDuringSchedulingIgnoredDuringExecution }) else self.mixinInstance({ requiredDuringSchedulingIgnoredDuringExecution: [requiredDuringSchedulingIgnoredDuringExecution] }),
                // If the anti-affinity requirements specified by this field are not met at scheduling time, the pod will not be scheduled onto the node. If the anti-affinity requirements specified by this field cease to be met at some point during pod execution (e.g. due to a pod label update), the system may or may not try to eventually evict the pod from its node. When there are multiple elements, the lists of nodes corresponding to each podAffinityTerm are intersected, i.e. all terms must be satisfied.
                withRequiredDuringSchedulingIgnoredDuringExecutionMixin(requiredDuringSchedulingIgnoredDuringExecution):: self + if std.type(requiredDuringSchedulingIgnoredDuringExecution) == 'array' then self.mixinInstance({ requiredDuringSchedulingIgnoredDuringExecution+: requiredDuringSchedulingIgnoredDuringExecution }) else self.mixinInstance({ requiredDuringSchedulingIgnoredDuringExecution+: [requiredDuringSchedulingIgnoredDuringExecution] }),
                requiredDuringSchedulingIgnoredDuringExecutionType:: hidden.v1.PodAffinityTerm,
              },
            },
            // Specifies the DNS parameters of a pod. Parameters specified here will be merged to the generated DNS configuration based on DNSPolicy.
            dnsConfig:: {
              local __mixinDnsConfig(dnsConfig) = { dnsConfig+: dnsConfig },
              mixinInstance(dnsConfig):: __mixinDnsConfig(dnsConfig),
              // A list of DNS name server IP addresses. This will be appended to the base nameservers generated from DNSPolicy. Duplicated nameservers will be removed.
              withNameservers(nameservers):: self + if std.type(nameservers) == 'array' then self.mixinInstance({ nameservers: nameservers }) else self.mixinInstance({ nameservers: [nameservers] }),
              // A list of DNS name server IP addresses. This will be appended to the base nameservers generated from DNSPolicy. Duplicated nameservers will be removed.
              withNameserversMixin(nameservers):: self + if std.type(nameservers) == 'array' then self.mixinInstance({ nameservers+: nameservers }) else self.mixinInstance({ nameservers+: [nameservers] }),
              // A list of DNS resolver options. This will be merged with the base options generated from DNSPolicy. Duplicated entries will be removed. Resolution options given in Options will override those that appear in the base DNSPolicy.
              withOptions(options):: self + if std.type(options) == 'array' then self.mixinInstance({ options: options }) else self.mixinInstance({ options: [options] }),
              // A list of DNS resolver options. This will be merged with the base options generated from DNSPolicy. Duplicated entries will be removed. Resolution options given in Options will override those that appear in the base DNSPolicy.
              withOptionsMixin(options):: self + if std.type(options) == 'array' then self.mixinInstance({ options+: options }) else self.mixinInstance({ options+: [options] }),
              optionsType:: hidden.v1.PodDNSConfigOption,
              // A list of DNS search domains for host-name lookup. This will be appended to the base search paths generated from DNSPolicy. Duplicated search paths will be removed.
              withSearches(searches):: self + if std.type(searches) == 'array' then self.mixinInstance({ searches: searches }) else self.mixinInstance({ searches: [searches] }),
              // A list of DNS search domains for host-name lookup. This will be appended to the base search paths generated from DNSPolicy. Duplicated search paths will be removed.
              withSearchesMixin(searches):: self + if std.type(searches) == 'array' then self.mixinInstance({ searches+: searches }) else self.mixinInstance({ searches+: [searches] }),
            },
            // SecurityContext holds pod-level security attributes and common container settings. Optional: Defaults to empty.  See type description for default values of each field.
            securityContext:: {
              local __mixinSecurityContext(securityContext) = { securityContext+: securityContext },
              mixinInstance(securityContext):: __mixinSecurityContext(securityContext),
              // A special supplemental group that applies to all containers in a pod. Some volume types allow the Kubelet to change the ownership of that volume to be owned by the pod:
              //
              // 1. The owning GID will be the FSGroup 2. The setgid bit is set (new files created in the volume will be owned by FSGroup) 3. The permission bits are OR'd with rw-rw----
              //
              // If unset, the Kubelet will not modify the ownership and permissions of any volume.
              withFsGroup(fsGroup):: self + self.mixinInstance({ fsGroup: fsGroup }),
              // The GID to run the entrypoint of the container process. Uses runtime default if unset. May also be set in SecurityContext.  If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence for that container.
              withRunAsGroup(runAsGroup):: self + self.mixinInstance({ runAsGroup: runAsGroup }),
              // Indicates that the container must run as a non-root user. If true, the Kubelet will validate the image at runtime to ensure that it does not run as UID 0 (root) and fail to start the container if it does. If unset or false, no such validation will be performed. May also be set in SecurityContext.  If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence.
              withRunAsNonRoot(runAsNonRoot):: self + self.mixinInstance({ runAsNonRoot: runAsNonRoot }),
              // The UID to run the entrypoint of the container process. Defaults to user specified in image metadata if unspecified. May also be set in SecurityContext.  If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence for that container.
              withRunAsUser(runAsUser):: self + self.mixinInstance({ runAsUser: runAsUser }),
              // The SELinux context to be applied to all containers. If unspecified, the container runtime will allocate a random SELinux context for each container.  May also be set in SecurityContext.  If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence for that container.
              seLinuxOptions:: {
                local __mixinSeLinuxOptions(seLinuxOptions) = { seLinuxOptions+: seLinuxOptions },
                mixinInstance(seLinuxOptions):: __mixinSeLinuxOptions(seLinuxOptions),
                // Level is SELinux level label that applies to the container.
                withLevel(level):: self + self.mixinInstance({ level: level }),
                // Role is a SELinux role label that applies to the container.
                withRole(role):: self + self.mixinInstance({ role: role }),
                // Type is a SELinux type label that applies to the container.
                withType(type):: self + self.mixinInstance({ type: type }),
                // User is a SELinux user label that applies to the container.
                withUser(user):: self + self.mixinInstance({ user: user }),
              },
              // A list of groups applied to the first process run in each container, in addition to the container's primary GID.  If unspecified, no groups will be added to any container.
              withSupplementalGroups(supplementalGroups):: self + if std.type(supplementalGroups) == 'array' then self.mixinInstance({ supplementalGroups: supplementalGroups }) else self.mixinInstance({ supplementalGroups: [supplementalGroups] }),
              // A list of groups applied to the first process run in each container, in addition to the container's primary GID.  If unspecified, no groups will be added to any container.
              withSupplementalGroupsMixin(supplementalGroups):: self + if std.type(supplementalGroups) == 'array' then self.mixinInstance({ supplementalGroups+: supplementalGroups }) else self.mixinInstance({ supplementalGroups+: [supplementalGroups] }),
              // Sysctls hold a list of namespaced sysctls used for the pod. Pods with unsupported sysctls (by the container runtime) might fail to launch.
              withSysctls(sysctls):: self + if std.type(sysctls) == 'array' then self.mixinInstance({ sysctls: sysctls }) else self.mixinInstance({ sysctls: [sysctls] }),
              // Sysctls hold a list of namespaced sysctls used for the pod. Pods with unsupported sysctls (by the container runtime) might fail to launch.
              withSysctlsMixin(sysctls):: self + if std.type(sysctls) == 'array' then self.mixinInstance({ sysctls+: sysctls }) else self.mixinInstance({ sysctls+: [sysctls] }),
              sysctlsType:: hidden.v1.Sysctl,
              // The Windows specific settings applied to all containers. If unspecified, the options within a container's SecurityContext will be used. If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence.
              windowsOptions:: {
                local __mixinWindowsOptions(windowsOptions) = { windowsOptions+: windowsOptions },
                mixinInstance(windowsOptions):: __mixinWindowsOptions(windowsOptions),
                // GMSACredentialSpec is where the GMSA admission webhook (https://github.com/kubernetes-sigs/windows-gmsa) inlines the contents of the GMSA credential spec named by the GMSACredentialSpecName field. This field is alpha-level and is only honored by servers that enable the WindowsGMSA feature flag.
                withGmsaCredentialSpec(gmsaCredentialSpec):: self + self.mixinInstance({ gmsaCredentialSpec: gmsaCredentialSpec }),
                // GMSACredentialSpecName is the name of the GMSA credential spec to use. This field is alpha-level and is only honored by servers that enable the WindowsGMSA feature flag.
                withGmsaCredentialSpecName(gmsaCredentialSpecName):: self + self.mixinInstance({ gmsaCredentialSpecName: gmsaCredentialSpecName }),
                // The UserName in Windows to run the entrypoint of the container process. Defaults to the user specified in image metadata if unspecified. May also be set in PodSecurityContext. If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence. This field is beta-level and may be disabled with the WindowsRunAsUserName feature flag.
                withRunAsUserName(runAsUserName):: self + self.mixinInstance({ runAsUserName: runAsUserName }),
              },
            },
          },
        },
        // SecretKeySelector selects a key of a Secret.
        secretKeySelector:: {
          local kind = { kind: 'SecretKeySelector' },
          // The key of the secret to select from.  Must be a valid secret key.
          withKey(key):: self + self.mixinInstance({ key: key }),
          // Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
          withName(name):: self + self.mixinInstance({ name: name }),
          // Specify whether the Secret or its key must be defined
          withOptional(optional):: self + self.mixinInstance({ optional: optional }),
          mixin:: {},
        },
        // TopologySpreadConstraint specifies how to spread matching pods among the given topology.
        topologySpreadConstraint:: {
          local kind = { kind: 'TopologySpreadConstraint' },
          // MaxSkew describes the degree to which pods may be unevenly distributed. It's the maximum permitted difference between the number of matching pods in any two topology domains of a given topology type. For example, in a 3-zone cluster, MaxSkew is set to 1, and pods with the same labelSelector spread as 1/1/0: | zone1 | zone2 | zone3 | |   P   |   P   |       | - if MaxSkew is 1, incoming pod can only be scheduled to zone3 to become 1/1/1; scheduling it onto zone1(zone2) would make the ActualSkew(2-0) on zone1(zone2) violate MaxSkew(1). - if MaxSkew is 2, incoming pod can be scheduled onto any zone. It's a required field. Default value is 1 and 0 is not allowed.
          withMaxSkew(maxSkew):: self + self.mixinInstance({ maxSkew: maxSkew }),
          // TopologyKey is the key of node labels. Nodes that have a label with this key and identical values are considered to be in the same topology. We consider each <key, value> as a "bucket", and try to put balanced number of pods into each bucket. It's a required field.
          withTopologyKey(topologyKey):: self + self.mixinInstance({ topologyKey: topologyKey }),
          // WhenUnsatisfiable indicates how to deal with a pod if it doesn't satisfy the spread constraint. - DoNotSchedule (default) tells the scheduler not to schedule it - ScheduleAnyway tells the scheduler to still schedule it It's considered as "Unsatisfiable" if and only if placing incoming pod on any topology violates "MaxSkew". For example, in a 3-zone cluster, MaxSkew is set to 1, and pods with the same labelSelector spread as 3/1/1: | zone1 | zone2 | zone3 | | P P P |   P   |   P   | If WhenUnsatisfiable is set to DoNotSchedule, incoming pod can only be scheduled to zone2(zone3) to become 3/2/1(3/1/2) as ActualSkew(2-1) on zone2(zone3) satisfies MaxSkew(1). In other words, the cluster can still be imbalanced, but scheduler won't make it *more* imbalanced. It's a required field.
          withWhenUnsatisfiable(whenUnsatisfiable):: self + self.mixinInstance({ whenUnsatisfiable: whenUnsatisfiable }),
          mixin:: {
            // LabelSelector is used to find matching pods. Pods that match this label selector are counted to determine the number of pods in their corresponding topology domain.
            labelSelector:: {
              local __mixinLabelSelector(labelSelector) = { labelSelector+: labelSelector },
              mixinInstance(labelSelector):: __mixinLabelSelector(labelSelector),
              // matchExpressions is a list of label selector requirements. The requirements are ANDed.
              withMatchExpressions(matchExpressions):: self + if std.type(matchExpressions) == 'array' then self.mixinInstance({ matchExpressions: matchExpressions }) else self.mixinInstance({ matchExpressions: [matchExpressions] }),
              // matchExpressions is a list of label selector requirements. The requirements are ANDed.
              withMatchExpressionsMixin(matchExpressions):: self + if std.type(matchExpressions) == 'array' then self.mixinInstance({ matchExpressions+: matchExpressions }) else self.mixinInstance({ matchExpressions+: [matchExpressions] }),
              matchExpressionsType:: hidden.meta.v1.LabelSelectorRequirement,
              // matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels map is equivalent to an element of matchExpressions, whose key field is "key", the operator is "In", and the values array contains only "value". The requirements are ANDed.
              withMatchLabels(matchLabels):: self + self.mixinInstance({ matchLabels: matchLabels }),
            },
          },
        },
        // ContainerStateWaiting is a waiting state of a container.
        containerStateWaiting:: {
          local kind = { kind: 'ContainerStateWaiting' },
          // Message regarding why the container is not yet running.
          withMessage(message):: self + self.mixinInstance({ message: message }),
          // (brief) reason the container is not yet running.
          withReason(reason):: self + self.mixinInstance({ reason: reason }),
          mixin:: {},
        },
        // EnvVar represents an environment variable present in a Container.
        envVar:: {
          local kind = { kind: 'EnvVar' },
          // Name of the environment variable. Must be a C_IDENTIFIER.
          withName(name):: self + self.mixinInstance({ name: name }),
          // Variable references $(VAR_NAME) are expanded using the previous defined environment variables in the container and any service environment variables. If a variable cannot be resolved, the reference in the input string will be unchanged. The $(VAR_NAME) syntax can be escaped with a double $$, ie: $$(VAR_NAME). Escaped references will never be expanded, regardless of whether the variable exists or not. Defaults to "".
          withValue(value):: self + self.mixinInstance({ value: value }),
          mixin:: {
            // Source for the environment variable's value. Cannot be used if value is not empty.
            valueFrom:: {
              local __mixinValueFrom(valueFrom) = { valueFrom+: valueFrom },
              mixinInstance(valueFrom):: __mixinValueFrom(valueFrom),
              // Selects a key of a ConfigMap.
              configMapKeyRef:: {
                local __mixinConfigMapKeyRef(configMapKeyRef) = { configMapKeyRef+: configMapKeyRef },
                mixinInstance(configMapKeyRef):: __mixinConfigMapKeyRef(configMapKeyRef),
                // The key to select.
                withKey(key):: self + self.mixinInstance({ key: key }),
                // Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
                withName(name):: self + self.mixinInstance({ name: name }),
                // Specify whether the ConfigMap or its key must be defined
                withOptional(optional):: self + self.mixinInstance({ optional: optional }),
              },
              // Selects a field of the pod: supports metadata.name, metadata.namespace, metadata.labels, metadata.annotations, spec.nodeName, spec.serviceAccountName, status.hostIP, status.podIP, status.podIPs.
              fieldRef:: {
                local __mixinFieldRef(fieldRef) = { fieldRef+: fieldRef },
                mixinInstance(fieldRef):: __mixinFieldRef(fieldRef),
                // Version of the schema the FieldPath is written in terms of, defaults to "v1".
                withApiVersion(apiVersion):: self + self.mixinInstance({ apiVersion: apiVersion }),
                // Path of the field to select in the specified API version.
                withFieldPath(fieldPath):: self + self.mixinInstance({ fieldPath: fieldPath }),
              },
              // Selects a resource of the container: only resources limits and requests (limits.cpu, limits.memory, limits.ephemeral-storage, requests.cpu, requests.memory and requests.ephemeral-storage) are currently supported.
              resourceFieldRef:: {
                local __mixinResourceFieldRef(resourceFieldRef) = { resourceFieldRef+: resourceFieldRef },
                mixinInstance(resourceFieldRef):: __mixinResourceFieldRef(resourceFieldRef),
                // Container name: required for volumes, optional for env vars
                withContainerName(containerName):: self + self.mixinInstance({ containerName: containerName }),
                // Specifies the output format of the exposed resources, defaults to "1"
                withDivisor(divisor):: self + self.mixinInstance({ divisor: divisor }),
                // Required: resource to select
                withResource(resource):: self + self.mixinInstance({ resource: resource }),
              },
              // Selects a key of a secret in the pod's namespace
              secretKeyRef:: {
                local __mixinSecretKeyRef(secretKeyRef) = { secretKeyRef+: secretKeyRef },
                mixinInstance(secretKeyRef):: __mixinSecretKeyRef(secretKeyRef),
                // The key of the secret to select from.  Must be a valid secret key.
                withKey(key):: self + self.mixinInstance({ key: key }),
                // Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
                withName(name):: self + self.mixinInstance({ name: name }),
                // Specify whether the Secret or its key must be defined
                withOptional(optional):: self + self.mixinInstance({ optional: optional }),
              },
            },
          },
        },
        // Represents a Fibre Channel volume. Fibre Channel volumes can only be mounted as read/write once. Fibre Channel volumes support ownership management and SELinux relabeling.
        fcVolumeSource:: {
          local kind = { kind: 'FCVolumeSource' },
          // Filesystem type to mount. Must be a filesystem type supported by the host operating system. Ex. "ext4", "xfs", "ntfs". Implicitly inferred to be "ext4" if unspecified.
          withFsType(fsType):: self + self.mixinInstance({ fsType: fsType }),
          // Optional: FC target lun number
          withLun(lun):: self + self.mixinInstance({ lun: lun }),
          // Optional: Defaults to false (read/write). ReadOnly here will force the ReadOnly setting in VolumeMounts.
          withReadOnly(readOnly):: self + self.mixinInstance({ readOnly: readOnly }),
          // Optional: FC target worldwide names (WWNs)
          withTargetWWNs(targetWWNs):: self + if std.type(targetWWNs) == 'array' then self.mixinInstance({ targetWWNs: targetWWNs }) else self.mixinInstance({ targetWWNs: [targetWWNs] }),
          // Optional: FC target worldwide names (WWNs)
          withTargetWWNsMixin(targetWWNs):: self + if std.type(targetWWNs) == 'array' then self.mixinInstance({ targetWWNs+: targetWWNs }) else self.mixinInstance({ targetWWNs+: [targetWWNs] }),
          // Optional: FC volume world wide identifiers (wwids) Either wwids or combination of targetWWNs and lun must be set, but not both simultaneously.
          withWwids(wwids):: self + if std.type(wwids) == 'array' then self.mixinInstance({ wwids: wwids }) else self.mixinInstance({ wwids: [wwids] }),
          // Optional: FC volume world wide identifiers (wwids) Either wwids or combination of targetWWNs and lun must be set, but not both simultaneously.
          withWwidsMixin(wwids):: self + if std.type(wwids) == 'array' then self.mixinInstance({ wwids+: wwids }) else self.mixinInstance({ wwids+: [wwids] }),
          mixin:: {},
        },
        // Lifecycle describes actions that the management system should take in response to container lifecycle events. For the PostStart and PreStop lifecycle handlers, management of the container blocks until the action is complete, unless the container process fails, in which case the handler is aborted.
        lifecycle:: {
          local kind = { kind: 'Lifecycle' },
          mixin:: {
            // PostStart is called immediately after a container is created. If the handler fails, the container is terminated and restarted according to its restart policy. Other management of the container blocks until the hook completes. More info: https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/#container-hooks
            postStart:: {
              local __mixinPostStart(postStart) = { postStart+: postStart },
              mixinInstance(postStart):: __mixinPostStart(postStart),
              // One and only one of the following should be specified. Exec specifies the action to take.
              exec:: {
                local __mixinExec(exec) = { exec+: exec },
                mixinInstance(exec):: __mixinExec(exec),
                // Command is the command line to execute inside the container, the working directory for the command  is root ('/') in the container's filesystem. The command is simply exec'd, it is not run inside a shell, so traditional shell instructions ('|', etc) won't work. To use a shell, you need to explicitly call out to that shell. Exit status of 0 is treated as live/healthy and non-zero is unhealthy.
                withCommand(command):: self + if std.type(command) == 'array' then self.mixinInstance({ command: command }) else self.mixinInstance({ command: [command] }),
                // Command is the command line to execute inside the container, the working directory for the command  is root ('/') in the container's filesystem. The command is simply exec'd, it is not run inside a shell, so traditional shell instructions ('|', etc) won't work. To use a shell, you need to explicitly call out to that shell. Exit status of 0 is treated as live/healthy and non-zero is unhealthy.
                withCommandMixin(command):: self + if std.type(command) == 'array' then self.mixinInstance({ command+: command }) else self.mixinInstance({ command+: [command] }),
              },
              // HTTPGet specifies the http request to perform.
              httpGet:: {
                local __mixinHttpGet(httpGet) = { httpGet+: httpGet },
                mixinInstance(httpGet):: __mixinHttpGet(httpGet),
                // Host name to connect to, defaults to the pod IP. You probably want to set "Host" in httpHeaders instead.
                withHost(host):: self + self.mixinInstance({ host: host }),
                // Custom headers to set in the request. HTTP allows repeated headers.
                withHttpHeaders(httpHeaders):: self + if std.type(httpHeaders) == 'array' then self.mixinInstance({ httpHeaders: httpHeaders }) else self.mixinInstance({ httpHeaders: [httpHeaders] }),
                // Custom headers to set in the request. HTTP allows repeated headers.
                withHttpHeadersMixin(httpHeaders):: self + if std.type(httpHeaders) == 'array' then self.mixinInstance({ httpHeaders+: httpHeaders }) else self.mixinInstance({ httpHeaders+: [httpHeaders] }),
                httpHeadersType:: hidden.v1.HTTPHeader,
                // Path to access on the HTTP server.
                withPath(path):: self + self.mixinInstance({ path: path }),
                // Name or number of the port to access on the container. Number must be in the range 1 to 65535. Name must be an IANA_SVC_NAME.
                withPort(port):: self + self.mixinInstance({ port: port }),
                // Scheme to use for connecting to the host. Defaults to HTTP.
                withScheme(scheme):: self + self.mixinInstance({ scheme: scheme }),
              },
              // TCPSocket specifies an action involving a TCP port. TCP hooks not yet supported
              tcpSocket:: {
                local __mixinTcpSocket(tcpSocket) = { tcpSocket+: tcpSocket },
                mixinInstance(tcpSocket):: __mixinTcpSocket(tcpSocket),
                // Optional: Host name to connect to, defaults to the pod IP.
                withHost(host):: self + self.mixinInstance({ host: host }),
                // Number or name of the port to access on the container. Number must be in the range 1 to 65535. Name must be an IANA_SVC_NAME.
                withPort(port):: self + self.mixinInstance({ port: port }),
              },
            },
            // PreStop is called immediately before a container is terminated due to an API request or management event such as liveness/startup probe failure, preemption, resource contention, etc. The handler is not called if the container crashes or exits. The reason for termination is passed to the handler. The Pod's termination grace period countdown begins before the PreStop hooked is executed. Regardless of the outcome of the handler, the container will eventually terminate within the Pod's termination grace period. Other management of the container blocks until the hook completes or until the termination grace period is reached. More info: https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/#container-hooks
            preStop:: {
              local __mixinPreStop(preStop) = { preStop+: preStop },
              mixinInstance(preStop):: __mixinPreStop(preStop),
              // One and only one of the following should be specified. Exec specifies the action to take.
              exec:: {
                local __mixinExec(exec) = { exec+: exec },
                mixinInstance(exec):: __mixinExec(exec),
                // Command is the command line to execute inside the container, the working directory for the command  is root ('/') in the container's filesystem. The command is simply exec'd, it is not run inside a shell, so traditional shell instructions ('|', etc) won't work. To use a shell, you need to explicitly call out to that shell. Exit status of 0 is treated as live/healthy and non-zero is unhealthy.
                withCommand(command):: self + if std.type(command) == 'array' then self.mixinInstance({ command: command }) else self.mixinInstance({ command: [command] }),
                // Command is the command line to execute inside the container, the working directory for the command  is root ('/') in the container's filesystem. The command is simply exec'd, it is not run inside a shell, so traditional shell instructions ('|', etc) won't work. To use a shell, you need to explicitly call out to that shell. Exit status of 0 is treated as live/healthy and non-zero is unhealthy.
                withCommandMixin(command):: self + if std.type(command) == 'array' then self.mixinInstance({ command+: command }) else self.mixinInstance({ command+: [command] }),
              },
              // HTTPGet specifies the http request to perform.
              httpGet:: {
                local __mixinHttpGet(httpGet) = { httpGet+: httpGet },
                mixinInstance(httpGet):: __mixinHttpGet(httpGet),
                // Host name to connect to, defaults to the pod IP. You probably want to set "Host" in httpHeaders instead.
                withHost(host):: self + self.mixinInstance({ host: host }),
                // Custom headers to set in the request. HTTP allows repeated headers.
                withHttpHeaders(httpHeaders):: self + if std.type(httpHeaders) == 'array' then self.mixinInstance({ httpHeaders: httpHeaders }) else self.mixinInstance({ httpHeaders: [httpHeaders] }),
                // Custom headers to set in the request. HTTP allows repeated headers.
                withHttpHeadersMixin(httpHeaders):: self + if std.type(httpHeaders) == 'array' then self.mixinInstance({ httpHeaders+: httpHeaders }) else self.mixinInstance({ httpHeaders+: [httpHeaders] }),
                httpHeadersType:: hidden.v1.HTTPHeader,
                // Path to access on the HTTP server.
                withPath(path):: self + self.mixinInstance({ path: path }),
                // Name or number of the port to access on the container. Number must be in the range 1 to 65535. Name must be an IANA_SVC_NAME.
                withPort(port):: self + self.mixinInstance({ port: port }),
                // Scheme to use for connecting to the host. Defaults to HTTP.
                withScheme(scheme):: self + self.mixinInstance({ scheme: scheme }),
              },
              // TCPSocket specifies an action involving a TCP port. TCP hooks not yet supported
              tcpSocket:: {
                local __mixinTcpSocket(tcpSocket) = { tcpSocket+: tcpSocket },
                mixinInstance(tcpSocket):: __mixinTcpSocket(tcpSocket),
                // Optional: Host name to connect to, defaults to the pod IP.
                withHost(host):: self + self.mixinInstance({ host: host }),
                // Number or name of the port to access on the container. Number must be in the range 1 to 65535. Name must be an IANA_SVC_NAME.
                withPort(port):: self + self.mixinInstance({ port: port }),
              },
            },
          },
        },
        // Pod anti affinity is a group of inter pod anti affinity scheduling rules.
        podAntiAffinity:: {
          local kind = { kind: 'PodAntiAffinity' },
          // The scheduler will prefer to schedule pods to nodes that satisfy the anti-affinity expressions specified by this field, but it may choose a node that violates one or more of the expressions. The node that is most preferred is the one with the greatest sum of weights, i.e. for each node that meets all of the scheduling requirements (resource request, requiredDuringScheduling anti-affinity expressions, etc.), compute a sum by iterating through the elements of this field and adding "weight" to the sum if the node has pods which matches the corresponding podAffinityTerm; the node(s) with the highest sum are the most preferred.
          withPreferredDuringSchedulingIgnoredDuringExecution(preferredDuringSchedulingIgnoredDuringExecution):: self + if std.type(preferredDuringSchedulingIgnoredDuringExecution) == 'array' then self.mixinInstance({ preferredDuringSchedulingIgnoredDuringExecution: preferredDuringSchedulingIgnoredDuringExecution }) else self.mixinInstance({ preferredDuringSchedulingIgnoredDuringExecution: [preferredDuringSchedulingIgnoredDuringExecution] }),
          // The scheduler will prefer to schedule pods to nodes that satisfy the anti-affinity expressions specified by this field, but it may choose a node that violates one or more of the expressions. The node that is most preferred is the one with the greatest sum of weights, i.e. for each node that meets all of the scheduling requirements (resource request, requiredDuringScheduling anti-affinity expressions, etc.), compute a sum by iterating through the elements of this field and adding "weight" to the sum if the node has pods which matches the corresponding podAffinityTerm; the node(s) with the highest sum are the most preferred.
          withPreferredDuringSchedulingIgnoredDuringExecutionMixin(preferredDuringSchedulingIgnoredDuringExecution):: self + if std.type(preferredDuringSchedulingIgnoredDuringExecution) == 'array' then self.mixinInstance({ preferredDuringSchedulingIgnoredDuringExecution+: preferredDuringSchedulingIgnoredDuringExecution }) else self.mixinInstance({ preferredDuringSchedulingIgnoredDuringExecution+: [preferredDuringSchedulingIgnoredDuringExecution] }),
          preferredDuringSchedulingIgnoredDuringExecutionType:: hidden.v1.WeightedPodAffinityTerm,
          // If the anti-affinity requirements specified by this field are not met at scheduling time, the pod will not be scheduled onto the node. If the anti-affinity requirements specified by this field cease to be met at some point during pod execution (e.g. due to a pod label update), the system may or may not try to eventually evict the pod from its node. When there are multiple elements, the lists of nodes corresponding to each podAffinityTerm are intersected, i.e. all terms must be satisfied.
          withRequiredDuringSchedulingIgnoredDuringExecution(requiredDuringSchedulingIgnoredDuringExecution):: self + if std.type(requiredDuringSchedulingIgnoredDuringExecution) == 'array' then self.mixinInstance({ requiredDuringSchedulingIgnoredDuringExecution: requiredDuringSchedulingIgnoredDuringExecution }) else self.mixinInstance({ requiredDuringSchedulingIgnoredDuringExecution: [requiredDuringSchedulingIgnoredDuringExecution] }),
          // If the anti-affinity requirements specified by this field are not met at scheduling time, the pod will not be scheduled onto the node. If the anti-affinity requirements specified by this field cease to be met at some point during pod execution (e.g. due to a pod label update), the system may or may not try to eventually evict the pod from its node. When there are multiple elements, the lists of nodes corresponding to each podAffinityTerm are intersected, i.e. all terms must be satisfied.
          withRequiredDuringSchedulingIgnoredDuringExecutionMixin(requiredDuringSchedulingIgnoredDuringExecution):: self + if std.type(requiredDuringSchedulingIgnoredDuringExecution) == 'array' then self.mixinInstance({ requiredDuringSchedulingIgnoredDuringExecution+: requiredDuringSchedulingIgnoredDuringExecution }) else self.mixinInstance({ requiredDuringSchedulingIgnoredDuringExecution+: [requiredDuringSchedulingIgnoredDuringExecution] }),
          requiredDuringSchedulingIgnoredDuringExecutionType:: hidden.v1.PodAffinityTerm,
          mixin:: {},
        },
        // ResourceRequirements describes the compute resource requirements.
        resourceRequirements:: {
          local kind = { kind: 'ResourceRequirements' },
          // Limits describes the maximum amount of compute resources allowed. More info: https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/
          withLimits(limits):: self + self.mixinInstance({ limits: limits }),
          // Requests describes the minimum amount of compute resources required. If Requests is omitted for a container, it defaults to Limits if that is explicitly specified, otherwise to an implementation-defined value. More info: https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/
          withRequests(requests):: self + self.mixinInstance({ requests: requests }),
          mixin:: {},
        },
        // Projection that may be projected along with other supported volume types
        volumeProjection:: {
          local kind = { kind: 'VolumeProjection' },
          mixin:: {
            // information about the configMap data to project
            configMap:: {
              local __mixinConfigMap(configMap) = { configMap+: configMap },
              mixinInstance(configMap):: __mixinConfigMap(configMap),
              // If unspecified, each key-value pair in the Data field of the referenced ConfigMap will be projected into the volume as a file whose name is the key and content is the value. If specified, the listed keys will be projected into the specified paths, and unlisted keys will not be present. If a key is specified which is not present in the ConfigMap, the volume setup will error unless it is marked optional. Paths must be relative and may not contain the '..' path or start with '..'.
              withItems(items):: self + if std.type(items) == 'array' then self.mixinInstance({ items: items }) else self.mixinInstance({ items: [items] }),
              // If unspecified, each key-value pair in the Data field of the referenced ConfigMap will be projected into the volume as a file whose name is the key and content is the value. If specified, the listed keys will be projected into the specified paths, and unlisted keys will not be present. If a key is specified which is not present in the ConfigMap, the volume setup will error unless it is marked optional. Paths must be relative and may not contain the '..' path or start with '..'.
              withItemsMixin(items):: self + if std.type(items) == 'array' then self.mixinInstance({ items+: items }) else self.mixinInstance({ items+: [items] }),
              itemsType:: hidden.v1.KeyToPath,
              // Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
              withName(name):: self + self.mixinInstance({ name: name }),
              // Specify whether the ConfigMap or its keys must be defined
              withOptional(optional):: self + self.mixinInstance({ optional: optional }),
            },
            // information about the downwardAPI data to project
            downwardAPI:: {
              local __mixinDownwardAPI(downwardAPI) = { downwardAPI+: downwardAPI },
              mixinInstance(downwardAPI):: __mixinDownwardAPI(downwardAPI),
              // Items is a list of DownwardAPIVolume file
              withItems(items):: self + if std.type(items) == 'array' then self.mixinInstance({ items: items }) else self.mixinInstance({ items: [items] }),
              // Items is a list of DownwardAPIVolume file
              withItemsMixin(items):: self + if std.type(items) == 'array' then self.mixinInstance({ items+: items }) else self.mixinInstance({ items+: [items] }),
              itemsType:: hidden.v1.DownwardAPIVolumeFile,
            },
            // information about the secret data to project
            secret:: {
              local __mixinSecret(secret) = { secret+: secret },
              mixinInstance(secret):: __mixinSecret(secret),
              // If unspecified, each key-value pair in the Data field of the referenced Secret will be projected into the volume as a file whose name is the key and content is the value. If specified, the listed keys will be projected into the specified paths, and unlisted keys will not be present. If a key is specified which is not present in the Secret, the volume setup will error unless it is marked optional. Paths must be relative and may not contain the '..' path or start with '..'.
              withItems(items):: self + if std.type(items) == 'array' then self.mixinInstance({ items: items }) else self.mixinInstance({ items: [items] }),
              // If unspecified, each key-value pair in the Data field of the referenced Secret will be projected into the volume as a file whose name is the key and content is the value. If specified, the listed keys will be projected into the specified paths, and unlisted keys will not be present. If a key is specified which is not present in the Secret, the volume setup will error unless it is marked optional. Paths must be relative and may not contain the '..' path or start with '..'.
              withItemsMixin(items):: self + if std.type(items) == 'array' then self.mixinInstance({ items+: items }) else self.mixinInstance({ items+: [items] }),
              itemsType:: hidden.v1.KeyToPath,
              // Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
              withName(name):: self + self.mixinInstance({ name: name }),
              // Specify whether the Secret or its key must be defined
              withOptional(optional):: self + self.mixinInstance({ optional: optional }),
            },
            // information about the serviceAccountToken data to project
            serviceAccountToken:: {
              local __mixinServiceAccountToken(serviceAccountToken) = { serviceAccountToken+: serviceAccountToken },
              mixinInstance(serviceAccountToken):: __mixinServiceAccountToken(serviceAccountToken),
              // Audience is the intended audience of the token. A recipient of a token must identify itself with an identifier specified in the audience of the token, and otherwise should reject the token. The audience defaults to the identifier of the apiserver.
              withAudience(audience):: self + self.mixinInstance({ audience: audience }),
              // ExpirationSeconds is the requested duration of validity of the service account token. As the token approaches expiration, the kubelet volume plugin will proactively rotate the service account token. The kubelet will start trying to rotate the token if the token is older than 80 percent of its time to live or if the token is older than 24 hours.Defaults to 1 hour and must be at least 10 minutes.
              withExpirationSeconds(expirationSeconds):: self + self.mixinInstance({ expirationSeconds: expirationSeconds }),
              // Path is the path relative to the mount point of the file to project the token into.
              withPath(path):: self + self.mixinInstance({ path: path }),
            },
          },
        },
        // ContainerState holds a possible state of container. Only one of its members may be specified. If none of them is specified, the default one is ContainerStateWaiting.
        containerState:: {
          local kind = { kind: 'ContainerState' },
          mixin:: {
            // Details about a running container
            running:: {
              local __mixinRunning(running) = { running+: running },
              mixinInstance(running):: __mixinRunning(running),
              // Time at which the container was last (re-)started
              withStartedAt(startedAt):: self + self.mixinInstance({ startedAt: startedAt }),
            },
            // Details about a terminated container
            terminated:: {
              local __mixinTerminated(terminated) = { terminated+: terminated },
              mixinInstance(terminated):: __mixinTerminated(terminated),
              // Container's ID in the format 'docker://<container_id>'
              withContainerID(containerID):: self + self.mixinInstance({ containerID: containerID }),
              // Exit status from the last termination of the container
              withExitCode(exitCode):: self + self.mixinInstance({ exitCode: exitCode }),
              // Time at which the container last terminated
              withFinishedAt(finishedAt):: self + self.mixinInstance({ finishedAt: finishedAt }),
              // Message regarding the last termination of the container
              withMessage(message):: self + self.mixinInstance({ message: message }),
              // (brief) reason from the last termination of the container
              withReason(reason):: self + self.mixinInstance({ reason: reason }),
              // Signal from the last termination of the container
              withSignal(signal):: self + self.mixinInstance({ signal: signal }),
              // Time at which previous execution of the container started
              withStartedAt(startedAt):: self + self.mixinInstance({ startedAt: startedAt }),
            },
            // Details about a waiting container
            waiting:: {
              local __mixinWaiting(waiting) = { waiting+: waiting },
              mixinInstance(waiting):: __mixinWaiting(waiting),
              // Message regarding why the container is not yet running.
              withMessage(message):: self + self.mixinInstance({ message: message }),
              // (brief) reason the container is not yet running.
              withReason(reason):: self + self.mixinInstance({ reason: reason }),
            },
          },
        },
        // Represents a Flocker volume mounted by the Flocker agent. One and only one of datasetName and datasetUUID should be set. Flocker volumes do not support ownership management or SELinux relabeling.
        flockerVolumeSource:: {
          local kind = { kind: 'FlockerVolumeSource' },
          // Name of the dataset stored as metadata -> name on the dataset for Flocker should be considered as deprecated
          withDatasetName(datasetName):: self + self.mixinInstance({ datasetName: datasetName }),
          // UUID of the dataset. This is unique identifier of a Flocker dataset
          withDatasetUUID(datasetUUID):: self + self.mixinInstance({ datasetUUID: datasetUUID }),
          mixin:: {},
        },
        // Represents a Glusterfs mount that lasts the lifetime of a pod. Glusterfs volumes do not support ownership management or SELinux relabeling.
        glusterfsVolumeSource:: {
          local kind = { kind: 'GlusterfsVolumeSource' },
          // EndpointsName is the endpoint name that details Glusterfs topology. More info: https://examples.k8s.io/volumes/glusterfs/README.md#create-a-pod
          withEndpoints(endpoints):: self + self.mixinInstance({ endpoints: endpoints }),
          // Path is the Glusterfs volume path. More info: https://examples.k8s.io/volumes/glusterfs/README.md#create-a-pod
          withPath(path):: self + self.mixinInstance({ path: path }),
          // ReadOnly here will force the Glusterfs volume to be mounted with read-only permissions. Defaults to false. More info: https://examples.k8s.io/volumes/glusterfs/README.md#create-a-pod
          withReadOnly(readOnly):: self + self.mixinInstance({ readOnly: readOnly }),
          mixin:: {},
        },
        // An empty preferred scheduling term matches all objects with implicit weight 0 (i.e. it's a no-op). A null preferred scheduling term matches no objects (i.e. is also a no-op).
        preferredSchedulingTerm:: {
          local kind = { kind: 'PreferredSchedulingTerm' },
          // Weight associated with matching the corresponding nodeSelectorTerm, in the range 1-100.
          withWeight(weight):: self + self.mixinInstance({ weight: weight }),
          mixin:: {
            // A node selector term, associated with the corresponding weight.
            preference:: {
              local __mixinPreference(preference) = { preference+: preference },
              mixinInstance(preference):: __mixinPreference(preference),
              // A list of node selector requirements by node's labels.
              withMatchExpressions(matchExpressions):: self + if std.type(matchExpressions) == 'array' then self.mixinInstance({ matchExpressions: matchExpressions }) else self.mixinInstance({ matchExpressions: [matchExpressions] }),
              // A list of node selector requirements by node's labels.
              withMatchExpressionsMixin(matchExpressions):: self + if std.type(matchExpressions) == 'array' then self.mixinInstance({ matchExpressions+: matchExpressions }) else self.mixinInstance({ matchExpressions+: [matchExpressions] }),
              matchExpressionsType:: hidden.v1.NodeSelectorRequirement,
              // A list of node selector requirements by node's fields.
              withMatchFields(matchFields):: self + if std.type(matchFields) == 'array' then self.mixinInstance({ matchFields: matchFields }) else self.mixinInstance({ matchFields: [matchFields] }),
              // A list of node selector requirements by node's fields.
              withMatchFieldsMixin(matchFields):: self + if std.type(matchFields) == 'array' then self.mixinInstance({ matchFields+: matchFields }) else self.mixinInstance({ matchFields+: [matchFields] }),
              matchFieldsType:: hidden.v1.NodeSelectorRequirement,
            },
          },
        },
        // ServiceAccountTokenProjection represents a projected service account token volume. This projection can be used to insert a service account token into the pods runtime filesystem for use against APIs (Kubernetes API Server or otherwise).
        serviceAccountTokenProjection:: {
          local kind = { kind: 'ServiceAccountTokenProjection' },
          // Audience is the intended audience of the token. A recipient of a token must identify itself with an identifier specified in the audience of the token, and otherwise should reject the token. The audience defaults to the identifier of the apiserver.
          withAudience(audience):: self + self.mixinInstance({ audience: audience }),
          // ExpirationSeconds is the requested duration of validity of the service account token. As the token approaches expiration, the kubelet volume plugin will proactively rotate the service account token. The kubelet will start trying to rotate the token if the token is older than 80 percent of its time to live or if the token is older than 24 hours.Defaults to 1 hour and must be at least 10 minutes.
          withExpirationSeconds(expirationSeconds):: self + self.mixinInstance({ expirationSeconds: expirationSeconds }),
          // Path is the path relative to the mount point of the file to project the token into.
          withPath(path):: self + self.mixinInstance({ path: path }),
          mixin:: {},
        },
        // Represents a source location of a volume to mount, managed by an external CSI driver
        csiVolumeSource:: {
          local kind = { kind: 'CSIVolumeSource' },
          // Driver is the name of the CSI driver that handles this volume. Consult with your admin for the correct name as registered in the cluster.
          withDriver(driver):: self + self.mixinInstance({ driver: driver }),
          // Filesystem type to mount. Ex. "ext4", "xfs", "ntfs". If not provided, the empty value is passed to the associated CSI driver which will determine the default filesystem to apply.
          withFsType(fsType):: self + self.mixinInstance({ fsType: fsType }),
          // Specifies a read-only configuration for the volume. Defaults to false (read/write).
          withReadOnly(readOnly):: self + self.mixinInstance({ readOnly: readOnly }),
          // VolumeAttributes stores driver-specific properties that are passed to the CSI driver. Consult your driver's documentation for supported values.
          withVolumeAttributes(volumeAttributes):: self + self.mixinInstance({ volumeAttributes: volumeAttributes }),
          mixin:: {
            // NodePublishSecretRef is a reference to the secret object containing sensitive information to pass to the CSI driver to complete the CSI NodePublishVolume and NodeUnpublishVolume calls. This field is optional, and  may be empty if no secret is required. If the secret object contains more than one secret, all secret references are passed.
            nodePublishSecretRef:: {
              local __mixinNodePublishSecretRef(nodePublishSecretRef) = { nodePublishSecretRef+: nodePublishSecretRef },
              mixinInstance(nodePublishSecretRef):: __mixinNodePublishSecretRef(nodePublishSecretRef),
              // Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
              withName(name):: self + self.mixinInstance({ name: name }),
            },
          },
        },
        // Represents a cinder volume resource in Openstack. A Cinder volume must exist before mounting to a container. The volume must also be in the same region as the kubelet. Cinder volumes support ownership management and SELinux relabeling.
        cinderVolumeSource:: {
          local kind = { kind: 'CinderVolumeSource' },
          // Filesystem type to mount. Must be a filesystem type supported by the host operating system. Examples: "ext4", "xfs", "ntfs". Implicitly inferred to be "ext4" if unspecified. More info: https://examples.k8s.io/mysql-cinder-pd/README.md
          withFsType(fsType):: self + self.mixinInstance({ fsType: fsType }),
          // Optional: Defaults to false (read/write). ReadOnly here will force the ReadOnly setting in VolumeMounts. More info: https://examples.k8s.io/mysql-cinder-pd/README.md
          withReadOnly(readOnly):: self + self.mixinInstance({ readOnly: readOnly }),
          // volume id used to identify the volume in cinder. More info: https://examples.k8s.io/mysql-cinder-pd/README.md
          withVolumeID(volumeID):: self + self.mixinInstance({ volumeID: volumeID }),
          mixin:: {
            // Optional: points to a secret object containing parameters used to connect to OpenStack.
            secretRef:: {
              local __mixinSecretRef(secretRef) = { secretRef+: secretRef },
              mixinInstance(secretRef):: __mixinSecretRef(secretRef),
              // Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
              withName(name):: self + self.mixinInstance({ name: name }),
            },
          },
        },
        // Represents a volume that is populated with the contents of a git repository. Git repo volumes do not support ownership management. Git repo volumes support SELinux relabeling.
        //
        // DEPRECATED: GitRepo is deprecated. To provision a container with a git repo, mount an EmptyDir into an InitContainer that clones the repo using git, then mount the EmptyDir into the Pod's container.
        gitRepoVolumeSource:: {
          local kind = { kind: 'GitRepoVolumeSource' },
          // Target directory name. Must not contain or start with '..'.  If '.' is supplied, the volume directory will be the git repository.  Otherwise, if specified, the volume will contain the git repository in the subdirectory with the given name.
          withDirectory(directory):: self + self.mixinInstance({ directory: directory }),
          // Repository URL
          withRepository(repository):: self + self.mixinInstance({ repository: repository }),
          // Commit hash for the specified revision.
          withRevision(revision):: self + self.mixinInstance({ revision: revision }),
          mixin:: {},
        },
        // Adapts a secret into a projected volume.
        //
        // The contents of the target Secret's Data field will be presented in a projected volume as files using the keys in the Data field as the file names. Note that this is identical to a secret volume source without the default mode.
        secretProjection:: {
          local kind = { kind: 'SecretProjection' },
          // If unspecified, each key-value pair in the Data field of the referenced Secret will be projected into the volume as a file whose name is the key and content is the value. If specified, the listed keys will be projected into the specified paths, and unlisted keys will not be present. If a key is specified which is not present in the Secret, the volume setup will error unless it is marked optional. Paths must be relative and may not contain the '..' path or start with '..'.
          withItems(items):: self + if std.type(items) == 'array' then self.mixinInstance({ items: items }) else self.mixinInstance({ items: [items] }),
          // If unspecified, each key-value pair in the Data field of the referenced Secret will be projected into the volume as a file whose name is the key and content is the value. If specified, the listed keys will be projected into the specified paths, and unlisted keys will not be present. If a key is specified which is not present in the Secret, the volume setup will error unless it is marked optional. Paths must be relative and may not contain the '..' path or start with '..'.
          withItemsMixin(items):: self + if std.type(items) == 'array' then self.mixinInstance({ items+: items }) else self.mixinInstance({ items+: [items] }),
          itemsType:: hidden.v1.KeyToPath,
          // Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
          withName(name):: self + self.mixinInstance({ name: name }),
          // Specify whether the Secret or its key must be defined
          withOptional(optional):: self + self.mixinInstance({ optional: optional }),
          mixin:: {},
        },
        // SecurityContext holds security configuration that will be applied to a container. Some fields are present in both SecurityContext and PodSecurityContext.  When both are set, the values in SecurityContext take precedence.
        securityContext:: {
          local kind = { kind: 'SecurityContext' },
          // AllowPrivilegeEscalation controls whether a process can gain more privileges than its parent process. This bool directly controls if the no_new_privs flag will be set on the container process. AllowPrivilegeEscalation is true always when the container is: 1) run as Privileged 2) has CAP_SYS_ADMIN
          withAllowPrivilegeEscalation(allowPrivilegeEscalation):: self + self.mixinInstance({ allowPrivilegeEscalation: allowPrivilegeEscalation }),
          // Run container in privileged mode. Processes in privileged containers are essentially equivalent to root on the host. Defaults to false.
          withPrivileged(privileged):: self + self.mixinInstance({ privileged: privileged }),
          // procMount denotes the type of proc mount to use for the containers. The default is DefaultProcMount which uses the container runtime defaults for readonly paths and masked paths. This requires the ProcMountType feature flag to be enabled.
          withProcMount(procMount):: self + self.mixinInstance({ procMount: procMount }),
          // Whether this container has a read-only root filesystem. Default is false.
          withReadOnlyRootFilesystem(readOnlyRootFilesystem):: self + self.mixinInstance({ readOnlyRootFilesystem: readOnlyRootFilesystem }),
          // The GID to run the entrypoint of the container process. Uses runtime default if unset. May also be set in PodSecurityContext.  If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence.
          withRunAsGroup(runAsGroup):: self + self.mixinInstance({ runAsGroup: runAsGroup }),
          // Indicates that the container must run as a non-root user. If true, the Kubelet will validate the image at runtime to ensure that it does not run as UID 0 (root) and fail to start the container if it does. If unset or false, no such validation will be performed. May also be set in PodSecurityContext.  If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence.
          withRunAsNonRoot(runAsNonRoot):: self + self.mixinInstance({ runAsNonRoot: runAsNonRoot }),
          // The UID to run the entrypoint of the container process. Defaults to user specified in image metadata if unspecified. May also be set in PodSecurityContext.  If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence.
          withRunAsUser(runAsUser):: self + self.mixinInstance({ runAsUser: runAsUser }),
          mixin:: {
            // The capabilities to add/drop when running containers. Defaults to the default set of capabilities granted by the container runtime.
            capabilities:: {
              local __mixinCapabilities(capabilities) = { capabilities+: capabilities },
              mixinInstance(capabilities):: __mixinCapabilities(capabilities),
              // Added capabilities
              withAdd(add):: self + if std.type(add) == 'array' then self.mixinInstance({ add: add }) else self.mixinInstance({ add: [add] }),
              // Added capabilities
              withAddMixin(add):: self + if std.type(add) == 'array' then self.mixinInstance({ add+: add }) else self.mixinInstance({ add+: [add] }),
              // Removed capabilities
              withDrop(drop):: self + if std.type(drop) == 'array' then self.mixinInstance({ drop: drop }) else self.mixinInstance({ drop: [drop] }),
              // Removed capabilities
              withDropMixin(drop):: self + if std.type(drop) == 'array' then self.mixinInstance({ drop+: drop }) else self.mixinInstance({ drop+: [drop] }),
            },
            // The SELinux context to be applied to the container. If unspecified, the container runtime will allocate a random SELinux context for each container.  May also be set in PodSecurityContext.  If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence.
            seLinuxOptions:: {
              local __mixinSeLinuxOptions(seLinuxOptions) = { seLinuxOptions+: seLinuxOptions },
              mixinInstance(seLinuxOptions):: __mixinSeLinuxOptions(seLinuxOptions),
              // Level is SELinux level label that applies to the container.
              withLevel(level):: self + self.mixinInstance({ level: level }),
              // Role is a SELinux role label that applies to the container.
              withRole(role):: self + self.mixinInstance({ role: role }),
              // Type is a SELinux type label that applies to the container.
              withType(type):: self + self.mixinInstance({ type: type }),
              // User is a SELinux user label that applies to the container.
              withUser(user):: self + self.mixinInstance({ user: user }),
            },
            // The Windows specific settings applied to all containers. If unspecified, the options from the PodSecurityContext will be used. If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence.
            windowsOptions:: {
              local __mixinWindowsOptions(windowsOptions) = { windowsOptions+: windowsOptions },
              mixinInstance(windowsOptions):: __mixinWindowsOptions(windowsOptions),
              // GMSACredentialSpec is where the GMSA admission webhook (https://github.com/kubernetes-sigs/windows-gmsa) inlines the contents of the GMSA credential spec named by the GMSACredentialSpecName field. This field is alpha-level and is only honored by servers that enable the WindowsGMSA feature flag.
              withGmsaCredentialSpec(gmsaCredentialSpec):: self + self.mixinInstance({ gmsaCredentialSpec: gmsaCredentialSpec }),
              // GMSACredentialSpecName is the name of the GMSA credential spec to use. This field is alpha-level and is only honored by servers that enable the WindowsGMSA feature flag.
              withGmsaCredentialSpecName(gmsaCredentialSpecName):: self + self.mixinInstance({ gmsaCredentialSpecName: gmsaCredentialSpecName }),
              // The UserName in Windows to run the entrypoint of the container process. Defaults to the user specified in image metadata if unspecified. May also be set in PodSecurityContext. If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence. This field is beta-level and may be disabled with the WindowsRunAsUserName feature flag.
              withRunAsUserName(runAsUserName):: self + self.mixinInstance({ runAsUserName: runAsUserName }),
            },
          },
        },
        // Represents a StorageOS persistent volume resource.
        storageOSVolumeSource:: {
          local kind = { kind: 'StorageOSVolumeSource' },
          // Filesystem type to mount. Must be a filesystem type supported by the host operating system. Ex. "ext4", "xfs", "ntfs". Implicitly inferred to be "ext4" if unspecified.
          withFsType(fsType):: self + self.mixinInstance({ fsType: fsType }),
          // Defaults to false (read/write). ReadOnly here will force the ReadOnly setting in VolumeMounts.
          withReadOnly(readOnly):: self + self.mixinInstance({ readOnly: readOnly }),
          // VolumeName is the human-readable name of the StorageOS volume.  Volume names are only unique within a namespace.
          withVolumeName(volumeName):: self + self.mixinInstance({ volumeName: volumeName }),
          // VolumeNamespace specifies the scope of the volume within StorageOS.  If no namespace is specified then the Pod's namespace will be used.  This allows the Kubernetes name scoping to be mirrored within StorageOS for tighter integration. Set VolumeName to any name to override the default behaviour. Set to "default" if you are not using namespaces within StorageOS. Namespaces that do not pre-exist within StorageOS will be created.
          withVolumeNamespace(volumeNamespace):: self + self.mixinInstance({ volumeNamespace: volumeNamespace }),
          mixin:: {
            // SecretRef specifies the secret to use for obtaining the StorageOS API credentials.  If not specified, default values will be attempted.
            secretRef:: {
              local __mixinSecretRef(secretRef) = { secretRef+: secretRef },
              mixinInstance(secretRef):: __mixinSecretRef(secretRef),
              // Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
              withName(name):: self + self.mixinInstance({ name: name }),
            },
          },
        },
        // Volume represents a named volume in a pod that may be accessed by any container in the pod.
        volume:: {
          local kind = { kind: 'Volume' },
          // Volume's name. Must be a DNS_LABEL and unique within the pod. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
          withName(name):: self + self.mixinInstance({ name: name }),
          mixin:: {
            // AWSElasticBlockStore represents an AWS Disk resource that is attached to a kubelet's host machine and then exposed to the pod. More info: https://kubernetes.io/docs/concepts/storage/volumes#awselasticblockstore
            awsElasticBlockStore:: {
              local __mixinAwsElasticBlockStore(awsElasticBlockStore) = { awsElasticBlockStore+: awsElasticBlockStore },
              mixinInstance(awsElasticBlockStore):: __mixinAwsElasticBlockStore(awsElasticBlockStore),
              // Filesystem type of the volume that you want to mount. Tip: Ensure that the filesystem type is supported by the host operating system. Examples: "ext4", "xfs", "ntfs". Implicitly inferred to be "ext4" if unspecified. More info: https://kubernetes.io/docs/concepts/storage/volumes#awselasticblockstore
              withFsType(fsType):: self + self.mixinInstance({ fsType: fsType }),
              // The partition in the volume that you want to mount. If omitted, the default is to mount by volume name. Examples: For volume /dev/sda1, you specify the partition as "1". Similarly, the volume partition for /dev/sda is "0" (or you can leave the property empty).
              withPartition(partition):: self + self.mixinInstance({ partition: partition }),
              // Specify "true" to force and set the ReadOnly property in VolumeMounts to "true". If omitted, the default is "false". More info: https://kubernetes.io/docs/concepts/storage/volumes#awselasticblockstore
              withReadOnly(readOnly):: self + self.mixinInstance({ readOnly: readOnly }),
              // Unique ID of the persistent disk resource in AWS (Amazon EBS volume). More info: https://kubernetes.io/docs/concepts/storage/volumes#awselasticblockstore
              withVolumeID(volumeID):: self + self.mixinInstance({ volumeID: volumeID }),
            },
            // AzureDisk represents an Azure Data Disk mount on the host and bind mount to the pod.
            azureDisk:: {
              local __mixinAzureDisk(azureDisk) = { azureDisk+: azureDisk },
              mixinInstance(azureDisk):: __mixinAzureDisk(azureDisk),
              // Host Caching mode: None, Read Only, Read Write.
              withCachingMode(cachingMode):: self + self.mixinInstance({ cachingMode: cachingMode }),
              // The Name of the data disk in the blob storage
              withDiskName(diskName):: self + self.mixinInstance({ diskName: diskName }),
              // The URI the data disk in the blob storage
              withDiskURI(diskURI):: self + self.mixinInstance({ diskURI: diskURI }),
              // Filesystem type to mount. Must be a filesystem type supported by the host operating system. Ex. "ext4", "xfs", "ntfs". Implicitly inferred to be "ext4" if unspecified.
              withFsType(fsType):: self + self.mixinInstance({ fsType: fsType }),
              // Expected values Shared: multiple blob disks per storage account  Dedicated: single blob disk per storage account  Managed: azure managed data disk (only in managed availability set). defaults to shared
              withKind(kind):: self + self.mixinInstance({ kind: kind }),
              // Defaults to false (read/write). ReadOnly here will force the ReadOnly setting in VolumeMounts.
              withReadOnly(readOnly):: self + self.mixinInstance({ readOnly: readOnly }),
            },
            // AzureFile represents an Azure File Service mount on the host and bind mount to the pod.
            azureFile:: {
              local __mixinAzureFile(azureFile) = { azureFile+: azureFile },
              mixinInstance(azureFile):: __mixinAzureFile(azureFile),
              // Defaults to false (read/write). ReadOnly here will force the ReadOnly setting in VolumeMounts.
              withReadOnly(readOnly):: self + self.mixinInstance({ readOnly: readOnly }),
              // the name of secret that contains Azure Storage Account Name and Key
              withSecretName(secretName):: self + self.mixinInstance({ secretName: secretName }),
              // Share Name
              withShareName(shareName):: self + self.mixinInstance({ shareName: shareName }),
            },
            // CephFS represents a Ceph FS mount on the host that shares a pod's lifetime
            cephfs:: {
              local __mixinCephfs(cephfs) = { cephfs+: cephfs },
              mixinInstance(cephfs):: __mixinCephfs(cephfs),
              // Required: Monitors is a collection of Ceph monitors More info: https://examples.k8s.io/volumes/cephfs/README.md#how-to-use-it
              withMonitors(monitors):: self + if std.type(monitors) == 'array' then self.mixinInstance({ monitors: monitors }) else self.mixinInstance({ monitors: [monitors] }),
              // Required: Monitors is a collection of Ceph monitors More info: https://examples.k8s.io/volumes/cephfs/README.md#how-to-use-it
              withMonitorsMixin(monitors):: self + if std.type(monitors) == 'array' then self.mixinInstance({ monitors+: monitors }) else self.mixinInstance({ monitors+: [monitors] }),
              // Optional: Used as the mounted root, rather than the full Ceph tree, default is /
              withPath(path):: self + self.mixinInstance({ path: path }),
              // Optional: Defaults to false (read/write). ReadOnly here will force the ReadOnly setting in VolumeMounts. More info: https://examples.k8s.io/volumes/cephfs/README.md#how-to-use-it
              withReadOnly(readOnly):: self + self.mixinInstance({ readOnly: readOnly }),
              // Optional: SecretFile is the path to key ring for User, default is /etc/ceph/user.secret More info: https://examples.k8s.io/volumes/cephfs/README.md#how-to-use-it
              withSecretFile(secretFile):: self + self.mixinInstance({ secretFile: secretFile }),
              // Optional: SecretRef is reference to the authentication secret for User, default is empty. More info: https://examples.k8s.io/volumes/cephfs/README.md#how-to-use-it
              secretRef:: {
                local __mixinSecretRef(secretRef) = { secretRef+: secretRef },
                mixinInstance(secretRef):: __mixinSecretRef(secretRef),
                // Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
                withName(name):: self + self.mixinInstance({ name: name }),
              },
              // Optional: User is the rados user name, default is admin More info: https://examples.k8s.io/volumes/cephfs/README.md#how-to-use-it
              withUser(user):: self + self.mixinInstance({ user: user }),
            },
            // Cinder represents a cinder volume attached and mounted on kubelets host machine. More info: https://examples.k8s.io/mysql-cinder-pd/README.md
            cinder:: {
              local __mixinCinder(cinder) = { cinder+: cinder },
              mixinInstance(cinder):: __mixinCinder(cinder),
              // Filesystem type to mount. Must be a filesystem type supported by the host operating system. Examples: "ext4", "xfs", "ntfs". Implicitly inferred to be "ext4" if unspecified. More info: https://examples.k8s.io/mysql-cinder-pd/README.md
              withFsType(fsType):: self + self.mixinInstance({ fsType: fsType }),
              // Optional: Defaults to false (read/write). ReadOnly here will force the ReadOnly setting in VolumeMounts. More info: https://examples.k8s.io/mysql-cinder-pd/README.md
              withReadOnly(readOnly):: self + self.mixinInstance({ readOnly: readOnly }),
              // Optional: points to a secret object containing parameters used to connect to OpenStack.
              secretRef:: {
                local __mixinSecretRef(secretRef) = { secretRef+: secretRef },
                mixinInstance(secretRef):: __mixinSecretRef(secretRef),
                // Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
                withName(name):: self + self.mixinInstance({ name: name }),
              },
              // volume id used to identify the volume in cinder. More info: https://examples.k8s.io/mysql-cinder-pd/README.md
              withVolumeID(volumeID):: self + self.mixinInstance({ volumeID: volumeID }),
            },
            // ConfigMap represents a configMap that should populate this volume
            configMap:: {
              local __mixinConfigMap(configMap) = { configMap+: configMap },
              mixinInstance(configMap):: __mixinConfigMap(configMap),
              // Optional: mode bits to use on created files by default. Must be a value between 0 and 0777. Defaults to 0644. Directories within the path are not affected by this setting. This might be in conflict with other options that affect the file mode, like fsGroup, and the result can be other mode bits set.
              withDefaultMode(defaultMode):: self + self.mixinInstance({ defaultMode: defaultMode }),
              // If unspecified, each key-value pair in the Data field of the referenced ConfigMap will be projected into the volume as a file whose name is the key and content is the value. If specified, the listed keys will be projected into the specified paths, and unlisted keys will not be present. If a key is specified which is not present in the ConfigMap, the volume setup will error unless it is marked optional. Paths must be relative and may not contain the '..' path or start with '..'.
              withItems(items):: self + if std.type(items) == 'array' then self.mixinInstance({ items: items }) else self.mixinInstance({ items: [items] }),
              // If unspecified, each key-value pair in the Data field of the referenced ConfigMap will be projected into the volume as a file whose name is the key and content is the value. If specified, the listed keys will be projected into the specified paths, and unlisted keys will not be present. If a key is specified which is not present in the ConfigMap, the volume setup will error unless it is marked optional. Paths must be relative and may not contain the '..' path or start with '..'.
              withItemsMixin(items):: self + if std.type(items) == 'array' then self.mixinInstance({ items+: items }) else self.mixinInstance({ items+: [items] }),
              itemsType:: hidden.v1.KeyToPath,
              // Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
              withName(name):: self + self.mixinInstance({ name: name }),
              // Specify whether the ConfigMap or its keys must be defined
              withOptional(optional):: self + self.mixinInstance({ optional: optional }),
            },
            // CSI (Container Storage Interface) represents storage that is handled by an external CSI driver (Alpha feature).
            csi:: {
              local __mixinCsi(csi) = { csi+: csi },
              mixinInstance(csi):: __mixinCsi(csi),
              // Driver is the name of the CSI driver that handles this volume. Consult with your admin for the correct name as registered in the cluster.
              withDriver(driver):: self + self.mixinInstance({ driver: driver }),
              // Filesystem type to mount. Ex. "ext4", "xfs", "ntfs". If not provided, the empty value is passed to the associated CSI driver which will determine the default filesystem to apply.
              withFsType(fsType):: self + self.mixinInstance({ fsType: fsType }),
              // NodePublishSecretRef is a reference to the secret object containing sensitive information to pass to the CSI driver to complete the CSI NodePublishVolume and NodeUnpublishVolume calls. This field is optional, and  may be empty if no secret is required. If the secret object contains more than one secret, all secret references are passed.
              nodePublishSecretRef:: {
                local __mixinNodePublishSecretRef(nodePublishSecretRef) = { nodePublishSecretRef+: nodePublishSecretRef },
                mixinInstance(nodePublishSecretRef):: __mixinNodePublishSecretRef(nodePublishSecretRef),
                // Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
                withName(name):: self + self.mixinInstance({ name: name }),
              },
              // Specifies a read-only configuration for the volume. Defaults to false (read/write).
              withReadOnly(readOnly):: self + self.mixinInstance({ readOnly: readOnly }),
              // VolumeAttributes stores driver-specific properties that are passed to the CSI driver. Consult your driver's documentation for supported values.
              withVolumeAttributes(volumeAttributes):: self + self.mixinInstance({ volumeAttributes: volumeAttributes }),
            },
            // DownwardAPI represents downward API about the pod that should populate this volume
            downwardAPI:: {
              local __mixinDownwardAPI(downwardAPI) = { downwardAPI+: downwardAPI },
              mixinInstance(downwardAPI):: __mixinDownwardAPI(downwardAPI),
              // Optional: mode bits to use on created files by default. Must be a value between 0 and 0777. Defaults to 0644. Directories within the path are not affected by this setting. This might be in conflict with other options that affect the file mode, like fsGroup, and the result can be other mode bits set.
              withDefaultMode(defaultMode):: self + self.mixinInstance({ defaultMode: defaultMode }),
              // Items is a list of downward API volume file
              withItems(items):: self + if std.type(items) == 'array' then self.mixinInstance({ items: items }) else self.mixinInstance({ items: [items] }),
              // Items is a list of downward API volume file
              withItemsMixin(items):: self + if std.type(items) == 'array' then self.mixinInstance({ items+: items }) else self.mixinInstance({ items+: [items] }),
              itemsType:: hidden.v1.DownwardAPIVolumeFile,
            },
            // EmptyDir represents a temporary directory that shares a pod's lifetime. More info: https://kubernetes.io/docs/concepts/storage/volumes#emptydir
            emptyDir:: {
              local __mixinEmptyDir(emptyDir) = { emptyDir+: emptyDir },
              mixinInstance(emptyDir):: __mixinEmptyDir(emptyDir),
              // What type of storage medium should back this directory. The default is "" which means to use the node's default medium. Must be an empty string (default) or Memory. More info: https://kubernetes.io/docs/concepts/storage/volumes#emptydir
              withMedium(medium):: self + self.mixinInstance({ medium: medium }),
              // Total amount of local storage required for this EmptyDir volume. The size limit is also applicable for memory medium. The maximum usage on memory medium EmptyDir would be the minimum value between the SizeLimit specified here and the sum of memory limits of all containers in a pod. The default is nil which means that the limit is undefined. More info: http://kubernetes.io/docs/user-guide/volumes#emptydir
              withSizeLimit(sizeLimit):: self + self.mixinInstance({ sizeLimit: sizeLimit }),
            },
            // FC represents a Fibre Channel resource that is attached to a kubelet's host machine and then exposed to the pod.
            fc:: {
              local __mixinFc(fc) = { fc+: fc },
              mixinInstance(fc):: __mixinFc(fc),
              // Filesystem type to mount. Must be a filesystem type supported by the host operating system. Ex. "ext4", "xfs", "ntfs". Implicitly inferred to be "ext4" if unspecified.
              withFsType(fsType):: self + self.mixinInstance({ fsType: fsType }),
              // Optional: FC target lun number
              withLun(lun):: self + self.mixinInstance({ lun: lun }),
              // Optional: Defaults to false (read/write). ReadOnly here will force the ReadOnly setting in VolumeMounts.
              withReadOnly(readOnly):: self + self.mixinInstance({ readOnly: readOnly }),
              // Optional: FC target worldwide names (WWNs)
              withTargetWWNs(targetWWNs):: self + if std.type(targetWWNs) == 'array' then self.mixinInstance({ targetWWNs: targetWWNs }) else self.mixinInstance({ targetWWNs: [targetWWNs] }),
              // Optional: FC target worldwide names (WWNs)
              withTargetWWNsMixin(targetWWNs):: self + if std.type(targetWWNs) == 'array' then self.mixinInstance({ targetWWNs+: targetWWNs }) else self.mixinInstance({ targetWWNs+: [targetWWNs] }),
              // Optional: FC volume world wide identifiers (wwids) Either wwids or combination of targetWWNs and lun must be set, but not both simultaneously.
              withWwids(wwids):: self + if std.type(wwids) == 'array' then self.mixinInstance({ wwids: wwids }) else self.mixinInstance({ wwids: [wwids] }),
              // Optional: FC volume world wide identifiers (wwids) Either wwids or combination of targetWWNs and lun must be set, but not both simultaneously.
              withWwidsMixin(wwids):: self + if std.type(wwids) == 'array' then self.mixinInstance({ wwids+: wwids }) else self.mixinInstance({ wwids+: [wwids] }),
            },
            // FlexVolume represents a generic volume resource that is provisioned/attached using an exec based plugin.
            flexVolume:: {
              local __mixinFlexVolume(flexVolume) = { flexVolume+: flexVolume },
              mixinInstance(flexVolume):: __mixinFlexVolume(flexVolume),
              // Driver is the name of the driver to use for this volume.
              withDriver(driver):: self + self.mixinInstance({ driver: driver }),
              // Filesystem type to mount. Must be a filesystem type supported by the host operating system. Ex. "ext4", "xfs", "ntfs". The default filesystem depends on FlexVolume script.
              withFsType(fsType):: self + self.mixinInstance({ fsType: fsType }),
              // Optional: Extra command options if any.
              withOptions(options):: self + self.mixinInstance({ options: options }),
              // Optional: Defaults to false (read/write). ReadOnly here will force the ReadOnly setting in VolumeMounts.
              withReadOnly(readOnly):: self + self.mixinInstance({ readOnly: readOnly }),
              // Optional: SecretRef is reference to the secret object containing sensitive information to pass to the plugin scripts. This may be empty if no secret object is specified. If the secret object contains more than one secret, all secrets are passed to the plugin scripts.
              secretRef:: {
                local __mixinSecretRef(secretRef) = { secretRef+: secretRef },
                mixinInstance(secretRef):: __mixinSecretRef(secretRef),
                // Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
                withName(name):: self + self.mixinInstance({ name: name }),
              },
            },
            // Flocker represents a Flocker volume attached to a kubelet's host machine. This depends on the Flocker control service being running
            flocker:: {
              local __mixinFlocker(flocker) = { flocker+: flocker },
              mixinInstance(flocker):: __mixinFlocker(flocker),
              // Name of the dataset stored as metadata -> name on the dataset for Flocker should be considered as deprecated
              withDatasetName(datasetName):: self + self.mixinInstance({ datasetName: datasetName }),
              // UUID of the dataset. This is unique identifier of a Flocker dataset
              withDatasetUUID(datasetUUID):: self + self.mixinInstance({ datasetUUID: datasetUUID }),
            },
            // GCEPersistentDisk represents a GCE Disk resource that is attached to a kubelet's host machine and then exposed to the pod. More info: https://kubernetes.io/docs/concepts/storage/volumes#gcepersistentdisk
            gcePersistentDisk:: {
              local __mixinGcePersistentDisk(gcePersistentDisk) = { gcePersistentDisk+: gcePersistentDisk },
              mixinInstance(gcePersistentDisk):: __mixinGcePersistentDisk(gcePersistentDisk),
              // Filesystem type of the volume that you want to mount. Tip: Ensure that the filesystem type is supported by the host operating system. Examples: "ext4", "xfs", "ntfs". Implicitly inferred to be "ext4" if unspecified. More info: https://kubernetes.io/docs/concepts/storage/volumes#gcepersistentdisk
              withFsType(fsType):: self + self.mixinInstance({ fsType: fsType }),
              // The partition in the volume that you want to mount. If omitted, the default is to mount by volume name. Examples: For volume /dev/sda1, you specify the partition as "1". Similarly, the volume partition for /dev/sda is "0" (or you can leave the property empty). More info: https://kubernetes.io/docs/concepts/storage/volumes#gcepersistentdisk
              withPartition(partition):: self + self.mixinInstance({ partition: partition }),
              // Unique name of the PD resource in GCE. Used to identify the disk in GCE. More info: https://kubernetes.io/docs/concepts/storage/volumes#gcepersistentdisk
              withPdName(pdName):: self + self.mixinInstance({ pdName: pdName }),
              // ReadOnly here will force the ReadOnly setting in VolumeMounts. Defaults to false. More info: https://kubernetes.io/docs/concepts/storage/volumes#gcepersistentdisk
              withReadOnly(readOnly):: self + self.mixinInstance({ readOnly: readOnly }),
            },
            // GitRepo represents a git repository at a particular revision. DEPRECATED: GitRepo is deprecated. To provision a container with a git repo, mount an EmptyDir into an InitContainer that clones the repo using git, then mount the EmptyDir into the Pod's container.
            gitRepo:: {
              local __mixinGitRepo(gitRepo) = { gitRepo+: gitRepo },
              mixinInstance(gitRepo):: __mixinGitRepo(gitRepo),
              // Target directory name. Must not contain or start with '..'.  If '.' is supplied, the volume directory will be the git repository.  Otherwise, if specified, the volume will contain the git repository in the subdirectory with the given name.
              withDirectory(directory):: self + self.mixinInstance({ directory: directory }),
              // Repository URL
              withRepository(repository):: self + self.mixinInstance({ repository: repository }),
              // Commit hash for the specified revision.
              withRevision(revision):: self + self.mixinInstance({ revision: revision }),
            },
            // Glusterfs represents a Glusterfs mount on the host that shares a pod's lifetime. More info: https://examples.k8s.io/volumes/glusterfs/README.md
            glusterfs:: {
              local __mixinGlusterfs(glusterfs) = { glusterfs+: glusterfs },
              mixinInstance(glusterfs):: __mixinGlusterfs(glusterfs),
              // EndpointsName is the endpoint name that details Glusterfs topology. More info: https://examples.k8s.io/volumes/glusterfs/README.md#create-a-pod
              withEndpoints(endpoints):: self + self.mixinInstance({ endpoints: endpoints }),
              // Path is the Glusterfs volume path. More info: https://examples.k8s.io/volumes/glusterfs/README.md#create-a-pod
              withPath(path):: self + self.mixinInstance({ path: path }),
              // ReadOnly here will force the Glusterfs volume to be mounted with read-only permissions. Defaults to false. More info: https://examples.k8s.io/volumes/glusterfs/README.md#create-a-pod
              withReadOnly(readOnly):: self + self.mixinInstance({ readOnly: readOnly }),
            },
            // HostPath represents a pre-existing file or directory on the host machine that is directly exposed to the container. This is generally used for system agents or other privileged things that are allowed to see the host machine. Most containers will NOT need this. More info: https://kubernetes.io/docs/concepts/storage/volumes#hostpath
            hostPath:: {
              local __mixinHostPath(hostPath) = { hostPath+: hostPath },
              mixinInstance(hostPath):: __mixinHostPath(hostPath),
              // Path of the directory on the host. If the path is a symlink, it will follow the link to the real path. More info: https://kubernetes.io/docs/concepts/storage/volumes#hostpath
              withPath(path):: self + self.mixinInstance({ path: path }),
              // Type for HostPath Volume Defaults to "" More info: https://kubernetes.io/docs/concepts/storage/volumes#hostpath
              withType(type):: self + self.mixinInstance({ type: type }),
            },
            // ISCSI represents an ISCSI Disk resource that is attached to a kubelet's host machine and then exposed to the pod. More info: https://examples.k8s.io/volumes/iscsi/README.md
            iscsi:: {
              local __mixinIscsi(iscsi) = { iscsi+: iscsi },
              mixinInstance(iscsi):: __mixinIscsi(iscsi),
              // whether support iSCSI Discovery CHAP authentication
              withChapAuthDiscovery(chapAuthDiscovery):: self + self.mixinInstance({ chapAuthDiscovery: chapAuthDiscovery }),
              // whether support iSCSI Session CHAP authentication
              withChapAuthSession(chapAuthSession):: self + self.mixinInstance({ chapAuthSession: chapAuthSession }),
              // Filesystem type of the volume that you want to mount. Tip: Ensure that the filesystem type is supported by the host operating system. Examples: "ext4", "xfs", "ntfs". Implicitly inferred to be "ext4" if unspecified. More info: https://kubernetes.io/docs/concepts/storage/volumes#iscsi
              withFsType(fsType):: self + self.mixinInstance({ fsType: fsType }),
              // Custom iSCSI Initiator Name. If initiatorName is specified with iscsiInterface simultaneously, new iSCSI interface <target portal>:<volume name> will be created for the connection.
              withInitiatorName(initiatorName):: self + self.mixinInstance({ initiatorName: initiatorName }),
              // Target iSCSI Qualified Name.
              withIqn(iqn):: self + self.mixinInstance({ iqn: iqn }),
              // iSCSI Interface Name that uses an iSCSI transport. Defaults to 'default' (tcp).
              withIscsiInterface(iscsiInterface):: self + self.mixinInstance({ iscsiInterface: iscsiInterface }),
              // iSCSI Target Lun number.
              withLun(lun):: self + self.mixinInstance({ lun: lun }),
              // iSCSI Target Portal List. The portal is either an IP or ip_addr:port if the port is other than default (typically TCP ports 860 and 3260).
              withPortals(portals):: self + if std.type(portals) == 'array' then self.mixinInstance({ portals: portals }) else self.mixinInstance({ portals: [portals] }),
              // iSCSI Target Portal List. The portal is either an IP or ip_addr:port if the port is other than default (typically TCP ports 860 and 3260).
              withPortalsMixin(portals):: self + if std.type(portals) == 'array' then self.mixinInstance({ portals+: portals }) else self.mixinInstance({ portals+: [portals] }),
              // ReadOnly here will force the ReadOnly setting in VolumeMounts. Defaults to false.
              withReadOnly(readOnly):: self + self.mixinInstance({ readOnly: readOnly }),
              // CHAP Secret for iSCSI target and initiator authentication
              secretRef:: {
                local __mixinSecretRef(secretRef) = { secretRef+: secretRef },
                mixinInstance(secretRef):: __mixinSecretRef(secretRef),
                // Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
                withName(name):: self + self.mixinInstance({ name: name }),
              },
              // iSCSI Target Portal. The Portal is either an IP or ip_addr:port if the port is other than default (typically TCP ports 860 and 3260).
              withTargetPortal(targetPortal):: self + self.mixinInstance({ targetPortal: targetPortal }),
            },
            // NFS represents an NFS mount on the host that shares a pod's lifetime More info: https://kubernetes.io/docs/concepts/storage/volumes#nfs
            nfs:: {
              local __mixinNfs(nfs) = { nfs+: nfs },
              mixinInstance(nfs):: __mixinNfs(nfs),
              // Path that is exported by the NFS server. More info: https://kubernetes.io/docs/concepts/storage/volumes#nfs
              withPath(path):: self + self.mixinInstance({ path: path }),
              // ReadOnly here will force the NFS export to be mounted with read-only permissions. Defaults to false. More info: https://kubernetes.io/docs/concepts/storage/volumes#nfs
              withReadOnly(readOnly):: self + self.mixinInstance({ readOnly: readOnly }),
              // Server is the hostname or IP address of the NFS server. More info: https://kubernetes.io/docs/concepts/storage/volumes#nfs
              withServer(server):: self + self.mixinInstance({ server: server }),
            },
            // PersistentVolumeClaimVolumeSource represents a reference to a PersistentVolumeClaim in the same namespace. More info: https://kubernetes.io/docs/concepts/storage/persistent-volumes#persistentvolumeclaims
            persistentVolumeClaim:: {
              local __mixinPersistentVolumeClaim(persistentVolumeClaim) = { persistentVolumeClaim+: persistentVolumeClaim },
              mixinInstance(persistentVolumeClaim):: __mixinPersistentVolumeClaim(persistentVolumeClaim),
              // ClaimName is the name of a PersistentVolumeClaim in the same namespace as the pod using this volume. More info: https://kubernetes.io/docs/concepts/storage/persistent-volumes#persistentvolumeclaims
              withClaimName(claimName):: self + self.mixinInstance({ claimName: claimName }),
              // Will force the ReadOnly setting in VolumeMounts. Default false.
              withReadOnly(readOnly):: self + self.mixinInstance({ readOnly: readOnly }),
            },
            // PhotonPersistentDisk represents a PhotonController persistent disk attached and mounted on kubelets host machine
            photonPersistentDisk:: {
              local __mixinPhotonPersistentDisk(photonPersistentDisk) = { photonPersistentDisk+: photonPersistentDisk },
              mixinInstance(photonPersistentDisk):: __mixinPhotonPersistentDisk(photonPersistentDisk),
              // Filesystem type to mount. Must be a filesystem type supported by the host operating system. Ex. "ext4", "xfs", "ntfs". Implicitly inferred to be "ext4" if unspecified.
              withFsType(fsType):: self + self.mixinInstance({ fsType: fsType }),
              // ID that identifies Photon Controller persistent disk
              withPdID(pdID):: self + self.mixinInstance({ pdID: pdID }),
            },
            // PortworxVolume represents a portworx volume attached and mounted on kubelets host machine
            portworxVolume:: {
              local __mixinPortworxVolume(portworxVolume) = { portworxVolume+: portworxVolume },
              mixinInstance(portworxVolume):: __mixinPortworxVolume(portworxVolume),
              // FSType represents the filesystem type to mount Must be a filesystem type supported by the host operating system. Ex. "ext4", "xfs". Implicitly inferred to be "ext4" if unspecified.
              withFsType(fsType):: self + self.mixinInstance({ fsType: fsType }),
              // Defaults to false (read/write). ReadOnly here will force the ReadOnly setting in VolumeMounts.
              withReadOnly(readOnly):: self + self.mixinInstance({ readOnly: readOnly }),
              // VolumeID uniquely identifies a Portworx volume
              withVolumeID(volumeID):: self + self.mixinInstance({ volumeID: volumeID }),
            },
            // Items for all in one resources secrets, configmaps, and downward API
            projected:: {
              local __mixinProjected(projected) = { projected+: projected },
              mixinInstance(projected):: __mixinProjected(projected),
              // Mode bits to use on created files by default. Must be a value between 0 and 0777. Directories within the path are not affected by this setting. This might be in conflict with other options that affect the file mode, like fsGroup, and the result can be other mode bits set.
              withDefaultMode(defaultMode):: self + self.mixinInstance({ defaultMode: defaultMode }),
              // list of volume projections
              withSources(sources):: self + if std.type(sources) == 'array' then self.mixinInstance({ sources: sources }) else self.mixinInstance({ sources: [sources] }),
              // list of volume projections
              withSourcesMixin(sources):: self + if std.type(sources) == 'array' then self.mixinInstance({ sources+: sources }) else self.mixinInstance({ sources+: [sources] }),
              sourcesType:: hidden.v1.VolumeProjection,
            },
            // Quobyte represents a Quobyte mount on the host that shares a pod's lifetime
            quobyte:: {
              local __mixinQuobyte(quobyte) = { quobyte+: quobyte },
              mixinInstance(quobyte):: __mixinQuobyte(quobyte),
              // Group to map volume access to Default is no group
              withGroup(group):: self + self.mixinInstance({ group: group }),
              // ReadOnly here will force the Quobyte volume to be mounted with read-only permissions. Defaults to false.
              withReadOnly(readOnly):: self + self.mixinInstance({ readOnly: readOnly }),
              // Registry represents a single or multiple Quobyte Registry services specified as a string as host:port pair (multiple entries are separated with commas) which acts as the central registry for volumes
              withRegistry(registry):: self + self.mixinInstance({ registry: registry }),
              // Tenant owning the given Quobyte volume in the Backend Used with dynamically provisioned Quobyte volumes, value is set by the plugin
              withTenant(tenant):: self + self.mixinInstance({ tenant: tenant }),
              // User to map volume access to Defaults to serivceaccount user
              withUser(user):: self + self.mixinInstance({ user: user }),
              // Volume is a string that references an already created Quobyte volume by name.
              withVolume(volume):: self + self.mixinInstance({ volume: volume }),
            },
            // RBD represents a Rados Block Device mount on the host that shares a pod's lifetime. More info: https://examples.k8s.io/volumes/rbd/README.md
            rbd:: {
              local __mixinRbd(rbd) = { rbd+: rbd },
              mixinInstance(rbd):: __mixinRbd(rbd),
              // Filesystem type of the volume that you want to mount. Tip: Ensure that the filesystem type is supported by the host operating system. Examples: "ext4", "xfs", "ntfs". Implicitly inferred to be "ext4" if unspecified. More info: https://kubernetes.io/docs/concepts/storage/volumes#rbd
              withFsType(fsType):: self + self.mixinInstance({ fsType: fsType }),
              // The rados image name. More info: https://examples.k8s.io/volumes/rbd/README.md#how-to-use-it
              withImage(image):: self + self.mixinInstance({ image: image }),
              // Keyring is the path to key ring for RBDUser. Default is /etc/ceph/keyring. More info: https://examples.k8s.io/volumes/rbd/README.md#how-to-use-it
              withKeyring(keyring):: self + self.mixinInstance({ keyring: keyring }),
              // A collection of Ceph monitors. More info: https://examples.k8s.io/volumes/rbd/README.md#how-to-use-it
              withMonitors(monitors):: self + if std.type(monitors) == 'array' then self.mixinInstance({ monitors: monitors }) else self.mixinInstance({ monitors: [monitors] }),
              // A collection of Ceph monitors. More info: https://examples.k8s.io/volumes/rbd/README.md#how-to-use-it
              withMonitorsMixin(monitors):: self + if std.type(monitors) == 'array' then self.mixinInstance({ monitors+: monitors }) else self.mixinInstance({ monitors+: [monitors] }),
              // The rados pool name. Default is rbd. More info: https://examples.k8s.io/volumes/rbd/README.md#how-to-use-it
              withPool(pool):: self + self.mixinInstance({ pool: pool }),
              // ReadOnly here will force the ReadOnly setting in VolumeMounts. Defaults to false. More info: https://examples.k8s.io/volumes/rbd/README.md#how-to-use-it
              withReadOnly(readOnly):: self + self.mixinInstance({ readOnly: readOnly }),
              // SecretRef is name of the authentication secret for RBDUser. If provided overrides keyring. Default is nil. More info: https://examples.k8s.io/volumes/rbd/README.md#how-to-use-it
              secretRef:: {
                local __mixinSecretRef(secretRef) = { secretRef+: secretRef },
                mixinInstance(secretRef):: __mixinSecretRef(secretRef),
                // Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
                withName(name):: self + self.mixinInstance({ name: name }),
              },
              // The rados user name. Default is admin. More info: https://examples.k8s.io/volumes/rbd/README.md#how-to-use-it
              withUser(user):: self + self.mixinInstance({ user: user }),
            },
            // ScaleIO represents a ScaleIO persistent volume attached and mounted on Kubernetes nodes.
            scaleIO:: {
              local __mixinScaleIO(scaleIO) = { scaleIO+: scaleIO },
              mixinInstance(scaleIO):: __mixinScaleIO(scaleIO),
              // Filesystem type to mount. Must be a filesystem type supported by the host operating system. Ex. "ext4", "xfs", "ntfs". Default is "xfs".
              withFsType(fsType):: self + self.mixinInstance({ fsType: fsType }),
              // The host address of the ScaleIO API Gateway.
              withGateway(gateway):: self + self.mixinInstance({ gateway: gateway }),
              // The name of the ScaleIO Protection Domain for the configured storage.
              withProtectionDomain(protectionDomain):: self + self.mixinInstance({ protectionDomain: protectionDomain }),
              // Defaults to false (read/write). ReadOnly here will force the ReadOnly setting in VolumeMounts.
              withReadOnly(readOnly):: self + self.mixinInstance({ readOnly: readOnly }),
              // SecretRef references to the secret for ScaleIO user and other sensitive information. If this is not provided, Login operation will fail.
              secretRef:: {
                local __mixinSecretRef(secretRef) = { secretRef+: secretRef },
                mixinInstance(secretRef):: __mixinSecretRef(secretRef),
                // Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
                withName(name):: self + self.mixinInstance({ name: name }),
              },
              // Flag to enable/disable SSL communication with Gateway, default false
              withSslEnabled(sslEnabled):: self + self.mixinInstance({ sslEnabled: sslEnabled }),
              // Indicates whether the storage for a volume should be ThickProvisioned or ThinProvisioned. Default is ThinProvisioned.
              withStorageMode(storageMode):: self + self.mixinInstance({ storageMode: storageMode }),
              // The ScaleIO Storage Pool associated with the protection domain.
              withStoragePool(storagePool):: self + self.mixinInstance({ storagePool: storagePool }),
              // The name of the storage system as configured in ScaleIO.
              withSystem(system):: self + self.mixinInstance({ system: system }),
              // The name of a volume already created in the ScaleIO system that is associated with this volume source.
              withVolumeName(volumeName):: self + self.mixinInstance({ volumeName: volumeName }),
            },
            // Secret represents a secret that should populate this volume. More info: https://kubernetes.io/docs/concepts/storage/volumes#secret
            secret:: {
              local __mixinSecret(secret) = { secret+: secret },
              mixinInstance(secret):: __mixinSecret(secret),
              // Optional: mode bits to use on created files by default. Must be a value between 0 and 0777. Defaults to 0644. Directories within the path are not affected by this setting. This might be in conflict with other options that affect the file mode, like fsGroup, and the result can be other mode bits set.
              withDefaultMode(defaultMode):: self + self.mixinInstance({ defaultMode: defaultMode }),
              // If unspecified, each key-value pair in the Data field of the referenced Secret will be projected into the volume as a file whose name is the key and content is the value. If specified, the listed keys will be projected into the specified paths, and unlisted keys will not be present. If a key is specified which is not present in the Secret, the volume setup will error unless it is marked optional. Paths must be relative and may not contain the '..' path or start with '..'.
              withItems(items):: self + if std.type(items) == 'array' then self.mixinInstance({ items: items }) else self.mixinInstance({ items: [items] }),
              // If unspecified, each key-value pair in the Data field of the referenced Secret will be projected into the volume as a file whose name is the key and content is the value. If specified, the listed keys will be projected into the specified paths, and unlisted keys will not be present. If a key is specified which is not present in the Secret, the volume setup will error unless it is marked optional. Paths must be relative and may not contain the '..' path or start with '..'.
              withItemsMixin(items):: self + if std.type(items) == 'array' then self.mixinInstance({ items+: items }) else self.mixinInstance({ items+: [items] }),
              itemsType:: hidden.v1.KeyToPath,
              // Specify whether the Secret or its keys must be defined
              withOptional(optional):: self + self.mixinInstance({ optional: optional }),
              // Name of the secret in the pod's namespace to use. More info: https://kubernetes.io/docs/concepts/storage/volumes#secret
              withSecretName(secretName):: self + self.mixinInstance({ secretName: secretName }),
            },
            // StorageOS represents a StorageOS volume attached and mounted on Kubernetes nodes.
            storageos:: {
              local __mixinStorageos(storageos) = { storageos+: storageos },
              mixinInstance(storageos):: __mixinStorageos(storageos),
              // Filesystem type to mount. Must be a filesystem type supported by the host operating system. Ex. "ext4", "xfs", "ntfs". Implicitly inferred to be "ext4" if unspecified.
              withFsType(fsType):: self + self.mixinInstance({ fsType: fsType }),
              // Defaults to false (read/write). ReadOnly here will force the ReadOnly setting in VolumeMounts.
              withReadOnly(readOnly):: self + self.mixinInstance({ readOnly: readOnly }),
              // SecretRef specifies the secret to use for obtaining the StorageOS API credentials.  If not specified, default values will be attempted.
              secretRef:: {
                local __mixinSecretRef(secretRef) = { secretRef+: secretRef },
                mixinInstance(secretRef):: __mixinSecretRef(secretRef),
                // Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
                withName(name):: self + self.mixinInstance({ name: name }),
              },
              // VolumeName is the human-readable name of the StorageOS volume.  Volume names are only unique within a namespace.
              withVolumeName(volumeName):: self + self.mixinInstance({ volumeName: volumeName }),
              // VolumeNamespace specifies the scope of the volume within StorageOS.  If no namespace is specified then the Pod's namespace will be used.  This allows the Kubernetes name scoping to be mirrored within StorageOS for tighter integration. Set VolumeName to any name to override the default behaviour. Set to "default" if you are not using namespaces within StorageOS. Namespaces that do not pre-exist within StorageOS will be created.
              withVolumeNamespace(volumeNamespace):: self + self.mixinInstance({ volumeNamespace: volumeNamespace }),
            },
            // VsphereVolume represents a vSphere volume attached and mounted on kubelets host machine
            vsphereVolume:: {
              local __mixinVsphereVolume(vsphereVolume) = { vsphereVolume+: vsphereVolume },
              mixinInstance(vsphereVolume):: __mixinVsphereVolume(vsphereVolume),
              // Filesystem type to mount. Must be a filesystem type supported by the host operating system. Ex. "ext4", "xfs", "ntfs". Implicitly inferred to be "ext4" if unspecified.
              withFsType(fsType):: self + self.mixinInstance({ fsType: fsType }),
              // Storage Policy Based Management (SPBM) profile ID associated with the StoragePolicyName.
              withStoragePolicyID(storagePolicyID):: self + self.mixinInstance({ storagePolicyID: storagePolicyID }),
              // Storage Policy Based Management (SPBM) profile name.
              withStoragePolicyName(storagePolicyName):: self + self.mixinInstance({ storagePolicyName: storagePolicyName }),
              // Path that identifies vSphere volume vmdk
              withVolumePath(volumePath):: self + self.mixinInstance({ volumePath: volumePath }),
            },
          },
        },
        // Affinity is a group of affinity scheduling rules.
        affinity:: {
          local kind = { kind: 'Affinity' },
          mixin:: {
            // Describes node affinity scheduling rules for the pod.
            nodeAffinity:: {
              local __mixinNodeAffinity(nodeAffinity) = { nodeAffinity+: nodeAffinity },
              mixinInstance(nodeAffinity):: __mixinNodeAffinity(nodeAffinity),
              // The scheduler will prefer to schedule pods to nodes that satisfy the affinity expressions specified by this field, but it may choose a node that violates one or more of the expressions. The node that is most preferred is the one with the greatest sum of weights, i.e. for each node that meets all of the scheduling requirements (resource request, requiredDuringScheduling affinity expressions, etc.), compute a sum by iterating through the elements of this field and adding "weight" to the sum if the node matches the corresponding matchExpressions; the node(s) with the highest sum are the most preferred.
              withPreferredDuringSchedulingIgnoredDuringExecution(preferredDuringSchedulingIgnoredDuringExecution):: self + if std.type(preferredDuringSchedulingIgnoredDuringExecution) == 'array' then self.mixinInstance({ preferredDuringSchedulingIgnoredDuringExecution: preferredDuringSchedulingIgnoredDuringExecution }) else self.mixinInstance({ preferredDuringSchedulingIgnoredDuringExecution: [preferredDuringSchedulingIgnoredDuringExecution] }),
              // The scheduler will prefer to schedule pods to nodes that satisfy the affinity expressions specified by this field, but it may choose a node that violates one or more of the expressions. The node that is most preferred is the one with the greatest sum of weights, i.e. for each node that meets all of the scheduling requirements (resource request, requiredDuringScheduling affinity expressions, etc.), compute a sum by iterating through the elements of this field and adding "weight" to the sum if the node matches the corresponding matchExpressions; the node(s) with the highest sum are the most preferred.
              withPreferredDuringSchedulingIgnoredDuringExecutionMixin(preferredDuringSchedulingIgnoredDuringExecution):: self + if std.type(preferredDuringSchedulingIgnoredDuringExecution) == 'array' then self.mixinInstance({ preferredDuringSchedulingIgnoredDuringExecution+: preferredDuringSchedulingIgnoredDuringExecution }) else self.mixinInstance({ preferredDuringSchedulingIgnoredDuringExecution+: [preferredDuringSchedulingIgnoredDuringExecution] }),
              preferredDuringSchedulingIgnoredDuringExecutionType:: hidden.v1.PreferredSchedulingTerm,
              // If the affinity requirements specified by this field are not met at scheduling time, the pod will not be scheduled onto the node. If the affinity requirements specified by this field cease to be met at some point during pod execution (e.g. due to an update), the system may or may not try to eventually evict the pod from its node.
              requiredDuringSchedulingIgnoredDuringExecution:: {
                local __mixinRequiredDuringSchedulingIgnoredDuringExecution(requiredDuringSchedulingIgnoredDuringExecution) = { requiredDuringSchedulingIgnoredDuringExecution+: requiredDuringSchedulingIgnoredDuringExecution },
                mixinInstance(requiredDuringSchedulingIgnoredDuringExecution):: __mixinRequiredDuringSchedulingIgnoredDuringExecution(requiredDuringSchedulingIgnoredDuringExecution),
                // Required. A list of node selector terms. The terms are ORed.
                withNodeSelectorTerms(nodeSelectorTerms):: self + if std.type(nodeSelectorTerms) == 'array' then self.mixinInstance({ nodeSelectorTerms: nodeSelectorTerms }) else self.mixinInstance({ nodeSelectorTerms: [nodeSelectorTerms] }),
                // Required. A list of node selector terms. The terms are ORed.
                withNodeSelectorTermsMixin(nodeSelectorTerms):: self + if std.type(nodeSelectorTerms) == 'array' then self.mixinInstance({ nodeSelectorTerms+: nodeSelectorTerms }) else self.mixinInstance({ nodeSelectorTerms+: [nodeSelectorTerms] }),
                nodeSelectorTermsType:: hidden.v1.NodeSelectorTerm,
              },
            },
            // Describes pod affinity scheduling rules (e.g. co-locate this pod in the same node, zone, etc. as some other pod(s)).
            podAffinity:: {
              local __mixinPodAffinity(podAffinity) = { podAffinity+: podAffinity },
              mixinInstance(podAffinity):: __mixinPodAffinity(podAffinity),
              // The scheduler will prefer to schedule pods to nodes that satisfy the affinity expressions specified by this field, but it may choose a node that violates one or more of the expressions. The node that is most preferred is the one with the greatest sum of weights, i.e. for each node that meets all of the scheduling requirements (resource request, requiredDuringScheduling affinity expressions, etc.), compute a sum by iterating through the elements of this field and adding "weight" to the sum if the node has pods which matches the corresponding podAffinityTerm; the node(s) with the highest sum are the most preferred.
              withPreferredDuringSchedulingIgnoredDuringExecution(preferredDuringSchedulingIgnoredDuringExecution):: self + if std.type(preferredDuringSchedulingIgnoredDuringExecution) == 'array' then self.mixinInstance({ preferredDuringSchedulingIgnoredDuringExecution: preferredDuringSchedulingIgnoredDuringExecution }) else self.mixinInstance({ preferredDuringSchedulingIgnoredDuringExecution: [preferredDuringSchedulingIgnoredDuringExecution] }),
              // The scheduler will prefer to schedule pods to nodes that satisfy the affinity expressions specified by this field, but it may choose a node that violates one or more of the expressions. The node that is most preferred is the one with the greatest sum of weights, i.e. for each node that meets all of the scheduling requirements (resource request, requiredDuringScheduling affinity expressions, etc.), compute a sum by iterating through the elements of this field and adding "weight" to the sum if the node has pods which matches the corresponding podAffinityTerm; the node(s) with the highest sum are the most preferred.
              withPreferredDuringSchedulingIgnoredDuringExecutionMixin(preferredDuringSchedulingIgnoredDuringExecution):: self + if std.type(preferredDuringSchedulingIgnoredDuringExecution) == 'array' then self.mixinInstance({ preferredDuringSchedulingIgnoredDuringExecution+: preferredDuringSchedulingIgnoredDuringExecution }) else self.mixinInstance({ preferredDuringSchedulingIgnoredDuringExecution+: [preferredDuringSchedulingIgnoredDuringExecution] }),
              preferredDuringSchedulingIgnoredDuringExecutionType:: hidden.v1.WeightedPodAffinityTerm,
              // If the affinity requirements specified by this field are not met at scheduling time, the pod will not be scheduled onto the node. If the affinity requirements specified by this field cease to be met at some point during pod execution (e.g. due to a pod label update), the system may or may not try to eventually evict the pod from its node. When there are multiple elements, the lists of nodes corresponding to each podAffinityTerm are intersected, i.e. all terms must be satisfied.
              withRequiredDuringSchedulingIgnoredDuringExecution(requiredDuringSchedulingIgnoredDuringExecution):: self + if std.type(requiredDuringSchedulingIgnoredDuringExecution) == 'array' then self.mixinInstance({ requiredDuringSchedulingIgnoredDuringExecution: requiredDuringSchedulingIgnoredDuringExecution }) else self.mixinInstance({ requiredDuringSchedulingIgnoredDuringExecution: [requiredDuringSchedulingIgnoredDuringExecution] }),
              // If the affinity requirements specified by this field are not met at scheduling time, the pod will not be scheduled onto the node. If the affinity requirements specified by this field cease to be met at some point during pod execution (e.g. due to a pod label update), the system may or may not try to eventually evict the pod from its node. When there are multiple elements, the lists of nodes corresponding to each podAffinityTerm are intersected, i.e. all terms must be satisfied.
              withRequiredDuringSchedulingIgnoredDuringExecutionMixin(requiredDuringSchedulingIgnoredDuringExecution):: self + if std.type(requiredDuringSchedulingIgnoredDuringExecution) == 'array' then self.mixinInstance({ requiredDuringSchedulingIgnoredDuringExecution+: requiredDuringSchedulingIgnoredDuringExecution }) else self.mixinInstance({ requiredDuringSchedulingIgnoredDuringExecution+: [requiredDuringSchedulingIgnoredDuringExecution] }),
              requiredDuringSchedulingIgnoredDuringExecutionType:: hidden.v1.PodAffinityTerm,
            },
            // Describes pod anti-affinity scheduling rules (e.g. avoid putting this pod in the same node, zone, etc. as some other pod(s)).
            podAntiAffinity:: {
              local __mixinPodAntiAffinity(podAntiAffinity) = { podAntiAffinity+: podAntiAffinity },
              mixinInstance(podAntiAffinity):: __mixinPodAntiAffinity(podAntiAffinity),
              // The scheduler will prefer to schedule pods to nodes that satisfy the anti-affinity expressions specified by this field, but it may choose a node that violates one or more of the expressions. The node that is most preferred is the one with the greatest sum of weights, i.e. for each node that meets all of the scheduling requirements (resource request, requiredDuringScheduling anti-affinity expressions, etc.), compute a sum by iterating through the elements of this field and adding "weight" to the sum if the node has pods which matches the corresponding podAffinityTerm; the node(s) with the highest sum are the most preferred.
              withPreferredDuringSchedulingIgnoredDuringExecution(preferredDuringSchedulingIgnoredDuringExecution):: self + if std.type(preferredDuringSchedulingIgnoredDuringExecution) == 'array' then self.mixinInstance({ preferredDuringSchedulingIgnoredDuringExecution: preferredDuringSchedulingIgnoredDuringExecution }) else self.mixinInstance({ preferredDuringSchedulingIgnoredDuringExecution: [preferredDuringSchedulingIgnoredDuringExecution] }),
              // The scheduler will prefer to schedule pods to nodes that satisfy the anti-affinity expressions specified by this field, but it may choose a node that violates one or more of the expressions. The node that is most preferred is the one with the greatest sum of weights, i.e. for each node that meets all of the scheduling requirements (resource request, requiredDuringScheduling anti-affinity expressions, etc.), compute a sum by iterating through the elements of this field and adding "weight" to the sum if the node has pods which matches the corresponding podAffinityTerm; the node(s) with the highest sum are the most preferred.
              withPreferredDuringSchedulingIgnoredDuringExecutionMixin(preferredDuringSchedulingIgnoredDuringExecution):: self + if std.type(preferredDuringSchedulingIgnoredDuringExecution) == 'array' then self.mixinInstance({ preferredDuringSchedulingIgnoredDuringExecution+: preferredDuringSchedulingIgnoredDuringExecution }) else self.mixinInstance({ preferredDuringSchedulingIgnoredDuringExecution+: [preferredDuringSchedulingIgnoredDuringExecution] }),
              preferredDuringSchedulingIgnoredDuringExecutionType:: hidden.v1.WeightedPodAffinityTerm,
              // If the anti-affinity requirements specified by this field are not met at scheduling time, the pod will not be scheduled onto the node. If the anti-affinity requirements specified by this field cease to be met at some point during pod execution (e.g. due to a pod label update), the system may or may not try to eventually evict the pod from its node. When there are multiple elements, the lists of nodes corresponding to each podAffinityTerm are intersected, i.e. all terms must be satisfied.
              withRequiredDuringSchedulingIgnoredDuringExecution(requiredDuringSchedulingIgnoredDuringExecution):: self + if std.type(requiredDuringSchedulingIgnoredDuringExecution) == 'array' then self.mixinInstance({ requiredDuringSchedulingIgnoredDuringExecution: requiredDuringSchedulingIgnoredDuringExecution }) else self.mixinInstance({ requiredDuringSchedulingIgnoredDuringExecution: [requiredDuringSchedulingIgnoredDuringExecution] }),
              // If the anti-affinity requirements specified by this field are not met at scheduling time, the pod will not be scheduled onto the node. If the anti-affinity requirements specified by this field cease to be met at some point during pod execution (e.g. due to a pod label update), the system may or may not try to eventually evict the pod from its node. When there are multiple elements, the lists of nodes corresponding to each podAffinityTerm are intersected, i.e. all terms must be satisfied.
              withRequiredDuringSchedulingIgnoredDuringExecutionMixin(requiredDuringSchedulingIgnoredDuringExecution):: self + if std.type(requiredDuringSchedulingIgnoredDuringExecution) == 'array' then self.mixinInstance({ requiredDuringSchedulingIgnoredDuringExecution+: requiredDuringSchedulingIgnoredDuringExecution }) else self.mixinInstance({ requiredDuringSchedulingIgnoredDuringExecution+: [requiredDuringSchedulingIgnoredDuringExecution] }),
              requiredDuringSchedulingIgnoredDuringExecutionType:: hidden.v1.PodAffinityTerm,
            },
          },
        },
        // Handler defines a specific action that should be taken
        handler:: {
          local kind = { kind: 'Handler' },
          mixin:: {
            // One and only one of the following should be specified. Exec specifies the action to take.
            exec:: {
              local __mixinExec(exec) = { exec+: exec },
              mixinInstance(exec):: __mixinExec(exec),
              // Command is the command line to execute inside the container, the working directory for the command  is root ('/') in the container's filesystem. The command is simply exec'd, it is not run inside a shell, so traditional shell instructions ('|', etc) won't work. To use a shell, you need to explicitly call out to that shell. Exit status of 0 is treated as live/healthy and non-zero is unhealthy.
              withCommand(command):: self + if std.type(command) == 'array' then self.mixinInstance({ command: command }) else self.mixinInstance({ command: [command] }),
              // Command is the command line to execute inside the container, the working directory for the command  is root ('/') in the container's filesystem. The command is simply exec'd, it is not run inside a shell, so traditional shell instructions ('|', etc) won't work. To use a shell, you need to explicitly call out to that shell. Exit status of 0 is treated as live/healthy and non-zero is unhealthy.
              withCommandMixin(command):: self + if std.type(command) == 'array' then self.mixinInstance({ command+: command }) else self.mixinInstance({ command+: [command] }),
            },
            // HTTPGet specifies the http request to perform.
            httpGet:: {
              local __mixinHttpGet(httpGet) = { httpGet+: httpGet },
              mixinInstance(httpGet):: __mixinHttpGet(httpGet),
              // Host name to connect to, defaults to the pod IP. You probably want to set "Host" in httpHeaders instead.
              withHost(host):: self + self.mixinInstance({ host: host }),
              // Custom headers to set in the request. HTTP allows repeated headers.
              withHttpHeaders(httpHeaders):: self + if std.type(httpHeaders) == 'array' then self.mixinInstance({ httpHeaders: httpHeaders }) else self.mixinInstance({ httpHeaders: [httpHeaders] }),
              // Custom headers to set in the request. HTTP allows repeated headers.
              withHttpHeadersMixin(httpHeaders):: self + if std.type(httpHeaders) == 'array' then self.mixinInstance({ httpHeaders+: httpHeaders }) else self.mixinInstance({ httpHeaders+: [httpHeaders] }),
              httpHeadersType:: hidden.v1.HTTPHeader,
              // Path to access on the HTTP server.
              withPath(path):: self + self.mixinInstance({ path: path }),
              // Name or number of the port to access on the container. Number must be in the range 1 to 65535. Name must be an IANA_SVC_NAME.
              withPort(port):: self + self.mixinInstance({ port: port }),
              // Scheme to use for connecting to the host. Defaults to HTTP.
              withScheme(scheme):: self + self.mixinInstance({ scheme: scheme }),
            },
            // TCPSocket specifies an action involving a TCP port. TCP hooks not yet supported
            tcpSocket:: {
              local __mixinTcpSocket(tcpSocket) = { tcpSocket+: tcpSocket },
              mixinInstance(tcpSocket):: __mixinTcpSocket(tcpSocket),
              // Optional: Host name to connect to, defaults to the pod IP.
              withHost(host):: self + self.mixinInstance({ host: host }),
              // Number or name of the port to access on the container. Number must be in the range 1 to 65535. Name must be an IANA_SVC_NAME.
              withPort(port):: self + self.mixinInstance({ port: port }),
            },
          },
        },
        // HostAlias holds the mapping between IP and hostnames that will be injected as an entry in the pod's hosts file.
        hostAlias:: {
          local kind = { kind: 'HostAlias' },
          // Hostnames for the above IP address.
          withHostnames(hostnames):: self + if std.type(hostnames) == 'array' then self.mixinInstance({ hostnames: hostnames }) else self.mixinInstance({ hostnames: [hostnames] }),
          // Hostnames for the above IP address.
          withHostnamesMixin(hostnames):: self + if std.type(hostnames) == 'array' then self.mixinInstance({ hostnames+: hostnames }) else self.mixinInstance({ hostnames+: [hostnames] }),
          // IP address of the host file entry.
          withIp(ip):: self + self.mixinInstance({ ip: ip }),
          mixin:: {},
        },
        // Pod affinity is a group of inter pod affinity scheduling rules.
        podAffinity:: {
          local kind = { kind: 'PodAffinity' },
          // The scheduler will prefer to schedule pods to nodes that satisfy the affinity expressions specified by this field, but it may choose a node that violates one or more of the expressions. The node that is most preferred is the one with the greatest sum of weights, i.e. for each node that meets all of the scheduling requirements (resource request, requiredDuringScheduling affinity expressions, etc.), compute a sum by iterating through the elements of this field and adding "weight" to the sum if the node has pods which matches the corresponding podAffinityTerm; the node(s) with the highest sum are the most preferred.
          withPreferredDuringSchedulingIgnoredDuringExecution(preferredDuringSchedulingIgnoredDuringExecution):: self + if std.type(preferredDuringSchedulingIgnoredDuringExecution) == 'array' then self.mixinInstance({ preferredDuringSchedulingIgnoredDuringExecution: preferredDuringSchedulingIgnoredDuringExecution }) else self.mixinInstance({ preferredDuringSchedulingIgnoredDuringExecution: [preferredDuringSchedulingIgnoredDuringExecution] }),
          // The scheduler will prefer to schedule pods to nodes that satisfy the affinity expressions specified by this field, but it may choose a node that violates one or more of the expressions. The node that is most preferred is the one with the greatest sum of weights, i.e. for each node that meets all of the scheduling requirements (resource request, requiredDuringScheduling affinity expressions, etc.), compute a sum by iterating through the elements of this field and adding "weight" to the sum if the node has pods which matches the corresponding podAffinityTerm; the node(s) with the highest sum are the most preferred.
          withPreferredDuringSchedulingIgnoredDuringExecutionMixin(preferredDuringSchedulingIgnoredDuringExecution):: self + if std.type(preferredDuringSchedulingIgnoredDuringExecution) == 'array' then self.mixinInstance({ preferredDuringSchedulingIgnoredDuringExecution+: preferredDuringSchedulingIgnoredDuringExecution }) else self.mixinInstance({ preferredDuringSchedulingIgnoredDuringExecution+: [preferredDuringSchedulingIgnoredDuringExecution] }),
          preferredDuringSchedulingIgnoredDuringExecutionType:: hidden.v1.WeightedPodAffinityTerm,
          // If the affinity requirements specified by this field are not met at scheduling time, the pod will not be scheduled onto the node. If the affinity requirements specified by this field cease to be met at some point during pod execution (e.g. due to a pod label update), the system may or may not try to eventually evict the pod from its node. When there are multiple elements, the lists of nodes corresponding to each podAffinityTerm are intersected, i.e. all terms must be satisfied.
          withRequiredDuringSchedulingIgnoredDuringExecution(requiredDuringSchedulingIgnoredDuringExecution):: self + if std.type(requiredDuringSchedulingIgnoredDuringExecution) == 'array' then self.mixinInstance({ requiredDuringSchedulingIgnoredDuringExecution: requiredDuringSchedulingIgnoredDuringExecution }) else self.mixinInstance({ requiredDuringSchedulingIgnoredDuringExecution: [requiredDuringSchedulingIgnoredDuringExecution] }),
          // If the affinity requirements specified by this field are not met at scheduling time, the pod will not be scheduled onto the node. If the affinity requirements specified by this field cease to be met at some point during pod execution (e.g. due to a pod label update), the system may or may not try to eventually evict the pod from its node. When there are multiple elements, the lists of nodes corresponding to each podAffinityTerm are intersected, i.e. all terms must be satisfied.
          withRequiredDuringSchedulingIgnoredDuringExecutionMixin(requiredDuringSchedulingIgnoredDuringExecution):: self + if std.type(requiredDuringSchedulingIgnoredDuringExecution) == 'array' then self.mixinInstance({ requiredDuringSchedulingIgnoredDuringExecution+: requiredDuringSchedulingIgnoredDuringExecution }) else self.mixinInstance({ requiredDuringSchedulingIgnoredDuringExecution+: [requiredDuringSchedulingIgnoredDuringExecution] }),
          requiredDuringSchedulingIgnoredDuringExecutionType:: hidden.v1.PodAffinityTerm,
          mixin:: {},
        },
        // Represents a Quobyte mount that lasts the lifetime of a pod. Quobyte volumes do not support ownership management or SELinux relabeling.
        quobyteVolumeSource:: {
          local kind = { kind: 'QuobyteVolumeSource' },
          // Group to map volume access to Default is no group
          withGroup(group):: self + self.mixinInstance({ group: group }),
          // ReadOnly here will force the Quobyte volume to be mounted with read-only permissions. Defaults to false.
          withReadOnly(readOnly):: self + self.mixinInstance({ readOnly: readOnly }),
          // Registry represents a single or multiple Quobyte Registry services specified as a string as host:port pair (multiple entries are separated with commas) which acts as the central registry for volumes
          withRegistry(registry):: self + self.mixinInstance({ registry: registry }),
          // Tenant owning the given Quobyte volume in the Backend Used with dynamically provisioned Quobyte volumes, value is set by the plugin
          withTenant(tenant):: self + self.mixinInstance({ tenant: tenant }),
          // User to map volume access to Defaults to serivceaccount user
          withUser(user):: self + self.mixinInstance({ user: user }),
          // Volume is a string that references an already created Quobyte volume by name.
          withVolume(volume):: self + self.mixinInstance({ volume: volume }),
          mixin:: {},
        },
        // Represents a Rados Block Device mount that lasts the lifetime of a pod. RBD volumes support ownership management and SELinux relabeling.
        rbdVolumeSource:: {
          local kind = { kind: 'RBDVolumeSource' },
          // Filesystem type of the volume that you want to mount. Tip: Ensure that the filesystem type is supported by the host operating system. Examples: "ext4", "xfs", "ntfs". Implicitly inferred to be "ext4" if unspecified. More info: https://kubernetes.io/docs/concepts/storage/volumes#rbd
          withFsType(fsType):: self + self.mixinInstance({ fsType: fsType }),
          // The rados image name. More info: https://examples.k8s.io/volumes/rbd/README.md#how-to-use-it
          withImage(image):: self + self.mixinInstance({ image: image }),
          // Keyring is the path to key ring for RBDUser. Default is /etc/ceph/keyring. More info: https://examples.k8s.io/volumes/rbd/README.md#how-to-use-it
          withKeyring(keyring):: self + self.mixinInstance({ keyring: keyring }),
          // A collection of Ceph monitors. More info: https://examples.k8s.io/volumes/rbd/README.md#how-to-use-it
          withMonitors(monitors):: self + if std.type(monitors) == 'array' then self.mixinInstance({ monitors: monitors }) else self.mixinInstance({ monitors: [monitors] }),
          // A collection of Ceph monitors. More info: https://examples.k8s.io/volumes/rbd/README.md#how-to-use-it
          withMonitorsMixin(monitors):: self + if std.type(monitors) == 'array' then self.mixinInstance({ monitors+: monitors }) else self.mixinInstance({ monitors+: [monitors] }),
          // The rados pool name. Default is rbd. More info: https://examples.k8s.io/volumes/rbd/README.md#how-to-use-it
          withPool(pool):: self + self.mixinInstance({ pool: pool }),
          // ReadOnly here will force the ReadOnly setting in VolumeMounts. Defaults to false. More info: https://examples.k8s.io/volumes/rbd/README.md#how-to-use-it
          withReadOnly(readOnly):: self + self.mixinInstance({ readOnly: readOnly }),
          // The rados user name. Default is admin. More info: https://examples.k8s.io/volumes/rbd/README.md#how-to-use-it
          withUser(user):: self + self.mixinInstance({ user: user }),
          mixin:: {
            // SecretRef is name of the authentication secret for RBDUser. If provided overrides keyring. Default is nil. More info: https://examples.k8s.io/volumes/rbd/README.md#how-to-use-it
            secretRef:: {
              local __mixinSecretRef(secretRef) = { secretRef+: secretRef },
              mixinInstance(secretRef):: __mixinSecretRef(secretRef),
              // Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
              withName(name):: self + self.mixinInstance({ name: name }),
            },
          },
        },
        // Sysctl defines a kernel parameter to be set
        sysctl:: {
          local kind = { kind: 'Sysctl' },
          // Name of a property to set
          withName(name):: self + self.mixinInstance({ name: name }),
          // Value of a property to set
          withValue(value):: self + self.mixinInstance({ value: value }),
          mixin:: {},
        },
        // DownwardAPIVolumeSource represents a volume containing downward API info. Downward API volumes support ownership management and SELinux relabeling.
        downwardAPIVolumeSource:: {
          local kind = { kind: 'DownwardAPIVolumeSource' },
          // Optional: mode bits to use on created files by default. Must be a value between 0 and 0777. Defaults to 0644. Directories within the path are not affected by this setting. This might be in conflict with other options that affect the file mode, like fsGroup, and the result can be other mode bits set.
          withDefaultMode(defaultMode):: self + self.mixinInstance({ defaultMode: defaultMode }),
          // Items is a list of downward API volume file
          withItems(items):: self + if std.type(items) == 'array' then self.mixinInstance({ items: items }) else self.mixinInstance({ items: [items] }),
          // Items is a list of downward API volume file
          withItemsMixin(items):: self + if std.type(items) == 'array' then self.mixinInstance({ items+: items }) else self.mixinInstance({ items+: [items] }),
          itemsType:: hidden.v1.DownwardAPIVolumeFile,
          mixin:: {},
        },
      },
      resource:: {
        local apiVersion = { apiVersion: 'resource' },
        // Quantity is a fixed-point representation of a number. It provides convenient marshaling/unmarshaling in JSON and YAML, in addition to String() and AsInt64() accessors.
        //
        // The serialization format is:
        //
        // <quantity>        ::= <signedNumber><suffix>
        // (Note that <suffix> may be empty, from the "" case in <decimalSI>.)
        // <digit>           ::= 0 | 1 | ... | 9 <digits>          ::= <digit> | <digit><digits> <number>          ::= <digits> | <digits>.<digits> | <digits>. | .<digits> <sign>            ::= "+" | "-" <signedNumber>    ::= <number> | <sign><number> <suffix>          ::= <binarySI> | <decimalExponent> | <decimalSI> <binarySI>        ::= Ki | Mi | Gi | Ti | Pi | Ei
        // (International System of units; See: http://physics.nist.gov/cuu/Units/binary.html)
        // <decimalSI>       ::= m | "" | k | M | G | T | P | E
        // (Note that 1024 = 1Ki but 1000 = 1k; I didn't choose the capitalization.)
        // <decimalExponent> ::= "e" <signedNumber> | "E" <signedNumber>
        //
        // No matter which of the three exponent forms is used, no quantity may represent a number greater than 2^63-1 in magnitude, nor may it have more than 3 decimal places. Numbers larger or more precise will be capped or rounded up. (E.g.: 0.1m will rounded up to 1m.) This may be extended in the future if we require larger or smaller quantities.
        //
        // When a Quantity is parsed from a string, it will remember the type of suffix it had, and will use the same type again when it is serialized.
        //
        // Before serializing, Quantity will be put in "canonical form". This means that Exponent/suffix will be adjusted up or down (with a corresponding increase or decrease in Mantissa) such that:
        // a. No precision is lost
        // b. No fractional digits will be emitted
        // c. The exponent (or suffix) is as large as possible.
        // The sign will be omitted unless the number is negative.
        //
        // Examples:
        // 1.5 will be serialized as "1500m"
        // 1.5Gi will be serialized as "1536Mi"
        //
        // Note that the quantity will NEVER be internally represented by a floating point number. That is the whole point of this exercise.
        //
        // Non-canonical values will still parse as long as they are well formed, but will be re-emitted in their canonical form. (So always use canonical form, or don't diff.)
        //
        // This format is intended to make it difficult to use these numbers without writing some sort of special handling code in the hopes that that will cause implementors to also use a fixed point implementation.
        quantity:: {},
      },
      intstr:: {
        local apiVersion = { apiVersion: 'intstr' },
        // IntOrString is a type that can hold an int32 or a string.  When used in JSON or YAML marshalling and unmarshalling, it produces or consumes the inner type.  This allows you to have, for example, a JSON field that can accept a name or number.
        intOrString:: {},
      },
    },
    meta:: {
      v1:: {
        local apiVersion = { apiVersion: 'meta/v1' },
        // OwnerReference contains enough information to let you identify an owning object. An owning object must be in the same namespace as the dependent, or be cluster-scoped, so there is no namespace field.
        ownerReference:: {
          local kind = { kind: 'OwnerReference' },
          // If true, AND if the owner has the "foregroundDeletion" finalizer, then the owner cannot be deleted from the key-value store until this reference is removed. Defaults to false. To set this field, a user needs "delete" permission of the owner, otherwise 422 (Unprocessable Entity) will be returned.
          withBlockOwnerDeletion(blockOwnerDeletion):: self + self.mixinInstance({ blockOwnerDeletion: blockOwnerDeletion }),
          // If true, this reference points to the managing controller.
          withController(controller):: self + self.mixinInstance({ controller: controller }),
          // Name of the referent. More info: http://kubernetes.io/docs/user-guide/identifiers#names
          withName(name):: self + self.mixinInstance({ name: name }),
          // UID of the referent. More info: http://kubernetes.io/docs/user-guide/identifiers#uids
          withUid(uid):: self + self.mixinInstance({ uid: uid }),
          mixin:: {},
        },
        // Time is a wrapper around time.Time which supports correct marshaling to YAML and JSON.  Wrappers are provided for many of the factory methods that the time package offers.
        time:: {},
        // FieldsV1 stores a set of fields in a data structure like a Trie, in JSON format.
        //
        // Each key is either a '.' representing the field itself, and will always map to an empty set, or a string representing a sub-field or item. The string will follow one of these four formats: 'f:<name>', where <name> is the name of a field in a struct, or key in a map 'v:<value>', where <value> is the exact json formatted value of a list item 'i:<index>', where <index> is position of a item in a list 'k:<keys>', where <keys> is a map of  a list item's key fields to their unique values If a key maps to an empty Fields value, the field that key represents is part of the set.
        //
        // The exact format is defined in sigs.k8s.io/structured-merge-diff
        fieldsV1:: {},
        // A label selector is a label query over a set of resources. The result of matchLabels and matchExpressions are ANDed. An empty label selector matches all objects. A null label selector matches no objects.
        labelSelector:: {
          local kind = { kind: 'LabelSelector' },
          // matchExpressions is a list of label selector requirements. The requirements are ANDed.
          withMatchExpressions(matchExpressions):: self + if std.type(matchExpressions) == 'array' then self.mixinInstance({ matchExpressions: matchExpressions }) else self.mixinInstance({ matchExpressions: [matchExpressions] }),
          // matchExpressions is a list of label selector requirements. The requirements are ANDed.
          withMatchExpressionsMixin(matchExpressions):: self + if std.type(matchExpressions) == 'array' then self.mixinInstance({ matchExpressions+: matchExpressions }) else self.mixinInstance({ matchExpressions+: [matchExpressions] }),
          matchExpressionsType:: hidden.meta.v1.LabelSelectorRequirement,
          // matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels map is equivalent to an element of matchExpressions, whose key field is "key", the operator is "In", and the values array contains only "value". The requirements are ANDed.
          withMatchLabels(matchLabels):: self + self.mixinInstance({ matchLabels: matchLabels }),
          mixin:: {},
        },
        // A label selector requirement is a selector that contains values, a key, and an operator that relates the key and values.
        labelSelectorRequirement:: {
          local kind = { kind: 'LabelSelectorRequirement' },
          // key is the label key that the selector applies to.
          withKey(key):: self + self.mixinInstance({ key: key }),
          // operator represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists and DoesNotExist.
          withOperator(operator):: self + self.mixinInstance({ operator: operator }),
          // values is an array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. This array is replaced during a strategic merge patch.
          withValues(values):: self + if std.type(values) == 'array' then self.mixinInstance({ values: values }) else self.mixinInstance({ values: [values] }),
          // values is an array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. This array is replaced during a strategic merge patch.
          withValuesMixin(values):: self + if std.type(values) == 'array' then self.mixinInstance({ values+: values }) else self.mixinInstance({ values+: [values] }),
          mixin:: {},
        },
        // ManagedFieldsEntry is a workflow-id, a FieldSet and the group version of the resource that the fieldset applies to.
        managedFieldsEntry:: {
          local kind = { kind: 'ManagedFieldsEntry' },
          // FieldsType is the discriminator for the different fields format and version. There is currently only one possible value: "FieldsV1"
          withFieldsType(fieldsType):: self + self.mixinInstance({ fieldsType: fieldsType }),
          // Manager is an identifier of the workflow managing these fields.
          withManager(manager):: self + self.mixinInstance({ manager: manager }),
          // Operation is the type of operation which lead to this ManagedFieldsEntry being created. The only valid values for this field are 'Apply' and 'Update'.
          withOperation(operation):: self + self.mixinInstance({ operation: operation }),
          mixin:: {
            // FieldsV1 holds the first JSON version format as described in the "FieldsV1" type.
            withFieldsV1(fieldsV1):: self + self.mixinInstance({ fieldsV1: fieldsV1 }),
            // Time is timestamp of when these fields were set. It should always be empty if Operation is 'Apply'
            withTime(time):: self + self.mixinInstance({ time: time }),
          },
        },
        // ObjectMeta is metadata that all persisted resources must have, which includes all objects users must create.
        objectMeta:: {
          local kind = { kind: 'ObjectMeta' },
          // Annotations is an unstructured key value map stored with a resource that may be set by external tools to store and retrieve arbitrary metadata. They are not queryable and should be preserved when modifying objects. More info: http://kubernetes.io/docs/user-guide/annotations
          withAnnotations(annotations):: self + self.mixinInstance({ annotations: annotations }),
          // The name of the cluster which the object belongs to. This is used to distinguish resources with same name and namespace in different clusters. This field is not set anywhere right now and apiserver is going to ignore it if set in create or update request.
          withClusterName(clusterName):: self + self.mixinInstance({ clusterName: clusterName }),
          // Number of seconds allowed for this object to gracefully terminate before it will be removed from the system. Only set when deletionTimestamp is also set. May only be shortened. Read-only.
          withDeletionGracePeriodSeconds(deletionGracePeriodSeconds):: self + self.mixinInstance({ deletionGracePeriodSeconds: deletionGracePeriodSeconds }),
          // Must be empty before the object is deleted from the registry. Each entry is an identifier for the responsible component that will remove the entry from the list. If the deletionTimestamp of the object is non-nil, entries in this list can only be removed. Finalizers may be processed and removed in any order.  Order is NOT enforced because it introduces significant risk of stuck finalizers. finalizers is a shared field, any actor with permission can reorder it. If the finalizer list is processed in order, then this can lead to a situation in which the component responsible for the first finalizer in the list is waiting for a signal (field value, external system, or other) produced by a component responsible for a finalizer later in the list, resulting in a deadlock. Without enforced ordering finalizers are free to order amongst themselves and are not vulnerable to ordering changes in the list.
          withFinalizers(finalizers):: self + if std.type(finalizers) == 'array' then self.mixinInstance({ finalizers: finalizers }) else self.mixinInstance({ finalizers: [finalizers] }),
          // Must be empty before the object is deleted from the registry. Each entry is an identifier for the responsible component that will remove the entry from the list. If the deletionTimestamp of the object is non-nil, entries in this list can only be removed. Finalizers may be processed and removed in any order.  Order is NOT enforced because it introduces significant risk of stuck finalizers. finalizers is a shared field, any actor with permission can reorder it. If the finalizer list is processed in order, then this can lead to a situation in which the component responsible for the first finalizer in the list is waiting for a signal (field value, external system, or other) produced by a component responsible for a finalizer later in the list, resulting in a deadlock. Without enforced ordering finalizers are free to order amongst themselves and are not vulnerable to ordering changes in the list.
          withFinalizersMixin(finalizers):: self + if std.type(finalizers) == 'array' then self.mixinInstance({ finalizers+: finalizers }) else self.mixinInstance({ finalizers+: [finalizers] }),
          // GenerateName is an optional prefix, used by the server, to generate a unique name ONLY IF the Name field has not been provided. If this field is used, the name returned to the client will be different than the name passed. This value will also be combined with a unique suffix. The provided value has the same validation rules as the Name field, and may be truncated by the length of the suffix required to make the value unique on the server.
          //
          // If this field is specified and the generated name exists, the server will NOT return a 409 - instead, it will either return 201 Created or 500 with Reason ServerTimeout indicating a unique name could not be found in the time allotted, and the client should retry (optionally after the time indicated in the Retry-After header).
          //
          // Applied only if Name is not specified. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#idempotency
          withGenerateName(generateName):: self + self.mixinInstance({ generateName: generateName }),
          // A sequence number representing a specific generation of the desired state. Populated by the system. Read-only.
          withGeneration(generation):: self + self.mixinInstance({ generation: generation }),
          // Map of string keys and values that can be used to organize and categorize (scope and select) objects. May match selectors of replication controllers and services. More info: http://kubernetes.io/docs/user-guide/labels
          withLabels(labels):: self + self.mixinInstance({ labels: labels }),
          // ManagedFields maps workflow-id and version to the set of fields that are managed by that workflow. This is mostly for internal housekeeping, and users typically shouldn't need to set or understand this field. A workflow can be the user's name, a controller's name, or the name of a specific apply path like "ci-cd". The set of fields is always in the version that the workflow used when modifying the object.
          withManagedFields(managedFields):: self + if std.type(managedFields) == 'array' then self.mixinInstance({ managedFields: managedFields }) else self.mixinInstance({ managedFields: [managedFields] }),
          // ManagedFields maps workflow-id and version to the set of fields that are managed by that workflow. This is mostly for internal housekeeping, and users typically shouldn't need to set or understand this field. A workflow can be the user's name, a controller's name, or the name of a specific apply path like "ci-cd". The set of fields is always in the version that the workflow used when modifying the object.
          withManagedFieldsMixin(managedFields):: self + if std.type(managedFields) == 'array' then self.mixinInstance({ managedFields+: managedFields }) else self.mixinInstance({ managedFields+: [managedFields] }),
          managedFieldsType:: hidden.meta.v1.ManagedFieldsEntry,
          // Name must be unique within a namespace. Is required when creating resources, although some resources may allow a client to request the generation of an appropriate name automatically. Name is primarily intended for creation idempotence and configuration definition. Cannot be updated. More info: http://kubernetes.io/docs/user-guide/identifiers#names
          withName(name):: self + self.mixinInstance({ name: name }),
          // Namespace defines the space within each name must be unique. An empty namespace is equivalent to the "default" namespace, but "default" is the canonical representation. Not all objects are required to be scoped to a namespace - the value of this field for those objects will be empty.
          //
          // Must be a DNS_LABEL. Cannot be updated. More info: http://kubernetes.io/docs/user-guide/namespaces
          withNamespace(namespace):: self + self.mixinInstance({ namespace: namespace }),
          // List of objects depended by this object. If ALL objects in the list have been deleted, this object will be garbage collected. If this object is managed by a controller, then an entry in this list will point to this controller, with the controller field set to true. There cannot be more than one managing controller.
          withOwnerReferences(ownerReferences):: self + if std.type(ownerReferences) == 'array' then self.mixinInstance({ ownerReferences: ownerReferences }) else self.mixinInstance({ ownerReferences: [ownerReferences] }),
          // List of objects depended by this object. If ALL objects in the list have been deleted, this object will be garbage collected. If this object is managed by a controller, then an entry in this list will point to this controller, with the controller field set to true. There cannot be more than one managing controller.
          withOwnerReferencesMixin(ownerReferences):: self + if std.type(ownerReferences) == 'array' then self.mixinInstance({ ownerReferences+: ownerReferences }) else self.mixinInstance({ ownerReferences+: [ownerReferences] }),
          ownerReferencesType:: hidden.meta.v1.OwnerReference,
          // An opaque value that represents the internal version of this object that can be used by clients to determine when objects have changed. May be used for optimistic concurrency, change detection, and the watch operation on a resource or set of resources. Clients must treat these values as opaque and passed unmodified back to the server. They may only be valid for a particular resource or set of resources.
          //
          // Populated by the system. Read-only. Value must be treated as opaque by clients and . More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#concurrency-control-and-consistency
          withResourceVersion(resourceVersion):: self + self.mixinInstance({ resourceVersion: resourceVersion }),
          // SelfLink is a URL representing this object. Populated by the system. Read-only.
          //
          // DEPRECATED Kubernetes will stop propagating this field in 1.20 release and the field is planned to be removed in 1.21 release.
          withSelfLink(selfLink):: self + self.mixinInstance({ selfLink: selfLink }),
          // UID is the unique in time and space value for this object. It is typically generated by the server on successful creation of a resource and is not allowed to change on PUT operations.
          //
          // Populated by the system. Read-only. More info: http://kubernetes.io/docs/user-guide/identifiers#uids
          withUid(uid):: self + self.mixinInstance({ uid: uid }),
          mixin:: {
            // CreationTimestamp is a timestamp representing the server time when this object was created. It is not guaranteed to be set in happens-before order across separate operations. Clients may not set this value. It is represented in RFC3339 form and is in UTC.
            //
            // Populated by the system. Read-only. Null for lists. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata
            withCreationTimestamp(creationTimestamp):: self + self.mixinInstance({ creationTimestamp: creationTimestamp }),
            // DeletionTimestamp is RFC 3339 date and time at which this resource will be deleted. This field is set by the server when a graceful deletion is requested by the user, and is not directly settable by a client. The resource is expected to be deleted (no longer visible from resource lists, and not reachable by name) after the time in this field, once the finalizers list is empty. As long as the finalizers list contains items, deletion is blocked. Once the deletionTimestamp is set, this value may not be unset or be set further into the future, although it may be shortened or the resource may be deleted prior to this time. For example, a user may request that a pod is deleted in 30 seconds. The Kubelet will react by sending a graceful termination signal to the containers in the pod. After that 30 seconds, the Kubelet will send a hard termination signal (SIGKILL) to the container and after cleanup, remove the pod from the API. In the presence of network partitions, this object may still exist after this timestamp, until an administrator or automated process can determine the resource is fully terminated. If not set, graceful deletion of the object has not been requested.
            //
            // Populated by the system when a graceful deletion is requested. Read-only. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata
            withDeletionTimestamp(deletionTimestamp):: self + self.mixinInstance({ deletionTimestamp: deletionTimestamp }),
          },
        },
      },
    },
  },
}
