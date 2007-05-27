# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-2

MY_P=RemoteDesk-${PV}
DESCRIPTION="GNUstep remote windows access tool"
HOMEPAGE="http://www.nongnu.org/gap/remotedesk/index.html"
SRC_URI="http://savannah.nongnu.org/download/gap/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="${GS_DEPEND}"
RDEPEND="${GS_RDEPEND}
	net-misc/rdesktop"

S=${WORKDIR}/${MY_P}
