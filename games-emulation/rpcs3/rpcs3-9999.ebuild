# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

DESCRIPTION="PlayStation 3 emulator"
HOMEPAGE="https://rpcs3.net/"
EGIT_REPO_URI="https://github.com/RPCS3/rpcs3"
LICENSE="GPL-2"
SLOT="0"

IUSE="
	+faudio
	+gamemode
	joystick
	+native
	sdl
	+vulkan
"

RDEPEND="
	app-arch/zstd:=
	dev-libs/flatbuffers
	dev-libs/hidapi
	dev-libs/libusb:1
	dev-libs/pugixml
	dev-libs/xxhash
	>=dev-qt/qtbase-6.5.2:6[dbus,gui,widgets]
	>=dev-qt/qtdeclarative-6.5.2:6
	>=dev-qt/qtmultimedia-6.5.2:6
	>=dev-qt/qtsvg-6.5.2:6
	dev-util/glslang:=
	media-libs/cubeb
	media-libs/glew:0
	media-libs/libpng:*
	media-libs/openal
	media-libs/opencv:=
	media-libs/rtmidi
	media-video/ffmpeg:=
	net-libs/miniupnpc:=
	net-misc/curl
	virtual/opengl
	virtual/zlib
	x11-libs/libX11
	faudio?   ( app-emulation/faudio )
	gamemode? ( games-util/gamemode )
	joystick? ( dev-libs/libevdev )
	sdl?      ( media-libs/libsdl3:= )
	vulkan?   ( media-libs/vulkan-loader )
"

DEPEND="${RDEPEND}"

BDEPEND="
	|| (
		>=sys-devel/gcc-13
		>=llvm-core/clang-19
	)
	virtual/pkgconfig
"

EGIT_SUBMODULES=(
	"*"
	"-3rdparty/curl"
	"-3rdparty/FAudio"
	"-3rdparty/flatbuffers"
	"-3rdparty/glslang/glslang"
	"-3rdparty/hidapi/hidapi"
	"-3rdparty/libsdl-org/SDL"
	"-3rdparty/libusb"
	"-3rdparty/miniupnp/miniupnp"
	"-3rdparty/OpenAL/openal-soft"
	"-3rdparty/opencv/opencv"
	"-3rdparty/pugixml"
	"-3rdparty/rtmidi/rtmidi"
	"-3rdparty/wolfssl/wolfssl"
	"-3rdparty/xxHash"
	"-3rdparty/zlib"
	"-3rdparty/zstd/zstd"
	"-3rdparty/cubeb/cubeb"
	"-rpcs3-ffmpeg"
	"-3rdparty/discord-rpc/discord-rpc"
	"-3rdparty/feralinteractive/feralinteractive"
	"-3rdparty/llvm/llvm"
)

pkg_setup() {
	use gamemode || EGIT_SUBMODULES+=( "3rdparty/feralinteractive/feralinteractive" )
}

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		# --- Build ---
		-DBUILD_LLVM=OFF
		-DBUILD_SHARED_LIBS=OFF
		-DCMAKE_BUILD_TYPE=Release
		-DUSE_NATIVE_INSTRUCTIONS=$(usex native ON OFF)
		-DUSE_PRECOMPILED_HEADERS=ON
		-DWITH_LLVM=ON
		# --- USE flags ---
		-DUSE_DISCORD_RPC=OFF
		-DUSE_FAUDIO=$(usex faudio ON OFF)
		-DUSE_GAMEMODE=$(usex gamemode ON OFF)
		-DUSE_LIBEVDEV=$(usex joystick ON OFF)
		-DUSE_SDL=$(usex sdl ON OFF)
		-DUSE_VULKAN=$(usex vulkan ON OFF)
		# --- System libs ---
		-DUSE_SYSTEM_CUBEB=ON
		-DUSE_SYSTEM_CURL=ON
		-DUSE_SYSTEM_FAUDIO=$(usex faudio ON OFF)
		-DUSE_SYSTEM_FFMPEG=ON
		-DUSE_SYSTEM_GLSLANG=ON
		-DUSE_SYSTEM_HIDAPI=ON
		-DUSE_SYSTEM_LIBPNG=ON
		-DUSE_SYSTEM_LIBUSB=ON
		-DUSE_SYSTEM_MINIUPNPC=ON
		-DUSE_SYSTEM_OPENAL=ON
		-DUSE_SYSTEM_OPENCV=ON
		-DUSE_SYSTEM_PUGIXML=ON
		-DUSE_SYSTEM_RTMIDI=ON
		-DUSE_SYSTEM_SDL=$(usex sdl ON OFF)
		-DUSE_SYSTEM_WOLFSSL=OFF
		-DUSE_SYSTEM_ZLIB=ON
		-DUSE_SYSTEM_ZSTD=ON
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
}

pkg_postinst() {
	elog "RPCS3 requires PlayStation 3 firmware files to work."
	elog "Download the official firmware from:"
	elog "  https://www.playstation.com/en-us/support/hardware/ps3/system-software/"
	elog "then install it via: File → Install PS3 Firmware"
}
