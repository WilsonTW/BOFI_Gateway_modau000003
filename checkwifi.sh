ping -c4 8.8.8.8 > /dev/null

if [ $? != 0 ]
then
  sudo reboot
fi