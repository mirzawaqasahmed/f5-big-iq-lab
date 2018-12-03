Lab 5.4: FQDN and Service Discovery
-----------------------------------

Open a SSH session to *Ubuntu Lamp Server* in UDF.

Execute the playbooks for each tasks

- Task 10: HTTP Application Service using an FQDN pool to identify pool members::

    # cd /home/f5/f5-ansible-bigiq-as3-demo
    # ./cmd_playbook.sh as3_bigiq_task10_create_http_app_fqdn_nodes.yml

Connect as **paula** and check on BIG-IQ the application has been correctly created.

|lab-4-1|

Connect on the BIG-IP and look at the **fqdn_pool**:

|lab-4-2|


.. |lab-4-1| image:: images/lab-4-1.png
   :scale: 80%

.. |lab-4-2| image:: images/lab-4-2.png
   :scale: 80%

