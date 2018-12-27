Lab 1.2: Configuring BIG-IP for DDoS Logging to BIG-IQ
-------------------------------------------------------

BIG-IP uses logging profiles to format and send DoS log messages to one more destinations. Prior to BIG-IQ 6.0, this confifuration
was done using log destinations, publishers and creating profiles in multiple steps. 

BIG-IQ CM offers a quick way to create this profile, along with all the plumbing bits of a pool member, monitor etc... when using DCDs as the log destination. 

*Note*: This procedure is near identical to lab 2.1.1 in *Class 7* which configures logging for AFM events. What is different is the service ports for log message desinations, 
so a DoS Publisher should still is required in this use case. Begin by creating a Device DoS Log Publisher which can then be re-used for virtual server specific DoS publishing as needed.

1. Log into the BIG-IQ CM
2. Under *System* > *BIG-IQ Data Collection* > *BIG-IQ Data Collection Devices*, click *Services*
3. Stuff
4. Under *Deployment...* Local Traffic as there are pool members to be deployed
5. Under *Deployment...* Network Security which will associate 


Observe the pop up window: it outlines the objects being created that you can now view/browse in BIG-IQ, along with the name of the new logging profile. This Logging Profile can now be selected for other DoS Logging contexts such
as a virtual server/protected object configuration on this BIG-IP. 

*Optional*

Logging profiles created and deployed use HSL only as the log destination. If local logging of DoS Events is desired for troubleshooting on the BIG-IP, the publisher must have 
the *local-syslog* log destination in the log publisher in use. 

1. Under *Configuration...* as all logging profiles are a property of Local Traffic, and referenced by various modules including Network Security
2. Modify Stuff
3. Under *Deployment...*

