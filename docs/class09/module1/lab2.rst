Lab 2.2: Create custom security policies & Application Service Template
-----------------------------------------------------------------------
Connect as **larry**

1. Clone an access policy from the default-access-group. Go to *Configuration* > *ACCESS* > *Access Groups* > *default-access-group*.

Before you can clone policies, you must have an Access group configured for your Service Scaling Group.
Important: Do not edit access policies or configurations in the default Access group.
You clone a default access policy to create a starting point for defining access policies for an Access group.

.. note:: Do not edit default access policy templates. Clone a policy, then make any required edits in the cloned policy.

- Click Configuration > ACCESS > Access Groups. The Access Groups screen opens.

.. image:: ../pictures/module1/img_module2_lab2_1.png
  :align: center
  :scale: 50%

- Click default-access-group. The default-access-group General Properties screen opens.
- On the left, click Per-Session Policies. The Per-Session Policies (Shared) screen opens.
- Select the check box next to an access policy to clone, and click More > Clone .

.. image:: ../pictures/module1/img_module2_lab2_2.png
  :align: center
  :scale: 50%

- In the Clone Policy dialog box that opens, select the target Access group, and select whether to reuse existing objects from the target Access group, then click Clone.

.. image:: ../pictures/module1/img_module2_lab2_3.png
  :align: center
  :scale: 50%

- Check the target Access group to see that the target policy has been cloned.

.. image:: ../pictures/module1/img_module2_lab2_4.png
  :align: center
  :scale: 50%

.. image:: ../pictures/module1/img_module2_lab2_5.png
  :align: center
  :scale: 50%

Now you can edit the access policy, and the related objects created to support it on the target access group.

2. Review and edit resources associated with an access policy

