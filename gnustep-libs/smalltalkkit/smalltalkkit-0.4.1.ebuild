# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit gnustep-2 toolchain-funcs

S="${WORKDIR}/Etoile-${PV}/Languages/Smalltalk"

SQLITE="sqlite-3.6.2"
DESCRIPTION="Étoilé's Pragmatic Smalltalk, a Smalltalk JIT compiler which generates code binary-compatible with Objective-C"
HOMEPAGE="http://www.etoile-project.org"
SRC_URI="http://download.gna.org/etoile/etoile-${PV}.tar.bz2
	http://www.sqlite.org/${SQLITE}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=">=gnustep-base/gnustep-gui-0.16.0
	>=gnustep-libs/languagekit-${PV}"
RDEPEND="${DEPEND}"


src_prepare() {
	# Copy updated lempar.c
	cp "${WORKDIR}/${SQLITE}/tool/lempar.c" .
	# Use our own lemon in GNUmakefile
	sed -i -e "s#@lemon#@./lemon#" GNUmakefile || die "makefile sed failed"
}

src_compile() {
	# Compile lemon
	$(tc-getCC) ${CPPFLAGS} ${CFLAGS} ${LDFLAGS} \
		"${WORKDIR}/${SQLITE}/tool/lemon.c" -o lemon \
		|| die "lemon compilation failed"
	# Go on with compilation
	gnustep-base_src_compile
}
