#!/usr/bin/perl
use strict;
use warnings;

use Getopt::Long;

sub usage{
    print <<USAGE;
Name:
    $0
Description:
    get CDS region from a fasta format file.
Update:
    2022-01-28  edit by Xiao-wen Hu
Usage:
    perl $0 <f> <r> [options]
Options:
    -r, --regions       <string>*   the region of CDS, start-end
    -f, --fasta     <string>*   reference fasta file
    -o, --outfile    <string>    output file            [default: ./output ]
    help                        print this help information
e.g
    perl fetch_nucleotides_from_alignments.pl -f global.fas -r 266-1346,13468-21552 -o global_CDS.fas
USAGE
    exit 0;
}

my ($help,$regions,$outfile,$fasta);
GetOptions(
    "fasta|f=s"  => \$fasta,
    "region|r=s"    => \$regions,
    "outfile|o:s" => \$outfile,
    "help|?"     => \$help
);
die &usage if (!defined $regions || !defined $fasta || defined $help);

$outfile ||= "./output";

open FA,$fasta || die "Can't open the  fasta file $!\n";
open(OUT, ">$outfile");


my @region=split/,/,$regions;

my $info = "";
my $seq = "";
while (<FA>){
	s/\s+$//;
	if(/^(>.*)/){
		if($info){
			&out_fasta($info, $seq);
			$info = $1;
			$seq = "";
		}else{
			$info = $1;
		}
	}else{
		$seq .= $_;
	}
	if(eof){
		&out_fasta($info, $seq);
	}
}
close(FA);

sub out_fasta{
    my ($info, $seq) = @_;
	my $cds_seq = "";
	foreach(@region){
		s/\s+$//;
		my ($start, $end)=split/-/;
		my $split_len = $end - $start + 1;
		my $began= $start - 1 ;
		my $subseq = substr($seq, $began, $split_len);
		$cds_seq .= $subseq;	
	}
	print OUT $info."\n".$cds_seq."\n";	
}

