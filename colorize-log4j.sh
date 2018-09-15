#!/usr/bin/env bash

readonly RED=1
readonly GREEN=2
readonly YELLOW=3
readonly BLUE=4
readonly MAGENTA=5
readonly CYAN=6
readonly GREY=7
readonly BRIGHT_RED=9


# FATAL
# ERROR
# WARN
# INFO
# DEBUG
# TRACE

fatal=$(tput bold;tput setaf $RED)
fatalREGEXP=*FATAL*

error=$(tput setaf $RED)
errorREGEXP=*ERROR*

warn=$(tput setaf $YELLOW)
warnREGEXP=*WARN*

info=$(tput setaf $BLUE)
infoREGEXP=*INFO*

debug=$(tput setaf $CYAN)
debugREGEXP=*DEBUG*

trace=$(tput setaf $GREY)
traceREGEXP=*TRACE*


while read line; do

    if [[ $line == $fatalREGEXP ]]
    then
        echo $line | sed -e "s/\($1\)/$fatal/"
    elif [[ $line == $errorREGEXP ]]
    then
        echo $line | sed -e "s/\($1\)/$error/"
    elif [[ $line == $warnREGEXP ]]
    then
        echo $line | sed -e "s/\($1\)/$warn/"
    elif [[ $line == $infoREGEXP ]]
    then
        echo $line | sed -e "s/\($1\)/$info/"
    elif [[ $line == $debugREGEXP ]]
    then
        echo $line | sed -e "s/\($1\)/$debug/"
    elif [[ $line == $traceREGEXP ]]
    then
        echo $line | sed -e "s/\($1\)/$trace/"
    else
        echo $line
    fi

    printf $(tput sgr0) # sgr0: turn off all attributes (http://linuxcommand.org/lc3_adv_tput.php)

    done
