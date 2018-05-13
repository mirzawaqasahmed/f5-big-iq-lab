Lab 2.3: Troubleshooting Security
---------------------------------
Connect as **paula**.
Go to *Applications* > *APPLICATIONS*:

1. Select one of the WAF application ``site36.example.com`` and turn on Enhanced Analytics, at the top right of the screen.

2. Let's generate some 404 error, connect on the *Ubuntu Lamp Server* server and launch the following command:

``# /home/f5/scripts/generate_bad_traffic.sh``

3. See the spike in analytics

The first chart in the Security charts section, is showing legal/blocked/alarmed transactions.
You can tell by the ratio of these 3 categories if it really makes sense that one application got it all blocked vs another application that has some blocked and some legal.

4. Show Comparaison chart

Select 2 items
Select different metrics
