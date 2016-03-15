FROM debian:unstable
MAINTAINER Jose-Luis Rivas <me@ghostbar.co>

VOLUME /opt/repo
VOLUME /opt/keys
VOLUME /opt/conf
VOLUME /opt/src

WORKDIR /home/builder/src

RUN apt-get install build-essential -y

USER builder
COPY scripts/* /bin/

ENTRYPOINT ["entrypoint.sh", "-r"]
