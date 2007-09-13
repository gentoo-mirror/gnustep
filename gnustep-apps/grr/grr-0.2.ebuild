# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-2

S="${WORKDIR}/Etoile-${PV}/Services/User/${PN/g/G}"

DESCRIPTION="RSS Reader application for RSS/OPML feeds"
HOMEPAGE="http://www.etoile-project.org"
SRC_URI="http://download.gna.org/etoile/etoile-${PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"
SLOT="0"

DEPEND="gnustep-libs/etoile-ui
	gnustep-libs/opmlkit
	gnustep-libs/rsskit"
RDEPEND="${DEPEND}"

src_compile() {
	egnustep_env
	egnustep_make etoile=yes || die "compilation failed"
}
