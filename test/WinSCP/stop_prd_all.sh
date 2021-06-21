#/usr/bin/sh

if [ -z $1 ] || [ -z $2 ] || [ -z $3 ] || [ -z $4 ]; then
	echo "Command Usage"
	echo "Command: stop_prd_all.sh <ap doamin> <prcs domain> <web domain> <web site>"
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

#Stop Web service
psadmin -w shutdown! -d $3 
#stop Application Service
psadmin -c shutdown! -d $1
psadmin -c cleanipc -d $1
#Stop Process Scheduler
psadmin -p stop  -d $2
psadmin -p cleanipc -d $2

#clean AP Service cache
if [ -d $PS_CFG_HOME/appserv/$1/CACHE ]; then
	rm -rf $PS_CFG_HOME/appserv/$1/CACHE/PS*
        echo 'Application Server Cache Files:' `ls -A $PS_CFG_HOME/appserv/$1/CACHE/|wc -l`
else
	echo "do nothing on Application Server Cache!"
fi

#clean Process Scheduler CACHE
if [ -d $PS_CFG_HOME/appserv/$2/CACHE ]; then
	rm -rf $PS_CFG_HOME/appserv/prcs/$2/CACHE/PS*
	echo 'Process Scheduler Cache Files:' `ls -A $PS_CFG_HOME/appserv/prcs/$2/CACHE/|wc -l`
else
	echo "do nothing on Process Scheduler Cache!"
fi

#clean web cache
#Please input correct web cache folder location
echo $PS_CFG_HOME/webserv/$3/applications/peoplesoft/PORTAL.war/$4/cache
if [ -d $PS_CFG_HOME/webserv/$3/applications/peoplesoft/PORTAL.war/$4/cache ]; then
	rm -rf $PS_CFG_HOME/webserv/$3/applications/peoplesoft/PORTAL.war/$4/cache/*
	echo 'PIA Cache Files:' `ls -A $PS_CFG_HOME/webserv/$3/applications/peoplesoft/PORTAL.war/$4/cache/|wc -l`
fi
	echo "do nothing on PIA Web Cache!"
echo '
