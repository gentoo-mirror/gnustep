# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-2

S="${WORKDIR}/Etoile-${PV}/Services/User/${PN/t/T}"

DESCRIPTION="Etoile project simple word processor"

HOMEPAGE="http://www.etoile-project.org"
SRC_URI="http://download.gna.org/etoile/etoile-${PV}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~ppc ~x86"
SLOT="0"

DEPEND="gnustep-libs/ogrekit"
RDEPEND="${DEPEND}"
