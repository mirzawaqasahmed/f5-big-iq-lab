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

Below Virtual Servers and Pool Members can be used in the context of the UDF lab.

- **vLab Test Web Site 16:**

=======================================  =========== ==== ============================
Test Website                             VIP         Port Members
=======================================  =========== ==== ============================
site16.example.com *(used in module 4)*  10.1.10.116 80   10.1.20.116 and 10.1.20.117
site16.example.com                       10.1.10.116 443  10.1.20.116 and 10.1.20.117
site16port8081.example.com               10.1.10.116 8081 10.1.20.116 and 10.1.20.117
=======================================  =========== ==== ============================

- **vLab Test Web Site 18:**

=======================================  =========== ==== ============================
Test Website                             VIP         Port Members
=======================================  =========== ==== ============================
site18.example.com *(used in module 2)*  10.1.10.118 80   10.1.20.118 and 10.1.20.119
site18.example.com *(used in module 2)*  10.1.10.118 443  10.1.20.118 and 10.1.20.119
site18port8081.example.com               10.1.10.118 8081 10.1.20.118 and 10.1.20.119
=======================================  =========== ==== ============================

- **vLab Test Web Site 20:**

==========================  =========== ==== ============================
Test Website                VIP         Port Members
==========================  =========== ==== ============================
site20.example.com          10.1.10.120 80   10.1.20.120 and 10.1.20.121
site20.example.com          10.1.10.120 443  10.1.20.120 and 10.1.20.121
site20port8081.example.com  10.1.10.120 8081 10.1.20.120 and 10.1.20.121
==========================  =========== ==== ============================

- **Hackazon Test Web Site 22:**

=======================================  =========== ==== ============================
Test Website                             VIP         Port Members
=======================================  =========== ==== ============================
site22.example.com *(used in module 3)*  10.1.10.122 80   10.1.20.122
=======================================  =========== ==== ============================


.. toctree::
   :maxdepth: 1
   :glob:

   lab*
