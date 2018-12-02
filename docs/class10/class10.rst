Class 10: BIG-IQ DNS
====================

In this class, we will review the DNS Management in BIG-IQ 6.0 and above.

.. toctree::
   :maxdepth: 1
   :glob:

   intro
   module*/module*

------------

Below Virtual Servers and Pool Members can be used in the context of the  (UDF lab) for this class.

.. warning:: After starting the blueprint in UDF, connect to the BIG-IP Cluster BOS-vBIGIP01.termmarc.com and BOS-vBIGIP02.termmarc.com, make sure the cluster shows **In Sync**.

==================================  ===========
Test Listeners                      Ports
==================================  ===========
10.1.10.203 *(Boston Cluster)*      53 UDP
10.1.10.204                         53 UDP
==================================  ===========
