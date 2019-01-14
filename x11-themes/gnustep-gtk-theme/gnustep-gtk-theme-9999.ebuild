# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit git-r3 gnustep-2

DESCRIPTION="a GNUstep theme engine using current Gtk+ theme"
HOMEPAGE="https://github.com/gnustep/plugins-themes-Gtk"
SRC_URI=""
EGIT_REPO_URI="https://github.com/gnustep/plugins-themes-Gtk.git"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="gnome-base/gconf
	x11-libs/gtk+:2"
DEPEND="virtual/pkgconfig
	${RDEPEND}"

pkg_postinst() {
	elog "Use gnustep-apps/systempreferences to switch theme"
}
