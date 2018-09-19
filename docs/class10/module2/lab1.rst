Lab 1.1: Adding a BIG-IP DNS device to existing Sync Group
-----------------------------------------------------------
In order for a BIG-IP DNS to be added to a sync group, the following objects must first be created on each device:

* Data Center
* Server Object
* Listener 

In this lab, we will create necessary objects for a DNS Sync Group test

Data Center setup
******************

BIG-IP DNS data centers represent a group of services or applications that reside in a specific geographic location. BIG-IP DNS systems use pools to represent and monitor the availability of each service or application. To direct application traffic to a primary data center, the wide IPs configured to use Global Availability load balancing mode respond to DNS name resolution requests using the IP addresses of available pools in the primary data center.

Data center failover is the process of changing the IP addresses that the wide IP uses when answering DNS name resolution requests from those of the primary pool in one data center to those of a secondary pool in another data center.

All BIG-IP DNS systems in a configuration synchronization (ConfigSync) group receive requests for DNS name resolution; however, when responding to DNS name resolution requests, the wide IP uses only the IP addresses of primary and available pools.

To create your Data Center(s) go to *xxx* > *xxx*, it should look like this:

.. image:: ../pictures/module1/img_module1_lab11_x.png
  :align: center
  :scale: 50%

|

Server Object setup
********************

Blurb about Server object 

For our lab, we will need two BIG-IP DNS devices:

To create your Server Objects go to *xxx* *xxx*, it should look like this:

* BIG-IPDNS01
* BIG-IPDNS02

.. image:: ../pictures/module1/img_module1_lab11_xx.png
  :align: center
  :scale: 50%


Listener Object creation
*************************

Blurb about listeners 

To create your Listeners, go to *xxx* > *xxx* and click on *xxx*

you should see this:

.. image:: ../pictures/module1/img_module1_lab11_xxx.png
  :align: center
  :scale: 50%

|


Click on the button *Save & Close*, Click on the button *Save & Close* again

You should see your ``XXX`` available now.
