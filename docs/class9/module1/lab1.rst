Lab 1.1: Access Built-in templates
----------------------------------
**[New 6.0.1]** BIG-IQ v6.0 will have the default access templates below built-in. These default templates cannot be modified but they can be cloned.
They can be used to deploy various type of applications. These default templates are only displayed after BIG-IQ is managing a BIG-IP device.

- ``Default-f5-HTTPS-offload-lb-Access-AD-Authentication-template``: For load balancing an HTTPS application on port 443 with SSL offloading on BIG-IP and securing application Access using AD authentication.
- ``Default-f5-HTTPS-offload-lb-Access-LDAP-Authentication-template``: For load balancing an HTTPS application on port 443 with SSL offloading on BIG-IP and securing application Access using LDAP authentication.
- ``Default-f5-HTTPS-offload-lb-Access-RADIUS-Authentication-template``: For load balancing an HTTPS application on port 443 with SSL offloading on BIG-IP and securing application Access using RADIUS authentication.

.. warning:: access templates cannot be used as is and need to be cloned. Next chapter will show the workflow.

Connect as **marco**, go to *Applications* > *SERVICE CATALOG*:

Look through the different default templates.

.. image:: ../pictures/module1/img_module1_lab1_1.png
  :align: center

|

.. warning:: There will be no default AFM or DoS policies delivered in BIG-IQ 6.0. **Larry** will need to manually define them and link them to the custom templates.
