 #
 # ----------------------------------------------------------------------------
 # "THE BEER-WARE LICENSE" (Revision 42):
 # <kod@miracleas.dk> wrote this file. As long as you retain this notice you
 # can do whatever you want with this stuff. If we meet some day, and you think
 # this stuff is worth it, you can buy me a beer in return - Kristian Martensen
 # ----------------------------------------------------------------------------
 #

import datetime
import MySQLdb
import os

dbh = MySQLdb.connect(host='localhost', user='root', passwd='')
dbh.query('SET autocommit=0')
dbh.query('FLUSH TABLES WITH READ LOCK;')
os.system('btrfs subvolume snapshot /var/lib/mysql/ /path/to/backups/mybak_' + str(datetime.date.today()) )
dbh.query('UNLOCK TABLES;')
dbh.close()

