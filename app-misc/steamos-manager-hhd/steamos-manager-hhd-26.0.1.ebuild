# Copyright 2024 Gentoo Authors
# SPDX-License-Identifier: GPL-2.0-or-later

EAPI=8

CRATES="
	aho-corasick@1.1.4
	anstyle@1.0.13
	anyhow@1.0.100
	async-broadcast@0.7.2
	async-recursion@1.1.1
	async-trait@0.1.89
	autocfg@1.5.0
	bindgen@0.72.1
	bitflags@2.10.0
	bumpalo@3.19.1
	bytes@1.11.0
	cecd-proxy@0.1.0
	cexpr@0.6.0
	cfg-expr@0.20.5
	cfg-if@1.0.4
	cfg_aliases@0.2.1
	clang-sys@1.8.1
	clap@4.5.53
	clap_builder@4.5.53
	clap_derive@4.5.49
	clap_lex@0.7.6
	concurrent-queue@2.5.0
	config@0.15.19
	const-random@0.1.18
	const-random-macro@0.1.16
	crossbeam-utils@0.8.21
	crunchy@0.2.4
	dlv-list@0.5.2
	either@1.15.0
	endi@1.1.1
	enumflags2@0.7.12
	enumflags2_derive@0.7.12
	equivalent@1.0.2
	errno@0.3.14
	event-listener@5.4.1
	event-listener-strategy@0.5.4
	fastrand@2.3.0
	futures-channel@0.3.31
	futures-core@0.3.31
	futures-executor@0.3.31
	futures-io@0.3.31
	futures-lite@2.6.1
	futures-macro@0.3.31
	futures-sink@0.3.31
	futures-task@0.3.31
	futures-util@0.3.31
	getrandom@0.2.16
	getrandom@0.3.4
	gio@0.21.5
	gio-sys@0.21.5
	glib@0.21.5
	glib-macros@0.21.5
	glib-sys@0.21.5
	glob@0.3.3
	gobject-sys@0.21.5
	hashbrown@0.14.5
	hashbrown@0.16.1
	heck@0.5.0
	hermit-abi@0.3.9
	hex@0.4.3
	indexmap@2.12.1
	inotify@0.11.0
	inotify-sys@0.1.5
	input-linux@0.7.1
	input-linux-sys@0.9.0
	io-lifetimes@1.0.11
	itertools@0.13.0
	itertools@0.14.0
	itoa@1.0.16
	js-sys@0.3.83
	lazy_static@1.5.0
	libc@0.2.178
	libloading@0.8.9
	libudev-sys@0.1.4
	linux-raw-sys@0.11.0
	log@0.4.29
	matchers@0.2.0
	memchr@2.7.6
	memoffset@0.9.1
	minimal-lexical@0.2.1
	mio@1.1.1
	nix@0.29.0
	nix@0.30.1
	nom@7.1.3
	ntapi@0.4.2
	num_enum@0.7.5
	num_enum_derive@0.7.5
	objc2-core-foundation@0.3.2
	objc2-io-kit@0.3.2
	once_cell@1.21.3
	ordered-multimap@0.7.3
	ordered-stream@0.2.0
	parking@2.2.1
	pathdiff@0.2.3
	pin-project-lite@0.2.16
	pin-utils@0.1.0
	pkg-config@0.3.32
	prettyplease@0.2.37
	proc-macro-crate@3.4.0
	proc-macro2@1.0.103
	quick-xml@0.36.2
	quote@1.0.42
	r-efi@5.3.0
	regex@1.12.2
	regex-automata@0.4.13
	regex-syntax@0.8.8
	rust-ini@0.21.3
	rustc-hash@2.1.1
	rustix@1.1.2
	rustversion@1.0.22
	ryu@1.0.21
	serde@1.0.228
	serde_core@1.0.228
	serde_derive@1.0.228
	serde_json@1.0.146
	serde_repr@0.1.20
	serde_spanned@1.0.4
	sharded-slab@0.1.7
	shlex@1.3.0
	signal-hook-registry@1.4.7
	slab@0.4.11
	smallvec@1.15.1
	socket2@0.6.1
	speech-dispatcher@0.16.0
	speech-dispatcher-sys@0.7.0
	static_assertions@1.1.0
	strum@0.27.2
	strum_macros@0.27.2
	syn@2.0.111
	sysinfo@0.37.2
	system-deps@7.0.7
	target-lexicon@0.13.3
	tempfile@3.23.0
	thread_local@1.1.9
	tiny-keccak@2.0.2
	tokio@1.48.0
	tokio-macros@2.6.0
	tokio-stream@0.1.17
	tokio-util@0.7.17
	toml@0.9.10+spec-1.1.0
	toml_datetime@0.7.5+spec-1.1.0
	toml_parser@1.0.6+spec-1.1.0
	toml_writer@1.0.6+spec-1.1.0
	toml_edit@0.23.10+spec-1.0.0
	tracing@0.1.44
	tracing-attributes@0.1.31
	tracing-core@0.1.36
	tracing-subscriber@0.3.22
	udev@0.9.3
	uds_windows@1.1.0
	unicode-ident@1.0.22
	uuid@1.19.0
	version-compare@0.2.1
	wasi@0.11.1+wasi-snapshot-preview1
	wasip2@1.0.1+wasi-0.2.4
	wasm-bindgen@0.2.106
	wasm-bindgen-macro@0.2.106
	wasm-bindgen-macro-support@0.2.106
	wasm-bindgen-shared@0.2.106
	winapi@0.3.9
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	windows@0.61.3
	windows-collections@0.2.0
	windows-core@0.61.2
	windows-future@0.2.1
	windows-implement@0.60.2
	windows-interface@0.59.3
	windows-link@0.1.3
	windows-link@0.2.1
	windows-numerics@0.2.0
	windows-result@0.3.4
	windows-strings@0.4.2
	windows-sys@0.48.0
	windows-sys@0.60.2
	windows-sys@0.61.2
	windows-targets@0.48.5
	windows-targets@0.53.5
	windows-threading@0.1.0
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_gnullvm@0.53.1
	windows_aarch64_msvc@0.48.5
	windows_aarch64_msvc@0.53.1
	windows_i686_gnu@0.48.5
	windows_i686_gnu@0.53.1
	windows_i686_gnullvm@0.53.1
	windows_i686_msvc@0.48.5
	windows_i686_msvc@0.53.1
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnu@0.53.1
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_gnullvm@0.53.1
	windows_x86_64_msvc@0.48.5
	windows_x86_64_msvc@0.53.1
	winnow@0.7.14
	wit-bindgen@0.46.0
	xdg@3.0.0
	zbus@5.12.0
	zbus_macros@5.12.0
	zbus_names@4.2.0
	zbus_xml@5.0.2
	zvariant@5.8.0
	zvariant_derive@5.8.0
	zvariant_utils@3.2.1
"

inherit cargo git-r3

DESCRIPTION="Fork of Valve's steamos-manager with Handheld Daemon (HHD) TDP integration"
HOMEPAGE="https://github.com/hhd-dev/steamos-manager-hhd"

EGIT_REPO_URI="https://gitlab.steamos.cloud/holo/steamos-manager.git"
EGIT_COMMIT="v${PV}"

SRC_URI="${CARGO_CRATE_URIS}"

LICENSE="MIT Apache-2.0 Unicode-DFS-2016"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=sys-power/hhd-4.1
	sys-apps/dbus
	|| ( sys-apps/systemd sys-auth/elogind )
	app-accessibility/speech-dispatcher
"

DEPEND="${RDEPEND}"

BDEPEND="
	|| ( dev-lang/rust-bin dev-lang/rust )
	dev-vcs/git
"

PATCHES=(
	"${FILESDIR}/hhd-ftrace.patch"
	"${FILESDIR}/hhd-gpu.patch"
	"${FILESDIR}/hhd-inputplumber.patch"
	"${FILESDIR}/hhd-power.patch"
	"${FILESDIR}/hhd-root.patch"
	"${FILESDIR}/hhd-session.patch"
	"${FILESDIR}/hhd-steamos-manager-system.patch"
	"${FILESDIR}/hhd-steamos-manager-user.patch"
	"${FILESDIR}/hhd-user.patch"
	"${FILESDIR}/hhd-wifi.patch"
	"${FILESDIR}/no-orca-service.patch"
)

src_unpack() {
	git-r3_src_unpack
	cargo_src_unpack
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
