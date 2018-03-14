<!--
  Copyright 2018 Yahoo Japan Corporation.
  Licensed under the terms of the MIT license.
  See LICENSE in the project root.
-->
# vespa-tutorial

検索エンジン [Vespa](http://vespa.ai/) の日本語環境チュートリアルのサンプルコードです。

チュートリアル資料が `gh-pages` として公開されているので、併せて参照してください。

* https://yahoojapan.github.io/vespa-tutorial/

## ライセンス

このサンプルコードは MIT ライセンスにて提供しています。
詳しくは LICENSE ファイルをご確認ください。

## 事前準備

このチュートリアルの実行には以下の2つのソフトウェアが必要です。

* [`docker`](https://www.docker.com/)
* [`docker-compose`](https://docs.docker.com/compose/)

事前にこれら2つを実行環境にインストールしてください。

### CentOS7 での例

```bash
// install docker
$ sudo yum install docker
$ sudo systemctl enable docker
$ sudo systemctl start docker

// install dokcer-compose
$ sudo curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
$ sudo chmod +x /usr/local/bin/docker-compose
```

## クイックスタート

取り急ぎ Vespa の動作を確認したい場合は、以下のように `boot.sh` を用いて Vespa クラスタを構築することができます
(Vespa クラスタの起動には *8GB* 程度のメモリが必要です、単体起動したい場合はチュートリアル資料を参照してください)。

```bash
// please move to vespa-tutorial directory first
$ cd vespa-tutorial/

// start Vespa cluster
$ ./boot.sh start

// stop Vespa cluster
$ ./boot.sh stop
```

起動した Vespa は `8080` ポートで検索を受け付けます。

```bash
$ curl 'http://localhost:8080/search/?lang=ja&query=入門'
```
