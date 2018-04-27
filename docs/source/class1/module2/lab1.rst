Lab 2.1: Built-in Service Template
----------------------------------
BIG-IQ will be delivered with default built-in Service Templat. Those templates cannot be modified but they can be cloned (see Lab 2.3).
They can be used to depoy various type of application. The default templates will be display only after at
least 1 BIG-IP device is managed by BIG-IQ.

Below default non secured built-in Service Templates:

- Default-f5-FastL4-TCP-lb-template: For load balancing a TCP-based application with a FastL4 profile.
- Default-f5-FastL4-UDP-lb-template: For load balancing a UDP-based application with a FastL4 profile.
- Default-f5-HTTP-lb-template: For load balancing an HTTP application on port 80.
- Default-f5-fastHTTP-lb-template: For load balancing an HTTP-based application, speeding up connections and reducing the number of connections to the back-end server.

Go to *Applications* > *SERVICE CATALOG*, :

.. image:: ../pictures/module2/img_module2_lab1_1.png
  :align: center
