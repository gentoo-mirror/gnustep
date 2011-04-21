# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit autotools git

DESCRIPTION="Fork from the last available CVS version of Window Maker"
HOMEPAGE="http://repo.or.cz/w/wmaker-crm.git"
SRC_URI="http://www.windowmaker.info/pub/source/release/WindowMaker-extra-0.1.tar.gz"
EGIT_REPO_URI="git://repo.or.cz/wmaker-crm.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="gif jpeg nls png tiff modelock +vdesktop xinerama"

DEPEND="x11-libs/libXv
	>=x11-libs/libXft-2.1.0
	x11-libs/libXt
	media-libs/fontconfig
	gif? ( >=media-libs/giflib-4.1.0-r3 )
	png? ( >=media-libs/libpng-1.2.1 )
	jpeg? ( virtual/jpeg )
	tiff? ( >=media-libs/tiff-3.6.1-r2 )
	xinerama? ( x11-libs/libXinerama )"
RDEPEND="${DEPEND}
	!x11-wm/windowmaker
	nls? ( >=sys-devel/gettext-0.10.39 )"

src_unpack() {
	# wm-extras
	unpack ${A}

	git_src_unpack
}

src_prepare() {
	for file in "${S}"/WindowMaker/*menu*; do
		if [[ -r $file ]] ; then
			sed -i -e "s:/usr/local/GNUstep/Applications/WPrefs.app:${EPREFIX}/usr/bin/:g;" "$file" || die
			sed -i -e 's:/usr/local/share/WindowMaker:${EPREFIX}/usr/share/WindowMaker:g;' "$file" || die
			sed -i -e 's:/opt/share/WindowMaker:${EPREFIX}/usr/share/WindowMaker:g;' "$file" || die
		fi;
	done;

	eautoreconf || die "eautoreconf failed"
}

src_configure() {
	local myconf

	# image format types
	# xpm is provided by X itself
	myconf="--enable-xpm $(use_enable png) $(use_enable jpeg) $(use_enable gif) $(use_enable tiff)"

	# non required X capabilities
	myconf="${myconf} $(use_enable modelock) $(use_enable xinerama)"

	if use nls; then
		[[ -z $LINGUAS ]] && export LINGUAS="`ls po/*.po | sed 's:po/\(.*\)\.po$:\1:'`"
	else
		myconf="${myconf} --disable-locale"
	fi

	# enable new features, need to be done via defines
	append-flags -DNEWAPPICON

	# default settings with $myconf appended
	econf \
		--sysconfdir="${EPREFIX}"/etc/X11 \
		--with-x \
		--enable-usermenu \
		--with-pixmapdir="${EPREFIX}"/usr/share/pixmaps \
		--with-nlsdir="${EPREFIX}"/usr/share/locale \
		${myconf} || die
	cd ../WindowMaker-extra-0.1
	econf || die "windowmaker-extra: configure has failed"
}

src_compile() {
	emake || die "windowmaker: make has failed"

	# WindowMaker Extra Package (themes and icons)
	cd ../WindowMaker-extra-0.1
	emake || die "windowmaker-extra: make has failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "windowmaker: install has failed."

	dodoc AUTHORS BUGFORM BUGS ChangeLog COPYING* INSTALL* FAQ* \
		  README* NEWS TODO

	# WindowMaker Extra
	cd ../WindowMaker-extra-0.1
	emake DESTDIR="${D}" install || die "windowmaker-extra: install failed"

	newdoc README README.extra

	# create wmaker session shell script
	echo "#!/usr/bin/env bash" > wmaker
	echo "${EPREFIX}/usr/bin/wmaker" >> wmaker
	exeinto /etc/X11/Sessions/
	doexe wmaker

	insinto /etc/X11/dm/Sessions
	doins "${FILESDIR}"/wmaker.desktop
	make_desktop_entry /usr/bin/wmaker
}
