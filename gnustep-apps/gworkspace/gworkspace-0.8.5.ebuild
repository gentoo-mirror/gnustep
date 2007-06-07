# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-apps/gworkspace/gworkspace-0.8.3.ebuild,v 1.2 2007/01/05 07:07:47 flameeyes Exp $

inherit autotools gnustep-2

S=${WORKDIR}/${P/gw/GW}

DESCRIPTION="A workspace manager for GNUstep"
HOMEPAGE="http://www.gnustep.it/enrico/gworkspace/"
SRC_URI="http://www.gnustep.it/enrico/gworkspace/${P}.tar.gz"

KEYWORDS="~amd64 ~ppc ~x86"
LICENSE="GPL-2"
SLOT="0"

IUSE="pdf"
DEPEND="${GS_DEPEND}
	pdf? ( >=gnustep-libs/popplerkit-0.0.1_pre )
	gnustep-apps/systempreferences
	>=dev-db/sqlite-3.2.8"
RDEPEND="${GS_RDEPEND}
	!gnustep-apps/desktop
	!gnustep-apps/recycler"

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/${P}-rpath.patch
	epatch ${FILESDIR}/${P}-popplerkit.patch

	cd Inspector
	eautoreconf || die "failed running autoreconf"
}

src_compile() {
	egnustep_env
	econf --with-inotify
	egnustep_make

	cd ${S}/GWMetadata
	econf || die "GWMetadata configure failed"
	egnustep_make || die "GWMetadata make failed"
}

src_install() {
	egnustep_env

	egnustep_install

	cd ${S}/GWMetadata
	egnustep_install

	if use doc;
	then
		dodir /usr/share/doc/${PF}
		cp ${S}/Documentation/*.pdf ${D}/usr/share/doc/${PF}
	fi
}

