#!/usr/bin/perl

$0 =~ m@/([^/]+)$@;
my $dir = $`; #'

push @INC, $dir ;


use DBI;
use strict;
use Getopt::Long;


use strict;

require "common.pl";

my $host = "dbserv.csc.uvic.ca";
#my $host = "localhost";
my $user = "dmg";
my $password = "patito";
my $db = "imdb";

my $dbh = DBI->connect("dbi:Pg:dbname=imdb", "", "",
		       { RaiseError => 1});

$dbh->do("SET CLIENT_ENCODING TO 'LATIN1';");

my $dryRun = 1;

my $delete = 1;

my $sth;
if (!$dryRun) {
    
    if ($delete) {
	my $sth = $dbh->prepare("delete from directs;");
	my $rc = $sth->execute();
    }
    $sth = $dbh->prepare("insert into directs(pid, id, dnote) values (?, ?, ?); ");
}



Skip_Until("Name			Titles\n");

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
	$name = myTrim($1);
	$role = $'; #'

#	print "Name $person{firstname}:$person{lastname}:$person{index}\n";
	

	# process roles now
	
	do {
	    my %roleFields;
	    chomp $role;
	    if ($role =~ /^\t/) {
		%roleFields = Parse_Directed($role);
		%roleFields = Clean_Fields(%roleFields);
		if (!$dryRun) {
		    my $rc = $sth->execute($name, $roleFields{key}, $roleFields{note});
		}
		print "$roleFields{key}|$name|$roleFields{note}\n";

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

print STDERR "Done. Found $count names";


