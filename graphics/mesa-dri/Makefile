PORTNAME=	mesa-dri
PORTVERSION=	${MESAVERSION}
PORTREVISION=	2
CATEGORIES=	graphics

COMMENT=	OpenGL hardware acceleration drivers for DRI2+
WWW=		https://www.mesa3d.org/

BUILD_DEPENDS+=	${PYTHON_PKGNAMEPREFIX}ply>0:devel/py-ply@${PY_FLAVOR} \
	${PYTHON_PKGNAMEPREFIX}pyyaml>0:devel/py-pyyaml@${PY_FLAVOR} \
	libdisplay-info>0:sysutils/libdisplay-info \

USES+=		llvm:noexport

OPTIONS_DEFINE=		ZSTD GLVND
OPTIONS_GROUP=		GALLIUM PLATFORM VULKAN
OPTIONS_DEFAULT=	WAYLAND X11 ZSTD
OPTIONS_SUB=		yes

GLVND_DESC=		Use system vendor-neutral OpenGL dispatch lib
GLVND_RUN_DEPENDS=	libglvnd>0:graphics/libglvnd
GLVND_MESON_ENABLED=	glvnd

ZSTD_DESC=		Use ZSTD for shader cache
ZSTD_LIB_DEPENDS=	libzstd.so:archivers/zstd
ZSTD_MESON_ENABLED=	zstd

OPTIONS_GROUP_PLATFORM=	X11 WAYLAND
X11_DESC=		Enable X11 support for GBM/EGL
WAYLAND_DESC=		Enable Wayland support for GBM/EGL and Vulkan

OPTIONS_GROUP_GALLIUM=	CROCUS ETNAVIV FREEDRENO I915 IRIS LIMA LLVMPIPE \
			NOUVEAU PANFROST R300 R600 RADEONSI SVGA SWRAST \
			TEGRA VIRGL V3D VC4 ZINK

GALLIUM_DESC=		Unified OpenGL drivers
CROCUS_DESC=		Intel GPU Gen4 (Broadwater) to Gen7 (Haswell)
ETNAVIV_DESC=		Vivante GCxxx series GPUs
FREEDRENO_DESC=		Qualcomm Adreno GPUs
I915_DESC=		Intel GPU Gen3 (Grantsdale to Pineview)
IRIS_DESC=		Intel GPU Gen8 (Broadwell) and newer
LIMA_DESC=		Mali Utgard (Mali-4xx) embedded GPUs from ARM
LLVMPIPE_DESC=		Software rasterizer
NOUVEAU_DESC=		Open-source driver for Nvidia video cards and Tegra family of SoCs
PANFROST_DESC=		ARM Midgard and Bifrost
R300_DESC=		AMD/ATI R300, R400 and R500
R600_DESC=		AMD/ATI R600, R700, Evergreen, Northern Islands
RADEONSI_DESC=		AMD/ATI Southern Islands and newer
SVGA_DESC=		VMWare Virtual GPU
SWRAST_DESC=		Software reference implementation for the Gallium3D framework
TEGRA_DESC=		NVIDIA Tegra ARM SoCs
VIRGL_DESC=		Virtual Machine
V3D_DESC=		Broadcom VideoCore V GPUs (Raspberry Pi)
VC4_DESC=		Broadcom's VideoCore IV GPU (Raspberry Pi 1/2/3)
ZINK_DESC=		OpenGL on top of Khronos’ Vulkan API
OPTIONS_EXCLUDE+=	${ARCH:Narmv7:C/.+/VC4/}
OPTIONS_EXCLUDE+=	${ARCH:Naarch64:C/.+/V3D FREEDRENO ETNAVIV TEGRA LIMA PANFROST/}
OPTIONS_EXCLUDE+=	${ARCH:Namd64:Ni386:Nx86_64:C/.+/R300 R600 RADEONSI IRIS CROCUS I915/}
MESON_ARGS+=            -Dgallium-drivers=${GALLIUM_DRIVERS:ts,}
. for _gd in ${OPTIONS_GROUP_GALLIUM}
OPTIONS_DEFAULT+=       ${_gd:tl}
${_gd}_VARS+=           GALLIUM_DRIVERS+=${_gd:tl}
. endfor

OPTIONS_GROUP_VULKAN=	ANV FREEDRENO INTEL_HASVK NOUVEAU PANFROST RADV SWRAST_VK
VULKAN_DESC=		Vulkan drivers
RADV_DESC=		AMD GPU support with Khronos' Vulkan API
RADV_BUILD_DEPENDS=	glslangValidator:graphics/glslang
FREEDRENO_DESC=		Qualcomm Adreno GPUs
ANV_DESC=		Intel Mesa Vulkan (ANV)
INTEL_HASVK_DESC=	Forked open-source Intel driver for Ivy Bridge/Haswell
NOUVEAU_DESC=		Open-source driver for Nvidia video cards and Tegra family of SoCs
PANFROST_DESC=		ARM Midgard and Bifrost
SWRAST_VK_DESC=		Lavapipe software driver

OPTIONS_EXCLUDE+=	${ARCH:Marmv7:C/.+/PANFROST/}
OPTIONS_EXCLUDE+=	${ARCH:Naarch64:C/.+/FREEDRENO PANFROST/}
OPTIONS_EXCLUDE+=	${ARCH:Namd64:Ni386:Nx86_64:C/.+/INTEL INTEL_HASVK/}
MESON_ARGS+=		-Dvulkan-drivers=${VULKAN_DRIVERS:ts,}
. for _vd in ${OPTIONS_GROUP_VULKAN}
OPTIONS_DEFAULT+=	${_vd:tl}
${_vd}_VARS+=		VULKAN_DRIVERS+=${_vd:tl:S/anv/intel/:S/radv/amd/:S/swrast_vk/swrast/}
. endfor

.include <bsd.port.options.mk>
.include "${.CURDIR:H:H}/graphics/mesa-dri/Makefile.common"

LDFLAGS_i386=		-Wl,-znotext

.if ${PORT_OPTIONS:MX11} || ${PORT_OPTIONS:MWAYLAND}
LIB_DEPENDS+=	libgbm.so.1:graphics/mesa-libs
.endif

.if ${PORT_OPTIONS:MX11}
MESA_PLATFORMS+=	x11
USE_XORG+=		xcb xorgproto xrandr x11 xdamage xext xfixes xshmfence xv
.else
MESON_ARGS+=		-Dxlib-lease=disabled
.endif

MESON_ARGS+=	-Dplatforms="${MESA_PLATFORMS:ts,:tl}"

# Vulkan Video extensions (keep in sync with mesa-gallium-va)
MESON_ARGS+=	-Dvideo-codecs="all"

# Disable some options
MESON_ARGS+=	-Dandroid-libbacktrace=disabled \
		-Dgallium-mediafoundation=disabled \
		-Dgallium-va=disabled \
		-Dglx=disabled \
		-Degl=enabled \
		-Dlmsensors=disabled \
		-Dmicrosoft-clc=disabled \
		-Dvalgrind=disabled

.if ${ARCH} != amd64
MESON_ARGS+=	-Dintel-rt=disabled # https://gitlab.freedesktop.org/mesa/mesa/-/issues/10629
.endif

.for _gd in ${OPTIONS_GROUP_GALLIUM}
. if defined(GALLIUM_DRIVERS) && ${GALLIUM_DRIVERS:M${_gd}}
PLIST_SUB+=	${_gd}=""
. else
PLIST_SUB+=	${_gd}="@comment "
. endif
.endfor

PLIST_SUB += ARCH=${ARCH:S/amd/x86_/}
.for _vd in ${OPTIONS_GROUP_VULKAN}
. if defined(VULKAN_DRIVERS) && ${VULKAN_DRIVERS:M${_vd}}
PLIST_SUB+=	${_vd}=""
. else
PLIST_SUB+=	${_vd}="@comment "
. endif
.endfor

post-install:
	@${RM} -r ${STAGEDIR}/etc/OpenCL
	${INSTALL_DATA} ${FILESDIR}/01-freebsd.conf \
		${STAGEDIR}${PREFIX}/share/drirc.d

.include <bsd.port.post.mk>
