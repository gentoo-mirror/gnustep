# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-2

S=${WORKDIR}/OgreKit

DESCRIPTION="OniGuruma regular expression framework"
HOMEPAGE="http://www.etoile-project.org/etoile/mediawiki/index.php?title=OgreKit"
SRC_URI="http://overlays.gentoo.org/svn/proj/gnustep/downloads/${P}.tar.bz2"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"

DEPEND=">=dev-libs/oniguruma-5.7.0"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd ${S}

	sed  -i "s/^include.*etoile.make//" GNUmakefile
}

