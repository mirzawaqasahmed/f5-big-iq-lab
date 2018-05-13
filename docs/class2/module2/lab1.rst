Lab 1.1: Deploy an application
------------------------------

We will deploy an application via the app template feature on our ``SSG`` called
*SSGClass2*

On your BIG-IQ, go to *Applications* > *Applications*

.. image:: ../pictures/module1/img_module2_lab1_1.png
    :align: center
    :scale: 50%

|

Click on the *Create* button. Select the Template *Default-f5-HTTPS-offload-lb-template*

* Name : site30.example.com
* Environment: *Select Service Scaling Group*
* Service Scaling Group: Select *SSGClass2*

.. image:: ../pictures/module1/img_module2_lab1_2.png
    :align: center
    :scale: 50%

|

* Servers : Click on the advanced view

.. image:: ../pictures/module1/img_module2_lab1_3.png
    :align: center
|

.. note:: You'll need to setup the *Application Server Node* first to be able
  to select them as your pool members

  * Application Server Pool:

    * Name: pool_site30
    * Pool members:

      * Port: 80
      * node: Select *# 10.1.20.130*

      * Port: 80
      * node: Select *# 10.1.20.131*

  * Application Server Node

    * Name: 10.1.20.130
    * Address: 10.1.20.130

    * Name: 10.1.20.131
    * Address: 10.1.20.131

.. image:: ../pictures/module1/img_module2_lab1_4.png
  :align: center
  :scale: 50%

|

* Load Balancer:

  * Name: site30_vs_443
  * Destination Address: 10.1.10.130
  * Destination Network Mask: 255.255.255.255
  * Service Port: 443

* HTTP Redirect:

  * Name: site30_redirect_vs80
  * Destination Address: 10.1.10.130
  * Destination Network Mask: 255.255.255.255
  * Service Port: 80

  .. image:: ../pictures/module1/img_module2_lab1_5.png
    :align: center
    :scale: 50%

  |

Click on *Create*. You'll see your application being created

.. image:: ../pictures/module1/img_module2_lab1_6.png
  :align: center
  :scale: 50%

|

Next, we will review the configuration on our SSG devices and on our tier1 BIG-IPs
