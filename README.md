# elasticsearch
Self-configuring Elasticsearch image build

# Usage

By default, elasticsearch will be started with 90% of the containers memory limit allocated to heap, e.g.:
```bash
docker run -d -p 9200:9200 -m512m quay.io/vektorcloud/elasticsearch:latest
```

To override this behavior, use the `ES_HEAP_SIZE` variable:
```bash
docker run -d -p 9200:9200 -e ES_HEAP_SIZE=1024m quay.io/vektorcloud/elasticsearch:latest
```
