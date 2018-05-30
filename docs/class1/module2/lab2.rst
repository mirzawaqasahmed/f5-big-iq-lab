Lab 2.2: Create custom security policies & Application Service Template
-----------------------------------------------------------------------
Connect as **larry**

1. Create the custom ASM policy, go to *Configuration* > *SECURITY* > *Web Application Security* > *policies*.

.. image:: ../pictures/module2/img_module2_lab2_1.png
  :align: center
  :scale: 50%

|

Select the ``f5-asm-policy1`` ASM policy from the list and look through its settings. Notice the policy is in Transparent mode.

Edit the Policy ``f5-asm-policy1``, switch to ``Manual`` Learning Mode and ``Make available in Application Templates``, click Save.

.. image:: ../pictures/module2/img_module2_lab2_4.png
  :align: center
  :scale: 50%

|

In addition, go to *POLICY BUILDING* > *Settings* and set *Policy Building Mode* to ``Central`` and switch to ``Manual`` Learning Mode, click Save & Close.

.. image:: ../pictures/module2/img_module2_lab2_4b.png
  :align: center
  :scale: 50%

.. note:: If you want to use learning/blocking mode, you will need a dedicated app template per application.

.. warning:: Ignore the unauthorized error when saving the policy.

2. Create the AFM Policy, go to *Configuration* > *SECURITY* > *Network Security* > *Firewall Policies*, click Create.
Then enter the name of your policy: ``f5-afm-policy1``. Make sure the box ``Make available in Application Templates`` is checked. Click Save.

.. image:: ../pictures/module2/img_module2_lab2_5.png
  :align: center
  :scale: 50%

|

Create 2 Rules:

- rule 1: set the destination ports to ``443`` and ``80``, Protocol to ``tcp``
- rule 2: set action to ``reject`` and log to ``true``

Click Save & Close.

.. image:: ../pictures/module2/img_module2_lab2_6.png
  :align: center
  :scale: 50%

|

Connect as **marco**

1. Create a Clone of the *Default-f5-HTTPS-WAF-lb-template* policy, go to *Applications* > *SERVICE CATALOG*, and click on *Clone*.
Enter the name of your cloned template: ``f5-HTTPS-WAF-lb-template-custom1``

.. image:: ../pictures/module2/img_module2_lab2_7.png
  :align: center
  :scale: 50%

|

2. Then select the ASM policy ``f5-asm-policy1``, the AFM policy ``f5-afm-policy1`` and the Logging Profile ``templates-default`` in the SECURITY POLICIES section on both Virtual Servers (Standalone Device).

.. image:: ../pictures/module2/img_module2_lab2_8.png
  :align: center
  :scale: 50%

|

Save & Close

.. image:: ../pictures/module2/img_module2_lab2_9.png
  :align: center
  :scale: 50%

|

.. note:: A DoS Profile could also be assign to the template but we are not using it for this lab.

.. warning:: Application DOS is only supported on Standalone device. The Network DOS is supported on Standalone and Tier 1 device (in a context of SSG)
