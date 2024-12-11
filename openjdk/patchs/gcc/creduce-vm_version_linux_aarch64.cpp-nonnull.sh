#!/bin/bash
#uasge: time creduce --n `nproc` ~/git/auxiliary/openjdk/patch/asan/creduce-vm_version_linux_aarch64.cpp-nonnull.sh vm_version_linux_aarch64.cpp &> creduce.log
ulimit -t 10
set -x
baseCommand="g++ -Wall -Wextra -O3 -c -Wno-tautological-compare -Wno-unused-parameter -Wno-unknown-pragmas vm_version_linux_aarch64.cpp"
timeout 5 ~/software/gcc/gcc-14.2.0-binary/bin/${baseCommand} &> tmp.log &&
grep "argument 2 is null but the corresponding size argument 3 value is" tmp.log && \
timeout 5 ~/software/gcc/gcc-14.2.0-binary/bin/${baseCommand} -Wno-nonnull &> tmp.log && \
test `wc -l < tmp.log` -eq 0 && \
timeout 5 /usr/bin/${baseCommand} &> tmp.log && \
test `wc -l < tmp.log` -eq 0
