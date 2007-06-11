# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-base

# Eclass for GNUstep Apps, Frameworks, and Bundles build

DEPEND=">=gnustep-base/gnustep-make-2.0
	virtual/gnustep-back"
RDEPEND="$DEPEND
	debug? ( >=sys-devel/gdb-6.0 )"

# If you need to explicitly call some EXPORT_FUNCTIONS,
# use the gnustep-base_* prefixed ones
