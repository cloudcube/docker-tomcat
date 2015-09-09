#!/bin/bash
set -e
set -x

# configure tomcat admin user/password
TOMCAT_ADMIN_USER=${TOMCAT_ADMIN_USER:-admin}
TOMCAT_ADMIN_PASSWORD=${TOMCAT_ADMIN_PASSWORD:-admin}
sed 's,{{TOMCAT_ADMIN_USER}},'"${TOMCAT_ADMIN_USER}"',g' -i /opt/tomcat/conf/tomcat-users.xml
sed 's,{{TOMCAT_ADMIN_PASSWORD}},'"${TOMCAT_ADMIN_PASSWORD}"',g' -i /opt/tomcat/conf/tomcat-users.xml



if [ ! -f /opt/tomcat/webapps/isFile ]; then
    touch /opt/tomcat/webapps/isFile
    cd /opt/tomcat/
    mv webapps.bak webapps
    # mv /opt/tomcat/webapps.bak /opt/tomcat/webapps
    # sleep 50s
fi

exec supervisord -c /etc/supervisor/supervisord.conf
