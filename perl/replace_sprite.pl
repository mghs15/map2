
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

			$d =~ s/std\/\/\///g;
			$d =~ s/pale\/\/\///g;
			
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
