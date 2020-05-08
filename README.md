# RES - Labo 04 - HTTP

## Step 1

1. Create a repo 

Création du répertoire 

> **Labo 04** 
	> **docker-images** 
		> **apache-php-image**   
			> **public-html** et Dockerfile

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

1. Création du répertoire

> **Labo 04**
	> **docker-images**
		> **express-image**
			> Dockerfile

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

