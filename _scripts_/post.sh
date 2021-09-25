outcome=`lsmod | grep uclogic > /dev/null; echo $?`
if [ "$outcome" != "0" ]; then
  exit 1
fi

echo "Mapping tablet pen to screen"
xinput map-to-output 8 HDMI-1
