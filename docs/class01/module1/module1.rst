Module 1: Creating the personas (users with roles)
==================================================
In this module, we will learn about the different personas used in the Cloud Edition workflows.

We will use these personas through out the lab. We are not trying to demonstrate full RBAC feature, as this is not the focus.

.. note:: David, Marco, Paula, Paul and Larry are already created in the blueprint, so only the **olivia* user needs to be created.

We will be using 4 main personas for this lab:

1. **David** & **Marco**: Full Administrator
2. **Larry**: Security Manager
3. **Paula** & **Paul**: Application Manager
4. **Olivia**: Super-NetOps

**David** and **Marco** will have full access to BIG-IQ. He knows a lot about F5 products (BIG-IQ/BIG-IP).
He will provide the access to David, Larry and Paula. He will also manage the Service Scaling Group (SSG)
and application templates.

**Larry** will manage the Web Application Firewall (WAF) policies. He will work with Paula's team
to define the necessary security policies for each applications.
Ensure teams comply with security policies, industry rules and regulations, and best practices.
Keeping up to date on threats, determining their potential impact, and mitigating the risks.

**Paula** and **Paul** will manage the application deployments, monitor levels of app incidents, building solutions to address identified, prioritized business problems in a timely manner.
Maximizing value of app through capabilities design, adoption, and usage.
Ensuring that the app fits within the rest of the organization’s app portfolio strategy.

**Olivia** will try automating whenever possible, to enable efficiency and ability to solve problems at scale.
Automate common network patterns that the other teams can consume.
Automate existing environment management and troubleshooting tasks.

Connect to your BIG-IQ as **admin** and go to : *System* > *Users Management* > *Users*
and verify each user & role below and change where needed.

**1. David and Marco: Full Administrator**

- *Auth Provider* = local
- *User Name* = david
- *Full Name* = Full Administrator
- (*Password stored in Radius server* = david)
- *Role* = Administrator Role

- *Auth Provider* = Radius
- *User Name* = marco
- *Full Name* = Full Administrator
- (*Password stored in Radius server* = marco)
- *Role* = Administrator Role

**2. Larry: Application Security Manager**

- *Auth Provider* = Radius
- *User Name* = larry
- *Full Name* = Security Manager
- (*Password stored in Radius server* = larry)
- *Role* = Security Manager

**3. Paula: Application Manager VMware**

- *Auth Provider* = Radius
- *User Name* = paula
- *Full Name* = Application Manager
- (*Password stored in Radius server* = paula)
- *Role* = Application Creator VMware (custom role with ALL default templates except AWS)

**4. Paul: Application Manager AWS**

- *Auth Provider* = Radius
- *User Name* = paul
- *Full Name* = Application Manager
- (*Password stored in Radius server* = paul)
- *Role* = Application Creator AWS (custom role with AWS default templates only)

**5. Olivia: Super-NetOps**

Click on *Add*

- *Auth Provider* = local
- *User Name* = olivia
- *Full Name* = Super-NetOps
- *Password* = olivia
- *Role* = Application Creator VMware (custom role with ALL default templates)

Click on *Save & Close*

.. warning:: Only local users are supported to execute Ansible playbook until Ansible 2.7. It will be possible to use auth_provider in release 2.8.

.. image:: ../pictures/module1/img_module1_lab2_1.png
  :align: center
  :scale: 50%

|

Application Creator VMware custom role:

.. image:: ../pictures/module1/img_module1_lab2_2.png
  :align: center
  :scale: 50%
