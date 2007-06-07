# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-2

S=${WORKDIR}/PopplerKit

DESCRIPTION="PopplerKit is a GNUstep/Cocoa framework for accessing and rendering PDF content."
HOMEPAGE="http://www.etoile-project.org/etoile/mediawiki/index.php?title=Frameworks_Suite"
SRC_URI="http://overlays.gentoo.org/svn/proj/gnustep/downloads/${P}.tar.bz2"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"

DEPEND=">=app-text/poppler-0.4
	>=media-libs/freetype-2"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd ${S}

	sed  -i "s/^include.*etoile.make//" GNUmakefile
}

