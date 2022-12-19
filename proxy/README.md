# Criando o certificado

Entre na pasta ssl:

```
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout example1.key -out example1.crt
```

# Adicionar o nginx no host

```
sudo nano /etc/hosts
```

Verificar o IP do container `reverse` que é o nginx. Em seu docker-compose, o ip foi fixado em `11.5.0.2`. Esse endereço naõ deve mudar podendo ficar no host.

Adicionado:

```
11.5.0.2 tomcat.example.com
11.5.0.2 apache.example.com
```


# Obter o IP do proxy

```
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps --filter name=reverse -q)
```

# Criar um certificado inicial

Não é possível criar certificado localhost. Criar com o comando abaixo e copiar para a pasta `./data/certbot/conf/live/*`.

```
openssl req -x509 -out fullchain.pem -keyout privkey.pem \
  -newkey rsa:2048 -nodes -sha256 \
  -subj '/CN=tomcat.example.com' -extensions EXT -config <( \
   printf "[dn]\nCN=tomcat.example.com\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:tomcat.example.com\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")
```

criar na pasta `criar_certificado`;