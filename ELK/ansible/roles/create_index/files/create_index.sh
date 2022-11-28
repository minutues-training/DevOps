#!/bin/sh
#echo $*
#create index
curl -X PUT "$4:9200/$1?pretty" -u $2:$3
#create data view
curl -X POST "$4:5601/api/data_views/data_view" -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d'
{
  "data_view": {
     "title": "'$1'",
     "name": "'$1'"
  }
}
' -u $2:$3
#import dashboard
curl -X POST "$4:5601/api/saved_objects/_import?createNewCopies=true" -H "kbn-xsrf: true" --form file=@./export.ndjson -u $2:$3
