#!/usr/bin/env bash

docker build -t sample:2.0 .
docker run -d -p 80:80 sample:2.0