outcome=`lsmod | grep uclogic > /dev/null; echo $?`
if [ "$outcome" != "0" ]; then
  exit 1
fi

echo "Mapping tablet pen to screen"
id=`xinput | grep "stylus" | awk '{ print $6 }' | awk 'BEGIN {FS="="} { print $2 }'`
xinput map-to-output ${id} HDMI-1
