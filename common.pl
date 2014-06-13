#!/usr/bin/perl

sub Parse_Movie_Data
{
    my ($movie) = @_;
    my %fields;
    my $save = $movie;

    # there are 3 main components
    # title, year, type


    # Scanning this is tricky, let us do a top down one.

    # reversing string will help
    
    $movie = reverse($movie);

# Notes

    if ($movie =~ /^}}([^{]+){{ +/) {
	
	$fields{notes} = reverse($1);
	$movie = $'; #';

    }
    
    die if $movie =~ /^}}/;

# TV episodes

    if ($movie =~ /^}([^{]+){ +/) {
	$fields{episode} = reverse($1);
	$movie = $'; #';
    }
    
    die if $movie =~ /^}/;


    if ($movie =~ /^\)([^(]+)\( +/) {
# attribute
    # the next one is either (V), (TV)... or (year)
	# but it only  appears once

	my $token = reverse($1);
	$movie = $'; #'
	if (Looks_Like_Year($token)) {
	    $fields{year} = $token;
	} else {
	    $fields{attr} = $token;
	    
	    # But we still need to read the year
	    if ($movie =~ /^\)([^(]+)\(/) {
		$fields{year} = reverse($1);		
		$movie = $'; #'
	    } else {
		die "Error, we did not find a year [$save]\n";
	    }
	}
    }
    
#    die "[" . reverse ($movie) . "]" if $movie =~ /^\)/;

# year

    $movie = reverse($movie);

    if ($movie =~ /[{}(]/) {
#	print STDERR  "[$movie]\n";
	;
    }

    $fields{title} = $movie;


    die "Illegal movie key [$save] no title" . join("\n,", %fields) if $fields{title} eq "";

    die "Illegal movie key [$save] no year" . join("\n,", %fields)  if $fields{year} eq "";

    die "Illegal movie key [$save] wrong year " . join("\n         :", %fields) unless ($fields{year} eq "????") or
	($fields{year} >= 1897 or $fields{year} <= 2010);

    return %fields;

}




sub Skip_Until
{
    my ($searchFor) = @_;

    while (<>) {
	return if $_ =~ /$searchFor/;
    }
    die "unable to find string [$searchFor] in input stream";
}

sub Looks_Like_Year
{
    my ($year) = @_;


    return 1 if $year =~ /^[0-9]+/;

    return 1 if $year =~ /^[0-9]+[IV]+/;
    return 1 if $year =~ /^\?+/;
    return 0;
}

sub Parse_Role
{
    my ($role) = @_;
    my %roles;

    $role =~ s/^[\t ]+//;

    if ($role =~ /<([0-9]+)>$/) {
	$roles{billing} = $1;
	$role = $`; #`
    }
    $roles{character} = "";
    # there might be [] inside [  ] but not more than once
    # so first try to match 2 levels
    if ($role =~ /\[(.+\[.+\].*)\] *$/) {
#        print STDERR "Matching $role [$1]\n";
	$roles{character} = $1;
        $role = $`; #'
    }

    if ($role =~ /\[([^]]+)\] *$/) {
	$roles{character} = $1;
	$role = $`; #`
    }
    if ($role =~ /  \(([^)]+)\)$/) {
	$roles{note} = $1;
	$role = $` . $'; #';
    }
    $roles{key} = $role;
    return %roles;
}


sub Match
{
    my ($m, $left, $right) = @_;
    my $depth =1;
    my $rest;

    my $i = length($m) -1;
    while ($i >= 0 && $depth > 0) {
        if (substr($m, $i, 1) eq $right) {
            #we found the beginning of another one
            $depth ++;
        } elsif (substr($m, $i, 1) eq $left) {
            $depth --;
        }
        $i--;
    }
    if ($depth == 0) {
        $rest = substr($m, $i+2);
        $m = substr($m, 0, $i+1);
    } else {
        print STDERR "Not able to match it <$m>\n";
    }
    # m contains the new title, $rest the character
    return ($m, $rest);
} 


sub Parse_Directed
{
    my ($role) = @_;
    my %roles;

 #this needs to be parse from the left
    # find the year first
    die "[$role]" unless $role =~ /\([0-9\?]{4}[\/XIV]*\)/;
    my $prefix = $` . $&; #';
    $role = $'; #';
    # does it contain V/TV/VG
    if ($role =~ s/^ *\((VG|V|TV)\)//) {
        $prefix .= $&;
    }
    while ($role =~ / +\(([^)]+)\)$/) {
	$roles{note} .= "$1;";
	$role = $`; #`
    }
	
    $roles{key} = $prefix . $role;
    return %roles;
}



sub Clean_Fields
{
    %f = @_;
    foreach my $a (sort keys %f) {
	$f{$a} =~ s/^[\t ]+//;
	$f{$a} =~ s/[\t ]+$//;
    }
    return %f;
}


sub myTrim($)
{
    my $s = shift;
    $s=~ s/^\s+//;
    $s=~ s/\s+$//;
    return $s;
}

1;

