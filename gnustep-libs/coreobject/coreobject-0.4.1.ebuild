# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-2

S="${WORKDIR}/Etoile-${PV}/Frameworks/CoreObject"

DESCRIPTION="A framework for describing and organizing model objects"
HOMEPAGE="http://www.etoile-project.org"
SRC_URI="http://download.gna.org/etoile/etoile-${PV}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="dev-db/postgresql-base
	>=gnustep-base/gnustep-gui-0.16.0
	>=gnustep-libs/etoile-serialize-${PV}"
RDEPEND="${DEPEND}"
