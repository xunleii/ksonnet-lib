local k8s = import "aaa.libsonnet";

{
    bench: [
        k8s.apps.v1.deployment.mixin.spec.template.spec.withContainers([
            k8s.apps.v1.deployment.mixin.spec.template.spec.containersType.withName("aaa").withImage("aaa"),
            k8s.apps.v1.deployment.mixin.spec.template.spec.containersType.withName("bbb").withImage("bbb"),
            k8s.apps.v1.deployment.mixin.spec.template.spec.containersType.withName("ccc").withImage("ccc")
        ])
        for i in std.range(0, 1000)
    ],
}