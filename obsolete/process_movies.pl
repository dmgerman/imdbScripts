#!/usr/bin/perl

use strict;

require "common.pl";


Skip_Until("MOVIES LIST\n");

# Skip next two lines
my $a = <>;$a = <>;

# From this point on we have movies

my $count =0;
while (<>) {
    chomp($_);
    last if ($_ =~ /^\-+$/);
    $count++;

    my $movie = $_;
    my @fields = split(/\t+/, $movie);

    my %movieAttr = Parse_Movie_Data($fields[0]);

}

print "Done. Found $count movies";
