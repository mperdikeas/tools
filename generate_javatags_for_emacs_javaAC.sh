#!/bin/bash
MUTIL_JAR=~/java-mutil/dist/mutil.jar
COMMONS_IO_JAR=~/java-mutil/lib/commons-io-2.0.1.jar
COMMONS_LANG_JAR=~/java-mutil/lib/commons-lang-2.4.jar
JSF_JAR=~/archetypes/repo-wide-libs/javax.faces-2.1.8.jar
JEE_JAR=~/archetypes/repo-wide-libs/javaee-web-api-6.0.jar
HIB_JAR=~/archetypes/repo-wide-libs/hibernate-jpa-2.0-api-1.0.1.Final.jar
JBO_JAR=~/archetypes/repo-wide-libs/jboss-ejb-api_3.1_spec-1.0.1.Final.jar
JJSF_JAR=~/archetypes/repo-wide-libs/jboss-jsf-api_2.1_spec-2.0.1.Final.jar
JSER_JAR=~/archetypes/repo-wide-libs/jboss-servlet-api_3.0_spec-1.0.0.Final.jar
CL3_JAR=~/archetypes/repo-wide-libs/commons-lang3-3.1.jar
EMACS_JAC_FOLDER=~/environment/.emacs.d/ajc-java-complete
JAVA_TAGS_FILE_NAME=.java_base.tag
JAVA_TAGS_FILE=~/$JAVA_TAGS_FILE_NAME
DATE=$(date +"%Y-%m-%d_%H%M%S")
JAVA_TAGS_FILE_BACKUP_NAME=$JAVA_TAGS_FILE_NAME"_"$DATE
BACKUP_FOLDER=~/.backup
JAVA_TAGS_FILE_BACKUP=$BACKUP_FOLDER/$JAVA_TAGS_FILE_BACKUP_NAME


if [ ! -d $EMACS_JAC_FOLDER ]
   then
        echo "$EMACS_JAC_FOLDER directory does not exist"
        exit 1;
fi

if [ -f $JAVA_TAGS_FILE ]
    then
    echo "$JAVA_TAGS_FILE exists creating backup"
    mkdir -p $BACKUP_FOLDER
    cp $JAVA_TAGS_FILE $JAVA_TAGS_FILE_BACKUP
fi


if [ ! -f $MUTIL_JAR ]        ; then echo "WARN: $MUTIL_JAR"        "file does not exist - generating tags without it" ; fi
if [ ! -f $COMMONS_IO_JAR ]   ; then echo "WARN: $COMMONS_IO_JAR"   "file does not exist - generating tags without it" ; fi
if [ ! -f $COMMONS_LANG_JAR ] ; then echo "WARN: $COMMONS_LANG_JAR" "file does not exist - generating tags without it" ; fi
if [ ! -f $JSF_JAR ]          ; then echo "WARN: $JSF_JAR"          "file does not exist - generating tags without it" ; fi
if [ ! -f $JEE_JAR ]          ; then echo "WARN: $JEE_JAR"          "file does not exist - generating tags without it" ; fi
if [ ! -f $HIB_JAR ]          ; then echo "WARN: $HIB_JAR"          "file does not exist - generating tags without it" ; fi
if [ ! -f $JBO_JAR ]          ; then echo "WARN: $JBO_JAR"          "file does not exist - generating tags without it" ; fi
if [ ! -f $JJSF_JAR ]         ; then echo "WARN: $JJSF_JAR"         "file does not exist - generating tags without it" ; fi
if [ ! -f $JSER_JAR ]         ; then echo "WARN: $JSER_JAR"         "file does not exist - generating tags without it" ; fi
if [ ! -f $CL3_JAR ]          ; then echo "WARN: $CL3_JAR"          "file does not exist - generating tags without it" ; fi



if [ -z "$JAVA_HOME" ]; then
    echo "$JAVA_HOME not set - refusing to generate tags"
    exit 1
fi

RT_JAR=$JAVA_HOME/jre/lib/rt.jar

if [ ! -f $RT_JAR ]; then
    echo "Java runtime rt.jar not found in $RT_JAR - refusing to generate tags"
    exit 1
fi

CLASSPATH=$RT_JAR:$MUTIL_JAR:$COMMONS_IO_JAR:$COMMONS_LANG_JAR:$JSF_JAR:$JEE_JAR:$HIB_JAR:$JBO_JAR:$JJSF_JAR:$JSER_JAR:$CL3_JAR:.

echo "classpath is now: $CLASSPATH"

cd $EMACS_JAC_FOLDER
java -classpath $CLASSPATH Tags 2>&1

NUMOFLINES=$(wc -l <"${JAVA_TAGS_FILE}")
if [ -f $JAVA_TAGS_FILE_BACKUP ]; then 
    NUMOFLINES_BACKUP=$(wc -l <"${JAVA_TAGS_FILE_BACKUP}")
    echo "old tags file is now in: $JAVA_TAGS_FILE_BACKUP ($NUMOFLINES_BACKUP lines)"; else
    echo "this is the first tags file created (no need to create backup)"
fi
echo "current tags file is now in: $JAVA_TAGS_FILE ($NUMOFLINES lines)"
cd -