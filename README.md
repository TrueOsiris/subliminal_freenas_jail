subliminal_freenas_jail
=======================

Subliminal script to run as crontab entry in subliminal jail

Made a script that runs with crontab & bash.
You'll have to install bash first
cd /usr/ports/shells/bash/ && make install clean

crontab -e 
says
30 10 * * * bash /mnt/it/dev/scripts/bash/subliminal_cron.sh
which runs subliminal on all folders and it's subfolders, but will keep track on which video files were already checked for subs.
