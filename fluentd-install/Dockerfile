FROM centos
RUN yum install httpd -y
#COPY index.html /var/www/html/
#RUN ln -sf /dev/stdout /var/log/httpd/access_log && ln -sf /dev/stderr /var/log/httpd/error_log

RUN curl -L https://toolbelt.treasuredata.com/sh/install-redhat-td-agent3.sh | sh
#RUN mv /etc/td-agent/td-agent.conf /etc/td-agent/td-agent.conf.old
COPY td-agent.conf /etc/td-agent/
RUN systemctl start td-agent.service

CMD /usr/sbin/httpd -D FOREGROUND
EXPOSE 80
