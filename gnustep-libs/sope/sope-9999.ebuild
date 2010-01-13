# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit gnustep-base apache-module flag-o-matic subversion

ESVN_REPO_URI="http://svn.opengroupware.org/SOPE/trunk"

DESCRIPTION="An extensive set of frameworks which form a complete Web application server environment"
HOMEPAGE="http://sope.opengroupware.org/en/index.html"
LICENSE="LGPL-2"
SLOT="0"
KEYWORDS=""
IUSE="apache2 ldap libFoundation mysql postgres sqlite"
DEPEND="gnustep-base/gnustep-base
	dev-libs/libxml2
	dev-libs/openssl
	dev-util/monotone
	ldap? ( net-nds/openldap )
	mysql? ( virtual/mysql )
	postgres? ( virtual/postgresql-base )
	sqlite? ( >=dev-db/sqlite-3.0 )"
RDEPEND="${DEPEND}"

APACHE2_MOD_DEFINE="NGOBJWEB"
APACHE2_MOD_FILE="sope-appserver/mod_ngobjweb/mod_ngobjweb.so"
APACHE2_MOD_CONF="47_mod_ngobjweb"

S=${WORKDIR}/${PN}

want_apache

pkg_setup() {
	gnustep-base_pkg_setup
	local myLDFLAGS="$(gnustep-config --variable=LDFLAGS 2>/dev/null)"
	if [ -n "${myLDFLAGS}" ] && (echo "${myLDFLAGS}" | grep -q "\-\-a\(dd\|s\)\-needed" 2>/dev/null); then
		ewarn
		ewarn "You seem to have compiled GNUstep with custom LDFLAGS:"
		for foo in $(gnustep-config --variable=LDFLAGS); do
			ewarn "  "${foo}
		done
		ewarn
		ewarn "SOPE is very sensitive regarding custom LDFLAGS. Especially with:"
		ewarn "  --add-needed"
		ewarn "  --as-needed"
		ewarn
		ewarn "If your SOPE install does not work as expected then please re-emerge SOPE"
		ewarn "and your GNUstep (base and make) without any LDFLAGS before filing bugs."
		ewarn
	fi
	append-ldflags -Wl,--no-as-needed
	depend.apache_pkg_setup
}

src_unpack() {
	subversion_src_unpack

	# SOGo Monotone
	EMTN_STORE_DIR="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}/mtn-src"
	addread "${EMTN_STORE_DIR}"
	addwrite "${EMTN_STORE_DIR}"
	if [ ! -d "${EMTN_STORE_DIR}" ]; then
		mkdir -p "${EMTN_STORE_DIR}" || die "Can't mkdir ${EMTN_STORE_DIR}."
	fi
	cd "${EMTN_STORE_DIR}" || die "Can't chdir to ${EMTN_STORE_DIR}"

	if [ ! -f "db.mtn" ]; then
	mtn db init --db=./db.mtn || die "Failed to initialize Monotone database"
	fi

	# Pull Inverse's SOGo Monotone repository
	mtn --db=./db.mtn pull inverse.ca ca.inverse.sogo || die "Failed to pull Monotone repository"
	if [ ! -d "SOGo" ]; then
		mtn --db=./db.mtn checkout --branch ca.inverse.sogo SOGo || die "Failed to checkout SOGo branch"
	else
		cd SOGo
		mtn update
	fi
}

src_prepare() {
	# http://www.scalableogo.org/english/support/faq/article/how-do-i-compile-sogo.html
	epatch "${EMTN_STORE_DIR}"/SOGo/SOPE/sope-gsmake2.diff
	epatch "${EMTN_STORE_DIR}"/SOGo/SOPE/sope-patchset-r1660.diff
	epatch "${FILESDIR}"/${PN}-r1660-use_system_root.patch
	epatch "${FILESDIR}"/${PN}-r1660-SOGo-fix.patch
	epatch "${FILESDIR}"/${PN}-r1660-SoOFS.patch			# Fixing stuff after SOGo patches
	epatch "${FILESDIR}"/${PN}-r1660-MySQL4Channel.m.patch		# Fixing issues with primary key and UTF8
	epatch "${FILESDIR}"/${PN}-r1660-NGLogSyslogAppender.m.patch	# Fixing compiler warnings
	epatch "${FILESDIR}"/${PN}-r1660-NGHttp+WO.m.patch		# Fixing compiler warnings
	epatch "${FILESDIR}"/${PN}-r1660-LDAP_deprecated.patch		# Fixing QA issues on 64 Bit

	if use apache2; then
		# Only add mod_ngobjweb if it is not already in SUBPROJECTS
		if ! ( sed -e :a -e '/\\$/N; s/\\\n//; ta' "${S}"/sope-appserver/GNUmakefile 2>/dev/null | grep -q "^[[:space:]]*SUBPROJECTS[\t \+=].*[[:space:]]mod_ngobjweb" ); then
			sed -i "/^SUBPROJECTS[\t \+=]/,/^[\t ]\{1,99\}[a-zA-Z]\{1,99\}[\t ]*$/{s/\([a-zA-Z]\)$/\1\t\\\\\n\tmod_ngobjweb/}" \
				"${S}"/sope-appserver/GNUmakefile
		fi
	else
		# Only remove mod_ngobjweb if it is found in SUBPROJECTS
		if ( sed -e :a -e '/\\$/N; s/\\\n//; ta' "${S}"/sope-appserver/GNUmakefile 2>/dev/null | grep -q "^[[:space:]]*SUBPROJECTS[\t \+=].*[[:space:]]mod_ngobjweb" ); then
			sed -i "s/^[\t ]*mod_ngobjweb[\t ]*$/\n/;/^[\t ]*mod_ngobjweb[\t ]*\\\\$/d" \
				"${S}"/sope-appserver/GNUmakefile
		fi
	fi

	gnustep-base_src_prepare
}

src_configure() {
	egnustep_env
	local myconf
	if use libFoundation; then
		myconf="${myconf} --frameworks=libFoundation"
		cd "${S}"/libFoundation
		./configure \
			--prefix=/usr \
			$(use_enable debug) \
			--with-gnustep || die "configure libFoundation failed"
	fi
	cd "${S}"
	./configure \
		$(use_enable debug) \
		$(use_enable debug strip) \
		--with-gnustep ${myconf} || die "configure failed"
}

src_compile() {
	egnustep_env
	local myconf
	if use libFoundation; then
		cd "${S}"/libFoundation
		CFLAGS="${CFLAGS} -Wno-import" egnustep_make
		cd "${S}"
	fi
	if use apache2; then
		myconf="${myconf} apxs=/usr/sbin/apxs"
		myconf="${myconf} apr=/usr/bin/apr-1-config"
	fi
	egnustep_make ${myconf}
}

src_test() {
	# SOPE tends to break horribly if gnustep-make is build with LDFLAGS such as
	# -Wl,--add-needed or -Wl,--as-needed. So we check here some vital binaries.
	# Check if SoCore, SoOFS is correctly build/linked
	local mySoCoreLDD=$(ldd -d "${S}"/sope-appserver/NGObjWeb/SoCore.sxp/SoCore 2>&1 | grep "lib\(NG\(ObjWeb\|Mime\|Streams\|Extensions\)\|EOControl\|DOM\|SaxObjC\|XmlRpc\)\.so\." | wc -l)
	local mySoOFSLDD=$(ldd -d "${S}"/sope-appserver/SoOFS/SoOFS.sxp/SoOFS 2>&1 | grep "lib\(SoOFS\|NG\(ObjWeb\|Mime\|Streams\|Extensions\)\|EOControl\|DOM\|SaxObjC\|XmlRpc\)\.so\." | wc -l)
	if [ -z "${mySoCoreLDD}" -o -z "${mySoOFSLDD}" -o "${mySoCoreLDD}" != "8" -o "${mySoOFSLDD}" != "9" ]; then
		ewarn
		ewarn "This SOPE installtion is not correctly build. Probably you are using"
		ewarn "LDFLAGS to build SOPE that are not correctly handled in SOPE or you"
		ewarn "have emerged gnustep-base/gnustep-make with LDFLAGS which are"
		ewarn "preventing SOPE to link the needed libraries into it's own binaries."
		ewarn "Please remerge gnustep-base/gnustep-make and/or SOPE with empty LDFLAGS."
		ewarn
		die "SOPE build is not complete (SoCore, SoOFS)"
	fi
	# Do the same for WEExtensions, WOExtensions, WEPrototype
	local myWEExtensionsLDD=$(ldd -d "${S}"/sope-appserver/WEExtensions/WEExtensions.wox/WEExtensions 2>&1 | grep "lib\(WEExtensions\|NG\(ObjWeb\|Mime\|Streams\|Extensions\)\|EOControl\|DOM\|SaxObjC\|XmlRpc\)\.so\." | wc -l)
	local myWOExtensionsLDD=$(ldd -d "${S}"/sope-appserver/WOExtensions/WOExtensions.wox/WOExtensions 2>&1 | grep "lib\(W[EO]Extensions\|NG\(ObjWeb\|Mime\|Streams\|Extensions\)\|EOControl\|DOM\|SaxObjC\|XmlRpc\)\.so\." | wc -l)
	local myWEPrototypeLDD=$(ldd -d "${S}"/sope-appserver/WEPrototype/WEPrototype.wox/WEPrototype 2>&1 | grep "lib\(WEPrototype\|NG\(ObjWeb\|Mime\|Streams\|Extensions\)\|EOControl\|DOM\|SaxObjC\|XmlRpc\)\.so\." | wc -l)
	if [ -z "${myWEExtensionsLDD}" -o -z "${myWOExtensionsLDD}" -o -z "${myWEPrototypeLDD}" -o "${myWEExtensionsLDD}" != "9" -o "${myWOExtensionsLDD}" != "10" -o "${myWEPrototypeLDD}" != "9" ]; then
		ewarn
		ewarn "This SOPE installtion is not correctly build. Probably you are using"
		ewarn "LDFLAGS to build SOPE that are not correctly handled in SOPE or you"
		ewarn "have emerged gnustep-base/gnustep-make with LDFLAGS which are"
		ewarn "preventing SOPE to link the needed libraries into it's own binaries."
		ewarn "Please remerge gnustep-base/gnustep-make and/or SOPE with empty LDFLAGS."
		ewarn
		die "SOPE build is not complete (WEExtensions, WOExtensions, WEPrototype)"
	fi
}

src_install() {
	newenvd "${FILESDIR}"/sope.envd 99sope \
		|| die "Failed installing env.d script"
	gnustep-base_src_install
	use apache2 && apache-module_src_install
}

pkg_postinst() {
	gnustep-base_pkg_postinst
	use apache2 && apache-module_pkg_postinst
}
