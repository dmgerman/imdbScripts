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
my $delete = 1;
my $sth ;


if (not $dryRun) {
    my $dbh = DBI->connect("dbi:Pg:dbname=imdb", "", "",
                           { RaiseError => 1});

    $dbh->do("SET CLIENT_ENCODING TO 'LATIN1';");

    if ($delete) {
	my $sth = $dbh->prepare("delete from genres;");
	my $rc = $sth->execute();
	
    }

    $sth = $dbh->prepare("insert into genres(id, genre) values (?, ?); ");

}



Skip_Until("8: THE GENRES LIST\n");

# Skip next line
my $a = <>;
$a = <>;
# From this point on we have movies

my $count =0;
$_ = <>;
while (1) {
    chomp($_);
    last if $_ eq "";
    last if ($_ =~ /^\-+$/);
    $count++;

    my %genre = Parse_Genre($_);
	
    if (!$dryRun) {
	my $rc = $sth->execute($genre{id}, $genre{genre});
    } else {
        print "$genre{id}|$genre{genre}\n";
    }

    $_ = <>;
}

print STDERR "Done. Found $count names\n";



sub Parse_Genre
{
    my ($movie) = @_;
    my %fields;

    if ($movie =~ /\t+([A-Za-z\-]+)$/) {
	$fields{id} = $`; #'
	$fields{genre} = $1;
    } else {
	print STDERR "Illegal record [$movie]\n"
    }
    return %fields;
}

