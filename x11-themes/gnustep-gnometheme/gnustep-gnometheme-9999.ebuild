# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit gnustep-2 subversion

DESCRIPTION="a GNUstep theme engine using current Gtk+ theme"
HOMEPAGE="http://svn.gna.org/viewcvs/gnustep/plugins/themes/GnomeTheme/"
SRC_URI=""
ESVN_REPO_URI="svn://svn.gna.org/svn/gnustep/plugins/themes/GnomeTheme"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

pkg_postinst() {
	elog "As of now, SystemPreferences crashes on GnomeTheme,"
	elog "but setting the theme like this works:"
	elog "# defaults write NSGlobalDomain GSTheme GnomeTheme"
}
