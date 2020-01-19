package ksonnet

import (
	"bytes"
	"fmt"
	"os"

	"github.com/go-openapi/spec"

	"github.com/ksonnet/ksonnet-lib/ksonnet-gen/ksonnet/transpiler"
	"github.com/ksonnet/ksonnet-lib/ksonnet-gen/printer"
)

var whitelist = []string{
	"io.k8s.api.admissionregistration.v1.MutatingWebhook",
	"io.k8s.api.admissionregistration.v1.MutatingWebhookConfiguration",
	"io.k8s.api.admissionregistration.v1.MutatingWebhookConfigurationList",
	"io.k8s.api.admissionregistration.v1.RuleWithOperations",
	"io.k8s.api.admissionregistration.v1.ServiceReference",
	"io.k8s.api.admissionregistration.v1.ValidatingWebhook",
	"io.k8s.api.admissionregistration.v1.ValidatingWebhookConfiguration",
	"io.k8s.api.admissionregistration.v1.ValidatingWebhookConfigurationList",
	"io.k8s.api.admissionregistration.v1.WebhookClientConfig",
	"io.k8s.api.admissionregistration.v1beta1.MutatingWebhook",
	"io.k8s.api.admissionregistration.v1beta1.MutatingWebhookConfiguration",
	"io.k8s.api.admissionregistration.v1beta1.MutatingWebhookConfigurationList",
	"io.k8s.api.admissionregistration.v1beta1.RuleWithOperations",
	"io.k8s.api.admissionregistration.v1beta1.ServiceReference",
	"io.k8s.api.admissionregistration.v1beta1.ValidatingWebhook",
	"io.k8s.api.admissionregistration.v1beta1.ValidatingWebhookConfiguration",
	"io.k8s.api.admissionregistration.v1beta1.ValidatingWebhookConfigurationList",
	"io.k8s.api.admissionregistration.v1beta1.WebhookClientConfig",
	"io.k8s.api.apps.v1.ControllerRevision",
	"io.k8s.api.apps.v1.ControllerRevisionList",
	"io.k8s.api.apps.v1.DaemonSet",
	"io.k8s.api.apps.v1.DaemonSetCondition",
	"io.k8s.api.apps.v1.DaemonSetList",
	"io.k8s.api.apps.v1.DaemonSetSpec",
	"io.k8s.api.apps.v1.DaemonSetStatus",
	"io.k8s.api.apps.v1.DaemonSetUpdateStrategy",
	"io.k8s.api.apps.v1.Deployment",
	"io.k8s.api.apps.v1.DeploymentCondition",
	"io.k8s.api.apps.v1.DeploymentList",
	"io.k8s.api.apps.v1.DeploymentSpec",
	"io.k8s.api.apps.v1.DeploymentStatus",
	"io.k8s.api.apps.v1.DeploymentStrategy",
	"io.k8s.api.apps.v1.ReplicaSet",
	"io.k8s.api.apps.v1.ReplicaSetCondition",
	"io.k8s.api.apps.v1.ReplicaSetList",
	"io.k8s.api.apps.v1.ReplicaSetSpec",
	"io.k8s.api.apps.v1.ReplicaSetStatus",
	"io.k8s.api.apps.v1.RollingUpdateDaemonSet",
	"io.k8s.api.apps.v1.RollingUpdateDeployment",
	"io.k8s.api.apps.v1.RollingUpdateStatefulSetStrategy",
	"io.k8s.api.apps.v1.StatefulSet",
	"io.k8s.api.apps.v1.StatefulSetCondition",
	"io.k8s.api.apps.v1.StatefulSetList",
	"io.k8s.api.apps.v1.StatefulSetSpec",
	"io.k8s.api.apps.v1.StatefulSetStatus",
	"io.k8s.api.apps.v1.StatefulSetUpdateStrategy",
	"io.k8s.api.apps.v1beta1.ControllerRevision",
	"io.k8s.api.apps.v1beta1.ControllerRevisionList",
	"io.k8s.api.apps.v1beta1.Deployment",
	"io.k8s.api.apps.v1beta1.DeploymentCondition",
	"io.k8s.api.apps.v1beta1.DeploymentList",
	"io.k8s.api.apps.v1beta1.DeploymentRollback",
	"io.k8s.api.apps.v1beta1.DeploymentSpec",
	"io.k8s.api.apps.v1beta1.DeploymentStatus",
	"io.k8s.api.apps.v1beta1.DeploymentStrategy",
	"io.k8s.api.apps.v1beta1.RollbackConfig",
	"io.k8s.api.apps.v1beta1.RollingUpdateDeployment",
	"io.k8s.api.apps.v1beta1.RollingUpdateStatefulSetStrategy",
	"io.k8s.api.apps.v1beta1.Scale",
	"io.k8s.api.apps.v1beta1.ScaleSpec",
	"io.k8s.api.apps.v1beta1.ScaleStatus",
	"io.k8s.api.apps.v1beta1.StatefulSet",
	"io.k8s.api.apps.v1beta1.StatefulSetCondition",
	"io.k8s.api.apps.v1beta1.StatefulSetList",
	"io.k8s.api.apps.v1beta1.StatefulSetSpec",
	"io.k8s.api.apps.v1beta1.StatefulSetStatus",
	"io.k8s.api.apps.v1beta1.StatefulSetUpdateStrategy",
	"io.k8s.api.apps.v1beta2.ControllerRevision",
	"io.k8s.api.apps.v1beta2.ControllerRevisionList",
	"io.k8s.api.apps.v1beta2.DaemonSet",
	"io.k8s.api.apps.v1beta2.DaemonSetCondition",
	"io.k8s.api.apps.v1beta2.DaemonSetList",
	"io.k8s.api.apps.v1beta2.DaemonSetSpec",
	"io.k8s.api.apps.v1beta2.DaemonSetStatus",
	"io.k8s.api.apps.v1beta2.DaemonSetUpdateStrategy",
	"io.k8s.api.apps.v1beta2.Deployment",
	"io.k8s.api.apps.v1beta2.DeploymentCondition",
	"io.k8s.api.apps.v1beta2.DeploymentList",
	"io.k8s.api.apps.v1beta2.DeploymentSpec",
	"io.k8s.api.apps.v1beta2.DeploymentStatus",
	"io.k8s.api.apps.v1beta2.DeploymentStrategy",
	"io.k8s.api.apps.v1beta2.ReplicaSet",
	"io.k8s.api.apps.v1beta2.ReplicaSetCondition",
	"io.k8s.api.apps.v1beta2.ReplicaSetList",
	"io.k8s.api.apps.v1beta2.ReplicaSetSpec",
	"io.k8s.api.apps.v1beta2.ReplicaSetStatus",
	"io.k8s.api.apps.v1beta2.RollingUpdateDaemonSet",
	"io.k8s.api.apps.v1beta2.RollingUpdateDeployment",
	"io.k8s.api.apps.v1beta2.RollingUpdateStatefulSetStrategy",
	"io.k8s.api.apps.v1beta2.Scale",
	"io.k8s.api.apps.v1beta2.ScaleSpec",
	"io.k8s.api.apps.v1beta2.ScaleStatus",
	"io.k8s.api.apps.v1beta2.StatefulSet",
	"io.k8s.api.apps.v1beta2.StatefulSetCondition",
	"io.k8s.api.apps.v1beta2.StatefulSetList",
	"io.k8s.api.apps.v1beta2.StatefulSetSpec",
	"io.k8s.api.apps.v1beta2.StatefulSetStatus",
	"io.k8s.api.apps.v1beta2.StatefulSetUpdateStrategy",
	"io.k8s.api.auditregistration.v1alpha1.AuditSink",
	"io.k8s.api.auditregistration.v1alpha1.AuditSinkList",
	"io.k8s.api.auditregistration.v1alpha1.AuditSinkSpec",
	"io.k8s.api.auditregistration.v1alpha1.Policy",
	"io.k8s.api.auditregistration.v1alpha1.ServiceReference",
	"io.k8s.api.auditregistration.v1alpha1.Webhook",
	"io.k8s.api.auditregistration.v1alpha1.WebhookClientConfig",
	"io.k8s.api.auditregistration.v1alpha1.WebhookThrottleConfig",
	"io.k8s.api.authentication.v1.BoundObjectReference",
	"io.k8s.api.authentication.v1.TokenRequest",
	"io.k8s.api.authentication.v1.TokenRequestSpec",
	"io.k8s.api.authentication.v1.TokenRequestStatus",
	"io.k8s.api.authentication.v1.TokenReview",
	"io.k8s.api.authentication.v1.TokenReviewSpec",
	"io.k8s.api.authentication.v1.TokenReviewStatus",
	"io.k8s.api.authentication.v1.UserInfo",
	"io.k8s.api.authentication.v1beta1.TokenReview",
	"io.k8s.api.authentication.v1beta1.TokenReviewSpec",
	"io.k8s.api.authentication.v1beta1.TokenReviewStatus",
	"io.k8s.api.authentication.v1beta1.UserInfo",
	"io.k8s.api.authorization.v1.LocalSubjectAccessReview",
	"io.k8s.api.authorization.v1.NonResourceAttributes",
	"io.k8s.api.authorization.v1.NonResourceRule",
	"io.k8s.api.authorization.v1.ResourceAttributes",
	"io.k8s.api.authorization.v1.ResourceRule",
	"io.k8s.api.authorization.v1.SelfSubjectAccessReview",
	"io.k8s.api.authorization.v1.SelfSubjectAccessReviewSpec",
	"io.k8s.api.authorization.v1.SelfSubjectRulesReview",
	"io.k8s.api.authorization.v1.SelfSubjectRulesReviewSpec",
	"io.k8s.api.authorization.v1.SubjectAccessReview",
	"io.k8s.api.authorization.v1.SubjectAccessReviewSpec",
	"io.k8s.api.authorization.v1.SubjectAccessReviewStatus",
	"io.k8s.api.authorization.v1.SubjectRulesReviewStatus",
	"io.k8s.api.authorization.v1beta1.LocalSubjectAccessReview",
	"io.k8s.api.authorization.v1beta1.NonResourceAttributes",
	"io.k8s.api.authorization.v1beta1.NonResourceRule",
	"io.k8s.api.authorization.v1beta1.ResourceAttributes",
	"io.k8s.api.authorization.v1beta1.ResourceRule",
	"io.k8s.api.authorization.v1beta1.SelfSubjectAccessReview",
	"io.k8s.api.authorization.v1beta1.SelfSubjectAccessReviewSpec",
	"io.k8s.api.authorization.v1beta1.SelfSubjectRulesReview",
	"io.k8s.api.authorization.v1beta1.SelfSubjectRulesReviewSpec",
	"io.k8s.api.authorization.v1beta1.SubjectAccessReview",
	"io.k8s.api.authorization.v1beta1.SubjectAccessReviewSpec",
	"io.k8s.api.authorization.v1beta1.SubjectAccessReviewStatus",
	"io.k8s.api.authorization.v1beta1.SubjectRulesReviewStatus",
	"io.k8s.api.autoscaling.v1.CrossVersionObjectReference",
	"io.k8s.api.autoscaling.v1.HorizontalPodAutoscaler",
	"io.k8s.api.autoscaling.v1.HorizontalPodAutoscalerList",
	"io.k8s.api.autoscaling.v1.HorizontalPodAutoscalerSpec",
	"io.k8s.api.autoscaling.v1.HorizontalPodAutoscalerStatus",
	"io.k8s.api.autoscaling.v1.Scale",
	"io.k8s.api.autoscaling.v1.ScaleSpec",
	"io.k8s.api.autoscaling.v1.ScaleStatus",
	"io.k8s.api.autoscaling.v2beta1.CrossVersionObjectReference",
	"io.k8s.api.autoscaling.v2beta1.ExternalMetricSource",
	"io.k8s.api.autoscaling.v2beta1.ExternalMetricStatus",
	"io.k8s.api.autoscaling.v2beta1.HorizontalPodAutoscaler",
	"io.k8s.api.autoscaling.v2beta1.HorizontalPodAutoscalerCondition",
	"io.k8s.api.autoscaling.v2beta1.HorizontalPodAutoscalerList",
	"io.k8s.api.autoscaling.v2beta1.HorizontalPodAutoscalerSpec",
	"io.k8s.api.autoscaling.v2beta1.HorizontalPodAutoscalerStatus",
	"io.k8s.api.autoscaling.v2beta1.MetricSpec",
	"io.k8s.api.autoscaling.v2beta1.MetricStatus",
	"io.k8s.api.autoscaling.v2beta1.ObjectMetricSource",
	"io.k8s.api.autoscaling.v2beta1.ObjectMetricStatus",
	"io.k8s.api.autoscaling.v2beta1.PodsMetricSource",
	"io.k8s.api.autoscaling.v2beta1.PodsMetricStatus",
	"io.k8s.api.autoscaling.v2beta1.ResourceMetricSource",
	"io.k8s.api.autoscaling.v2beta1.ResourceMetricStatus",
	"io.k8s.api.autoscaling.v2beta2.CrossVersionObjectReference",
	"io.k8s.api.autoscaling.v2beta2.ExternalMetricSource",
	"io.k8s.api.autoscaling.v2beta2.ExternalMetricStatus",
	"io.k8s.api.autoscaling.v2beta2.HorizontalPodAutoscaler",
	"io.k8s.api.autoscaling.v2beta2.HorizontalPodAutoscalerCondition",
	"io.k8s.api.autoscaling.v2beta2.HorizontalPodAutoscalerList",
	"io.k8s.api.autoscaling.v2beta2.HorizontalPodAutoscalerSpec",
	"io.k8s.api.autoscaling.v2beta2.HorizontalPodAutoscalerStatus",
	"io.k8s.api.autoscaling.v2beta2.MetricIdentifier",
	"io.k8s.api.autoscaling.v2beta2.MetricSpec",
	"io.k8s.api.autoscaling.v2beta2.MetricStatus",
	"io.k8s.api.autoscaling.v2beta2.MetricTarget",
	"io.k8s.api.autoscaling.v2beta2.MetricValueStatus",
	"io.k8s.api.autoscaling.v2beta2.ObjectMetricSource",
	"io.k8s.api.autoscaling.v2beta2.ObjectMetricStatus",
	"io.k8s.api.autoscaling.v2beta2.PodsMetricSource",
	"io.k8s.api.autoscaling.v2beta2.PodsMetricStatus",
	"io.k8s.api.autoscaling.v2beta2.ResourceMetricSource",
	"io.k8s.api.autoscaling.v2beta2.ResourceMetricStatus",
	"io.k8s.api.batch.v1.Job",
	"io.k8s.api.batch.v1.JobCondition",
	"io.k8s.api.batch.v1.JobList",
	"io.k8s.api.batch.v1.JobSpec",
	"io.k8s.api.batch.v1.JobStatus",
	"io.k8s.api.batch.v1beta1.CronJob",
	"io.k8s.api.batch.v1beta1.CronJobList",
	"io.k8s.api.batch.v1beta1.CronJobSpec",
	"io.k8s.api.batch.v1beta1.CronJobStatus",
	"io.k8s.api.batch.v1beta1.JobTemplateSpec",
	"io.k8s.api.batch.v2alpha1.CronJob",
	"io.k8s.api.batch.v2alpha1.CronJobList",
	"io.k8s.api.batch.v2alpha1.CronJobSpec",
	"io.k8s.api.batch.v2alpha1.CronJobStatus",
	"io.k8s.api.batch.v2alpha1.JobTemplateSpec",
	"io.k8s.api.certificates.v1beta1.CertificateSigningRequest",
	"io.k8s.api.certificates.v1beta1.CertificateSigningRequestCondition",
	"io.k8s.api.certificates.v1beta1.CertificateSigningRequestList",
	"io.k8s.api.certificates.v1beta1.CertificateSigningRequestSpec",
	"io.k8s.api.certificates.v1beta1.CertificateSigningRequestStatus",
	"io.k8s.api.coordination.v1.Lease",
	"io.k8s.api.coordination.v1.LeaseList",
	"io.k8s.api.coordination.v1.LeaseSpec",
	"io.k8s.api.coordination.v1beta1.Lease",
	"io.k8s.api.coordination.v1beta1.LeaseList",
	"io.k8s.api.coordination.v1beta1.LeaseSpec",
	"io.k8s.api.core.v1.AWSElasticBlockStoreVolumeSource",
	"io.k8s.api.core.v1.Affinity",
	"io.k8s.api.core.v1.AttachedVolume",
	"io.k8s.api.core.v1.AzureDiskVolumeSource",
	"io.k8s.api.core.v1.AzureFilePersistentVolumeSource",
	"io.k8s.api.core.v1.AzureFileVolumeSource",
	"io.k8s.api.core.v1.Binding",
	"io.k8s.api.core.v1.CSIPersistentVolumeSource",
	"io.k8s.api.core.v1.CSIVolumeSource",
	"io.k8s.api.core.v1.Capabilities",
	"io.k8s.api.core.v1.CephFSPersistentVolumeSource",
	"io.k8s.api.core.v1.CephFSVolumeSource",
	"io.k8s.api.core.v1.CinderPersistentVolumeSource",
	"io.k8s.api.core.v1.CinderVolumeSource",
	"io.k8s.api.core.v1.ClientIPConfig",
	"io.k8s.api.core.v1.ComponentCondition",
	"io.k8s.api.core.v1.ComponentStatus",
	"io.k8s.api.core.v1.ComponentStatusList",
	"io.k8s.api.core.v1.ConfigMap",
	"io.k8s.api.core.v1.ConfigMapEnvSource",
	"io.k8s.api.core.v1.ConfigMapKeySelector",
	"io.k8s.api.core.v1.ConfigMapList",
	"io.k8s.api.core.v1.ConfigMapNodeConfigSource",
	"io.k8s.api.core.v1.ConfigMapProjection",
	"io.k8s.api.core.v1.ConfigMapVolumeSource",
	"io.k8s.api.core.v1.Container",
	"io.k8s.api.core.v1.ContainerImage",
	"io.k8s.api.core.v1.ContainerPort",
	"io.k8s.api.core.v1.ContainerState",
	"io.k8s.api.core.v1.ContainerStateRunning",
	"io.k8s.api.core.v1.ContainerStateTerminated",
	"io.k8s.api.core.v1.ContainerStateWaiting",
	"io.k8s.api.core.v1.ContainerStatus",
	"io.k8s.api.core.v1.DaemonEndpoint",
	"io.k8s.api.core.v1.DownwardAPIProjection",
	"io.k8s.api.core.v1.DownwardAPIVolumeFile",
	"io.k8s.api.core.v1.DownwardAPIVolumeSource",
	"io.k8s.api.core.v1.EmptyDirVolumeSource",
	"io.k8s.api.core.v1.EndpointAddress",
	"io.k8s.api.core.v1.EndpointPort",
	"io.k8s.api.core.v1.EndpointSubset",
	"io.k8s.api.core.v1.Endpoints",
	"io.k8s.api.core.v1.EndpointsList",
	"io.k8s.api.core.v1.EnvFromSource",
	"io.k8s.api.core.v1.EnvVar",
	"io.k8s.api.core.v1.EnvVarSource",
	"io.k8s.api.core.v1.EphemeralContainer",
	"io.k8s.api.core.v1.Event",
	"io.k8s.api.core.v1.EventList",
	"io.k8s.api.core.v1.EventSeries",
	"io.k8s.api.core.v1.EventSource",
	"io.k8s.api.core.v1.ExecAction",
	"io.k8s.api.core.v1.FCVolumeSource",
	"io.k8s.api.core.v1.FlexPersistentVolumeSource",
	"io.k8s.api.core.v1.FlexVolumeSource",
	"io.k8s.api.core.v1.FlockerVolumeSource",
	"io.k8s.api.core.v1.GCEPersistentDiskVolumeSource",
	"io.k8s.api.core.v1.GitRepoVolumeSource",
	"io.k8s.api.core.v1.GlusterfsPersistentVolumeSource",
	"io.k8s.api.core.v1.GlusterfsVolumeSource",
	"io.k8s.api.core.v1.HTTPGetAction",
	"io.k8s.api.core.v1.HTTPHeader",
	"io.k8s.api.core.v1.Handler",
	"io.k8s.api.core.v1.HostAlias",
	"io.k8s.api.core.v1.HostPathVolumeSource",
	"io.k8s.api.core.v1.ISCSIPersistentVolumeSource",
	"io.k8s.api.core.v1.ISCSIVolumeSource",
	"io.k8s.api.core.v1.KeyToPath",
	"io.k8s.api.core.v1.Lifecycle",
	"io.k8s.api.core.v1.LimitRange",
	"io.k8s.api.core.v1.LimitRangeItem",
	"io.k8s.api.core.v1.LimitRangeList",
	"io.k8s.api.core.v1.LimitRangeSpec",
	"io.k8s.api.core.v1.LoadBalancerIngress",
	"io.k8s.api.core.v1.LoadBalancerStatus",
	"io.k8s.api.core.v1.LocalObjectReference",
	"io.k8s.api.core.v1.LocalVolumeSource",
	"io.k8s.api.core.v1.NFSVolumeSource",
	"io.k8s.api.core.v1.Namespace",
	"io.k8s.api.core.v1.NamespaceCondition",
	"io.k8s.api.core.v1.NamespaceList",
	"io.k8s.api.core.v1.NamespaceSpec",
	"io.k8s.api.core.v1.NamespaceStatus",
	"io.k8s.api.core.v1.Node",
	"io.k8s.api.core.v1.NodeAddress",
	"io.k8s.api.core.v1.NodeAffinity",
	"io.k8s.api.core.v1.NodeCondition",
	"io.k8s.api.core.v1.NodeConfigSource",
	"io.k8s.api.core.v1.NodeConfigStatus",
	"io.k8s.api.core.v1.NodeDaemonEndpoints",
	"io.k8s.api.core.v1.NodeList",
	"io.k8s.api.core.v1.NodeSelector",
	"io.k8s.api.core.v1.NodeSelectorRequirement",
	"io.k8s.api.core.v1.NodeSelectorTerm",
	"io.k8s.api.core.v1.NodeSpec",
	"io.k8s.api.core.v1.NodeStatus",
	"io.k8s.api.core.v1.NodeSystemInfo",
	"io.k8s.api.core.v1.ObjectFieldSelector",
	"io.k8s.api.core.v1.ObjectReference",
	"io.k8s.api.core.v1.PersistentVolume",
	"io.k8s.api.core.v1.PersistentVolumeClaim",
	"io.k8s.api.core.v1.PersistentVolumeClaimCondition",
	"io.k8s.api.core.v1.PersistentVolumeClaimList",
	"io.k8s.api.core.v1.PersistentVolumeClaimSpec",
	"io.k8s.api.core.v1.PersistentVolumeClaimStatus",
	"io.k8s.api.core.v1.PersistentVolumeClaimVolumeSource",
	"io.k8s.api.core.v1.PersistentVolumeList",
	"io.k8s.api.core.v1.PersistentVolumeSpec",
	"io.k8s.api.core.v1.PersistentVolumeStatus",
	"io.k8s.api.core.v1.PhotonPersistentDiskVolumeSource",
	"io.k8s.api.core.v1.Pod",
	"io.k8s.api.core.v1.PodAffinity",
	"io.k8s.api.core.v1.PodAffinityTerm",
	"io.k8s.api.core.v1.PodAntiAffinity",
	"io.k8s.api.core.v1.PodCondition",
	"io.k8s.api.core.v1.PodDNSConfig",
	"io.k8s.api.core.v1.PodDNSConfigOption",
	"io.k8s.api.core.v1.PodIP",
	"io.k8s.api.core.v1.PodList",
	"io.k8s.api.core.v1.PodReadinessGate",
	"io.k8s.api.core.v1.PodSecurityContext",
	"io.k8s.api.core.v1.PodSpec",
	"io.k8s.api.core.v1.PodStatus",
	"io.k8s.api.core.v1.PodTemplate",
	"io.k8s.api.core.v1.PodTemplateList",
	"io.k8s.api.core.v1.PodTemplateSpec",
	"io.k8s.api.core.v1.PortworxVolumeSource",
	"io.k8s.api.core.v1.PreferredSchedulingTerm",
	"io.k8s.api.core.v1.Probe",
	"io.k8s.api.core.v1.ProjectedVolumeSource",
	"io.k8s.api.core.v1.QuobyteVolumeSource",
	"io.k8s.api.core.v1.RBDPersistentVolumeSource",
	"io.k8s.api.core.v1.RBDVolumeSource",
	"io.k8s.api.core.v1.ReplicationController",
	"io.k8s.api.core.v1.ReplicationControllerCondition",
	"io.k8s.api.core.v1.ReplicationControllerList",
	"io.k8s.api.core.v1.ReplicationControllerSpec",
	"io.k8s.api.core.v1.ReplicationControllerStatus",
	"io.k8s.api.core.v1.ResourceFieldSelector",
	"io.k8s.api.core.v1.ResourceQuota",
	"io.k8s.api.core.v1.ResourceQuotaList",
	"io.k8s.api.core.v1.ResourceQuotaSpec",
	"io.k8s.api.core.v1.ResourceQuotaStatus",
	"io.k8s.api.core.v1.ResourceRequirements",
	"io.k8s.api.core.v1.SELinuxOptions",
	"io.k8s.api.core.v1.ScaleIOPersistentVolumeSource",
	"io.k8s.api.core.v1.ScaleIOVolumeSource",
	"io.k8s.api.core.v1.ScopeSelector",
	"io.k8s.api.core.v1.ScopedResourceSelectorRequirement",
	"io.k8s.api.core.v1.Secret",
	"io.k8s.api.core.v1.SecretEnvSource",
	"io.k8s.api.core.v1.SecretKeySelector",
	"io.k8s.api.core.v1.SecretList",
	"io.k8s.api.core.v1.SecretProjection",
	"io.k8s.api.core.v1.SecretReference",
	"io.k8s.api.core.v1.SecretVolumeSource",
	"io.k8s.api.core.v1.SecurityContext",
	"io.k8s.api.core.v1.Service",
	"io.k8s.api.core.v1.ServiceAccount",
	"io.k8s.api.core.v1.ServiceAccountList",
	"io.k8s.api.core.v1.ServiceAccountTokenProjection",
	"io.k8s.api.core.v1.ServiceList",
	"io.k8s.api.core.v1.ServicePort",
	"io.k8s.api.core.v1.ServiceSpec",
	"io.k8s.api.core.v1.ServiceStatus",
	"io.k8s.api.core.v1.SessionAffinityConfig",
	"io.k8s.api.core.v1.StorageOSPersistentVolumeSource",
	"io.k8s.api.core.v1.StorageOSVolumeSource",
	"io.k8s.api.core.v1.Sysctl",
	"io.k8s.api.core.v1.TCPSocketAction",
	"io.k8s.api.core.v1.Taint",
	"io.k8s.api.core.v1.Toleration",
	"io.k8s.api.core.v1.TopologySelectorLabelRequirement",
	"io.k8s.api.core.v1.TopologySelectorTerm",
	"io.k8s.api.core.v1.TopologySpreadConstraint",
	"io.k8s.api.core.v1.TypedLocalObjectReference",
	"io.k8s.api.core.v1.Volume",
	"io.k8s.api.core.v1.VolumeDevice",
	"io.k8s.api.core.v1.VolumeMount",
	"io.k8s.api.core.v1.VolumeNodeAffinity",
	"io.k8s.api.core.v1.VolumeProjection",
	"io.k8s.api.core.v1.VsphereVirtualDiskVolumeSource",
	"io.k8s.api.core.v1.WeightedPodAffinityTerm",
	"io.k8s.api.core.v1.WindowsSecurityContextOptions",
	"io.k8s.api.discovery.v1beta1.Endpoint",
	"io.k8s.api.discovery.v1beta1.EndpointConditions",
	"io.k8s.api.discovery.v1beta1.EndpointPort",
	"io.k8s.api.discovery.v1beta1.EndpointSlice",
	"io.k8s.api.discovery.v1beta1.EndpointSliceList",
	"io.k8s.api.events.v1beta1.Event",
	"io.k8s.api.events.v1beta1.EventList",
	"io.k8s.api.events.v1beta1.EventSeries",
	"io.k8s.api.extensions.v1beta1.AllowedCSIDriver",
	"io.k8s.api.extensions.v1beta1.AllowedFlexVolume",
	"io.k8s.api.extensions.v1beta1.AllowedHostPath",
	"io.k8s.api.extensions.v1beta1.DaemonSet",
	"io.k8s.api.extensions.v1beta1.DaemonSetCondition",
	"io.k8s.api.extensions.v1beta1.DaemonSetList",
	"io.k8s.api.extensions.v1beta1.DaemonSetSpec",
	"io.k8s.api.extensions.v1beta1.DaemonSetStatus",
	"io.k8s.api.extensions.v1beta1.DaemonSetUpdateStrategy",
	"io.k8s.api.extensions.v1beta1.Deployment",
	"io.k8s.api.extensions.v1beta1.DeploymentCondition",
	"io.k8s.api.extensions.v1beta1.DeploymentList",
	"io.k8s.api.extensions.v1beta1.DeploymentRollback",
	"io.k8s.api.extensions.v1beta1.DeploymentSpec",
	"io.k8s.api.extensions.v1beta1.DeploymentStatus",
	"io.k8s.api.extensions.v1beta1.DeploymentStrategy",
	"io.k8s.api.extensions.v1beta1.FSGroupStrategyOptions",
	"io.k8s.api.extensions.v1beta1.HTTPIngressPath",
	"io.k8s.api.extensions.v1beta1.HTTPIngressRuleValue",
	"io.k8s.api.extensions.v1beta1.HostPortRange",
	"io.k8s.api.extensions.v1beta1.IDRange",
	"io.k8s.api.extensions.v1beta1.IPBlock",
	"io.k8s.api.extensions.v1beta1.Ingress",
	"io.k8s.api.extensions.v1beta1.IngressBackend",
	"io.k8s.api.extensions.v1beta1.IngressList",
	"io.k8s.api.extensions.v1beta1.IngressRule",
	"io.k8s.api.extensions.v1beta1.IngressSpec",
	"io.k8s.api.extensions.v1beta1.IngressStatus",
	"io.k8s.api.extensions.v1beta1.IngressTLS",
	"io.k8s.api.extensions.v1beta1.NetworkPolicy",
	"io.k8s.api.extensions.v1beta1.NetworkPolicyEgressRule",
	"io.k8s.api.extensions.v1beta1.NetworkPolicyIngressRule",
	"io.k8s.api.extensions.v1beta1.NetworkPolicyList",
	"io.k8s.api.extensions.v1beta1.NetworkPolicyPeer",
	"io.k8s.api.extensions.v1beta1.NetworkPolicyPort",
	"io.k8s.api.extensions.v1beta1.NetworkPolicySpec",
	"io.k8s.api.extensions.v1beta1.PodSecurityPolicy",
	"io.k8s.api.extensions.v1beta1.PodSecurityPolicyList",
	"io.k8s.api.extensions.v1beta1.PodSecurityPolicySpec",
	"io.k8s.api.extensions.v1beta1.ReplicaSet",
	"io.k8s.api.extensions.v1beta1.ReplicaSetCondition",
	"io.k8s.api.extensions.v1beta1.ReplicaSetList",
	"io.k8s.api.extensions.v1beta1.ReplicaSetSpec",
	"io.k8s.api.extensions.v1beta1.ReplicaSetStatus",
	"io.k8s.api.extensions.v1beta1.RollbackConfig",
	"io.k8s.api.extensions.v1beta1.RollingUpdateDaemonSet",
	"io.k8s.api.extensions.v1beta1.RollingUpdateDeployment",
	"io.k8s.api.extensions.v1beta1.RunAsGroupStrategyOptions",
	"io.k8s.api.extensions.v1beta1.RunAsUserStrategyOptions",
	"io.k8s.api.extensions.v1beta1.RuntimeClassStrategyOptions",
	"io.k8s.api.extensions.v1beta1.SELinuxStrategyOptions",
	"io.k8s.api.extensions.v1beta1.Scale",
	"io.k8s.api.extensions.v1beta1.ScaleSpec",
	"io.k8s.api.extensions.v1beta1.ScaleStatus",
	"io.k8s.api.extensions.v1beta1.SupplementalGroupsStrategyOptions",
	"io.k8s.api.flowcontrol.v1alpha1.FlowDistinguisherMethod",
	"io.k8s.api.flowcontrol.v1alpha1.FlowSchema",
	"io.k8s.api.flowcontrol.v1alpha1.FlowSchemaCondition",
	"io.k8s.api.flowcontrol.v1alpha1.FlowSchemaList",
	"io.k8s.api.flowcontrol.v1alpha1.FlowSchemaSpec",
	"io.k8s.api.flowcontrol.v1alpha1.FlowSchemaStatus",
	"io.k8s.api.flowcontrol.v1alpha1.GroupSubject",
	"io.k8s.api.flowcontrol.v1alpha1.LimitResponse",
	"io.k8s.api.flowcontrol.v1alpha1.LimitedPriorityLevelConfiguration",
	"io.k8s.api.flowcontrol.v1alpha1.NonResourcePolicyRule",
	"io.k8s.api.flowcontrol.v1alpha1.PolicyRulesWithSubjects",
	"io.k8s.api.flowcontrol.v1alpha1.PriorityLevelConfiguration",
	"io.k8s.api.flowcontrol.v1alpha1.PriorityLevelConfigurationCondition",
	"io.k8s.api.flowcontrol.v1alpha1.PriorityLevelConfigurationList",
	"io.k8s.api.flowcontrol.v1alpha1.PriorityLevelConfigurationReference",
	"io.k8s.api.flowcontrol.v1alpha1.PriorityLevelConfigurationSpec",
	"io.k8s.api.flowcontrol.v1alpha1.PriorityLevelConfigurationStatus",
	"io.k8s.api.flowcontrol.v1alpha1.QueuingConfiguration",
	"io.k8s.api.flowcontrol.v1alpha1.ResourcePolicyRule",
	"io.k8s.api.flowcontrol.v1alpha1.ServiceAccountSubject",
	"io.k8s.api.flowcontrol.v1alpha1.Subject",
	"io.k8s.api.flowcontrol.v1alpha1.UserSubject",
	"io.k8s.api.networking.v1.IPBlock",
	"io.k8s.api.networking.v1.NetworkPolicy",
	"io.k8s.api.networking.v1.NetworkPolicyEgressRule",
	"io.k8s.api.networking.v1.NetworkPolicyIngressRule",
	"io.k8s.api.networking.v1.NetworkPolicyList",
	"io.k8s.api.networking.v1.NetworkPolicyPeer",
	"io.k8s.api.networking.v1.NetworkPolicyPort",
	"io.k8s.api.networking.v1.NetworkPolicySpec",
	"io.k8s.api.networking.v1beta1.HTTPIngressPath",
	"io.k8s.api.networking.v1beta1.HTTPIngressRuleValue",
	"io.k8s.api.networking.v1beta1.Ingress",
	"io.k8s.api.networking.v1beta1.IngressBackend",
	"io.k8s.api.networking.v1beta1.IngressList",
	"io.k8s.api.networking.v1beta1.IngressRule",
	"io.k8s.api.networking.v1beta1.IngressSpec",
	"io.k8s.api.networking.v1beta1.IngressStatus",
	"io.k8s.api.networking.v1beta1.IngressTLS",
	"io.k8s.api.node.v1alpha1.Overhead",
	"io.k8s.api.node.v1alpha1.RuntimeClass",
	"io.k8s.api.node.v1alpha1.RuntimeClassList",
	"io.k8s.api.node.v1alpha1.RuntimeClassSpec",
	"io.k8s.api.node.v1alpha1.Scheduling",
	"io.k8s.api.node.v1beta1.Overhead",
	"io.k8s.api.node.v1beta1.RuntimeClass",
	"io.k8s.api.node.v1beta1.RuntimeClassList",
	"io.k8s.api.node.v1beta1.Scheduling",
	"io.k8s.api.policy.v1beta1.AllowedCSIDriver",
	"io.k8s.api.policy.v1beta1.AllowedFlexVolume",
	"io.k8s.api.policy.v1beta1.AllowedHostPath",
	"io.k8s.api.policy.v1beta1.Eviction",
	"io.k8s.api.policy.v1beta1.FSGroupStrategyOptions",
	"io.k8s.api.policy.v1beta1.HostPortRange",
	"io.k8s.api.policy.v1beta1.IDRange",
	"io.k8s.api.policy.v1beta1.PodDisruptionBudget",
	"io.k8s.api.policy.v1beta1.PodDisruptionBudgetList",
	"io.k8s.api.policy.v1beta1.PodDisruptionBudgetSpec",
	"io.k8s.api.policy.v1beta1.PodDisruptionBudgetStatus",
	"io.k8s.api.policy.v1beta1.PodSecurityPolicy",
	"io.k8s.api.policy.v1beta1.PodSecurityPolicyList",
	"io.k8s.api.policy.v1beta1.PodSecurityPolicySpec",
	"io.k8s.api.policy.v1beta1.RunAsGroupStrategyOptions",
	"io.k8s.api.policy.v1beta1.RunAsUserStrategyOptions",
	"io.k8s.api.policy.v1beta1.RuntimeClassStrategyOptions",
	"io.k8s.api.policy.v1beta1.SELinuxStrategyOptions",
	"io.k8s.api.policy.v1beta1.SupplementalGroupsStrategyOptions",
	"io.k8s.api.rbac.v1.AggregationRule",
	"io.k8s.api.rbac.v1.ClusterRole",
	"io.k8s.api.rbac.v1.ClusterRoleBinding",
	"io.k8s.api.rbac.v1.ClusterRoleBindingList",
	"io.k8s.api.rbac.v1.ClusterRoleList",
	"io.k8s.api.rbac.v1.PolicyRule",
	"io.k8s.api.rbac.v1.Role",
	"io.k8s.api.rbac.v1.RoleBinding",
	"io.k8s.api.rbac.v1.RoleBindingList",
	"io.k8s.api.rbac.v1.RoleList",
	"io.k8s.api.rbac.v1.RoleRef",
	"io.k8s.api.rbac.v1.Subject",
	"io.k8s.api.rbac.v1alpha1.AggregationRule",
	"io.k8s.api.rbac.v1alpha1.ClusterRole",
	"io.k8s.api.rbac.v1alpha1.ClusterRoleBinding",
	"io.k8s.api.rbac.v1alpha1.ClusterRoleBindingList",
	"io.k8s.api.rbac.v1alpha1.ClusterRoleList",
	"io.k8s.api.rbac.v1alpha1.PolicyRule",
	"io.k8s.api.rbac.v1alpha1.Role",
	"io.k8s.api.rbac.v1alpha1.RoleBinding",
	"io.k8s.api.rbac.v1alpha1.RoleBindingList",
	"io.k8s.api.rbac.v1alpha1.RoleList",
	"io.k8s.api.rbac.v1alpha1.RoleRef",
	"io.k8s.api.rbac.v1alpha1.Subject",
	"io.k8s.api.rbac.v1beta1.AggregationRule",
	"io.k8s.api.rbac.v1beta1.ClusterRole",
	"io.k8s.api.rbac.v1beta1.ClusterRoleBinding",
	"io.k8s.api.rbac.v1beta1.ClusterRoleBindingList",
	"io.k8s.api.rbac.v1beta1.ClusterRoleList",
	"io.k8s.api.rbac.v1beta1.PolicyRule",
	"io.k8s.api.rbac.v1beta1.Role",
	"io.k8s.api.rbac.v1beta1.RoleBinding",
	"io.k8s.api.rbac.v1beta1.RoleBindingList",
	"io.k8s.api.rbac.v1beta1.RoleList",
	"io.k8s.api.rbac.v1beta1.RoleRef",
	"io.k8s.api.rbac.v1beta1.Subject",
	"io.k8s.api.scheduling.v1.PriorityClass",
	"io.k8s.api.scheduling.v1.PriorityClassList",
	"io.k8s.api.scheduling.v1alpha1.PriorityClass",
	"io.k8s.api.scheduling.v1alpha1.PriorityClassList",
	"io.k8s.api.scheduling.v1beta1.PriorityClass",
	"io.k8s.api.scheduling.v1beta1.PriorityClassList",
	"io.k8s.api.settings.v1alpha1.PodPreset",
	"io.k8s.api.settings.v1alpha1.PodPresetList",
	"io.k8s.api.settings.v1alpha1.PodPresetSpec",
	"io.k8s.api.storage.v1.CSINode",
	"io.k8s.api.storage.v1.CSINodeDriver",
	"io.k8s.api.storage.v1.CSINodeList",
	"io.k8s.api.storage.v1.CSINodeSpec",
	"io.k8s.api.storage.v1.StorageClass",
	"io.k8s.api.storage.v1.StorageClassList",
	"io.k8s.api.storage.v1.VolumeAttachment",
	"io.k8s.api.storage.v1.VolumeAttachmentList",
	"io.k8s.api.storage.v1.VolumeAttachmentSource",
	"io.k8s.api.storage.v1.VolumeAttachmentSpec",
	"io.k8s.api.storage.v1.VolumeAttachmentStatus",
	"io.k8s.api.storage.v1.VolumeError",
	"io.k8s.api.storage.v1.VolumeNodeResources",
	"io.k8s.api.storage.v1alpha1.VolumeAttachment",
	"io.k8s.api.storage.v1alpha1.VolumeAttachmentList",
	"io.k8s.api.storage.v1alpha1.VolumeAttachmentSource",
	"io.k8s.api.storage.v1alpha1.VolumeAttachmentSpec",
	"io.k8s.api.storage.v1alpha1.VolumeAttachmentStatus",
	"io.k8s.api.storage.v1alpha1.VolumeError",
	"io.k8s.api.storage.v1beta1.CSIDriver",
	"io.k8s.api.storage.v1beta1.CSIDriverList",
	"io.k8s.api.storage.v1beta1.CSIDriverSpec",
	"io.k8s.api.storage.v1beta1.CSINode",
	"io.k8s.api.storage.v1beta1.CSINodeDriver",
	"io.k8s.api.storage.v1beta1.CSINodeList",
	"io.k8s.api.storage.v1beta1.CSINodeSpec",
	"io.k8s.api.storage.v1beta1.StorageClass",
	"io.k8s.api.storage.v1beta1.StorageClassList",
	"io.k8s.api.storage.v1beta1.VolumeAttachment",
	"io.k8s.api.storage.v1beta1.VolumeAttachmentList",
	"io.k8s.api.storage.v1beta1.VolumeAttachmentSource",
	"io.k8s.api.storage.v1beta1.VolumeAttachmentSpec",
	"io.k8s.api.storage.v1beta1.VolumeAttachmentStatus",
	"io.k8s.api.storage.v1beta1.VolumeError",
	"io.k8s.api.storage.v1beta1.VolumeNodeResources",
	"io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1.CustomResourceColumnDefinition",
	"io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1.CustomResourceConversion",
	"io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1.CustomResourceDefinition",
	"io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1.CustomResourceDefinitionCondition",
	"io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1.CustomResourceDefinitionList",
	"io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1.CustomResourceDefinitionNames",
	"io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1.CustomResourceDefinitionSpec",
	"io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1.CustomResourceDefinitionStatus",
	"io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1.CustomResourceDefinitionVersion",
	"io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1.CustomResourceSubresourceScale",
	"io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1.CustomResourceSubresourceStatus",
	"io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1.CustomResourceSubresources",
	"io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1.CustomResourceValidation",
	"io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1.ExternalDocumentation",
	"io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1.JSON",
	"io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1.JSONSchemaProps",
	"io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1.JSONSchemaPropsOrArray",
	"io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1.JSONSchemaPropsOrBool",
	"io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1.JSONSchemaPropsOrStringArray",
	"io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1.ServiceReference",
	"io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1.WebhookClientConfig",
	"io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1.WebhookConversion",
	"io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1beta1.CustomResourceColumnDefinition",
	"io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1beta1.CustomResourceConversion",
	"io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1beta1.CustomResourceDefinition",
	"io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1beta1.CustomResourceDefinitionCondition",
	"io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1beta1.CustomResourceDefinitionList",
	"io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1beta1.CustomResourceDefinitionNames",
	"io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1beta1.CustomResourceDefinitionSpec",
	"io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1beta1.CustomResourceDefinitionStatus",
	"io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1beta1.CustomResourceDefinitionVersion",
	"io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1beta1.CustomResourceSubresourceScale",
	"io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1beta1.CustomResourceSubresourceStatus",
	"io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1beta1.CustomResourceSubresources",
	"io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1beta1.CustomResourceValidation",
	"io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1beta1.ExternalDocumentation",
	"io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1beta1.JSON",
	"io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1beta1.JSONSchemaProps",
	"io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1beta1.JSONSchemaPropsOrArray",
	"io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1beta1.JSONSchemaPropsOrBool",
	"io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1beta1.JSONSchemaPropsOrStringArray",
	"io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1beta1.ServiceReference",
	"io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1beta1.WebhookClientConfig",
	"io.k8s.apimachinery.pkg.api.resource.Quantity",
	"io.k8s.apimachinery.pkg.apis.meta.v1.APIGroup",
	"io.k8s.apimachinery.pkg.apis.meta.v1.APIGroupList",
	"io.k8s.apimachinery.pkg.apis.meta.v1.APIResource",
	"io.k8s.apimachinery.pkg.apis.meta.v1.APIResourceList",
	"io.k8s.apimachinery.pkg.apis.meta.v1.APIVersions",
	"io.k8s.apimachinery.pkg.apis.meta.v1.DeleteOptions",
	"io.k8s.apimachinery.pkg.apis.meta.v1.FieldsV1",
	"io.k8s.apimachinery.pkg.apis.meta.v1.GroupVersionForDiscovery",
	"io.k8s.apimachinery.pkg.apis.meta.v1.LabelSelector",
	"io.k8s.apimachinery.pkg.apis.meta.v1.LabelSelectorRequirement",
	"io.k8s.apimachinery.pkg.apis.meta.v1.ListMeta",
	"io.k8s.apimachinery.pkg.apis.meta.v1.ManagedFieldsEntry",
	"io.k8s.apimachinery.pkg.apis.meta.v1.MicroTime",
	"io.k8s.apimachinery.pkg.apis.meta.v1.ObjectMeta",
	"io.k8s.apimachinery.pkg.apis.meta.v1.OwnerReference",
	"io.k8s.apimachinery.pkg.apis.meta.v1.Patch",
	"io.k8s.apimachinery.pkg.apis.meta.v1.Preconditions",
	"io.k8s.apimachinery.pkg.apis.meta.v1.ServerAddressByClientCIDR",
	"io.k8s.apimachinery.pkg.apis.meta.v1.Status",
	"io.k8s.apimachinery.pkg.apis.meta.v1.StatusCause",
	"io.k8s.apimachinery.pkg.apis.meta.v1.StatusDetails",
	"io.k8s.apimachinery.pkg.apis.meta.v1.Time",
	"io.k8s.apimachinery.pkg.apis.meta.v1.WatchEvent",
	"io.k8s.apimachinery.pkg.runtime.RawExtension",
	"io.k8s.apimachinery.pkg.util.intstr.IntOrString",
	"io.k8s.apimachinery.pkg.version.Info",
	"io.k8s.kube-aggregator.pkg.apis.apiregistration.v1.APIService",
	"io.k8s.kube-aggregator.pkg.apis.apiregistration.v1.APIServiceCondition",
	"io.k8s.kube-aggregator.pkg.apis.apiregistration.v1.APIServiceList",
	"io.k8s.kube-aggregator.pkg.apis.apiregistration.v1.APIServiceSpec",
	"io.k8s.kube-aggregator.pkg.apis.apiregistration.v1.APIServiceStatus",
	"io.k8s.kube-aggregator.pkg.apis.apiregistration.v1.ServiceReference",
	"io.k8s.kube-aggregator.pkg.apis.apiregistration.v1beta1.APIService",
	"io.k8s.kube-aggregator.pkg.apis.apiregistration.v1beta1.APIServiceCondition",
	"io.k8s.kube-aggregator.pkg.apis.apiregistration.v1beta1.APIServiceList",
	"io.k8s.kube-aggregator.pkg.apis.apiregistration.v1beta1.APIServiceSpec",
	"io.k8s.kube-aggregator.pkg.apis.apiregistration.v1beta1.APIServiceStatus",
	"io.k8s.kube-aggregator.pkg.apis.apiregistration.v1beta1.ServiceReference",
}

// Emit takes a swagger API specification, and returns the text of
// `ksonnet-lib`, written in Jsonnet.
func Emit(spec *spec.Swagger, ksonnetLibSHA, k8sSHA *string) (k *bytes.Buffer, k8s *bytes.Buffer, err error) {
	jsonnet, err := transpiler.Transpile(
		spec,
		transpiler.Config{
			PublicAPIs:      []string{".+"},
			BlacklistedAPIs: []string{"JSONSchema.*"},
			IgnoredFields:   []string{"kind", "apiVersion", "error"},
			APIsSpec: map[string]transpiler.APISpec{
				"io.k8s.api.core.v1.PersistentVolumeSpec": {
					RenameFields: map[string]string{
						"local": "localStorage",
					},
				},
				"io.k8s.api.core.v1.Container": {
					Ctor: transpiler.Ctor{
						Params: map[string]interface{}{
							"name":  "",
							"image": "",
						},
						Body: map[string]string{
							"withImage": "image",
							"withName":  "name",
						},
					},
				},
				"io.k8s.api.apps.v1.Deployment": {
					Ctor: transpiler.Ctor{
						Params: map[string]interface{}{
							"name":       "",
							"replicas":   1,
							"containers": "",
						},
						Body: map[string]string{
							"metadata.withName":                 "name",
							"spec.withReplicas":                 "replicas",
							"spec.template.spec.withContainers": "containers",
						},
					},
				},
			},
		},
	)
	//jsonnet, err := transpiler.Transpile(
	//	spec,
	//	transpiler.Config{
	//		PublicAPIs:    []string{"io.k8s.api.core.v1.Pod", "io.k8s.api.apps.v1.Deployment", "io.k8s.api.apps.v1.StatefulSet"},
	//		IgnoredFields: []string{"kind", "apiVersion", "status"},
	//	},
	//)
	//jsonnet, err := transpiler.Transpile(spec, transpiler.Config{PublicAPIs: []string{"io.k8s.api.apps.v1.Deployment", "io.k8s.api.apps.v1.StatefulSet"}})
	//jsonnet, err := transpiler.Transpile(spec, transpiler.Config{PublicAPIs: []string{"io.k8s.api.core.v1.EmptyDirVolumeSource"}})

	//istAPINodes := istNodeCache{}
	//for fullname, schema := range spec.SwaggerProps.Definitions {
	//	istAPINodes[fullname], err = apiNodeFromSchema(fullname, &schema)
	//	if err != nil {
	//		panic(err)
	//	}
	//}
	//
	//// test package
	////cache, err := istAPINodes.WhitelistAPI([]string{"io.k8s.api.apps.v1.Deployment", "io.k8s.api.core.v1.Container"})
	//cache, err := istAPINodes.WhitelistAPI(whitelist)
	//deployment := cache["io.k8s.api.apps.v1.Deployment"]
	//_ = deployment
	//
	////podSpec := cache["io.k8s.api.core.v1.PodSpec"]
	//
	fmt.Fprintf(os.Stderr, "err: %+v\n", err)

	var buf bytes.Buffer
	_ = jsonnet
	err = printer.Fprint(&buf, jsonnet)
	fmt.Println(buf.String())
	return
}
