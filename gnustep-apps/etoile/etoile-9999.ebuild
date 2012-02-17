# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit gnustep-2 subversion

DESCRIPTION="Meta-package for the Etoile desktop environment"
HOMEPAGE="http://www.etoile-project.org"
SRC_URI=""
ESVN_REPO_URI="svn://svn.gna.org/svn/etoile/trunk/Etoile"

LICENSE="as-is"
KEYWORDS=""
SLOT="0"
IUSE=""

RDEPEND="gnustep-base/gnustep-make[libobjc2]
   >=virtual/gnustep-back-0.22.0"
DEPEND="${RDEPEND}"
