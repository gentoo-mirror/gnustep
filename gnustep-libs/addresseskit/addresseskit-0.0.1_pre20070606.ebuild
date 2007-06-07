# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-libs/popplerkit/popplerkit-0.0.0.20050720.ebuild,v 1.2 2005/08/25 19:03:49 swegener Exp $

inherit gnustep-2

S=${WORKDIR}/AddressesKit

DESCRIPTION="system wide contacts support framework"
HOMEPAGE="http://www.etoile-project.org/etoile/mediawiki/index.php?title=Frameworks_Suite"
SRC_URI="http://overlays.gentoo.org/svn/proj/gnustep/downloads/${P}.tar.bz2"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"

DEPEND="${GS_DEPEND}
	!gnustep-apps/addresses"
RDEPEND="${GS_RDEPEND}"

src_unpack() {
	unpack ${A}
	cd ${S}

	sed  -i "s/^include.*etoile.make//" \
		Frameworks/AddressView/GNUmakefile Frameworks/Addresses/GNUmakefile
}

