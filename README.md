Docker tomcat
# Introduction

Dockerfile  tomcat container image.

## Version

Current Version: **current**

# Installation

Pull the latest version of the image from the docker index. This is the recommended method of installation as it is easier to update image in the future. These builds are performed by the **Docker Trusted Build** service.

```bash
docker pull 192.168.0.240:4000/tomcat
```

Alternately you can build the image yourself.

```bash
git clone https://code.ad.6starhome.com/david/docker-tomat.git
cd docker-tomat
docker build -t 192.168.0.240:4000/tomcat .
```

# Quickstart

Run the activiti image

```bash
docker run --name='tomcat' \
    -p 18888:8080 \
    -p 12228:22 \
    -v /home/docker/docker_data/test/tomcat:/opt/tomcat/webapps
192.168.0.240:4000/tomcat
```

Point your browser to `http://<ip>:8080/manager` and login using the default username and password:

* username: **admin**
* password: **admin**

You should now have the Activiti application up and ready for testing. If you want to use this image in production the please read on.
