import shutil
import filecmp
import glob
import os
from datetime import datetime


print '================'
print 'Checking whether MySQL configuration file has changed since last Online check'
#copy current conf
shutil.copyfile('/etc/my.cnf', 'my.cnf.' + datetime.now().strftime("%Y%m%d%H%M%S"))
conf_files = sorted(glob.glob('my.cnf*'), reverse = True)
if len(conf_files) > 1:
   if filecmp.cmp(conf_files{0], conf_files[1], True):
      print 'No changes, all good!'
   else:
      print 'Configuration file has changed since last run.'
      print 'Do a diff on ' + conf_files[0] + ' and ' + conf_files[1]
      print 'and review changes'
else:
   print 'No file to compare with'

#delete obsolete conf files
if len(conf_files) > 1:
   for i in range(1, len(conf_files)):
      print 'Deleted obsolete conf file ' + conf_files[i]
      os.remove(conf_files[i])
print '================'

