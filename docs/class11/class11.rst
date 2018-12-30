Class 11: BIG-IQ DDoS Monitoring and Dashboard
==============================================

**[New 6.1.0]** 

In this class, we will review new DDoS Dashboard view, protection summary, and DDoS Event logging and correlation. 

.. toctree::
   :maxdepth: 1
   :glob:

   intro
   module*/module*
------------

For simplicity, UDP attack traffic will be generated against both DNS virtual servers and device wide DoS: additional attacks can be done using the client nodes at the discretion of the student. 

This class only requires the two BOS BIG-IPs, BIG-IQ CM and DCD, and the LAMP server. ESXi along with the other BIG-IPs do not need to be running.



The following DNS Virtual Server is already created and will be used as an attacked destination in these labs:

==================================  ===========
Test Listeners                      Ports
==================================  ===========
10.1.10.203 *(Boston Cluster)*      53 UDP
==================================  ===========



