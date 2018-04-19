Lab 1.3: Deploy your Service Scaling Group
------------------------------------------

Before setting up our SSG and deploy it, do the following:

* Open **2** putty sessions with your BIG-IQ.

* On the first SSH session, run the following command:

  ``tail -f /var/log/restjavad.0.log | grep vmware``

* On the second SSH session, run the following command:

  ``tail -f /var/log/orchestrator.log``

Keep those sessions open until the end of the class.

Launch vCenter also with the following credentials:

* login: administrator@vsphere.local
* password: Purpl3$lab

.. image:: ../pictures/module1/img_module1_lab3_4.png
    :align: center
    :scale: 50%

|


Service Scaling Group Setup
***************************

To deploy your ``Service Scaling Group`` (SSG), go to *Applications* >
*Service Scaling Groups* and click the *Create* button

.. image:: ../pictures/module1/img_module1_lab3_1.png
    :align: center
    :scale: 50%

|

Service Scaling Group Properties:

* Name : SSGClass2
* Cloud Environment: select *SSGClass2VMWAreEnvironment*
* Minimum Device(s) Required: 2
* Desired Number of Device(s): 2
* Maximum Device(s) Required : 3
* Maximum Application(s) Allowed: 3

.. image:: ../pictures/module1/img_module1_lab3_2.png
    :align: center
    :scale: 50%

|

Let's review those parameters.

* Minimum Device(s) Required : this specify how many BIG-IP VE(s) should always
  be available at any time
* Desired Number of Device(s): this specify the ideal number of BIG-IP VE(s)
  should be available when no scale-out scenario is triggered
* Maximum Device(s) Required: this specify the maximum number of BIG-IP VE(s)
  that can be created in this SSG. The purpose is to make sure that under some
  scenarios (like being DDOS), we won't add constantly new devices
* Maximum Application(s) Allowed: This specify how many applications we will
  be able to deploy on top of this SSG. The idea is to ensure that if we use a
  Cloud edition VE, we won't try to go over the license limit


Load-Balancer:

* Devices: Select the already discovered BIG-IP *ip-10-1-1-8.us-west2.compute*
  Òthat has 10.1.1.8 as an IP Address

.. warning:: Add a screenshot of the Tier1 BIG-IP

The device(s) we select here, we behave as our Tier1 devices. They will load
balance the traffic aimed at this SSG.

Scaling Rules:

* Scale-Out: Select *Throughput(In)* Greater than 5 (Mbps)
* Scale-In: Select *Troughput(In)* Less than 2 (Mbps)



Here we define our threshold to scale-in/scale-out. Here it will be based on the
**aggregated** throughput they receive. The ``cooldown period`` mentions an
interval where we don't do any scaling. The idea is to see how the situation
evolves after a scale-in scale-out event.

.. warning:: We NEED TO MAKE sure that the throughput scale changed from Gb to
  Mb

Click on *Save & Close* and your SSG will start being provisioned.
Go to the next lab to see how to troubleshoot/monitor your SSG Deployment.

.. note::

  You may need to go to another page on your BIG-IQ interface and come back to
  the SSG page to see your SSG appear
