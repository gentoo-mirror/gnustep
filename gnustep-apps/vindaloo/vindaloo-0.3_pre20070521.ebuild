# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-2

S=${WORKDIR}/${PN/v/V}

DESCRIPTION="An Application for displaying and navigating in PDF documents."

HOMEPAGE="http://www.etoile-project.org/etoile/mediawiki/index.php?title=Applications"
SRC_URI="http://overlays.gentoo.org/svn/proj/gnustep/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~ppc ~x86 ~amd64"
SLOT="0"

DEPEND="${GS_DEPEND}
	gnustep-libs/popplerkit
	gnustep-libs/iconkit"
RDEPEND="${GS_RDEPEND}"

src_unpack() {
	unpack ${A}
	cd ${S}

	sed  -i "s/^include.*etoile.make//" GNUmakefile
}
