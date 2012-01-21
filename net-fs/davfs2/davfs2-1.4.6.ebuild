# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit autotools eutils linux-mod

DESCRIPTION="Linux FUSE (or coda) driver that allows you to mount a WebDAV resource."
HOMEPAGE="http://savannah.nongnu.org/projects/davfs2"
SRC_URI="http://mirror.lihnidos.org/GNU/savannah/davfs2/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""
RESTRICT="test"

DEPEND="dev-libs/libxml2
		net-libs/neon
		sys-libs/zlib"
RDEPEND="${DEPEND}"

pkg_setup() {
	enewgroup davfs2
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.4.5-glibc212.patch
	sed -e "s/^NE_REQUIRE_VERSIONS.*29/& 30/" -i configure.ac
	eautoreconf
}

src_configure() {
	econf --enable-largefile
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS BUGS ChangeLog FAQ NEWS README README.translators THANKS TODO

	# Remove wrong locations created by install.
	rm -fr "${D}/usr/share/doc/davfs2"
	rm -fr "${D}/usr/share/davfs2"

	dodir /var/run/mount.davfs
	keepdir /var/run/mount.davfs
	fowners root:davfs2 /var/run/mount.davfs
	fperms 1774 /var/run/mount.davfs

	# Ignore nobody's home
	cat>>"${D}/etc/davfs2/davfs2.conf"<<EOF

# nobody is a system account in Gentoo
ignore_home nobody
EOF
}

pkg_postinst() {
	elog
	elog "Quick setup:"
	elog "   (as root)"
	elog "   # gpasswd -a \${your_user} davfs2"
	elog "   # echo 'http://path/to/dav /home/\${your_user}/dav davfs rw,user,noauto  0  0' >> /etc/fstab"
	elog "   Edit the config file to disable locks and increase the cache size"
	elog "   (enable the gui_optimize option if using a graphical file manager)"
	elog
	elog "   (as user)"
	elog "   # mkdir -p ~/dav"
	elog "   \$ mount ~/dav"
	elog
}
