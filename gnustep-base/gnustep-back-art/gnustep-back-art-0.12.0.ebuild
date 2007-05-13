# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-base/gnustep-back-art/gnustep-back-art-0.11.0.ebuild,v 1.1 2006/09/03 21:17:12 grobian Exp $

inherit gnustep-2

S=${WORKDIR}/gnustep-back-${PV}

DESCRIPTION="libart_lgpl back-end component for the GNUstep GUI Library"

HOMEPAGE="http://www.gnustep.org"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/core/gnustep-back-${PV}.tar.gz"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
SLOT="0"
LICENSE="LGPL-2.1"

PROVIDE="virtual/gnustep-back"

IUSE="${IUSE} opengl xim doc"
# from http://gnustep.made-it.com/BuildGuide/index.html#BUILDING.GNUSTEP
# gnustep-gui, libICE, libSM, libX11, libXext, libXi, libXmu, libXt,
# libGL, libXft, libXrender, libexpat, libfontconfig, libfreetype,
# libart
DEPEND="${GNUSTEP_CORE_DEPEND}
	>=gnustep-base/gnustep-gui-0.12
	opengl? ( virtual/opengl virtual/glu )
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXmu
	x11-libs/libXt
	x11-libs/libXft
	x11-libs/libXrender
	dev-libs/expat
	media-libs/fontconfig
	>=media-libs/freetype-2.1.9
	>=media-libs/libart_lgpl-2.3
	gnustep-base/mknfonts
	media-fonts/dejavu
	!virtual/gnustep-back"
RDEPEND="${DEPEND}
	${DEBUG_DEPEND}
	${DOC_RDEPEND}"

egnustep_install_domain "System"

src_compile() {
	egnustep_env

	use opengl && myconf="--enable-glx"
	myconf="$myconf `use_enable xim`"
	myconf="$myconf --enable-server=x11"
	myconf="$myconf --enable-graphics=art --with-name=art"
	econf $myconf || die "configure failed"

	egnustep_make

	# Create font lists for DejaVu
	einfo "Installing DejaVu fonts in GNUstep"
	cd Fonts
	mknfonts /usr/share/fonts/dejavu/*.ttf
	for fdir in DejaVu*; do
		mv -v "$fdir" `echo $fdir | tr -d [:space:]`
	done
}

src_install() {
	egnustep_env

	gnustep-2_src_install
	
	mkdir -p "${D}/${GNUSTEP_SYSTEM_LIBRARY}/Fonts"
	cp -pPR Fonts/*.nfont "${D}/${GNUSTEP_SYSTEM_LIBRARY}/Fonts"

	dosym \
		"${GNUSTEP_SYSTEM_LIBRARY}/Bundles/libgnustep-art-012.bundle" \
		"${GNUSTEP_SYSTEM_LIBRARY}/Bundles/libgnustep-art.bundle"
}

