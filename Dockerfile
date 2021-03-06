FROM ubuntu:16.04 as system

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        x11vnc \
        xvfb \
        fluxbox \
        runit \
        net-tools \
        xterm \
        novnc \
    && apt-get autoclean -y \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /etc/sv/socklog* /etc/service/* /var/log/socklog* \
    && ln -s /etc/sv/* /etc/service/ \
    && ln -s /etc/sv /service \
    && chown root /etc/sv

ENV DEBIAN_FRONTEND="nonintractive"

# settings.env contains environment variables for VNC port and X server
# sv contains service files
COPY rootfs /

WORKDIR /


ENTRYPOINT ["./entrypoint.sh"]
