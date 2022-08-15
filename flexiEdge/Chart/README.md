# flexiEdge

`flexiEdge` is core component in the [flexiWAN](https://flexiwan.com/) ECO System.

## Introduction

This chart bootstraps `flexiEdge` as a Kubernetes VM intsnace on top of 
KubeVirt <https://kubevirt.io/>.

### Philosophy

The `flexiEdge` HelmChart is focused on `flexiEdge` deployment configuration.

To keep this HelmChart as generic as possible we tend
to avoid integrating any third party solutions nor any specific use cases.

Accordingly, the encouraged approach to fulfill your needs:

1. override the default flexiEdge configuration values ([yaml file or cli](https://helm.sh/docs/chart_template_guide/values_files/))
2. append your own configurations (`kubectl apply -f myconf.yaml`)
3. extend this HelmChart ([as a Subchart](https://helm.sh/docs/chart_template_guide/subcharts_and_globals/))

## Installing

### Prerequisites

With the command `helm version`, make sure that you have:

- Helm v3 [installed](https://helm.sh/docs/using_helm/#installing-helm)

With the command `kubectl version`, make sure that you have:

- Kubernetes 1.16+

Add flexiEdge's chart repository to Helm:
[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/flexiedge)](https://artifacthub.io/packages/search?repo=flexiedge)

```bash
helm repo add flexiwan https://helm.flexiwan.com/flexiedge/
```

You can update the chart repository by running:

```bash
helm repo update
```

### Deploying the chart

```bash
helm install my-release flexiwan/flexiedge
```
> **Tip**: List all releases using `helm list -A`

## Undeploying the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```
The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |


### Common parameters

| Name                | Description                                                                                | Value           |
| ------------------- | ------------------------------------------------------------------------------------------ | --------------- |
| `nameOverride`      | String to partially override multus.fullname template (will maintain the release name) | `""`            |
| `fullnameOverride`  | String to fully override multus.fullname template                                      | `""`            |
| `kubeVersion`       | Force target Kubernetes version (using Helm capabilities if not set)                       | `""`            |
| `clusterDomain`     | Kubernetes Cluster Domain                                                                  | `cluster.local` |
| `extraDeploy`       | Extra objects to deploy (value evaluated as a template)                                    | `[]`            |
| `commonLabels`      | Add labels to all the deployed resources                                                   | `{}`            |
| `commonAnnotations` | Add annotations to all the deployed resources                                              | `{}`            |


### Multus CNI parameters

| Name                 | Description                                                          | Value                     |
| -------------------- | -------------------------------------------------------------------- | ------------------------- |
| `image.registry`     | Multus CNI image registry                                            | `docker.io`               |
| `image.repository`   | Multus CNI image repository                                          | `startechnica/multus`     |
| `image.tag`          | Multus CNI image tag (immutable tags are recommended)                | `1.21.5-debian-10-r3`     |
| `image.pullPolicy`   | Multus CNI image pull policy                                         | `IfNotPresent`            |
| `image.pullSecrets`  | Specify docker-registry secret names as an array                     | `[]`                      |
| `image.debug`        | Set to true if you would like to see extra information on logs       | `false`                   |
| `hostAliases`        | Deployment pod host aliases                                          | `[]`                      |
| `command`            | Override default container command (useful when using custom images) | `[]`                      |
| `args`               | Override default container args (useful when using custom images)    | `[]`                      |
| `extraEnvVars`       | Extra environment variables to be set on Multus CNI containers       | `[]`                      |
| `extraEnvVarsCM`     | ConfigMap with extra environment variables                           | `""`                      |
| `extraEnvVarsSecret` | Secret with extra environment variables                              | `""`                      |



### Exposing the Traefik dashboard

This HelmChart does not expose the Traefik dashboard by default, for security concerns.
Thus, there are multiple ways to expose the dashboard.
For instance, the dashboard access could be achieved through a port-forward :

```bash
kubectl port-forward $(kubectl get pods --selector "app.kubernetes.io/name=traefik" --output=name) 9000:9000
```

Accessible with the url: http://127.0.0.1:9000/dashboard/

Another way would be to apply your own configuration, for instance,
by defining and applying an IngressRoute CRD (`kubectl apply -f dashboard.yaml`):

```yaml
# dashboard.yaml
apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  name: dashboard
spec:
  entryPoints:
    - web
  routes:
    - match: Host(`traefik.localhost`) && (PathPrefix(`/dashboard`) || PathPrefix(`/api`))
      kind: Rule
      services:
        - name: api@internal
          kind: TraefikService
```

Accessible with the url: http://traefik.localhost/dashboard/

## Contributing

If you want to contribute to this chart, please read the [Contributing Guide](./CONTRIBUTING.md).
