#!/bin/bash
#shellcheck disable=SC2162

WORKDIR='build'
DESKTOP='awesome'
VERSION='v02.01.03'
OUTFOLDER='iso_out'
BUILDDATE=$(date +'%H%M-%d%m-%Y')

declare -A PACKAGEURLS=(
	['archiso']='https://geo.mirror.pkgbuild.com/extra/os/x86_64/archiso-75-1-any.pkg.tar.zst'
	['arcolinux-keyring']='https://ant.seedhost.eu/arcolinux/arcolinux_repo/x86_64/arcolinux-keyring-20251209-3-any.pkg.tar.zst'
	['arcolinux-mirrorlist-git']='https://ant.seedhost.eu/arcolinux/arcolinux_repo/x86_64/arcolinux-mirrorlist-git-24.03-12-any.pkg.tar.zst'
	['chaotic-keyring']='https://ant.seedhost.eu/arcolinux/arcolinux_repo_3party/x86_64/chaotic-keyring-20230616-1-any.pkg.tar.zst'
	['chaotic-mirrorlist']='https://ant.seedhost.eu/arcolinux/arcolinux_repo_3party/x86_64/chaotic-mirrorlist-20240306-1-any.pkg.tar.zst'
	['endeavouros-keyring']='https://ant.seedhost.eu/arcolinux/arcolinux_repo_3party/x86_64/endeavouros-keyring-20231222-1-any.pkg.tar.zst'
	['endeavouros-mirrorlist']='https://ant.seedhost.eu/arcolinux/arcolinux_repo_3party/x86_64/endeavouros-mirrorlist-24.2-1-any.pkg.tar.zst'
	['pacman-contrib']='https://geo.mirror.pkgbuild.com/extra/os/x86_64/pacman-contrib-1.10.5-1-x86_64.pkg.tar.zst'
	['rebornos-keyring']='https://ant.seedhost.eu/arcolinux/arcolinux_repo_3party/x86_64/rebornos-keyring-20231128-1-any.pkg.tar.zst'
	['rebornos-mirrorlist']='https://ant.seedhost.eu/arcolinux/arcolinux_repo_3party/x86_64/rebornos-mirrorlist-20240215-1-any.pkg.tar.zst'
	['reflector']='https://geo.mirror.pkgbuild.com/extra/os/x86_64/reflector-2023-1-any.pkg.tar.zst'
)

cleanup_failure(){
	echo -e '\nAn error occurred, cleaning up build directories.'
	sudo rm -rf "$WORKDIR" 'tacOS_latest'
	echo -e '\nPlease check the package lists and configuration before retrying.'
	exit 1
}

cleanup_success(){
	sudo rm -rf "$LATESTISO" "$WORKDIR"
	echo -e "\nFresh iso in $HOME/$OUTFOLDER\n"
}

[ -d "$OUTFOLDER" ] && sudo rm -rf "$OUTFOLDER"
[ -d "$HOME/$OUTFOLDER" ] && sudo rm -rf "$HOME/$OUTFOLDER"
[ ! -d 'tacOS_latest' ] && mkdir -p 'tacOS_latest'
[ ! -d "$HOME/Downloads" ] && mkdir -p "$HOME/Downloads"

while true; do
	echo -e '\nSelect the ingredients for the TacOS\n'
	echo -e '▸ [N] NachOS (Nvidia)\n▸ [J] JalapenOS (Intel)\n▸ [A] AsadOS (AMD)\n▸ [C] ChurrOS (Server)\n'
	read -p '▸ ' GPUBRAND
	case "$GPUBRAND" in
		n|N)
			PACKAGELIST='nachOS.txt'
			LATESTISO="nachOS_${DESKTOP}_${VERSION}_x86_64"
			ISOLABEL="nachOS_${DESKTOP}_${VERSION}_x86_64.iso"
			cp "pkglists/$PACKAGELIST" "$PWD/tacOS/packages.x86_64"
			break;;
		j|J)
			PACKAGELIST='jalapenOS.txt'
			LATESTISO="jalapenOS_${DESKTOP}_${VERSION}_x86_64"
			ISOLABEL="jalapenOS_${DESKTOP}_${VERSION}_x86_64.iso"
			cp "pkglists/$PACKAGELIST" "$PWD/tacOS/packages.x86_64"
			break;;
		a|A)
			PACKAGELIST='asadOS.txt'
			LATESTISO="asadOS_${DESKTOP}_${VERSION}_x86_64"
			ISOLABEL="asadOS_${DESKTOP}_${VERSION}_x86_64.iso"
			cp "pkglists/$PACKAGELIST" "$PWD/tacOS/packages.x86_64"
			break;;
		c|C)
			PACKAGELIST='churrOS.txt'
			LATESTISO="churrOS_${DESKTOP}_${VERSION}_x86_64"
			ISOLABEL="churrOS_${DESKTOP}_${VERSION}_x86_64.iso"
			cp "pkglists/$PACKAGELIST" "$PWD/tacOS/packages.x86_64"
			break;;
		*) echo -e '⚠ invalid selection ⚠';;
	esac
done

if command -v curl &>'/dev/null'; then
	DLCMD=('curl' '-L' '-o')
elif command -v wget &>'/dev/null'; then
	DLCMD=('wget' '-c' '-O')
else
	echo -e 'Neither wget nor curl is installed. Please install one to continue.'
	exit 1
fi

echo -e '\nMaking sure system requirements are installed'
for PACKAGE in "${!PACKAGEURLS[@]}"; do
	if ! pacman -Qs "$PACKAGE" &>'/dev/null' 2>&1; then
		echo -e "\n$PACKAGE isnt installed,\ninstalling it now"
		if ! sudo pacman -S "$PACKAGE"; then
			echo -e "\nFailed to install $PACKAGE with pacman\ninstalling it manually from repository\n"
			case "$PACKAGE" in
				'archiso')
					"${DLCMD[@]}" "$HOME/Downloads/${PACKAGEURLS['archiso']##*/}" "${PACKAGEURLS['archiso']}"
					sudo pacman -U "$HOME/Downloads/${PACKAGEURLS['archiso']##*/}";;
				'arcolinux-keyring')
					"${DLCMD[@]}" "$HOME/Downloads/${PACKAGEURLS['arcolinux-keyring']##*/}" "${PACKAGEURLS['arcolinux-keyring']}"
					sudo pacman -U "$HOME/Downloads/${PACKAGEURLS['arcolinux-keyring']##*/}";;
				'arcolinux-mirrorlist-git')
					"${DLCMD[@]}" "$HOME/Downloads/${PACKAGEURLS['arcolinux-mirrorlist-git']##*/}" "${PACKAGEURLS['arcolinux-mirrorlist-git']}"
					sudo pacman -U "$HOME/Downloads/${PACKAGEURLS['arcolinux-mirrorlist-git']##*/}";;
				'chaotic-keyring')
					"${DLCMD[@]}" "$HOME/Downloads/${PACKAGEURLS['chaotic-keyring']##*/}" "${PACKAGEURLS['chaotic-keyring']}"
					sudo pacman -U "$HOME/Downloads/${PACKAGEURLS['chaotic-keyring']##*/}";;
				'chaotic-mirrorlist')
					"${DLCMD[@]}" "$HOME/Downloads/${PACKAGEURLS['chaotic-mirrorlist']##*/}" "${PACKAGEURLS['chaotic-mirrorlist']}"
					sudo pacman -U "$HOME/Downloads/${PACKAGEURLS['chaotic-mirrorlist']##*/}";;
				'endeavouros-keyring')
					"${DLCMD[@]}" "$HOME/Downloads/${PACKAGEURLS['endeavouros-keyring']##*/}" "${PACKAGEURLS['endeavouros-keyring']}"
					sudo pacman -U "$HOME/Downloads/${PACKAGEURLS['endeavouros-keyring']##*/}";;
				'endeavouros-mirrorlist')
					"${DLCMD[@]}" "$HOME/Downloads/${PACKAGEURLS['endeavouros-mirrorlist']##*/}" "${PACKAGEURLS['endeavouros-mirrorlist']}"
					sudo pacman -U "$HOME/Downloads/${PACKAGEURLS['endeavouros-mirrorlist']##*/}";;
				'pacman-contrib')
					"${DLCMD[@]}" "$HOME/Downloads/${PACKAGEURLS['pacman-contrib']##*/}" "${PACKAGEURLS['pacman-contrib']}"
					sudo pacman -U "$HOME/Downloads/${PACKAGEURLS['pacman-contrib']##*/}";;
				'rebornos-keyring')
					"${DLCMD[@]}" "$HOME/Downloads/${PACKAGEURLS['rebornos-keyring']##*/}" "${PACKAGEURLS['rebornos-keyring']}"
					sudo pacman -U "$HOME/Downloads/${PACKAGEURLS['rebornos-keyring']##*/}";;
				'rebornos-mirrorlist')
					"${DLCMD[@]}" "$HOME/Downloads/${PACKAGEURLS['rebornos-mirrorlist']##*/}" "${PACKAGEURLS['rebornos-mirrorlist']}"
					sudo pacman -U "$HOME/Downloads/${PACKAGEURLS['rebornos-mirrorlist']##*/}";;
				'reflector')
					"${DLCMD[@]}" "$HOME/Downloads/${PACKAGEURLS['reflector']##*/}" "${PACKAGEURLS['reflector']}"
					sudo pacman -U "$HOME/Downloads/${PACKAGEURLS['reflector']##*/}";;
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

echo "Building iso from archiso template with packages listed in $PACKAGELIST"
sudo mkarchiso -v -w "$WORKDIR" -o "$OUTFOLDER" "$PWD/tacOS/" || cleanup_failure

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
cleanup_success

unset ANS BUILDDATE DESKTOP DLCMD GPUBRAND ISOLABEL LATEST LATESTISO OUTFOLDER PACKAGELIST PACKAGEURLS WORKDIR
