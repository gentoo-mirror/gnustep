# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-base

DESCRIPTION="GNUstep Makefile Package"

HOMEPAGE="http://www.gnustep.org"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/core/${P}.tar.gz"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
SLOT="0"
LICENSE="GPL-2"

DEPEND="${GNUSTEP_CORE_DEPEND}
	>=sys-devel/make-3.75"
RDEPEND="${DEPEND}"

pkg_setup() {
	gnustep-base_pkg_setup

	if ! built_with_use sys-devel/gcc objc; then
		ewarn "gcc must be compiled with Objective-C support! See the objc USE flag."
		die "ObjC support not available"
	fi
}

src_compile() {
	cd ${S}

	local myconf
	myconf="--prefix=${GNUSTEP_PREFIX} --with-layout=gnustep"
	myconf="$myconf --with-config-file=/etc/GNUstep/GNUstep.conf"
	myconf="$myconf --enable-native-objc-exceptions"
	econf $myconf || die "configure failed"

	emake
}

src_install() {
	local make_eval="-j1"
	use debug || make_eval="${make_eval} debug=no"
	make_eval="${make_eval} verbose=yes"

	emake ${make_eval} DESTDIR=${D} install || die "install has failed"

	if use doc ; then
		cd Documentation
		emake ${make_eval} all || die "doc make has failed"
		emake ${make_eval} DESTDIR=${D} install || die "doc install has failed"
		cd ..
	fi

	exeinto /etc/profile.d
	doexe ${FILESDIR}/gnustep-2.sh
	doexe ${FILESDIR}/gnustep-2.csh

	. ./GNUstep.conf
	dodir /etc/env.d
	cat <<- EOF > "${D}"/etc/env.d/99gnustep
PATH=${GNUSTEP_SYSTEM_TOOLS}:${GNUSTEP_LOCAL_TOOLS}
LDPATH=${GNUSTEP_SYSTEM_LIBRARIES}:${GNUSTEP_LOCAL_LIBRARIES}
MANPATH=${GNUSTEP_SYSTEM_DOC_MAN}:${GNUSTEP_LOCAL_DOC_MAN}
INFOPATH=${GNUSTEP_SYSTEM_DOC_INFO}:${GNUSTEP_LOCAL_DOC_INFO}
INFODIR=${GNUSTEP_SYSTEM_DOC_INFO}:${GNUSTEP_LOCAL_DOC_INFO}
EOF
}
