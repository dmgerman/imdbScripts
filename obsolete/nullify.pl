#!/usr/bin/perl

while (<>) {
    chomp;
    s/\\/\\\\/g;
    s/\|\|/|\\N|/g;
    s/\|\|/|\\N|/g;
    s/^\|/\\N|/;
    s/\|$/|\\N/;
    print $_, "\n";
}
