# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit gnustep-2

S="${WORKDIR}/Etoile-${PV}/Services/User/Melodie"

DESCRIPTION="Melodie is a music player for Etoile"

HOMEPAGE="http://www.etoile-project.org"
SRC_URI="http://download.gna.org/etoile/etoile-${PV}.tar.bz2"

LICENSE="BSD"
KEYWORDS="~amd64 ~ppc ~x86"
SLOT="0"
IUSE=""

DEPEND=">=gnustep-base/gnustep-gui-0.16.0
	>=media-libs/libmp4v2-1.9.0
	media-libs/taglib
	>=gnustep-libs/coreobject-${PV}
	>=gnustep-libs/etoile-ui-${PV}
	>=gnustep-libs/iconkit-${PV}
	>=gnustep-libs/mediakit-${PV}
	>=gnustep-libs/scriptkit-${PV}
	>=gnustep-libs/smalltalkkit-${PV}"
RDEPEND="${DEPEND}"

src_prepare() {
	cd "${WORKDIR}/Etoile-${PV}"
	sed -i -e "s/-Werror/-Wno-unreachable-code/" etoile.make "${S}"/GNUmakefile || die "sed failed"

	cd "${S}"
	sed -i -e "s|#include <mp4.h>|#include <mp4v2/mp4v2.h>|" TLMusicFile.m || die "libmp4v2 sed failed"
}
