local k8s = import "k8s.libsonnet.1";

{
    bench: [
        k8s.apps.v1.deployment.mixin.spec.template.spec.withContainers([
            k8s.apps.v1.deployment.mixin.spec.template.spec.containersType.withName("aaa").withImage("aaa"),
            k8s.apps.v1.deployment.mixin.spec.template.spec.containersType.withName("bbb").withImage("bbb"),
            k8s.apps.v1.deployment.mixin.spec.template.spec.containersType.withName("ccc").withImage("ccc")
        ])
        for i in std.range(0, 10000)
    ],
}