Lab 2.4: Miscellaneous
----------------------
Connect as **paula**.
Go to *Applications* > *APPLICATIONS*:

Get user familiar with using timescales, drill downs, how to stop real time display and log correlation/overlay.
Toggle filters for category and Log Level

How to display raw stats vs. Analytics.

How to add/remove columns in raw stats.

How to sort raw data columns.

How to compare two or more items in the detailed right hand pane. i.e. compare pool members, or URLs.

Page Load Time is dependent on CPSM (Client side Perf Monitoring javascript injection).
Note it is not there with default HTTP profile.
Create an App the removes Accept-Encoding header so CPSM will work. Note that page load time now works.

Page Load Time (Request Header Erase: Accept-Encoding)

https://support.f5.com/csp/article/K13849
An HTTP response is eligible for CSPM injection under the following conditions:
·        The HTTP content is not compressed.
·        The HTTP content-type is text/html.
·        The HTTP content contains an HTML <head> tag.
For a response containing the CSPM injection to generate results, the client browser must support the Navigation Timing API (window.performance.timing).

Show differences in AVR profile on BIG-IP when advanced Analytics is enabled/disabled.
