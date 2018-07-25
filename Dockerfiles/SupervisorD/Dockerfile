FROM centos:7

LABEL maintainer="doss"

RUN yum install -y epel-release
RUN yum update -y && yum install -y which sudo httpd php openssh-server

#configure sshd to get it started
#there could be issues for other keys, but it seems that sshd starts so keep it simple now
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ""

RUN yum install -y supervisor
#not sure why this needed, commenting for now:
#RUN mkdir -p /var/lock/apache2 /var/run/apache2 /var/run/sshd /var/log/supervisor 

#get config for supervisor from dir with Dockerfile
COPY supervisord.ini /etc/supervisord.d/supervisord.ini

EXPOSE 22 80

#start supervisord which will start other required serivces
CMD ["/usr/bin/supervisord"]
