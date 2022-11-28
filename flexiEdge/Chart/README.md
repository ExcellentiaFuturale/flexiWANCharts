# flexiEdge

`flexiEdge` is core component in the [flexiWAN](https://flexiwan.com/) ECO System.

[flexiWAN](https://flexiwan.com/) provides unique networking technology and open architecture for SD-WAN & SASE.
It's disrupts and democratizes the SD-WAN and SASE market with its 3 world First SD-WAN & SASE Open Source, First application store for SD-WAN & SASE, and First SaaS business model for SD-WAN & SASE

In addition to being a complete solution, flexiWAN removes vendor lock-in and breaks networking monopolies by slicing SD-WAN horizontally allowing for dynamic 3rd party applications (Smartphone concept) to be loaded and run in the data flow of the router or in the cloud management system.

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

### Application Description

As Kubernetes containerized platforms become the next generation universal platform for Edge and Networking. The integration of flexiWAN makes it easy for Service Providers, ISVs, and SIs to onboard this technology and offer services based on it.
This Helm Chart installs a flexiEdge networking Edge instance for secure connectivity supporting scenarios such as branch-to branch, branch-to-PoP, or remote user to branch offices or PoP.

The application is centrally managed from the cloud using flexiManage.  It enhances the traffic availability, quality and security in the network.

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

### Image parameters

| Name                | Description                                                                                | Value           |
| ------------------- | ------------------------------------------------------------------------------------------ | --------------- |
| `ImageVersion`      | flexiEdge Docker Image version                                                             | `latest`        |

### Kubernetes parameters

| Name                | Description                                                                                | Value           |
| ------------------- | ------------------------------------------------------------------------------------------ | --------------- |
| `KubernetesAPI`     | Kubernetes API Address                                                                     | `""`            |

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

## Example

The following example provide a way to deploy flexiEdge with the following parameters:

- Name: flexiwan
- Ethernet interface:
- CNI0 as calico interface with no dhcp router in disable mode
- CNI1 as SRIOV interface assign to sriov-vfio-network-c1p1 with manual IP configuration (172.16.0.2/29 and Gateway 172.16.0.1)
- Token: ************************

```bash
helm install flexiwan flexiwan/flexiedge  --set ethernets.cni0.dhcproutes=false --set ethernets.cni1.type=sriov --set ethernets.cni1.sriov=smartedge-apps/sriov-vfio-network-c1p1 --set ethernets.cni1.dhcp=false --set ethernets.cni1.address=172.16.0.2/29 --set ethernets.cni1.gateway=172.16.0.1 –flexiwan.token=”*******************************************************”

NAME: flexiedge
LAST DEPLOYED: Sun Aug 28 16:40:24 2022
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
==========================================================================
Thank you for using flexiWAN - The World’s First Open Source SD-WAN & SASE
==========================================================================

1. flexiEdge is now running on your Kubernetes cluster

2. NOTE: It may take a few minutes for the VM to be available.
   You can watch the status of by running 'kubectl get --namespace my-flexiedge vmi -w'

3. To uninstall helm chart use the command:
   helm delete my-flexiedge

---------
```

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

### Uninstall the Chart

In order to delete flexiWAN simply run the following comman

```
$ helm uninstall my-flexiedge
release "my-flexiedge" uninstalled
```

## Troubleshooting

To troubleshoot the Helm Chart installation process:

- First make sure the Helm is deployed:

```bash
$ helm list
NAME            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
flexiedge       default         1               2022-08-28 18:27:28.471894243 +0000 UTC deployed        flexiedge-0.0.1 latest

```

- Check if the virt-launcher Pod is running

```bash
$ get pod -n flexiedge
NAME                            READY   STATUS    RESTARTS   AGE
virt-launcher-flexiedge-kxrft   1/1     Running   0          2m6s
```

- Check if the VMI is running

```bash
$ kubectl get vmi -n flexiedge
NAME        AGE     PHASE     IP              NODENAME            READY
flexiedge   2m47s   Running   10.245.14.167   ubuntu-4042ff21dd   True
```

- Access the VM via the Virtual Console (default user: admin, default password: flexiwan)
```bash
$ virtctl console flexiedge -n my-flexiedge
Successfully connected to flexiedge console. The escape sequence is ^]

Ubuntu 18.04 LTS flexiedge ttyS0

flexiedge login:

```

To troubleshoot flexiWAN issues refer to the troubleshooting guide [here](https://docs.flexiwan.com/troubleshoot/overview.html)

## Additional Information

After deploying flexiWAN, follow the documentation steps [here](https://docs.flexiwan.com/management/management-login.html) to complete the configuration.
Related material

https://flexiwan.com/
https://flexiwan.com/academy/
https://docs.flexiwan.com/

## Contributing

If you want to contribute to this chart, please read the [Contributing Guide](./CONTRIBUTING.md).
