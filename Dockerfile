FROM alpine:latest

COPY glibc-2.21-r2.apk /tmp/glibc-2.21-r2.apk
RUN apk --update add bc curl ca-certificates tar bash && \
    apk add --allow-untrusted /tmp/glibc-2.21-r2.apk

ENV JAVA_VERSION 8u66
ENV JAVA_VERSION_BUILD 17
ENV JAVA_PACKAGE server-jre

# Download and unarchive Java
RUN mkdir /opt && curl -jksSLH "Cookie: oraclelicense=accept-securebackup-cookie"\
    http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION}-b${JAVA_VERSION_BUILD}/${JAVA_PACKAGE}-${JAVA_VERSION}-linux-x64.tar.gz \
    | tar -xzf - -C /opt &&\
    ln -s /opt/jdk1.* /opt/jdk &&\
    rm -rf /opt/jdk/*src.zip \
           /opt/jdk/lib/missioncontrol \
           /opt/jdk/lib/visualvm \
           /opt/jdk/lib/*javafx* \
           /opt/jdk/jre/lib/plugin.jar \
           /opt/jdk/jre/lib/ext/jfxrt.jar \
           /opt/jdk/jre/bin/javaws \
           /opt/jdk/jre/lib/javaws.jar \
           /opt/jdk/jre/lib/desktop \
           /opt/jdk/jre/plugin \
           /opt/jdk/jre/lib/deploy* \
           /opt/jdk/jre/lib/*javafx* \
           /opt/jdk/jre/lib/*jfx* \
           /opt/jdk/jre/lib/amd64/libdecora_sse.so \
           /opt/jdk/jre/lib/amd64/libprism_*.so \
           /opt/jdk/jre/lib/amd64/libfxplugins.so \
           /opt/jdk/jre/lib/amd64/libglass.so \
           /opt/jdk/jre/lib/amd64/libgstreamer-lite.so \
           /opt/jdk/jre/lib/amd64/libjavafx*.so \
           /opt/jdk/jre/lib/amd64/libjfx*.so

# Set environment
ENV JAVA_HOME /opt/jdk
ENV PATH ${PATH}:${JAVA_HOME}/bin

# Install Elasticsearch
ENV ES_VERSION 2.0.1
ENV ES_URL https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-${ES_VERSION}.tar.gz 

RUN adduser -D elasticsearch && \
    cd /tmp/ && \
    curl -Lskj $ES_URL | tar xzf - && \
    mv /tmp/elasticsearch-${ES_VERSION} /opt/elasticsearch && \
	  rm -f $(find /opt/elasticsearch -iname '*.exe' -or -iname '*.bat') && \
    rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

COPY config/ /opt/elasticsearch/config
COPY entrypoint.sh /entrypoint.sh

ENV ES_HEAP_SIZE auto

RUN mkdir -p /opt/elasticsearch/data /var/log/elasticsearch && \
    chown -Rf elasticsearch. /opt/elasticsearch /var/log/elasticsearch

VOLUME /opt/elasticsearch/data
EXPOSE 9200 9300
USER elasticsearch
CMD /bin/bash /entrypoint.sh
