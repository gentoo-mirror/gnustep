# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-libs/cenonlibrary/cenonlibrary-3.80.1.ebuild,v 1.1 2006/03/26 13:36:16 grobian Exp $

inherit gnustep-2

S=${WORKDIR}/Cenon

DESCRIPTION="Default library required to run Cenon"
HOMEPAGE="http://www.cenon.info/"
SRC_URI="http://www.vhf-group.com/vhfInterservice/download/source/CenonLibrary-${PV}-1.tar.bz2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="Cenon"

src_compile() {
	echo "nothing to compile"
}

src_install() {
	egnustep_env
	dodir ${GNUSTEP_SYSTEM_LIBRARY}
	cp -pPR ${S} ${D}${GNUSTEP_SYSTEM_LIBRARY}
}
