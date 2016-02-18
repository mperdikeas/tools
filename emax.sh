#!/usr/bin/env bash

echo "barzar"
if [[ ($# -ne 0) && ($# -ne 1) ]]; then
    echo "usage is $0 [optional name of emacs daemon file to TCP-connect to"
    exit 1
else
    echo "foo"
    if [[ ($# -eq 0) ]]; then
        echo "0 arg"
        emacsclient -t
    elif [[ ($# -eq 1) ]]; then
        FILE="$1"    
        if [ ! -f ~/.emacs.d/server/"$FILE" ]; then
            echo "starting daemon"
            emacs --daemon="$FILE"
            echo "daemon $FILE started, please issue command again to connect"
        fi
        emacsclient -f "$FILE" -t
    fi
fi
