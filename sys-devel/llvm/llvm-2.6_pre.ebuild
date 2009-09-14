# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: 

inherit eutils toolchain-funcs multilib

DESCRIPTION="Low Level Virtual Machine"
HOMEPAGE="http://llvm.org/"
#SRC_URI="http://llvm.org/releases/${PV}/${P}.tar.gz"
SRC_URI="http://llvm.org/prereleases/${PV/_pre}/${PN}-${PV/_pre}.tar.gz"

LICENSE="LLVM"
# most part of LLVM fall under the "University of Illinois Open Source License"
# which doesn't seem to exist in portage yet, so I call it 'LLVM' for now.  it
# can be read from llvm/LICENSE.TXT in the source tarball.

# the directory llvm/runtime/GCCLibraries/libc contains a stripped down C
# library licensed under the LGPL 2.1 with some third party copyrights, see the
# two LICENCE* files in that directory.  Those parts do *not* get built, so
# we omit LGPL in ${LICENCE}

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

IUSE="debug alltargets"

DEPEND="dev-lang/perl
  >=sys-devel/make-3.79
  >=sys-devel/flex-2.5.4
  >=sys-devel/bison-1.28
  !~sys-devel/bison-1.85
  !~sys-devel/bison-1.875
  >=sys-devel/gcc-3.0
  >=sys-devel/binutils-2.18
        "
RDEPEND="dev-lang/perl"
PDEPEND=""

S=${WORKDIR}/${PN}-${PV/_pre}

pkg_setup() {
	# need to check if the active compiler is ok

	broken_gcc=" 3.2.2 3.2.3 3.3.2 4.1.1 "
	broken_gcc_x86=" 3.4.0 3.4.2 "
	broken_gcc_amd64=" 3.4.6 "

	gcc_vers=$(gcc-fullversion)

	if [[ ${broken_gcc} == *" ${version} "* ]] ; then
		elog "Your version of gcc is known to miscompile llvm."
		elog "Check http://www.llvm.org/docs/GettingStarted.html for"
		elog "possible solutions."
		die "Your currently active version of gcc is known to miscompile llvm" 
	fi

	if [[ ${CHOST} == i*86-* && ${broken_gcc_x86} == *" ${version} "* ]] ; then
		elog "Your version of gcc is known to miscompile llvm on x86"
		elog "architectures.  Check"
		elog "http://www.llvm.org/docs/GettingStarted.html for possible"
		elog "solutions."
		die "Your currently active version of gcc is known to miscompile llvm" 
	fi

	if [[ ${CHOST} == x86_64-* && ${broken_gcc_amd64} == *" ${version} "* ]];
	then
		 elog "Your version of gcc is known to miscompile llvm in amd64"
		 elog "architectures.  Check"
		 elog "http://www.llvm.org/docs/GettingStarted.html for possible"
		 elog "solutions."
		die "Your currently active version of gcc is known to miscompile llvm" 
	 fi
}

src_compile() {
	# unfortunately ./configure won't listen to --mandir and the-like, so take
	# care of this.
	einfo "Fixing install dirs"
	sed -e 's,^PROJ_docsdir.*,PROJ_docsdir := $(DESTDIR)$(PROJ_prefix)/share/doc/'${PF}, \
		-e 's,^PROJ_etcdir.*,PROJ_etcdir := $(DESTDIR)/etc/llvm,' \
		-i Makefile.config.in || die "sed failed"

	# fix gccld and gccas, which would otherwise point to the build directory
	einfo "Fixing gccld and gccas"
	sed -e 's,^TOOLDIR.*,TOOLDIR=/usr/bin,' \
		-i tools/gccld/gccld.sh tools/gccas/gccas.sh || die "sed failed"

	# all binaries get rpath'd to a dir in the temporary tree that doesn't
	# contain libraries anyway; can safely remove those to avoid QA warnings
	# (the exception would be if we build shared libraries, which we don't)
	einfo "Fixing rpath"
	sed -e 's,-rpath \$(ToolDir),,g' -i Makefile.rules || die "sed failed"

	epatch "${FILESDIR}"/llvm-2.3-dont-build-hello.patch
	epatch "${FILESDIR}"/llvm-2.3-disable-strip.patch
	local CONF_FLAGS=""

	if use debug; then
		CONF_FLAGS="${CONF_FLAGS} --disable-optimized"
		einfo "Note: Compiling LLVM in debug mode will create huge and slow binaries"
		# ...and you probably shouldn't use tmpfs, unless it can hold 900MB
	else
		CONF_FLAGS="${CONF_FLAGS} \
			--enable-optimized \
			--disable-assertions \
			--disable-expensive-checks"
	fi

	if use alltargets; then
		CONF_FLAGS="${CONF_FLAGS} --enable-targets=all"
	else
		CONF_FLAGS="${CONF_FLAGS} --enable-targets=host-only"
	fi

	if use amd64; then
		CONF_FLAGS="${CONF_FLAGS} --enable-pic"
	fi

	# things would be built differently depending on whether llvm-gcc is
	# already present on the system or not. When not bootstapping we make sure
	# that no llvm-gcc is found
	local LLVM_GCC_DIR=/dev/null 
	local LLVM_GCC_DRIVER=nope ; local LLVM_GPP_DRIVER=nope
	if has_version sys-devel/llvm-gcc; then
		# when bootstapping, make sure configure will find installed llvm-gcc
		if [[ -z ${LLVM_GCC_PREFIX} ]] ; then
			local here=/usr/$(get_libdir)/llvm-gcc/
			# this is scary
			local LLVM_GCC_PREFIX=${here}$(ls $here | head -1)
		fi

		[[ -z $(ls ${LLVM_GCC_PREFIX}/bin/*-gcc 2> /dev/null) ]] && \
			die "failed to find installed llvm-gcc, LLVM_GCC_PREFIX=${LLVM_GCC_PREFIX}"

		for driver in ${LLVM_GCC_PREFIX}/bin/*-gcc ; do
			LLVM_GCC_DRIVER=${driver##*/}
			break;
		done

		LLVM_GCC_DIR=${LLVM_GCC_PREFIX}

		[[ -z ${LLVM_GCC_DRIVER} ]] && \
			die "failed to find installed llvm-gcc, LLVM_GCC_PREFIX=${LLVM_GCC_PREFIX}"

		einfo "using $LLVM_GCC_DRIVER residing in $LLVM_GCC_DIR"
		LLVM_GPP_DRIVER=${LLVM_GCC_DRIVER/%-gcc/-g++}
	fi

	CONF_FLAGS="${CONF_FLAGS} \
		--with-llvmgccdir=${LLVM_GCC_DIR} \
		--with-llvmgcc=${LLVM_GCC_DRIVER} \
		--with-llvmgxx=${LLVM_GPP_DRIVER}"

	econf ${CONF_FLAGS} || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"

	# don't install html.tar.gz in /usr/share/doc -- FIXME: USE=doc
	einfo "Removing archived html documentation"
	rm "${D}"/usr/share/doc/${PF}/*tar.gz \
		|| die "no such file ${D}/usr/share/doc/${PF}/*tar.gz"

	# tblgen does not get installed, so remove its man page.  
	# llvmgcc.1 and llvmgxx.1 are present here for unknown reasons. But, since 
	# llvm-gcc installs bad man pages, keep the 2 files alive
	rm "${D}"/usr/share/man/man1/tblgen.1
}
