#!/usr/bin/env bash
if [ $# -lt 2 ]
then
    echo "usage is $0 <number-of-parallel-threads> <script or bash invocation to run>"
else
    N=$1
    shift
    SCRIPT_OR_COMMAND="$@"
    # for i in {1.."$N"} 
    # for i in $(seq 1 1 $N) # http://unix.stackexchange.com/q/103121/24044
    for ((i = 1 ; i <= $N ; i++ ))
    do
        if [ -e "$SCRIPT_OR_COMMAND" ] # it's a file
        then
            "$SCRIPT_OR_COMMAND" > $i.out 2> $i.err &
        else                           # it's a shell command, run it with eval
            eval "$SCRIPT_OR_COMMAND > $i.out 2> $i.err &"
        fi
    done
fi

