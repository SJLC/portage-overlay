# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-mobilephone/heimdall/heimdall-1.4.0.ebuild,v 1.1 2013/08/18 20:56:03 floppym Exp $

EAPI=5

inherit autotools eutils qt4-r2 udev

if [[ ${PV} != 9999 ]]; then
	SRC_URI="https://github.com/Benjamin-Dobell/Heimdall/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/Heimdall-${PV}"
else
	inherit git-2
	EGIT_REPO_URI="git://github.com/Benjamin-Dobell/Heimdall.git
		https://github.com/Benjamin-Dobell/Heimdall.git"
fi

DESCRIPTION="Tool suite used to flash firmware onto Samsung Galaxy S devices"
HOMEPAGE="http://www.glassechidna.com.au/products/heimdall/"

LICENSE="MIT"
SLOT="0"
IUSE="qt4"

RDEPEND="qt4? ( dev-qt/qtcore:4= dev-qt/qtgui:4= )"

DEPEND="${RDEPEND}
	dev-libs/libusbx:1=
	virtual/pkgconfig"

src_prepare() {
	rm -r libusbx-1.0 || die
	cd "${S}/heimdall" || die
	edos2unix configure.ac Makefile.am || die
	sed -i -e /sudo/d Makefile.am || die
	eautoreconf
}

src_configure() {
	cd "${S}/libpit" || die
	econf

	cd "${S}/heimdall" || die
	econf

	if use qt4; then
		cd "${S}/heimdall-frontend" || die
		eqmake4 heimdall-frontend.pro OUTPUTDIR=/usr/bin || die
	fi
}

src_compile() {
	emake -C libpit
	emake -C heimdall
	use qt4 && emake -C heimdall-frontend
}

src_install() {
	emake -C heimdall DESTDIR="${D}" udevrulesdir="$(get_udevdir)/rules.d" install
	dodoc Linux/README
	use qt4 && emake -C heimdall-frontend INSTALL_ROOT="${D}" install
}
