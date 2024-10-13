#!/bin/bash

source ./project.sh

./flash.sh && st-util -u -m &

bash -i -c "${TOOLCHAIN_PREFIX}gdb out.elf -ex 'target extended-remote localhost:4242'"

killall st-util
