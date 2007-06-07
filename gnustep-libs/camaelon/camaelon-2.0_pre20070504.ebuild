# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-libs/camaelon/camaelon-2.0_pre20060324.ebuild,v 1.1 2006/03/26 10:49:57 grobian Exp $

inherit gnustep-2

S=${WORKDIR}/${PN/c/C}

DESCRIPTION="Camaelon allows you to load theme bundles for GNUstep."

HOMEPAGE="http://www.etoile-project.org/etoile/mediawiki/index.php?title=Camaelon"
SRC_URI="http://overlays.gentoo.org/svn/proj/gnustep/downloads/${P}.tar.bz2"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~amd64"
SLOT="0"
LICENSE="LGPL-2.1"

DEPEND="${GS_DEPEND}"
RDEPEND="${GS_RDEPEND}"

src_install() {
	gnustep-2_src_install || die "install failed"

	#Link default theme
	mkdir -p ${D}${GNUSTEP_SYSTEM_LIBRARY}/Themes
	ln -s ${GNUSTEP_SYSTEM_LIBRARY}/Bundles/Camaelon.themeEngine/Resources/Nesedah.theme ${D}${GNUSTEP_SYSTEM_LIBRARY}/Themes/
}
