#!/usr/bin/perl

use DBI;
use strict;
use Getopt::Long;

use strict;

my ($inside) = (-1);

my ($database) = ("packages");

my $dbh = DBI->connect("dbi:Pg:dbname=$database", "dmg", "",
		       { RaiseError => 1});

my $sth = $dbh->prepare("delete from package;");
my $rc = $sth->execute();

while (<>) {
    chomp;
#    print "***************** Reading [". $_  . "]\n";

    my $filename = $_;
    my %fields = Read_Package($_);

    %fields = Replace_Variables($fields{package}, %fields);


    $filename =~ s/.*\/fink\//\/fink\//;

    if ($filename =~ /unstable/) {
	next;
    }

    if ($filename !~ /stable/) {
	die "$filename\n";
    }
    


    my $sth = $dbh->prepare("insert into package(package, license, deps, builddeps, filename, provides) values (?, ?, ?, ?,?, ?); ");
    
    my $rc = $sth->execute($fields{package}, $fields{license}, $fields{depends}, $fields{builddepends}, $filename, $fields{provides});


    print $fields{package} . ":" . $fields{suggests} . ":" . $fields{depends} . "\n";    


#foreach my $a (sort keys %fields) { print "Key: [$a] Value [$fields{$a}]\n"; }

    foreach my $a (sort keys %fields) {
	#print "Key: $a Value $fields{$a}\n";
	if ($a =~ /^splitoff/) {
	    open OUT, ">/tmp/ripxxx" || die "Unable to create temp file";
	    print OUT "$fields{$a}\n";
	    close OUT;
	    my %subfields = Read_Package("/tmp/ripxxx");

	    %subfields = Replace_Variables($fields{package}, %subfields);

	    my $sth = $dbh->prepare("insert into package(package, splitoff, license, deps, builddeps, filename, provides) values (?, ?, ?, ?, ?,?, ?); ");
    
	    my $rc = $sth->execute($subfields{package}, $fields{package}, $subfields{license}, $subfields{depends}, $subfields{builddeps}, $filename, $subfields{provides});

	    print $subfields{package} . ":" . $subfields{suggests} . ":" . $subfields{depends} . "\n";    


	}
    }

}


$dbh->disconnect;




sub Read_Package
{
    my ($filename) = @_;
    my $save = $/;
    my %ret;
    my ($key, $value);
    
    $inside = -1;
    open (IN, $filename) or  die "Unable to open file $filename\n";
    
    while (($key,$value) = Read_Record()) {
	$key =~ s/^[ \t]+//;
	$key =~ tr/[A-Z]/[a-z]/;
	$value =~ s/^[ \t]+//;
	$value =~ s/[ \t]+$//;

	$value =~ s/^<<//;
	$value =~ s/<<$//;
	$ret{$key} = $value;
    }

    if ($ret{package} eq "") {
#	$ret{Depends} eq "") {
	if ($ret{info2} ne "") {
	    my ($line);
	    $line = $ret{info2};

#	    printf STDERR "It has info2\n";
	    open OUT, ">/tmp/ripxxx" || die "Unable to create temp file";
	    print OUT $line . "\n";
	    close OUT;
	    return Read_Package("/tmp/ripxxx");

	}
	print "----------------------------------\n";

	foreach my $a (sort keys %ret) {
	    print "Key: $a Value $ret{$a}\n";
	    print "Key: $a\n";
	}
	    
	die "Unable to find description\n";
    }

    return %ret;
}

sub Replace_Variables()
{
    my ($name, %fields) = @_;
    
    foreach my $a (sort keys %fields) {
	$fields{$a} =~ s/%{Ni}/$name/ig;
	$fields{$a} =~ s/%N/$name/ig;
#	$fields{$a} =~ s/%type_pkg\[perl\]//i;
    }
    return %fields;
}



sub Read_Record
{
    my ($line, $key, $value) = ("", "", "");


    $line = Read_Line();

#    print "Line [$line]\n";

    # remove  \n
    #$line =~ s/\n/ /mg;

    return () if (!defined($line) || $line eq "myEOF" );

    if ($line =~ /^[ \t]*([A-Za-z0-9_-]+):[ \t]*/) {
	$key = $1;
	$value = $'; #'
    } else {
	die "Illegal record [$line]";
    }
    return ($key, $value);
}



sub Read_Line
{
    my ($line, $temp);


    $inside ++;
    while ($line = <IN>) {

	if ($line eq "") {
	    die "SHould not reach here\n";
	}

	chomp $line;
#	print "[$inside]Reading inside loop [$line]\n";

	next if $line =~ /^[ \t]*#/; # comment line, keep reading
	
	next if $line =~ /^[ \t]*$/; # empty line, keep reading

	last;
    }
    if (!defined ($line)) {
	$inside --;
	return "myEOF";
    }

#    print "+[$inside] [$line]\n";
    if ($line =~ /^[ \t]*<<[ \t]*$/) {
#	print "RETURNING\n";
	$inside --;
	return "<<";
    }
#    print ">[$inside] [$line]\n";


    # Has line continuation
    if ($line =~ /<<[ \t]*$/) {



#	$line = substr($line, 0, -2);
	while ($temp = Read_Line()) {
	    chomp $temp;
	    if ($temp eq "myEOF") {
		die "should not find end of file\n";
	    }

#	    print "[$inside] ABC [$temp]\n";

	    if ($temp =~ /^[ \t]*<<[ \t]*$/) {
#		print "FOund last [$temp]\n";
		$line .= "\n<<";
		last ;
	    }
	    $line .= "\n" . $temp;
	}

	# at this point "inside" has the begining and the last <<
	# so we need to remove them
    }

#    print "=====================================To return [$inside][$line]\n";


    $inside --;

    return $line;

}
