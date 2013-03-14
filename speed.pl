#!/usr/bin/perl -w
use strict;

die "Usage: $0 filename\n" unless @ARGV == 1;

die "$ARGV[0] is not a file!\n" unless -f $ARGV[0];

my $oldSize = -s $ARGV[0];
my $noData = 0;
my $cnt = 0;
my $total = 0;
while (1) {
    sleep(1);
    $cnt++;
    my $newSize = -s $ARGV[0];
    $total += $newSize - $oldSize;
    print "Size: ".(-s $ARGV[0])." bytes, speed: ".($newSize-$oldSize)." bytes/sec (avg:".int($total/$cnt)." bytes/sec)\n";
    if ($newSize == $oldSize) {
	$noData++;
	print "Stalling... Waiting for $noData seconds...\n";
	sleep($noData);
	if ($noData == 10) {
	    die "No data received for 55 seconds...\n";
	}
    } else {
	$noData = 0;
    }
    $oldSize = $newSize;
}
