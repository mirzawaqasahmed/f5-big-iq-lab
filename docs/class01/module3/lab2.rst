Lab 3.2: Delete Application via API with Ansible (6.0.x only)
-------------------------------------------------------------

.. warning:: Starting BIG-IQ 6.1, AS3 should be the preferred method to deploy application services programmatically through BIG-IQ.

In this lab, we are going to delete an application using Ansible.

Connect via ``SSH`` to the system *Ubuntu Lamp Server*.

**olivia** user is used to execute the playbook:

Execute the playbook::

    # cd /home/f5/f5-ansible-demo
    # ansible-playbook -i notahost, delete_http_bigiq_app.yaml -vvvv

Connect as **olivia** (select Auth Provider local) and check on BIG-IQ the application has been correctly deleted.

.. note :: If you have time, you can try to deploy another application type using other Ansible modules (e.g. bigiq_application_fasthttp, bigiq_application_fastl4_tcp, bigiq_application_https_offload, bigiq_application_https_waf)
