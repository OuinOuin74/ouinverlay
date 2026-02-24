# Copyright 2025 Gentoo Authors
# SPDX-License-Identifier: GPL-2.0-or-later

EAPI=8

inherit meson vala xdg

DESCRIPTION="A modern compatibility tools manager (GE-Proton, Wine-GE, etc.)"
HOMEPAGE="https://github.com/Vysp3r/ProtonPlus"
SRC_URI="https://github.com/Vysp3r/ProtonPlus/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/ProtonPlus-${PV}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="test"

DEPEND="
	dev-libs/glib:2
	dev-libs/json-glib
	dev-libs/libgee:0.8
	gui-libs/gtk:4
	gui-libs/libadwaita:1[vala]
	net-libs/libsoup:3.0
	app-arch/libarchive:=
"

RDEPEND="${DEPEND}"

BDEPEND="
	$(vala_depend)
	dev-build/meson
"

src_prepare() {
	default
	vala_setup
}

src_compile() {
	meson_src_compile
}

src_install() {
	meson_src_install
}

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}
