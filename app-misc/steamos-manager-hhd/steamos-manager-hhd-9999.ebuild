# Copyright 2024 Gentoo Authors
# SPDX-License-Identifier: GPL-2.0-or-later

EAPI=8

inherit cargo git-r3

DESCRIPTION="Fork of Valve's steamos-manager with Handheld Daemon (HHD) TDP integration"
HOMEPAGE="https://github.com/hhd-dev/steamos-manager-hhd"

EGIT_REPO_URI="https://github.com/hhd-dev/steamos-manager-hhd.git"
EGIT_BRANCH="master"

LICENSE="MIT Apache-2.0 Unicode-DFS-2016"
SLOT="0"
KEYWORDS=""

RDEPEND="
	>=sys-power/hhd-4.1
	>=sys-apps/inputplumber-0.74
	sys-apps/dbus
	|| ( sys-apps/systemd sys-auth/elogind )
"

DEPEND="${RDEPEND}"

BDEPEND="
	|| ( dev-lang/rust-bin dev-lang/rust )
	llvm-core/clang
	dev-vcs/git
"

PATCHES=(
	"${FILESDIR}/no-orca-service.patch"
)

src_unpack() {
	git-r3_src_unpack
	cargo_live_src_unpack
}

src_prepare() {
	default
}

src_compile() {
	emake build
}

src_install() {
	emake install DESTDIR="${D}"
}
