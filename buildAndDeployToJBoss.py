#!/usr/bin/env python
import os
import sys
import signal
import socket
import subprocess

# Get IP address to use when spawning JBoss
myip = socket.gethostbyname(socket.gethostname())

# JBoss related settings
g_JBossFolder = os.getenv("HOME") + "/git-jboss/jboss-as-7.1.1.Final"
g_deployFolder = g_JBossFolder + "/standalone/deployments"
g_deployRunCmd = "./bin/standalone.sh -Djboss.http.port=8888 -Djboss.bind.address=" + myip + " -bmanagement=127.0.0.1 2>&1"

# seconds to wait before considering deployment as timed out
g_timeoutInSeconds = 15


def panic(x):
    if not x.endswith("\n"):
        x += "\n"
    sys.stderr.write("\n"+chr(27)+"[32m" + x + chr(27) + "[0m\n")
    sys.exit(1)


def emphasis(x, *args):
    x = x.strip()
    sys.stdout.write(chr(27)+"[31m")
    sys.stdout.write(x)
    sys.stdout.write(' ' + ' '.join(list(args)))
    sys.stdout.write(chr(27)+"[0m\n")
    sys.stdout.flush()


def main():
    if len(sys.argv) != 2:
        panic("Usage: " + sys.argv[0] + " <pathToAnyModifiedFile>")
    buildRootFolder = sys.argv[1]
    if not os.path.isdir(buildRootFolder):
        panic("The argument provided (%s) is not a folder!" % buildRootFolder)
    buildRootFolder = os.path.abspath(buildRootFolder)
    folderPieces = buildRootFolder.split(os.sep)
    for i in xrange(len(folderPieces), 0, -1):
        candidateFolder = os.sep.join(folderPieces[0:i])
        if os.path.exists(candidateFolder+os.sep+'build.properties'):
            break
    else:
        panic("Could not locate any 'build.properties' in any of:\n%s\n" %
              "\n".join(os.sep.join(folderPieces[0:i])
                        for i in xrange(len(folderPieces), 0, -1)))
    emphasis("Using 'build.properties' in", candidateFolder)
    os.chdir(candidateFolder)
    emphasis("Cleaning up any .ear inside", candidateFolder, "and its children")

    def LocateEar(folder="."):
        for root, dirs, files in os.walk(folder):
            for x in files:
                if x.endswith(".ear"):
                    fullPathAndFilename = root+os.sep+x
                    yield fullPathAndFilename

    for oblivion in LocateEar():
        print "Removing", oblivion
        os.unlink(oblivion)
    if 0 != os.system("ant"):
        panic("Build failed")
    ears = list(LocateEar())
    if len(ears) == 0:
        panic("No .ear generated from build!")
    if len(ears) != 1:
        panic("There must be exactly one .ear generated from the build!\n(%s)" %
              ",".join(ears))
    earToDeploy = ears[0]
    global g_deployFolder
    if not g_deployFolder.endswith(os.sep):
        g_deployFolder += os.sep
    emphasis("Attempting to deploy\n\t" + earToDeploy + "\nto\n\t" + g_deployFolder)
    os.system("rm -rf " + g_deployFolder + "*")
    if 0 != os.system("cp '%s' %s" % (earToDeploy, g_deployFolder)):
        panic("Failed to copy the generated .ear to " + g_deployFolder)
    os.chdir(g_JBossFolder)
    jboss = subprocess.Popen(g_deployRunCmd,
                             stdout=subprocess.PIPE,
                             executable="bash",
                             shell=True)
    source = iter(jboss.stdout.readline, '')
    basenameEar = os.path.basename(earToDeploy)

    def handlerOfTimeOut(_, unused):
        emphasis("Timedout waiting for '%s' to deploy..." % basenameEar)
        os.system(g_JBossFolder + "/bin/jboss-cli.sh --connect command=:shutdown")
        jboss.wait()
        sys.exit(1)

    signal.signal(signal.SIGALRM, handlerOfTimeOut)
    signal.alarm(g_timeoutInSeconds)
    for line in source:
        sys.stdout.write(line)
        sys.stdout.flush()
        if 'Deployed "' + basenameEar + '"' in line:
            emphasis("Deployed successfully!")
            break
    signal.alarm(0)
    os.chdir(g_JBossFolder)
    os.system(g_JBossFolder + "/bin/jboss-cli.sh --connect command=:shutdown")
    jboss.wait()
    sys.exit(0)


if __name__ == "__main__":
    main()
