#!/bin/bash

source ./project.sh

make out.bin && \
	st-flash write out.bin 0x8000000 && \
	st-util &
${TOOLCHAIN_PREFIX}gdb out.elf -ex 'target extended-remote localhost:4242'
killall st-util
