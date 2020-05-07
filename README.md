# RES - Labo 04 - HTTP

## Step 1

1. Create a repo 

Création du répertoire 

> **Labo 04** 
	> **docker-images** 
		> **apache-php-image**   
			> **public-html** et Dockerfile

2. Create a Docker image from a base Docker image

Sur _Docker hub_, recherche d'image **hhtpd**, dont la documentation nous mène à un lien sur une image docker Apache avec php officielle. Cette image documente la manière dont il faut utiliser l'image avec un Dockerfile, nous avons ajouté ces lignes au Dockerfile : 

```
FROM php:7.2-apache
COPY ./public-html /var/www/html/
```

4. Explore the structure of the image

![](rapport-pictures/step1image1.PNG)

5. Add the conf/content

On ajoute dans **public-html** : index.html file et une styles.css pour afficher une animation de café 

```
docker build -t res/apache_php .
docker run -d -p 9090:80 res/apache_php
```

![](rapport-pictures/step1.image2.PNG)


