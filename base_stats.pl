#!/usr/bin/perl
##########Example: perl base_stats.pl myFasta.fa #############

use warnings;
use strict;

my ($file)=@ARGV;

open(F, $file);
my $outfile = $file.".stats";
open(OUT, ">$outfile");

my $id = "";
my $seq = "";

my @target_bases=("A", "T", "G", "C", "N", "R", "Y", "K", "M", "S", "W", "B",  "D", "H", "V");
print OUT "seq_id"."\t".join("\t", @target_bases)."\n";
while(<F>){
	if(/>(\S+)/){
		if($id){
			print OUT "$id\t".&stats($seq)."\n";
			$id = $1;
			$seq = "";
		}else{
			$id = $1;
		}
	}else{
		s/\s+$//;
		$seq .=  $_;
		if(eof){
			print OUT "$id\t".&stats($seq)."\n";
		}
	}
}

sub stats{
	my ($seq) = @_;
	my $len = length($seq);
	
	my %h;
	my @bases=split//,$seq;
	foreach my $base(@bases){	
		if(exists $h{$base}){
			$h{$base}++;
		}else{
			$h{$base}=1;
		}
	}
	
	my @freq_stats=();
	foreach my $base(@target_bases){
		my $freq = 0;
		if(exists $h{$base}){
			$freq = $h{$base}/$len;
			$freq=sprintf("%.4f", $freq);
		}
		push(@freq_stats, $freq);
	}
	return join("\t", @freq_stats);
}