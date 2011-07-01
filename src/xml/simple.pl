#!/usr/bin/env perl

use strict;
use warnings;

use XML::Simple qw(XMLin);
use Data::Dumper;

my $x = XMLin(<<END
<?xml version="1.0" encoding="UTF-8" ?>
<foo>
	<bar><baz quux="1"/></bar>
	<bar><baz quuux="2"/></bar>
</foo>
END
);
print Dumper \$x;

