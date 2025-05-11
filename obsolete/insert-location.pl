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

my $dbh;

if (!$dryRun)  {
    $dbh = DBI->connect("dbi:Pg:dbname=imdb;host=ti.dmg", "dmg", "pdspfu2ml",
			{ RaiseError => 1});
}

my $delete = 1;

my $sth ;
if (!$dryRun) {

    if ($delete) {
	my $sth = $dbh->prepare("delete from locations;");
	my $rc = $sth->execute();
	
    }

    $sth = $dbh->prepare("insert into locations(id, country, location, note) values (?, ?, ?, ?); ");

}




Skip_Until("LOCATIONS LIST\n");

# skip next 2 line
my $a = <>;
$a = <>;
# From this point on we have movies

my $count =0;
$_ = <>;
while (1) {
    last if $_ eq "";
    chomp($_);
    last if ($_ =~ /^\-+$/);
    $count++;

    my %record = Parse_Location($_);
    if (scalar(%record) != 0) {

        if (!$dryRun) {
            my $rc = $sth->execute($record{id}, $record{country}, $record{loc}, $record{note});
        } else {
            print "$record{id}|$record{country}|$record{loc}|$record{note}\n";
            
        }
    }
    $_ = <>;
}

print STDERR "Done. Found $count names";



sub Parse_Location
{
    my ($movie) = @_;
    my %fields;

    my @f = split(/\t+/, $movie);

    $fields{id} = $f[0];
    $fields{note} = $f[2];

    if ($f[1] !~ /,/) {
	$fields{country} = $f[1];
    } elsif ($f[1] =~ /, ([^,]+)$/) {
	$fields{loc} = $`; #';
	$fields{country} = $1;
    } else {
	print STDERR "Illegal record [$movie]\n";
        return ();
    }
    return %fields;
}

