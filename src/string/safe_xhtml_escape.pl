#!/usr/bin/env perl
# ex: set encoding=utf-8:

=cut

A catch-all string escape

Author: Ryan Flynn <parseerror@gmail.com>

=cut

use strict;
use warnings;
use Encode;

use utf8;
binmode(STDOUT, ":utf8");

# common entities that are referred to by name
my %NamedEntities = (
	# HTML/XML
	'"' => 'quot',
	'<' => 'lt',
	'>' => 'gt',
	'&' => 'amp',
	# "smart quotes
	'“' => 'ldquo',
	'”' => 'rdquo',
	'‘' => 'lsquo',
	'’' => 'rsquo',
	'‹' => 'lsaquo',
	'›' => 'rsaquo',
	'„' => 'bdquo',
	'‚' => 'sbquo',
	'«' => 'laquo',
	'»' => 'raquo',
	# misc web punct
	'–' => 'ndash',
	'—' => 'mdash',
	'·' => 'middot',
	'©' => 'copy',
	'®' => 'reg',
);

sub xhtml_escape {
	my $s = shift @_;
=cut
	for each unicode character:
		if character is not alphanumeric, a space or is (not ASCII or is ASCII and in %CharName):
	 		replace character with its numeric escape entity, or a named one if found
=cut
	$s =~ s/([^[:alnum:]^[:space:]])/(ord($1) < 0x80 && ord($1) > 32 && !$NamedEntities{$1} ? $1 : "&".($NamedEntities{$1} || sprintf("#%x",ord($1))).";")/ge;
	return $s;
}

my @Test = (
	# string			expected result
	[ 'common punct ,!@#$%/',	'common punct ,!@#$%/'				],
	[ '"double quotes"',		"&quot;double quotes&quot;"			],
	[ '<html/xml tag>',		"&lt;html/xml tag&gt;"				],
	[ "«common—web·punct»",		"&laquo;common&mdash;web&middot;punct&raquo;"	],
	[ "©right ®eg",			"&copy;right &reg;eg"				],
	[ "‘smart single’",		"&lsquo;smart single&rsquo;"			],
	[ "“smart double”",		"&ldquo;smart double&rdquo;"			],
	[ "0-7\0\1\2\3\4\5\6\7",	"0-7&#0;&#1;&#2;&#3;&#4;&#5;&#6;&#7;"		],
	[ "ASCII boundary\x19\x20\x21",	"ASCII boundary&#19; !"				],
);

foreach my $tref (@Test) {
	my ($have, $expect) = @$tref;
	my $res = xhtml_escape($have);
	my $have_esc;
	($have_esc = $have) =~ s/([\x00-\x18])/sprintf("\\x%02x",ord($1))/eg;
	printf("%2s %-30s %s%s\n", $res eq $expect ? "  " : "!!", $have_esc, $res, $res eq $expect ? "" : "(expected $expect)");
}

