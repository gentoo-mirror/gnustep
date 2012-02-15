# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit gnustep-2

DESCRIPTION="a GNUstep silver theme"
HOMEPAGE="http://wiki.gnustep.org/index.php/Themes"
# Non-versioned
SRC_URI="http://wiki.gnustep.org/images/6/6d/Silver.theme.tar.bz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S=${WORKDIR}

src_compile() { :; }

src_install() {
	egnustep_env

	#install themes
	dodir ${GNUSTEP_SYSTEM_LIBRARY}/Themes
	insinto ${GNUSTEP_SYSTEM_LIBRARY}/Themes/
	doins -r "${S}"/*theme
}

pkg_postinst() {
	elog "Use gnustep-apps/systempreferences to switch theme"
}
