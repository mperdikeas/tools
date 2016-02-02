#!/usr/bin/env bash
set -e
readonly PASS_FILE=~/esac.neuropublic.pwd
readonly DEST=172.31.148.22
dir=`mktemp -d` && cd $dir
printf "HTML will be exported in temp dir: [%s]\n" $dir
rm -f rawdar.html && cp ~/esac-rawdar/rawdar.html .
rm -fr rawdar.org.files/ && cp -Lr ~/esac-rawdar/rawdar.org.files/ . 2>&1 | grep -v cannot\ stat|| : #http://serverfault.com/a/153893
rm -f rawdar.zip && zip -r rawdar.zip rawdar.html rawdar.org.files/
printf "HTML exported in temp dir: [%s]\n" $dir
sshpass -f $PASS_FILE scp rawdar.zip user@$DEST:~/rawdar.war
sshpass -f $PASS_FILE ssh user@$DEST <<'ENDSSH'
./publish-rawdar.sh
ENDSSH


