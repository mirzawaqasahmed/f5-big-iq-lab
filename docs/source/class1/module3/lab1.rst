Lab 3.1: Create Application via API
-----------------------------------
In this lab, we are going to deploy a WAF application using Ansible.

Connect as **David**

Open a SSH session to *Ubuntu Lamp Server, LDAP and DHCP* in UDF.

Make sure you have install the latest F6 Ansible modules from the F5 Github devel branch.

Create your playbook as follow::

  Playbook content

- Application Name: ``site22.example.com``
- Name Virtual Server: ``vs_site22.example.com``
- Destination Address: ``10.1.10.122``
- Destination Network Mask: ``255.255.255.255``
- Service Port: ``80``
- Pool Members: ``10.1.20.122``

.. warning:: PENDING ANSIBLE MODULES AVAILBILITY

Execute your playbook::

    # ansible playbook.yml

Check on BIG-IQ the application has been correclty created.
