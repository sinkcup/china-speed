#!/bin/bash

rm -rf docs
mkdir -p docs
cp README.md docs/

mkdocs build --clean
