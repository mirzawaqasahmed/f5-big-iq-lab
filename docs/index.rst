F5 Cloud Edition / BIG-IQ Lab - Index
=====================================

Welcome
-------

Welcome to the |classbold| lab - |year|

|repoinfo|

There is lab environment available in UDF and Ravello (Oracle Public Cloud) for internal F5 users as well as Partners (please feel free to contact an `F5 representative`_).

This lab environment `UDF Lab`_ (internal) is designed to allow for quick and easy demos of a significant portion of the BIG-IQ product.

.. _F5 representative: https://f5.com/products/how-to-buy#3013

.. image:: ./pictures/diagram_udf.png
  :align: center
  :scale: 50%

**List of instances**:

- BIGIQ <> DCD
- 3x BIG-IP 13.1.0.5 / 1 standalone (Seattle), 1 cluster (Boston)
- 1x BIG-IP 12.1.0 / 1 standalone (Tel Aviv)
- LAMP Server - Radius, DHCP, RDP, Application Servers (Hackazon, dvmw, f5 demo app), Traffic Generator (HTTP, ACCESS, DNS, SECURITY).

**Components available**:

- "System" - Manage all aspects for BIG-IQ, 
- "Device"  - Discover, Import and manage BIGIP devices. 
- "Configuration" - ADC, Security (ASM config/monitoring, AFM config, FPS monitoring.)
- "Deployment" - Manage evaluation task and deployment.
- "Monitoring" - Event collection per device, statistics monitoring, iHealth reporting integration, alerting, and audit logging.
- "Application" - Application Management (Cloud Edition)

.. warning:: When using the `UDF Lab`_, make sure:

  1. STOP the ESXi if you do not plan to demo VMware SSG.
  2. STOP your deployment at the end of your demo.
  3. Do not forget to tear down your AWS SSG if any.
  4. In case of demonstrating VMware SSG, use only Arizona, Virginia or Frankfurt region to get go performance.

.. _UDF Lab: https://udf.f5.com/b/ffc0a2a4-7953-473a-8ecb-4a5e9e8f0eee#documentation

**Documentations**:

- `BIG-IP Cloud Edition Knowledge Center`_
- `Slides deck`_ (internal)
- `F5 BIG-IQ API`_
- `BIG-IP Cloud Edition FAQ`_
- `BIG-IP Cloud Edition Solution Guide`_

.. _BIG-IP Cloud Edition Knowledge Center: https://support.f5.com/csp/knowledge-center/software/BIG-IP?module=BIG-IP%20Cloud%20Edition 
.. _Slides deck: https://hive.f5.com/docs/DOC-48254
.. _F5 BIG-IQ API: https://clouddocs.f5.com/products/big-iq/mgmt-api/v6.0/
.. _BIG-IP Cloud Edition FAQ: https://devcentral.f5.com/articles/big-ip-cloud-edition-faq-31270?tag=big-iq
.. _BIG-IP Cloud Edition Solution Guide: https://f5.com/resources/white-papers/big-ip-cloud-edition-solution-guide-31373

**Videos**:

- `Analytics in BIG-IP Cloud Edition`_
- `Deploying an Application with BIG-IP Cloud Edition`_
- `BIG-IP Cloud Edition Application Services Catalog`_
- `BIG-IP Cloud Edition Deploy and Secure an Application`_
- `BIG-IP Cloud Edition Auto-scaling with VMware`_
- `BIG-IP Cloud Edition Auto scaling with AWS`_
- `BIG-IP Cloud Edition Using the BIG IP Cloud Edition Dashboard`_

.. _Analytics in BIG-IP Cloud Edition: https://www.youtube.com/watch?v=6Oh6fBPLw6A
.. _Deploying an Application with BIG-IP Cloud Edition: https://www.youtube.com/watch?v=Qwr3RIfUobo
.. _BIG-IP Cloud Edition Application Services Catalog: https://www.youtube.com/watch?v=otH_YxdCly0
.. _BIG-IP Cloud Edition Deploy and Secure an Application: https://www.youtube.com/watch?v=0a5e-70vS-4
.. _BIG-IP Cloud Edition Auto-scaling with VMware: https://www.youtube.com/watch?v=fA22obOF_iY
.. _BIG-IP Cloud Edition Auto scaling with AWS: https://www.youtube.com/watch?v=YByW7Q3jAvQ
.. _BIG-IP Cloud Edition Using the BIG IP Cloud Edition Dashboard: https://www.youtube.com/watch?v=FjyJq_9NS2Y

**Tools**:

- `BIG-IP 6.0 Application Service Catalog - Automation Demo with Postman`_
- `BIG-IP Cloud Edition AWS trial`_
- `BIG-IQ PM team GitHub (various automation tools)`_

.. _BIG-IP 6.0 Application Service Catalog - Automation Demo with Postman: https://github.com/codygreen/BIG-IQ-Automation-Application-Service-Catalog 
.. _BIG-IP Cloud Edition AWS trial: https://github.com/f5devcentral/f5-big-ip-cloud-edition-trial-quick-start 
.. _BIG-IQ PM team GitHub (various automation tools): https://github.com/f5devcentral/f5-big-iq-pm-team

.. toctree::
   :maxdepth: 2
   :numbered:
   :caption: **Contents/Lab**:
   :glob:

   class*/class*
