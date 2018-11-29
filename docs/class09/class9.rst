Class 9: BIG-IQ Access Policy Manager (APM)
===========================================

.. note:: On this page there is no actions to be done here regarding the lab itself

In this class, we will review the access management and access application creation feature available with BIG-IQ 6.0.1.

Below Virtual Servers and Pool Members can be used in the context of the  (UDF lab) for this class.

.. warning:: After starting the blueprint in UDF, connect to the BIG-IP Cluster BOS-vBIGIP01.termmarc.com and BOS-vBIGIP02.termmarc.com, make sure the cluster shows **In Sync**.

- **Test Web Sites:** *(used in module 1)*

======================  ============ ======== ============================ ============
Test Website            VIP          Ports    Servers                      Ports
======================  ============ ======== ============================ ============
site17auth.example.com  10.1.10.117  443      10.1.20.123 and 10.1.20.124  80/8081
======================  ============ ======== ============================ ============
site19auth.example.com  10.1.10.119  443      10.1.20.125 and 10.1.20.133  80/8081
======================  ============ ======== ============================ ============

- **Test Web Site:**

======================  ============ ======== ============================ ============
Test Website            VIP          Ports    Servers                      Ports
======================  ============ ======== ============================ ============
site21auth.example.com  10.1.10.121  443      10.1.20.134 and 10.1.20.135  80/8081
======================  ============ ======== ============================ ============

- Port 80: hackazon application
- Port 8080: web-dvwa application
- Port 8081: f5-hello-world application
- Port 8082: f5-demo-httpd application
- Port 445: ASM Policy Validator

.. toctree::
   :maxdepth: 1
   :glob:

   intro
   module*/module*
