# lfv

The previewer for [lf](https://github.com/gokcehan/lf) that ships with [Navi](https://navi-desktop.org). lfv displays file previews (such as images, PDFs, etc.) for lf, inspired by [lfimg](https://github.com/thimc/lfimg)'s approach.

## Install

```
git clone https://github.com/camku93/lfv
cd lfv
./install.sh
```

The installer works on [Arch Linux](https://archlinux.org), [Debian](https://www.debian.org), [Ubuntu](https://ubuntu.com) and their derivatives. It installs [lf](https://github.com/gokcehan/lf), [ueberzug](https://github.com/seebye/ueberzug) and every dependency lfv uses for previews.

## Manual install

On other systems, or if you prefer to install packages yourself, install [lf](https://github.com/gokcehan/lf) and [ueberzug](https://github.com/seebye/ueberzug), then any of these:

| Program | Arch package | Debian/Ubuntu package | Used for |
|---|---|---|---|
| [bat](https://github.com/sharkdp/bat) | bat | bat | syntax highlighting |
| [ffmpeg](https://ffmpeg.org) | ffmpeg | ffmpeg | music info and album art |
| [ffmpegthumbnailer](https://github.com/dirkvdb/ffmpegthumbnailer) | ffmpegthumbnailer | ffmpegthumbnailer | video frames |
| pdftoppm ([Poppler](https://poppler.freedesktop.org)) | poppler | poppler-utils | PDF pages |
| ddjvu ([DjVuLibre](https://djvu.sourceforge.net)) | djvulibre | djvulibre-bin | DjVu pages |
| rsvg-convert ([librsvg](https://gitlab.gnome.org/GNOME/librsvg)) | librsvg | librsvg2-bin | SVG |
| [ImageMagick](https://imagemagick.org) | imagemagick | imagemagick | fonts, HEIC, AVIF, JPEG XL |
| bsdtar ([libarchive](https://www.libarchive.org)) | libarchive | libarchive-tools | archives, comics, EPUB, office documents |
| [catdoc](https://packages.debian.org/stable/catdoc), [antiword](https://packages.debian.org/stable/antiword) | catdoc, antiword | catdoc, antiword | old Word .doc and Excel .xls |
| nm ([GNU Binutils](https://www.gnu.org/software/binutils/)) | binutils | binutils | object files |
| [lynx](https://lynx.invisible-island.net) | lynx | lynx | HTML |
| [glow](https://github.com/charmbracelet/glow) | glow | glow | Markdown |
| transmission-show ([Transmission](https://transmissionbt.com)) | transmission-cli | transmission-cli | torrents |
| [chafa](https://hpjansson.org/chafa/) | chafa | chafa | images without X11 |

Then install lfv itself:

```
sudo make install
```

This puts lfv in `/usr/local/bin` and the previewer in `/usr/local/share/lfv`. To uninstall: `sudo make uninstall`.
