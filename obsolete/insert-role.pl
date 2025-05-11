#!/usr/bin/perl

$0 =~ m@/([^/]+)$@;
my $dir = $`; #'

push @INC, $dir ;

use DBI;
use strict;
use Getopt::Long;


use strict;

require "common.pl";

my $table = "roles4";



my $dryRun = 1;

my $delete = 0;

my $sth;
if (!$dryRun) {
    my $dbh = DBI->connect("dbi:Pg:dbname=imdb", "", "",
		       { RaiseError => 1});

    $dbh->do("SET CLIENT_ENCODING TO 'LATIN1';");

    if ($delete) {
	my $sth = $dbh->prepare("delete from $table;");
	my $rc = $sth->execute();
    }
    $sth = $dbh->prepare("insert into $table(pid, id, character, billing, snote) values (?, ?, ?, ?,?); ");
}
my $search = "Name			Titles \n";


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

#	print "Name $name\n";
	

	# process roles now
	
	do {
	    my %roleFields;
	    chomp $role;
	    if ($role =~ /^\t/) {
		%roleFields = Parse_Role($role);
		%roleFields = Clean_Fields(%roleFields);
		if (!$dryRun) {
		    my $rc = $sth->execute($name, $roleFields{key}, $roleFields{character}, $roleFields{billing}, $roleFields{note});
		}
                my $key = $roleFields{key};
                while ($key =~ s/\((voice[^)]*|uncredited|credit only|scenes deleted|rumored|unconfirmed|singing voice|archive sound|attached)\)//) {
                    $roleFields{note} .= ";$1";
                }
                while ($key =~ s/\(as ([^)]+)\)//) {
                    my $t = $1;
                    if ($t =~ /\(/) {
                        $t .= ")";
                        $key =~ s/ +\)$//;                        
                    }
                    $roleFields{note} .= ";as $t";
                }
                while ($key =~ s/\(also as ([^)]+)\)//) {
                    my $t = $1;
                    if ($t =~ /\(/) {
                        $t .= ")";
                        $key =~ s/ +\)$//;
                    }
                    $roleFields{note} .= ";also as $t";
                }
                if ($key =~ s/\((archive footage[^)]*)\)//) {
                    $roleFields{note} .= ";$1";
                }
                if ($key =~ s/\((also archive footage[^)]*)\)//) {
                    $roleFields{note} .= ";$1";
                }
                
                $key =~ s/ +$//;
		print "$key|$name|$roleFields{character}|$roleFields{billing}|$roleFields{note}\n";
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
    if ($name =~ /\(([IV]+)\)$/) {
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

