FROM      ubuntu
MAINTAINER Jeffery Utter "jeff@jeffutter.com"

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN locale-gen en_US.UTF-8
RUN echo 'LANG="en_US.UTF-8"' > /etc/default/locale
RUN dpkg-reconfigure locales

RUN apt-get update
RUN apt-get -y install unzip git openssh-server

RUN adduser gogs --home /home/gogs --shell /bin/bash --disabled-password --gecos ""

ADD http://gogs.dn.qbox.me/gogs_v0.4.2_linux_amd64.zip /home/gogs/gogs.zip

RUN chown -R gogs:gogs /home/gogs/*

RUN cd /home/gogs/ ;\
    unzip gogs.zip ;\
    sed s#session    optional     pam_motd.so  motd=/run/motd.dynamic noupdate##g /etc/pam.d/sshd ;\
    sed s#session    optional     pam_motd.so \# [1]##g /etc/pam.d/sshd

RUN chown -R gogs:gogs /home/gogs
ADD start.sh /start.sh
ADD settings /settings
RUN chmod 755 /start.sh ;\
    chmod 755 /settings

CMD ["/start.sh"]
