# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-base/gnustep-make/gnustep-make-1.13.0.ebuild,v 1.3 2007/03/18 01:33:13 genone Exp $

inherit gnustep-2

DESCRIPTION="GNUstep Makefile Package"

HOMEPAGE="http://www.gnustep.org"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/core/${P}.tar.gz"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
SLOT="0"
LICENSE="GPL-2"

IUSE="${IUSE} doc non-flattened verbose"
DEPEND="${GNUSTEP_CORE_DEPEND}
	>=sys-devel/make-3.75"
RDEPEND="${DEPEND}
	${DOC_RDEPEND}"

egnustep_install_domain "System"

pkg_setup() {
	gnustep-2_pkg_setup

	if ! built_with_use sys-devel/gcc objc; then
		ewarn "gcc must be compiled with Objective-C support! See the objc USE flag."
		die "ObjC support not available"
	fi

	# setup defaults here
	egnustep_prefix "/usr/GNUstep"
	egnustep_system_root "/usr/GNUstep/System"
	egnustep_local_root "/usr/GNUstep/Local"
	egnustep_network_root "/usr/GNUstep/Network"
	egnustep_user_dir 'GNUstep'
}

src_compile() {
	cd ${S}

	local myconf
	myconf="--prefix=`egnustep_prefix` --with-layout=gnustep"
	use non-flattened && myconf="$myconf --disable-flattened --enable-multi-platform"
	econf $myconf || die "configure failed"

	egnustep_make
}

src_install() {
	. ${S}/GNUstep.sh

	local make_eval="-j1"
	use debug || make_eval="${make_eval} debug=no"
	use verbose && make_eval="${make_eval} verbose=yes"

	make ${make_eval} DESTDIR=${D} install || die "install has failed"

	if use doc ; then
		cd Documentation
		emake ${make_eval} all || die "doc make has failed"
		emake ${make_eval} DESTDIR=${D} install || die "doc install has failed"
		cd ..
	fi

	dodir /etc/conf.d
	echo "GNUSTEP_SYSTEM_ROOT=$(egnustep_system_root)" > ${D}/etc/conf.d/gnustep.env
	echo "GNUSTEP_LOCAL_ROOT=$(egnustep_local_root)" >> ${D}/etc/conf.d/gnustep.env
	echo "GNUSTEP_NETWORK_ROOT=$(egnustep_network_root)" >> ${D}/etc/conf.d/gnustep.env
	echo "GNUSTEP_USER_DIR='$(egnustep_user_dir)'" >> ${D}/etc/conf.d/gnustep.env

	insinto /etc/GNUstep
	doins ${S}/GNUstep.conf

	exeinto /etc/profile.d
	doexe ${FILESDIR}/gnustep-2.sh
	doexe ${FILESDIR}/gnustep-2.csh
}

