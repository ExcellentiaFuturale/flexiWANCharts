# flexiEdge

`flexiEdge` is core component in the [flexiWAN](https://flexiwan.com/) ECO System.

## Introduction

This chart bootstraps `flexiEdge` as a Kubernetes VM intsnace on top of 
[KubeVirt](https://kubevirt.io/) technology.

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

With the command `kubectl get kubevirt.kubevirt.io/kubevirt -n kubevirt -o=jsonpath="{.status.observedKubeVirtVersion}"`, make sure that you have 

- KubeVirt 0.48.1+

With the command `cat /etc/cni/net.d/00-multus.conf | jq .cniVersion`, make sure that you have:

- Multus CNI 0.3.1+

### Adding Chart Repository

Add flexiEdge's chart repository to Helm:
[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/flexiedge)](https://artifacthub.io/packages/search?repo=flexiedge)

#### For Main

```bash
helm repo add flexiwan https://helm.flexiwan.com/main
```
#### For Testing

```bash
helm repo add flexiwan https://helm.flexiwan.com/testing
```

#### For Unstable

```bash
helm repo add flexiwan https://helm.flexiwan.com/unstable
```

You can update the chart repository by running:

```bash
helm repo update
```

### Deploying the chart

To install the chart with the release name `my-flexiedge`:

```bash
helm install my-flexiedge flexiwan/flexiedge
```
> **Tip**: List all releases using `helm list -A`

### Undeploying the Chart

To uninstall/delete the `my-flexiedge` deployment:

```bash
$ helm delete my-flexiedge
```
The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Common parameters
| Name                | Description                                                                                | Value           |
| ------------------- | ------------------------------------------------------------------------------------------ | --------------- |
| `nameOverride`      | String to partially override flexiedge.fullname template (will maintain the release name)  | `""`            |
| `fullnameOverride`  | String to fully override multus.fullname template                                          | `""`            |


### Image parameters
| Name                | Description                                                                                | Value           |
| ------------------- | ------------------------------------------------------------------------------------------ | --------------- |
| `ImageVersion`      | flexiEdge Docker Image version                                                             | `latest`        |


### Kubernetes parameters
| Name                | Description                                                                                | Value           |
| ------------------- | ------------------------------------------------------------------------------------------ | --------------- |
| `KubernetesAPI`     | Kubernetes API Address                                                                     | `""`            |


| Name                | Description                                                                                | Value           |
| ------------------- | ------------------------------------------------------------------------------------------ | --------------- |
| `nameOverride`      | String to partially override flexiedge.fullname template (will maintain the release name)  | `""`            |
| `fullnameOverride`  | String to fully override multus.fullname template                                          | `""`            |


### flexiEdge parameters

| Name                 | Description                                                          | Value                     |
| -------------------- | -------------------------------------------------------------------- | ------------------------- |
| `flexiedge.token`    | flexiWAN organization token for device registration.                 | `""`                      |

### Kubevirt parameters

| Name                 | Description                                                                                 | Value             |
| -------------------- | ------------------------------------------------------------------------------------------- | ----------------- |
| `kubevirt.name`      | VirtualMachines Name.                                                                       | `flexiedge`       |
| `kubevirt.running`   | VirtualMachines Run Strategies. Determines whether or not there should be a guest running.  | `true`            |
| `kubevirt.memory`    | VirtualMachines Memory allocation (Minimum 4G).                                             | `4096M`           |
| `kubevirt.cpu`       | VirtualMachines VCPU allocation (Minimum 2 cores).                                          | `2`               |
| `kubevirt.mount`     | VirtualMachines Persistent Volume location on the host.                                     | `/mnt`            |

### Network parameters

| Name                                          | Description                                                     | Value                  |
| --------------------------------------------- | --------------------------------------------------------------- | ---------------------- |
| `ethernets.cni0.enabled`                      | Default network interface (mandatory). Can not be disbaled.     | `true`                 |
| `ethernets.cni0.type`                         | Interface type. Valid optional: bridge (mandatory)              | `bridge`               |
| `ethernets.cni0.dhcp`                         | Enable or Disable DHCP (mandatory)                              | `true`                 |
| `ethernets.cni0.dhcproutes`                   | Enable or Disable getting Default Gateway via DHCP (optional)   | `true`                 |
| `ethernets.cni0.address`                      | If DHCP is disable, please provide an IPv4 address (mandatory)  | ``                     |
| `ethernets.cni0.gateway`                      | if DHCP is disable, please provide an IPv4 gateway (optional)   | ``                     |
| `ethernets.cni0.nameservers.search`           | DNS Name Server Search                                          | `flexiwan.local`       |
| `ethernets.cni0.nameservers.search.addresses` | DNS Name Servers                                                | `[8.8.8.8, 1.1.1.1]`   |
| `ethernets.cni1.enabled`                      | Default network interface (mandatory).                          | `true`                 |
| `ethernets.cni1.type`                         | Interface type. Valid optional: sriov, bridge (mandatory)       | `sriov`                |
| `ethernets.cni1.sriov`                        | SRIOV Virtual Function alias (mandatory when using type: sriov) | `smartedge-apps/sriov-vfio-network-c1p1`|
| `ethernets.cni1.dhcp`                         | Enable or Disable DHCP (mandatory)                              | `false`                |
| `ethernets.cni1.dhcproutes`                   | Enable or Disable getting Default Gateway via DHCP (optional)   | `true`                 |
| `ethernets.cni1.address`                      | If DHCP is disable, please provide an IPv4 address (mandatory)  | `192.168.1.1/24`       |
| `ethernets.cni1.gateway`                      | if DHCP is disable, please provide an IPv4 gateway (optional)   | ``                     |
| `ethernets.cni1.nameservers.search`           | DNS Name Server Search                                          | `flexiwan.local`       |
| `ethernets.cni1.nameservers.search.addresses` | DNS Name Servers                                                | `[8.8.8.8, 1.1.1.1]`   |

### Exposing the flexiEdge dashboard

This HelmChart does not expose the flexiEdge dashboard by default, for security concerns.
Thus, there are multiple ways to expose the dashboard.
For instance, the dashboard access could be achieved through a port-forward :

```bash
kubectl port-forward $(kubectl get pods --selector "app.kubernetes.io/name=flexiEdge" --output=name) 8080:80
```

Accessible with the url: http://127.0.0.1:8080/

Another way would be to apply your own configuration, for instance,
by defining and applying an IngressRoute CRD.

## Contributing

If you want to contribute to this chart, please read the [Contributing Guide](./CONTRIBUTING.md).
