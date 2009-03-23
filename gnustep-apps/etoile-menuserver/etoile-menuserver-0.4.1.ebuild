# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit gnustep-2

S="${WORKDIR}/Etoile-${PV}/Services/Private/MenuServer"

DESCRIPTION="Menubar for the Etoile environment"
HOMEPAGE="http://www.etoile-project.org"
SRC_URI="http://download.gna.org/etoile/etoile-${PV}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"
SLOT="0"
IUSE=""

DEPEND=">=gnustep-base/gnustep-gui-0.16.0
	>=gnustep-libs/systemconfig-${PV}
	>=gnustep-libs/xwindowserverkit-${PV}"
RDEPEND="${DEPEND}"
# Not available in current stable
#	gnustep-libs/service-menulet
#	gnustep-libs/volumecontrol-menulet"

src_prepare() {
	cd "${WORKDIR}/Etoile-${PV}"
	sed -i -e "s/-Werror//" etoile.make || die "sed failed"
}
