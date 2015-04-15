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


