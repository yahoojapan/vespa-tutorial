#
# Copyright 2018 Yahoo Japan Corporation.
# Licensed under the terms of the MIT license.
# See LICENSE in the project root.
#
FROM docker.elastic.co/elasticsearch/elasticsearch:6.2.1

# install japanese tokenizer
RUN elasticsearch-plugin install analysis-kuromoji

# install ltr plugin
RUN elasticsearch-plugin install http://es-learn-to-rank.labs.o19s.com/ltr-1.0.0-es6.1.2.zip