Module 3: Application Deployment via API
========================================
BIG-IQ 6.0 will offer the below Ansible module available in Ansible 2.6 (for info `Ansible F5 github`_).

.. _Ansible F5 github: https://github.com/F5Networks/f5-ansible

.. warning:: Please, follow instruction on your machine to configure the `experimental F5 Modules`_ (UDF lab already setup).

.. _experimental F5 Modules: http://clouddocs.f5.com/products/orchestration/ansible/devel/usage/installing-modules.html

- Create a new Application from Default-f5-FastL4-TCP-lb-template **(BIG-IP Standalone only)**
- Create a new Application from Default-f5-HTTP-lb-template **(SSG and BIG-IP Standalone)**
- Create a new Application from Default-f5-HTTPS-offload-lb-template **(SSG and BIG-IP Standalone)**
- Create a new Application from Default-f5-HTTPS-WAF-lb-template **(SSG and BIG-IP Standalone)**
- Remove an Application **(SSG and BIG-IP Standalone)**
- Manual Scale-Out / Manual Scale-In on AWS SSG **(to come)**
- Manual Scale-Out / Manual Scale-In on VMware SSG **(to come)**

In this module, we will learn how to see create and delete an application using Ansible Playbook, also look at an example of straight API payload from BIG-IQ UI.

.. toctree::
   :maxdepth: 1
   :glob:

   lab*
