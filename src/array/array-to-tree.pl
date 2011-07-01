#!/usr/bin/env perl
# demonstrate how to merge arrays with shared prefixes, such as file paths, into a tree-like hash structure

use strict;
use warnings;
use Data::Dumper;

sub hash_tree
{
	my ($h, @children) = @_;
	for my $i (0..$#children)
	{
		my $child = $children[$i];
		$h->{$child} = {} if not defined $h->{$child};
		$h = $h->{$child};
	}
}

sub visit
{
	my ($h, @path) = @_;
	if (%$h) {
		foreach my $k (keys %$h)
		{
			my @p = @path;
			push @p, $k;
			visit($h->{$k}, @p);
		}
	} else {
		print join("/", @path)."\n";
	}
}

my @paths = qw#/foo/bar/baz /foo/bar/quux#;
print join("\n", @paths) . "\n";

@paths = map { [split '/', $_] } @paths;

my $root = {};
foreach my $path (@paths)
{
	hash_tree($root, @$path);
}
print Dumper $root;

visit($root, ());

