
# Docker image from docker hub
FROM resin/rpi-raspbian:jessie

# Me ;D
MAINTAINER Andrej Nankov <nanorocks@outlook.com>

# ARGUMENTS
ARG version
ENV SYNCTHING_USER syncthing
ENV UID 22000

# Coping start.sh to the docker image
COPY start.sh /

# This is path by default
RUN mkdir -p /home/syncthing/Sync

# For full access
RUN chmod 777 /home/syncthing/Sync 


# Get syncthing arm from github with wget, cleaning and adding user
RUN apt-get update -q && \
    apt-get install -qy \
        ca-certificates \
        wget && \
        wget https://github.com/syncthing/syncthing/releases/download/v0.14.43/syncthing-linux-arm-v0.14.43.tar.gz \
        -O /syncthing.tar.gz && \
    tar -xzvf syncthing.tar.gz && \
    mv sync*/syncthing /syncthing && \
    rm -rf syncthing.tar.gz syncthing-linux* && \
    chmod +x /start.sh && \
    useradd -g users --uid $UID $SYNCTHING_USER

# User nanorocks for dockerfile
USER $SYNCTHING_USER

# To executes the container by default when I launch the built image. One dockerfile one CMD ;D
CMD ["/start.sh"]
