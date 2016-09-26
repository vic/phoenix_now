FROM busybox

ARG APP
ARG VERSION

RUN mkdir /app
WORKDIR /app

COPY rel/$APP/releases/$VERSION/docker-$APP-$VERSION.tar.gz /app/tar.gz
RUN ls -la /app
RUN tar -xzf /app/tar.gz

WORKDIR /app/releases/$VERSION

EXPOSE 4000
CMD ["/bin/ls", "-la", "/app/bin"]