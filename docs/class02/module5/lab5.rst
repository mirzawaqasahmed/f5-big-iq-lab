Lab 5.5: Cleanup the environment (Azure)
----------------------------------------

Once you are done with your demo/training/testing, you will want to cleanup your
environment.

.. warning:: REMEMBER that this lab has a cost in Azure. You must make sure to tear down
  your environment as soon as you're done with it

.. warning:: The SSG will be automatically delete 23h after the deployment was started.

To do this, please proceed this way: Connect to your system called
**Ubuntu Lamp Server**

Do the following:

.. code::

    f5@03a920f8b4c0410d8f:~$ cd Azure-Cloud-Edition/
    f5@03a920f8b4c0410d8f:~/Azure-Cloud-Edition$ nohup ./111-DELETE_ALL.sh nopause &
    f5@03a920f8b4c0410d8f:~/Azure-Cloud-Edition$ tail -f nohup.out

Follow all the steps as explained:

* Delete the app deployed on your Azure ``SSG`` from the ``BIG-IQ UI`` and then press ENTER
* Delete the Azure ``SSG`` from the ``BIG-IQ UI`` and then press Enter

...

.. image:: ../pictures/module4/img_module4_lab5_1.png
  :align: center
  :scale: 50%

|

If you go monitor your ``Azure Stacks`` in the ``Azure Console``, you'll see the stacks
previously created being removed

In the end, your ``Azure VPC`` and all the related components should be removed .
