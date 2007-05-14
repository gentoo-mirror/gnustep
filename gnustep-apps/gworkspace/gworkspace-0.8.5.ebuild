# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-apps/gworkspace/gworkspace-0.8.3.ebuild,v 1.2 2007/01/05 07:07:47 flameeyes Exp $

inherit gnustep-2

S=${WORKDIR}/${P/gw/GW}

DESCRIPTION="A workspace manager for GNUstep"
HOMEPAGE="http://www.gnustep.it/enrico/gworkspace/"
SRC_URI="http://www.gnustep.it/enrico/gworkspace/${P}.tar.gz"

KEYWORDS="~amd64 ~ppc ~x86"
LICENSE="GPL-2"
SLOT="0"

IUSE="${IUSE} pdfkit doc"
DEPEND="${GS_DEPEND}
	pdfkit? ( =gnustep-libs/pdfkit-0.9* )
	gnustep-apps/systempreferences
	>=dev-db/sqlite-3.2.8
	!gnustep-apps/desktop
	!gnustep-apps/recycler"
RDEPEND="${GS_RDEPEND}
	pdfkit? ( =gnustep-libs/pdfkit-0.9* )
	gnustep-apps/systempreferences
	>=dev-db/sqlite-3.2.8
	!gnustep-apps/desktop
	!gnustep-apps/recycler"

egnustep_install_domain "System"

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/${P}-rpath.patch
}

src_compile() {
	gnustep-2_src_compile

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

