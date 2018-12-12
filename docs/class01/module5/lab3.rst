Lab 5.3: Deploying AS3 Templates on BIG-IQ
------------------------------------------

Task 6 - Create custom HTTP AS3 Template on BIG-IQ
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In this task, we will create a template which require a Service_HTTP object, force the service port to 8080, and prevent WAF (ASM) and IAM (APM) configuration.

1. Copy the below example of an AS3 service template into the Postman **BIG-IQ AS3 Template Creation** call.
It will create a new template in BIG-IQ AS3 Service Catalogue:

    POST https://10.1.1.4/mgmt/cm/global/appsvcs-templates

.. code-block:: yaml
   :linenos:

    {
        "description": "Task 6 - Create custom HTTP AS3 Template on BIG-IQ",
        "name": "HTTPcustomTemplateTask6",
        "schemaOverlay": {
            "type": "object",
            "properties": {
                "class": {
                    "type": "string",
                    "const": "Application"
                },
                "schemaOverlay": {},
                "label": {},
                "remark": {},
                "template": {},
                "enable": {},
                "constants": {}
            },
            "additionalProperties": {
                "allOf": [
                    {
                        "if": {
                            "properties": {
                                "class": {
                                    "const": "Service_HTTP"
                                }
                            }
                        },
                        "then": {
                            "$ref": "#/definitions/Service_HTTP"
                        }
                    }
                ],
                "not": {
                    "anyOf": [
                        {
                            "properties": {
                                "class": {
                                    "const": "IAM_Policy"
                                }
                            }
                        },
                        {
                            "properties": {
                                "class": {
                                    "const": "WAF_Policy"
                                }
                            }
                        }
                    ]
                }
            },
            "required": [
                "class"
            ],
            "definitions": {
                "Service_HTTP": {
                    "type": "object",
                    "properties": {
                        "virtualPort": {
                            "type": "integer",
                            "const": 8080,
                            "default": 8080
                        }
                    },
                    "dependencies": {
                        "policyIAM": {
                            "not": {}
                        },
                        "policyWAF": {
                            "not": {}
                        }
                    },
                    "additionalProperties": true
                }
            }
        }
    }


2. Logon on BIG-IQ, go to Application tab, then Application Templates. Look at the custom template created previous through the API.

|lab-3-1|

Note the AS3 Template cannot be created through BIG-IQ UI but only using the API. You can only delete a AS3 templates from the BIG-IQ UI.

You can see the Template in JSON format if you click on it.

|lab-3-2|

.. note :: For help with JSON Schema, there are lots of resources, but one good place to start is https://json-schema.org/learn.


Task 7 - Admin set RBAC for Olivia on BIG-IQ
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Let's update now Oliva's service catalog.

Logon on BIG-IQ as **david** go to the System tab, Role Management, Roles, CUSTOM ROLES, Application Roles, select **Application Creator AS3** 
and the custom role linked to the custom HTTP template previously created. Remove the **default** template from the allowed list. 
Click **Save & Close**.

|lab-3-3|


Task 8 - Deploy the HTTP Application Service using a Custom Template
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Now, let's deploy an application as Olivia using the AS3 template previously created in Task 6. Note in the below declaration, 
the virtualPort is set to 9090 while in the template, we force the virtualPort to a specific value and accept no other.

1. Using Postman, update the user to olivia/olivia in the **BIG-IQ Token (olivia)** call (body).

2. Copy below example of an AS3 Declaration into the body of the **BIG-IQ AS3 Declaration** collection in order to create the service on the BIG-IP through BIG-IQ:

POST https://10.1.1.4/mgmt/shared/appsvcs/declare?async=true


.. code-block:: yaml
   :linenos:
   :emphasize-lines: 34

    {
        "class": "AS3",
        "action": "deploy",
        "declaration": {
            "class": "ADC",
            "schemaVersion": "3.7.0",
            "id": "isc-lab",
            "label": "Task8",
            "target": {
                "hostname": "BOS-vBIGIP01.termmarc.com"
            },
            "Task8": {
                "class": "Tenant",
                "MyWebApp8http": {
                    "class": "Application",
                    "schemaOverlay": "HTTPcustomTemplateTask6",
                    "template": "http",
                    "statsProfile": {
                        "class": "Analytics_Profile",
                        "collectedStatsInternalLogging": true,
                        "collectedStatsExternalLogging": false,
                        "capturedTrafficInternalLogging": false,
                        "capturedTrafficExternalLogging": true,
                        "collectPageLoadTime": true,
                        "collectClientSideStatistics": true,
                        "collectResponseCode": true,
                        "sessionCookieSecurity": "ssl-only"
                    },
                    "serviceMain": {
                        "class": "Service_HTTP",
                        "virtualAddresses": [
                            "10.1.10.133"
                        ],
                        "virtualPort": 9090,
                        "pool": "pool_8",
                        "profileAnalytics": {
                            "use": "statsProfile"
                        }
                    },
                    "pool_8": {
                        "class": "Pool",
                        "monitors": [
                            "http"
                        ],
                        "members": [
                            {
                                "servicePort": 80,
                                "serverAddresses": [
                                    "10.1.20.132",
                                    "10.1.20.133"
                                ],
                                "shareNodes": true
                            }
                        ]
                    }
                }
            }
        }
    }

  
This will give you an ID which you can query using the **BIG-IQ Check AS3 Deployment Task**.

3. Use the **BIG-IQ Check AS3 Deployment Task** Postman calls to ensure that the AS3 deployment is successfull without errors: 

   GET https://10.1.1.4/mgmt/shared/appsvcs/task/<id>

4. As expected, note the error message returned due to the static value set in the template::

     "response": "declaration is invalid according to provided schema overlay: data['serviceMain'].virtualPort should be equal to constant",
                "status": 422


5. Update the "virtualPort" to 8080 and re-send the declaration.

6. Logon on **BOS-vBIGIP01.termmarc.com** and verify the Application is correctly deployed in partition Task8.

7. Logon on **BIG-IQ** as Olivia, go to Application tab and check the application is displayed and analytics are showing.

|lab-3-4|


Task 9 - Delete Task1 with their AS3 Applications
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

As david, use below AS3 declaration to delete couple of the application previoulsy created.

.. code-block:: yaml
   :linenos:

   {
       "class": "AS3",
       "action": "deploy",
       "persist": true,
       "declaration": {
           "class": "ADC",
           "schemaVersion": "3.7.0",
           "id": "example-declaration-01",
           "label": "Task9",
           "remark": "Task 9 - Delete Tenants",
           "target": {
               "hostname": "BOS-vBIGIP01.termmarc.com"
           },
           "Task1": {
               "class": "Tenant"
           }
       }
   }

Connect as **david** on BIG-IQ.

Here, we empty the tenant/partition of Task1. This should remove those partitions from BOS-vBIGIP01.termmarc.com. The relevant Apps 
should also disappear from BIG-IQ. 

.. |lab-3-1| image:: images/lab-3-1.png
   :scale: 60%
.. |lab-3-2| image:: images/lab-3-2.png
   :scale: 60%
.. |lab-3-3| image:: images/lab-3-3.png
   :scale: 60%
.. |lab-3-4| image:: images/lab-3-4.png
   :scale: 60%
