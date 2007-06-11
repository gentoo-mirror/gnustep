# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-2

MY_PN=${PN/gnum/GNUM}

S=${WORKDIR}/${MY_PN}

DESCRIPTION="A fully featured mail application for GNUstep"
HOMEPAGE="http://www.collaboration-world.com/gnumail/"
SRC_URI="http://www.collaboration-world.com/gnumail.data/releases/Stable/${MY_PN}-${PV/_/}.tar.gz"

KEYWORDS="~amd64 ~x86 ~ppc"
LICENSE="GPL-2"
SLOT="0"

IUSE="crypt emoticon xface"
DEPEND="=gnustep-libs/pantomime-${PV}
	>=gnustep-base/gnustep-gui-0.11.0
	gnustep-libs/addresseskit"
RDEPEND="crypt? ( app-crypt/gnupg )"

src_unpack() {
	unpack ${A}
	cd ${S}

	sed -i -e \
		's|$(GNUSTEP_INSTALLATION_DIR)/Library|$(DESTDIR)$(GNUSTEP_SYSTEM_LIBRARY)|' \
		Bundles/*/GNUmakefile || die "gnustep-make-2 sed failed"
}

src_compile() {
	egnustep_env
	egnustep_make

	cd Bundles/Clock
	egnustep_make
	cd ${S}

	if use xface ; then
		cd Bundles/Face
		egnustep_make
		cd ${S}
	fi

	if use crypt ; then
		cd Bundles/PGP
		egnustep_make
		cd ${S}
	fi

	if use emoticon ; then
		cd Bundles/Emoticon
		egnustep_make
		cd ${S}
	fi
}

src_install() {
	gnustep-base_src_install

	cd Bundles/Clock
	egnustep_install || die
	cd ${S}

	if use xface ; then
		cd Bundles/Face
		egnustep_install || die
		cd ${S}
	fi
	if use crypt ; then
		cd Bundles/PGP
		egnustep_install || die
		cd ${S}
	fi
	if use emoticon ; then
		cd Bundles/Emoticon
		egnustep_install || die
		cd ${S}
	fi

	dodoc ${S}/Documentation/*

	# FIX ?
	rm -rf ${D}$(egnustep_install_domain)/Applications/GNUMail.app/Resources/Resources
}
