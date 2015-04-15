# ExLibris Alma - phyiscal and electronic overlap analysis

Want to find out how many physical books you have in ExLibris Alma that you also have electronic versions of? Then this is for you.

This application analyses the MARCXML files from ExLibris Alma to find out duplicates in your holdings based on ISBN and also by title.

It outputs files that can be imported into ExLibris Alma as sets.

## ISBN matching

In ExLibris Alma a single record may have multiple ISBNs, this application normalises the Alma data based on ISBN allowing to matching against all ISBN of phyiscal records against all ISBNs of electronic records.

Here is a small sample of records where ISBNs are the same

| Alma ID (physical)          | ISBN (physical)           | ISBN (electronic)          | Title (physcial)       | Title (electronic)        |
|------------------|---------------|---------------|-------------|--------------|
| 9914634010001361 | 9780123820204 | 9780123820204 | database modeling and design                                            | database modeling and design                                                         |
| 9914634010001361 |     123820200 |     123820200 | database modeling and design                                            | database modeling and design                                                         |
| 9914632440001361 |     871706865 |     871706865 | titanium                                                                | titanium                                                                             |
| 9914634110001361 | 9781597496537 | 9781597496537 | the basics of information security                                      | the basics of information security                                                   |
| 9914633230001361 |       7144033 |       7144033 | manufacturing planning and control systems for supply chain management  | manufacturing planning and control systems for supply chain management fifth edition |
| 9914633350001361 | 9781849691086 | 9781849691086 | iphone javascript cookbook                                              | iphone javascript cookbook                                                           |

From this data we get just the unique Alma IDs for the matchign physical records and export the results to a file that ExLibris Alma can import as a set.

## Title matching

Given that not all electronic records have ISBNs (or the correct ISBNs) you can also analyse for duplicates based on title. As many electronic record are catalogued differenently titles may be slightly different.  We cater for this siutation by stripping all punctional, extra formatting and lower case the result then checking against only the first 50 characters

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

Again these result can be exported into a format the ExLibrs Alma can import as a set.

ISBN matches are very likely to be exactly the same record in a different format.

Titles matches are far less likely to be exactly the same item in a different format - as many titles are generically worded (Accoutning, Java, etc..) or names the same - which leads to non-accurate matches.

Assume that only 20% or so of the title matches are actually the same

## ExLirbis Alma 

To analyse the ExLibris Alma data we first need to get full outputs files from Alma of all the physical and electronic records.

To do this 

## MySQL Database

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

## Overlap queries

### ISBN matching

This is a query to get a sample of your results with titles, alma id and isbns so can you review the results to ensire that they are accurate

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
#### Save the matchign ISBNs to a CSV file (for Alma)

Once you're happy with the reulst run this query to output a list of uniqeue Alma IDs of physical records that also have electronic copies

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
