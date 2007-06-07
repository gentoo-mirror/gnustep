# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils gnustep-base

DESCRIPTION="Provides the tool to create .nfont packages suitable for use with gnustep-back-art."

HOMEPAGE="http://w1.423.telia.com/~u42308495/alex/backart/"
SRC_URI="http://w1.423.telia.com/~u42308495/alex/backart/${P}.tar.gz"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~amd64"
SLOT="0"
LICENSE="GPL-2"

DEPEND="gnustep-base/gnustep-gui
	>=media-libs/freetype-2.1"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/${PN}-rename.patch
}
