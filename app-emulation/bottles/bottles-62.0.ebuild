# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11,12,13} )

inherit meson python-single-r1 xdg

DESCRIPTION="Easily manage wine and proton prefix"
HOMEPAGE="https://github.com/bottlesdevs/Bottles"
SRC_URI="https://github.com/bottlesdevs/Bottles/archive/refs/tags/${PV}.tar.gz -> Bottles-${PV}.tar.gz"

S="${WORKDIR}/Bottles-${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gamemode vkd3d vulkan"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	app-arch/cabextract
	app-arch/p7zip
	app-arch/patool
	dev-libs/glib:2
	gnome-base/dconf
	gui-libs/gtk:4
	gui-libs/gtksourceview:5
	gui-libs/libadwaita:1
	dev-libs/libportal[gtk]
	media-gfx/imagemagick
	net-libs/webkit-gtk:6
	x11-apps/xdpyinfo
	x11-themes/hicolor-icon-theme
	$(python_gen_cond_dep '
		dev-python/chardet[${PYTHON_USEDEP}]
		dev-python/markdown[${PYTHON_USEDEP}]
		dev-python/orjson[${PYTHON_USEDEP}]
		dev-python/pathvalidate[${PYTHON_USEDEP}]
		dev-python/pycurl[${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/yara-python[${PYTHON_USEDEP}]
	')
	gamemode? (
		games-util/gamemode
		amd64? ( games-util/gamemode[abi_x86_32] )
	)
	vkd3d? (
		app-emulation/vkd3d-proton
		amd64? ( app-emulation/vkd3d-proton[abi_x86_32] )
	)
	vulkan? (
		media-libs/vulkan-loader
		amd64? ( media-libs/vulkan-loader[abi_x86_32] )
	)
	net-libs/gnutls
	amd64? ( net-libs/gnutls[abi_x86_32] )
"

DEPEND="${RDEPEND}"

BDEPEND="
	dev-util/blueprint-compiler
	dev-build/meson
	dev-build/ninja
"

PATCHES=(
	"${FILESDIR}/remove-flatpak-checks.patch"
)

src_configure() {
	local emesonargs=(
		-Dpython.bytecompile=1
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	python_optimize
}

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}
