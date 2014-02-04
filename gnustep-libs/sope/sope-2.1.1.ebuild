# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit gnustep-2

DESCRIPTION="An extensive set of frameworks which form a complete Web application server environment"
HOMEPAGE="http://www.sogo.nu/"
SRC_URI="http://www.sogo.nu/files/downloads/SOGo/Sources/SOPE-${PV}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="mysql postgres sqlite"

DEPEND="dev-libs/libxml2
	dev-libs/openssl
	net-nds/openldap
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql-base )
	sqlite? ( dev-db/sqlite:3 )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/SOPE

src_configure() {
	# Non-standard configure script
	./configure \
		$(use_enable debug) \
		$(use_enable debug strip) \
		--with-gnustep || die "configure failed"
}
