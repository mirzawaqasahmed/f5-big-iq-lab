Class 3: Analytics
==================

In this class, we will review the various analytics available for the applications and Service Scaling Group objects in BIG-IQ 6.0.

Below Virtual Servers and Pool Members can be used in the context of the  (`UDF lab`_) for this class.

.. _UDF lab: https://udf.f5.com/d/cf3810ee-4e02-4fd1-a0ec-747ee424920a#components

.. warning:: After starting the blueprint in UDF, connect to the BIG-IP Cluster BOS-vBIGIP01.termmarc.com and BOS-vBIGIP02.termmarc.com, make sure the cluster shows **In Sync**.

- **vLab Test Web Site 36:**

=======================================  =========== ==== ============================
Test Website                             VIP         Port Members
=======================================  =========== ==== ============================
site36.example.com                       10.1.10.136 80   10.1.20.136 and 10.1.20.137
site36.example.com *(used in module 2)*  10.1.10.136 443  10.1.20.136 and 10.1.20.137
site36.example.com                       10.1.10.136 8081 10.1.20.136 and 10.1.20.137
=======================================  =========== ==== ============================

- **vLab Test Web Site 38:**

=======================================  =========== ==== ============================
Test Website                             VIP         Port Members
=======================================  =========== ==== ============================
site38.example.com                       10.1.10.138 80   10.1.20.138 and 10.1.20.139
site38.example.com                       10.1.10.138 443  10.1.20.138 and 10.1.20.139
site38.example.com                       10.1.10.138 8081 10.1.20.138 and 10.1.20.139
=======================================  =========== ==== ============================

- **vLab Test Web Site 40:**

========================================  =========== ==== ============================
Test Website                              VIP         Port Members
========================================  =========== ==== ============================
site40.example.com  *(used in module 2)*  10.1.10.140 80   10.1.20.140 and 10.1.20.141
site40.example.com                        10.1.10.140 443  10.1.20.140 and 10.1.20.141
site40.example.com                        10.1.10.140 8081 10.1.20.140 and 10.1.20.141
========================================  =========== ==== ============================

- **Hackazon Test Web Site 42:**

=======================================  =========== ==== ============================
Test Website                             VIP         Port Members
=======================================  =========== ==== ============================
site42.example.com *(used in module 2)*  10.1.10.142 80   10.1.20.142
=======================================  =========== ==== ============================

.. toctree::
   :maxdepth: 1
   :glob:

   intro
   module*/module*
