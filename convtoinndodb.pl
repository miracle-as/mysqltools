#!/usr/bin/perl

use DBI;
use strict;

my $dsn      = 'DBI:mysql:database=information_schema;host=localhost'; 
my $dbuser   = 'root';
my $password = '';
my $dbh      = DBI->connect($dsn, $dbuser, $password, { RaiseError => 1, AutoCommit => 0 });
my $sth      = $dbh->prepare("select table_schema , table_name
                              from   information_schema.tables 
                              where  engine like 'myisam' 
                                and  table_schema not in ( 'mysql', 'information_schema' ) "
                            );

$sth->execute();

while (my $ref = $sth->fetchrow_hashref()) {
   print "Found a table: schema:  = $ref->{'table_schema'}, name = $ref->{'table_name'} \n";
   print "converting to innodb \n";

   $dbh->do("alter table $ref->{'table_schema'}.$ref->{'table_name'} engine=InnoDB");

   print "done with this one \n";  
}

$sth->finish();

print "done with all \n";

$dbh->disconnect();
