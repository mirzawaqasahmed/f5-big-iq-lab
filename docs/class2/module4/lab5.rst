Lab 4.5: Cleanup the environment (AWS)
--------------------------------------

Once you are done with your demo/training/testing, you will want to cleanup your 
environment. 

To do this, please proceed this way: Connect to your system called 
**Ubuntu 16.04 Lamp Server, Radius and DHCP**

Do the following: 

.. code:: 

    f5@03a920f8b4c0410d8f:~$ cd AWS-CFT-Cloud-Edition/
    f5@03a920f8b4c0410d8f:~/AWS-CFT-Cloud-Edition$ ./111-DELETE_ALL.sh

Follow all the steps as explained: 

* Delete the app deployed on your AWS ``SSG`` from the ``BIG-IQ UI``and then press ENTER
* Delete the AWS ``SSG`` from the ``BIG-IQ UI``and then press Enter 
...

.. image:: ../pictures/module4/img_module4_lab5_1.png
  :align: center
  :scale: 50%

|

If you go monitor your ``AWS Stacks`` in the ``AWS Console``, you'll see the stacks 
previously created being removed

In the end, your ``AWS VPC`` and all the related components should be removed . 
