# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

DESCRIPTION="PlayStation 3 emulator"
HOMEPAGE="https://rpcs3.net/"
EGIT_REPO_URI="https://github.com/RPCS3/rpcs3"
LICENSE="GPL-2"
SLOT="0"

IUSE="alsa +faudio joystick +llvm pulseaudio sdl vulkan"

RDEPEND="
	dev-libs/flatbuffers
	dev-libs/libusb
	>=dev-libs/pugixml-1.15
	dev-libs/xxhash
	>=dev-qt/qtbase-6.5.2[dbus,gui,widgets]
	>=dev-qt/qtdeclarative-6.5.2:6
	>=dev-qt/qtmultimedia-6.5.2:6
	>=dev-qt/qtsvg-6.5.2:6
	media-libs/glew:0
	media-libs/libpng:*
	media-libs/openal
	media-video/ffmpeg:=
	virtual/zlib
	virtual/opengl
	x11-libs/libX11
	alsa? ( media-libs/alsa-lib )
	faudio? ( app-emulation/faudio )
	joystick? ( dev-libs/libevdev )
	pulseaudio? ( media-libs/libpulse )
	sdl? ( media-libs/libsdl3 )
	vulkan? ( media-libs/vulkan-loader )
"

DEPEND="${RDEPEND}
	>=sys-devel/gcc-9
"

EGIT_SUBMODULES=(
	"*"
	"-3rdparty/FAudio"
	"-3rdparty/curl"
	"-3rdparty/libpng"
	"-3rdparty/libsdl-org/SDL"
	"-3rdparty/libusb"
	"-3rdparty/llvm/llvm"
	"-3rdparty/pugixml"
	"-3rdparty/zlib"
	"-rpcs3-ffmpeg"
	"-3rdparty/xxHash"
	"-3rdparty/flatbuffers"
)

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_LLVM=OFF
		-DBUILD_SHARED_LIBS=OFF
		-DCMAKE_CXX_FLAGS="${CXXFLAGS}"
		-DCMAKE_C_FLAGS="${CFLAGS}"
		-DUSE_ALSA=$(usex alsa ON OFF)
		-DUSE_DISCORD_RPC=OFF
		-DUSE_FAUDIO=$(usex faudio)
		-DUSE_SYSTEM_FAUDIO=$(usex faudio)
		-DUSE_LIBEVDEV=$(usex joystick ON OFF)
		-DUSE_PULSE=$(usex pulseaudio ON OFF)
		-DUSE_SDL=$(usex sdl)
		-DUSE_SYSTEM_CURL=ON
		-DUSE_SYSTEM_FFMPEG=ON
		-DUSE_SYSTEM_LIBPNG=ON
		-DUSE_SYSTEM_LIBUSB=ON
		-DUSE_SYSTEM_PUGIXML=ON
		-DUSE_SYSTEM_SDL=ON
		-DUSE_SYSTEM_ZLIB=ON
		-DUSE_VULKAN=$(usex vulkan ON OFF)
		-DWITH_LLVM=$(usex llvm ON OFF)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
}
