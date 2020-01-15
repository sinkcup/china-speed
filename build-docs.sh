#!/bin/bash

rm -rf docs
mkdir -p docs/img/
cp README.md docs/
cp favicon.ico docs/img/

export LC_ALL=C.UTF-8
export LANG=C.UTF-8
mkdocs build --clean
