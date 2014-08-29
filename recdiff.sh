#!/usr/bin/env bash
echo "this is so not working (http://unix.stackexchange.com/a/49498/24044)"
if [ $# -ne 2 ]
then
    echo "usage is $0 <directory-a> <directory-b>"
else
    DIR_A=$1
    DIR_B=$2
    echo "non-symlink files that differ or files present in $DIR_A but not in $DIR_B"
    # Skip files in $DIR_A which are symlinks
    for f in `find $DIR_A ! -type l`
    do
        # Suppress details of differences
        diff -rq $f $DIR_B/${f#*/}
    done
    echo "non-symlink files that differ or files present in $DIR_B but not in $DIR_A"
    # Skip files in $DIR_B which are symlinks
    for f in `find $DIR_B ! -type l`
    do
        # Suppress details of differences
        diff -rq $f $DIR_A/${f#*/}
    done
fi