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
    $dbh = DBI->connect("dbi:Pg:dbname=imdb;host=ti.dmg", "dmg", "pdspfu2ml",
		       { RaiseError => 1});
}

my $delete = 1;

my $sth ;
if (!$dryRun) {

    if ($delete) {
	my $sth = $dbh->prepare("delete from countries;");
	my $rc = $sth->execute();
	
    }

    $sth = $dbh->prepare("insert into countries(id, country) values (?, ?); ");

}




Skip_Until("COUNTRIES LIST\n");

# skip next line
my $a = <>;
# From this point on we have movies

my $count =0;
$_ = <>;
while (1) {
    chomp($_);
    last if ($_ =~ /^\-+$/);
    $count++;

    my %record = Parse_Country($_);

	
    if (!$dryRun) {
	my $rc = $sth->execute($record{id}, $record{country});
    } else {
        print "$record{id}|$record{country}\n";

    }

    $_ = <>;
}

print STDERR "Done. Found $count names";

sub Parse_Country
{
    my ($movie) = @_;
    my %fields;

    if ($movie =~ /\t+([^\t]+)$/) {
	$fields{id} = $`; #'
	$fields{country} = $1;
    } else {
	die "Illegal record [$movie]\n"
    }
    return %fields;
}

