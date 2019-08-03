
use strict;
my $start = time;
print $start;
print  "\n---------------------------\n";

my @allfile = glob "*.json";

foreach (@allfile) {
	my @outfile = ();
	my $outline = "";
	my $filename =  $_;
	open(FH, $filename) or die "$!";
	my @lines = <FH>;
	my $count = 0;
	foreach (@lines) {
		my $d = $_;
# ["concat","<gsi-vertical>",["get","alti"],"</gsi-vertical>"]]

#my $pat1 = quotemeta "[\"concat\",\"<gsi-vertical>\",[";
#my $pat2 = quotemeta "],\"</gsi-vertical>\"]]";
#my $chg1 = "[";
#my $chg2 = "]";


#		$d =~ s/$pat1/$chg1/g;
#		$d =~ s/$pat2/$chg2/g;
#		$d =~ s/"\"/""/g;

		$d =~ s/"<gsi-vertical>"/""/g;
		$d =~ s/"<\/gsi-vertical>"/""/g;
			
		$outfile[$count] = $d;
		print $outfile[$count];
		$count ++;
	}
	close(FH);
	
	my $outfilename = 'results'.'/'.$filename;
	print $outfilename;
	open (OutFH, ">", $outfilename) or die "$!";
		print OutFH @outfile;
	close(OutFH);
	print $_;
}


print  "\n---------------------------\n";
print  "\n";
print time;
print  "\n";
print time -  $start;  # 経過時間を出力


########################################

