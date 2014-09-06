#!/bin/bash


unset PATH
readonly ID=/usr/bin/id;
readonly ECHO=/bin/echo;
readonly MOUNT=/bin/mount;
readonly RM=/bin/rm;
readonly MV=/bin/mv;
readonly CP=/bin/cp;
readonly TOUCH=/bin/touch;
readonly RSYNC=/usr/bin/rsync;
readonly EXCLUDES=/home/mperdikeas/tools/make_snapshot.sh.excludes
readonly SNAPSHOT_RW=/media/Elements/snapshot;
readonly EXPR=/usr/bin/expr
readonly MKDIR=/bin/mkdir
readonly DATE=/bin/date
readonly START=$($DATE +%s)
echo "/--- $($DATE) snapshot start" >> $SNAPSHOT_RW/.home-history

echo "step 1 of 5 : deleting the oldest snapshot, if it exists"
if [ -d $SNAPSHOT_RW/home/manual.9 ] ; then \
$RM -rf $SNAPSHOT_RW/home/manual.9 ;        \
fi ;

echo "step 2 of 5 : shifting the middle snapshots"
if [ -d $SNAPSHOT_RW/home/manual.8 ] ; then $MV $SNAPSHOT_RW/home/manual.8 $SNAPSHOT_RW/home/manual.9 ; fi ;
if [ -d $SNAPSHOT_RW/home/manual.7 ] ; then $MV $SNAPSHOT_RW/home/manual.7 $SNAPSHOT_RW/home/manual.8 ; fi ;
if [ -d $SNAPSHOT_RW/home/manual.6 ] ; then $MV $SNAPSHOT_RW/home/manual.6 $SNAPSHOT_RW/home/manual.7 ; fi ;
if [ -d $SNAPSHOT_RW/home/manual.5 ] ; then $MV $SNAPSHOT_RW/home/manual.5 $SNAPSHOT_RW/home/manual.6 ; fi ;
if [ -d $SNAPSHOT_RW/home/manual.4 ] ; then $MV $SNAPSHOT_RW/home/manual.4 $SNAPSHOT_RW/home/manual.5 ; fi ;
if [ -d $SNAPSHOT_RW/home/manual.3 ] ; then $MV $SNAPSHOT_RW/home/manual.3 $SNAPSHOT_RW/home/manual.4 ; fi ;
if [ -d $SNAPSHOT_RW/home/manual.2 ] ; then $MV $SNAPSHOT_RW/home/manual.2 $SNAPSHOT_RW/home/manual.3 ; fi ;
if [ -d $SNAPSHOT_RW/home/manual.1 ] ; then $MV $SNAPSHOT_RW/home/manual.1 $SNAPSHOT_RW/home/manual.2 ; fi ;

echo "step 3 of 5 : make a hard-link-only (except for dirs) copy of the latest snapshot, if it exists"
if [ -d $SNAPSHOT_RW/home/manual.0 ] ; then                     \
$CP -al $SNAPSHOT_RW/home/manual.0 $SNAPSHOT_RW/home/manual.1 ; \
fi ;

# step 4 : rsync from the system into the latest snapshot (notice
# that rsynch behaves like cp --remove-destination by default, so
# the destination is unlinked first. If is were not so, this would
# copy over the other snapshot(s) too!
echo "step 4 of 5 : rsync from the system into the latest snapshot"

if [ ! -d "$SNAPSHOT_RW/home/manual.0" ]; then
    echo "directory $SNAPSHOT_RW/home/manual.0 does not exist - creating it."
    $MKDIR -p "$SNAPSHOT_RW/home/manual.0" || exit 1
fi

$RSYNC -vva --delete --delete-excluded    \
       --exclude-from=$EXCLUDES          \
      /home/ $SNAPSHOT_RW/home/manual.0  ;

# mystery: why is the following not working ? 
#$RSYNC -va --delete --delete-excluded    \
#       --exclude-from=$EXCLUDES          \
#       /home/ $SNAPSHOT_RW/home/manual.0 ;



echo "step 5 of 5 : touch the mtime of manual.0 to reflect the snapshot time"
$TOUCH $SNAPSHOT_RW/home/manual.0 ;

readonly END=$($DATE +%s)
readonly DIFF=$($EXPR $END - $START)
echo "\--- snapshot completed in $DIFF seconds." >> $SNAPSHOT_RW/.home-history
echo "snapshot completed in $DIFF seconds."
# that's all.

