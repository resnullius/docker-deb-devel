FROM ubuntu:trusty
MAINTAINER Jose-Luis Rivas <me@ghostbar.co>

ENV DEBIAN_FRONTEND noninteractive

VOLUME /opt/pkgs
VOLUME /opt/src

WORKDIR /opt/workplace

RUN apt-get update && \
  apt-get install build-essential equivs devscripts pristine-tar git -y

COPY scripts/* /bin/

ENTRYPOINT ["entrypoint.sh"]
