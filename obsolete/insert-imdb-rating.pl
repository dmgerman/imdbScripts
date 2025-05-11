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

my $dbh = DBI->connect("dbi:Pg:dbname=imdb", "", "",
		       { RaiseError => 1});

$dbh->do("SET CLIENT_ENCODING TO 'LATIN1';");


my $delete = 1;

my $sth ;
if (!$dryRun) {

    if ($delete) {
	my $sth = $dbh->prepare("delete from ratings;");
	my $rc = $sth->execute();
	
    }

    $sth = $dbh->prepare("insert into ratings(id, dist, votes, rank) values (?, ?, ?, ?); ");

}

Skip_Until('MOVIE RATINGS REPORT
');


my $count = 0;
while (<>) {

    chomp($_);
    last if ($_ =~ /^\-+$/);

    next if ($_ !~ /^      [0-9.]/);

    $count++;

    my %record = Parse_IMDB_Rating($_);

#    print "Movie $record{id}:$record{dist}:$record{votes}:$record{rank}\n";
	
    if (!$dryRun) {
	my $rc = $sth->execute($record{id}, $record{dist}, $record{votes}, $record{rank});
    } else {
        print join("|", $record{id}, $record{dist}, $record{votes}, $record{rank}), "\n";
    }
}

print STDERR "Done. Found $count names";



sub Parse_IMDB_Rating
{
    my ($movie) = @_;
    my %fields;

    if ($movie =~ /      ([0-9.*]{10}) +([0-9]+) +([0-9.]+) +(.+)$/) {
	$fields{id} = $4;
	$fields{rank}= $3;
	$fields{votes}= $2;
	$fields{dist} = $1;
    } else {
	die "Illegal record [$movie]\n"
    }
    return %fields;
}

