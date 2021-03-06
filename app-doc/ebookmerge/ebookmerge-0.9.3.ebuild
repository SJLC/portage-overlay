# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils

DESCRIPTION="Script to manage eBooks in Gentoo"
HOMEPAGE="http://www.josealberto.org/blog/2005/11/28/ebookmerge/
    http://code.google.com/p/htmlhelp/"
SRC_URI="mirror://gentoo/${P}.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm ia64 ~ppc ~ppc64 s390 sh ~x86"
IUSE=""

DEPEND="app-shells/bash"
RDEPEND="${DEPEND}"

S=${WORKDIR}

src_prepare() {
	## update hard-coded URLs and switch to google code upstream
	epatch "${FILESDIR}"/${P}-alt-http.patch
}

src_install() {
	newbin ${P} ebookmerge.sh || die
}

pkg_postinst() {
	elog
	elog "Need help?  Just run:"
	elog "ebookmerge.sh -h"
	elog
	elog "You first must run:"
	elog "ebookmerge.sh -r"
	elog
	elog "Use -m for an alternative mirror."
	elog
}
