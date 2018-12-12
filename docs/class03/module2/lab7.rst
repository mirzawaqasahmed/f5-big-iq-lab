Lab 2.7: Troubleshooting 503 Service Unavailable
------------------------------------------------
Connect as **paula**.

The goal of this lab is to show how BIG-IQ can help to troubleshoot an 503 HTTP error.

1. Select application ``site40.example.com`` and turn on **Enhanced Analytics**, click on the button at the top right of the screen, and click on **Start**.

.. note:: Enhanced Analytics might be already turn on for site40.example.com

The Enhanced Analytics allows you to increase the application data visibility by collecting additional data for all, or specific, client IP addresses sending requests to the application.
Note: When this option is enabled, a banner appears at the top of the screen and highlights the application health icon in the applications list.

3. Let's generate additonnal traffic to the application ``site40.example.com``, connect on the *Ubuntu Lamp Server* server and launch the following command:

``# docker_hackazon_id=$(sudo docker ps | grep hackazon | awk '{print $1}')``

``# sudo docker cp demo-app-troubleshooting/f5_capacity_issue.php $docker_hackazon_id:/var/www/hackazon/web``

``# /home/f5/demo-app-troubleshooting/503.sh``

3. Back to BIG-IQ Application dashboard, open application ``site40.example.com`` and display the *Transaction* Analytics.

- Click Expand the right-edge of the analytics panel to get the filters.
- Move the *URLs* and the *Response Codes* tables next to each other and expand them both (the tables can be moved up/down).
- In the *Response Codes* table, select the *200* and *503* lines.

.. image:: ../pictures/module2/img_module2_lab7_1.png
   :align: center
   :scale: 50%

|

- Click right on the *Response Codes* and click on *Add Comparison Chart*.

.. image:: ../pictures/module2/img_module2_lab7_2.png
   :align: center
   :scale: 50%

|

- Finally, only select the *503* error in the filters and notice the page *f5_capacity_issue.php* shows up.

It appears from the data showing on BIG-IQ the application may start having issue (error 503) when there are more traffic going through it.

.. image:: ../pictures/module2/img_module2_lab7_3.png
   :align: center
   :scale: 50%

|

Using the data available in BIG-IQ Application dashboard, we can narrow down 503 error and troubleshoot the inability of an application to handle production data capacities.