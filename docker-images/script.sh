#!/bin/bash
docker build -t res/apache_static ./apache-php-image
docker build -t res/express_dynamic ./express-image
docker build -t res/apache_rp ./apache-reverse-proxy 

docker run -d --name static res/apache_static
export STATIC_IP=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' static)":80"

docker run -d --name dynamic res/express_dynamic
export DYNAMIC_IP=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' dynamic)":3000"

echo "IpAdress du container static $IP_STATIC"
echo "IpAdress du container dynamic $IP_DYNAMIC"

docker run -d -e STATIC_IP -e DYNAMIC_IP -p 8080:80 --name reverseProxy res/apache_rp
