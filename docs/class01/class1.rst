Class 1: BIG-IQ Application Creation and AS3 (Cloud Edition)
============================================================

In this class, we will review the application creation feature available with BIG-IQ 6.0 and above.

.. toctree::
   :maxdepth: 1
   :glob:

   intro
   module*/module*

------------

Below Virtual Servers and Pool Members can be used in the context of the  (UDF lab) for this class.

- **Test Web Site:** *(used in module 4)*

==================  ============ ======== ============================ ============
Test Website         VIP         Ports    Servers                      Ports
==================  ============ ======== ============================ ============
site16.example.com  10.1.10.116  443/80   10.1.20.116 and 10.1.20.117  80/8080/8081
==================  ============ ======== ============================ ============

- **Test Web Site:** *(used in module 2 and class 7)*

==================  ============ ======== ============================ ============
Test Website         VIP         Ports    Servers                      Port
==================  ============ ======== ============================ ============
site18.example.com  10.1.10.118  443/80   10.1.20.118 and 10.1.20.119  80/8080/8081
==================  ============ ======== ============================ ============

- **Test Web Sites:** *(used in module 3)*

==================  ============ ======== ============================ ============
Test Website         VIP         Ports    Servers                      Ports
==================  ============ ======== ============================ ============
site20.example.com  10.1.10.120  443/80   10.1.20.120 and 10.1.20.121  80/8080/8081
site22.example.com  10.1.10.122  80       10.1.20.122                  80/8080/8081
==================  ============ ======== ============================ ============

- **Test Web Sites:** *(used in module 5)*

==================  ============ ======== ============================ ============
Test Website         VIP         Port     Server                       Ports
==================  ============ ======== ============================ ============
site11.example.com  10.1.10.111  443/80   10.1.20.110 and 10.1.20.111  80/8080/8081
site13.example.com  10.1.10.113  443/80   10.1.20.112 and 10.1.20.113  80/8080/8081
site23.example.com  10.1.10.123  443/80   10.1.20.123 and 10.1.20.124  80/8080/8081
site24.example.com  10.1.10.124  443/80   10.1.20.124 and 10.1.20.125  80/8080/8081
site25.example.com  10.1.10.125  8080     10.1.20.125 and 10.1.20.126  80/8080/8081
site27.example.com  10.1.10.127  443/80   10.1.20.127 and 10.1.20.128  80/8080/8081
site29.example.com  10.1.10.129  443/80   10.1.20.129 and 10.1.20.130  80/8080/8081
site31.example.com  10.1.10.131  443/80   10.1.20.131 and 10.1.20.132  80/8080/8081
site33.example.com  10.1.10.133  443/80   10.1.20.133 and 10.1.20.134  80/8080/8081
site34.example.com  10.1.10.134  443/80   10.1.20.134 and 10.1.20.135  80/8080/8081
==================  ============ ======== ============================ ============

- Port 80: hackazon application
- Port 8080: web-dvwa application
- Port 8081: f5-hello-world application
- Port 8082: f5-demo-httpd application
- Port 445: ASM Policy Validator

.. warning:: After starting the blueprint in UDF, connect to the BIG-IP Cluster BOS-vBIGIP01.termmarc.com and BOS-vBIGIP02.termmarc.com, make sure the cluster shows **In Sync**.