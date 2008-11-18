# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-2

S="${WORKDIR}/Etoile-${PV}/Frameworks/LuceneKit"

DESCRIPTION="GNUstep port of Lucene"
HOMEPAGE="http://www.etoile-project.org"
SRC_URI="http://download.gna.org/etoile/etoile-${PV}.tar.gz"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~ppc ~x86"
SLOT="0"

DEPEND="gnustep-libs/ogrekit"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${WORKDIR}/Etoile-${PV}"

	sed -i -e "s/-Werror//" etoile.make || die "sed failed"
}
