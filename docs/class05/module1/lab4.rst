Lab 1.4: Uploading QKviews to iHealth for a support case
--------------------------------------------------------

BIG-IQ can now push qkviews from managed devices to ihealth.f5.com and
provide a report of heuristic hits based on the qkview. These qkview
uploads can be performed ad-hoc or as part of a F5 support case. If a
support case is specified in the upload job, the qkview(s) will
automatically be associated/linked to the support case.

1. Navigate to **Monitoring** on the top menu bar and then to
   **REPORTS-> Device-> iHealth** -> **Configuration** on the left-hand
   menu\ **.**

   |image93|

2. Add Credentials to be used for the qkview upload and report
   retrieval. Click the Add button under Credentials.

   |image94|

3. | Fill in the credentials that you used to access
     https://ihealth.f5.com :
   | Name: **Give the credentials a name to be referenced in BIG-IQ**
   | Username: **<Username you use to access iHealth.f5.com>**
   | Password: **<Password you use to access iHealth.f5.com**>

4. Click the Test button to validate that your credentials work.

   |image95|

5. Click the **Save & Close** button in the lower right.

6. Click the **Tasks** button in the BIG-IQ iHealth menu.

   |image96|

7. Click the **QKView Upload** button to select which devices we need to
   upload QkViews from:

   |image97|

8. | Fill in the fields to upload the QkViews to iHealth.
   | Name: **QKViewUpload5346** (append the last 4 digits of your cell
     number to make this request unique)
   | Credentials: **<Select the credentials you just stored in step 5>**
   | Devices: Select **ip-10-1-1-7.us-west-2.compute.internal**

|image98|

1. Click the **Save & Close** button in the lower right. The task will
   be started immediately.

   \*Note that you can also schedule QKview uploads on a regular basis
   using the **QKView Upload Schedules** on the left menu bar

2. Click on the name of your upload job to get more details

   |image99|

3. Observe the progress of the Qkview creation, retrieval, upload,
   processing, and reporting. This operation can take some time, so you
   may want to move on to the next exercise and come back.

4. Once a job reaches the Finished status, click on the Reports menu to
   review the report.

   |image100|

5. Select the report you just created and click the **Open** hyperlink
   under the Report Column

   |image101|

6. You can also run the Upgrade Advisor from the BIG-IQ if you are
   running an older version of code. Select **Upgrade Advisor Reports**
   from the left-hand menu bar and then click the **Create** button in
   the main window pane.

7. Give your Upgrade Advisor Task a name and select the **ip-10-1-1-7**
   device. Choose your Target Version and then **Save & Close**

8. Click on the **Upgrade Advisor Reports** on the left-hand menu bar
   and your new report should show up shortly. You can see the status of
   the report generation by clicking **Tasks** on the left-hand
   menu-bar. Click on the **Target Software Version** column to view
   your results.

The End

   .. |image57| image:: media/image57.png
      :width: 6.50000in
      :height: 2.26458in
   .. |image58| image:: media/image58.png
      :width: 3.55095in
      :height: 1.12295in
   .. |image59| image:: media/image59.png
      :width: 2.77869in
      :height: 1.19931in
   .. |image60| image:: media/image60.png
      :width: 4.84426in
      :height: 1.91390in
   .. |image61| image:: media/image61.png
      :width: 6.50000in
      :height: 1.54375in
   .. |image62| image:: media/image62.png
      :width: 3.48361in
      :height: 1.43265in
   .. |image63| image:: media/image63.png
      :width: 6.50000in
      :height: 1.77569in
   .. |image64| image:: media/image64.png
      :width: 6.50000in
      :height: 2.03819in
   .. |image65| image:: media/image65.png
      :width: 6.50000in
      :height: 1.24931in
   .. |image66| image:: media/image66.png
      :width: 1.90883in
      :height: 1.11475in
   .. |image67| image:: media/image67.png
      :width: 2.24590in
      :height: 1.10238in
   .. |image68| image:: media/image68.png
      :width: 5.95902in
      :height: 3.15387in
   .. |image69| image:: media/image69.png
      :width: 4.90302in
      :height: 4.77049in
   .. |image70| image:: media/image70.png
      :width: 6.50000in
      :height: 1.25278in
   .. |image71| image:: media/image71.png
      :width: 1.60397in
      :height: 0.21872in
   .. |image72| image:: media/image71.png
      :width: 1.60397in
      :height: 0.21872in
   .. |image73| image:: media/image72.png
      :width: 6.50000in
      :height: 1.30833in
   .. |image74| image:: media/image73.png
      :width: 6.50000in
      :height: 1.04444in
   .. |image75| image:: media/image74.png
      :width: 6.50000in
      :height: 0.83611in
   .. |image76| image:: media/image75.png
      :width: 3.39984in
      :height: 0.85246in
   .. |image77| image:: media/image76.png
      :width: 6.50000in
      :height: 0.73333in
   .. |image78| image:: media/image77.png
      :width: 5.14127in
      :height: 2.46233in
   .. |image79| image:: media/image78.png
      :width: 3.51639in
      :height: 1.47646in
   .. |image80| image:: media/image79.png
      :width: 6.50000in
      :height: 0.71667in
   .. |image81| image:: media/image80.png
      :width: 6.50000in
      :height: 0.55903in
   .. |image82| image:: media/image81.png
      :width: 2.26013in
      :height: 0.93738in
   .. |image83| image:: media/image82.png
      :width: 6.50000in
      :height: 1.12500in
   .. |image84| image:: media/image81.png
      :width: 2.26013in
      :height: 0.93738in
   .. |image85| image:: media/image83.png
      :width: 4.62442in
      :height: 1.35400in
   .. |image86| image:: media/image84.png
      :width: 3.92659in
      :height: 1.02071in
   .. |image87| image:: media/image85.png
      :width: 2.45803in
      :height: 0.56243in
   .. |image88| image:: media/image86.png
      :width: 6.50000in
      :height: 1.82639in
   .. |image89| image:: media/image87.png
      :width: 4.93125in
      :height: 3.26643in
   .. |image90| image:: media/image88.png
      :width: 2.28096in
      :height: 1.23943in
   .. |image91| image:: media/image89.png
      :width: 4.59341in
      :height: 4.11475in
   .. |image92| image:: media/image90.png
      :width: 4.52576in
      :height: 1.54098in
   .. |image93| image:: media/image91.png
      :width: 5.94973in
      :height: 4.06557in
   .. |image94| image:: media/image92.png
      :width: 1.88518in
      :height: 0.92697in
   .. |image95| image:: media/image93.png
      :width: 3.62295in
      :height: 2.27173in
   .. |image96| image:: media/image94.png
      :width: 1.93125in
      :height: 1.26279in
   .. |image97| image:: media/image95.png
      :width: 1.93125in
      :height: 1.06679in
   .. |image98| image:: media/image96.png
      :width: 6.38198in
      :height: 2.57377in
   .. |image99| image:: media/image97.png
      :width: 2.82256in
      :height: 0.74991in
   .. |image100| image:: media/image98.png
      :width: 1.93125in
      :height: 1.35353in
   .. |image101| image:: media/image99.png
      :width: 6.49097in
      :height: 1.23125in
   .. |image102| image:: media/image100.png
      :width: 5.84302in
      :height: 4.64525in
