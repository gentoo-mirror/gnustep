# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-2

S="${WORKDIR}/Etoile-${PV}/Services/Private/System"

DESCRIPTION="Etoile main system process"
HOMEPAGE="http://www.etoile-project.org"
SRC_URI="http://download.gna.org/etoile/etoile-${PV}.tar.gz"

LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~ppc ~x86"
SLOT="0"

gnustep_config_script() {
	echo "gnustep_set_default NSGlobalDomain NSUseRunningCopy YES"
	echo "gnustep_set_default GWorkspace NoWarnOnQuit YES"
	echo "gnustep_set_default NSGlobalDomain GSWorkspaceApplication \"NotExist.app\""
}
