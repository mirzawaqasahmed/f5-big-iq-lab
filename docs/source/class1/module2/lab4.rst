Lab 2.4: Create Application
---------------------------
Connect as **Paula** to create a new application, go to *Applications* > *APPLICATIONS*, select the template you want to use to create your application.
Either choose one of the default template (``Default-f5-HTTP-lb-template``) or the custom template created in lab 3  (e.g. ``f5-HTTP-lb-custom-template``).

Type in a Name for the application you are creating.
Type the Prefix that you want the system to use to make certain that all of the objects created when you deploy an application are uniquely named.
If you want to append this prefix to the names of the objects that this application creates, keep Apply Prefix To Names selected. Appending the prefix to the objects in this application makes these objects easier to find using search filters.

To help identify this application when you want to use it later, in the Description field, type in a brief description for the application you are creating.

For Device, select the name of the device you want to deploy this application to.

Determine the objects that you want to deploy in this application.
To omit any of the objects defined in this template, click the  (X) icon that corresponds to that object.

To create additional copies of any of the objects defined in this template, click the  (+) icon that corresponds to that object.

For each object that you decide to include in the application, revise any of the settings that you want to change.
Note: You can select a value for an object that you are creating in this application that is also created as part of this application. That is, if your application template contains a pool member and a node, in most cases you want to use the node you are creating in the application for that pool member in the application. For example a template could define a pool MyPool1 and a node 45.54.45.54. To specify the application-created object, you select the value that is prefixed with a pound sign (#) when you select the value for that node. (That option would appear as #45.54.45.54 in the example cited here.)
