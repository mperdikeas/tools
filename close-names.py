#!/usr/bin/env python
import sys
import os, os.path
from Levenshtein import ratio
from sets import Set

g_exitCode = 0

extensions=(".zip", ".ear", ".jar", ".war")

def fileOfInterest(fname):
    return any(map(fname.endswith, extensions))

names = Set()

closeNames = Set()

def namesTooSimilar(a, b, threshold):
    r = ratio(a,b)
    return r> threshold and r<1.0

def learnAndCheck(newName, threshold):
    for n in names:
        if namesTooSimilar(n, newName, threshold):
            closeNames.add((n,newName, ratio(n, newName)))
    names.add(newName)


totalFiles = 0
totalFilesOfInterest = 0

def checkForFilesOfInterest(rootDir, threshold):
    for root, dirs, files in os.walk(rootDir):
        for f in files:
            global totalFiles
            totalFiles += 1
            if fileOfInterest(f):
                global totalFilesOfInterest
                totalFilesOfInterest += 1
                #print "found file of interest: %s"%f
                learnAndCheck(f, threshold)

def usage():
    print "Usage:", sys.argv[0], " root-folder closeness-threshold"
    sys.exit(1)


def main():
    if len(sys.argv) != 3:
        usage()
    rootDir   = sys.argv[1]
    threshold = float(sys.argv[2])
    checkForFilesOfInterest(rootDir, threshold)
    print "\nExamined %d files (%d of interest) and found %d close pairs:\n" % (totalFiles, totalFilesOfInterest, len(closeNames))
    for a,b,c in closeNames:
        print "%s | %s | %.3f "%(a,b,c)
    sys.exit(g_exitCode)

if __name__ == "__main__":
    main()
