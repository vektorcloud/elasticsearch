FROM quay.io/vektorcloud/oracle-jre:latest

# Install Elasticsearch
ENV ES_VERSION 5.1.2
ENV ES_URL https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ES_VERSION}.tar.gz

RUN apk add --no-cache bash bc && \
    cd /tmp/ && curl -Lskj $ES_URL | tar xzf - && \
    mv /tmp/elasticsearch-${ES_VERSION} /opt/elasticsearch && \
    adduser -D elastic && \
    mkdir -p /opt/elasticsearch/data /var/log/elasticsearch && \
    chown -Rf elastic /opt/elasticsearch /var/log/elasticsearch && \
    find /opt/elasticsearch -iname '*.exe' -delete -or -iname '*.bat' -delete

COPY run.sh /run.sh
COPY elasticsearch.yml /opt/elasticsearch/config/elasticsearch.yml

USER elastic
EXPOSE 9200 9300
VOLUME /opt/elasticsearch/data

CMD /run.sh
