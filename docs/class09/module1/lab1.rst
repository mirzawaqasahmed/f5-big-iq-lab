Lab 1.1: Access Built-in templates
----------------------------------
**[New 6.0.1]** BIG-IQ v6.0 will have the default access templates below built-in. These default templates cannot be modified but they can be cloned.
They can be used to deploy various type of applications. These default templates are only displayed after BIG-IQ is managing a BIG-IP device.

- ``Default-f5-HTTPS-offload-lb-Access-AD-Authentication-template``: For load balancing an HTTPS application on port 443 with SSL offloading on BIG-IP and securing application Access using AD authentication.
- ``Default-f5-HTTPS-offload-lb-Access-LDAP-Authentication-template``: For load balancing an HTTPS application on port 443 with SSL offloading on BIG-IP and securing application Access using LDAP authentication.
- ``Default-f5-HTTPS-offload-lb-Access-RADIUS-Authentication-template``: For load balancing an HTTPS application on port 443 with SSL offloading on BIG-IP and securing application Access using RADIUS authentication.

.. note:: access templates cannot be used as is and need to be cloned. Next chapter will show the workflow.

.. warning:: Those templates cannot be used in AWS due to technical constraints, BIG-IP APM do not support HA in Active-Active mode. and there are no AMIs with APM pre-provision.

Connect as **marco**, go to *Applications* > *SERVICE CATALOG*:

Look through the different default templates.

.. image:: ../pictures/module1/img_module1_lab1_1.png
  :align: center

|

.. note:: The timeout on the access policy were updated for the purpose of this lab:

  - Inactivity Timeout: ``120 seconds``
  - Access Policy Timeout:	``60 seconds``
  - Maximum Session Timeout:	``180 seconds``