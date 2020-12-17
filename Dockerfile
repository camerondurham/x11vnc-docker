FROM ubuntu:16.04 as system

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
    && cd / && ln -s /etc/sv /service \
    && chown root /etc/sv

ENV DEBIAN_FRONTEND="nonintractive"

# settings.env contains environment variables for VNC port and X server
# sv contains service files
COPY rootfs /

#########################


################################################################################
# builder
################################################################################
FROM ubuntu:16.04 as builder



RUN apt-get update \
    && apt-get install -y --no-install-recommends curl ca-certificates gnupg patch

# nodejs
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - \
    && apt-get install -y nodejs

# yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install -y yarn

# build frontend
COPY web /src/web
RUN cd /src/web \
    && yarn \
    && yarn build
RUN sed -i 's#app/locale/#novnc/app/locale/#' /src/web/dist/static/novnc/app/ui.js



################################################################################
# merge
################################################################################
FROM system
LABEL maintainer="cameron.r.durham@gmail.com"

COPY --from=builder /src/web/dist/ /usr/local/lib/web/frontend/
COPY rootfs /
RUN ln -sf /usr/local/lib/web/frontend/static/websockify /usr/local/lib/web/frontend/static/novnc/utils/websockify && \
	chmod +x /usr/local/lib/web/frontend/static/websockify/run && \
    ln -s /etc/sv/* /etc/service/  && \
    cd / && ln -s /etc/sv /service && \
    chown root /etc/sv


EXPOSE 80
WORKDIR /root
ENV HOME=/home/ubuntu \
    SHELL=/bin/bash

#########################

EXPOSE 5920 6099

ENTRYPOINT ["./entrypoint.sh"]
