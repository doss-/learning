# Welcome to MkDocs

For full documentation visit [mkdocs.org](http://mkdocs.org).

## Commands

* `mkdocs new [dir-name]` - Create a new project.
* `mkdocs serve` - Start the live-reloading docs server.
* `mkdocs build` - Build the documentation site.
* `mkdocs help` - Print this help message.

## Project layout

    mkdocs.yml    # The configuration file.
    docs/
        index.md  # The documentation homepage.
        ...       # Other markdown pages, images and other files.

# 12 factor apps

[12factor.net](https://12factor.net/)

# 8 Fallacies of Distributed Systems

[Understanding the 8 Fallacies of Distributed Systems ](https://dzone.com/articles/understanding-the-8-fallacies-of-distributed-syste)  
[original pdf](http://rgoarchitects.com/Files/fallacies.pdf)

## The network is reliable

it is not, and packets could be lost, so there is need of Error handling  
and retries after the packet lost and error occured\connection loss

## Latency is zero

latency is a thing, and computers are not close to each other. Sometimes things could be mirrored in different regions.  
Number of network requests need to be as little as possible, to minimize latency timings - the less requests goes through the network with unknown latency, the faster overall things would be

## Badnwidth is infinite

Bandwidth (channel width) is limited, and huge amount of data will take longer to transfer.  
Also when service gets requests from lots of clients, some clients could send lots of requests which will be transformed in network being to busy, so other clients will get no space.  
In this case some throtelling should be applied, and such clients at some moment need to be denied, so there will be network space for others to made a request.
Send small payloads - do not send huge packets with requests, send small ones so they will get through physicall wire faster, kind of

## The network is secure

Network inside even a single cluster is Insecure, so even the services located in secured network should use authentication.  
Especially in case when services are running some 3rd party code or libraries or stuff like that, which could send some requests over the network, when they should not be allowed to.

## Topology does not change

Orchestrator (tool which will keep all the services ap and running, restarted and scaled) could change topology - some services could be spawned eleswhere, on the different pc, rack or even availability zone, this will affect the Topology

## There is one administrator

There are lots of administrators - people and automated tools\scripts, so something that is considered by you as Immutable (eg. IP:port) could be changed by someone w/o your knowlege.  
Things like that need to be monitored, and all the updates should be visible and all the notifications or even automated changes should be done.

## Transport cost is zero

Usually transporting traffic in and out of datacenter costs a performance.  
Also transport could cost money, as datacenters could charge users for that metric

## The network is homogeneous

The network could consist of different hardware used such as routers, switches(manufacturer or model or age) and even the wire - fibre or copper etc.  
This could be applied to datacenter itself, or segment between datacenters where user's services are mirrorred, or anywhere on the way
