#!/usr/bin/env bash
# http://unix.stackexchange.com/a/108239/24044
if [ $# -ne 1 ]
then
    echo "usage is $0 <new ignore pattern>"
else
    PATTERN=$1
    for d in $(find . ! -name ".svn" -type d)
    do
        svn info "$d" &> /dev/null
        if [ $? -eq 0 ]
        then
            svn -q propset svn:ignore -F <((svn propget svn:ignore ; echo "$PATTERN") | sort -u) "$d"
        fi
    done
fi