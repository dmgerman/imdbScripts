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

my $sth;
if (!$dryRun) {
    
    if ($delete) {
	my $sth = $dbh->prepare("delete from links;");
	my $rc = $sth->execute();
    }
    $sth = $dbh->prepare("insert into links(id, id2, relationship) values (?, ?, ?); ");
}



Skip_Until("================\n");

# Skip next line
my $a = <>;

# From this point on we have movies

my $count =0;
$_ = <>;
while ($_ ne "") {
    my $name;
    my $role;
    chomp($_);
    last if ($_ =~ /^\-+$/);
    $count++;

    if (/([^\t]+)/) {
	$name = $_;

#	print "Name $name\n";
	
	# process roles now
	$role = <>;
	do {
	    chomp $role;
	    my %roleFields;
	    if ($role =~ /^ /) {
		%roleFields = Parse_Link($role);
		%roleFields = Clean_Fields(%roleFields);
		if ($roleFields{relation} ne "") {
		    if (!$dryRun) {
			my $rc = $sth->execute($name, $roleFields{to}, $roleFields{relation});
		    } else {
                        print "$name|$roleFields{to}|$roleFields{relation}\n";
                    }
		}
	    } else {
		print STDERR "illegal record in role: [$role]\n";
	    }

	    $role = <>;
	    
	} while $role ne "\n";

    } else {
	print STDERR "Illegal record [$_]\n" if $_ ne "";
    }


    $_ = <>;
}

print STDERR "Done. Found $count names\n";


sub Parse_Link
{
    my ($name) = @_;
    my %fields;
    if ($name =~ /  \((version of) /) {
    } elsif ($name =~ /  \((spoofs) /) {
    } elsif ($name =~ /  \((spin off from) /) {
    } elsif ($name =~ /  \((remake of) /) {
    } elsif ($name =~ /  \((references) /) {
    } elsif ($name =~ /  \((follows) /) {
    } elsif ($name =~ /  \((features) /) {
    } elsif ($name =~ /  \((edited from) /) {
    } elsif ($name =~ /  \((alternate language version of) /) {
    } elsif ($name =~ /  \((edited into) / ||
	     $name =~ /  \((featured in) / ||
	     $name =~ /  \((followed by) / ||
	     $name =~ /  \((referenced in) / ||
	     $name =~ /  \((remade as) / ||
	     $name =~ /  \((spin off) / ||
	     $name =~ /  \((spoofed in) /) {
	return ();
    } else {
	die "Illegal record 1: $name\n";
    }
    $fields{relation} = $1;
    $fields{to} = $'; #';

    if ($fields{to} =~ s/\)$//) {
    } else {
	die "Illegal record $name\n";
    }
    return %fields;
}

