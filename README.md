subliminal_freenas_jail
=======================

Subliminal script to run as crontab entry in subliminal jail<br>

Made a script that runs with crontab & bash.<br>
You'll have to install bash first<br>
<code>cd /usr/ports/shells/bash/ && make install clean</code>

<code>crontab -e</code><br>
says<br>
<code>30 10 * * * bash /mnt/it/dev/scripts/bash/subliminal_cron.sh</code><br>
which runs subliminal on all folders and it's subfolders, but will keep track on which video files were already checked for subs.<br>
<br>
To install subliminal as a Freenas / Freebsd jail:

Install subliminal in a separate jail
I'm using this package <url>https://github.com/Diaoul/subliminal</url> and all credit goes to the devs.

My sabnzbd downloads all arrive on a network share named 'download' and are extracted to a subfolder herein named 'complete'.<br>
This share is added as storage to the subliminal jail.<br>
In fact, any share with movie files that can be added to the jail will do.<br>

- create a standard jail, preferably enable ssh & login (or access the jail shell via freenas gui)<br>
<code>portsnap fetch extract<br>
mkdir /mnt/download<br>
chown nobody:nogroup /mnt/download<br>
chmod 777 /mnt/download</code><br>
- Add storage via the freenas gui: attach the share where sabnzbd downloads arrive to /mnt/download.<br>

Method 1 : use the port (which I did NOT do, I deinstalled it again).<br>
<code>cd /usr/ports/multimedia/py-subliminal && make install clean BATCH=yes</code><br>
I encountered several errors in this version so u can ignore this line.<br>
Perhaps in the future, this will be updated.<br>

Method 2 : use the latest version<br>
Lets add wget functionality to the jail<br>
<code>cd /usr/ports/ftp/wget && make install clean BATCH=yes<br>
cd ~</code><br>

Option A : Pull the latest stable release package either from python or github<br>
<code>wget https://pypi.python.org/packages/source/s/subliminal/subliminal-0.7.4.tar.gz --no-check-certificate<br>
tar -xvf subliminal-0.7.4.tar.gz<br>
mv subliminal-0.7.4 /usr/share/<br>
mv /usr/share/subliminal-0.7.4 /usr/share/subliminal</code><br>
Option B : Better yet, be a betatester & grab the dev master branch. This gave me the 0.8-dev version (2014-10-16).<br>
<code>wget https://github.com/Diaoul/subliminal/archive/master.zip --no-check-certificate<br>
tar -xvf master.zip<br>
mv subliminal-master /usr/share/<br>
mv /usr/share/subliminal-master /usr/share/subliminal</code><br>

Optional, open up this folder for usage & execution<br>
<code>chown -R nobody:nogroup /usr/share/subliminal<br>
chmod -R 777 /usr/share/subliminal</code><br>

Install dependencies. Might be that the setup does this, but I did so manually<br>
<code>cd /usr/ports/www/py-beautifulsoup/ && make install clean BATCH=yes<br>
cd /usr/ports/multimedia/py-guessit && make install clean BATCH=yes<br>
cd /usr/ports/www/py-requests && make install clean BATCH=yes<br>
cd /usr/ports/multimedia/py-enzyme && make install clean BATCH=yes<br>
cd /usr/ports/www/py-html5lib && make install clean BATCH=yes<br>
cd /usr/ports/devel/py-dogpile.cache && make install clean BATCH=yes<br>
cd /usr/ports/devel/py-babelfish && make install clean BATCH=yes<br>
cd /usr/ports/textproc/py-charade && make install clean BATCH=yes<br>
cd /usr/ports/textproc/py-pysrt && make install clean BATCH=yes<br>

cd /usr/share/subliminal</code><br>


Finally, build & install the package<br>
<code>python2.7 setup.py build<br>
python2.7 setup.py install</code><br>

Now u can use the subliminal command<br>

I suggest to either use crontab to schedule a job, or add some kind of script you can use in sabnzbd via sharing.
My scheduled job for Dutch subtitles :<br>
<code>find /mnt/download/complete/ \( -iname "*.mkv" -or -iname "*.avi" -or -iname "*.mp4" \) -exec subliminal -l nl -- "{}" \;</code><br>

I added the following to crontab using crontab -e<br>
<code>30 10 * * * /mnt/it/dev/scripts/bash/subliminal_cron.sh</code><br>
and subliminal_cron.sh has the following content:<br>
<code>#!/bin/sh<br>
find /mnt/download/complete/ \( -iname "*.mkv" -or -iname "*.avi" -or -iname "*.mp4" \) -exec subliminal -l nl
--addic7ed-username myaddicteduser --addic7ed-password myaddictedpw -- "{}" \;<br>
find /mnt/download/complete/ \( -iname "*.mkv" -or -iname "*.avi" -or -iname "*.mp4" \) -exec subliminal -l en
--addic7ed-username myaddicteduser --addic7ed-password myaddictedpw -- "{}" \;</code><br>

