# Copyright 1999-2024 Gentoo Authors
# SPDX-License-Identifier: GPL-2.0-only

EAPI=8

inherit git-r3

DESCRIPTION="ScummVM libretro core"
HOMEPAGE="https://github.com/libretro/scummvm"

EGIT_REPO_URI="https://github.com/libretro/scummvm.git"
EGIT_COMMIT="libretro-v${PV}"

DEPS_REPO="https://github.com/libretro/libretro-deps.git"
DEPS_COMMIT="7e6e34f0319f4c7448d72f0e949e76265ccf55a1"

COMMON_REPO="https://github.com/libretro/libretro-common.git"
COMMON_COMMIT="70ed90c42ddea828f53dd1b984c6443ddb39dbd6"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	app-arch/unzip
	app-arch/zip
"

src_unpack() {
	git-r3_src_unpack

	# Cloner les submodules manuellement au bon endroit
	local deps_dir="${S}/backends/platform/libretro/deps"
	mkdir -p "${deps_dir}" || die

	EGIT_REPO_URI="${DEPS_REPO}"
	EGIT_COMMIT="${DEPS_COMMIT}"
	EGIT_CHECKOUT_DIR="${deps_dir}/libretro-deps"
	git-r3_src_unpack

	EGIT_REPO_URI="${COMMON_REPO}"
	EGIT_COMMIT="${COMMON_COMMIT}"
	EGIT_CHECKOUT_DIR="${deps_dir}/libretro-common"
	git-r3_src_unpack
}

src_prepare() {
	default

	# Bypasse la validation git des submodules (incompatible avec le sandbox)
	sed -i \
		-e '/^submodule_test/c\submodule_test = ' \
		-e '/^SUBMODULE_FAILED/c\SUBMODULE_FAILED := ' \
		backends/platform/libretro/dependencies.mk || die

	# Supprime l'écran de démarrage ScummVM
	sed -i 's/splashScreen();/\/\/ splashScreen();/' engines/engine.cpp || die
}

src_configure() {
	true
}

src_compile() {
	emake -C backends/platform/libretro all
}

src_install() {
	insinto /usr/lib/libretro
	doins backends/platform/libretro/scummvm_libretro.so

	local datadir="${WORKDIR}/scummvm-data"
	mkdir -p "${datadir}" || die
	unzip -q backends/platform/libretro/scummvm.zip -d "${datadir}" || die

	insinto /usr/share/retroarch/system/scummvm
	doins -r "${datadir}"/scummvm/.
}
