FROM centos:7

MAINTAINER Takatsugu Ishikawa tissi0708@gmail.com

# update yum
RUN yum update -y && yum clean all

# EPEL : エンタープライズ Linux 用の拡張パッケージ
# Remi provide newer versions of software

# enabledを1にすると、デフォルトのレポジトリがremiになるが、今回は0のままにしておく。

# epel,remi
RUN yum install -y epel-release && \
	yum install -y http://rpms.famillecollet.com/enterprise/remi-release-7.rpm && \
    yum clean all && \
	sed -i -e "s/enabled *= *1/enabled=0/g" /etc/yum.repos.d/epel.repo && \
	sed -i -e "s/enabled *= *1/enabled=0/g" /etc/yum.repos.d/remi.repo

# httpd, sshd, scp, openssl, sudo, which
RUN yum install -y httpd httpd-tools openssh-server openssh-clients openssl sudo which && yum clean all

# libmcrypt php-mcryptのインストールするのに必要
RUN yum install --enablerepo=epel -y libmcrypt && yum clean all

# gd-last (for php-gd)　PHP用グラフィックライブラリGD
RUN yum install --enablerepo=remi -y gd-last && yum clean all

# php-pecl-memcached
RUN yum install --enablerepo=remi,remi-php56 -y php-pecl-memcached && yum clean all

# php
RUN yum install --enablerepo=remi-php56 -y php php-devel php-gd php-mbstring php-mcrypt php-mysqlnd php-pear php-xml php-opcache && \
    yum clean all && \
	sed -i -e "s/;date.timezone *=.*$/date.timezone = Asia\/Tokyo/" /etc/php.ini

# composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# phpunit
RUN curl -L https://phar.phpunit.de/phpunit.phar > /usr/local/bin/phpunit && chmod +x /usr/local/bin/phpunit

# initialize for ssh
RUN sed -i '/pam_loginuid\.so/s/required/optional/' /etc/pam.d/sshd && ssh-keygen -A

# create login user
RUN useradd -d /home/www -m -s /bin/bash www && \
	echo www:www | chpasswd && \
	echo 'www ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# timezone
RUN cp -p /usr/share/zoneinfo/Japan /etc/localtime

#ENV WEBAPP_ROOT /webapp
#
#ADD ./httpd.conf /etc/httpd/conf/httpd.conf
#ADD ./index.html /webapp/public/index.html
#ADD ./phpinfo.php /webapp/public/phpinfo.php

EXPOSE 22 80

