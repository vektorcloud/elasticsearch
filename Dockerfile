FROM quay.io/vektorcloud/oracle-jre:latest

ENV ES_VERSION 5.5.0
ENV ES_URL https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ES_VERSION}.tar.gz

ENV HEAP_SIZE auto

RUN apk add --no-cache bash bc && \
    cd /tmp/ && curl -Lskj $ES_URL | tar xzf - && \
    mv /tmp/elasticsearch-${ES_VERSION} /elastic && \
    mkdir -p /elastic/data /elastic/logs && \
    adduser -D elastic && \
    chown -Rf elastic /elastic && \
    find /elastic -iname '*.exe' -delete -or -iname '*.bat' -delete

COPY run.sh /run.sh
COPY elasticsearch.yml /elastic/config/elasticsearch.yml

EXPOSE 9200 9300
VOLUME /elastic/data

CMD /run.sh
