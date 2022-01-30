FROM ubuntu:20.04

# clean and update sources
RUN apt-get clean && apt-get update

# install notinteractive tzdata
ENV TZ=Europe/Kiev
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Installing Apache

RUN apt-get install -y apache2 php mysql-server php-mysqlnd && rm -f /etc/apache2/sites-enabled/000-default.conf
COPY httpd.conf /etc/apache2/sites-enabled/000-default.conf

RUN a2enmod actions && a2enmod headers && a2enmod rewrite && a2enmod cgid

# Setting workdir for docker

WORKDIR /var/www

# Exposing Apache port to host

EXPOSE 80

# Autostart apache

COPY httpd-foreground /usr/bin/
RUN chmod +x /usr/bin/httpd-foreground

CMD ["/usr/bin/httpd-foreground"]
