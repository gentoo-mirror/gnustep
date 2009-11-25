# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit gnustep-base apache-module

MY_PV="1660-200906161500"

DESCRIPTION="an extensive set of frameworks which form a complete Web application server environment"
HOMEPAGE="http://sope.opengroupware.org/en/index.html"
SRC_URI="http://download.opengroupware.org/nightly/sources/trunk/${PN}-trunk-r${MY_PV}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="mysql +postgres sqlite"

DEPEND="gnustep-base/gnustep-base
	dev-libs/libxml2
	net-nds/openldap
	mysql? ( virtual/mysql )
	postgres? ( virtual/postgresql-base )
	sqlite? ( >=dev-db/sqlite-3 )
	!gnustep-libs/gdl2"
RDEPEND="${DEPEND}"

APACHE2_MOD_DEFINE="SOPE"
APACHE2_MOD_FILE="sope-appserver/mod_ngobjweb/mod_ngobjweb.so"
need_apache2

S=${WORKDIR}/${PN}

src_prepare() {
	gnustep-base_src_prepare

	# Install in System instead of Local
	epatch "${FILESDIR}"/${PN}-use_system_root.patch
	# From SOGo project
	epatch "${FILESDIR}"/${PN}-gsmake2.diff
	epatch "${FILESDIR}"/${PN}-patchset-r1660.diff

	# Missing -lcrypt
	sed -e "s/-lXmlRpc -lDOM -lSaxObjC/\0 -lcrypt/" \
		-i sope-appserver/SoOFS/GNUmakefile.preamble \
		|| die "crypt sed failed"
}

src_configure() {
	# Do not use standard src_configure, as ./configure is not standard
	egnustep_env
	./configure --with-gnustep || die "configure failed"
}

src_compile() {
	egnustep_env
	egnustep_make apxs=/usr/sbin/apxs apr=/usr/bin/apr-1-config
}

src_install() {
	gnustep-base_src_install
	apache-module_src_install
}

pkg_postinst() {
	gnustep-base_pkg_postinst
	apache-module_pkg_postinst
}
