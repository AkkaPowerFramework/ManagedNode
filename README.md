# AkkaPowerFramework ManagedNode

Scripts and source code to create and configure a managed Node for the [AkkaPowerFramework](https://github.com/AkkaPowerFramework).

This is the only component that needs to be "traditionally" installed on the Docker host and manages the installation of Framework Services. It is the only component that isn't implemented as a Docker container. It is also the only component needed to be installed to add resources to a Cluster.

## Akka Power Framework

AkkaPowerFramework is a micro service framework that extense the C# .net port of the Akka Framework [Akka.net](https://getakka.net) to build highly concurrent, distributed and fault tolerant event-driven application.
