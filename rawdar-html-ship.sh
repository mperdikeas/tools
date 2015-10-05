#!/usr/bin/env bash
readonly PASS_FILE=~/esac.neuropublic.pwd
readonly DEST=172.31.148.22
rm -f rawdar.html && cp ~/esac-rawdar/rawdar.html .
rm -fr rawdar.org.files/ && cp -Lr ~/esac-rawdar/rawdar.org.files/ .
rm -f rawdar.zip && zip -r rawdar.zip rawdar.html rawdar.org.files/
sshpass -f $PASS_FILE scp rawdar.zip user@$DEST:~/rawdar.war
sshpass -f $PASS_FILE ssh user@$DEST <<'ENDSSH'
./publish-rawdar.sh
ENDSSH

