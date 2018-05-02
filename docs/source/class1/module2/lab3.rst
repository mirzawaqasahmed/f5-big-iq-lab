Lab 2.3: Create Application
---------------------------
Connect as **Paula** to create a new application, go to *Applications* > *APPLICATIONS*, select the template previously created ``f5-HTTPS-WAF-lb-template-custom1``.

Type in a Name for the application you are creating.

Type the Prefix that you want the system to use to make certain that all of the objects created when you deploy an application are uniquely named.
If you want to append this prefix to the names of the objects that this application creates, keep Apply Prefix To Names selected. Appending the prefix to the objects in this application makes these objects easier to find using search filters.

To help identify this application when you want to use it later, in the Description field, type in a brief description for the application you are creating.

For Device, select the name of the device you want to deploy this application to.

- Application Name: ``site18.example.com``

- Pool Members: ``10.1.20.118`` and ``10.1.20.119``
- Service Port: ``80``

- Name Virtual Server: ``vs_site18.example.com_https``
- Destination Address: ``10.1.10.118``
- Service Port: ``443``

- Name Virtual Server: ``vs_site18.example.com_redirect``
- Destination Address: ``10.1.10.118``
- Service Port: ``80``


Determine the objects that you want to deploy in this application.
To omit any of the objects defined in this template, click the  (X) icon that corresponds to that object.

To create additional copies of any of the objects defined in this template, click the  (+) icon that corresponds to that object.

For each object that you decide to include in the application, revise any of the settings that you want to change.
Note: You can select a value for an object that you are creating in this application that is also created as part of this application. That is, if your application template contains a pool member and a node, in most cases you want to use the node you are creating in the application for that pool member in the application. For example a template could define a pool MyPool1 and a node 45.54.45.54. To specify the application-created object, you select the value that is prefixed with a pound sign (#) when you select the value for that node. (That option would appear as #45.54.45.54 in the example cited here.)
