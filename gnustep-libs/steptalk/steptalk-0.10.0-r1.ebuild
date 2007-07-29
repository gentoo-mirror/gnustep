# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-2

DESCRIPTION="StepTalk is the official GNUstep scripting framework."
HOMEPAGE="http://www.gnustep.org/experience/StepTalk.html"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/libs/${P/steptalk/StepTalk}.tar.gz"

KEYWORDS="~amd64"
LICENSE="LGPL-2.1"
SLOT="0"

S="${WORKDIR}/StepTalk"

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/${P}-gnustep-make-2.patch
}

#TODO
#src_install() {
#	gnustep-base_src_install
#
#	if use doc ; then
#		egnustep_env
#		cd Documentation
#		mkdir -p ${TMP}/tmpdocs
#		mv *.* ${TMP}/tmpdocs
#		mv Reference ${TMP}/tmpdocs
#		mkdir -p ${D}$(egnustep_install_domain)/Library/Documentation/Developer/${PN/stept/StepT}
#		mv ${TMP}/tmpdocs/* ${D}$(egnustep_install_domain)/Library/Documentation/Developer/${PN/stept/StepT}
#		cd ..
#	fi
#}
