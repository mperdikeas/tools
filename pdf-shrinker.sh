#!/usr/bin/env bash
shopt -s globstar
if [[ ($# -ne 2) ]]
then
    echo "usage is $0 <directory to find PDFs under> <directory to copy results into>"
else
    echo "this script is not production-ready; best make sure that the input and output directories have no overlap"
    echo "also it hasnt been tested using the current directory for either input or output"
    DIR=$1
    OUTPUT=$2
    find -L "$DIR" -type f -iname \*.pdf -print0 | while read -d $'\0' file
    do
        dirname=$(dirname "$file")
        fname=$(basename "$file")
        mkdir -p "$OUTPUT/$dirname"
        # the below works but I got very poor compression results; gs was way better
        # convert -density 94x94 -quality 26 -compress jpeg "$file" "$OUTPUT/$dirname/$fname"

        # https://askubuntu.com/a/256449/89663
        # settings are:
        #     /screen
        #     /ebook
        #     /printer
        #     /prepress
        gs -dNOPAUSE -dQUIET \
           -dBATCH -sDEVICE=pdfwrite \
           -dCompatibilityLevel=1.4 -dPDFSETTINGS=/screen \
           -dDownsampleColorImages=true \
           -dDownsampleGrayImages=true \
           -dDownsampleMonoImages=true \
           -dColorImageDownsampleThreshold=1 \
           -dGrayImageDownsampleThreshold=1 \
           -dMonoImageDownsampleThreshold=1 \
           -dColorImageDownsampleType=/Bicubic \
           -dGrayImageDownsampleType=/Bicubic \
           -dMonoImageDownsampleType=/Bicubic \
           -dColorImageResolution=75 \
           -dGrayImageResolution=75 \
           -sOutputFile="$OUTPUT/$dirname/$fname" "$file"
    done
fi





