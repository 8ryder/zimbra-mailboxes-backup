#!/bin/bash

DESTINATION=/opt/zimbra/backup/mailbox/$(date '+%Y-%m-%d')

while [[ $# -gt 1 ]]
do
key="$1"

case $key in
    -d|--domain)
    DOMAIN="$2"
    shift # past argument
    ;;
    *)
            # unknown option
    ;;
esac
shift # past argument or value
done

#keep only 5 folders with backups
cd /opt/zimbra/backup/mailbox/
rm -f $(ls -1t * | tail -n +6)

#create the folder for the today backup
mkdir /opt/zimbra/backup/mailbox/$(date '+%Y-%m-%d')



echo ----
echo $DOMAIN
echo ----



echo $(zmprov -l gaa | grep $DOMAIN)
        for i in $( zmprov -l gaa | grep $DOMAIN); do
                echo "starting backup for" $i
                /opt/zimbra/bin/zmmailbox -z -m $i -t 0 getRestURL '//?fmt=tgz' > $DESTINATION/$i.tgz
                echo "finished backup for " $i
       done
