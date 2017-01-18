#!/bin/bash -e

[ "$HEAP_SIZE" == "auto" ] && {
  total_mem=$(cat /sys/fs/cgroup/memory/memory.limit_in_bytes)
  alloc_bytes=$(echo "$total_mem * .9" | bc | cut -f1 -d\.)
  export HEAP_SIZE="$((alloc_bytes /1024/1024))m"
}

ES_JAVA_OPTS+="-Xms${HEAP_SIZE} -Xmx${HEAP_SIZE}"

echo "Starting Elasticsearch..."
echo "ES_JAVA_OPTS: $ES_JAVA_OPTS"

exec /opt/elasticsearch/bin/elasticsearch -Des.logger.level=$ELASTICSEARCH_LOG_LEVEL \
                                          -Des.default.path.logs=${LOG_DIR} \
                                          -Djava.net.preferIPv4Stack=true \
                                          -Djava.net.preferIPv4Addresses
