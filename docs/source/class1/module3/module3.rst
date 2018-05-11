Module 3: Application Deployment via API (Ansible)
==================================================

BIG-IQ 6.0 will offer the below Ansible module available in Ansible (for info `Ansible F5 github`_).

.. _Ansible F5 github: https://github.com/F5Networks/f5-ansible

.. warning:: Please, follow instruction on your machine to configure the `experimental F5 Modules`_ (UDF lab already setup).

.. _experimental F5 Modules: http://clouddocs.f5.com/products/orchestration/ansible/devel/usage/installing-modules.html#method-1-install-in-a-relative-location-recommended

- Create a new Application from Default-f5-FastL4-TCP-lb-template
- Create a new Application from Default-f5-HTTP-lb-template
- Create a new Application from Default-f5-HTTPS-offload-lb-template
- Create a new Application from Default-f5-HTTPS-WAF-lb-template
- Remove an Application
- Manual Scale-Out / Manual Scale-In on AWS SSG
- Manual Scale-Out / Manual Scale-In on VMware SSG

In this module, we will learn how to create and delete an application using Ansible Playbook.

.. toctree::
   :maxdepth: 1
   :glob:

   lab*
