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

if (!$dryRun) {
    my $dbh = DBI->connect("dbi:Pg:dbname=imdb;host=ti.dmg", "", "",
		       { RaiseError => 1});
}

my $delete = 1;

my $sth ;
if (!$dryRun) {

    if ($delete) {
	my $sth = $dbh->prepare("delete from color;");
	my $rc = $sth->execute();
	
    }

    $sth = $dbh->prepare("insert into color(id, color, note) values (?, ?, ?); ");

}




Skip_Until("COLOR INFO LIST\n");

# skip next line
my $a = <>;
# From this point on we have movies

my $count =0;
$_ = <>;
while (1) {
    chomp($_);
    last if ($_ =~ /^\-+$/);
    $count++;

    my %record = Parse_Color($_);

	
    if (!$dryRun) {
	my $rc = $sth->execute($record{id}, $record{color}, $record{note});
    } else {
        print "$record{id}|$record{color}|$record{note}\n";
    }

    $_ = <>;
}

print STDERR "Done. Found $count names";



sub Parse_Color
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

