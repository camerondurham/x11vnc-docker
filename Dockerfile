FROM ubuntu:16.04

RUN apt-get update \
    && apt-get install -y \
    x11vnc \
    xvfb \
    fluxbox \
    runit

ADD sv /etc/sv

# link sv to service for runit to work
RUN rm -rf /etc/sv/socklog* /etc/service/* /var/log/socklog* \
    && ln -s /etc/sv/* /etc/service/ \
    && cd / && ln -s /etc/sv /service

ENV \
  DEBIAN_FRONTEND="nonintractive"

# settings.env contains environment variables for VNC port and X server
COPY settings.env /etc/settings.env

COPY entrypoint.sh /entrypoint.sh

EXPOSE 5920 6099

ENTRYPOINT ["./entrypoint.sh"]
