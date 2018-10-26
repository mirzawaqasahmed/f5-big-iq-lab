Lab 3.4: Automation Demo with Postman
-------------------------------------

From UDF, launch a Console/RDP session to have access to the Ubuntu Desktop. To do this, in your UDF deployment, click on the *Access* button
of the *Ubuntu Lamp Server* system and select *Console* or *XRDP*

.. image:: ../../pictures/udf_ubuntu.png
   :align: center
   :scale: 50%

|

If you are using Ravello, select the *Ubuntu Lamp Server* and click on *Console*:

.. image:: ../../pictures/ravello_ubuntu.png
   :align: center
   :scale: 50%

|

You can use the copy/past feature if you are using the Console:

.. image:: ../../pictures/ubuntu_console.png
   :align: center
   :scale: 50%

|

Follow below steps (source: `github`_):

.. _github: https://github.com/codygreen/BIG-IQ-Automation-Application-Service-Catalog

Installation
------------

1. Import the `F5 Workflow Functions postman libraries`_: 
2. Install the F5 Workflow Functions by running the install command inside it's collection.
3. Import the BIG-IQ `environment variables`_ into Postman.
4. Import the BIG-IQ catalog_ into Postman.


Notice
------

These examples are based on a custom service catalog entry and are intended for use as a example and starting point. 
If you try and run these against your BIG-IQ it will not work.  

Example_Usage
-------------

1. Get an authentication token - run the Get Auth Token collection
2. Create an application - run the Create App collection
3. Check the results (you should see status: FINISHED in the JSON response) - run the Get Status collection
4. Add a pool member - run the Add Pool Member collection
5. Check the results (you should see status: FINISHED in the JSON response) - run the Get Status collection
6. Delete a pool member - run the Delete Pool Member collection
7. Check the results (you should see status: FINISHED in the JSON response) - run the Get Status collection
8. Delete the application - run the Delete App Collection
9. Check the results (you should see status: FINISHED in the JSON response) - run the Get Status collection


.. _F5 Workflow Functions postman libraries: https://raw.githubusercontent.com/0xHiteshPatel/f5-postman-workflows/master/F5_Postman_Workflows.postman_collection.json
.. _environment variables: https://github.com/codygreen/BIG-IQ-Automation-Application-Service-Catalog/blob/master/Postman%20Workflow/big-iq_app_service_catalog_environment.json
.. _catalog: https://raw.githubusercontent.com/codygreen/BIG-IQ-Automation-Application-Service-Catalog/master/Postman%20Workflow/big-iq_app_service_catalog.postman_collection.json
