#!/usr/bin/env bash

SCRIPTNAME=`basename "$0"`

print_help() {
    cat <<EOF
 EOF
Usage: $SCRIPTNAME filename-to-watch command-to-execute
Uses 'inotifywait' to execute a command whenever 'filename' has been modified.

Inspired by http://superuser.com/a/181543/138891
Requires [sudo apt-get install inotify-tools]
EOF
}

# parse_parameters:
while [[ "$1" == -* ]] ; do
    case "$1" in
        -h|-help|--help)
            print_help
            exit
            ;;
        --)
            #echo "-- found"
            shift
            break
            ;;
        *)
            echo "Invalid parameter: '$1'"
            exit 1
            ;;
        esac
done

if [ "$#" != 2 ] ; then
    echo "Incorrect parameters. Use --help for usage instructions."
    exit 1
fi

FILENAME="$1"
COMMAND="$2"

while inotifywait -e close_write ${FILENAME}; do ${COMMAND}; done

