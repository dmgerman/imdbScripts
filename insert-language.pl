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
    $dbh = DBI->connect("dbi:Pg:dbname=imdb", "", "",
		       { RaiseError => 1});

    $dbh->do("SET CLIENT_ENCODING TO 'LATIN1';");
}
my $delete = 1;

my $sth ;
if (!$dryRun) {

    if ($delete) {
	my $sth = $dbh->prepare("delete from languages;");
	my $rc = $sth->execute();
	
    }

    $sth = $dbh->prepare("insert into languages(id, language, note) values (?, ?, ?); ");

}




Skip_Until("LANGUAGE LIST\n");

# skip next line
my $a = <>;
# From this point on we have movies

my $count =0;
$_ = <>;
while (1) {
    chomp($_);
    last if ($_ =~ /^\-+$/);
    $count++;

    my %record = Parse_Language($_);

	
    if (!$dryRun) {
	my $rc = $sth->execute($record{id}, $record{language}, $record{note});
    } else {
        print "$record{id}|$record{language}|$record{note}\n";

    }

    $_ = <>;
}

print STDERR "Done. Found $count names";



sub Parse_Language
{
    my ($movie) = @_;
    my %fields;

    if ($movie =~ /\t+([^\t]+)\t*/) {
	$fields{id} = $`; #'
	$fields{language} = $1;
	if ($' ne "") { #'
	    $fields{note} = $'; #';
	    }
    } else {
	print STDERR "Illegal record [$movie]\n"
    }
    return %fields;
}

