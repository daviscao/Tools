#!/usr/bin/perl
##########################################################################
#  File Name    : diff_2files.pl
#  Description  : 
#               : 
#  Author Name  : Davis Cao
#  Email        : daviscao@zhaoxin.com
#  Create Date  : 2014-08-27 09:47
##########################################################################

$file1_dir = "/project/elite2000/usr/daviscao/snps/FV_S3VDV/work/$ARGV[0]";
$file2_dir = "/project/elite2000/usr/daviscao/snps/FV_S3VDV_13431/work/$ARGV[1]";

if (scalar(@ARGV) < 1)
{
    print "Please enter file name to diff ...\n";
}

$diff_dir = "diff_dir";
if(! -e $diff_dir)
{
    system "mkdir $diff_dir";
}


if(! -e "$diff_dir/$ARGV[0]")
{
    system "mkdir $diff_dir/$ARGV[0]";
}
if(! -e "$diff_dir/$ARGV[1]")
{
    system "mkdir $diff_dir/$ARGV[1]";
}
my $i = 0;  
#foreach(@ARGV)
for ($i=2;$i<=$#ARGV;$i++) 
{
    my $file1 = "$file1_dir/$ARGV[$i]"; 
    my $file2 = "$file2_dir/$ARGV[$i]"; 

    print "Commapring $file1 ...\n";

	open(FILE1_fh, "<$file1") or die ("can't open $file1");
	open(FILE2_fh, "<$file2") or die ("can't open $file2");

	#open(ONLY_IN_FILE1_fh, ">./$diff_dir/$file1\_1") or die ("can't open $diff_dir/$file1\_1");
	#open(ONLY_IN_FILE2_fh, ">./$diff_dir/$file2\_2") or die ("can't open $diff_dir/$file2\_2");
	open(ONLY_IN_FILE1_fh, ">./$diff_dir/$ARGV[0]/$ARGV[$i]\_1") or die ("can't open $diff_dir/$ARGV[0]/$ARGV[$i]\_1");
	open(ONLY_IN_FILE2_fh, ">./$diff_dir/$ARGV[1]/$ARGV[$i]\_2") or die ("can't open $diff_dir/$ARGV[1]/$ARGV[$i]\_2");

	seek FILE1_fh,0,0;
	seek FILE2_fh,0,0;
	while($line1 = <FILE1_fh>) 
	{
	    chomp;
	    seek FILE2_fh,0,0;
	    while( $line2 = <FILE2_fh> )
	    {
		if( $line1 eq $line2 )
		{
		    last;
		}
		if( eof )
		{
		    print ONLY_IN_FILE1_fh "$line1";
		}
	    }
	}
	
	seek FILE1_fh,0,0;
	seek FILE2_fh,0,0;
	while($line2 = <FILE2_fh>) 
	{
	    chomp;
	    seek FILE1_fh,0,0;
	    while( $line1 = <FILE1_fh> )
	    {
		if( $line2 eq $line1 )
		{
		    last;
		}
		if( eof )
		{
		    print ONLY_IN_FILE2_fh "$line2";
		}
	    }
	}
	close(FILE1_fh);
	close(FILE2_fh);
	close(ONLY_IN_FILE1_fh);
	close(ONLY_IN_FILE2_fh);
}

