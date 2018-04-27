Lab 4.1: Create Application via API
-----------------------------------

BIG-IQ 6.0 will offer the below Ansible module available in Ansible 2.6 release (for info `Ansible F5 github`_).

- Create a new Application from Default-f5-FastL4-TCP-lb-template
- Create a new Application from Default-f5-HTTP-lb-template
- Create a new Application from Default-f5-HTTPS-offload-lb-template
- Create a new Application from Default-f5-HTTPS-WAF-lb-template
- Remove an Application
- Manual Scale-Out / Manual Scale-In on AWS SSG
- Manual Scale-Out / Manual Scale-In on VMware SSG

In this module, we are going to deploy an WAF application using Ansible.

Connect as **David**

Open a SSH session to *Ubuntu Lamp Server, LDAP and DHCP* in UDF.

Make sure you run Ansible 2.6 release::

  # ansible --version

Create your playbook as follow::

  Playbook content
  ddd
  eee

Execute your playbook::

    # ansible playbook.yml

Check on BIG-IQ the application has been correclty created:

.. image:: ../pictures/module4/img_module4_lab1_1.png
  :align: center
