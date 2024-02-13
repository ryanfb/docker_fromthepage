#!/bin/bash

docker exec -it "docker_fromthepage-mysql-1" sh -c '
mysql -u fromthepage -p"fromthepage" -e "UPDATE pages SET search_text = source_text WHERE source_text IS NOT NULL;" diary_development
'
