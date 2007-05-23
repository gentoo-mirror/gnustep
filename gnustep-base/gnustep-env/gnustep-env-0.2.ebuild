# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-base/gnustep-env/gnustep-env-0.1.8-r1.ebuild,v 1.3 2007/04/09 13:41:31 grobian Exp $

inherit gnustep-2

DESCRIPTION="This is a convience package that installs all base GNUstep libraries, convenience scripts, and environment settings for use on Gentoo."
# These are support files for GNUstep on Gentoo, so setting
#   homepage thusly
HOMEPAGE="http://www.gnustep.org"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

IUSE=""
DEPEND=">=gnustep-base/gnustep-make-2.0
	>=gnustep-base/gnustep-base-1.14
	>=gnustep-base/gnustep-gui-0.12
	>=virtual/gnustep-back-0.12"
RDEPEND="${DEPEND}"

egnustep_install_domain="System"

src_unpack() {
	echo "nothing to unpack"
}

src_compile() {
	echo "nothing to compile"
}

src_install() {
	egnustep_env

	dodir /etc/env.d
	cat <<- EOF > "${D}"/etc/env.d/99gnustep
PATH=${GNUSTEP_SYSTEM_TOOLS}:${GNUSTEP_LOCAL_TOOLS}:${GNUSTEP_NETWORK_TOOLS}
LDPATH=${GNUSTEP_SYSTEM_LIBRARIES}:${GNUSTEP_LOCAL_LIBRARIES}:${GNUSTEP_NETWORK_LIBRARIES}
MANPATH=${GNUSTEP_SYSTEM_DOC_MAN}:${GNUSTEP_LOCAL_DOC_MAN}:${GNUSTEP_NETWORK_DOC_MAN}
INFOPATH=${GNUSTEP_SYSTEM_DOC_INFO}:${GNUSTEP_LOCAL_DOC_INFO}:${GNUSTEP_NETWORK_DOC_INFO}
INFODIR=${GNUSTEP_SYSTEM_DOC_INFO}:${GNUSTEP_LOCAL_DOC_INFO}:${GNUSTEP_NETWORK_DOC_INFO}
EOF
}

