# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit gnustep-2 subversion

DESCRIPTION="a GNUstep theme engine using current Gtk+ theme"
HOMEPAGE="http://svn.gna.org/viewcvs/gnustep/plugins/themes/Gtk/"
SRC_URI=""
ESVN_REPO_URI="svn://svn.gna.org/svn/gnustep/plugins/themes/Gtk"

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
