# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic

# Inner gnustep eclass, should only be inherited directly by gnustep-base packages

# IUSE variables across all GNUstep packages
# "debug": enable code for debugging
# "doc": build and install documentation, if available
IUSE="debug doc"

# packages needed to build any base gnustep package
GNUSTEP_CORE_DEPEND="virtual/libc
	doc? ( virtual/tetex
		=dev-tex/latex2html-2002*
		>=app-text/texi2html-1.64 )"

# Where to install GNUstep
GNUSTEP_PREFIX="/usr/GNUstep"

# Ebuild function overrides
gnustep-base_pkg_setup() {
	if test_version_info 3.3
	then
		strip-unsupported-flags
	elif test_version_info 3.4
	then
		# strict-aliasing is known to break obj-c stuff in gcc-3.4*
		filter-flags -fstrict-aliasing
	fi

	# known to break ObjC (bug 86089)
	filter-flags -fomit-frame-pointer
}

gnustep-base_src_compile() {
	egnustep_env
	if [ -x ./configure ]; then
		econf || die
	fi
	egnustep_make || die
}

gnustep-base_src_install() {
	egnustep_env
	egnustep_install || die
	if use doc ; then
		egnustep_env
		egnustep_doc
	fi
	# Copies "convenience scripts"
	if [ -f "${FILESDIR}/config-${PN}.sh" ]; then
		dodir ${GNUSTEP_SYSTEM_TOOLS}/Gentoo
		exeinto ${GNUSTEP_SYSTEM_TOOLS}/Gentoo
		doexe ${FILESDIR}/config-${PN}.sh
	fi
}

gnustep-base_pkg_postinst() {
	# Informs user about existence of "convenience script"	
	if [ -f "${FILESDIR}/config-${PN}.sh" ]; then
		elog "Make sure to set happy defaults for this package by executing:"
		elog "  ${GNUSTEP_SYSTEM_TOOLS}/Gentoo/config-${PN}.sh"
		elog "as the user you will run the package as."
	fi
}

# Clean/reset an ebuild to the installed GNUstep environment
egnustep_env() {
	# Get additional variables
	GNUSTEP_SH_EXPORT_ALL_VARIABLES="true"

	if [ -f "${GNUSTEP_PREFIX}/System/Library/Makefiles/GNUstep.sh" ] ; then
		# Reset GNUstep variables
		. ${GNUSTEP_PREFIX}/System/Library/Makefiles/GNUstep-reset.sh
		. ${GNUSTEP_PREFIX}/System/Library/Makefiles/GNUstep.sh

		# Needed to run installed GNUstep apps in sandbox
		addpredict "/root/GNUstep"

		# Set up common env vars for make operations
		__GS_MAKE_EVAL=" \
			HOME=\"\${T}\" \
			GNUSTEP_USER_DIR=\"\${T}\" \
			GNUSTEP_USER_DEFAULTS_DIR=\"\${T}\"/Defaults \
			DESTDIR=\"\${D}\" \
			GNUSTEP_INSTALLATION_DOMAIN=SYSTEM \
			TAR_OPTIONS=\"\${TAR_OPTIONS} --no-same-owner\" \
			messages=yes \
			-j1"
			# -j1 is needed as gnustep-make is not parallel-safe

		if ! use debug ; then
			__GS_MAKE_EVAL="${__GS_MAKE_EVAL} debug=no"
		fi

		case ${CHOST} in
			*-linux-gnu|*-solaris*)
				append-ldflags \
					-Wl,-rpath="${GNUSTEP_SYSTEM_LIBRARIES}" \
					-L"${GNUSTEP_SYSTEM_LIBRARIES}"
			;;
			*)
				append-ldflags \
					-L"${GNUSTEP_SYSTEM_LIBRARIES}"
			;;
		esac
	else
		die "gnustep-make not installed!"
	fi
}

# Make utilizing GNUstep Makefiles
egnustep_make() {
	if [ -f ./[mM]akefile -o -f ./GNUmakefile ] ; then
		eval emake ${*} ${__GS_MAKE_EVAL} all || die "package make failed"
	else
		die "no Makefile found"
	fi
}

# Make-install utilizing GNUstep Makefiles
egnustep_install() {
	if [ -f ./[mM]akefile -o -f ./GNUmakefile ] ; then
		eval emake ${*} ${__GS_MAKE_EVAL} install || die "package install failed"
	else
		die "no Makefile found"
	fi
}

# Make and install docs using GNUstep Makefiles
egnustep_doc() {
	if [ -d ./Documentation ]; then
		# Check documentation presence
		cd ${S}/Documentation
		if [ -f ./[mM]akefile -o -f ./GNUmakefile ] ; then
			eval emake ${__GS_MAKE_EVAL} all || die "doc make failed"
			eval emake ${__GS_MAKE_EVAL} install || die "doc install failed"
		fi
		cd ..
	fi
}

EXPORT_FUNCTIONS pkg_setup src_compile src_install pkg_postinst
