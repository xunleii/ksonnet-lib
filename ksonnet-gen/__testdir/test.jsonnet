local lib = import "new.libsonnet";
local k8s = import "k8s.libsonnet.1";
local spec = k8s.apps.v1.deployment.mixin.spec.template.spec;

{
    klib:
        k8s.apps.v1.deployment.new("toto", 2) +
        k8s.apps.v1.deployment.mixin.spec.template.spec.withContainers([
            k8s.apps.v1.deployment.mixin.spec.template.spec.containersType.withName("aaa").withImage("aaa"),
            k8s.apps.v1.deployment.mixin.spec.template.spec.containersType.withName("bbb").withImage("bbb"),
            k8s.apps.v1.deployment.mixin.spec.template.spec.containersType.withName("ccc").withImage("ccc")
        ]),
    nlib: 
        lib.apps.v1.deployment.new("toto", 2) +
        lib.apps.v1.deployment.mixin.spec.template.spec.withContainers([
            lib.apps.v1.deployment.mixin.spec.template.spec.containersType.withName("aaa").withImage("aaa"),
            lib.apps.v1.deployment.mixin.spec.template.spec.containersType.withName("bbb").withImage("bbb"),
            lib.apps.v1.deployment.mixin.spec.template.spec.containersType.withName("ccc").withImage("ccc")
        ])
}