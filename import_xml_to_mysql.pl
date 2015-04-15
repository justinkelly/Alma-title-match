#!/usr/bin/perl

use strict;
use XML::Simple;
use Data::Dumper;

my ($type, $folder) = @ARGV;

my @files;

use DBI;

## MySQL database connection details
my $database_name = "alma_title_match";
my $database_host = "localhost";
my $database_user = "root";
my $database_password = "";
my $database_port = "3306";

my $database_driver = "mysql";
my $dsn = "DBI:$database_driver:database=$database_name;host=$database_hoste;port=$database_port";
my $dbh = DBI->connect($dsn, $database_user, $database_password ) or die $DBI::errstr;


@files = <$folder/*.xml>;
foreach my $file (@files) 
{

	print $file ."\n";
	my $xs = XML::Simple->new();
	my $booklist = $xs->XMLin($file,ForceArray=>['subfield']);

	#print Dumper($booklist);
	my $count = 0;
	foreach my $book (@{$booklist->{record}}) {

	#print "Count: ". $count . "\n";
		my $alma_id = $book->{controlfield}[0]->{content};

		$count++;		
		my @isbns;
		my $isbn;
		my $title;
		my $alt_title;
		foreach my $df (@{$book->{datafield}}) {

	##print $df->{datafield}->{subfield}->{content} . "\n";	
	##ISBNa
			if($df->{tag} =='020'){
				$isbn = $df->{subfield}[0]->{content} . "\n";	
				$isbn =~ tr/0-9//cd;
	#print "$isbn \n";	
				push(@isbns,$isbn);
			}
	## TItle
			if(exists($df->{tag}) && exists($df->{subfield}[0]->{code}))
			{
				if($df->{tag} =='245' && $df->{subfield}[0]->{code} =='a'){
					$title = $df->{subfield}[0]->{content} . "\n";	
					$title = lc $title;
					$title =~ tr/a-z0-9 //cd;
					$title =~ s/ +/ /;
	#print "$title \n";	
				}
			}

	## Alt title
			if($df->{tag} =='210' && $df->{subfield}[0]->{code} =='a'){
				$alt_title =  $df->{subfield}[0]->{content} . "\n";	
				$alt_title = lc $alt_title;
				$alt_title =~ tr/a-z0-9 //cd;
				$alt_title =~ s/ +/ /;
	#print "$alt_title \n";	
			}

		}
	##foreach isbn
		foreach my $record (@isbns) {

                my $sth = $dbh->prepare("INSERT INTO overlap_$type
                        (isbn, alma_id, title, alt_title,type )
                        values
                        (?,?,?,?,?)");
 	               $sth->execute($record,$alma_id,$title,$alt_title,$type)
        	            or die $DBI::errstr;
	                $sth->finish();
	#		print "Type: $type | ISBN: $record | Title: $title | Alt Title: $alt_title | Alma ID: $alma_id \n" ;

		}

	##ALma ID
	}
	print "Count: ". $count ."\n";
}
