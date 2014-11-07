#!/bin/bash
GL=1
log=""
qlog ( ) {
	d="$(date "+%Y%m%d %T")"
	mes="$d $1"
	log="$log$mes\n"
	echo "$mes" >> $logfile
	if [ "$2" == "1" ] 
	then
		echo $mes
	fi
}
reverser() {
	input="$1"
	reverse=""
	extension=""
	declare -a listf
	L=`find . -maxdepth 1 -iname "$input"`
	listf=( `echo $L`)
	echo ${listf[@]}
	n=0
	for (( k=0;k<4;k++))
	do
		m=$[4-$k]
		len=$[${#input}-$m]
		dig=${input:len:1}
		if [ "$dig" = "." ]
		then
			n=$m
		fi
	done
	len=${#input}-$n
	for (( i=$len-1; i>=0; i-- ))
	do
		reverse="$reverse${input:$i:1}"
	done
	extension=${input:len:n}
	reverse="$reverse$extension"
	mv -i "$input" "$reverse"
}
qfile() {
	# parameters 1 2 3 = logfile videofiles directory
	if [[ ! -e "$1" ]]
	then
		touch "$1"
		qlog "$1 created"
	else
		if [[ ! -w "$1" ]] 
		then
			printf "b\n"
			if [ $GL = 1 ]
			then
				printf "%b" "\e[1;31mcannot write to $1\e[0m\n"
				qlog "\e[1;31mcannot write to $1\e[0m"
			fi
			GL=0
		else   
			qlog "writing subliminal input line to $1"
			lang1="nl"
			lang2="en"
			#comnd1="subliminal -l $lang1 --verbose --single --providers podnapisi opensubtitles thesubdb tvsubtitles addic7ed --addic7ed-username trueosiris --addic7ed-password Elvis001 -- \"$3/$2\""
			comnd1="subliminal -l $lang1 --verbose --single --providers opensubtitles thesubdb tvsubtitles addic7ed --addic7ed-username myuser --addic7ed-password mypass -- \"$3/$2\""
			comnd2="subliminal -l $lang2 -q --providers opensubtitles thesubdb tvsubtitles addic7ed --addic7ed-username myuser --addic7ed-password mypass -- \"$3/$2\""			
			if grep -q "$3@@$2" "$1"
			then
				# check if sub already present
				movie=$2
				prefix=${movie:0:-4}
				#sub1="$prefix.$lang1.srt"
				sub1="$prefix.srt"
				sub2="$prefix.$lang2.srt"
				if [ ! -f $sub1 ]; then
					qlog "File $sub1 not found. Running subcheck:" 1
					qlog $comnd1 1
					eval $comnd1
				else
					qlog "skipping $2 in $3 for already present $sub1" 1
				fi
				if [ ! -f $sub2 ]; then
					qlog "File $sub2 not found. Running subcheck:" 1
					qlog $comnd2 1
					eval $comnd2
				else
					qlog "skipping $2 in $3 for $sub2" 1
				fi
				# end of check
			else
				# new file ? full subcheck
				qlog "Running subliminal for new file \"$2\" in $3" 1
				echo $comnd1
				eval $comnd1
				echo $comnd2
				eval $comnd2
				qlog "writing $3 $2 to $1"				
				echo "$3@@$2" >> $1
			fi
		fi
		qlog "$1 found"
	fi
}
qpar() {
	cur="$(pwd)"
	if [ -d "$1" ]
	then
		cd "$1"
		# which files need to be reversed ? posted with mirrored names nowadays
		rev=`find . -maxdepth 0 \( -iname "qoq*.mkv" -or -iname "sgnidrocervt*.mkv" -or -iname "sgnidrocervt*.avi" -or -iname "sbusln*.mkv" -or -iname "sbusln*.avi" \) | sed 's/\.\///g'`
		if [ "$rev" != "" ]
		then
			reverse "$rev"
		fi
		files=()
		OLDIFS=$IFS
		IFS=$'\n'
		files=($(find * -maxdepth 0 \( -iname "*.mkv" -o -iname "*.avi" -o -iname "*.mp4" \) \! -iname "*sample*" -type f | sed 's/^\.\///g' | sed 's/\ /./g'))
		# restore it 
		IFS=$OLDIFS
		if [ "$files" != "" ]
		then
			for j in $files
			do
				echo "TESTING ---> $j"
				qfile "$2" "$j" "$(pwd)"
			done
		fi
		#fi
		### Recall this very script for each subdirectory ###
		for x in *
		do 
			if [ -d "$x" ]
			then
				qpar "$x" "$2"
			fi
		done
		cd ..
	fi
}

thisdir=`pwd`
basedir=/mnt/download/complete/
cd $basedir

input="$1"
fetchedsubliminals="$2"
logfile="$3"
if [ ! $1 ]
then
	input="$(pwd)"
fi
if [ ! $2 ]
then
	fetchedsubliminals="$(pwd)/.fetchedsubliminals"
fi
if [ ! $3 ]
then
	logfile="$(pwd)/.subliminal.log"
fi
if [[ -e $logfile ]]
then
        touch $logfile
fi 
qpar "$input" "$fetchedsubliminals"

cd $thisdir
