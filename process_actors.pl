#!/usr/bin/perl

use strict;

require "common.pl";


Skip_Until("Name			Titles \n");

# Skip next line
my $a = <>;

# From this point on we have movies

my $count =0;
$_ = <>;
while (1) {
    my $name;
    my $role;
    chomp($_);
    last if ($_ =~ /^\-+$/);
    $count++;

    if (/([^\t]+)/) {
	$name = $1;
	$role = $'; #'
	print "Name $name\n";

	# process roles now
	
	do {
	    my %roleFields;
	    if ($role =~ /^\t/) {
		%roleFields = Parse_Role($role);

	    } else {
		print STDERR "illegal record in role: [$role]\n";
		die;
	    }

	    $role = <>;
	    
	} while $role ne "\n";

    } else {
	die "Illegal record $_\n";
    }
    $_ = <>;
}

print "Done. Found $count names";


