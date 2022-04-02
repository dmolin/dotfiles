outcome=`lsmod | grep uclogic > /dev/null; echo $?`
if [ "$outcome" != "0" ]; then
  exit 1
fi

echo "Mapping HUION tablet pen to screen"
id=`xinput | grep "HID 256c:006d stylus" --max-count=1 | awk '{ print $6 }' | awk 'BEGIN {FS="="} { print $2 }'`
xinput map-to-output ${id} HDMI-1
