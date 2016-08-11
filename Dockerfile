FROM centos:7

MAINTAINER Takatsugu Ishikawa tissi0708@gmail.com

RUN ["yum", "install", "-y", "httpd"]

COPY index.html /var/www/html/

CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]

