Lab 1.1: Create and Deploy Firewall Objects to Secure Applications

Lab 1.1: Create Shared Firewall Objects
****************************************
F5 Advanced Firewall Manager (AFM) configurations are built-up using a series of smaller object containers.  For example, a firewall policy may contain one or more rule lists, which contain firewall rules in an ordered list; a rule in  a rule list may contain one or more address lists, which contain lists of addresses or networks, and/or one or more port lists, which contain lists of ports.  Building firewall policies through a series of smaller building blocks, allows for object re-use across all firewall objects, and when managed through BIG-IQ allows for simple re-use of firewall objects across an entire fleet for F5 AFM instances.  In this excercise, we will create a few shared objects to be used in subsequent exercises for building a firewall policy.

.. note:: All steps in this lab will be completed using the persona Larry.

*Create Address Lists*:

1. Connect to your BIG-IQ (as *Larry*)and go to : *Configuration* > *Security* > *Network Security* > *Address Lists*
2. Click *Create* to create a new address list 
3. Edit the *Name* field, using the name ``deployed_app_destinations``
4. Click the *Addresses* button on left side of screen
5. Click the *Type* field to review the available options, then select *Address*
6. Add the address 10.1.10.118, and use site18 in the description
7. Click *Update*, then click *Save & Close* from bottom right

Create another address list identifying some known bad sources to block (small subset for Spamhaus EDROP):
1. Repeat steps 1-3 from above, this time using name ``deployed_app_bad_sources``
2. Click the *Addresses* button on left side of screen
3. Add the following to the address list
 - 5.188.11.0/24; description = Spamhaus EDROP member
 - 5.188.216.0/24; description = Spamhaus EDROP member
 - 14.118.252.0/22; description = Spamhaus EDROP member
 - Geolocation = Russian Federation; description = block those Russians

.. note :: Above sources are just being used for purpose of example.  Spamhaus EDROP list contains many more entries, and Russians aren't that bad!

 4.  Click *Save & Close*


*Create a Port List*:

1. Under *Configuration* > *Security* > *Network Security* >, click *Port List*
2. Click *Create* to create a new port list
3. Edit the *Name* field, using the name ``deployed_app_ports``
4. Click the *Ports* button on left side of the screen
5. Click the *Type* field too review the available options, the select *Port*
6. In the *Ports* field type ``80``, the click the + symbol, and add port ``443``
7. Click *Update*, then click *Save & Close* from the bottom right


Lab 1.2: Create Firewall Rules using Shared Firewall Objects
*************************************************************
Network firewalls use rules and rule lists to specify traffic-handling actions. The network software compares IP packets to the criteria specified in rules. If a packet matches the criteria, then the system takes the action specified by the rule. If a packet does not match any rule from the list, the software accepts the packet or passes it to the next rule or rule list. For example, the system compares the packet to self IP rules if the packet is destined for a network associated with a self IP address that has firewall rules defined.

Rule lists are containers for rules, which are run in the order they appear in their assigned rule list. A rule list can contain thousands of ordered rules, but cannot be nested inside another rule list. You can reorder rules in a given rule list at any time.

*Create Firewall Rule*:

1. Under *Configuration* > *Security* > *Network Security* > *Rule Lists*
2. Click *Create* to create a new rule list
3. Edit the *Name* field, using the name ``deployed_app_filters``
4. Click the *Rules* button left side of the screen
5. Click *Create Rule*
6. Click the pencil next to the new rule and edit as follows:
 - Name = bad_app_sources
 - Source Address = Address List = deployed_app_bad_sources
 - Action = drop 
 - Log = Check box to enable logging
 - Leave all other fields as any.
7. Click *Update* next to new rule.
8. Click *Create Rule*
9. Click the pencil next to the new rule and edit as follows:
- Name = deployed_app_dests 
- Destination Address = Address List = deployed_app_destinations
- Destination Ports = deployed_app_ports
- Protocol = TCP
- Action = Accept 
- Leave all other fields as any
10. Click *Save & Close*

*Manipulating Rules in Rules Lists*:

In this section, we will experiment with the various methods of re-ordering, editing, copying, and remove rules and rule contents

1.  From the Rule List screen, click on the ``deployed_app_filters`` rule list we just created, and experiment with options for manipulating the rules in the rules list:
- Drag the ``deployed_app_dests`` rule and drop it above the ``deployed_app_bad_sources`` rule
- Right click the ``deployed_app_dests`` rule and examine the available options.  Select *Cut Rule*, then select the ``bad_app_sources`` rule, right click and select *Paste After*
- Right click the ``deployed_app_bad_sources`` and select *Copy Rule*

2. Click *Cancel*, the click *Create* from Rule List screen
3. Click *Rules*, then *Create Rule*
4. Right click newly created rule, and select *Paste Before*.  The rule we copied from the ``deployed_app_filters`` has now been inserted in our new rule list.
.. note :: You can use Copy Rule and then Paste Rule between rule lists.  However, if you use the Cut Rule option and then paste betweeen rule lists, the cut rule will not be removed from the rule list.

5. Click the pencil next the rule you just inserted to edit the rule.  Click the "x" next to the ``deployed_app_destinations`` and ``deployed_web_app_ports`` lists to clear these fields from the rule.

.. note :: When editing a rule not all fields can be cleared, but you can remove the contents of the following fields:
 - Address (source or destination)
 - Port (source or destination)
 - VLAN
 - iRule
 - Description


6. Right click the rule initially created when you clicked *Create Rule*, and select *Delete Rule*
7. Click *Cancel* to exit rule list editor


*Managing Rule Lists*:

In this section, we will work with various options for managing rule lists

1. From the Rule List screen, select the ``deployed_app_filters`` rule list, and click the *Clone* button
 - Cloned rules provide a simple mechanism for copying an entire rule list, and making simple edits for new requirements.
2. Edit the Properties and Rules sections to meet new requirements.  For this lab, just go ahead and give the cloned rule a new name.  If you select a different partition in the cloned rule list, that partition must already exist on the BIG-IPs that the configuration will be deployed on.
3. Click *Save & Close* to save the newly cloned rule.  The cloned rule list is added to alphabetically under Rule Lists.  In a high availability configuration, the cloned rule list is replicated to the standby system as soon as it is cloned.
4. Click the cloned rule list.  In the bottom on the screen, view the elements of the rule list in the left hand pane.  In the right hand pane, click the *Related Items* button.  This will show you the objects related to the rule list, and the application components that are using the rule list.
5. Click the *Delete* button.  In this case, our cloned rule list isn't being used, so it is safe to delete.  If, however, the rule list was in use BIQ would present a dialog box informing you that you cannot remove the rule list because it is in use.



Lab 1.3: Create Firewall Policy, Publish, and Assign to Context
****************************************************************
Ultimately, the rule lists we worked with in the previous section are associated with a firewall policy for deployment.  Firewall policies, can be attached in multiple contexts (Global, Route Domain, Virtual Server, Self IP, and Management IP).  In this lab, we will explore using BIG-IQ to create a firewall policy, and look at options for attaching the policy in various contexts.  Finally, we will publish our firewall policy, and assign it to an application template.

*Creating Firewall Policies*:

1. Under *Configuration* > *Security* > *Network Security*, click *Firewall Policies*
2. Click *Create* to create a new firewall policy
3. Give the policy the name ``f5-afm-policy_118``, and click *Rules* button
4. Click *Add Rule List* button, and select the ``deployed_app_filters`` rule list created previously, and click Add.
5. The ``deployed_app_filters`` rule list will be added to the firewall policy, named as ``Reference_To_deployed_app_filters``.  From here, you can click the carrot beneath the rule ID and see the details of the rules that are part of the associated rule lists.
6. At the bottom on the Policy Editor screen, look at the Shared Objects view.  Click the drop down to see what Shared Objects can be added to a firewall policy.  
7. Select Rule Lists form the Shared Objects drop down.  Drag the ``deployed_app_filters`` rule list into the policy.
 - Rule Lists can be added using *Add Rule List* button, or just pulled in using the Shared Object repository.
8. Right click the duplicate reference to the ``deployed_app_filters`` rule list we just added.  
9. Examine the options for manipulating the ordering or rules or rule lists inside a firewall policy.
10. Select *Delete* to remove our duplicate reference.
11. Click the *Create Rule* button to add a new rule to the firewall policy
- Firewall policies contain and ordered list of rules and rules lists.  Using rule lists is a good method for organizing larger sets of rules, but not a requirement for building a firewall policy.
12. Click the pencil next to the new rule to edit the rule.
13. From the *Shared Objects* pane at the bottom on the Policy Editor screen, select *Address Lists* from the drop down.
14. Drag the address list ``deployed_app_bad_sources`` into the source address field in the rule we are editing.
- Address and Port lists can be dragged into rules inside firewall policy editor in the same way they can in rule list editor.
15. Click *Update*
16. Righ click the rule you just added and select *Delete*
17. Click *Save and Close* to create the new firewall policy.

*Associating Firewall Policies with Contexts*:

As mentioned, firewall policies can be attached to various contexts within a BIG-IP system.  Namely, policies can be attached at the Global, Route Domain, Virtual Server, Self-IP, and Management contexts.  In these exercises, we will explore using BIG-IQ to make these associations:

1. Under *Configuration* > *Security* > *Network Security*, click *Contexts*
2. In the search bar in the upper right corner, search for global.
3. Click the global context for the device ``SEA-vBIGIP01.termmarc.com``
4. Examine the *Properties* page.  A firewall policy can be attached as an *Enforced Firewall Policy* or a *Staged Firewall Policy*
5. From the *Shared Objects* section on bottom of screen, select *Firewall Policies*
6. Drag the ``f5-afm-policy_118`` policy into the row for *Enforced Firewall Policy*
- Shared objects (Firewall Policies, Service Policies, NAT Policies) can be dragged and dropped into the context.
7. Click *Cancel*
8. Clear the filter for Global. If interested, you can repeat the above steps for Self-IP, Route Domain, and/or VIP.

.. note :: To this point in the lab, we have not actually deployed any configuration to BIG-IP's.  All of our configuration has been created exclusively on BIG-IQ.  You can create a deployment now to push the objects that we have created, but we will do this as part of an application template update in a subsequent step.

Lab 1.4: Configure BIG-IQ Logging for AFM
******************************************
As of BIG-IQ 6.0, BIG-IQ supports remote log collecting and viewing for AFM policies.  The below steps will take you through the configuration required to support this feature:

1. Under *Configuration* > *Security* > *Network Security*, click *Contexts*
2. In the search bar in the upper right corner, search for ``site18``
3. Click the checkbox next to the lock symbol to select both the http and https virtual servers returned from search.
4. The *Configure Logging* button should now be available to click, click it.  

Unlike ASM logging configurations, Network Firewall logging configurations reference a number of system objects including: log publishers, destination, high speed log pools, and associated pool objects.  In order to create a logging profile to logs firewall events, these objects must already exist on the system.  By clicking *Configure Logging* BIG-IQ will create, if necessary, all the dependent objects and then create the logging profile that creates the objects.  BIG-IQ will display the dialog below, which outlines the objects that are being created:

.. image:: ../pictures/module1/afm_configure_logging_dialog.png
  :align: center
  :scale: 50%


5. Under *Configuration* > *Security* > *Network Security* > *Shared Security*, click *Logging Profiles*
6. Click the ``afm-remote-logging-profile`` created by BIG-IQ in previous step, the *Network Firewall* tab on left
7. Examine the options set by BIG-IQ when creating the logging profile.

.. note :: per https://support.f5.com/kb/en-us/products/big-iq-centralized-mgmt/manuals/product/big-iq-centralized-management-security-6-0-1/23.html#guid-525b3d56-f673-4569-85a5-0b979cb2cb35, none of the objects created in this manner should be modified.  Need to confirm whether this is the case.  Certainly seems reasonable that a customer would want to tweak these settings to meet their requirements.

8. Click *Cancel*

At this point, we have created all the objects necessary for logging firewall events.  However, we do need to verify that the Data Collection Devices (DCD) being used for this lab have the Network Security Service enabled.  To do this, follow the following steps:

1. We are currently logged in as Larry, the security manager, we need to log out of this role.  Then log in as the admin user.
2. Under *System* > *BIG-IQ Data Collection*, click *BIG-IQ Data Collection Devices*
3. Click on the device ``bigiq1dcd.example.com``, and click *Services* on left side.
4. Scroll down to *Network Security* and verify that service status is *Active*.  If not, activate.
5. Log out of system as Admin, and log back in as Larry.


Lab 1.4: Create new Application Template Using Firewall objects
****************************************************************
In this lab, we are going to attach our newly created firewall policies to application templates.

1. Under *Configuration* > *Security* > *Network Security*, click *Firewall Policies*
2. Click the checkbox next to ``f5-afm-policy_118``
3. Click the dropdown box on the *More* button and select *make available for templates*
- the firewall policy is now available for use with application templates on BIG-IQ
4. Click *Configuration* > *Security* > *Shared Security*, click *Logging Profiles*
5. Click the checkbox next to ``afm-remote-logging-profile``
6. Click the button *Make available for templates*
- the afm-remote-logging-profile is the logging profile BIG-IQ created for us when we configured logging in the previous exercise.

With the objects we created available for use with templates, we will now create a new template to use which references these objects.

For the steps below, we will use the *Marco* account to manipulate application templates
1. Under *Applications* > *Service Catalog* 
2. Check the box next to the ``Default-f5-HTTPS-WAF-lb-template``, click the dropdown box on the *More* button and select *Clone*
3. Name the cloned policy ``Default-f5-HTTPS-WAF-FW-lb-template``
4. Once editing the new template, select the *Security Policies* button
5. In the *Network Security* section, set the Enforced Firewall Policy to ``f5-afm-policy_118`` for both virtual servers.
6. In the *Shared Security* section, set the Logging Profiles to ``afm-remote-logging-profile`` for both virtual servers on the Standalone Device.
7. Click *Save & Close*
8. From the Service Catalog screen, select the template you just created ``Default-f5-HTTPS-WAF-FW-lb-template``, the click the *Publish* button.

At this point, we have created a new application template that is using our newly created firewall policy and logging profiles.  Next, we will associate an existing application with our new template.


Lab 1.5: Update Existing Application To Use New Application Template:
**********************************************************************
In previous labs, we have created and deployed a new application using a fresh template.  In this exercise, we are going to update an existing application to use a new template.

Complete the steps below logged in as *Marco*
1. Click the *Applications* tab, and click the *Applications* button.
2. Click the application ``site18.example.com``
3. In the upper right hand corner, click *Switch to Template* button

.. image:: ../pictures/module1/switch_to_template.png
  :align: center
  :scale: 50%

4. Select the ``Default-f5-HTTPS-WAF-FW-lb-template`` we just created.
5. In the template editor, in the Domain Names field, type site18.example.com
6. Click *Save & Close*

 - This will take a few moments, but the existing application is being re-configured with our updated template, which references our new firewall policy.

7. Once the application finishes deploying, click on the application ``site18.example.com``
8. Click the *Security* label under *Application Services*
9. Verify that the Network Firewall policy listed in the Security Configuration summary pane lists ``f5-afm-policy_118`` as the firewall policy.

.. image:: ../pictures/module1/app_sec_summary.png
  :align: center
  :scale: 50%


Lab 1.6 Monitoring Firewall Logging On BIG-IQ:
***********************************************
In this exercise, we will generate some traffic to be processes by the firewall policy, and use BIG-IQ monitoring to examine the results.

Complete the steps below logged in as *Larry*
1. Under *Monitoring* > *Events* > *Network Security*, click *Firewall*
2. View the current Firewall Event log, in filter box, enter ``site18`` to filter the log for our test application
- At this point, you probably will not have any events in the log.
3. From the ``Ubuntu 18.04 Lamp Server`` open an SSH session.
4. From the SSH session, run the following command:
.. code::cli
sudo nmap -sS 10.1.10.118 -D 10.1.10.7,10.1.10.8,10.1.10.9,5.188.11.1,5.188.11.2

This will use the nmap program to scan our test application using several different source addresses.  Our firewall policy will not allow all of the sources.

5. Refresh the Firewall Event Log.  This time you should see a number of events in the firewall log.
6. Click one of the events, and examine the details available

.. image:: ../pictures/module1/firewall_log_drop.png
  :align: center
  :scale: 50%

Why is the Firewall Event log not showing accepted connections, only drops?  <HINT: check the remote-afm-logging-profile>








