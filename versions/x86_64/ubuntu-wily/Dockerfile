FROM ubuntu:wily
MAINTAINER Jose-Luis Rivas <me@ghostbar.co>

VOLUME /opt/pkgs
VOLUME /opt/src

WORKDIR /opt/workplace

RUN apt-get update && apt-get install build-essential devscripts -y

COPY scripts/* /bin/

ENTRYPOINT ["entrypoint.sh"]
