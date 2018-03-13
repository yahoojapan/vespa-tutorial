<!--
  Copyright 2018 Yahoo Japan Corporation.
  Licensed under the terms of the MIT license.
  See LICENSE in the project root.
-->
# ドキュメント

チュートリアルのドキュメントは `asciidoc` で記述されています。

```
$ ls src/main/asciidoc/
index.adoc  images/     ...
```

以下のように `maven` を用いてビルドすることで、HTML 版のドキュメントが生成できます。

```
$ mvn
$ ls target/generated-docs/
index.html  images/     ...
```