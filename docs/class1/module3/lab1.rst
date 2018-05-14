Lab 3.1: Create Application via API
-----------------------------------
In this lab, we are going to deploy a basci HTTP application using Ansible.

The following parameters are filled in the playbook ``create_http_app.yaml``.

- Application Name: ``site22.example.com``
- Destination Address: ``10.1.10.122``
- Destination Network Mask: ``255.255.255.255``
- Service Port: ``80``
- Pool Members: ``10.1.20.122``

Open a SSH session to *Ubuntu Lamp Server, LDAP and DHCP* in UDF.

Update the f5-ansible module to the latest versions::

    # cd /home/f5/f5-ansible; git pull

**david** user is used to execute the playbook:

Execute the playbook::

    # cd /home/f5/f5-ansible-demo
    # ansible-playbook -i notahost, create_http_app.yaml -vvvv

.. note :: **david** is used to execute Ansible playbooks

Check on BIG-IQ the application has been correclty created.
