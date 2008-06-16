# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-2

S="${WORKDIR}/Etoile-${PV}/Languages/Io"

DESCRIPTION="Io language support in a convenient way for GNUstep developers or users"
HOMEPAGE="http://www.etoile-project.org"
SRC_URI="http://download.gna.org/etoile/etoile-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="gnustep-libs/distributedview
	>=gnustep-libs/steptalk-0.10"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd ${S}

	sed -i -e "s/IoVM/iovm/" GNUmakefile.steptalk || die "sed failed"
}

src_compile() {
	egnustep_env
	egnustep_make steptalk=yes || die "compilation failed"
}
