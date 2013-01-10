#!/usr/bin/env python
import sys
from sets import Set
import os, os.path
import zipfile
import tempfile
import hashlib


g_exitCode = 0

extensions=(".ear", ".jar", ".war")

def isContainer(fname):
    return any(map(fname.endswith, extensions)) and zipfile.is_zipfile(fname)


def looksLikeAContainer(s):
    return any(map(s.endswith, extensions))

def isClass(fname):
    return fname.endswith(".class")

names = Set()

closeNames = Set()



totalFiles           = 0 # total files
ttlContnrFs          = 0 # total containers in filesystem
ttlContnrContnr      = 0 # total containers in container
ttlContnrContnrPhony = 0 # total containers in container phony
ttlClszFs            = 0 # total classes in filesystem
ttlClszContnr        = 0 # total classes in container
ttlDisparities       = 0

md5s = {}

def learnMD5(hrLocus, key, fileobj): # hrLocus: human-readable locus
    m = hashlib.md5()
    m.update(fileobj.read())
    if key in md5s and md5s[key][0] != m.hexdigest():
        print "Inconsistency for", key, "in", md5s[key][1], "and", hrLocus
        global ttlDisparities
        ttlDisparities += 1
        global g_exitCode
        g_exitCode = 1
    md5s[key] = m.hexdigest(), hrLocus


def checkForClassesInContainer(hrLocus, container):
    contents = zipfile.ZipFile(container) # the constructor ZipFile accepts either a string (path to a file) or a file-like object
    for content in contents.namelist():
        if isClass(content):
            global ttlClszContnr
            ttlClszContnr += 1
            learnMD5(hrLocus, content, contents.open(content))
            # print "class in container: %s" % content
        else:
            # print "object %s in container %s is not a class" % (content, container)
            None
        if looksLikeAContainer(content):
            tmpfname = tempfile.NamedTemporaryFile()
            tmpfname.write(contents.read(content))
            if zipfile.is_zipfile(tmpfname):
                global ttlContnrContnr
                ttlContnrContnr += 1
                checkForClassesInContainer(hrLocus+":"+content, tmpfname)
            else:
                global ttlContnrContnrPhony
                ttlContnrContnrPhony += 1


skipClassfilesInFileSystem = True

def checkForClasses(rootDir):
    for dirpath, dirs, files in os.walk(rootDir):
        # print "examining %s | %s | %s" % (dirpath, dirs, files)
        for f in files:
            global totalFiles
            totalFiles += 1
            if isClass(f):
                global ttlClszFs
                ttlClszFs += 1
                if not skipClassfilesInFileSystem:
                    learnMD5(dirpath, f, open(os.path.join(dirpath, f)))
                # print "class in filesystem: %s" % f
                #learnAndCheck(f)
            elif isContainer(os.path.join(dirpath, f)):
                global ttlContnrFs
                ttlContnrFs += 1
                checkForClassesInContainer(os.path.join(dirpath, f), os.path.join(dirpath, f))



ttlContnrContnr = 0 # total containers in container                
                

def usage():
    print "Usage:", sys.argv[0], " root-folder [-c]"
    print "   -c : include classes in the filesystem (as opposed to just classes in containers)"
    sys.exit(1)


def main():
    if len(sys.argv) not in (2,3):
        usage()
    if len(sys.argv)==3 and sys.argv[2]!="-c":
        usage()
    rootDir   = sys.argv[1]
    if len(sys.argv)==3 and sys.argv[2]=="-c":
        global skipClassfilesInFileSystem
        skipClassfilesInFileSystem = False
    checkForClasses(rootDir)
    print "--------------------------"
    print "processed %d files, %d containers and %d classes" % (totalFiles, ttlContnrFs+ttlContnrContnr, ttlClszFs+ttlClszContnr)
    print "%d classes in filesystem%s, %d classes in containers" % (ttlClszFs, " (all skipped)" if skipClassfilesInFileSystem else "", ttlClszContnr)
    print "containers in filesystem/containers/phony: %d/%d/%d" %(ttlContnrFs, ttlContnrContnr, ttlContnrContnrPhony)
    print "total disparities = %d" % ttlDisparities

    sys.exit(g_exitCode)

if __name__ == "__main__":
    main()
