# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils gnome2 flag-o-matic

DESCRIPTION="GNOME CUPS Printer Management Interface"
HOMEPAGE="http://www.gnome.org/"

SRC_URI="http://ftp.gnome.org/pub/GNOME/sources/${PN}/${PV}/${P}.tar.bz2
	mirror://gentoo/${PN}-patches-${PV}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 ~sh sparc x86 ~x86-fbsd"
IUSE=""

COMMON=">=x11-libs/gtk+-2.3.1
	>=dev-libs/glib-2.3.1
	>=gnome-base/libgnome-2
	>=gnome-base/libgnomeui-2.2
	>=gnome-base/libglade-2
	>=gnome-base/libbonobo-2
	>=net-print/libgnomecups-0.2.3
	gnome-base/gnome-keyring"

RDEPEND="${COMMON}
	x11-libs/gksu"

DEPEND="${COMMON}
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.28"

DOCS="ChangeLog NEWS README"

src_unpack() {
	gnome2_src_unpack

	rm "${WORKDIR}"/patches/140_all_ui_tooltip.patch || \
		die "removing patch failed"

	export	EPATCH_SOURCE="${WORKDIR}/patches" \
		EPATCH_SUFFIX="patch" \
		EPATCH_MULTI_MSG="Applying Ubuntu patches (enhancements) ..."
	epatch

	cd "${S}"
	elog "Fixing buffer issues (see bug #259045) ..."
	sed -i -e "s:sprintf:snprintf:g" \
	    libgnomecups/gnome-cups-ui-connection.c \
	    || die "sed failed"
}

src_install() {
	gnome2_src_install
	#Debian-specific.
	rm "${D}"/usr/sbin/gnome-cups-switch
}
