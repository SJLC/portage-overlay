# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

ETYPE="sources"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="7"
K_DEBLOB_AVAILABLE="1"

inherit kernel-2
detect_version
detect_arch

LED_PATCH="linux-${PV}-ppc_pata_led.patch"
#UNIPATCH_LIST="${LED_PATCH}"

DESCRIPTION="Full sources including the Gentoo patchset for the ${KV_MAJOR}.${KV_MINOR} kernel tree"
HOMEPAGE="http://dev.gentoo.org/~mpagano/genpatches"
SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI}"

KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86"
IUSE="deblob"

EPATCH_OPTS="-Np1 -F 3"

src_prepare(){
	epatch "${FILESDIR}"/"${LED_PATCH}"
}

pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "For more info on this patchset, and how to report problems, see:"
	einfo "${HOMEPAGE}"
}

pkg_postrm() {
	kernel-2_pkg_postrm
}