#!/bin/sh
set -e

[ $ES_HEAP_SIZE == auto ] && {
  total_mem=$(cat /sys/fs/cgroup/memory/memory.limit_in_bytes)
	alloc_bytes=$(echo "$total_mem * .9" | bc | cut -f1 -d\.)
	ES_HEAP_SIZE=$((alloc_bytes /1024/1024))M
}

echo "Starting Elasticsearch..."
echo "Heap Size: $ES_HEAP_SIZE"

exec /opt/elasticsearch/bin/elasticsearch -Des.logger.level=$ELASTICSEARCH_LOG_LEVEL \
                                          -Des.default.path.logs=/var/log/elasticsearch
