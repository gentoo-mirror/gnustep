# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-2

S="${WORKDIR}/Etoile-${PV}/Services/User/Calc"

DESCRIPTION="A very simple calculator"
HOMEPAGE="http://www.etoile-project.org/etoile/mediawiki/index.php?title=Applications"
SRC_URI="http://download.gna.org/etoile/etoile-${PV}.tar.gz"

LICENSE="BSD"
KEYWORDS="~ppc ~x86 ~amd64"
SLOT="0"

DEPEND="gnustep-libs/etoile-io"
RDEPEND="${DEPEND}"

src_compile() {
	einfo "Nothing to compile"
}
src_install() {
	egnustep_env
	dodir ${GNUSTEP_SYSTEM_APPS}
	cp -R Calc.app ${D}/${GNUSTEP_SYSTEM_APPS}

	# Tools wrapper
	dodir ${GNUSTEP_SYSTEM_TOOLS}
	ln -s ${GNUSTEP_SYSTEM_APPS}/Calc.app/Calc ${D}/${GNUSTEP_SYSTEM_TOOLS}/
}
