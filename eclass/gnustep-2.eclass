# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-base

# Eclass for GNUstep Apps, Frameworks, and Bundles build

DEPEND=">=gnustep-base/gnustep-make-2.0
	virtual/gnustep-back"
RDEPEND="$DEPEND
	debug? ( >=sys-devel/gdb-6.0 )"

gnustep-2_pkg_setup() {
	gnustep-base_pkg_setup
}

gnustep-2_src_compile() {
	gnustep-base_src_compile
}

gnustep-2_src_install() {
	gnustep-base_src_install
}

gnustep-2_pkg_postinst() {
	gnustep-base_pkg_postinst
}

EXPORT_FUNCTIONS pkg_setup src_compile src_install pkg_postinst
