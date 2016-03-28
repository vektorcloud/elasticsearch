FROM quay.io/vektorcloud/oracle-jre:latest

# Install Elasticsearch
ENV ES_VERSION 2.2.0
ENV ES_URL https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-${ES_VERSION}.tar.gz 

RUN apk add --no-cache bash bc && \
    cd /tmp/ && curl -Lskj $ES_URL | tar xzf - && \
    mv /tmp/elasticsearch-${ES_VERSION} /opt/elasticsearch && \
    adduser -D elasticsearch && \
    mkdir -p /opt/elasticsearch/data /var/log/elasticsearch && \
    chown -Rf elasticsearch. /opt/elasticsearch /var/log/elasticsearch && \
    find /opt/elasticsearch -iname '*.exe' -delete -or -iname '*.bat' -delete

COPY config/ /opt/elasticsearch/config
COPY entrypoint.sh /entrypoint.sh

EXPOSE 9200 9300
USER elasticsearch
VOLUME /opt/elasticsearch/data

CMD /bin/bash /entrypoint.sh
