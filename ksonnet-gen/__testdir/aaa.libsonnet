// increase size vitually
local k8s = import "k8s.libsonnet";

{
  apps:: {
    v1:: {
      deployment:: hidden.apps.v1.deployment(function(deployment) deployment),
    },
  },
  local hidden = {
    apps:: {
      v1:: {
        deployment(mixinInstance):: {
          mixinInstance(deployment):: mixinInstance(deployment),
          spec:: self.mixin.spec,
          mixin:: {
            spec:: hidden.apps.v1.deploymentSpec(function(spec) mixinInstance({spec+: spec}))
          },
        },
        deploymentSpec(mixinInstance):: {
          mixinInstance(deployment):: mixinInstance(deployment),
          template:: self.mixin.template,
          mixin:: {
            template:: hidden.core.v1.podTemplate(function(template) mixinInstance({template+: template}))
          },
        },
      },
    },
    core:: {
      v1:: {
        podTemplate(mixinInstance):: {
          mixinInstance(podTemplate):: mixinInstance(podTemplate),
          spec:: self.mixin.spec,
          mixin:: {
            spec:: hidden.core.v1.podSpec(function(spec) mixinInstance({spec+: spec}))
          },
        },
        podSpec(mixinInstance):: {
          mixinInstance(podSpec):: mixinInstance(podSpec),
          withContainers(containers):: self + if std.type(containers) == 'array' then mixinInstance({ containers: containers }) else mixinInstance({ containers: [containers] }),
          withContainersMixin(containers):: self + if std.type(containers) == 'array' then mixinInstance({ containers+: containers }) else mixinInstance({ containers+: [containers] }),
          containersType:: hidden.core.v1.container(function(containersType) containersType),
          mixin:: {},
        },
        container(mixinInstance):: {
          mixinInstance(podSpec):: mixinInstance(podSpec),
          withName(name):: self + mixinInstance({name: name}),
          withImage(image):: self + mixinInstance({image: image}),
          mixin:: {},
        },
      },
    },
  },
  k8s:: k8s,  
}