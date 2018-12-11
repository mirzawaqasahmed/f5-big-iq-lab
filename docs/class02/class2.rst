Class 2: BIG-IQ Deployment with auto-scale on AWS, Azure & VMware (Cloud Edition)
=================================================================================

In this class, we will review the auto-scale feature available with BIG-IQ 6.0 and above.
called ``Service Scaling Groups`` (SSG)

.. toctree::
   :maxdepth: 1
   :glob:

   intro
   module*/module*

------------

Below Virtual Servers and Pool Members can be used in the context of the  (UDF lab) for this class.

- **Test Web Site:** *(used in module 2)*

==================  ============ ======== ============================ ============
Test Website         VIP         Ports    Servers                      Ports
==================  ============ ======== ============================ ============
site30.example.com   10.1.10.130 443/80   10.1.20.130 and 10.1.20.131  80/8080/8081
==================  ============ ======== ============================ ============

- **Test Web Sites:**

==================  ============ ======== ============================ ============
Test Website         VIP         Ports    Servers                      Ports
==================  ============ ======== ============================ ============
site26.example.com   10.1.10.126 443/80   10.1.20.126 and 10.1.20.127  80/8080/8081
site28.example.com   10.1.10.128 443/80   10.1.20.128 and 10.1.20.129  80/8080/8081
site32.example.com   10.1.10.132 80       10.1.20.132                  80/8080/8081
==================  ============ ======== ============================ ============

- Port 80: hackazon application
- Port 8080: web-dvwa application
- Port 8081: f5-hello-world application
- Port 8082: f5-demo-httpd application
- Port 445: ASM Policy Validator

.. warning:: After starting the blueprint in UDF, connect to the BIG-IP Cluster BOS-vBIGIP01.termmarc.com and BOS-vBIGIP02.termmarc.com, make sure the cluster shows **In Sync**.
