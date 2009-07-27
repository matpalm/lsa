#!/usr/bin/env bash
set -x
time cat dat/test.$1.dat | ./feed_to_occurrence_matrix.rb > test.$1.womatrix 
time SVDLIBC/linux/svd -o test.$1 test.$1.womatrix
time cpp/bin/Release/lsa < test.$1.womatrix > test.$1.lsa.out
