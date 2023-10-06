#!/usr/bin/env sh

set -ex

mkdir -p ./coverage
lcov -c -d ./src -o coverage/lcov.info.info
# genhtml -o coverage/html coverage/lcov.info
