#!/bin/bash
#shellcheck disable=SC2162

WORKDIR='build'
DESKTOP='awesome'
VERSION='v02.01.01'
OUTFOLDER='iso_out'
BUILDDATE=$(date +'%H%M-%d%m-%Y')

PACKAGES=(
	'alhp-keyring'
	'alhp-mirrorlist'
	'archiso'
	'arcolinux-keyring'
	'arcolinux-mirrorlist-git'
	'chaotic-keyring'
	'chaotic-mirrorlist'
	'endeavouros-keyring'
	'endeavouros-mirrorlist'
	'pacman-contrib'
	'rebornos-keyring'
	'rebornos-mirrorlist'
	'reflector'
	'xerolinux-mirrorlist'
)

declare -A PACKAGEURLS=(
	[1]='https://archlinux.pkgs.org/rolling/chaotic-aur-x86_64/alhp-keyring-20230504-4-any.pkg.tar.zst'
	[2]='https://archlinux.pkgs.org/rolling/chaotic-aur-x86_64/alhp-mirrorlist-20230831-1-any.pkg.tar.zst'
	[3]='https://geo.mirror.pkgbuild.com/extra/os/x86_64/archiso-72-1-any.pkg.tar.zst'
	[4]='https://ant.seedhost.eu/arcolinux/arcolinux_repo/x86_64/arcolinux-keyring-20251209-3-any.pkg.tar.zst'
	[5]='https://ant.seedhost.eu/arcolinux/arcolinux_repo/x86_64/arcolinux-mirrorlist-git-23.06-01-any.pkg.tar.zst'
	[6]='https://ant.seedhost.eu/arcolinux/arcolinux_repo_3party/x86_64/chaotic-keyring-20230616-1-any.pkg.tar.zst'
	[7]='https://ant.seedhost.eu/arcolinux/arcolinux_repo_3party/x86_64/chaotic-mirrorlist-20230603-1-any.pkg.tar.zst'
	[8]='https://ant.seedhost.eu/arcolinux/arcolinux_repo_3party/x86_64/endeavouros-keyring-20230523-1-any.pkg.tar.zst'
	[9]='https://ant.seedhost.eu/arcolinux/arcolinux_repo_3party/x86_64/endeavouros-mirrorlist-23.7-1-any.pkg.tar.zst'
	[10]='https://geo.mirror.pkgbuild.com/extra/os/x86_64/pacman-contrib-1.9.0-1-x86_64.pkg.tar.zst'
	[11]='https://ant.seedhost.eu/arcolinux/arcolinux_repo_3party/x86_64/rebornos-keyring-20230606-1-any.pkg.tar.zst'
	[12]='https://ant.seedhost.eu/arcolinux/arcolinux_repo_3party/x86_64/rebornos-mirrorlist-20230606-1-any.pkg.tar.zst'
	[13]='https://geo.mirror.pkgbuild.com/extra/os/x86_64/reflector-2023-1-any.pkg.tar.zst'
	[14]='https://ant.seedhost.eu/arcolinux/arcolinux_repo_3party/x86_64/xerolinux-mirrorlist-0.1.3-3-any.pkg.tar.zst'
)

[ -d "$OUTFOLDER" ] && sudo rm -rf "$OUTFOLDER"
[ -d "$HOME/$OUTFOLDER" ] && sudo rm -rf "$HOME/$OUTFOLDER"
[ ! -d 'tacOS_latest' ] && mkdir -p 'tacOS_latest'

while true; do
	echo -e '\nSelect the ingredients for the tacOS\n'
	echo -e '▸ [N] nachOS (Nvidia)\n▸ [J] jalapenOS (Intel)\n▸ [A] asadOS (AMD)\n▸ [C] churrOS (server)\n'
	read -p '▸ ' GPUBRAND
	case "$GPUBRAND" in
	n)
		PACKAGELIST='nachOS.txt'
		LATESTISO="nachOS_${DESKTOP}_${VERSION}_x86_64"
		ISOLABEL="nachOS_${DESKTOP}_${VERSION}_x86_64.iso"
		cp "pkglists/$PACKAGELIST" "$PWD/tacOS/packages.x86_64"
		break;;
	j)
		PACKAGELIST='jalapenOS.txt'
		LATESTISO="jalapenOS_${DESKTOP}_${VERSION}_x86_64"
		ISOLABEL="jalapenOS_${DESKTOP}_${VERSION}_x86_64.iso"
		cp "pkglists/$PACKAGELIST" "$PWD/tacOS/packages.x86_64"
		break;;
	a)
		PACKAGELIST='asadOS.txt'
		LATESTISO="asadOS_${DESKTOP}_${VERSION}_x86_64"
		ISOLABEL="asadOS_${DESKTOP}_${VERSION}_x86_64.iso"
		cp "pkglists/$PACKAGELIST" "$PWD/tacOS/packages.x86_64"
		break;;
	a)
		PACKAGELIST='churrOS.txt'
		LATESTISO="churrOS_${DESKTOP}_${VERSION}_x86_64"
		ISOLABEL="churrOS_${DESKTOP}_${VERSION}_x86_64.iso"
		cp "pkglists/$PACKAGELIST" "$PWD/tacOS/packages.x86_64"
		break;;		
	*) echo -e '⚠ invalid selection ⚠';;
	esac
done

echo -e '\nMaking sure system requirements are installed'
for PACKAGE in "${PACKAGES[@]}"; do
	if ! pacman -Qs "$PACKAGE" &>'/dev/null' 2>&1; then
		echo -e "\n$PACKAGE isnt installed,\ninstalling it now"
		if ! sudo pacman -S "$PACKAGE"; then
			echo -e "\nFailed to install $PACKAGE with pacman\ninstalling it manually from repository\n"
			case "$PACKAGE" in
				'alhp-keyring')
					wget -P "$HOME/Downloads" "${PACKAGEURLS[1]}"
					sudo pacman -U "$HOME/Downloads/${PACKAGEURLS[1]##*/}";;
				'alhp-mirrorlist')
					wget -P "$HOME/Downloads" "${PACKAGEURLS[2]}"
					sudo pacman -U "$HOME/Downloads/${PACKAGEURLS[2]##*/}";;			
				'archiso')
					wget -P "$HOME/Downloads" "${PACKAGEURLS[3]}"
					sudo pacman -U "$HOME/Downloads/${PACKAGEURLS[3]##*/}";;
				'arcolinux-keyring')
					wget -P "$HOME/Downloads" "${PACKAGEURLS[4]}"
					sudo pacman -U "$HOME/Downloads/${PACKAGEURLS[4]##*/}";;
				'arcolinux-mirrorlist-git')
					wget -P "$HOME/Downloads" "${PACKAGEURLS[5]}"
					sudo pacman -U "$HOME/Downloads/${PACKAGEURLS[5]##*/}";;
				'chaotic-keyring')
					wget -P "$HOME/Downloads" "${PACKAGEURLS[6]}"
					sudo pacman -U "$HOME/Downloads/${PACKAGEURLS[6]##*/}";;
				'chaotic-mirrorlist')
					wget -P "$HOME/Downloads" "${PACKAGEURLS[7]}"
					sudo pacman -U "$HOME/Downloads/${PACKAGEURLS[7]##*/}";;
				'endeavouros-keyring')
					wget -P "$HOME/Downloads" "${PACKAGEURLS[8]}"
					sudo pacman -U "$HOME/Downloads/${PACKAGEURLS[8]##*/}";;
				'endeavouros-mirrorlist')
					wget -P "$HOME/Downloads" "${PACKAGEURLS[9]}"
					sudo pacman -U "$HOME/Downloads/${PACKAGEURLS[9]##*/}";;
				'pacman-contrib')
					wget -P "$HOME/Downloads" "${PACKAGEURLS[10]}"
					sudo pacman -U "$HOME/Downloads/${PACKAGEURLS[10]##*/}";;
				'rebornos-keyring')
					wget -P "$HOME/Downloads" "${PACKAGEURLS[11]}"
					sudo pacman -U "$HOME/Downloads/${PACKAGEURLS[11]##*/}";;
				'rebornos-mirrorlist')
					wget -P "$HOME/Downloads" "${PACKAGEURLS[12]}"
					sudo pacman -U "$HOME/Downloads/${PACKAGEURLS[12]##*/}";;
				'reflector')
					wget -P "$HOME/Downloads" "${PACKAGEURLS[13]}"
					sudo pacman -U "$HOME/Downloads/${PACKAGEURLS[13]##*/}";;
				'xerolinux-mirrorlist')
					wget -P "$HOME/Downloads" "${PACKAGEURLS[14]}"
					sudo pacman -U "$HOME/Downloads/${PACKAGEURLS[14]##*/}";;
			esac
		fi
	fi
done

if ! diff -q 'tacOS/pacman.conf' '/etc/pacman.conf'; then
	echo -e '\nCopy over new pacman.conf to /etc (y/n)\n'
	read -p '▸ ' ANS
	[ "$ANS" == 'y' ] && sudo cp 'tacOS/pacman.conf' '/etc'
fi
echo -e '\nUpdating pacman mirrors and keyrings\n'
sudo pacman-key --init; sudo pacman-key --populate
sudo reflector --age 6 --latest 20 --sort score --protocol https --save '/etc/pacman.d/mirrorlist'
sudo pacman -Fy; sudo pacman -Syu
echo -e "\nAdding build date ($BUILDDATE) to /etc/dev-rel\n"
sed -i "s/\(^ISO_BUILD=\).*/\1$BUILDDATE/" 'tacOS/airootfs/etc/dev-rel'

echo -e "Building iso from archiso template\nwith packages listed in $PACKAGELIST\n"
sudo mkarchiso -v -w "$WORKDIR" -o "$OUTFOLDER" "$PWD/tacOS/"
cd "$OUTFOLDER" || exit 1
sudo mv 'tacOS-'*'-x86_64.iso' "$ISOLABEL"
echo -e "\nCreating checksums for $ISOLABEL\n"
md5sum "$ISOLABEL" | sudo tee "$ISOLABEL.md5"
sha1sum "$ISOLABEL" | sudo tee "$ISOLABEL.sha1"
sha256sum "$ISOLABEL" | sudo tee "$ISOLABEL.sha256"
cd - || exit 1

sudo chown "$USER":"$USER" "$OUTFOLDER"
sudo find "$OUTFOLDER" -type f -exec chown "$USER":"$USER" {} \;
test -f "$HOME/$OUTFOLDER/$ISOLABEL" && sudo rm -rf "$HOME/$OUTFOLDER/$ISOLABEL"
cp -r "$OUTFOLDER" "$HOME/"
mv "$OUTFOLDER" "$LATESTISO"
tar zcvf "$LATESTISO.tar.gz" "$LATESTISO"
test -f "tacOS_latest/$LATESTISO.tar.gz" &&
	sudo rm -rf "$HOME/tacOS_latest/$LATESTISO.tar.gz"
mv "$LATESTISO.tar.gz" 'tacOS_latest'
echo -e "\nFresh iso in $HOME/$OUTFOLDER\n"
sudo rm -rf "$LATESTISO"
sudo rm -rf "$WORKDIR"
unset ANS BUILDDATE DESKTOP GPUBRAND ISOLABEL LATEST LATESTISO OUTFOLDER PACKAGELIST PACKAGES PACKAGEURLS WORKDIR
