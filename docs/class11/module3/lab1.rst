Lab 1.1: Generating Simple DDoS Attacks
--------------------------------------------------------

With the DoS Profiles applied to the BIG-IP, we can now generate attack traffic that will be detected and mitigated. The Ubuntu host has several simple tools useful in generating packet and application based attacks that will be used. 

By logging to the DCDs of BIG-IQ, both archived reporting and real time dashboards can be used to display attack and traffic information. 

1. Begin by lauching a 
2. Expand the *Flood* category of attack types
3. Select *UDP Flood* and modify the settings as shown below: 


hping3 --rand-source -i u10000 --udp -p 53 10.1.10.203



.. note:: Most DoS Vector values are *per TMM*, with one common exception being Single Endpoint Sweep and Flood vectors which aggregates multiple packet types and applies the configured limit across all TMMs. 

