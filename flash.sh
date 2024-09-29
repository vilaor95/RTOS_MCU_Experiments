#!/bin/bash

source ./project.sh

make out.bin && \
	st-flash write out.bin 0x8000000
