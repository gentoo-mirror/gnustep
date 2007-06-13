# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-2

S=${WORKDIR}/${P/projectc/ProjectC}

DESCRIPTION="An IDE for GNUstep."
HOMEPAGE="http://www.gnustep.org/experience/ProjectCenter.html"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/dev-apps/${P/projectc/ProjectC}.tar.gz"

KEYWORDS="~amd64 ~x86 ~ppc"
LICENSE="GPL-2"
SLOT="0"

RDEPEND=">=sys-devel/gdb-6.0"