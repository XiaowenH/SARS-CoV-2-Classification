#!/usr/bin/perl
#**************How to use this script********************
#example
#perl date_convertor.pl test_dates.txt >file.decimal_dates.txt
#date.list formate must be one record one line, example
#	EPI_ISL_440683	2020-04-03
#	EPI_ISL_9159809	2020-03-24
#	EPI_ISL_9159847	2020-03-30
#	EPI_ISL_464013	2020-04-05
#	EPI_ISL_463993	2020-03-13
#	EPI_ISL_693362	2020-03-15
#	EPI_ISL_463001	2020-03-18
#********************************************************
use strict;
use warnings;

my $file = shift @ARGV;
open(F, $file) or die "Can not open $file $!\n";

sub is_leap_year{
	my ($year)=@_;
	my $result = 0;

	unless($year%4){
		unless($year%100){
			unless($year%400){
				$result = 1;
			}else{
				$result = 0;
			}
		}else{
			$result = 1;
		}
	}else{
		$result = 0;
	}
	return $result;
}

sub month2day{
	my ($leap)=@_;
	my %month2day_hash;
	
	if($leap == 1){
		%month2day_hash = ("0" => 0,
		"1" => 31, "2" => 29, "3" => 31, "4" => 30, "5" => 31, "6" => 30,
		"7" => 31, "8" => 31, "9" => 30, "10" => 31, "11" => 30, "12" => 31);
	}else{
		%month2day_hash = ("0" => 0,
		"1" => 31, "2" => 28, "3" => 31, "4" => 30, "5" => 31, "6" => 30,
		"7" => 31, "8" => 31, "9" => 30, "10" => 31, "11" => 30, "12" => 31);
	}
	return %month2day_hash;
}
while(<F>){
	s/\s+$//;
	my ($id, $date)=split/\t/;
	if(($date=~/(\d+)\/(\d+)\/(\d+)/) or ($date=~/(\d+)-(\d+)-(\d+)/)){
		my ($year, $month, $day) = ($1, $2, $3);
		$month=~s/^0//;
		$day=~s/^0//;
		my $leap = is_leap_year($year);
		
		my $one_day = 0;
		if($leap == 1){
			$one_day = 1/366;
		}else{
			$one_day = 1/365;
		}
		
		my %month2day_hash = month2day($leap);
		my $month_days = 0;
		for(my $i=1;$i<=$month;$i++){	
			$month_days = $month2day_hash{$i-1} + $month_days;
		}
		my $all_days = $month_days + $day -1 ;
		my $digit_date = $year + $all_days * $one_day;
		#print $all_days."\t".$one_day."\t".$digit_date."\n";
		print $id."\t".$digit_date."\n";
	}else{
		print "The date format is not correct, please check it \n";
	}
}
