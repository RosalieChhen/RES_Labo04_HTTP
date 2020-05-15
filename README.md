# RES - Labo 04 - HTTP

## Step 1

1. Create a repo 

Création du répertoire docker-images/apache-php-image/

Dans ce dossier, on créé un dossier public-html et un Dockerfile.

2. Create a Docker image from a base Docker image

Sur _Docker hub_, recherche d'image **hhtpd**, dont la documentation nous mène à un lien sur une image docker Apache avec php officielle. La version que nous avons utilisé est la version 7.2, beaucoup plus récente que celle utilisée dans la vidéo. Cette image documente la manière dont il faut utiliser l'image avec un Dockerfile, nous avons ajouté ces lignes au Dockerfile : 

```
FROM php:7.2-apache
COPY ./public-html /var/www/html/
```

4. Explore the structure of the image

Tentative de connexion avec le serveur établi avec netcat : le serveur tourne et répond avec le code status _400 Bad Request_.

![](rapport-pictures/step1image1.PNG)

5. Add the conf/content

On ajoute dans **public-html** : index.html file et une styles.css pour afficher une animation de café 

```
docker build -t res/apache_php .
docker run -d -p 9090:80 res/apache_php
```

![](rapport-pictures/step1image2.PNG)


## Step 2a

1. Création du répertoire express-image dans docker-images, et ajout d'un Dockerfile.

2. Create a Docker image from a base Docker image

La version utilisé pour Node JS est la version 12.16.3, qui est donc plus récent que celle utilisée dans la vidéo. Nous avons ajouté ces lignes au Dockerfile :

```
FROM node:12.16.3

COPY src /opt/app

CMD ["node", "/opt/app/index.js"]
```

3. Add the content

Créer un répertoire src où on y ajoute un fichier index.js avec les lignes suivantes :

```
var Chance = require('chance');
var chance = new Chance();

console.log("Bonjour " + chance.name());
```

4. Explore the structure

On peut constater en démarrant le container que la version est la bonne

![](rapport-pictures/step2image1.png)

## Step 2b

1. Use the Express.js framework

Installer le framework js dans notre dossier "src" pour cela, nous avons utilisé les commandes suivantes :

```
npm install --save express
```

2. Return json payload on GET requests

Pour pouvoir retourner un payload json lorsqu'on accède à l'URL, nous avons modifié notre précédent index.js avec les lignes suivantes :

```
var Chance = require('chance');
var chance = new Chance();

var express = require('express');
var app = express();

app.get('/', function(req, res){
    res.send(generateEmployees(req.query.maxNb))
});

app.listen(3000, function(){
    console.log('Accepting HTTP requests on port 3000.')
});

function generateEmployees(maxNb){
    var numberOfEmployees = chance.integer({
        min: 0,
        max: maxNb
    });

    var employees = [];

    for(var i = 0; i < numberOfEmployees; ++i){
        var gender = chance.gender()
        employees.push({
            firstName: chance.first({
                gender: gender
            }),
            lastName: chance.last(),
            gender: gender,
            email: chance.email(),
            salary: chance.euro()
        });
    }

    return employees;
}
```

Pour que l'on puisse également voir si il était possible que le client puisse agir sur notre génération des employés, nous avons ajouté un paramètre à la requête '/' pour que l'on puisse dans notre navigateur avec une url de ce style : 

```
http://localhost:3000/?maxNb=12
```

![](rapport-pictures/step2image2.png)

3. Run and test the containers

## Step 3b

Configuration d'un reverse proxy dont on hardcode les adresses ip des containers qui font tourner le serveur web et teste du reverse proxy en interactif dans un container.

1. Configuration du reverse proxy

On lance un container avec l'image apache-php statique et un autre avec l'image express dynamique et on regarde leur adresse ip :

```
apache_static : 172.17.0.2
express_dynamic : 172.17.0.3
```

![](rapport-pictures/step3bimage1.PNG)

On contrôle en se plaçant dans la vm de docker (avec docker-machine sur windows) qu'on peut envoyer une requête GET / HTTP/1.0 au serveur, avec telnet aux 2 adresses ip.

![](rapport-pictures/step3bimage2.PNG) 

On lance un container avec l'image php:7.2-apache en interactif et port-mappé sur le port 8080.
```
docker run -it -p 8080:80 php:7.2-apache /bin/bash
```

 On créé une configruation dans le dossier etc/apache2/sites-available dans un fichier nommé 001-reverse-proxy.conf.

(Et installation de vim dans ce container).

Contenu du fichier de configuration (la première règle renvoie à la page dynamique et la règle générale à la page statique) : 

![](rapport-pictures/step3bimage3.PNG)

2. Tester le reverse proxy

Toujours dans le container, on active les modules nécessaire à la configuration (précisé dans la documentation), avec les commandes suivantes :

```
a2enmod proxy
a2enmod proxy_http

service apache2 restart
```

On établit la connexion à travers le reverse proxy, depuis l'extérieur (on utilise donc l'adresse ip utilisée par docker et le port 8080 auquel on a mappé le container du reverse-proxy).

Avec une requête qui doit suivre la première règle de la configuration (retourne page dynamique).

![](rapport-pictures/step3bimage4.PNG)

Avec une requête qui doit suivre la règle générale de la configuration (retourne page statique).

![](rapport-pictures/step3bimage5.PNG)

## Step 3c

Configuration d'un reverse proxy dont on hardcode les adresses ip des containers qui font tourner le serveur web et teste du reverse proxy avec une image pour le reverse-proxy.

1. On créé un dossier dans docker-images, pour le reverse-proxy avec un Dockerfile.

Contenu du Dockerfile : 

```
FROM php:7.2-apache

COPY conf/ /etc/apache2

RUN a2enmod proxy proxy_http
RUN a2ensite 000-* 001-*
```

2. Configuration du reverse proxy

Dans le dossier docker-images/apache-reverse-proxy/conf/sites-available, on créé les fichiers 000-default.conf et 001-reverse-proxy.conf. 

On lance un container avec l'image apache-php statique et un autre avec l'image express dynamique et on regarde leur adresse ip :

```
apache_php : 172.17.0.3
express : 172.17.0.2
```

Contenu du fichier de configuration (la première règle renvoie à la page dynamique et la règle générale à la page statique) : 

```
<VirtualHost *:80>
    ServerName rorobastien.res.ch

    #ErrorLog ${APACHE_LOG_DIR}/error.log
    #CustomLog ${APACHE_LOG_DIR}/access.log combined

    ProxyPass "/api/employees/" "http://172.17.0.2:3000/"
    ProxyPassReverse "/api/employees/" "http://172.17.0.2:3000/"
    
    ProxyPass "/" "http://172.17.0.3:80/"
    ProxyPassReverse "/" "http://172.17.0.3:80/"

</VirtualHost>
```

3. Test du reverse-proxy

On lance un container avec l'image apache-reverse-proxy.

![](rapport-pictures/step3cimage1.PNG)

On établit la connexion à travers le reverse proxy.

Avec une requête qui doit suivre la première règle de la configuration (retourne page dynamique).

![](rapport-pictures/step3cimage2.PNG)

Avec une requête qui doit suivre la règle générale de la configuration (retourne page statique).

![](rapport-pictures/step3cimage3.PNG)

4. Configurations DNS

On modifier le fichier hosts (sous windows) qui se trouve dans etc pour faire correspondre l'addresse ip utilisée par le reverse-proxy avec le nom du serveur :
```
192.168.99.100 	rorobastien.res.ch
```

Sur un browser, on voit que la configuration a fonctionné :

![](rapport-pictures/step3cimage4.PNG)

![](rapport-pictures/step3cimage5.PNG)





