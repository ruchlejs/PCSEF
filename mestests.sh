#!/bin/bash
cd $(dirname $0)
make clean
make kernel.bin
make run &
PIDTEST=$!
sleep 10
kill $PIDTEST
