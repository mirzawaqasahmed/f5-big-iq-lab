Lab 3.2: Delete Application via API  (Ansible)
----------------------------------------------
In this lab, we are going to delete an application using Ansible.

Open a SSH session to *Ubuntu Lamp Server* in UDF.

**david** user is used to execute the playbook:

Execute the playbook::

    # cd /home/f5/f5-ansible-demo
    # ansible-playbook -i notahost, delete_http_app.yaml -vvvv

Check on BIG-IQ the application has been correclty deleted.

.. note :: If you have time, you can try to deploy another application type using other Ansible modules (e.g. bigiq_application_fasthttp, bigiq_application_fastl4_tcp, bigiq_application_https_offload, bigiq_application_https_waf)
