Class 3:  BIG-IQ Analytics
==========================

.. note:: On this page there is no actions to be done here regarding the lab itself

In this class, we will review the various analytics available for the applications and Service Scaling Group objects in BIG-IQ 6.0.

Below Virtual Servers and Pool Members can be used in the context of the  (`UDF lab`_) for this class.

.. _UDF lab: https://udf.f5.com/d/cf3810ee-4e02-4fd1-a0ec-747ee424920a#components

.. warning:: After starting the blueprint in UDF, connect to the BIG-IP Cluster BOS-vBIGIP01.termmarc.com and BOS-vBIGIP02.termmarc.com, make sure the cluster shows **In Sync**.

- **vLab Test Web Site 36:** *(used in module 2)*

==================  ============ ======== ============================ =======
Test Website         VIP         Ports    Servers                      Ports
==================  ============ ======== ============================ =======
site36.example.com   10.1.10.136 443/80   10.1.20.136 and 10.1.20.137  80/8081
==================  ============ ======== ============================ =======

- **vLab Test Web Site 38:**

==================  ============ ======== ============================ =======
Test Website         VIP         Ports    Servers                      Ports
==================  ============ ======== ============================ =======
site38.example.com   10.1.10.138 443/80   10.1.20.138 and 10.1.20.139  80/8081
==================  ============ ======== ============================ =======

- **vLab Test Web Site 40:** *(used in module 2)*

==================  ============ ======== ============================ =======
Test Website         VIP         Ports    Servers                      Ports
==================  ============ ======== ============================ =======
site40.example.com   10.1.10.140 443/80   10.1.20.140 and 10.1.20.141  80/8081
==================  ============ ======== ============================ ======

- **vLab Test Web Site 42:** *(used in module 2)*

==================  ============ ======== ============================ =======
Test Website         VIP         Port     Server                       Ports
==================  ============ ======== ============================ =======
site42.example.com   10.1.10.142 80       10.1.20.142                  80/8081
==================  ============ ======== ============================ =======

.. toctree::
   :maxdepth: 1
   :glob:

   intro
   module*/module*
