# zimbra-mailboxes-backup
Bash script for backing up Zimbra mailboxes.

For now it's simple, it backups all the mailboxes on the server if no options are given and backups the selected domain if -d option is given.

The mechanism of backup is described on zmmailbox tool page:
https://wiki.zimbra.com/wiki/Zmmailbox ( see Export/import an entire account section)


USAGE
-d, --domain WORD                       backup accounts with the specified WORD in the name, insert @domain.ltd for filtering by domain

-f, --folder /PATH/TO/DIRECTORY         backup to specified path, default /opt/zimbra/backup/mailbox can be modified in the script file

-k, --keep X                            keep X previous backups, by default 5. The older backups will be automatically deleted. The default number can be modified in the script file.
