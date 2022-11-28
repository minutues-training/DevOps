#!/bin/bash

status_code="$(curl -I -XHEAD --write-out %{http_code} --silent --output /dev/null http://$4:9200/$1/ -u $2:$3)"
#echo "statuscode: '$status_code'"
if [ "$status_code" -eq 200 ]
then
	curl -X POST "$4:5601/api/data_views/data_view" -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d'
{
  "data_view": {
     "title": "'$1'*",
     "name": "'$1'"
  }
}
' -u $2:$3

fi
