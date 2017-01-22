#!/bin/bash
#network-monitor.sh


function start-mon(){
	airmon-ng check kill
	airmon-ng start wlan0
}

function stop-mon(){
	
	airmon-ng stop wlan0mon
	service networking restart
	service network-manager restart
	echo "Network restarted"
}

function error(){

	echo "This command just have start and stop arguments"
	echo "network-monitor.sh start"
	echo "network-monitor.sh stop"
}

case $1 in
	start)
		start-mon
		;;
	stop)	
		stop-mon
		;;
	*)
		error
		;;
esac
