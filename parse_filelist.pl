#!/usr/bin/perl
use strict;
use warnings;
use utf8;

use Getopt::Long;

#### main ####
my ($arg_i,$arg_o,$arg_def) = &parse_option();

my @expand_list = &expand_list($arg_i);
my $arg_o_tmp = &write_list2tmp(\@expand_list,$arg_o);
my $status = &parse_define($arg_o_tmp,$arg_o,$arg_def);
if (! $status){
	my $os = $^O;print "$os\n";
	if ($os eq "MSWin32") {
		system("del $arg_o_tmp")
	}else{
	    system("rm $arg_o_tmp");
	}
}
#########
sub parse_option {
    my $arg_i;
    my $arg_o;
    my @arg_D;
    my $arg_h;

    my $sts = GetOptions (
               'i=s' => \$arg_i,
               'o=s' => \$arg_o,
               'D=s' => \@arg_D,
               'h'   => \$arg_h);

    if ((!$sts) || (defined($arg_h)) || (!defined($arg_i)) || (!defined($arg_o))) {
	    print <<EOF; 
Usage : parse_filelist.pl -i input_src_list_file   # Input Source List File
                          -o output_src_list_file  # Output Source List File
                         [-D define_macro ] ...    # Macros As Defined
                          -h                       # Print Out Help Brief

example: parse_filelist.pl -i filelist.f  -o file.list -D MACRO1 -D MACRO2            		  
#### filelist.f template ####

// *****            ->comment line
../../file1.v       ->file
-f ../../file1.f    ->dot f file

#ifdef MACRO1       ->MACRO1
    ...
#else
    ...
#endif

#ifdef MACRO2       ->MACRO2
    ...
#else
    ...
#endif
#############################
EOF
        exit (-1);
    }

   if (! -e $arg_i) {
      print "Input file $arg_i doesn't exist!\n"; 
      #exit (-1);
   }

   my $arg_def = "";
   $arg_def = join(" ", @arg_D);
   @arg_D = split(/\s+/, $arg_def);
   $arg_def = join(" ",map("-D$_",@arg_D));

   return ($arg_i,$arg_o,$arg_def);
}

#first expand the filelist to a list (including define_macro)
sub expand_list {
    my $file_list = shift;
    
    my @expd_list = ();
    my $flist_fh;
    open($flist_fh,"<","$file_list") or die"parse_filelist.pl: can not find $!\n";
    while (my $item = <$flist_fh>) {
        chomp($item);
        next if ($item =~ /^\s*$/);     # skip empty line
        $item =~ s/^\s+//;              # remove leading space
        $item =~ s/\s+$//;              # remove lagging space
        next if ($item =~ /^\/\//);     # skip comment line

        if ($item =~ /^-f\s+(.*)/) {
            my @list = &expand_list($1); # recursively expand on .f (dot f) file
            push (@expd_list,@list); 
        } else {
            push (@expd_list,$item);
        }
    }
    close ($flist_fh);

    return @expd_list;
}

#then write the list to tmp file
sub write_list2tmp(){
	my $expd_list_ptr = shift;
	my $arg_o 		  = shift;

    my $tmp_file = "${arg_o}.tmp.$$";
    if (open(TMP,">","$tmp_file")) {
        foreach (@$expd_list_ptr) {
            chomp;
            print TMP "$_\n";
        }
        close (TMP);
    } else {
        print "Can not open temp file $tmp_file for write!\n";
        exit (-1); 
    }
    
    return $tmp_file;
}
#finally get file list by define macros
sub parse_define {
   my $arg_i   = shift;
   my $arg_o   = shift;
   my $arg_def = shift;

   my $cpp_cmd = "";
   $cpp_cmd .= "cpp -P ";
   $cpp_cmd .= "$arg_def ";
   $cpp_cmd .= "-o $arg_o ";
   $cpp_cmd .= "$arg_i";
   
   print "$cpp_cmd\n";

   my $sts = system($cpp_cmd);
   
   return $sts;
}
