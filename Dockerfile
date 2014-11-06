FROM      ubuntu
MAINTAINER Jeffery Utter "jeff@jeffutter.com"

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN locale-gen en_US.UTF-8 ;\
    echo 'LANG="en_US.UTF-8"' > /etc/default/locale ;\
    dpkg-reconfigure locales

RUN apt-get update
RUN apt-get -y install unzip git openssh-server

RUN adduser gogs --home /home/gogs --shell /bin/bash --disabled-password --gecos ""

RUN cd /home/gogs/ ;\
    wget http://gogs.dn.qbox.me/gogs_v0.5.5_linux_amd64.zip -O gogs.zip ;\
    unzip gogs.zip ;\
    rm gogs.zip ;\
    sed '/pam_loginuid.so/s/^/#/g' -i  /etc/pam.d/* ;\
    chown -R gogs:gogs /home/gogs

ADD start.sh /start.sh
ADD settings /settings
RUN chmod 755 /start.sh ;\
    chmod 755 /settings

CMD ["/start.sh"]
