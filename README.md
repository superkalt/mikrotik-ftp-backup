# mikrotik-ftp-backup
This is a script sourced from a kind user on the Mikrotik forums: https://forum.mikrotik.com/viewtopic.php?t=159432

I have tweaked it a little, mainly for the purpose of encrypting the backup and including sensitive data in the config extract.

This can be added as a script via the Tools->Scripts path in Mikrotik. A schedule can then be added in System->Scheduler.

Frustratingly, TLS FTP doesn't appear to be supported by MikroTik.