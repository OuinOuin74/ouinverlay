# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Steam Big Picture session based on gamescope"
HOMEPAGE="https://github.com/bazzite-org/gamescope-session-steam"
EGIT_REPO_URI="https://github.com/bazzite-org/gamescope-session-steam.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""

RDEPEND="
	gui-wm/gamescope
	games-util/gamescope-session
	media-fonts/dejavu
"

src_install() {
	insinto /usr
	doins -r usr/*

	# Restore executable permissions on scripts in /usr/bin
	local f
	for f in "${ED}"/usr/bin/*; do
		[[ -f "${f}" ]] && fperms 0755 "/usr/bin/$(basename "${f}")"
	done

	# Font workaround for initial Big Picture mode startup
	dosym -r /usr/share/fonts/dejavu/DejaVuSans.ttf \
		/usr/share/fonts/truetype/ttf-dejavu/DejaVuSans.ttf
}
