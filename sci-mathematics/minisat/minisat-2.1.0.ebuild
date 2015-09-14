# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils toolchain-funcs

MY_P="${PN}2-070721"

DESCRIPTION="Small yet efficient SAT solver with reference paper"
HOMEPAGE="http://minisat.se/Main.html"
SRC_URI="http://minisat.se/downloads/${MY_P}.zip
	doc? ( http://minisat.se/downloads/MiniSat.pdf )"

SLOT="0"
KEYWORDS="amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
LICENSE="MIT"

IUSE="debug doc extended-solver"

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}

pkg_setup() {
	if use debug; then
		myconf="d"
		myext="debug"
	else
		myconf="r"
		myext="release"
	fi

	if use extended-solver; then
		mydir="simp"
	else
		mydir="core"
	fi

	tc-export CXX AR

	if has_version ">=sci-mathematics/minisat-2.2.0" ; then
		ewarn ""
		ewarn "The minisat2 2.1 and 2.2 ABIs are not compatible and there"
		ewarn "is currently no slotting.  Please mask it yourself (eg, in"
		ewarn "packages.mask) if you need to use the 2.1x version."
		ewarn ""
	fi
}

src_prepare() {
	sed -i \
		-e "s|-O3|${CFLAGS} ${LDFLAGS}|" \
		-e "s|@\$(CXX)|\$(CXX)|" \
		mtl/template.mk || die
}

src_compile() {
	export MROOT="${S}"
	emake -C ${mydir} "$myconf" || die
	if ! use debug; then
		LIB="${PN}" emake -C ${mydir} lib || die
	else
		LIB="${PN}" emake -C ${mydir} libd || die
	fi
}

src_install() {
	# somewhat brute-force, but so is the build setup...

	insinto /usr/include/${PN}2/mtl
	doins mtl/*.h || die

	insinto /usr/include/${PN}2/core
	doins core/Solver*.h || die

	insinto /usr/include/${PN}2/simp
	doins simp/Simp*.h || die

	if ! use debug; then
		newbin ${mydir}/${PN}_${myext} ${PN} || die
		dolib.a ${mydir}/lib${PN}.a || die
	else
		newbin ${mydir}/${PN}_${myext} ${PN} || die
		newlib.a ${mydir}/lib${PN}_${myext}.a lib${PN}.a || die
	fi

	dodoc README || die
	if use doc; then
		dodoc "${DISTDIR}"/MiniSat.pdf || die
	fi
}

