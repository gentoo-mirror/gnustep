# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit gnustep-2 user

MY_PN="SOGo"

DESCRIPTION="Groupware server built around OpenGroupware.org and the SOPE application server"
HOMEPAGE="http://www.sogo.nu"
SRC_URI="http://www.sogo.nu/files/downloads/${MY_PN}/Sources/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="postgres mysql"

DEPEND="dev-libs/libmemcached
	dev-libs/openssl
	gnustep-libs/sope[mysql?,postgres?]
	net-nds/openldap"
RDEPEND="${DEPEND}"

REQUIRED_USE="|| ( mysql postgres )"

S=${WORKDIR}/${MY_PN}-${PV}

pkg_setup() {
	enewuser sogo -1 /bin/bash /var/lib/sogo
}

src_prepare() {
	gnustep-base_src_prepare
	sed -e "s/validateArgs$//" -i configure \
		|| die "GNUstep.conf sed failed"
}

src_configure() {
	egnustep_env

	./configure \
		$(use_enable debug) \
		$(use_enable debug strip) \
		--with-ssl=ssl \
		--prefix=/usr \
		|| die "configure failed"
}

src_install() {
	gnustep-base_src_install

	newconfd "${FILESDIR}"/sogod.confd sogod
	newinitd "${FILESDIR}"/sogod.initd sogod

	insinto /etc/logrotate.d
	newins Scripts/logrotate sogo
	newdoc Apache/SOGo.conf SOGo-Apache.conf

	insinto /etc/sogo
	doins Scripts/sogo.conf

	insinto /etc/cron.d
	newins Scripts/sogo.cron sogo
	keepdir /var/log/sogo

	fowners sogo:sogo /var/log/sogo
	fowners -R root:sogo /etc/sogo
}

pkg_postinst() {
	gnustep-base_pkg_postinst
	elog "SOGo documentation is available online at:"
	elog "http://www.sogo.nu/downloads/documentation.html"
	elog
	elog "Apache sample configuration file is available in:"
	elog "/usr/share/doc/${PF}"
}
