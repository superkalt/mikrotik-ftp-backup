### Set local variables. Change the value between "" to reflect your environment. Do not delete quotation marks. 
:local FTPSERVER xxxx
:local FTPUSERNAME xxxx
:local FTPPASSWORD xxxx
#:local ENCPASS 

### Set Local and Remote Filename variables. Do not change this unless you want to edit the format of the filename.
### Default "local file name" is always the same to avoid lots of files and running out of space, "remote file name" uploaded to FTP has the DATE
:local HOSTNAME [/system identity get name]
:local DATE ([:pick [/system clock get date] 7 11] \
. [:pick [/system clock get date] 0 3] \
. [:pick [/system clock get date] 4 6]);
:local LOCALFILENAME "$HOSTNAME-Backup-Daily"
:local REMOTEFILENAME "$HOSTNAME-$DATE"

### Enable for Debug removing staing hash in the following lines
:log info "BACKUP: STARTING"
#:log info "BACKUP: FTPSERVER: $FTPSERVER"
#:log info "BACKUP: FTPUSER: $FTPUSERNAME"
#:log info "BACKUP: FTPPASSWORD: $FTPPASSWORD"
#:log info "BACKUP: LOCALFILENAME: $LOCALFILENAME"
#:log info "BACKUP: FTPFILENAME: $REMOTEFILENAME"
#:log info "BACKUP: $HOSTNAME"
#:log info "BACKUP: $DATE"

### Create backup file and export the config.
export compact show-sensitive file="$LOCALFILENAME"
/system backup save name="$LOCALFILENAME"
#/system backup save name="$LOCALFILENAME" password="$ENCPASS"
:log info "BACKUP: Created Successfully"

### Upload config file to FTP server.
/tool fetch address=$FTPSERVER src-path="$LOCALFILENAME.backup" \
user=$FTPUSERNAME mode=ftp port=21 password=$FTPPASSWORD \
dst-path="/mikrotik-backup/$REMOTEFILENAME.backup" upload=yes
#:log info "Config Uploaded Successfully"

### Upload backup file to FTP server.
/tool fetch address=$FTPSERVER src-path="$LOCALFILENAME.rsc" \
user=$FTPUSERNAME mode=ftp port=21 password=$FTPPASSWORD \
dst-path="/mikrotik-backup/$REMOTEFILENAME.rsc" upload=yes
#:log info "Backup Uploaded Successfully"

### Wait 2 second before doing anything
delay 2;

### Remove starting hash in the following lines to delete created backup files once they have been uploaded. I usually let them there because it's useful having them ready.
/file remove "$LOCALFILENAME.backup"
/file remove "$LOCALFILENAME.rsc"
:log info "BACKUP: Local Files Deleted Successfully"

### Finishing the Backup
:log info "BACKUP: FINISHED"
