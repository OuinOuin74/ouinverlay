# Copyright 2024 Gentoo Authors
# SPDX-License-Identifier: GPL-2.0-or-later

EAPI=8

inherit desktop xdg

ELECTRON_VER="40.4.1"

DESCRIPTION="Configurator interface for Handheld Daemon"
HOMEPAGE="https://hhd.dev"
SRC_URI="
	https://github.com/hhd-dev/hhd-ui/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/electron/electron/releases/download/v${ELECTRON_VER}/electron-v${ELECTRON_VER}-linux-x64.zip
		-> electron-${ELECTRON_VER}-linux-x64.zip
	https://github.com/OuinOuin74/hhd-overlay/releases/download/hhd-ui-${PV}-deps/hhd-ui-${PV}-node_modules.tar.gz
"

S="${WORKDIR}/hhd-ui-${PV}"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="strip"

PDEPEND="
	sys-power/hhd
"

BDEPEND="
	net-libs/nodejs[npm]
	app-arch/unzip
"

src_unpack() {
	unpack "${P}.tar.gz"

	cd "${S}" || die
	tar xzf "${DISTDIR}/hhd-ui-${PV}-node_modules.tar.gz" || die

	mkdir -p "${WORKDIR}/electron" || die
	cd "${WORKDIR}/electron" || die
	unpack "electron-${ELECTRON_VER}-linux-x64.zip"
}

src_prepare() {
	default
	sed -i "s|electron@electronversion@|/usr/lib/hhd-ui/electron/electron|" \
		"./pkg/hhd-ui.sh" || die
	sed -i "s|\"electron\": \"[^\"]*\"|\"electron\": \"^${ELECTRON_VER}\"|" \
		./electron/package.json || die
	sed -i "s|\"version\": \"[0-9.]*\"|\"version\": \"${ELECTRON_VER}\"|" \
		./electron/node_modules/electron/package.json || die
	sed -i "s|\"version\": \"1.0.0\"|\"version\": \"${PV}\"|" \
		./electron/package.json || die
	sed -i "s|Gaming;||" "./pkg/hhd-ui.desktop" || die
}

src_compile() {
	export ELECTRON_CACHE="${WORKDIR}/electron-cache"
	mkdir -p "${ELECTRON_CACHE}" || die
	cp "${DISTDIR}/electron-${ELECTRON_VER}-linux-x64.zip" \
		"${ELECTRON_CACHE}/electron-v${ELECTRON_VER}-linux-x64.zip" || die
	export ELECTRON_OVERRIDE_DIST_PATH="${WORKDIR}/electron"

	npm run electron-build || die "electron-build failed"

	pushd electron || die
	# Forcer le format dir uniquement, pas AppImage
	npx electron-builder build --linux dir || die "electron npm build failed"
	popd || die
}

src_install() {
	pushd electron || die
	insinto /usr/lib/hhd-ui
	doins ./dist/linux-unpacked/resources/app.asar
	doins ./package.json
	popd || die

	insinto /usr/lib/hhd-ui/electron
	doins -r "${WORKDIR}/electron/."
	fperms 0755 /usr/lib/hhd-ui/electron/electron
	fperms 0755 /usr/lib/hhd-ui/electron/chrome_crashpad_handler
	fperms 4755 /usr/lib/hhd-ui/electron/chrome-sandbox

	insinto /usr/share/applications/hhd-ui
	doins ./art/library_capsule.png
	doins ./art/library_hero.png
	doins ./art/library_logo.png
	doins ./art/main_capsule.png
	doins ./art/icon.png

	domenu ./pkg/hhd-ui.desktop
	exeinto /usr/bin
	newexe ./pkg/hhd-ui.sh hhd-ui
}

pkg_postinst() {
	xdg_pkg_postinst
	elog "hhd-ui uses Electron ${ELECTRON_VER} bundled in /usr/lib/hhd-ui/electron."
	elog ""
	elog "For Handheld Daemon (optional):"
	elog "  emerge --ask sys-power/hhd"
}
