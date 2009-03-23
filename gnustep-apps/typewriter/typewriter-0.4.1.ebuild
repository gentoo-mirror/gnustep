# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-2

S="${WORKDIR}/Etoile-${PV}/Services/User/${PN/t/T}"

DESCRIPTION="Etoilé general text editor for plain and rich format text"

HOMEPAGE="http://www.etoile-project.org"
SRC_URI="http://download.gna.org/etoile/etoile-${PV}.tar.bz2"

LICENSE="BSD"
KEYWORDS="~amd64 ~ppc ~x86"
SLOT="0"
IUSE=""

DEPEND=">=gnustep-libs/ogrekit-${PV}
	>=gnustep-libs/scriptkit-${PV}"
RDEPEND="${DEPEND}"
