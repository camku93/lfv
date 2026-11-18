#!/bin/sh
# Installs lfv and the programs it uses for previews.
#   ./install.sh              install everything, or pick preview groups
#   ./install.sh --yes        install everything without asking
#   ./install.sh --uninstall  remove lfv (installed packages are kept)

set -u

PREFIX=${PREFIX:-/usr/local}

say()  { printf '\n\033[1;35m==> %s\033[0m\n' "$*"; }
warn() { printf '\033[1;33m!! %s\033[0m\n' "$*" >&2; }
die()  { printf '\033[1;31mxx %s\033[0m\n' "$*" >&2; exit 1; }
have() { command -v "$1" >/dev/null 2>&1; }

cd "$(dirname "$0")" || die "Cannot enter the lfv folder."
[ "$(id -u)" -ne 0 ] || die "Run this as your normal user. It uses sudo when it needs to."
have sudo || die "sudo is not installed."

if [ "${1:-}" = --uninstall ]; then
	sudo rm -f "$PREFIX/bin/lfv"
	sudo rm -rf "$PREFIX/share/lfv"
	say "lfv removed. Packages it installed were kept."
	exit 0
fi

if have pacman; then
	pm=pacman
elif have apt-get; then
	pm=apt
else
	warn "This script supports Arch-based and Debian/Ubuntu-based systems."
	if have dnf; then
		warn "On Fedora, lf and ueberzug come from COPR repositories."
	fi
	warn "See \"Manual install\" in README.md for the list of programs."
	exit 1
fi

# group number | description | Arch packages | Debian/Ubuntu packages
groups='1|Syntax highlighting for text and code|bat|bat
2|Music info and album art|ffmpeg|ffmpeg
3|Video thumbnails|ffmpegthumbnailer|ffmpegthumbnailer
4|PDF and DjVu pages|poppler djvulibre|poppler-utils djvulibre-bin
5|SVG, fonts, HEIC/AVIF photos|librsvg imagemagick|librsvg2-bin imagemagick
6|Archives, comics, EPUB, office documents|libarchive catdoc antiword binutils|libarchive-tools catdoc antiword binutils
7|Web pages and Markdown|lynx glow|lynx glow
8|Torrents|transmission-cli|transmission-cli
9|Images without X11 (Wayland, SSH)|chafa|chafa'

column=3
[ "$pm" = apt ] && column=4

all() { printf '%s\n' "$groups" | cut -d'|' -f"$column" | tr '\n' ' '; }

core="file"
have lf || core="$core lf"
have ueberzug || core="$core ueberzug"

if [ "${1:-}" = --yes ]; then
	extra=$(all)
else
	printf 'lfv needs lf and ueberzug. The other programs add previews for more file types.\n'
	printf 'Install everything (recommended)? [Y/n] '
	answer=
	read -r answer
	case $answer in
	[Nn]*)
		printf '\n'
		printf '%s\n' "$groups" | awk -F'|' '{ printf "  %s) %-42s (%s)\n", $1, $2, $'"$column"' }'
		printf '\nNumbers to install (for example: 1 2 4), or Enter for none: '
		picks=
		read -r picks
		extra=
		for n in $picks; do
			case $n in
			[1-9]) extra="$extra $(printf '%s\n' "$groups" | awk -F'|' -v n="$n" '$1 == n { print $'"$column"' }')" ;;
			*) warn "Ignoring \"$n\"." ;;
			esac
		done
		;;
	*) extra=$(all) ;;
	esac
fi

available() {
	case $pm in
	pacman) pacman -Si "$1" >/dev/null 2>&1 ;;
	apt) apt-cache show "$1" 2>/dev/null | grep -q '^Package:' ;;
	esac
}

install_pkgs() {
	case $pm in
	pacman) sudo pacman -S --needed --noconfirm "$@" ;;
	apt) sudo apt-get install -y "$@" ;;
	esac
}

if [ "$pm" = apt ]; then
	say "Updating the package lists"
	sudo apt-get update || warn "Could not update the package lists, continuing."
fi

say "Checking packages"
found=
missing=
for p in $core $extra; do
	if available "$p"; then
		found="$found $p"
	else
		missing="$missing $p"
	fi
done

if [ -n "$found" ]; then
	say "Installing packages"
	# shellcheck disable=SC2086
	if ! install_pkgs $found; then
		warn "Installing everything at once failed, trying one at a time."
		for p in $found; do
			install_pkgs "$p" || missing="$missing $p"
		done
	fi
fi

have lf || die "lf could not be installed, so lfv cannot work. Install lf, then run this again."

say "Installing lfv to $PREFIX"
if ! { sudo install -Dm755 lfv "$PREFIX/bin/lfv" &&
	sudo install -Dm755 previewer "$PREFIX/share/lfv/previewer" &&
	sudo install -Dm755 cleaner "$PREFIX/share/lfv/cleaner"; }; then
	die "Could not install lfv."
fi

say "Done. Run lfv to start lf with previews."
if [ -n "$missing" ]; then
	warn "Could not be installed (those file types fall back to text previews):"
	for p in $missing; do printf '   %s\n' "$p" >&2; done
fi
if ! have ueberzug; then
	warn "ueberzug is missing, so images show as text or through chafa."
elif [ -n "${WAYLAND_DISPLAY:-}" ]; then
	warn "You are on Wayland. ueberzug needs X11, so images show through chafa here."
fi
