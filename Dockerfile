#
# Ubuntu 14.04 with Tomcat Dockerfile
#
# Pull base image.
FROM java:8

MAINTAINER HaibinZhao "zhaohaibin@6starhome.com"

ENV REFRESHED_AT 2015-09-09 12:00

USER root

RUN \
    apt-get update && \
    apt-get install git openssh-server -y

RUN echo "export LC_ALL=C" >> /root/.bashrc

# Install Supervisor.
RUN  apt-get install -y supervisor && sed -i 's/^\(\[supervisord\]\)$/\1\nnodaemon=true/' /etc/supervisor/supervisord.conf

RUN \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


ADD adds/authorized_keys /authorized_keys

ADD config/config.sh /config.sh

RUN chmod u+x /config.sh

RUN sh /config.sh && rm /config.sh

ADD config/sshd.conf /etc/supervisor/conf.d/sshd.conf

ADD config/tomcat.conf /etc/supervisor/conf.d/tomcat.conf

EXPOSE 8080

EXPOSE 22

ENV TOMCAT_VERSION 8.0.22

ENV ACTIVITI_VERSION 5.17.0

ENV MYSQL_CONNECTOR_JAVA_VERSION 5.1.35

RUN wget http://archive.apache.org/dist/tomcat/tomcat-8/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -O /tmp/catalina.tar.gz

# Unpack
RUN tar xzf /tmp/catalina.tar.gz -C /opt
RUN ln -s /opt/apache-tomcat-${TOMCAT_VERSION} /opt/tomcat
RUN rm /tmp/catalina.tar.gz
ADD config/supervisor-wrapper.sh /opt/tomcat/bin/supervisor-wrapper.sh

# Remove unneeded apps
RUN mv /opt/tomcat/webapps/host-manager /opt/tomcat/host-manager.bak && \
    mv /opt/tomcat/webapps/manager /opt/tomcat/manager.bak && \
    mv /opt/tomcat/webapps/ROOT /opt/tomcat/ROOT.bak

# To install jar files first we need to deploy war files manually

VOLUME ["/opt/tomcat/webapps"]


# Add roles
ADD assets /assets
RUN chmod u+x /assets/startup.sh


RUN cp /assets/config/tomcat/tomcat-users.xml /opt/apache-tomcat-${TOMCAT_VERSION}/conf/

WORKDIR /assets

CMD ["/assets/startup.sh"]
