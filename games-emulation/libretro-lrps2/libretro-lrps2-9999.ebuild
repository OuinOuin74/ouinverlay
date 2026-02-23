# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

DESCRIPTION="Sony PlayStation 2 libretro core (fork of PCSX2)"
HOMEPAGE="https://github.com/libretro/ps2"
EGIT_REPO_URI="https://github.com/libretro/ps2.git"

LICENSE="GPL-3+"
SLOT="0"

BDEPEND="
	dev-build/cmake
	dev-vcs/git
"

src_unpack() {
	git-r3_src_unpack
}

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release
		-DCMAKE_C_FLAGS_RELEASE="-DNDEBUG"
		-DCMAKE_CXX_FLAGS_RELEASE="-DNDEBUG"
		-DCMAKE_POLICY_VERSION_MINIMUM=3.5
		-DBUILD_SHARED_LIBS=OFF
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	insinto /usr/lib/libretro
	doins "${BUILD_DIR}/bin/pcsx2_libretro.so"
}
