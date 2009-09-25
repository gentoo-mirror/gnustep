# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit gnustep-2

S="${WORKDIR}/Etoile-${PV}/Frameworks/EtoileFoundation"

DESCRIPTION="Foundation framework extensions from the Etoile project"
HOMEPAGE="http://www.etoile-project.org"
SRC_URI="http://download.gna.org/etoile/etoile-${PV}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=">=virtual/gnustep-back-0.16.0"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -e "s#ADDITIONAL_OBJCFLAGS += -march=i586##" GNUmakefile || die "sed failed"

	cd "${WORKDIR}/Etoile-${PV}"
	sed -i -e "s/-Werror//" etoile.make || die "Werror sed failed"
}