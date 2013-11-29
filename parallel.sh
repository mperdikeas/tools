#!/usr/bin/env bash
if [ $# -ne 2 ]
then
    echo "usage is $0 <number-of-parallel-threads> <script to run>"
else
    N=$1
    SCRIPT=$2
    # for i in {1.."$N"} # http://unix.stackexchange.com/q/103121/24044
    for i in $(seq 1 1 $N)
    do
        "$SCRIPT" > $i.out 2> $i.err &
    done
fi

