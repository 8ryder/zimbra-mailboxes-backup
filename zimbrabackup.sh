#!/bin/bash

DOMAIN=''
DESTINATION=/opt/zimbra/backup/mailbox
DESTINATION_PREFIX=zmbrbckp
KEEP=5

function help
	{	
		echo "
		USAGE
		-d, --domain WORD			backup accounts with the specified WORD in the name, insert @domain.ltd for filtering by domain
		-f, --folder /PATH/TO/DIRECTORY		backup to specified path, default /opt/zimbra/backup/mailbox can be modified in the script file
                -k, --keep X                            keep X previous backups, by default 5. The older backups will be automatically deleted. Has to be integer, the default number can be modified in the script file.
                -h, --help                              display this help

                "
		}  


while [[ $# -ge 1 ]]
do
key="$1"

case $key in
    -d|--domain)
	if [ -z $2 ]; then echo "domain option selected, but no domain inserted"
	exit 1
	fi
    DOMAIN="$2"
    shift # past argument
    ;;
    -f|--folder)
        if [ -z $2 ]; then 
		echo "folder option selected, but no path specified"
        	exit 1
        fi
	
	if ! [ -d "$2" ]; then
		echo "the specified path is not valid"
		exit 1
	fi

    DESTINATION="$2"
    shift # past argument
    ;;
    -k|--keep)
	case $2 in
    		''|*[!0-9]*) 
			echo "the specified keep argument is not an integer"
			exit 1
			;;
		*) KEEP=$2 ;;
	esac
    shift # past argument
    ;;
    -h|--help)
	help
	exit 1
    shift #past argument
    ;;
    *)
	echo "unknown option"
	help
	exit 1
            # unknown option
    ;;
esac
shift # past argument or value
done

#set the real destination path, with selected path, prefix and today date
DESTINATION_FINAL=$DESTINATION/$DESTINATION_PREFIX-$(date '+%Y-%m-%d')

#keep only 5 folders with backups
cd $DESTINATION
rm -f $(ls -1dt $DESTINATION/$DESTINATION_PREFIX-* | tail -n +$KEEP)

#create the folder for the today backup
mkdir $DESTINATION_FINAL


echo ----
echo "selected domain " $DOMAIN
echo "selected keeping number " $KEEP
echo "selected destination folder " $DESTINATION
echo "the final destination folder is: " $DESTINATION_FINAL
echo ----

#here we test if domain variable is set and then chose accounts to backup
if [ -z $DOMAIN ]; then
	ACCOUNTS=$(/opt/zimbra/bin/zmprov -l gaa)
else
	ACCOUNTS=$(/opt/zimbra/bin/zmprov -l gaa | grep $DOMAIN)
fi

for account in $ACCOUNTS; 
		do
			echo "starting backup for" $account
			/opt/zimbra/bin/zmmailbox -z -m $account -t 0 getRestURL '//?fmt=tgz' > $DESTINATION_FINAL/$account.tgz
			echo "finished backup for " $account
       		done
