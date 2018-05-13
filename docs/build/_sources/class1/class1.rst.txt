Class 1: Application Creation
=============================

In this class, we will review the application creation feature available with BIG-IQ 6.0.

Below Virtual Servers and Pool Members can be used in the context of the  (`UDF lab`_) for this class.

.. _UDF lab: https://udf.f5.com/d/cf3810ee-4e02-4fd1-a0ec-747ee424920a#components

.. warning:: After starting the blueprint in UDF, connect to the BIG-IP Cluster BOS-vBIGIP01.termmarc.com and BOS-vBIGIP02.termmarc.com, make sure the cluster shows **In Sync**.

- **vLab Test Web Site 16:**

=======================================  =========== ==== ============================
Test Website                             VIP         Port Members
=======================================  =========== ==== ============================
site16.example.com *(used in module 4)*  10.1.10.116 80   10.1.20.116 and 10.1.20.117
site16.example.com                       10.1.10.116 443  10.1.20.116 and 10.1.20.117
site16.example.com                       10.1.10.116 8081 10.1.20.116 and 10.1.20.117
=======================================  =========== ==== ============================

- **vLab Test Web Site 18:**

=======================================  =========== ==== ============================
Test Website                             VIP         Port Members
=======================================  =========== ==== ============================
site18.example.com *(used in module 2)*  10.1.10.118 80   10.1.20.118 and 10.1.20.119
site18.example.com *(used in module 2)*  10.1.10.118 443  10.1.20.118 and 10.1.20.119
site18.example.com                       10.1.10.118 8081 10.1.20.118 and 10.1.20.119
=======================================  =========== ==== ============================

- **vLab Test Web Site 20:**

==========================  =========== ==== ============================
Test Website                VIP         Port Members
==========================  =========== ==== ============================
site20.example.com          10.1.10.120 80   10.1.20.120 and 10.1.20.121
site20.example.com          10.1.10.120 443  10.1.20.120 and 10.1.20.121
site20.example.com          10.1.10.120 8081 10.1.20.120 and 10.1.20.121
==========================  =========== ==== ============================

- **Hackazon Test Web Site 22:**

=======================================  =========== ==== ============================
Test Website                             VIP         Port Members
=======================================  =========== ==== ============================
site22.example.com *(used in module 3)*  10.1.10.122 80   10.1.20.122
=======================================  =========== ==== ============================

.. toctree::
   :maxdepth: 1
   :glob:

   intro
   module*/module*
