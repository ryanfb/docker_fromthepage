docker_fromthepage
==================

A Dockerfile for building [FromThePage](https://github.com/benwbrum/fromthepage) and running a development server.

# Single container/process (with SQLite database)
 
* Test the build with `docker build .`
* Tag the build with `docker build -t fromthepage .`
* Run the build with `docker run -d -p 3000 --name fromthepage_dev fromthepage`
* Find the mapped port with `docker port fromthepage_dev 3000`, then access it in a browser

# Multiple containers/processes with `docker-compose` (with MySQL database)

* `docker-compose build`
* `docker-compose up -d`
* Find the mapped port with `docker-compose port fromthepage 3000`, then access it in a browser
