#!/bin/bash

cd /etc/racoon/certs/

mv newcert.pem IPSECcert.pem
mv newkey.pem IPSECkey.pem
mv newreq.pem IPSECreq.pem

#Lien entre cacert.pem et hash sur r-vp2
cd /etc/racoon/certs/
ln -s cacert.pem $(openssl x509 -noout -hash < cacert.pem).0

#Lien entre crl.pem et hash  sur r-vp2
cd /etc/racoon/certs/
ln -s crl.pem $(openssl x509 -noout -hash < cacert.pem).r0

#Extraction IPSECkey.pem  sur r-vp2
openssl rsa -in IPSECkey.pem -out IPSECkey.pem