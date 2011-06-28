#!/usr/bin/env perl
#
# slurp all file contents, split into lines, map each line to a hash key
#

use strict;
use warnings;

my $contents = do { local $/ = <DATA> }; # file slurp
my @lines = split /\n/, $contents;
my %keys = map { $_ => 1 } @lines;

# demonstrate lookup
for (qw/zero one two three four/)
{
	printf "%-6s: %b\n", $_, defined($keys{$_});
}

__DATA__
one
two
three
