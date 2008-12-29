# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-2

S="${WORKDIR}/Etoile-${PV}/Frameworks/MediaKit"

DESCRIPTION="a common backend engine to play multimedia stream"
HOMEPAGE="http://www.etoile-project.org"
SRC_URI="http://download.gna.org/etoile/etoile-${PV}.tar.gz"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~ppc ~x86"
SLOT="0"
IUSE=""

DEPEND=">=gnustep-base/gnustep-gui-0.16.0
	gnustep-libs/etoile-foundation
	gnustep-libs/systemconfig
	>=media-video/ffmpeg-0.4.9_p20080326"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${WORKDIR}/Etoile-${PV}"

	cd "${S}"
	sed -i -e "s#avcodec.h#libavcodec/avcodec.h#" \
		-e "s#avformat.h#libavformat/avformat.h#" \
		MKMediaFile.h || die "ffmpeg sed failed"
}
