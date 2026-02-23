# Copyright 1999-2024 Gentoo Authors
# SPDX-License-Identifier: GPL-2.0-only

EAPI=8

inherit git-r3

DESCRIPTION="Fast MegaDrive/MegaCD/32X libretro core"
HOMEPAGE="https://github.com/libretro/picodrive"
EGIT_REPO_URI="https://github.com/notaz/picodrive.git"

LICENSE="MAME"
SLOT="0"

src_prepare() {
	default
}

src_configure() {
	true
}

src_compile() {
	emake -f Makefile.libretro ARCH=x86_64
}

src_install() {
	insinto /usr/lib/libretro
	doins picodrive_libretro.so
}
