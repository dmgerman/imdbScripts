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

my $dbh = DBI->connect("dbi:Pg:dbname=imdb-new", "", "",
		       { RaiseError => 1});

$dbh->do("SET CLIENT_ENCODING TO 'LATIN1';");


my $sth = $dbh->prepare("select id, episode, title, yearid, index from movies where episode is not null; ");

$sth->execute();

my $sth2;
if (!$dryRun) {
    $sth2 = $dbh->prepare("delete from episodes; ");
    my $rc = $sth2->execute();

    $sth2 = $dbh->prepare("insert into episodes(id, subtitle, season, epnumber,episodeof) values (?, ?, ?, ?,?); ");
}




my $count = 0;
while ( my @row = $sth->fetchrow_array ) {
#    print "$row[1]\n";
    my %fields = Parse_Episode($row[1], $row[0]);
    %fields = Clean_Fields(%fields);
#    print "Id: $row[0]:$fields{subtitle}:$fields{season}:$fields{episode}\n";
    my $of;

    if ($row[4] eq "") {
        $of = sprintf('%s (%d)', $row[2] , $row[3] );
    } else {
        $of = sprintf('%s (%d/%s)', $row[2] , $row[3], $row[4]);        
    }
    if (!$dryRun) {
	my $rc = $sth2->execute($row[0], $fields{subtitle}, $fields{season}, $fields{episode}, $of);
    } else {
        print join("|", $row[0], $fields{subtitle}, $fields{season}, $fields{episode}, sprintf('%s (%s)', $row[2] , $row[3])), "\n";
    }
    $count ++;
}

print STDERR "Done. Total $count\n";



sub Parse_Episode
{
    my ($ep, $all) = @_;
    my %f;

    if ($ep =~ /\(\#([0-9]+)\.([0-9]+)\)/) {
	$f{season} = $1;
	$f{episode} = $2;
	$f{subtitle} = $`; #';
    } elsif ($ep =~ /{{/) {
	die "Illegal record $ep\n";
    } else {
#        print STDERR "who knows: [$ep][$all]\n";
	$f{subtitle} = $ep;
    }
    return %f;
}

