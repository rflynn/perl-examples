#!/usr/bin/env perl

#
# use async to run a function that takes 1+ second asynchronously,
# so that all 5 complete within ~1 second
#

use strict;
use warnings;

use threads;
use Data::Dumper;

sub dostuff
{
	my ($param) = @_;
	sleep(1);
	my $results = [$param, $param.$param];
	return $results;
}

my @data = ('a'..'e');
my @workers = map { async { dostuff($_) } } @data;
my @work = map { $_->join } @workers;

print Dumper \@work;

