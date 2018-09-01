#!/bin/perl -w

use strict;
use 5.010;

my $file_name_i = $ARGV[0];
my $file_name_o = $file_name_i;
   $file_name_o =~ s/\.txt/_pl.txt/g;

open my $fh_in,  '<', $file_name_i or die "Can't open file $file_name_i:$!\n";
open my $fh_out, '>', $file_name_o;

my ($line_cnt,$line_len,$line_len_act) = (0,95,0);

while(<$fh_in>)
{
	chomp;
	$line_cnt++;
	$line_len_act = length($_);
	print "$line_cnt: $line_len_act\n";
 	if (($line_cnt > 2) && ($line_len_act == $line_len)) {
 		printf $fh_out "%10d %s\n",$line_cnt, $_; 
	}
}
