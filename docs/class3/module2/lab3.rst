Lab 2.3: Troubleshooting Security
---------------------------------
Connect as **larry**

1. Larry check the Web Application Security for ``templates-default`` ASM Policy.

Go to Configuration > SECURITY > Web Application Security > Policies

Click the box to select all suggestions and **Accept** the learning.

.. image:: ../pictures/module2/img_module2_lab3_1.png
  :align: center
  :scale: 50%

.. note:: If you want to use learning/blocking mode, you will need a dedicated app template per application, unless you want to share the learning amongs the applications using the same ASM policy.

|

2. Go to Deployment > EVALUATE & DEPLOY > Web Application Security

Under Deployments, click on **Create**. Name your Deployment, select BOS-vBIGIP01.termmarc.com, choose method **Deploy immediately**, then click on **Create**.

.. image:: ../pictures/module2/img_module2_lab3_2a.png
  :align: center
  :scale: 50%

|

3. Go back to Configuration > SECURITY > Web Application Security > Policies

Update the Enforcement Mode to ``Blocking``, Save and Close.

.. image:: ../pictures/module2/img_module2_lab3_2.png
  :align: center
  :scale: 50%

|

Connect as **paula**

Select ``site36.example.com``

1. Paula enforce the policy: APPLICATION SERVICES > Security > CONFIGURATION tab > click on ``Start Blocking``

.. image:: ../pictures/module2/img_module2_lab3_3.png
  :align: center
  :scale: 50%

|

.. note:: The Enforcement Mode is controlled by the Application owner, the Host Name of the application (FQDN) will be configured in the ASM Policy to enforce it (or not)

.. image:: ../pictures/module2/img_module2_lab3_3a.png
  :align: center
  :scale: 50%

2. Connect on the *Ubuntu Lamp Server* server and launch the following command:

``# /home/f5/scripts/generate_bad_traffic.sh``

3. Check the various Security Analytics: Illegal Transactions, All Transactions and Violations.

.. image:: ../pictures/module2/img_module2_lab3_4.png
  :align: center
  :scale: 50%

4. Stop the bad traffic script, connect on the *Ubuntu Lamp Server* server and ``CTRL+C``.
