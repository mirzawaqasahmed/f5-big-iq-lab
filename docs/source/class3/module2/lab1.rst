Lab 2.1: Troubleshooting 404
----------------------------
Connect as **Paula**.
Go to *Applications* > *APPLICATIONS*:

Page Load Time is dependent on CPSM (Client side Perf Monitoring javascript injection).
Note it is not there with default HTTP profile.
Create an App the removes Accept-Encoding header so CPSM will work. Note that page load time now works.

Show how to drill down to troubleshoot a 404 error. Have a pool of servers with identical content. Have one of the servers missing one item.
Send enough traffic to reach threshold to make application turn red due to 404 error.
Look at Analytics to see Response Codes. Notice 4xxx errors.
Turn on Advanced Analytics to get deeper information such as URL info.
See all the URL's in default mode, then should be able to filter on 404 errors on right panel, this should give you only the URL that is missing as well as the pool member which is missing the content.
Problem solved.

Show differences in AVR profile on BIG-IP when advanced Analytics is enabled/disabled.

Highlight the Advanced Analytics status in app list and panels (light blue), and also within the app stats itself.

Get user familiar with using timescales, drill downs, how to stop real time display and log correlation/overlay.
Toggle filters for category and Log Level


Page Load Time (Request Header Erase: Accept-Encoding)

https://support.f5.com/csp/article/K13849
An HTTP response is eligible for CSPM injection under the following conditions:
·        The HTTP content is not compressed.
·        The HTTP content-type is text/html.
·        The HTTP content contains an HTML <head> tag.
For a response containing the CSPM injection to generate results, the client browser must support the Navigation Timing API (window.performance.timing).
