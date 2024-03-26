#!/bin/bash
#shellcheck disable=SC2162

WORKDIR='build'
DESKTOP='awesome'
VERSION='v02.01.02'
OUTFOLDER='iso_out'
BUILDDATE=$(date +'%H%M-%d%m-%Y')

PACKAGES=(
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
	'wget'
	'xerolinux-mirrorlist'
)

declare -A PACKAGEURLS=(
	[1]='https://geo.mirror.pkgbuild.com/extra/os/x86_64/archiso-75-1-any.pkg.tar.zst'
	[2]='https://ant.seedhost.eu/arcolinux/arcolinux_repo/x86_64/arcolinux-keyring-20251209-3-any.pkg.tar.zst'
	[3]='https://ant.seedhost.eu/arcolinux/arcolinux_repo/x86_64/arcolinux-mirrorlist-git-24.03-12-any.pkg.tar.zst'
	[4]='https://ant.seedhost.eu/arcolinux/arcolinux_repo_3party/x86_64/chaotic-keyring-20230616-1-any.pkg.tar.zst'
	[5]='https://ant.seedhost.eu/arcolinux/arcolinux_repo_3party/x86_64/chaotic-mirrorlist-20240306-1-any.pkg.tar.zst'
	[6]='https://ant.seedhost.eu/arcolinux/arcolinux_repo_3party/x86_64/endeavouros-keyring-20231222-1-any.pkg.tar.zst'
	[7]='https://ant.seedhost.eu/arcolinux/arcolinux_repo_3party/x86_64/endeavouros-mirrorlist-24.2-1-any.pkg.tar.zst'
	[8]='https://geo.mirror.pkgbuild.com/extra/os/x86_64/pacman-contrib-1.10.5-1-x86_64.pkg.tar.zst'
	[9]='https://ant.seedhost.eu/arcolinux/arcolinux_repo_3party/x86_64/rebornos-keyring-20231128-1-any.pkg.tar.zst'
	[10]='https://ant.seedhost.eu/arcolinux/arcolinux_repo_3party/x86_64/rebornos-mirrorlist-20240215-1-any.pkg.tar.zst'
	[11]='https://geo.mirror.pkgbuild.com/extra/os/x86_64/reflector-2023-1-any.pkg.tar.zst'
	[12]='https://geo.mirror.pkgbuild.com/extra/os/x86_64/wget-1.24.5-1-x86_64.pkg.tar.zst'
)

[ -d "$OUTFOLDER" ] && sudo rm -rf "$OUTFOLDER"
[ -d "$HOME/$OUTFOLDER" ] && sudo rm -rf "$HOME/$OUTFOLDER"
[ ! -d 'tacOS_latest' ] && mkdir -p 'tacOS_latest'
[ ! -d "$HOME/Downloads" ] && mkdir -p "$HOME/Downloads"

while true; do
	echo -e '\nSelect the ingredients for the tacOS\n'
	echo -e '▸ [N] nachOS (Nvidia)\n▸ [J] jalapenOS (Intel)\n▸ [A] asadOS (AMD)\n▸ [C] churrOS (server)\n'
	read -p '▸ ' GPUBRAND
	case "$GPUBRAND" in
	[n|N])
		PACKAGELIST='nachOS.txt'
		LATESTISO="nachOS_${DESKTOP}_${VERSION}_x86_64"
		ISOLABEL="nachOS_${DESKTOP}_${VERSION}_x86_64.iso"
		cp "pkglists/$PACKAGELIST" "$PWD/tacOS/packages.x86_64"
		break;;
	[j|J])
		PACKAGELIST='jalapenOS.txt'
		LATESTISO="jalapenOS_${DESKTOP}_${VERSION}_x86_64"
		ISOLABEL="jalapenOS_${DESKTOP}_${VERSION}_x86_64.iso"
		cp "pkglists/$PACKAGELIST" "$PWD/tacOS/packages.x86_64"
		break;;
	[a|A])
		PACKAGELIST='asadOS.txt'
		LATESTISO="asadOS_${DESKTOP}_${VERSION}_x86_64"
		ISOLABEL="asadOS_${DESKTOP}_${VERSION}_x86_64.iso"
		cp "pkglists/$PACKAGELIST" "$PWD/tacOS/packages.x86_64"
		break;;
	[c|C])
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
				'archiso')
					wget -c -P "$HOME/Downloads" "${PACKAGEURLS[1]}"
					sudo pacman -U "$HOME/Downloads/${PACKAGEURLS[1]##*/}";;
				'arcolinux-keyring')
					wget -c -P "$HOME/Downloads" "${PACKAGEURLS[2]}"
					sudo pacman -U "$HOME/Downloads/${PACKAGEURLS[2]##*/}";;
				'arcolinux-mirrorlist-git')
					wget -c -P "$HOME/Downloads" "${PACKAGEURLS[3]}"
					sudo pacman -U "$HOME/Downloads/${PACKAGEURLS[3]##*/}";;
				'chaotic-keyring')
					wget -c -P "$HOME/Downloads" "${PACKAGEURLS[4]}"
					sudo pacman -U "$HOME/Downloads/${PACKAGEURLS[4]##*/}";;
				'chaotic-mirrorlist')
					wget -c -P "$HOME/Downloads" "${PACKAGEURLS[5]}"
					sudo pacman -U "$HOME/Downloads/${PACKAGEURLS[5]##*/}";;
				'endeavouros-keyring')
					wget -c -P "$HOME/Downloads" "${PACKAGEURLS[6]}"
					sudo pacman -U "$HOME/Downloads/${PACKAGEURLS[6]##*/}";;
				'endeavouros-mirrorlist')
					wget -c -P "$HOME/Downloads" "${PACKAGEURLS[7]}"
					sudo pacman -U "$HOME/Downloads/${PACKAGEURLS[7]##*/}";;
				'pacman-contrib')
					wget -c -P "$HOME/Downloads" "${PACKAGEURLS[8]}"
					sudo pacman -U "$HOME/Downloads/${PACKAGEURLS[8]##*/}";;
				'rebornos-keyring')
					wget -c -P "$HOME/Downloads" "${PACKAGEURLS[9]}"
					sudo pacman -U "$HOME/Downloads/${PACKAGEURLS[9]##*/}";;
				'rebornos-mirrorlist')
					wget -c -P "$HOME/Downloads" "${PACKAGEURLS[10]}"
					sudo pacman -U "$HOME/Downloads/${PACKAGEURLS[10]##*/}";;
				'reflector')
					wget -c -P "$HOME/Downloads" "${PACKAGEURLS[11]}"
					sudo pacman -U "$HOME/Downloads/${PACKAGEURLS[11]##*/}";;
				'wget')
					wget -c -P "$HOME/Downloads" "${PACKAGEURLS[12]}"
					sudo pacman -U "$HOME/Downloads/${PACKAGEURLS[12]##*/}";;					
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
sudo pacman-key --init
sudo pacman-key --populate archlinux
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
