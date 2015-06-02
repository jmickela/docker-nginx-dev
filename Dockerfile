# Nginx/PHP Container Image
FROM ubuntu:14.04
MAINTAINER Jason Mickela <jason@rootid.in>

RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install nginx
RUN apt-get -y install php5-fpm php5-mysql

#for running tests - debugging
RUN apt-get -y install php5-cli php5-curl php5-gd php5-dev php-pear
RUN pecl install xdebug

ADD nginx.conf /etc/nginx/nginx.conf
ADD php.ini /etc/php5/fpm/php.ini

RUN sed -i s/\;cgi\.fix_pathinfo\s*\=\s*1/cgi.fix_pathinfo\=0/ /etc/php5/fpm/php.ini

# Docker mounts volumes as user and group 1000, change the www-data uid and gid to match
RUN usermod www-data -u 1000
RUN groupmod www-data -g 1000

# add volumes for debug and file manipulation
VOLUME ["/var/log/", "/var/www"]

EXPOSE 80

#xdebug uses port 9000, set to 10000 because php5-fpm uses 9000
EXPOSE 10000
 
CMD service php5-fpm start && nginx