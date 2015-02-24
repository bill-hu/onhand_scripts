#!/usr/bin/perl
#bill.hu 2015.2.24
#backup all git in a folder to another folder
 use strict;
 use Cwd;
 use warnings;
 

 my $path = $ARGV[0];
 print "Backup Git repository,bill hu 2015\n";
 print "Useage: ".$0," folders_with_git folder_backup_to\n";
 print "eg.: ".$0." d:/hubin g:/GitRepo\n";
 print "-------------------------------------------------\n";
 
 if(! $ARGV[0] cmp "")
 {
	printf("Please Input Dir Name");
	exit(0);
 }
 
 if(! $ARGV[1] cmp "")
 {
	printf("Please Input Dest Dir Name");
	exit(0);
 }
 
 my $DistPath = $ARGV[1];

 my $dircount = 0;
 
 sub backup_git{
   my $srcPath = $_[0];
   my $destName = $_[1];
   my $destPath = $_[2];

   print $destName," ",$destPath,"  ",$srcPath, "\n";
   my $cwd = getcwd();
   chdir $srcPath;
   my $mycmd = "git remote add backup " . $destPath ."\/" .$destName;
   system($mycmd);
   print $mycmd ,"\n";  
   
   my @branchList =  readpipe("git branch");
   my $listSize = @branchList;
   if($listSize > 0)
   {
		if(!chdir $destPath)
		{
		   print $destPath . "not exist";
		   return;
		}
		if(-d $destName)
		{
		   print $destName . "already exist";
		}
		else
		{
		  mkdir $destName;
		}
		
		chdir $destName;
		system("git init --bare");
   }
   
   chdir $srcPath;
   
   for(my $i=0;$i< $listSize;$i++)
   {
     my $branch = $branchList[$i];
	 $branch =~ s/^ *//g; #for "  master"
	 $branch =~ s/^\*( *)//;#for "* master"
	 $branch =~ s/[\r|\n]*//g; #for ld lf
	 print $branch."\n";
	 my $cmd = "git push backup ".$branch.":".$branch;
	 print $cmd."\n";
	 system($cmd);
   }
 
   chdir $cwd
 }

 sub parse_env {    

     my $path = $_[0];

     my $subpath;

     my $handle; 

  

     if (-d $path) {

         if (opendir($handle, $path)) {

             while ($subpath = readdir($handle)) {

                 if (!($subpath =~ m/^\.$/) and !($subpath =~ m/^(\.\.)$/)) {

                     my $p = $path."/$subpath"; 

                     if (-d $p) {
                         if  (!($subpath cmp ".git"))
                         {
                            ++ $dircount;  
                         	#print $path."\n"; 
							my $str = $path;
                         	$str=~ m/([^\/]+)$/;
							my $name = $1;
							#print $name ."\n";
							backup_git $path,$name,$DistPath;
                         	last;
                  	 }
                     else
                     {
                         	parse_env($p);
                     }
                     }
                 }                
             }
             closedir($handle);            
         }
     } 
    return $dircount;
} 

  

 my $count = parse_env $path;

 my $str = "Total git folders:".$count."\n";

 print $str; 