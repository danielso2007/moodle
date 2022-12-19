#!/bin/bash
#sudo openssl req -x509 -nodes -new -sha256 -days 1024 -newkey rsa:2048 -keyout RootCA.key -out RootCA.pem -subj "/C=BR/CN=Example-Root-CA"
#sudo openssl x509 -outform pem -in RootCA.pem -out RootCA.crt
sudo openssl req -new -nodes -newkey rsa:2048 -keyout privkey.pem -out fullchain.pem -subj "/C=BR/ST=RiodeJaneiro/L=RiodeJaneiro/O=Example-Certificates/CN=moodle.example.com"
sudo openssl x509 -trustout -req -sha256 -days 1024 -in fullchain.pem -CA RootCA.pem -CAkey RootCA.key -CAcreateserial -extfile moodle.ext -out fullchain.pem

#sudo apt-get install libnss3-tools
#sudo openssl pkcs12 -export -out moodle.example.com.pfx -inkey privkey.pem -in fullchain.pem
#sudo pk12util -d sql:$HOME/.pki/nssdb -i moodle.example.com.pfx
#sudo certutil -d sql:$HOME/.pki/nssdb -A -t "P,," -n 'dev cert' -i fullchain.pem

mv -f fullchain.pem ../data/certbot/conf/live/moodle.example.com/fullchain.pem
mv -f privkey.pem ../data/certbot/conf/live/moodle.example.com/privkey.pem