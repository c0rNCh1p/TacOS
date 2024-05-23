#!/bin/bash
#shellcheck disable=SC2086

OLDVSN='v02.02.03'

echo -e "\nThe current iso version is $OLDVSN"
echo -e '\nEnter the new iso version'
read -rp '▸ ' NEWVSN

echo -e '\nChanging version refs in archiso files'
sed -i 's/'$OLDVSN'/'$NEWVSN'/gI' '../build_iso.sh'
sed -i 's/'$OLDVSN'/'$NEWVSN'/gI' '../tacOS/airootfs/etc/calamares/branding/tacOS/branding.desc'
sed -i 's/'$OLDVSN'/'$NEWVSN'/gI' '../tacOS/airootfs/etc/dev-rel'
sed -i 's/'$OLDVSN'/'$NEWVSN'/gI' '../tacOS/airootfs/etc/hostname'
sed -i 's/'$OLDVSN'/'$NEWVSN'/gI' '../tacOS/profiledef.sh'

echo -e "Iso version updated to $NEWVSN"
sed -i 's/'$OLDVSN'/'$NEWVSN'/gI' "$0"
unset NEWVSN OLDVSN
