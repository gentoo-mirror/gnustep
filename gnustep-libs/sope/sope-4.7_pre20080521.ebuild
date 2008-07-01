# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-2

MY_PV="1621-200805211100"

DESCRIPTION="an extensive set of frameworks which form a complete Web application server environment"
HOMEPAGE="http://sope.opengroupware.org/en/index.html"
SRC_URI="http://download.opengroupware.org/nightly/sources/trunk/${PN}-trunk-r${MY_PV}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
#TODO add use flags and deps for mysql,postrgesql, sqlite
IUSE=""

DEPEND="dev-libs/libxml2
	net-nds/openldap
	www-servers/apache"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

src_unpack() {
	gnustep-base_src_unpack

	# Fix for recent gnustep-base
	epatch "${FILESDIR}"/${PN}-nsexception.patch
	# Install in System instead of Local
	epatch "${FILESDIR}"/${PN}-use_system_root.patch
	# From SOGo project
	epatch "${FILESDIR}"/${PN}-gsmake2.diff
	epatch "${FILESDIR}"/${PN}-mime-nosort.diff
	epatch "${FILESDIR}"/${PN}-patchset-r1621.diff
}

src_compile() {
	# Do not use standard src_compile, as ./configure is not standard
	egnustep_env
	./configure --with-gnustep || die "configure failed"
	egnustep_make apxs=/usr/sbin/apxs apr=/usr/bin/apr-1-config
}
