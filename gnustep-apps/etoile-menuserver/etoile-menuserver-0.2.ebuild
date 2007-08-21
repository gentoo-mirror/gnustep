# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-2

S="${WORKDIR}/Etoile-${PV}/Services/Private/MenuServer"

DESCRIPTION="Menubar for the Etoile environment"
HOMEPAGE="http://www.etoile-project.org"
SRC_URI="http://download.gna.org/etoile/etoile-${PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"
SLOT="0"

DEPEND="gnustep-apps/etoile-system
	gnustep-libs/xwindowserverkit"
RDEPEND="${DEPEND}
	gnustep-libs/service-menulet
	gnustep-libs/volumecontrol-menulet"
