FROM php:7.2-apache

RUN apt-get update && \
    apt-get install -y nano

COPY apache2-foreground /usr/local/bin/
COPY template /var/apache2/templates 
COPY conf/ /etc/apache2

RUN a2enmod proxy proxy_http proxy_balancer lbmethod_byrequests headers status
RUN a2ensite 000-* 001-*
