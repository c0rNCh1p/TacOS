#!/bin/bash
#shellcheck disable=SC2086

OLDVSN='v02.01.01'

echo -e "\nThe current iso version is $OLDVSN"
echo -e '\nEnter the new iso version\n'
read -rp '▸ ' NEWVSN

echo -e '\nChanging version refs in archiso files\n'
sed -i 's/'$OLDVSN'/'$NEWVSN'/gI' '../build_iso.sh'
sed -i 's/'$OLDVSN'/'$NEWVSN'/gI' '../tacOS/profiledef.sh'
sed -i 's/'$OLDVSN'/'$NEWVSN'/gI' '../tacOS/airootfs/etc/dev-rel'
sed -i 's/'$OLDVSN'/'$NEWVSN'/gI' '../tacOS/airootfs/etc/hostname'
sed -i 's/'$OLDVSN'/'$NEWVSN'/gI' '../tacOS/syslinux/archiso_sys-linux.cfg'
sed -i 's/'$OLDVSN'/'$NEWVSN'/gI' '../tacOS/efiboot/loader/entries/01-archiso-x86_64-linux.conf'
sed -i 's/'$OLDVSN'/'$NEWVSN'/gI' '../tacOS/efiboot/loader/entries/02-archiso-x86_64-linux-no-nouveau.conf'
sed -i 's/'$OLDVSN'/'$NEWVSN'/gI' '../tacOS/efiboot/loader/entries/03-nvidianouveau.conf'
sed -i 's/'$OLDVSN'/'$NEWVSN'/gI' '../tacOS/efiboot/loader/entries/04-nvidianonouveau.conf'
sed -i 's/'$OLDVSN'/'$NEWVSN'/gI' '../tacOS/efiboot/loader/entries/05-nomodeset.conf'

echo -e "Iso version updated to $NEWVSN"
sed -i 's/'$OLDVSN'/'$NEWVSN'/gI' "$0"
unset NEWVSN OLDVSN
