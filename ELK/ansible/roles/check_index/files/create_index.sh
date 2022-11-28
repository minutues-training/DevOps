#!/bin/bash

status_code="$(curl -I -XHEAD --write-out %{http_code} --silent --output /dev/null 'http://localhost:9200/elasti/' -u elastic:minutus)"
echo "statuscode: '$status_code'"
if [ "$status_code" -eq 404 ]
then
	echo "works"
else
	echo "No"
fi
