OK_MARK="\033[0;32m\xE2\x9C\x94\033[0m"
KO_MARK="\033[0;31m\xE2\x9C\x96\033[0m"

x=()
y=()

function ProgressBar {
 let _progress=(${1}*100/${2}*100)/100
 let _done=(${_progress}*4)/10
 let _left=40-$_done

 _fill=$(printf "%${_done}s")
 _empty=$(printf "%${_left}s")

 printf "\rProgress : [${_fill// /\#}${_empty// /-}] ${_progress}%%"
}

function f1 {
 a=`jar tf $1 | grep '\.class' | head -1`
	if [[ "$a" == *.class ]]; then
	 b=`echo ${a%.*}`
	 c=`javap -classpath $1 -verbose $b | grep "major"`
		d=${c//major version: }
		e=`echo $d:$1`
	 x+=($e)
	else
	 e=`echo '?':$1`
	 y+=($e)
	fi
}

function f2 {
	ldir=`ls`
	count=`ls | wc -l`
	index=0

	for e in $ldir
	do
		f1 $e
		index=$[$index +1]
		ProgressBar ${index} ${count}
	done

 printf "\33[2K\r"
	printf "OK: ${#x[@]} , KO: ${#y[@]} %s\n"	
	printf "${KO_MARK} %s\n" "${y[@]}" | sort -V
	printf "${OK_MARK} %s\n" "${x[@]}" | sort -V
}

# home_mf=${home//\//\\} # / -> \
# home_mf=${home//\\//}  # \ -> /

odir="$PWD"
ndir=${1//\\//}
cd $ndir
f2 $ndir
cd $odir