# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils gnustep-2

MY_PN=SimpleAgenda
DESCRIPTION="a simple calender and agenda application"
HOMEPAGE="http://coyote.octets.fr/pub/gnustep/"
SRC_URI="http://coyote.octets.fr/pub/gnustep/${MY_PN}-${PV}.tar.gz
		 http://coyote.octets.fr/pub/gnustep/ChronographerSource.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S=${WORKDIR}/${MY_PN}-${PV}

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/${PN}-chronographersource.patch
}

src_compile() {
	egnustep_env
	cd ${WORKDIR}/ChronographerSource
	egnustep_make

	cd ${S}
	egnustep_make
}

src_install() {
	cd ${WORKDIR}/ChronographerSource
	egnustep_install

	cd ${S}
	egnustep_install
}
