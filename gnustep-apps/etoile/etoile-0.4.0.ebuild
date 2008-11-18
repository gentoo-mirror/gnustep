# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-2

S="${WORKDIR}/Etoile-${PV}/Services/Private/System"

DESCRIPTION="Meta-package for the Etoile desktop environment"
HOMEPAGE="http://www.etoile-project.org"
SRC_URI="http://download.gna.org/etoile/etoile-${PV}.tar.gz"

LICENSE="as-is"
KEYWORDS="~amd64 ~ppc ~x86"
SLOT="0"

RDEPEND=">=gnustep-apps/azbackground-${PV}
	>=gnustep-apps/dictionaryreader-${PV}
	>=gnustep-apps/etoile-corner-${PV}
	>=gnustep-apps/etoile-idle-${PV}
	>=gnustep-apps/etoile-menuserver-${PV}
	>=gnustep-apps/fontmanager-${PV}
	>=gnustep-apps/melodie-${PV}
	>=gnustep-apps/scriptservices-${PV}
	>=gnustep-apps/stepchat-${PV}
	>=gnustep-apps/typewriter-${PV}
	>=gnustep-apps/vindaloo-${PV}
	>=gnustep-libs/camaelon-${PV}"

src_unpack() {
	unpack ${A}
	cd ${S}

	# Fix path
	egnustep_env
	sed -i "s#/usr/local/bin/etoile#${GNUSTEP_SYSTEM_TOOLS}/etoile_system#" \
		etoile.desktop || die "Fixing desktop file failed"
}

src_compile() {
	einfo "Nothing to compile"
}

src_install() {
	egnustep_env

	# Install SystemTaskList
	dodir ${GNUSTEP_SYSTEM_LIBRARY}/Etoile
	insinto ${GNUSTEP_SYSTEM_LIBRARY}/Etoile
	doins SystemTaskList.plist

	# Install desktop entry file
	insinto /usr/share/xsessions
	doins etoile.desktop
}
