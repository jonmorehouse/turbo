# Turbo - cross region, multi cluster Google Cloud Infrastructure

A [terraform module](https://github.com/hashicorp/terraform) for building multi-region infrastructure on Google Cloud.

## Introduction

Building modern infrastructures involve creating multiple isolated clusters across multiple zones or regions. Turbo is an attempt at making some opinionated decisions on the way the network boundaries are built, while giving users the ability to choose technologies such as a scheduler, container runtime, service discovery runtime and routing runtime.

Turbo provisions 4 clusters, as well as a set of bastion instances. It provides security by isolating clusters based upon responsiblity. Turbo exposes an interface, via `terraform` for configuring your infrastructure.

## Cluster Concept

Before digging into the internals of a cluster within `turbo`, its important to build a conceptual model of what a `cluster` is. A cluster is a single purpose, isolated set of instances across a custom set of zones and regions. There are 4 types of clusters in `turbo`: **coordination**, **core**, **service** and **public**. Below is a description of each cluster's responsibilities:

* **coordination** - coordination/service discovery systems that are fundamental to an infrastructure. This is normally just a service discovery/coordination system such as [etcd](https://github.com/coreos/etcd) or [consul](https://github.com/hashicorp/consul).
* **core** - systems that the service layer relies on, but benefit from isolation. Examples include a container scheduler such as [nomad](https://github.com/hashicorp/nomad) or [kubernetes](https://github.com/kubernetes/kubernetes) and other fundamental services such as distributed logging, messaging, and core communication tools.
* **service** - service layer for running services in isolation. For most setups this will be the **node** layer which the scheduler schedules against.
* **public** - the public facing layer, which is usually just a shim providing routing to services in other layers. For instance, tools such as [fabio](https://github.com/ebay/fabio) or [gatekeeper](https://github.com/jonmorehouse/gatekeeper) can be scheduled in this layer to route public traffic.

By default, `turbo` configures these clusters with reasonable defaults. Future projects will include more fully fleshed out infrastructures such as a [consul](https://github.com/hashicorp/consul) [nomad](https://github.com/hashicorp/nomad) and [gatekeeper](https://github.com/jonmorehouse/gatekeeper.) setup.

For custom use cases, `turbo` exposes a set of underlying `terraform` modules which the [turbo module](https://github.com/jonmorehouse/turbo/tree/master/turbo) itself uses. For more advanced use cases, it is possible to simply reference the various cluster configuration to create additional clusters.

## Cluster Networking

Each cluster in `turbo` consists of a single network, which spans a configurable number of zones across a configurable number of regions. Each zone presides in its own subnetwork range and all instances created in the zone are addressed in the subnetwork.

`turbo` exposes networking configuration to expose `UDP` and `TCP` ports/port-ranges to other clusters (aka, the coordination cluster allows TCP traffic over port 3500 from the scheduler cluster). Behind the scenes, [network firewalls]() are configured to accept traffic from the proper instances from the source clusters. `turbo` also exposes the ability to open traffic to cidr block ranges and public traffic. This is useful if for instance, you wanted to configure VPC peering, or expose any part of your cluster for any region.

## Cluster Compute Resources

There are primarily _two_ types of clusters: `static` and `dynamic`.

A `dynamic` cluster allows a maximum and minimum number of instances to maintain per zone. Behind the scenes, an [instance template]() [instance group] [group manager] and [autoscaler] are created to dynamically spin up and down instances in response to CPU.

All zones are load balanced internally by a [target pool]() resource which is responsible for protocol forwarding and load balancing between instances in the zone over both `UDP` and `TCP`.

**Note** some systems can have a primary and secondary zone which is only used in failover instances. Then at the DNS or service discovery level, they can choose which Region to route to either by picking the closest data center or having DNS load balancer / propagate. `Turbo` doesn't attempt to make decisions about how traffic is routed between regions at this point, in order to provide maximum flexibility.

## Cluster Bootstrapping

Because `turbo` doesn't make any opinions about the software that is actually installed on each instance in each unique cluster, it exposes three hooks for configuring each cluster: `bootstrap` `node_startup` and `node_shutdown`. Users of `turbo` are responsible for providing scripts which install and start the

An example of this in practice, is demonstrable by imagining bootstrapping a service discovery cluster in the `coordination` cluster. By providing a `startup` script, each node in a `turbo` cluster can bootstrap itself. Once each service has been started and has finished bootstrapping, the `bootstrap` script is executed from a random host in each zone in the cluster. This makes it permissible to for instance, bootstrap a set of nodes in a service discovery cluster and then follow up by bootstrapping the entire cluster.

## Usage

```tf
# coordination cluster
provider "google" {
  project = "foo"
  region  = "us-east1"
}

module "foo" {
  source = "./turbo"

  name   = "foo"

  // coordination cluster configuration
  coordination_instances_per_zone = 1

  coordination_zones = {
    "us-west1" = "us-west1-a,us-west1-b"
    "us-central1" = "us-central1-a"
  }

  coordination_failover_zones = {
    "us-west1-a" = "us-west1-b"
    "us-west1-b" = "us-west1-a"
  }



  // core cluster configuration
}

```

