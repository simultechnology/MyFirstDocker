#!/usr/bin/env bash

docker build -t simul-httpd24
#docker run -d -p 80:80 sample:2.0

docker run -d -p 9780:80 -p 9722:22 --name simul-httpd24 simul-httpd24