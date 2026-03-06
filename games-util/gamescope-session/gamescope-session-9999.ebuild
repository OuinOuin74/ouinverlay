# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Common gamescope session files"
HOMEPAGE="https://github.com/OpenGamingCollective/gamescope-session"
EGIT_REPO_URI="https://github.com/OpenGamingCollective/gamescope-session.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""

RDEPEND="
	gui-wm/gamescope
"
src_install() {
	insinto /usr
	doins -r usr/*

	# Restore executable permissions on scripts in /usr/bin
	local f
	for f in "${ED}"/usr/bin/*; do
		[[ -f "${f}" ]] && fperms 0755 "/usr/bin/$(basename "${f}")"
	done

	# Restore executable permissions on scripts in /usr/share/gamescope-session-plus
	local s
	for s in "${ED}"/usr/share/gamescope-session-plus/*; do
		[[ -f "${s}" ]] && fperms 0755 "/usr/share/gamescope-session-plus/$(basename "${s}")"
	done

	dodoc README.md
}
