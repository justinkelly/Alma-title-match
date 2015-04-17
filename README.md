# ExLibris Alma - phyiscal and electronic overlap analysis

Want to find out how many physical books you have in ExLibris Alma that you also have electronic versions of? If so then this is for you.

This application analyses the MARCXML files from ExLibris Alma to find the overlap of your physical and electronic records in your holdings based on ISBN and also by title.

It outputs files that can be imported into ExLibris Alma as sets.

## ISBN matching

In ExLibris Alma a single record may have multiple ISBNs, this application normalises the Alma data based on ISBN allowing for the matching of against all ISBN of phyiscal records against all ISBNs of electronic records.

Here is a small sample of records where ISBNs are the same

| Alma ID (physical)          | ISBN (physical)           | ISBN (electronic)          | Title (physcial)       | Title (electronic)        |
|------------------|---------------|---------------|-------------|--------------|
| 9914634010001361 | 9780123820204 | 9780123820204 | database modeling and design                                            | database modeling and design                                                         |
| 9914634010001361 |     123820200 |     123820200 | database modeling and design                                            | database modeling and design                                                         |
| 9914632440001361 |     871706865 |     871706865 | titanium                                                                | titanium                                                                             |
| 9914634110001361 | 9781597496537 | 9781597496537 | the basics of information security                                      | the basics of information security                                                   |
| 9914633230001361 |       7144033 |       7144033 | manufacturing planning and control systems for supply chain management  | manufacturing planning and control systems for supply chain management fifth edition |
| 9914633350001361 | 9781849691086 | 9781849691086 | iphone javascript cookbook                                              | iphone javascript cookbook                                                           |

From this data we get just the unique Alma IDs for the matching physical records and export the results to a file that ExLibris Alma can import as a set.

## Title matching

Given that not all electronic records have ISBNs (or the correct ISBNs) you can also analyse for duplicates based on title. As many electronic record are catalogued differently, titles may be slightly different.  We cater for this siutation by stripping all punctional, extra formatting and lower case the result then checking against only the first 50 characters. Also to narrow the results we are excluding records that already match on ISBN.

Here is a sample result

| Alma ID (physical) | Alma ID (electronic) | Title (physial) | Title (electronic)|
|--------------------|----------------------|-----------------|-------------------|
| 9914706280001361 | 99333124301361|managing people |managing people|
| 9914727370001361 |99333124301361|managing people |managing people|
| 9914845200001361 |99333439301361|software engineering |software engineering|
| 9914758580001361 |9914687570001361|electric power systems |electric power systems|
| 9914836540001361|99333471201361|color |color|
| 9914857210001361|99333471201361|color |color|
| 9914852230001361|99333515301361|writing winning business proposals |writing winning business proposals|
| 9914758580001361|9914689900001361|electric power systems |electric power systems|
| 9914833850001361|9914988860001361|as time goes by |as time goes by|
| 9914834330001361|9915002000001361|software architecture |software architecture|

Again these results can be exported into a format the ExLibrs Alma can import as a set.

ISBN matches are very likely to be exactly the same record in a different format.

Titles matches are far less likely to be exactly the same item in a different format - as many titles are generically worded  or named the same - which leads to non-accurate matches.

Assume that only 20% or less of the title matches are actually the same

Note: Titles matching excludes records where their ISBNs match - the title matching records complement the ISBN matching results.

## ExLirbis Alma 

To analyse the ExLibris Alma data we first need to get full outputs files from Alma of all the physical and electronic records.

To do this 
...

Export physical books as a set
![](https://457e801a8dceff4f14fee686917b28b7570650e8.googledrive.com/host/0B3qPjbk9su5uT0pQdVhVYXVUbEk/Blog/2015-Alma-export-books.png)

Export electronic books as a set
![](https://457e801a8dceff4f14fee686917b28b7570650e8.googledrive.com/host/0B3qPjbk9su5uT0pQdVhVYXVUbEk/Blog/2015-Alma-export-ebooks.png)


![](https://457e801a8dceff4f14fee686917b28b7570650e8.googledrive.com/host/0B3qPjbk9su5uT0pQdVhVYXVUbEk/Blog/2015-Alma-export-step-1.png)

![](https://457e801a8dceff4f14fee686917b28b7570650e8.googledrive.com/host/0B3qPjbk9su5uT0pQdVhVYXVUbEk/Blog/2015-Alma-export-step-2.png)



Once you have all the MARCXML files for both the electronic and print records save them into the folders on your server/workstation where you'll run this script

Save the electronic records into a folder called 'electronic' 
and physical records into a folder called 'print'

Here is a screenshot of how i've stored the MARCXML files
![](https://457e801a8dceff4f14fee686917b28b7570650e8.googledrive.com/host/0B3qPjbk9su5uT0pQdVhVYXVUbEk/Blog/2015-Alma-title-match.png)
## MySQL Database

On your MySQL server create a new blank database and import the  [database_setup.sql](https://github.com/justinkelly/Alma-title-match/blob/master/database_setup.sql) file
- or just copy and paste the contents of the file into your MySQL query console to execute

## Config

Edit the import_xml_to_mysql.sql file and update it with your MySQL database connection information

```
## MySQL database connection details
my $database_name = "alma_title_match";
my $database_host = "localhost";
my $database_user = "root";
my $database_password = "";
my $database_port = "3306";
```

## Perl and Linux

This import script is written in Perl, please ensure you have the below Perl modules installed on your system

* XML::Simple
* Data::Dumper
* DBI

The script runs best on a Linux type system, it just needs Perl, the above Perl modules, and MySQL client software installed to run.

## Import the MARCXML files to MySQL

Once you have edited the import file to add int he MySQL connection details run the import script over the MARCXML files to convert MARCXML to MySQL

In the difrectory where you have the import script and MARCXML files to import the phyiscal records run

Note: the first argument 'physical' records into the Database the type of iles
the second argument 'print' define the directory that stores the MARCXML files for the physical/print records.

```
perl import_xml_to_mysql.pl 'physical' 'print' > outpul_physical.txt
```

To import the electronic records run

```
perl import_xml_to_mysql.pl 'electronic' 'electronic' > output_electronic.txt
```
Note: the first argument 'electronic' records into the Database the type of files
the second argument 'electronic' define the directory that stores the MARCXML files for the electronic records.

These 2 script convert all the MARCXML files in the specified directories into your MySQL database.

Both imports can take a number of hours based on the number of records and type of server.

Once done we can analyse the data use SQL.

## Overlap queries

### ISBN matching

This is a query to get a sample of your results with titles, Alma ID and ISBNs so can you review the results to ensure that they are accurate

```
select 
  distinct 
    overlap_physical.alma_id, 
    overlap_physical.isbn, 
    overlap_electronic.isbn, 
    overlap_physical.title, 
    overlap_electronic.title  
from 
  overlap_physical 
    INNER JOIN 
    overlap_electronic ON overlap_physical.isbn = overlap_electronic.isbn
limit 20;
```

Heres is a sample result

| Alma ID (physical)          | ISBN (physical)           | ISBN (electronic)          | Title (physcial)       | Title (electronic)        |
|------------------|---------------|---------------|-------------|--------------|
| 9914634010001361 | 9780123820204 | 9780123820204 | database modeling and design                                            | database modeling and design                                                         |
| 9914634010001361 |     123820200 |     123820200 | database modeling and design                                            | database modeling and design                                                         |
| 9914632440001361 |     871706865 |     871706865 | titanium                                                                | titanium                                                                             |




#### Save the matchign ISBNs to a CSV file (for Alma)

Once you're happy with the results run this query to output a list of unique Alma IDs of physical records that also have electronic copies

```
select 
  distinct 
    overlap_physical.alma_id 
from 
  overlap_physical 
    INNER JOIN 
    overlap_electronic ON overlap_physical.isbn = overlap_electronic.isbn 
INTO OUTFILE '/tmp/alma_isbn.csv' FIELDS TERMINATED BY ',';
```

Here is a sample result , note that only unique Alma IDs are selected - there are no duplicates - unlike the previos tseting query

| Alma ID (physical) |
|------------------|
| 9914634010001361 |
| 9914632440001361 |  

This CSV file can be saved in Excel as .xls or .xlsx and import into Alma as a set for further analyses.

#### Save the matchign ISBNs to a separate table

Run this query to save the matching ISBNs into a separate table - this is to speed up the title matching queries in the next section

```
insert 
  into 
  overlap_overlap (alma_id)  
    select 
      DISTINCT 
        overlap_physical.alma_id 
    from
      overlap_physical 
      INNER JOIN 
        overlap_electronic ON overlap_physical.isbn = overlap_electronic.isbn ;
```

### Title matching query

To match electronic and physical title by not - where they have not already been matched on ISBN in the previous query - run the below query.

This output a csv file to /tmp called alma_titles.csv

```
SELECT 
  DISTINCT 
    overlap_physical.alma_id as p_alma_id, 
    overlap_electronic.alma_id as e_alma_id, 
    overlap_physical.title as p_title,
    overlap_electronic.title as e_title 
from 
  overlap_physical, 
  overlap_electronic 
where 
  LEFT(overlap_physical.title,50) = LEFT(overlap_electronic.title,50)
  AND 
    overlap_physical.isbn != overlap_electronic.isbn 
  AND 
    overlap_physical.alma_id NOT IN  (select overlap_overlap.alma_id from overlap_overlap)
  INTO OUTFILE '/tmp/alma_titles.csv' FIELDS TERMINATED BY ',';
```

Here is a sample result

| Alma ID (physical) | Alma ID (electronic) | Title (physial) | Title (electronic)|
|--------------------|----------------------|-----------------|-------------------|
| 9914706280001361 | 99333124301361|managing people |managing people|
| 9914727370001361 |99333124301361|managing people |managing people|
| 9914845200001361 |99333439301361|software engineering |software engineering|

Again this CSV file can be saved in Excel as .xls or .xlsx and import into Alma as a set for further analyses.
