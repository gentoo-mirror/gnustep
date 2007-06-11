# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-2

S=${WORKDIR}/${PN/c/C}

DESCRIPTION="Camaelon allows you to load theme bundles for GNUstep."

HOMEPAGE="http://www.etoile-project.org/etoile/mediawiki/index.php?title=Camaelon"
SRC_URI="http://overlays.gentoo.org/svn/proj/gnustep/downloads/${P}.tar.bz2"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~amd64"
SLOT="0"
LICENSE="LGPL-2.1"

src_install() {
	egnustep_env
	egnustep_install

	#Link default theme
	mkdir -p ${D}${GNUSTEP_SYSTEM_LIBRARY}/Themes
	ln -s ${GNUSTEP_SYSTEM_LIBRARY}/Bundles/Camaelon.themeEngine/Resources/Nesedah.theme ${D}${GNUSTEP_SYSTEM_LIBRARY}/Themes/
}
