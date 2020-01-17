local lib = import "new.libsonnet";
local k8s = import "k8s.libsonnet";
local spec = k8s.apps.v1.deployment.mixin.spec.template.spec;

{
//    nlib: lib.apps.v1.deployment.mixin.spec.template.spec.securityContext.withRunAsUser("root").withRunAsGroup("root"),
    klib: k8s.apps.v1.deployment.mixin.spec.template.spec.securityContext.withRunAsUser("root").withRunAsGroup("root"),
    nlib: lib.apps.v1.deployment.mixin.spec.template.spec.securityContext.withRunAsUser("root").withRunAsGroup("root")
}