Class 7: BIG-IQ Application Firewall Manager (AFM)
==================================================

In this class, we will review the managing F5 Advanced Firewall Manager deployments in BIG-IQ 6.0 and above.

.. toctree::
   :maxdepth: 1
   :glob:

   intro
   module*/module*

------------

Below Virtual Servers and Pool Members can be used in the context of the (UDF lab) for this class.

.. warning:: After starting the blueprint in UDF, connect to the BIG-IP Cluster BOS-vBIGIP01.termmarc.com and BOS-vBIGIP02.termmarc.com, make sure the cluster shows **In Sync**.


- **Test Web Site 18:** *(used in module 1)*

==================  ============ ======== ============================ ============
Test Website         VIP         Ports    Servers                      Port
==================  ============ ======== ============================ ============
site18.example.com   10.1.10.118 443/80   10.1.20.118 and 10.1.20.119  80/8080/8081
==================  ============ ======== ============================ ============

- Port 80: hackazon application
- Port 8080: web-dvwa application
- Port 8081: f5-hello-world application
- Port 8082: f5-demo-httpd application
- Port 445: ASM Policy Validator
