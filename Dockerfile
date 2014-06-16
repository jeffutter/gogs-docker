FROM      ubuntu
MAINTAINER Jeffery Utter "jeff@jeffutter.com"

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN locale-gen en_US.UTF-8
RUN echo 'LANG="en_US.UTF-8"' > /etc/default/locale
RUN dpkg-reconfigure locales

RUN apt-get update
RUN apt-get -y install unzip git

RUN adduser gogs --home /home/gogs --shell /bin/bash --disabled-password --gecos ""

ADD http://gogs.dn.qbox.me/gogs_v0.4.2_linux_amd64.zip /home/gogs/gogs.zip

RUN chown -R gogs:gogs /home/gogs/*

USER gogs
ENV HOME /home/gogs
WORKDIR /home/gogs

RUN unzip gogs.zip

CMD ["/bin/bash"]
