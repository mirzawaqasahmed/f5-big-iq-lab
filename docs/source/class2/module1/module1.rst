Module 1: Setup a Service scaling group (SSG)
=============================================

In this module, we will learn about the ``Service Scaling Group`` (SSG) feature
provided with BIG-IQ 6.0

The ``Service Scaling Group`` (SSG) gives us the capability to setup a cluster of BIG-IPs
that will scale based on criterias defined by the administrator.

Topology of Service Scaling Group
---------------------------------

With BIG-IQ 6.0, the ``Service Scaling Group`` is composed of 2 tiers of ADCs.
Depending on the environment, the implementation of the ``Service Scaling Group``
(SSG) will differ.

============= =========== ==============
 Environment     Tier1         Tier2
============= =========== ==============
   AWS            ELB         F5 VE
   VMWARE        F5 ADC       F5 VE
============= =========== ==============

Here is an example of topology of SSD deployment on top of VMWare:

.. image:: ../pictures/module1/img_module1.png
  :align: center
  :scale: 50%

.. warning:: We need a topology schema for VMWare and ELB. The reason is that
    with AWS, our VE will be deployed as a single nic interface and it may not
    be the case with VMWare

Tier1 management - how does this work ?
---------------------------------------

With BIG-IQ 6.0, the provisioning and deployment of Tier1 has to be done
upfront by the administrator. It means that:


* The F5 platform (or AWS ELB) will have to be provisioned, licensed (for F5 VE)
  and its networking configuration done
* Once the platform is ready. everything related to app deployment will be
  handled by BIG-IQ


.. note:: with BIG-IQ 6.0, we only support F5 Virtual edition for tier1.
  With BIG-IQ 6.0.1, we will support F5 HW also.

.. warning:: Depending on the exec commit of 6.1, it would be good to say whether
  6.1 will automate tier1 deployment or not

Tier2 management - how does this work ?
---------------------------------------

With BIG-IQ 6.0, the provisioning of tier2 BIG-IPs is fully automated. You
don't have to setup anything upfront but licenses for BIG-IQ to assign to the
dynamically provisioned BIG-IPs

To handle the provisioning and onboarding of our F5 virtual edition, we leverage
different components:

* ansible playbooks to handle the provisioning of our F5 virtual edition
* our F5 cloud deployment templates

  * `F5 Vmware template <https://github.com/F5Networks/f5-aws-cloudformation>`_
  * `F5 AWS template <https://github.com/F5Networks/f5-vmware-vcenter-templates>`_

* f5 cloud libs

  * ` F5 cloud libs <https://github.com/F5Networks/f5-cloud-libs>`_

Application deployment in a SSG - VMWARE
----------------------------------------

To ensure the traffic goes through the SSG as expected, application will be
deployed in a certain manner:

* When the app is deployed from BIG-IQ, it will receive a Virtual server IP.
* This VS IP will be configured:

  * On all Tier 2 VEs. This IP will be used to setup the relevant ADC config
    on all the Virtual edition sitting on tier2. They will have have an
    **identical** Setup
  * On the tier 1 cluster. BIG-IQ will setup a virtual server with the same IP
    and the following configuration

      * address translation will be disabled
      * the pool members for this app will be the Tier2 BIG-IP Self-IPs
      * the pool monitor will be **XXXXXXXXXXXXXXXXX**

.. warning:: we need to update this base on the discussion that will happen
    with PM/PD this week



.. warning:: Need a schema of the app setup on SSG for VMWARE

Application deployment in a SSG - AWS
-------------------------------------

To ensure the traffic goes through the SSG as expected, application will be
deployed in a certain manner:

.. warning:: Need a schema of the app setup on SSG for AWS

In this lab, we will create a ``Service Scaling Group`` in a VMWare environment

.. toctree::
   :maxdepth: 1
   :glob:

   lab*
