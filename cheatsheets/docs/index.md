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

# Microservices

To use a mircoservices we need to convert usual methods into network calls,  
 together with parameters of the methods, which also need to be [de]serializable  
and result , returned by the method also need to be serializable.


    var result = Method(arg1, arg2);

> __result__ and __args__ need to be serialized and deserialized byt client and server  
Method need to be Explicit, Language agnostic, multiversion API contract.   

Which means name would be used on different sides(server and client), in different languages, and whole the signature will require lots of changes on both sides.  

Also the method signature will not be shown in IntelliSense anymore because it is not in referenced library anymore, it is just simple Network call (which could be wrapped into library but this will require extra work)

Serializable narrows amount of Types we could use (only serializable ones),  
 and the process of serialization of language-specific object into serializable data type, such as JSON, XML, Avro, YAML, so on, takes CPU and RAM

Sometimes serialization of types, especially if they support reflection, could use 90+% of the resources used by the service\app.

## Inprocess method call vs Network request

 - Performance - Worse:  
Increases network congestion, means that it adds to network traffic  
Unpredictable timing, in-process call could take microseconds, and Network call could take seconds and could even fail on timeout - need to expect it and be ready to handle.

 - Unreliable:  
Requires retries, timeouts and circuit breakers.  
Circuit breaker is when client tries to communicate with a server, and if it fails to connect\communicate for X consecutive times(e.g. 5) it will no longer try for Y amount of time, or otherwise it will became a DDoS attacker of own server. This loop(try 5 times, wait 1 minute) will continute until server is available again - then circuit breaker will exit and allow traffic to move on.  
Circuit breaker - client logic mostly  
But server also need to count whether it answered, and if yes - do not send same answers for requests made because of circuit breaker still not exited and sending more requests, that already have been answered

 - Security:  
When method was in a single process, there was no need of security, authentication and encryption.  
But now Parameters and Results are sent over the network, those need to be encrypted  
Now anyone could call this Method, which become Network call, so only authorized clients need to be served

 - Diagnostics:  
Calls are now are done over the network, instead of being in-process before, so there is latency now.  
Events and logs are now generated by all the tools and apps, like web servers, proxies, encryptors, virtual machines.  
Call stack is now split over the network and potentially lots of machines, you cant just view it in Debug mode like before, or go to Method implementation by F12(F11 in VS?)  
Clocks are not fully synchorized, use UTC in the cluster.   
But even with same UTC some machines could slow down or pace too fast, so there could be situation when Client sent a request at 00.01 by clien's time and server received it by 23.59 by server's time.  
So during logs examination this need to be taken into account.


# Idempotent operation

Operation which could be performed 2+ times witn no ill effect.

Example:

> Method call to the server, with an image as a parameter, and the server produces thumbnail(preview of the image) and returns it to the client.  
This oparation could be performed 2+ times with the same exact image and the server will return the same exact thumbnail every time. Without any _ill_ effect.

**Services MUST implement operations idempotently**

Servers need to make sure that operation is idempotent.

Example:

> Method adds $100 to an account by creating a request, it does this in a circuit breaker loop, but after server accepts the call, method sends another one. If server will accept all such calls - account will have more than $100.  
So server should check whether the call was processed, and if so - deny all the same calls being done afterwards.  
Which will be a State corruption.

So the Client need to send the requests in loop manner, to make sure message is sent and received.

The Server need to make sure idempotentcy - so every request received from the Client will be idempotent - Client could call method 2+ times _with no ill effect_

## Idempotant CRUD operations



|   |Operation   | HTTP Verb   | What to do  |
|---|---|---|---|
|C   | id = Create()   | POST   | see pattern below   |
|R   | data = Read(id)  | GET/HEAD/OPTIONS/TRACE   | Naturally idempotent  |
|U   | Update(id, data)  | PUT   | Last writer wins   |
|D   | Delete(id)  | DELETE   | if already done OK   |

Idempotency pattern:

![picture](/home/dos/git/learning/cheatsheets/docs/img/idempotency_CRUD.jpg)

- Client: asks server to create unique ID **or** client(_trusted_) creates ab ID

> some unique ID like GUID is created by the server on clients request, this is more trustfull way, but adds network latency.  
Client could create ID on its own, w/o network communication, but it needs to be Unique, so Server need to _Trust_ the client on that matter.  
This could be retried, but only last ID matters, all other previous IDs should be thrown away

- Client: sends ID & desired operation to server

> Client then sends POST asking Server to add $100 to the account.  
This also could be retried, as we are talking about idemtotency here

- Server: if ID is new, do the operation and log the ID, respond OK

> **Must be transactioned(atomic) operation**  
This is important to keep idempotency: if Client sends operation +$100, and Server checked in the Log for the ID, start doing the operation, and Client sends the retry - Server will start 2nd operation, because 1st is still ongoing and ID is not yet logged.  
On the other hand if Search and then Log the ID, server could crash on the execution of the operation, and will not perform the operation at all.  
So the atomic 'Search-for-ID; Perform-operation; Log-the-ID' operation is important. Otherwise it will not guaranteed to be **Idempotent**.
