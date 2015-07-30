#
# Ubuntu 14.04 with tomcat Dockerfile
#
# Pull base image.
FROM java:8

MAINTAINER David Zhao “cloudcube@outlook.com”

ENV REFRESHED_AT 2015-07-30 22:00

USER root

RUN apt-get update

RUN apt-get install git openssh-server maven -y

RUN echo "export LC_ALL=C" >> /root/.bashrc                                               

# Install Supervisor.
RUN  apt-get install -y supervisor && sed -i 's/^\(\[supervisord\]\)$/\1\nnodaemon=true/' /etc/supervisor/supervisord.conf 

ADD adds/authorized_keys /authorized_keys

ADD config/config.sh /config.sh

RUN chmod u+x /config.sh

RUN sh /config.sh && rm /config.sh

ADD config/sshd.conf /etc/supervisor/conf.d/sshd.conf

ADD config/tomcat.conf /etc/supervisor/conf.d/tomcat.conf

EXPOSE 8080

EXPOSE 22 

ENV TOMCAT_VERSION 8.0.22


RUN wget http://archive.apache.org/dist/tomcat/tomcat-8/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -O /tmp/catalina.tar.gz

# Unpack
RUN tar xzf /tmp/catalina.tar.gz -C /opt
RUN ln -s /opt/apache-tomcat-${TOMCAT_VERSION} /opt/tomcat
RUN rm /tmp/catalina.tar.gz


# Remove unneeded apps
RUN rm -rf /opt/tomcat/webapps/examples
RUN rm -rf /opt/tomcat/webapps/docs


# Add roles
ADD assets /assets
RUN cp /assets/config/tomcat/tomcat-users.xml /opt/apache-tomcat-${TOMCAT_VERSION}/conf/

CMD ["/assets/init"]

