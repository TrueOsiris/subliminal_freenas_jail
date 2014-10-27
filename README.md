subliminal_freenas_jail
=======================

Subliminal script to run as crontab entry in subliminal jail<br>

Made a script that runs with crontab & bash.<br>
You'll have to install bash first<br>
<code>cd /usr/ports/shells/bash/ && make install clean</code>

crontab -e <br>
says<br>
30 10 * * * bash /mnt/it/dev/scripts/bash/subliminal_cron.sh<br>
which runs subliminal on all folders and it's subfolders, but will keep track on which video files were already checked for subs.
