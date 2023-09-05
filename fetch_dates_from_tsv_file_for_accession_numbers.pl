use strict;
use File::Basename;
use Getopt::Long;

sub usage{
    print <<USAGE;
Name:
    $0
Description:
    Fetch collect date from tsv file 
Update:
    2022-02-25  edit by Xiao-wen Hu
Usage:
    perl $0 <tsv> <query> [options]
Options:
    -t, --tsv       <string>*   refernece gtf file
    -q, --query     <string>*   reference fasta file
    -o, --outfile   <string>    output directory            [default: ./ ]
    help                        print this help information
e.g
    perl fetch_dates_from_tsv_file_for_accession_numbers.pl -t head_global_all_meta.tsv -q queryDNA_ID.txt  -o acc2date.txt
USAGE
    exit 0;
}

my ($help,$outfile,$tsv,$query);
GetOptions(
    "tsv|t=s"    => \$tsv,
    "query|q=s"  => \$query,
    "outfile|o:s" => \$outfile,
    "help|?"     => \$help
);
die &usage if (!defined $tsv || !defined $query || defined $help);



open TSV, $tsv or die "Can't open the gtf file $!";
my %h;

while(<TSV>){
	my @tmp=split/\t/;
	$h{$tmp[2]}=$tmp[3];
}
close(TSV);

open OUT,">$outfile"  || die "Can't write the file $outfile $! \n";	
open FA, $query or die "Can't open the gtf file $!";

while(<FA>){
	s/\s+$//;
	if(exists $h{$_}){
		print OUT $_."\t".$h{$_}."\n";
	}else{
		print OUT $_."\n";
	}
}

close(OUT);
close(FA);
