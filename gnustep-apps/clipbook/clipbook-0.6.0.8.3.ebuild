# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-apps/clipbook/clipbook-0.6.0.8.3.ebuild,v 1.1 2006/12/05 21:22:14 grobian Exp $

inherit gnustep-2

S=${WORKDIR}/GWorkspace-${PV/0.6.}/${PN/clipb/ClipB}

DESCRIPTION="A clipboard for GNUstep that can hold things for later copy and paste."
HOMEPAGE="http://www.gnustep.it/enrico/gworkspace/"
SRC_URI="http://www.gnustep.it/enrico/gworkspace/gworkspace-${PV/0.6.}.tar.gz"

KEYWORDS="~amd64 ~x86 ~ppc"
LICENSE="GPL-2"
SLOT="0"

IUSE=""
DEPEND="${GS_DEPEND}"
RDEPEND="${GS_RDEPEND}"