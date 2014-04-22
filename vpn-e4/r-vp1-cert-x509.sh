#!/bin/bash

#Configuration ssh pour s'authentifier sant mot de passe 
ssh-keygen -t rsa
ssh-copy-id -i /root/.ssh/id_rsa root@r-vp2
service ssh restart

#Génération de l'autorité de certification 
/usr/lib/ssl/misc/CA.pl -newca

#Generation du certificat de r-vp1
/usr/lib/ssl/misc/CA.pl -newreq

#Signature du certificat de r-vp1
/usr/lib/ssl/misc/CA.pl -sign

#Deplacement des fichiers cert et key dans le dossier de racoon
mv newcert.pem /etc/racoon/certs/IPSECcert.pem
mv newkey.pem /etc/racoon/certs/IPSECkey.pem
mv newreq.pem /etc/racoon/certs/IPSECreq.pem

# Copie de l'Autorité de certification dans le repertoire de racoon
cp  /root/scripts/demoCA/cacert.pem /etc/racoon/certs/

#Génération de la liste de révocations des certificats
openssl ca -gencrl -out crl.pem

#Copie de la liste de révocation dans racoon
cp crl.pem /etc/racoon/certs

#Lien entre cacert.pem et hash 
cd /etc/racoon/certs/
ln -s cacert.pem $(openssl x509 -noout -hash < cacert.pem).0

#Lien entre crl.pem et hash 
cd  /etc/racoon/certs/
ln -s crl.pem $(openssl x509 -noout -hash < cacert.pem).r0

#Déchiffrement mot de passe de la clé pour racoon
cd /etc/racoon/certs/
openssl rsa -in IPSECkey.pem -out IPSECkey.pem

#Generation du certificat de r-vp2
/usr/lib/ssl/misc/CA.pl -newreq

#Signature du certificat de r-vp2
/usr/lib/ssl/misc/CA.pl -sign

#Copie des fichiers du certificat sur r-vp2
scp /root/scripts/demoCA/cacert.pem newcert.pem newkey.pem newreq.pem crl.pem r-vp2:/etc/racoon/certs/