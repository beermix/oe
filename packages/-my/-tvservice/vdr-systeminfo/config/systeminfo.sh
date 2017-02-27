#!/bin/sh
# systeminfo.sh: external data collection script
# This file belongs to the VDR plugin systeminfo
#
# See the main source file 'systeminfo.c' for copyright information and
# how to reach the author.
#
# $Id$
#
# possible output formats:
# (blanks around tabs only for better reading)
# 1)   Name \t Value         	displays Name and Value
# 2)   Name \t Value1 \t Value2 displays Name, Value1 and Value2
# 3)   Name \t total used       displays an additional progress bar (percentage) after the values
# 4)   s \t Name \t ...         defines a static value, this line is only requested during the first cycle
#
# special keywords (they are replaced by the plugin with the actual value):
#      CPU%    CPU usage in percent
#
# test with: for i in $(seq 1 16); do systeminfo.sh $i;echo;done
#

PATH=/usr/bin:/bin:/sbin

case "$1" in
	1)	# kernel version (static)
		KERNEL=$(uname -rmv)
		echo -ne "s\tLinux Kernel:\t\t"$KERNEL
		exit
        	;;

	2)	# distribution release (static)
		if test -f /etc/os-release; then
			RELEASE=$(grep "^PRETTY_NAME=" /etc/os-release|cut -d"=" -f 2|tr -d '"'|tr -d "'")
		else
			RELEASE="unknown"
		fi
		echo -ne "s\tDistribution:\t\t"$RELEASE
		exit
        	;;

	3)	# CPU type (static)
		CPUTYPE=$(grep 'model name' /proc/cpuinfo | cut -d':' -f 2  | cut -d' ' -f2- | uniq)
		echo -ne "s\tCPU Type:\t\t"$CPUTYPE
		exit
        	;;

	4)	# current CPU speed
		VAR=$(grep 'cpu MHz' /proc/cpuinfo | sed 's/.*: *\([0-9]*\)\.[0-9]*/\1 MHz/')
		echo -ne "CPU speed:\t\t"$VAR
		exit
        	;;

	5)	# current Display resolution
		D_DEV=$(xrandr |grep ' connected' | awk '{print $1}')
		D_RES=$(xrandr |grep ' connected' | awk '{print $3}' | sed s/+.*//)
		echo -ne "Display:\t"${D_DEV:-<unknown>}"\t"${D_RES:-N/A}
		exit
        	;;

	6)	# hostname and IP (static)
		hostname=$(hostname)
		IP=$(ifconfig eth0 | grep inet | cut -d: -f2 | cut -d' ' -f1)
		echo -ne "Hostname:\t"${hostname:-<unknown>}"\tIP: "${IP:-N/A}
		exit
        	;;

	7)	# temperature of CPU and mainboard
		CPU=`cputemp`
		echo -ne "Temperatures:\tCPU: "$CPU
		exit
        	;;

	8	)# GPU temperature
		GPU=`gputemp`
		echo -e "\tGPU: "$GPU
		exit
        	;;

	9)	# CPU usage
		VDRCPU=$(ps -C vdr -o %cpu= | sort | tail -n1)
		echo -e "CPU time:\t"$VDRCPU%
		exit
        	;;

	10)	# time and uptime
		TIME=$( echo `uptime` | awk '{ print $1 }' )
		UPTIME=$( echo `uptime` | sed 's/,/ /' | cut -d' ' -f3,4,6 )
		echo -ne "Time:\t"$TIME"\tUptime: "$UPTIME
        	exit
        	;;

	11)	# header (static)
		echo -ne "s\t\ttotal / free"
		exit
            ;;

	12)	# video disk usage
		VAR=$(df -Pk /storage/videos | tail -n 1 | tr -s ' ' | cut -d' ' -f 2,4)
		echo -ne "Video Disk:\t"$VAR
		exit
        	;;

	13)	# memory usage
		VAR=$( grep -E 'MemTotal|MemFree' /proc/meminfo | cut -d: -f2 | tr -d ' ')
		echo -ne "Memory:\t"$VAR
		exit
        	;;

	14)	# swap usage
		VAR=$(grep -E 'SwapTotal|SwapFree' /proc/meminfo | cut -d: -f2 | tr -d ' ')
		echo -ne "Swap:\t"$VAR
		exit
        	;;
	test)
		echo ""
		echo "Usage: systeminfo.sh {1|2|3|4|...}"
		echo ""
		exit 1
        	;;
esac
exit
