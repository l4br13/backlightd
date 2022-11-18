#!/bin/sh

program=$(basename $0)
program_dir=/var/lib/backlight
dir=$(dirname $(realpath 0))
uid=$(id -u)
backlight=/sys/class/backlight

if [ $uid != 0 ]; then
	printf "$program: need to run as root.\n"
	exit
fi

if [ ! -d $program_dir ]; then
	mkdir $program_dir
fi

opt=$(getopt -n $(basename $0) -o hvls -l help,version,load,save,set: -- "$@")

if [ $? -ne 0 ]; then
	printf "Try '$(basename $0) --help' for more information.\n"
	exit
fi

eval set -- $opt

while true; do
	if [ "$1" = "--" ]; then
		shift
		__param=$@
		break
	else
		case $1 in
			--help|-h)
				__help=1
			;;
			--version|-v)
				__version=1
			;;
			--set)
				__set=1
				shift
				__set_args=$1
			;;
			--save)
				__save=1
			;;
			--load)
				__load=1
			;;
			*)
				break
			;;
		esac
	fi
	shift
done

__usage () {
	printf "Usage:	 $(basename $0) [options] [arguments]\n"
	printf "\n"
	printf "Options:\n"
	printf "	--set		set brightness value\n"
	printf "	--save		save brightness value\n"
	printf "	--load		load saved brightness value\n"
	printf "	-v, --version	show version information\n"
	printf "	-h, --help	show help information\n"
	printf "\n"
	return 1
}

__version () {
	printf "v1.0\n"
	return 1
}

__save() {
	if [ ! -d $program_dir ]; then
		mkdir $program_dir
	fi
	for panel_dir in $backlight/*; do
		panel=$(basename $panel_dir)
		cat $panel_dir/brightness > $program_dir/$panel.brightness
	done
	return 1
}

__load() {
	if [ ! -d $program_dir ]; then
		mkdir $program_dir
	fi
	for panel_dir in $backlight/*; do
		panel=$(basename $panel_dir)
		if [ ! -f $program_dir/$panel.brightness ]; then
			continue
		fi
		brightness=$(cat $program_dir/$panel.brightness)
		echo $brightness > $panel_dir/brightness
	done
	return 1
}

__set () {
	if [ -z $1 ]; then
		return 0
	fi
	if [ -z $__param ]; then
		for panel in /sys/class/backlight/*; do
			echo $1 > $panel/brightness
		done
	else
		if [ ! -f /sys/class/backlight/$__param/brightness ]; then
			return 0
		fi
		echo $1 > /sys/class/backlight/$__param/brightness
	fi
	return 1
}

if [ ! -z $__help ]; then
	__usage
elif [ ! -z $__version ]; then
	__version
elif [ ! -z $__set ]; then
	__set $__set_args
elif [ ! -z $__load ]; then
	__load
elif [ ! -z $__save ]; then
	__save
else
	__usage
fi