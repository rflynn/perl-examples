#!/usr/bin/env perl

=cut

A catch-all string escape

Author: Ryan Flynn <parseerror@gmail.com>

=cut

use strict;
use warnings;
use Encode;


my %CharName = (
	'"' => 'quot',
	'<' => 'lt',
	'>' => 'gt',
);

sub xhtml_escape {
	my $s = decode_utf8(shift @_);
=cut
	for each unicode character:
		if character is not alphanumeric, a space or is not an ASCII puncutation (except quote, less-than or greater-than):
	 		replace character with its numeric escape entity, or a named one if found
=cut
	$s =~ s/([^[:alnum:]^[:space:]])/(ord($1) < 128 && ord($1) > 32 && $1 ne "\"" && $1 ne "<" && $1 ne ">" ? $1 : "&#".($CharName{$1}||ord($1)).";")/ge;
	return $s;
}

my @Test = (
	["‘hello’", ""],
	['"hello"', "&quot;hello&quot;"],
	['<hello>', "&lt;hello&gt;"],
	["“—”", ""],
	["‘—’", ""],
	["“—”", ""],
	["‹—›", ""],
	["«—»", ""],
);

foreach my $tref (@Test) {
	my ($have,$expect) = @$tref;
	printf("%s -> %s\n", $have,  xhtml_escape($have));
}

