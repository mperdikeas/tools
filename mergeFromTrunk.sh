#!/bin/bash
svn info | if grep ^URL >/dev/null ; then
    URL=$(svn info | grep ^URL)
    URL=$(echo $URL | sed 's,^URL: ,,;s,branches/[^/]*/,trunk/,')
    echo Merging from $URL
    if svn merge $URL ; then
        svn commit -m "Merged from trunk"
    else
        echo Not committed...
    fi
else
    echo "The current folder is not a subversion one."
fi
