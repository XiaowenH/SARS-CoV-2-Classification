##################################################
# perl rename2acc.pl -t clade_S.tsv -f clade_S.fasta
# output file is "clade_S_rename.fasta"
##################################################

use strict;
use File::Basename;
use Getopt::Long;

sub usage{
    print <<USAGE;
Name:
    $0
Description:
    rename fasta sequence from tsv and output new fasta 
Update:
    2021-09-28  edit by Xiao-wen Hu
Usage:
    perl $0 <tsv> <fa> [options]
Options:
    -t, --tsv       <string>*   refernece gtf file
    -f, --fasta     <string>*   reference fasta file
    -o, --outfile   <string>    output directory            [default: ./ ]
    help                        print this help information
e.g
    perl $0 -g clade_S.tsv -f clade_S.fasta  -o clade_S_rename.fasta
USAGE
    exit 0;
}

my ($help,$outfile,$fasta,$tsv);
GetOptions(
    "tsv|t=s"    => \$tsv,
    "fasta|f=s"  => \$fasta,
    "outfile|o:s" => \$outfile,
    "help|?"     => \$help
);
die &usage if (!defined $tsv || !defined $fasta || defined $help);



my $tmp=$fasta;
$tmp=~s/(\.\S+)$/_rename$1/;
$outfile ||= $tmp;

open TSV, $tsv or die "Can't open the gtf file $!";
my @acc=();
while(<TSV>){
	next if(/Accession/);
	my @a = split /\t/,$_;
	push(@acc, $a[2]);
}
close(TSV);

open OUT,">$outfile"  || die "Can't write the file $outfile $! \n";	
open FA, $fasta or die "Can't open the gtf file $!";
my $n=0;
while(<FA>){
	if(/^>/){
		print OUT ">$acc[$n]\n";
		$n++;
	}else{
		print OUT ;
	}
}

close(OUT);
close(FA);
