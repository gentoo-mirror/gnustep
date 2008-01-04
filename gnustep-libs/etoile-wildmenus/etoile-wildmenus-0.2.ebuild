# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-2

S="${WORKDIR}/Etoile-${PV}/Bundles/EtoileWildMenus"

DESCRIPTION="provides horizontal menu display to Etoile applications"
HOMEPAGE="http://www.etoile-project.org"
SRC_URI="http://download.gna.org/etoile/etoile-${PV}.tar.gz"
LICENSE="BSD"
KEYWORDS="~amd64 ~ppc ~x86"
SLOT="0"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-gnustep-base-1.15.patch
	epatch "${FILESDIR}"/${P}-gnustep-gui-0.13.1.patch
}

gnustep_config_script() {
	echo "gnustep_append_default NSGlobalDomain GSAppKitUserBundles \"${GNUSTEP_SYSTEM_LIBRARY}/Bundles/EtoileMenus.bundle\""
}
