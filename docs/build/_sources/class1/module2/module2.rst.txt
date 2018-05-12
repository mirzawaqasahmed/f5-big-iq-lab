Module 2: Application Templates & Deployment
============================================
In this module, we will learn how to use Application Templates and how to deploy an **Application**.

The Application Templates will be created by **Marco**, the Administrator.
**Larry** will create the security policies and let Marco know about the ones to associate with the templates.
Once the template is ready with all the necessary information, it will be ready to use by the Application owner.

**Paula** need to deploy an application, she has multiple Application servers. At this time, she needs to test
the performance of her application, she also wants to make her application secure before staging it to production.
She connects to the BIG-IQ and as access to her Application Dashboard.
**Paula** use the application template created by Marco to deploy her Application.

After a week of testing her application (in the class ~5 min), she will reach to **Larry** to fine tune and validate
the learning done by the Application Firewall (BIG-IP ASM).

.. note:: A traffic generator located on the *Ubuntu Lamp Server, LDAP and DHCP* server, is sending good traffic every minutes to the virtual servers.

Once the security policy is tunned and validated, **Paula** will enforce it by enableling herself the blocking mode in the policy.

Finally, we will simulate "bad" traffic to show the security policy blocking it.

.. note:: A traffic generator located on the *Ubuntu Lamp Server, LDAP and DHCP* server, can be launched manually to send bad traffic to the virtual servers.

.. toctree::
   :maxdepth: 1
   :glob:

   lab*
