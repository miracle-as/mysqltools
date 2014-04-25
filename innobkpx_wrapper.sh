#!/usr/bin/bash

OUTDIR=/mnt/dbbackup             # or whereever it may be practical
BKUPDIR=${OUTDIR}/mysqlbkup`date +"%Y%m%d"`_`date +"%H%M"`
USER=""                          # my backup username
PASSWORD=""                      # my backup password
SOCKET=/var/lib/mysql/mysql.sock # or whereever it may reside
LOGFILE=${OUTDIR}/logs/`date +"%Y%m%d"`.mysql.backup.log
TODAY=`date +"%Y%m%d"`
NOW=`date +"%H%M"`
NODE=`uname -n | awk -F\. '{print $1}'`


echo "${TODAY}-${NOW}-${0} Initializing Online backup of mysql to ${BKUPDIR}"                          2>&1 >> ${LOGFILE}

### check mountpoint ->
RETVAL=0
if [ ! -f ${OUTDIR}/nfs_up ] ; then
   mount ${OUTDIR}
   RETVAL=$?
   if [ $RETVAL -eq 0 ];then echo "${TODAY}-${NOW} - ${NODE}:${0} ${OUTDIR} is mounted"                2>&1 >> ${LOGFILE}
   else echo "${TODAY}-${NOW}-${NODE}:${0} ERROR ${OUTDIR} NOT  mountable"                             2>&1 >> ${LOGFILE}
      exit 1         
   fi
fi
###

### do backup ->
innobackupex --user=${USER} --password=${PASSWORD} --socket=${SOCKET} --compress --no-timestamp ${BKUPDIR} 2>> ${LOGFILE} 
if [ $RETVAL -eq 0 ] ;then
   echo "${TODAY}-${NOW} - ${NODE}:${0} MySQL backup is Successfull"                                   2>&1 >> ${LOGFILE}
else [ $RETVAL -ne 0 ] && ErrHeader="${TODAY}-${NOW} - ${NODE}: ERROR MySQL backup FAILED in ${0}" 
   echo ${ErrHeader}                                                                                   2>&1 >> ${LOGFILE}
   exit 1
fi
###


### log file maintenance ->
#Retain last 14 logfiles
FILEPAR1=${OUTDIR}/logs/*.log
RETAIN=14
FILES=(`ls -lt ${FILEPAR1}| awk '{print $9}'`)
FLEN=${#FILES[@]}
 
for (( i=${RETAIN}; i<${FLEN}; i++ ));
do
  echo ${TODAY}-${NOW} Removed $i                                                                      2>&1 >> ${LOGFILE}
  rm -f ${FILES[$i]}                                                                                   2>&1 >> ${LOGFILE}
done
###

