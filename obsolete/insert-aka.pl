#!/usr/bin/perl


$0 =~ m@/([^/]+)$@;
my $dir = $`; #'

push @INC, $dir ;

use strict;
use Getopt::Long;


use strict;

require "common.pl";


Skip_Until("AKA TITLES LIST\n");

# skip next line
my $a = <>;
# From this point on we have movies

my $count =0;
$_ = <>;
my $id;
while (<>) {
    chomp($_);
    last if ($_ =~ /^\-+$/);
    $count++;
    if (/^ /)  {
        # this is the aka of a movie
        #(aka "'t Spaanse Schaep" (2011))     (Netherlands) (third season title)
        die "not in a movie [$_] aka " if $id eq "";
        if ($_ =~ /\(aka ([^\t]+)\)\t(.+)$/) {
            # it has a note
            my $aka = $1;
            my $note = $2;
            print "$id|$aka|$note\n";
        } elsif ($_ =~ /\(aka ([^\t]+)\)$/) {
            print "$id|$1|\n";
        } else {
            die Illegal record "$_";
        }
    } elsif ($_ ne "") {
        $id = $_;
    } else {
        # this is the movie
        $id = "";
    }
    

#    print "$record{id}|$record{aka}|$record{note}\n";

}

print STDERR "Done. Found $count names";



sub Parse_Aka
{
    my ($movie) = @_;
    my %fields;

    if ($movie =~ /\t+([^\t]+)\t*/) {
	$fields{id} = $`; #'
	$fields{color} = $1;
	if ($' ne "") { #'
	    $fields{note} = $'; #';
	    }
    } else {
	die "Illegal record [$movie]\n"
    }
    return %fields;
}

