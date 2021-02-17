FROM debian:buster

RUN apt-get update

RUN apt-get -y install openssl

RUN apt-get -y install wget

RUN apt-get -y install nginx
COPY ./srcs/nginx.conf /etc/nginx/sites-enabled
RUN rm -rf /etc/nginx/sites-enabled/default

RUN apt-get -y install mariadb-server
COPY ./srcs/mysql.sh .
RUN bash mysql.sh

RUN apt-get -y install php-fpm php-mysql php-mbstring

RUN	wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-english.tar.xz

RUN	tar xf phpMyAdmin-5.0.4-english.tar.xz && \
	rm -f phpMyAdmin-5.0.4-english.tar.xz && \
	mv phpMyAdmin-5.0.4-english /var/www/html/phpMyAdmin

RUN wget http://wordpress.org/latest.tar.gz && \
	tar -xzvf latest.tar.gz && rm -rf latest.tar.gz && \
	mv wordpress /var/www/html/
COPY ./srcs/wp-config.php /var/www/html/wordpress
RUN rm -rf /var/www/html/wordpress/wp-config-sample.php

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -subj "/C=ru/ST=Central/L=Moscow/O=CodingSchool/OU=6thWave/CN=sthrace/" \
    -keyout /etc/ssl/sthrace.key \
    -out /etc/ssl/sthrace.crt

RUN chown -R $sthrace:$sthrace /var/www/html/*
RUN chmod -R 755 /var/www/html/*

COPY ./srcs/autoindex.sh .

COPY ./srcs/launch.sh .

ENTRYPOINT bash launch.sh

# /var/www/html/index.nginx-debian.html // NGINX Welcome page
# /etc/nginx/nginx.conf // NGINX conf file that has been created before all other modules have beef installed
# ip addr show eth0  // Command to find out IP address
# /var/www/html // Server block directory