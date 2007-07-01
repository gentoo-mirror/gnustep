# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-2

S=${WORKDIR}/${P/c/C}

DESCRIPTION="Free software and romantic music player for GNUstep."
HOMEPAGE="http://organact.mine.nu/~wolfgang/cynthiune"
SRC_URI="http://organact.mine.nu/~wolfgang/cynthiune/${P/c/C}.tar.gz"

IUSE="modplug arts esd"

KEYWORDS="~amd64 ~ppc ~x86"
LICENSE="GPL-2"
SLOT="0"

DEPEND=">=media-libs/libid3tag-0.15.0b
	>=media-libs/libmad-0.15.1b
	media-libs/audiofile
	>=media-libs/libogg-1.1.2
	>=media-libs/libvorbis-1.0.1-r2
	media-libs/flac
	media-libs/libmpcdec
	modplug? ( media-libs/libmodplug )
	esd? ( media-sound/esound )
	arts? ( kde-base/arts )"
RDEPEND="$DEPEND"

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch "${FILESDIR}"/${P}-flac-1.1.3.patch
	epatch "${FILESDIR}"/${P}-NSCellExtensions.patch
	epatch "${FILESDIR}"/${P}-gnustep-make-2.patch
}

cynthiune_get_config() {
	local myconf=""
	# Gentoo doesn't have libavi (any more)
	myconf="${myconf} disable-windowsmedia=yes"
	use modplug || myconf="${myconf} disable-mod=yes"
	use arts || myconf="${myconf} disable-arts=yes"
	use esd || myconf="${myconf} disable-esound=yes"

	echo ${myconf}
}

src_compile() {
	egnustep_env
	egnustep_make "$(cynthiune_get_config)" || die "make failed"
}

src_install() {
	egnustep_env
	egnustep_install "$(cynthiune_get_config)" || die
	if use doc ; then
		egnustep_env
		egnustep_doc || die
	fi
	egnustep_package_config
}
