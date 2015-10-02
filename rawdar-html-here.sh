#!/usr/bin/env bash

rm -f rawdar.html && cp ~/esac-rawdar/rawdar.html .
rm -fr rawdar.org.files/ && cp -Lr ~/esac-rawdar/rawdar.org.files/ .
rm -f rawdar.zip && zip -r rawdar.zip rawdar.html rawdar.org.files/
