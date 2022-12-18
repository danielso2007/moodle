# https://linuxize.com/post/creating-a-self-signed-ssl-certificate/
# https://letsencrypt.org/pt-br/getting-started/
cd certificate
openssl req -newkey rsa:4096 \
            -x509 \
            -sha256 \
            -days 3650 \
            -nodes \
            -out moodle_cert.crt \
            -keyout moodle_cert.key