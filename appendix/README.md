<!--
  Copyright 2018 Yahoo Japan Corporation.
  Licensed under the terms of the MIT license.
  See LICENSE in the project root.
-->
# Appendix

Vespa との動作比較のために、チュートリアルで用いた book インデックスのサンプルと同じデータを用いて、
以下の代表的な OSS 検索エンジンを構築するサンプルを付録として添付しています。

* [Solr](http://lucene.apache.org/solr/)
* [ElasticSearch](https://www.elastic.co/jp/products/elasticsearch)

なお、Vespa のサンプルと同様に、
実行には `docker` 及び `docker-compose` が必要となります。

## Solr

Solr の起動停止は `solr/boot.sh` によって行います。

```bash
// please move to solr directory first
$ cd solr/

// start Solr
$ ./boot.sh start

// stop Solr
$ ./boot.sh stop
```

起動した Solr は `8983` ポートで検索を受け付けます。

```bash
$ curl 'http://localhost:8983/solr/book/select?q=*:*&indent=true'
```

また、以下の URL にアクセスすることで Solr の UI にアクセスすることができます (ホスト名は適宜変えてください)。

```bash
http://localhost:8983
```

## ElasticSearch

ElasticSearch の起動停止は `elasticsearch/boot.sh` によって行います。

```bash
// please move to elasticsearch directory first
$ cd elasticsearch/

// start ElasticSearch
$ ./boot.sh start

// stop ElasticSearch
$ ./boot.sh stop
```

起動した ElasticSearch は `9200` ポートで検索を受け付けます。

```bash
$ curl 'http://localhost:9200/book/_search?q=*:*&pretty=true'
```

また、以下の URL にアクセスすることで Kibana の UI にアクセスすることができます (ホスト名は適宜変えてください)。

```bash
http://localhost:5601
```