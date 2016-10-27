#!/bin/sh
ADDON_DIR=$HOME/.xbmc/addons/emulator.retroarch
ADDON_FILES=/storage/emulators/retroarch
ADDON_CORES=$ADDON_DIR/cores
LD_LIBRARY_PATH=$ADDON_DIR/lib

if [ ! "$#" = "2" ];
then
  echo "Usage: `basename $0` core /path/to/romfile"
  echo "Example: `basename $0` snes9x /storage/mario.sfc"
  echo
  echo "Available cores:"
  echo " `ls -1 $ADDON_CORES/*.so  |  cut -d - -f 1 | cut -d / -f 7`"
  echo
  exit 1
fi

if [ ! -f $ADDON_CORES/$1-libretro.so ]; then
  echo "Core $1 not found, exiting."
  exit 1
fi

if [ ! -f "$2" ]; then
  echo "Rom file $2 not found, exiting."
  exit 1
fi

if [ -f "$2.cfg" ]; then
  echo "Config file for `basename "$2"` found, using."
  EXTRAFLAG="--appendconfig "$2.cfg""
fi

if [ ! -d $ADDON_FILES ]; then
  mkdir -p $ADDON_FILES/config
  mkdir -p $ADDON_FILES/rom
  mkdir -p $ADDON_FILES/save
  mkdir -p $ADDON_FILES/system
  mkdir -p $ADDON_FILES/screenshots
  cp $ADDON_DIR/config/retroarch.cfg $ADDON_FILES/config/retroarch.cfg
  cp -a $ADDON_DIR/shaders $ADDON_FILES/
fi

touch /var/lock/xbmc.disabled
killall xbmc.bin
sleep 2

$ADDON_DIR/bin/retroarch -c $ADDON_FILES/config/retroarch.cfg $EXTRAFLAG -L $ADDON_CORES/$1-libretro.so "$2" &

while [ $(pidof retroarch) ];do
    usleep 200000
done;
rm /var/lock/xbmc.disabled

