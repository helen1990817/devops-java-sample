#/usr/bin/sh

if [ -z $1 ] || [ -z $2 ] || [ -z $3 ] || [ -z $4 ]; then
	echo "Command Usage"
	echo "Command: start_prd_all.sh <ap doamin> <prcs domain> <web domain>"
	echo "#############################################################################"
	exit 1
fi

export PS_HOME=/u01/app/psoft/pt854
export PS_CFG_HOME=/u01/app/psoft/config
export TUXDIR=/u01/app/middleware/tux1211
export LD_LIBRARY_PATH=/u01/app/psoft/pt854/bin:/u01/app/middleware/tux1211/lib:$LD_LIBRARY_PATH
export PATH=$ORACLE_HOME/bin:$TUXDIR/bin:$PS_HOME/bin:$PATH

cd /u01/app/psoft/pt854
. psconfig.sh

#Start Process Scheduler
psadmin -p start -d $2
#Start Application Server
psadmin -c boot -d $1
#Start Web Service
psadmin -w start -d $3

