#!/bin/bash

docker exec -it "docker_fromthepage-fromthepage-1" sh -c '
echo "Adding origin..."
git remote rm origin
git remote add origin https://github.com/Simon-Dirks/fromthepage
git pull
git reset --hard
echo "Setting dev branch..."
git branch --set-upstream-to=origin/development development
echo "Pulling..."
git pull
'
