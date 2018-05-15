Lab 3.2: Delete Application via API  (Ansible)
----------------------------------------------
In this lab, we are going to delete an application using Ansible.

Open a SSH session to *Ubuntu Lamp Server* in UDF.

Update the f5-ansible module to the latest versions::

    # cd /home/f5/f5-ansible; git pull

**david** user is used to execute the playbook:

Execute the playbook::

    # cd /home/f5/f5-ansible-demo
    # ansible-playbook -i notahost, delete_http_app.yaml -vvvv

Check on BIG-IQ the application has been correclty deleted.

.. note :: If you have time, you can try to deploy another application type (e.g. WAG, HTTPS, TCP)
