#!/bin/sh
################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2017 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

################################################################################
# Colors
ESC_SEQ="\x1b["
COL_RESET=$ESC_SEQ"39;49;00m"
COL_RED=$ESC_SEQ"31;01m"
COL_GREEN=$ESC_SEQ"32;01m"
COL_YELLOW=$ESC_SEQ"33;01m"
COL_BLUE=$ESC_SEQ"34;01m"
COL_MAGENTA=$ESC_SEQ"35;01m"
COL_CYAN=$ESC_SEQ"36;01m"
################################################################################

IN_FILE="$1"

if [ -z "$IN_FILE" ]; then
  echo ""
  echo -e "${COL_RED}Enter the m3u-file from:${COL_YELLOW} http://super-pomoyka.us.to/trash/ttv-list/AceLiveList.php${COL_RESET}"
  echo ""
  exit 1
fi

OUT_DIR="/storage/ttv-m3u"
OUT_FILE="$OUT_DIR/AceLive-TTV.m3u"
LOGO_LIST="/storage/.config/acestream/ttv-logo.list"

mkdir -p $OUT_DIR

cat $IN_FILE | sed 's/(Развлекательные)//; \
                s/(Общие)//; s/(Фильмы)//; \
                s/(Эротика)//; s/(Новостные)//; \
                s/(Региональные)//; s/(Музыка)//; \
                s/(Детские)//; s/(allfon)//; \
                s/(Спорт)//; s/(Религиозные)//; \
                s/(Мужские)//; s/(Познавательные)//;' > $OUT_FILE

sed "s|ttv-logo=|tvg-logo=|g" -i $OUT_FILE

URL_IP=`ifconfig eth0 | awk '/inet addr:/ {print $2}' | sed 's/addr://'`
if [ -z $URL_IP ]; then
  URL_IP=`ifconfig wlan0 | awk '/inet addr:/ {print $2}' | sed 's/addr://'`
  [ -z $URL_IP ] && URL_IP="127.0.0.1"
fi
sed -i -e "s/http:\/\/.*:6878/http:\/\/$URL_IP:6878/g" $OUT_FILE

if [ ! -f "$LOGO_LIST" ]; then
  echo ""
  echo -e "${COL_RED}File not found:${COL_YELLOW} /storage/.config/acestream/ttv-logo.list${COL_RESET}"
  echo ""
  exit 1
fi

cat $LOGO_LIST |  
    while read -r LINE ; do
      CH_NAME=`echo $LINE | awk -F\\# '{print $1}' | sed 's/^[ \t]*//; s/[ \t]*$//'`
      URL_LOGO=`echo $LINE | awk -F\\# '{print $2}' | sed 's/^[ \t]*//; s/[ \t]*$//'`

      sed -i -e "s|tvg-logo=\"$CH_NAME\.png\"|tvg-logo=\"$URL_LOGO\"|ig" $OUT_FILE
      echo -e "${COL_BLUE}Channel name:${COL_YELLOW} $CH_NAME${COL_RESET}"
      echo -e "${COL_BLUE}Channel logo:${COL_YELLOW} $URL_LOGO${COL_RESET}"
      echo ""
    done

echo -e "${COL_RED}Done.${COL_RESET}"
echo ""

exit 0
