#!/usr/bin/env bash

for f in $(svn status | grep ?  | awk '{print $2}'); do svn add $f; done
