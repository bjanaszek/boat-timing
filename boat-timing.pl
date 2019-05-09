#!/usr/bin/perl -w

# This script will calculate the schedule for a race
# based on the usual CCHS crew pre-race schedule:
# * 55 minutes - Boat in slings
# * 40 minutes - Boat meeting
# * 35 minutes - Hands on
# * 30 minutes - Launch
#
# Additional times can be added the %times hash as necessary
#
# Usage:
#   perl boat-timing.pl hh:mm
# Where "hh:mm" is the race start in 24 hour time.

use strict;
use DateTime;
use Tie::IxHash;

my $racetime = $ARGV[0];

if (not defined $racetime) {
    print STDERR "Please enter a race time as 24 hour time (hh:mm).\n";
    exit;
}

if ($racetime !~ /([01]?[0-9]|2[0-3]):[0-5][0-9]/) {
    die "Please enter a properly formed race start time (hh:mm)\n";
}

my ($h, $m) = split /:/, $racetime;
my %times;
# This preserves the order of the hash
tie %times, 'Tie::IxHash';

# Add additional times here as necessary
# Hash value should minutes before race time
%times = (
    "Boat in slings" => 55,
    "Boat Meeting" => 15,
    "Hands on" => 5,
    "Launch" => 5
);

# The month/day/year component doesn't matter...we're just doing minute math
my $dt = DateTime->new(
    year => 2019,
    month => 5,
    day => 11,
    hour => $h,
    minute => $m
);

my $first = 1;
my $time;

foreach my $key (keys %times) {
    if ($first) {
        $dt->subtract( minutes => $times{$key} );
        $first = 0;
    } else {
        $dt->add( minutes => $times{$key} );
    }
    $time = $dt->hms();
    print "$key: \t\t$time\n";
}
print "RACE: \t\t\t$racetime:00\n";

