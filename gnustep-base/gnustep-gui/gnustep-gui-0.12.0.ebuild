# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-base

DESCRIPTION="Library of GUI classes written in Obj-C"
HOMEPAGE="http://www.gnustep.org/"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/core/${P}.tar.gz"

KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
SLOT="0"
LICENSE="LGPL-2.1"

#gsnd USE flag removed until portaudio-19 is available
IUSE="jpeg gif png cups"

DEPEND="${GNUSTEP_CORE_DEPEND}
	>=gnustep-base/gnustep-base-1.14.0
	x11-libs/libXt
	>=media-libs/tiff-3
	jpeg? ( >=media-libs/jpeg-6b )
	gif? ( >=media-libs/giflib-4.1 )
	png? ( >=media-libs/libpng-1.2 )
	cups? ( >=net-print/cups-1.1 )
	app-text/aspell"
# gsnd needs a recent portaudio that's not unmasked in the tree yet
#	gsnd? (
#		>=media-libs/audiofile-0.2
#		=media-libs/portaudio-19*
#	)
RDEPEND="${DEPEND}"

#src_unpack() {
#	unpack ${A}
#	cd ${S}
#
#	if use gsnd;
#	then
#		sed -i -e "s:#include <portaudio.h>:#include <portaudio-2/portaudio.h>:g" ${S}/Tools/gsnd/gsnd.m 
#		sed -i -e "s:-lportaudio:-lportaudio-2:g" ${S}/Tools/gsnd/GNUmakefile 
#		sed -i -e "s:^BUILD_GSND=.*$:BUILD_GSND=gsnd:g" ${S}/config.make.in 
#	fi
#}

src_compile() {
	egnustep_env

	myconf="--with-tiff-include=/usr/include --with-tiff-library=/usr/lib"
	use gif && myconf="$myconf --disable-ungif --enable-libgif"
	myconf="$myconf `use_enable jpeg`"
	myconf="$myconf `use_enable png`"
	myconf="$myconf `use_enable cups`"

#	if use gsnd;
#	then
#		myconf="$myconf `use_enable gsnd`"
#		myconf="$myconf --with-audiofile-include=/usr/include --with-audiofile-lib=/usr/lib"
#		myconf="$myconf --with-include-flags=-I/usr/include/portaudio-2"
#	fi

	econf $myconf || die "configure failed"

	egnustep_make || die
}
