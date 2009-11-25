# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit depend.apache gnustep-base

MY_PN="SOGo"
MY_PV="${PV/_/}"

DESCRIPTION="groupware server built around OpenGroupware.org and the SOPE application server"
HOMEPAGE="http://sogo.opengroupware.org/"
SRC_URI="http://www.inverse.ca/downloads/${MY_PN}/Sources/${MY_PN}-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="gnustep-libs/sope[postgres]"
RDEPEND="${DEPEND}
	dev-db/postgresql"
need_apache2

S=${WORKDIR}/${MY_PN}-${MY_PV}

src_configure() {
	# Do not use standard src_compile, as ./configure is not standard
	egnustep_env
	./configure
}

src_install() {
	gnustep-base_src_install

	# Apache configuration file
	dodir "${APACHE_MODULES_CONFDIR}"
	cat <<EOF >"${D}/${APACHE_MODULES_CONFDIR}"/47_sogo.conf
<IfDefine SOPE>
LoadModule ngobjweb_module modules/mod_ngobjweb.so

Alias /sogo.woa/WebServerResources/ \
	${GNUSTEP_SYSTEM_LIBRARY}/SOGo/WebServerResources/
Alias /SOGo.woa/WebServerResources/ \
	${GNUSTEP_SYSTEM_LIBRARY}/SOGo/WebServerResources/
Alias /SOGO.woa/WebServerResources/ \
	${GNUSTEP_SYSTEM_LIBRARY}/SOGo/WebServerResources/

AliasMatch /SOGo/so/ControlPanel/Products/(.*)/Resources/(.*) \
	${GNUSTEP_SYSTEM_LIBRARY}/SOGo/\$1.SOGo/Resources/\$2

<LocationMatch "^/SOGo*">
	AddDefaultCharset UTF-8
	SetHandler ngobjweb-adaptor
	SetAppPort 20000
	Allow from 127.0.0.1
</LocationMatch>

<LocationMatch "^/SOGo/so/ControlPanel/Products/.*UI/Resources/.*png">
	SetHandler default-handler
</LocationMatch>

<LocationMatch "^/SOGo/so/ControlPanel/Products/.*UI/Resources/.*gif">
	SetHandler default-handler
</LocationMatch>

<LocationMatch "^/SOGo/so/ControlPanel/Products/.*UI/Resources/.*css">
	SetHandler default-handler
</LocationMatch>

<LocationMatch "^/SOGo/so/ControlPanel/Products/.*UI/Resources/.*js">
	SetHandler default-handler
</LocationMatch>

</IfDefine>
EOF

	# Init script
	newinitd "${FILESDIR}"/sogo.initd sogo \
		|| die "Init script installation failed"
}

pkg_preinst() {
	enewuser sogo -1 /bin/bash /var/lib/sogo
}

pkg_postinst() {
	gnustep-base_pkg_postinst

	elog "Do not forget to enable the sope module in /etc/apache2/httpd.conf"
	elog "Now follow the steps from the SOGo documentation, Configuration section:"
	elog "http://www.inverse.ca/contributions/sogo/documentation.html#c803"
	elog "The default port configured for sogo is 20000 (from 47_sogo.conf)"
	elog "The sogo user home directory is /var/lib/sogo"
	elog ""
	elog "Then you can start/stop sogo with /etc/init.d/sogo"
}
