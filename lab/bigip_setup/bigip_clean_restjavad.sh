#!/bin/bash

bigstart stop restjavad 
rm -rf /var/config/rest/
rm -rf /shared/em/ssl.crt/*
rm -rf /var/log/restjavad*
bigstart start restjavad