Lab 5.6: Troubleshooting (Azure)
--------------------------------

Here are some Troubleshooting steps to help you troubleshooting issue with your Azure SSG deployment and Application:

1. In BIG-IQ UI, if the application deployment failed, click Retry.
2. In BIG-IQ UI, check BIG-IQ license on Console Node and Data Collection Device (System > THIS DEVICE > Licensing) and 
   BIG-IP license pool (Devices > LICENSE MANAGEMENT > Licenses).
3. In BIG-IQ UI, check the Cloud Environment if all the information are populated correctly (Applications > ENVIRONEMENTS > Cloud Environments).
4. In BIG-IQ CLI, check following logs: /var/log/restjavad.0.log and /var/log/orchestrator.log.
5. In Azure Marketplace, check if you have subscribed and accepted the terms for the F5 products.

.. image:: ../pictures/module5/img_module5_lab1_5.png
  :align: center
  :scale: 50%

7. In Azure Console, confirm the Access Key has the necessary permissions (review lab 1).