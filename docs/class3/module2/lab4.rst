Lab 2.4: Miscellaneous
----------------------
Connect as **paula**.
Open ``site42.example.com``.

1. **Page Load Time** is dependent on CSPM (Client side Perf Monitoring javascript injection).

An HTTP response is eligible for CSPM injection under the following conditions:

- The HTTP content is not compressed.
- The HTTP content-type is text/html.
- The HTTP content contains an HTML <head> tag.

Navigation Timing is currently supported by the following browsers:

- Internet Explorer 9 and later
- Mozilla Firefox 4 and later
- Chrome 10 and later

For a response containing the CSPM injection to generate results, the client browser must support the Navigation Timing API (window.performance.timing).
https://support.f5.com/csp/article/K13849

In order to get the page load time, there are 2 things:
- ``Page Load Time`` parameter in the HTTP Analytics profile attached to the virtual server needs to be enabled
- The ``Request Header Erase`` needs to be set to ``Accept-Encoding``

In order to test it quickly, let's manually set in the HTTP profile attached to ``site42.example.com`` on the ``BIG-IP SEA-vBIGIP01.termmarc.com``

.. image:: ../pictures/module2/img_module2_lab4_1.png
  :align: center
  :scale: 50%

|

.. note :: Other way could be to create a clone of a default template and change the parameter Request Header Erase within the template. Note we cannot modify the default built-in templates.

Launch a RDP session to have access to the vCenter webui (vCenter runs as an instance
in our ESXi). To do this, in your UDF deployment, click on the *Access* button
of the *ESXi 6.5.0 + vCenter* system and select *VCENTER THROUGH WIN7*

.. image:: ../../class2/pictures/module1/img_module1_lab3_5.png
    :align: center
    :scale: 50%

|

Open Chrome and navigate on the website http://site42.example.com. If you open the developer tools in the browser (ctrl+shift+i), you can see the F5 CSPM javascript added to the page.

.. image:: ../pictures/module2/img_module2_lab4_2.png
  :align: center
  :scale: 50%

|

Go back on the BIG-IQ and check you can see now the Page Load Time.

.. image:: ../pictures/module2/img_module2_lab4_3.png
  :align: center
  :scale: 50%

|

2. Differences when Enhanced Analytics are enabled or disable on the HTTP Analytics profile
Login to BIG-IP, go to ``SEA-vBIGIP01.termmarc.com`` BIG-IP, Local Traffic > Profiles > Analytics > HTTP Analytics.

.. image:: ../pictures/module2/img_module2_lab4_4.png
  :align: center
  :scale: 50%

|

.. image:: ../pictures/module2/img_module2_lab4_5.png
  :align: center
  :scale: 50%

|

3. Compare two or more items in the detailed right hand panel. i.e. compare pool members and URLs.

.. image:: ../pictures/module2/img_module2_lab4_6.png
  :align: center
  :scale: 50%

|

Select different metric:

.. image:: ../pictures/module2/img_module2_lab4_7.png
  :align: center
  :scale: 50%

|
