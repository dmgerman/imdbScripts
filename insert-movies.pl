#!/usr/bin/perl

$0 =~ m@/([^/]+)$@;
my $dir = $`; #'

push @INC, $dir ;


use DBI;
use strict;
use Getopt::Long;

use strict;

require "common.pl";

my $sth;
my $dbh;
my $rc;

my $dryRun = 1;
my $onlyMovies = 1;


if (!$dryRun) {
   $dbh = DBI->connect("dbi:Pg:dbname=imdb", "", "",
		       { RaiseError => 1});

   $dbh->do("SET CLIENT_ENCODING TO 'LATIN1';");


   $sth = $dbh->prepare("delete from production;");
   $rc = $sth->execute();

}

Skip_Until("MOVIES LIST\n");

# Skip next two lines
my $a = <>;$a = <>;

# From this point on we have movies

my $count =0;

if (!$dryRun) {
   my $sth = $dbh->prepare("insert into production(id, year, index, year2, original, notes, episode, attr, title) values (?, ?, ?, ?, ?, ?,?, ?, ?); ");
} 

while (<>) {
    my $yearBegin;
    my $yearEnd;

    chomp($_);
    last if ($_ =~ /^\-+$/);
    $count++;

    my $movie = $_;
    my @fields = split(/\t+/, $movie);

    my %movieAttr = Parse_Movie_Data($fields[0]);

#    $fields[0] =~ s/\s+{{[^}]+}}\s*//;
#    next if ($movieAttr{attr} ne "") or 
#        ($movieAttr{episode} ne "");
    # split the year and the index
    if ($movieAttr{"year"} =~ m@^([0-9\?]+)/(.+)@) {
#        print STDERR "values [", $movieAttr{"year"}, "]\n";
#        die $_;

        $movieAttr{"year"} = $1;
        $movieAttr{"index"} = $2;        
    } else {
    }
       
    if ($movieAttr{year} eq "????") {
        $movieAttr{year} = "";
    }
    if ($movieAttr{year} ne "") {
        die "year [" . $movieAttr{year} . "] " . $_ if not $movieAttr{year} =~ /^[0-9]{4}$/;
    }
    # ok, now split the year begin-year end
    my $year  = $fields[1];
    if ($year =~ /(\-|,|\?)/ or $year eq '') {
        $year = '';
    } else {
        die "year [" . $year . "] " . $_ if not $year =~ /^[0-9]{4}$/;
    }


#    print join("|", 
#               "key", $fields[0], # key
#               "title", $movieAttr{title}, #title
#               "year-range", $fields[1],
#               "year", $movieAttr{year}, #year
#               "index", $movieAttr{index}, 
#               "note", $movieAttr{notes}, 
#               "ep", $movieAttr{episode}, 
#               "attr", $movieAttr{attr}, 
#               "original", $movie), "\n";

    print join("|", 
               $fields[0], # key
               $movieAttr{title}, #title
               $year,
               $movieAttr{year}, #year
               $fields[1],
               $movieAttr{index}, 
               $movieAttr{notes}, 
               $movieAttr{episode}, 
               $movieAttr{attr}, 
               $movie), "\n";




    if (!$dryRun) {
       my $rc = $sth->execute($fields[0], $movieAttr{title}, $fields[1], $movieAttr{year}, $movieAttr{notes}, $movieAttr{episode}, $movieAttr{attr},$movie );
    } 
    
}

print STDERR "Done. Found $count movies";
