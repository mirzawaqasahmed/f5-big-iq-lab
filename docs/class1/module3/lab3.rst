Lab 3.2: Create Application via API (Python)
--------------------------------------------
In this lab, we are going to create an application using Python script and BIG-IQ API.

On BIG-IQ, connect as **david** to create a new application, go to *Applications* > *APPLICATIONS*, select the template previously created ``Default-f5-HTTP-lb-template``.

- BIG-IP: Select ``SEA-vBIGIP01.termmarc.com``
- Application Name: ``site20.example.com``
- Destination Address: ``10.1.10.120``
- Destination Network Mask: ``255.255.255.255``
- Service Port: ``80``
- Pool Members: ``10.1.20.120``
- Pool Members: ``10.1.20.121``

Do click on Create but on **View Sample API Request** at the top right corner.

.. image:: ../pictures/module3/img_module3_lab3_1.png
  :align: center
  :scale: 50%

|

Open a SSH session to *Ubuntu Lamp Server* in UDF.

Edit the file ``/home/f5/class1mod3.py``

- Set application name: APP_NAME = "``site20.example.com``"
- Confirm the correct template name is configured in ``templates`` variable (e.g. Default-f5-HTTP-lb-template)
- Check the BIG-IP management IP used to filter the device where the app will be deployed in variable ``device`` (e.g. 10.1.1.7)
- Replace the API Sample Request generated from BIG-IQ UI in the script in the ``post_body`` variable (only until ``addAnalytics`` line)

Execute the Python script::

    # cd /home/f5/
    # python3 class1mod3.py

.. warning:: Due to python dependancy issue, the script cannot be executed on the Lamp server at the moment.

Check on BIG-IQ the application has been correclty created.
