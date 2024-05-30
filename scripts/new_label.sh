#!/bin/bash
#shellcheck disable=SC2086

OLDNAME='tacOS'

echo -e "The current iso label is $OLDNAME"
echo -e '\nEnter the new iso label\n'
read -rp '~ ' NEWNAME
echo -e '\nChanging label refs in archiso files'

mv "../$NEWNAME/airootfs/etc/$OLDNAME-rel" "../$NEWNAME/airootfs/etc/$NEWNAME-rel"
mv "../$NEWNAME/airootfs/etc/calamares/branding/$OLDNAME" "../$NEWNAME/airootfs/etc/calamares/branding/$NEWNAME"
mv "../$NEWNAME/airootfs/etc/mkinitcpio.d/$OLDNAME" "../$NEWNAME/airootfs/etc/mkinitcpio.d/$NEWNAME"
mv "../$NEWNAME/airootfs/etc/systemd/logind.conf.d/$OLDNAME-settings.conf" "../$NEWNAME/airootfs/etc/systemd/logind.conf.d/$NEWNAME-settings.conf"
mv "../$OLDNAME" "../$NEWNAME"

sed -i 's/'$OLDNAME'/'$NEWNAME'/gI' "../$NEWNAME/airootfs/etc/$NEWNAME-rel"
sed -i 's/'$OLDNAME'/'$NEWNAME'/gI' "../$NEWNAME/airootfs/etc/default/grub"
sed -i 's/'$OLDNAME'/'$NEWNAME'/gI' "../$NEWNAME/airootfs/etc/dev-rel"
sed -i 's/'$OLDNAME'/'$NEWNAME'/gI' "../$NEWNAME/airootfs/etc/hostname"
sed -i 's/'$OLDNAME'/'$NEWNAME'/gI' "../$NEWNAME/efiboot/loader/entries/01-archiso-x86_64-linux.conf"
sed -i 's/'$OLDNAME'/'$NEWNAME'/gI' "../$NEWNAME/efiboot/loader/entries/02-archiso-x86_64-linux-no-nouveau.conf"
sed -i 's/'$OLDNAME'/'$NEWNAME'/gI' "../$NEWNAME/efiboot/loader/entries/03-nvidianouveau.conf"
sed -i 's/'$OLDNAME'/'$NEWNAME'/gI' "../$NEWNAME/efiboot/loader/entries/04-nvidianonouveau.conf"
sed -i 's/'$OLDNAME'/'$NEWNAME'/gI' "../$NEWNAME/efiboot/loader/entries/05-nomodeset.conf"
sed -i 's/'$OLDNAME'/'$NEWNAME'/gI' "../$NEWNAME/grub/grub.cfg"
sed -i 's/'$OLDNAME'/'$NEWNAME'/gI' "../$NEWNAME/profiledef.sh"
sed -i 's/'$OLDNAME'/'$NEWNAME'/gI' "../$NEWNAME/syslinux/archiso_sys-linux.cfg"
sed -i 's/'$OLDNAME'/'$NEWNAME'/gI' "../tacOS/syslinux/archiso_head.cfg"
sed -i 's/'$OLDNAME'/'$NEWNAME'/gI' "../tacOS/syslinux/archiso_pxe-linux.cfg"
sed -i 's/'$OLDNAME'/'$NEWNAME'/gI' '..//tacOS/airootfs/etc/calamares/branding/tacOS/branding.desc'
sed -i 's/'$OLDNAME'/'$NEWNAME'/gI' '../build_iso.sh'
sed -i 's/'$OLDNAME'/'$NEWNAME'/gI' '../tacOS/airootfs/etc/calamares/modules/bootloader-grub.conf'
sed -i 's/'$OLDNAME'/'$NEWNAME'/gI' '../tacOS/airootfs/etc/calamares/modules/bootloader-refind.conf'
sed -i 's/'$OLDNAME'/'$NEWNAME'/gI' '../tacOS/airootfs/etc/calamares/modules/bootloader-systemd.conf'
sed -i 's/'$OLDNAME'/'$NEWNAME'/gI' '../tacOS/airootfs/etc/calamares/modules/bootloader.conf'
sed -i 's/'$OLDNAME'/'$NEWNAME'/gI' '../tacOS/airootfs/etc/calamares/modules/shellprocess-before.conf'
sed -i 's/'$OLDNAME'/'$NEWNAME'/gI' '../tacOS/airootfs/etc/calamares/modules/shellprocess-final.conf'
sed -i 's/'$OLDNAME'/'$NEWNAME'/gI' '../tacOS/airootfs/etc/calamares/modules/users.conf'
sed -i 's/'$OLDNAME'/'$NEWNAME'/gI' '../tacOS/airootfs/etc/calamares/settings.conf'
sed -i 's/'$OLDNAME'/'$NEWNAME'/gI' '../tacOS/airootfs/etc/skel/.bashrc'
sed -i 's/'$OLDNAME'/'$NEWNAME'/gI' '../tacOS/airootfs/usr/share/icons/default/index.theme'
sed -i 's/'$OLDNAME'/'$NEWNAME'/gI' 'new_version.sh'


echo -e "\nIso label updated to $NEWNAME\n"
sed -i 's/'$OLDNAME'/'$NEWNAME'/gI' "$0"

unset NEWNAME OLDNAME
