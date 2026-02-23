# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..14} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 systemd udev

DESCRIPTION="Handheld Daemon. A tool for managing the quirks of handheld devices."
HOMEPAGE="https://github.com/hhd-dev/hhd"
SRC_URI="https://github.com/hhd-dev/hhd/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/hhd-${PV}"
LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/evdev[${PYTHON_USEDEP}]
	dev-python/rich[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/python-xlib[${PYTHON_USEDEP}]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pyserial[${PYTHON_USEDEP}]
	dev-python/pyroute2[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	sys-process/lsof
	virtual/libusb:1
	sys-power/acpi_call
"

DEPEND="${RDEPEND}
	dev-python/babel[${PYTHON_USEDEP}]
	dev-python/build[${PYTHON_USEDEP}]
	dev-python/installer[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
"

src_compile() {
	einfo "Compiling translations (ignoring upstream placeholder errors)..."
	pybabel compile -D hhd -d ./i18n || ewarn "hhd: some translations skipped"
	pybabel compile -D adjustor -d ./i18n || ewarn "adjustor: some translations skipped"
	mkdir -p src/hhd/i18n || die
	cp -rf i18n/* src/hhd/i18n/ || die
	distutils-r1_src_compile
}

src_install() {
	distutils-r1_src_install
	udev_dorules usr/lib/udev/rules.d/83-hhd.rules
	insinto /usr/lib/udev/hwdb.d
	doins usr/lib/udev/hwdb.d/83-hhd.hwdb
	systemd_dounit usr/lib/systemd/system/hhd.service
	systemd_dounit usr/lib/systemd/system/hhd@.service
}

pkg_postinst() {
	udev_reload
	ewarn "After installation, you may need to reboot or reload udev rules:"
	ewarn "  udevadm control --reload-rules && udevadm trigger"
}
