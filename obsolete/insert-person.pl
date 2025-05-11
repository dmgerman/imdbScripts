#!/usr/bin/perl

$0 =~ m@/([^/]+)$@;
my $dir = $`; #'

push @INC, $dir ;


use DBI;
use strict;
use Getopt::Long;
use strict;

require "common.pl";

my $dryRun = 1;

# 0 maile, 1 female, 2 directors
my $insertFemale  = shift @ARGV ;

die "need type" unless $insertFemale == 0 or $insertFemale == 1 or $insertFemale == 2;


my $host = "dbserv.csc.uvic.ca";
#my $host = "localhost";
my $user = "dmg";
my $password = "patito";
my $db = "imdb";

my $search = '^Name\s+Titles';

my $delete = 0;
my $gender = 'M';
if ($insertFemale == 1) {
    $delete = 0;
    $gender = 'F';
}
if ($insertFemale == 2) {
    $delete = 0;
    $gender = 'D';
}

print STDERR "Starting\n";

my $sth;
if (not $dryRun) {
    my $dbh = DBI->connect("dbi:Pg:dbname=$db", "", "",
                           { RaiseError => 1});

    $dbh->do("SET CLIENT_ENCODING TO 'LATIN1';");


    if ($delete) {
        my $sth = $dbh->prepare("delete from persons;");
        my $rc = $sth->execute();
    }

    $sth = $dbh->prepare("insert into persons(lastname, firstname, index, gender, pid) values (?, ?, ?, ?,?); ");
}
    

Skip_Until($search);
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

	my %person = Parse_Person($name);
	%person = Clean_Fields(%person);

#	print "Name $person{firstname}:$person{lastname}:$person{index}\n";
	
        my $rc;
        if (not $dryRun) {
            $rc = $sth->execute($person{lastname}, $person{firstname}, $person{index}, $gender, $name);
        } else {
            print join("|",$name, $person{lastname}, $person{firstname}, $person{index}, $gender), "\n";
        }


	# process roles now
	
	do {
	    my %roleFields;
	    if ($role =~ /^\t/) {
		%roleFields = Parse_Role($role);
		%roleFields= Clean_Fields(%roleFields);

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


sub Parse_Person
{
    my ($name) = @_;
    my %fields;
    if ($name =~ /\(([IVX]+)\)$/) {
	$name = $`;
	$fields{index} = $1;
    }
    if ($name =~ /^([^,]+),([^,]+)$/) {
	$fields{lastname} = $1;
	$fields{firstname} = $2;
    } else {
	$fields{lastname} = $name;
    }
    return %fields;
}

