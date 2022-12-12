#To build this image: docker build . -t dockers:mc_vanilla

FROM debian:11

ENV LC_CTYPE C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -yq htop vim tmux openjdk-17-jdk openjdk-17-jre

RUN mkdir /server

EXPOSE 25565
WORKDIR /server/
ENTRYPOINT /server/run.sh
