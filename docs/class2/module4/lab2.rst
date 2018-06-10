Lab 4.2: Deploy our ``SSG`` in AWS 
----------------------------------

Since we have already seen the different components needed to deploy a ``SSG`` successfully, 
we will automatically deploy it and review its configuration. 

Retrieve our BIG-IP SEA Public IP 
*********************************

We will establish a ``VPN`` connection between our ``UDF`` environment and ``AWS``. This will be 
setup automatically. 

We will use our BIG-IP SEA as one of the ``VPN endpoint``. 

In your ``UDF`` blueprint, find your BIG-IP called **SEA-vBIGIP01.termmarc.com.v13.1.0.5 (VPN)** 
and click on **Access** > **TMUI**. It will open a new tab in your browser to access its GUI. 

Here copy the ``hostname`` you see in your browser : 

.. image:: ../pictures/module4/img_module4_lab1_2.png
  :align: center
  :scale: 50%

|

Ping this ``hostname`` to retrieve its IP Address: 

.. code:: 

    PAR-ML-00026375:~ menant$ ping 443cbace-334b-491d-8b10-3772c26d70bb.access.udf.f5.com
    PING 443cbace-334b-491d-8b10-3772c26d70bb.access.udf.f5.com (129.146.155.127): 56 data bytes
    Request timeout for icmp_seq 0

In the example above, we can see that our public IP is **129.146.155.127**. 

.. note:: the ping will fail, it's fine. we just needed to retrieve the public IP

Launch our ``SSG`` - Access our orchestrator
********************************************

To setup ``BIG-IQ`` and ``AWS`` automatically, open a ``SSH`` connection on the UDF system 
called: **Ubuntu 16.04 Lamp Server, Radius and DHCP**

.. image:: ../pictures/module4/img_module4_lab1_1.png
  :align: center
  :scale: 50%

|

Once connected via ``SSH``, go into the folder: **AWS-CFT-Cloud-Edition**: 

    ``cd AWS-CFT-Cloud-Edition/``

we will need to edit the following files: 

* **config.yml**: This file will contains all the information needed to deploy the ``AWS`` environment 
  successfully. 
* **08-create-aws-auto-scaling.yml**: we will change the setup of the default ``SSG`` that gets deployed. 
  we want to deploy 2 instances to review how it is setup as part of a ``SSG`` group. 


Launch our ``SSG`` - Update config.yml
***************************************

Use your favorite editor to update this file. 

    ``vi config.yml``

Here are the settings you will need to change to deploy everything successfully: 

* AWS_ACCESS_KEY_ID: Use the ``AWS Access Key`` you retrieved from the previous lab (IAM section).
* AWS_SECRET_ACCESS_KEY: Use the ``AWS Secret Access Key`` you retrieve from the previous lab (IAM section).
* PREFIX: Specify a ``prefix`` that will be used on each object automatically created. we will use **UDF-LAB-** 
  AND your **NAME**. Example: **UDF-LAB-MENANT**. 

  .. warning:: DO NOT PUT a ``-`` at the end or your deployment will fail 
        We need you to put something so that your PREFIX will be UNIQUE to you or it will overlap with 
        other student's env. If your name is 'common', pick something else that should be unique or append 
        your first name to it. 

* AWS_SSH_KEY: Use the ``AWS Key Pair`` we created in the previous lab: **BIG-IQ-SSG**
* CUSTOMER_GATEWAY_IP: Use the Public IP Address of our **SEA BIG-IP** you retrieved earlier. 

Save the config file. 

.. note:: We don't have to change anything else as long as we use the US-East (N. Virginia) Region

Launch our ``SSG`` - Update our SSG configuration
*************************************************

To update configuration pushed by the orchestrator, we will update the file called 
**08-create-aws-auto-scaling.yml**. Use your favorite editor to update it 

Look for this section in the file: 

.. code::

    - include_tasks: ./helpers/post.yml
      with_items:
        - name: Create service scaling group
          url: "{{BIGIQ_URI}}/cm/cloud/service-scaling-groups"
          body: >
            {
                "name": "{{SSG_NAME}}",
                "description": "AWS scaling group",
                "environmentReference": {
                    "link": "https://localhost/mgmt/cm/cloud/environments/{{cloud_environment_result.id}}"
                },
                "minSize": 1,
                "maxSize": 3,
                "maxSupportedApplications": 3,
                "desiredSize": 1,
                "postDeviceCreationUserScriptReference": null,
                "preDeviceDeletionUserScriptReference": null,
                "scalingPolicies": [
                {
                    "name": "scale-out",
                    "cooldown": 15,
                    "direction": "ADD",
                    "type": "ChangeCount",
                    "value": 1
                },
                {
                    "name": "scale-in",
                    "cooldown": 15,
                    "direction": "REMOVE",
                    "type": "ChangeCount",
                    "value": 1
                }]
            }

Change the **minSize** from 1 to 2 : 

.. code::

    - include_tasks: ./helpers/post.yml
      with_items:
        - name: Create service scaling group
          url: "{{BIGIQ_URI}}/cm/cloud/service-scaling-groups"
          body: >
            {
                "name": "{{SSG_NAME}}",
                "description": "AWS scaling group",
                "environmentReference": {
                    "link": "https://localhost/mgmt/cm/cloud/environments/{{cloud_environment_result.id}}"
                },
                "minSize": 2,
                "maxSize": 3,
                "maxSupportedApplications": 3,
                "desiredSize": 1,
                "postDeviceCreationUserScriptReference": null,
                "preDeviceDeletionUserScriptReference": null,
                "scalingPolicies": [
                {
                    "name": "scale-out",
                    "cooldown": 15,
                    "direction": "ADD",
                    "type": "ChangeCount",
                    "value": 1
                },
                {
                    "name": "scale-in",
                    "cooldown": 15,
                    "direction": "REMOVE",
                    "type": "ChangeCount",
                    "value": 1
                }]
            }


**minSize** specified how many BIG-IP VE instances we should deploy in our ``SSG``. Here, we changed the 
default configuration that would deploy a single instance. This will allow us to see how multiple VEs in 
a ``SSG`` deployed in ``AWS`` are setup. 

Launch our ``SSG`` - Trigger the deployment 
*******************************************

Now that the relevant files have been updated, we can trigger the deployment. 

To trigger the deployment, run the following command: 

 ``./000-RUN_ALL.sh nopause``

In the next lab, we will review what has been setup on ``BIG-IQ`` and what was deployed in our ``AWS VPC``.