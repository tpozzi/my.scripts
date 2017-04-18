#!/bin/bash
all_sw_ports=($(snmpwalk -v 2c -c labtech-snmp 192.168.0.250 iso.3.6.1.2.1.17.7.1.4.5.1.1 | awk '{print $1}' | awk -F \. '{print $14}' | awk '$1<101'))
all_vlan_ports=($(snmpwalk -v 2c -c labtech-snmp 192.168.0.250 iso.3.6.1.2.1.17.7.1.4.5.1.1 | awk '{print $1 " " $4}' | awk -F \. '{print $14}' | awk '$1<101' | awk '{print $2}'))
old_vlan=$(snmpwalk -v 2c -c labtech-snmp 192.168.0.250 iso.3.6.1.2.1.17.7.1.4.5.1.1.54 | awk '{print $4}')
vlan=$1
looptimes=1
ifIndex=$2

i=0
while [ $i -lt ${#all_sw_ports[@]} ]
do
	if [ $looptimes -eq 1 ]
	then
		i2=$i
		i3=0
		i4=1
		while [ $i2 -le 3 ]
		do
			case $i4 in
				1)
					hex_port=8
					;;
				2)
					hex_port=4
					;;
				3)
					hex_port=2
					;;
				4)
					hex_port=1
					;;
			esac
			if [ ${all_vlan_ports[$i2]} -eq $vlan ]
			then
				((array$looptimes[$i3]=$hex_port))
				((array$looptimes[4]+=((array$looptimes[$i3]))))
				echo "${all_vlan_ports[$i2]} - $((array$looptimes[$i3]))"
			else
				if [ -z $ifIndex ] 
				then
					((array$looptimes[$i3]=0))
					((array$looptimes[4]+=((array$looptimes[$i3]))))
					echo "${all_vlan_ports[$i2]} - $((array$looptimes[$i3]))"
				else
					if [ ${all_sw_ports[$i2]} -eq $ifIndex ]
					then
						((array$looptimes[$i3]=$hex_port))
						((array$looptimes[4]=$((array$looptimes[4] + array$looptimes[$i3]))))
						echo "all_vlan_ports[$i2]} - $((array$$looptimes[$i3]))"
					else
						((array$looptimes[$i3]=0))
						((array$looptimes[4]+=((array$looptimes[$i3]))))
						echo "${all_vlan_ports[$i2]} - $((array$looptimes[$i3]))"
					fi
				fi
			fi
			i2=$((i2+1))
			i3=$((i3+1))
			i4=$((i4+1))
		done
		echo "Sum - $((array$looptimes[4]))"
else
		i2=$i
		i3=0
		i4=1
		i5=$((i+4))
		while [ $i2 -lt $i5 ]
		do
			case $i4 in
				1)
					hex_port=8
					;;
				2)
					hex_port=4
					;;
				3)
					hex_port=2
					;;
				4)
					hex_port=1
					;;
			esac
			if [ -z ${all_vlan_ports[$i2]} ]
			then
					echo "NULL"
			else
				if [ ${all_vlan_ports[$i2]} -eq $vlan ]
				then
					((array$looptimes[$i3]=$hex_port))
					((array$looptimes[4]+=((array$looptimes[$i3]))))
					echo "${all_vlan_ports[$i2]} - $((array$looptimes[$i3]))"
				else
					if [ -z $ifIndex ] 
					then
						((array$looptimes[$i3]=0))
						((array$looptimes[4]+=((array$looptimes[$i3]))))
						echo "${all_vlan_ports[$i2]} - $((array$looptimes[$i3]))"
					else
					   if [ "${all_sw_ports[$i2]}" -eq $ifIndex ]
					   then
						   ((array$looptimes[$i3]=$hex_port))
						   ((array$looptimes[4]=$((array$looptimes[4] + array$looptimes[$i3]))))
						   echo "all_vlan_ports[$i2]} - $((array$looptimes[$i3]))"
					   else
							((array$looptimes[$i3]=0))
							((array$looptimes[4]+=((array$looptimes[$i3]))))
							echo "${all_vlan_ports[$i2]} - $((array$looptimes[$i3]))"
					   fi
					fi
				fi
			fi
			i2=$((i2+1))
			i3=$((i3+1))
			i4=$((i4+1))
		done
		echo "Sum - $((array$looptimes[4]))"
	fi
looptimes=$((looptimes+1))
echo "Value of looptimes - $looptimes"
((i+=4))
done
i=1
tmphex=""
while [ $i -lt $looptimes ]
do
	case $((array$i[4])) in
		10)
			tmphex+=A
			;;
		11)
			tmphex+=B
			;;
		12)
			tmphex+=C
			;;
		13)
			tmphex+=D
			;;
		14)
			tmphex+=E
			;;
		15)
			tmphex+=F
			;;
		*)
			if [ -z $((array$i[4])) ]
			then
				exit 0
			else
				tmphex+=$((array$i[4]))
			fi
			;;
	esac

((i+=1))
done
if [ -z $ifIndex ] 
then
	echo $tmphex
else
snmpset -v 2c -c labtech-snmp 192.168.0.250 1.3.6.1.2.1.17.7.1.4.3.1.2.$(echo $vlan) x $(echo "0x000000000000$(echo $tmphex)0") 1.3.6.1.2.1.17.7.1.4.3.1.3.$(echo $vlan) x 0x00 1.3.6.1.2.1.17.7.1.4.3.1.4.$(echo $vlan) x $(echo "0x000000000000$(echo $tmphex)0")
fi
