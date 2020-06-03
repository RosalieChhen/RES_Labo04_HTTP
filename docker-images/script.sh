#!/bin/bash
docker build -t res/apache_static ./apache-php-image
docker build -t res/express_dynamic ./express-image
docker build -t res/apache_rp ./apache-reverse-proxy 

docker run -d --name static_1 res/apache_static	
ip_static_1=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' static_1)":80"

export STATIC_IP=${ip_static_1}


docker run -d --name dynamic_1 res/express_dynamic
ip_dynamic_1=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' dynamic_1)":3000"

export DYNAMIC_IP=${ip_dynamic_1}

echo "IpAdresses statiques : $ip_static_1"
echo "IpAdresses statiques : $ip_dynamic_1"

docker run -d -e STATIC_IP -e DYNAMIC_IP -p 8080:80 --name reverseProxy res/apache_rp
