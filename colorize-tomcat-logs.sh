#!/usr/bin/env bash

# https://gist.github.com/zakmac/8135974d0ade78483e3b

# ABOUT
# Add color to your Catalina output logs for [info, warn, error, severe, startup]
# - This isn't the smartest, so if there is a match for any of the listed statuses in an
#   output you can bet it'll be colorized

# USAGE
# catalina run 2>&1 | bash ~/colorize-tomcat-logs.sh

readonly RED=1
readonly GREEN=2
readonly BROWN=3
readonly CYAN=6
readonly BRIGHT_RED=9
readonly GREY=240


success=$(tput bold;tput setaf $GREEN)
successCondition=*Server" "startup" "in*

info=$(tput setaf $CYAN)
infoCondition=*INFO*

warn=$(tput setaf $BROWN)
warnCondition=*WARN*

error=$(tput setaf $BRIGHT_RED)
errorCondition=*ERROR*

severe=$(tput bold;tput setaf $RED)
severeCondition=*SEVERE*

fine=$(tput bold;tput setaf $GREY)
fineCondition=*FINE*

while read line; do

    if [[ $line == $successCondition ]]
    then
        echo $line | sed -e "s/\($1\)/$success/"
    elif [[ $line == $infoCondition ]]
    then
        echo $line | sed -e "s/\($1\)/$info/"
    elif [[ $line == $warnCondition ]]
    then
        echo $line | sed -e "s/\($1\)/$warn/"
    elif [[ $line == $errorCondition ]]
    then
        echo $line | sed -e "s/\($1\)/$error/"
    elif [[ $line == $severeCondition ]]
    then
        echo $line | sed -e "s/\($1\)/$severe/"
    elif [[ $line == $fineCondition ]]
    then
        echo $line | sed -e "s/\($1\)/$fine/"
    else
        echo $line
    fi

    printf $(tput sgr0) # sgr0: turn off all attributes (http://linuxcommand.org/lc3_adv_tput.php)

    done
