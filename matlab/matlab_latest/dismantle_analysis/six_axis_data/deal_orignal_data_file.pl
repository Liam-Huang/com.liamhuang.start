#!/bin/perl -w

use strict;
use 5.010;

my $file_name_i = $ARGV[0];
my $file_name_o = $file_name_i;
   $file_name_o =~ s/\.txt/pl.txt/g;

open my $fh_in,  '<', $file_name_i or die "Can't open file $file_name_i:$!\n";
open my $fh_out, '>', $file_name_o;

my ($package_cnt,$package_len,$line_cnt,$data_cnt)=(0,30,0,0);
my  @data_array_256;
my  $idx;
my  $package_head_flag = 0;

while(<$fh_in>)
{
	chomp;
	$line_cnt++;
	if ($_ =~ /one package/)
	{
		$package_cnt++;
		@data_array_256=();
		$package_head_flag = 1;
	}elsif ($_ =~ /(-?--)(.*)/) {
		$data_cnt++;
		$idx=($data_cnt-1)%256;
		$data_array_256[$idx]=$2;
		$package_head_flag = 0;
	}

 	if (($data_cnt%256 eq 0) && ($data_cnt ne 0) && ($package_head_flag eq 0)) {
 		for ($idx=0; $idx<256; $idx++){ printf $fh_out "%3d %18s\n", $idx, $data_array_256[$idx];}
 	}
}



