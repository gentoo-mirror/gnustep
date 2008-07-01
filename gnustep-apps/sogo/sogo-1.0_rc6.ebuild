# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#TODO:
# * create user, fill defaults
# * complete DEPEND

inherit depend.apache gnustep-base

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
need_apache2

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

src_install() {
	gnustep-base_src_install
	dodir "${APACHE_MODULES_CONFDIR}"
	cat <<EOF >"${D}/${APACHE_MODULES_CONFDIR}"/47_sogo.conf
<IfDefine SOPE>
LoadModule ngobjweb_module modules/mod_ngobjweb.so

Alias   /sogo.woa/WebServerResources/ \
        ${GNUSTEP_SYSTEM_LIBRARY}/SOGo-0.9/WebServerResources/
Alias   /SOGo.woa/WebServerResources/ \
        ${GNUSTEP_SYSTEM_LIBRARY}/SOGo-0.9/WebServerResources/

AliasMatch      /SOGo/so/ControlPanel/Products/(.*)/Resources/(.*) \
                ${GNUSTEP_SYSTEM_LIBRARY}/SOGo-0.9/\$1.SOGo/Resources/\$2

<LocationMatch "^/SOGo*">
        AddDefaultCharset UTF-8
        SetHandler ngobjweb-adaptor
        SetAppPort 18888
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

}
