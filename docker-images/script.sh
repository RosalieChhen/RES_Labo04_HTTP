#!/bin/bash
docker kill static_1 static_2 static_3 dynamic_1 dynamic_2 dynamic_3 reverseProxy
docker rm static_1 static_2 static_3 dynamic_1 dynamic_2 dynamic_3 reverseProxy
docker rmi -f res/apache_static res/express_dynamic res/apache_rp

docker build -t res/apache_static ./apache-php-image
docker build -t res/express_dynamic ./express-image
docker build -t res/apache_rp ./apache-reverse-proxy 

docker run -d --name static_1 res/apache_static	
ip_static_1=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' static_1)":80"

docker run -d --name static_2 res/apache_static
ip_static_2=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' static_2)":80"

docker run -d --name static_3 res/apache_static
ip_static_3=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' static_3)":80"

static_ip="http://${ip_static_1};http://${ip_static_2};http://${ip_static_3}"


docker run -d --name dynamic_1 res/express_dynamic
ip_dynamic_1=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' dynamic_1)":3000"

docker run -d --name dynamic_2 res/express_dynamic
ip_dynamic_2=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' dynamic_2)":3000"

docker run -d --name dynamic_3 res/express_dynamic
ip_dynamic_3=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' dynamic_3)":3000"

dynamic_ip="http://${ip_dynamic_1};http://${ip_dynamic_2};http://${ip_dynamic_3}"


echo "IpAdresses statiques : $ip_static_1, $ip_static_2, $ip_static_3"
echo "IpAdresses statiques : $ip_dynamic_1, $ip_dynamic_2, $ip_dynamic_3"

docker run -d -e STATIC_IP=$static_ip -e DYNAMIC_IP=$dynamic_ip -p 8080:80 --name reverseProxy res/apache_rp
