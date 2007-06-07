# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-apps/talksoup/talksoup-1.0_alpha1.ebuild,v 1.1 2006/06/25 14:16:27 grobian Exp $

inherit gnustep-2

MY_P="TalkSoup-1.0alpha"
S=${WORKDIR}/${MY_P}

DESCRIPTION="IRC client for GNUstep"
HOMEPAGE="http://talksoup.aeruder.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-1"

DEPEND="${GS_DEPEND}
	>=gnustep-libs/netclasses-1.05"
RDEPEND="${GS_RDEPEND}
	>=gnustep-libs/netclasses-1.05"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-make2_support.patch
}
