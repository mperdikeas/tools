#!/bin/bash
if [ $# -lt 1 ] ; then
    echo Usage: $0 file.jrxml param1=value1 param2=value2 ...
    exit 1
fi
JRXML=$(realpath "$1")
shift
cd /home/mperdikeas/neuro-jsf-pilot-svn-stable/trunk/CodeGen/Reports/RunJasper/dist || exit 1
java -cp $(echo lib/*jar | sed 's, ,:,g') -jar ./RunJasper.jar jdbc:postgresql://172.31.128.116:5444/stress gaiauser gaia-user-pwd "$JRXML" "$@"
