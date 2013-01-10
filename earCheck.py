#!/usr/bin/env python
import sys
import hashlib
import zipfile
import tempfile


md5s = {}
g_exitCode = 0


def learnMD5(fullFilePath, key, fileobj):
    m = hashlib.md5()
    m.update(fileobj.read())
    #print fullFilePath, key, m.hexdigest()
    if key in md5s and md5s[key][0] != m.hexdigest():
        print "Inconsistency for", key, "in", md5s[key][1], "and", fullFilePath
        global g_exitCode
        g_exitCode = 1
    md5s[key] = m.hexdigest(), fullFilePath


def processJarOrWar(fullfilename, fileobj=None):
    if fileobj is None:
        zipobj = zipfile.ZipFile(fullfilename)
    else:
        tmpFilename = tempfile.NamedTemporaryFile()
        tmpFilename.write(fileobj.read())
        zipobj = zipfile.ZipFile(tmpFilename)
    for n in zipobj.namelist():
        if n.endswith(".class"):
            learnMD5(fullfilename, n, zipobj.open(n))
        elif n.endswith(".jar") or n.endswith(".ear"):
            processJarOrWar(fullfilename + ":" + n, fileobj=zipobj.open(n))


def usage():
    print "Usage:", sys.argv[0], " filename.ear"
    sys.exit(1)


def main():
    if len(sys.argv) == 1:
        usage()
    processJarOrWar(sys.argv[1])
    sys.exit(g_exitCode)

if __name__ == "__main__":
    main()
