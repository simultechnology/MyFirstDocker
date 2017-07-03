#!/usr/bin/env bash

docker build -t simul-httpd24 .
#docker run -d -p 80:80 sample:2.0

docker run -e XDEBUG_CONFIG="remote_host={{172.17.0.1}}" \
-d -p 9780:80 -p 9722:22 -v `pwd`/htdocs:/var/www/html/ --name myweb simul-httpd24

