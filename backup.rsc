### Set local variables. Change the value between "" to reflect your environment. Do not delete quotation marks. 
:local ftpserver "int-ftp"
:local username ""
:local password ""
:local encpass ""

### Set Local and Remote Filename variables. Do not change this unless you want to edit the format of the filename.
### Default "local file name" is always the same to avoid lots of files and running out of space, "remote file name" uploaded to FTP has the date
:local hostname [/system identity get name]
:local date ([:pick [/system clock get date] 7 11] \
. [:pick [/system clock get date] 0 3] \
. [:pick [/system clock get date] 4 6]);
:local localfilename "$hostname-Backup-Daily";
:local remotefilename "$hostname-$date";

### Enable for Debug removing staing hash in the following lines
:log info "$localfilename";
:log info "$remotefilename";
:log info "$hostname";
:log info "$date";

### Stating the Backup
:log info "STARTING BACKUP";

### Create backup file and export the config.
export compact show-sensitive file="$localfilename"
/system backup save name="$localfilename" password="$encpass"
:log info "Backup Created Successfully"

### Upload config file to FTP server.
/tool fetch address=$ftpserver src-path="$localfilename.backup" \
user=$username mode=ftp port=21 password=$password \
dst-path="/home/$hostname/$remotefilename.backup" upload=yes
:log info "Config Uploaded Successfully"

### Upload backup file to FTP server.
/tool fetch address=$ftpserver src-path="$localfilename.rsc" \
user=$username mode=ftp port=21 password=$password \
dst-path="/home/$hostname/$remotefilename.rsc" upload=yes
:log info "Backup Uploaded Successfully"

### Wait 2 second before doing anything
delay 2;

### Remove starting hash in the following lines to delete created backup files once they have been uploaded. I usually let them there because it's useful having them ready.
#/file remove "$localfilename.backup"
#/file remove "$localfilename.rsc"
#:log info "Local Backup Files Deleted Successfully"

### Finishing the Backup
:log info "BACKUP FINISHED";