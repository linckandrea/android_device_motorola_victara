#!/vendor/bin/sh

PATH=/vendor/bin/
export PATH

while getopts d op;
do
	case $op in
		d)  dbg_on=1;;
	esac
done
shift $(($OPTIND-1))

scriptname=${0##*/}

debug()
{
	[ $dbg_on ] && echo "Debug: $*"
}

notice()
{
	echo "$*"
	echo "$scriptname: $*" > /dev/kmsg
}

error_and_leave()
{
	local err_msg
	local err_code=$1
	case $err_code in
		1)  err_msg="Error: No response from touch IC";;
		2)  err_msg="Error: Cannot read property $1";;
		3)  err_msg="Error: No matching firmware file found";;
		4)  err_msg="Error: Touch IC is in bootloader mode";;
		5)  err_msg="Error: Touch provides no reflash interface";;
		6)  err_msg="Error: Touch driver is not running";;
	esac
	notice "$err_msg"
	exit $err_code
}

for touch_vendor in $*; do
	debug "searching driver for vendor [$touch_vendor]"
	touch_driver_link=$(ls -l /sys/bus/i2c/drivers/$touch_vendor*/*-*)
	if [ -z "$touch_driver_link" ]; then
		debug "no driver for vendor [$touch_vendor] is running"
		shift 1
	else
		debug "driver for vendor [$touch_vendor] found!!!"
		break
	fi
done

[ -z "$touch_driver_link" ] && error_and_leave 6

touch_path=/sys/devices/${touch_driver_link#*devices/}
debug "sysfs touch path: $touch_path"

[ -f $touch_path/doreflash ] || error_and_leave 5
[ -f $touch_path/poweron ] || error_and_leave 5

# Set permissions to enable factory touch tests
chown root:mot_tcmd $touch_path/drv_irq
chown root:mot_tcmd $touch_path/hw_irqstat
chown root:mot_tcmd $touch_path/reset

debug "wait until driver reports <ready to flash>..."
while true; do
	readiness=$(cat $touch_path/poweron)
	if [ "$readiness" == "1" ]; then
		debug "ready to flash!!!"
		break;
	fi
	sleep 1
	debug "not ready; keep waiting..."
done
unset readiness

device_property=ro.hw.device
hwrev_property=ro.hw.revision
firmware_path=/system/etc/firmware

let dec_cfg_id_boot=0; dec_cfg_id_latest=0;

read_touch_property()
{
	property=""
	debug "retrieving property: [$touch_path/$1]"
	property=$(cat $touch_path/$1 2> /dev/null)
	debug "touch property [$1] is: [$property]"
	[ -z "$property" ] && return 1
	return 0
}

find_latest_config_id()
{
	debug "scanning dir for files matching [$1]"
	str_cfg_id_latest=""
	let dec=0; max=0;
	for file in $(ls $1 2>/dev/null);
	do
		x=${file#*-}; z=${x#*-}; str_hex=${z%%-*};
		let dec=0x$str_hex
		if [ $dec -gt $max ];
		then
			let max=$dec; dec_cfg_id_latest=$dec;
			str_cfg_id_latest=$str_hex
		fi
	done
	unset dec max x z str_hex
	[ -z "$str_cfg_id_latest" ] && return 1
	return 0
}

read_touch_property flashprog || error_and_leave 1
bl_mode=$property
debug "bl mode: $bl_mode"

read_touch_property productinfo || error_and_leave 1
touch_product_id=$property
if [ -z "$touch_product_id" ] || [ "$touch_product_id" == "0" ];
then
	debug "touch ic reports invalid product id"
	error_and_leave 3
fi
debug "touch product id: $touch_product_id"

read_touch_property buildid || error_and_leave 1
str_cfg_id_boot=${property#*-}
let dec_cfg_id_boot=0x$str_cfg_id_boot
debug "touch config id: $str_cfg_id_boot"

product_id=$(getprop $device_property 2> /dev/null)
[ -z "$product_id" ] && error_and_leave 2 $device_property
product_id=${product_id%-*}
product_id=${product_id%_*}
debug "product id: $product_id"

hwrev_id=$(getprop $hwrev_property 2> /dev/null)
[ -z "$hwrev_id" ] && error_and_leave 2 $hwrev_property
debug "hw revision: $hwrev_id"

cd $firmware_path

debug "search for best hw revision match"
hw_mask="-$hwrev_id"
while [ ! -z "$hw_mask" ]; do
	if [ "$hw_mask" == "-" ]; then
		hw_mask=""
	fi
	find_latest_config_id "$touch_vendor-$touch_product_id-*-$product_id$hw_mask.*"
	if [ $? -eq 0 ]; then
		break;
	fi
        hw_mask=${hw_mask%?}
done

[ -z "$str_cfg_id_latest" ] && error_and_leave 3

firmware_file=$(ls $touch_vendor-$touch_product_id-$str_cfg_id_latest-*-$product_id$hw_mask.*)
debug "firmware file for upgrade $firmware_file"

if [ $dec_cfg_id_boot -ne $dec_cfg_id_latest ] || [ "$bl_mode" == "1" ];
then
	debug "forcing firmware upgrade"
	echo 1 > $touch_path/forcereflash
	debug "sending reflash command"
	echo $firmware_file > $touch_path/doreflash
	read_touch_property flashprog || error_and_leave 1
	bl_mode=$property

	[ "$bl_mode" == "1" ] && error_and_leave 4

	read_touch_property buildid || error_and_leave 1
	str_cfg_id_new=${property#*-}
	debug "firmware config ids: expected $str_cfg_id_latest, current $str_cfg_id_new"

	notice "Touch firmware config id at boot time $str_cfg_id_boot"
	notice "Touch firmware config id in the file $str_cfg_id_latest"
	notice "Touch firmware config id currently programmed $str_cfg_id_new"
else
	notice "Touch firmware is up to date"
fi

# let the next in line to proceed
setprop hw.touch.ready 1

unset device_property hwrev_property
unset str_cfg_id_boot str_cfg_id_latest str_cfg_id_new
unset dec_cfg_id_boot dec_cfg_id_latest
unset hwrev_id product_id touch_product_id
unset synaptics_link firmware_path touch_path
unset bl_mode dbg_on hw_mask firmware_file property

return 0
