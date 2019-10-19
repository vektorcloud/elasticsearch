# elasticsearch

[![circleci][circleci]](https://circleci.com/gh/vektorcloud/elasticsearch)

Self-configuring Elasticsearch image build

# Usage

Start with a persistent data volume:

```bash
docker volume create elastic_data
docker run -d --name=elastic \
           -p 9200:9200 \
           -m 1024m \
           -v elastic_data:/elastic/data \
           --cap-add IPC_LOCK \
           --ulimit memlock=-1:-1 \
           --ulimit nofile=65536:65536 \
           quay.io/vektorcloud/elasticsearch:6
```

By default, elasticsearch will be started with 70% of the containers memory limit allocated to heap. To override this behavior, use the `HEAP_SIZE` variable:

```bash
docker run -d --name=elastic \
           -p 9200:9200 \
           -e HEAP_SIZE=1024m \
           --cap-add IPC_LOCK \
           --ulimit memlock=-1:-1 \
           --ulimit nofile=65536:65536 \
           quay.io/vektorcloud/elasticsearch:6
```

[circleci]: https://img.shields.io/circleci/build/gh/vektorcloud/elasticsearch?color=1dd6c9&logo=CircleCI&logoColor=1dd6c9&style=for-the-badge "elasticsearch"
