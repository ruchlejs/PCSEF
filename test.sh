#!/bin/bash
cd $(dirname $0)
make clean
make test.bin
make test_to &
PIDTEST=$!
sleep 5
