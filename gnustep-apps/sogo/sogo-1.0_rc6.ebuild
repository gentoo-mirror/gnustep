# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#TODO:
# * switch to gnustep-base
# * Provide default configuration file for apache
# * create user, fill defaults
# * complete DEPEND

inherit gnustep-2

MY_PN="SOGo"
MY_PV="1.0rc6.1"
DESCRIPTION="groupware server built around OpenGroupware.org and the SOPE application server"
HOMEPAGE="http://sogo.opengroupware.org/"
SRC_URI="http://www.inverse.ca/downloads/${MY_PN}/Sources/${MY_PN}-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="gnustep-libs/sope"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_PN}

src_unpack() {
	gnustep-base_src_unpack

	# Fix for missing include
	epatch "${FILESDIR}"/${PN}-foundation_include.patch
}


src_compile() {
	# Do not use standard src_compile, as ./configure is not standard
	egnustep_env
	./configure
	egnustep_make
}
