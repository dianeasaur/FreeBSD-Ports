# Fortran support
#
# Feature:	fortran
# Usage:	USES = fortran
# Valid ARGS:	lfortran
#
# MAINTAINER:	4983626+dianeasaur@users.noreply.github.com

.if !defined(_INCLUDE_USES_FORTRAN_MK)
    _INCLUDE_USES_FORTRAN_MK=yes

.  if empty(fortran_ARGS)
fortran_ARGS=	${FORTRAN_DEFAULT}
.  endif

VALID_ARGS=	flang gfortran lfortran

.  if ${fortran_ARGS} == flang
_USE_LLVM=	yes
.    if defined(_USE_LLVM)
.include "${USESDIR}/llvm.mk"
_LLVM_VER=	${LLVM_DEFAULT}
BUILD_DEPENDS+= flang${_LLVM_VER}:devel/llvm${_LLVM_VER}
RUN_DEPENDS+=   flang${_LLVM_VER}:devel/llvm${_LLVM_VER}
.    endif # defined(_USE_LLVM)
FC_DEFAULTS=
F77=		flang${_LLVM_VER}
F90=		flang${_LLVM_VER}
FC=		flang${_LLVM_VER}
FFLAGS+=	-Wl,-rpath=${LLVM_PREFIX}/lib
F90FLAGS+=	-Wl,-rpath=${LLVM_PREFIX}/lib
FCFLAGS+=	-Wl,-rpath=${LLVM_PREFIX}/lib
LDFLAGS+=	-L${LOCALBASE}/lib -Wl,-rpath=${LLVM_PREFIX}/lib
CFLAGS_F2018=	-I${LLVM_PREFIX}/include
.  elif ${fortran_ARGS} ==	lfortran
_USE_LLVM=	yes
.    if defined(_USE_LLVM)
.include "${USESDIR}/llvm.mk"
_LLVM_VER=	${LLVM_DEFAULT}
BUILD_DEPENDS+=	lfortran:lang/lfortran
RUN_DEPENDS+=	lfortran:lang/lfortran
.    endif # defined(_USE_LLVM)
FC_DEFAULTS=	--backend llvm --fixed-form-infer
F77=		lfortran
F90=		lfortran
FC=		lfortran
FFLAGS+=	-Wl,-rpath=${LLVM_PREFIX}/lib
F90FLAGS+=	-Wl,-rpath=${LLVM_PREFIX}/lib
FCFLAGS+=	-Wl,-rpath=${LLVM_PREFIX}/lib
LDFLAGS+=	-L${LOCALBASE}/lib -Wl,-rpath=${LLVM_PREFIX}/lib
CFLAGS_F2018=	-I${LLVM_PREFIX}/include
.  elif ${fortran_ARGS} ==	gfortran
.    if empty(USE_GCC)
_GCC_VER=	${GCC_DEFAULT:S/.//}
.    else
_GCC_VER=	${_USE_GCC}
.    endif
BUILD_DEPENDS+=	gfortran${_GCC_VER}:lang/gcc${_GCC_VER}
RUN_DEPENDS+=	gfortran${_GCC_VER}:lang/gcc${_GCC_VER}
F77=	gfortran${_GCC_VER}
F90=	gfortran${_GCC_VER}
FC=	gfortran${_GCC_VER}
FFLAGS+=	-Wl,-rpath=${LOCALBASE}/lib/gcc${_GCC_VER}
F90FLAGS+=	-Wl,-rpath=${LOCALBASE}/lib/gcc${_GCC_VER}
FCFLAGS+=	-Wl,-rpath=${LOCALBASE}/lib/gcc${_GCC_VER}
LDFLAGS+=	-Wl,-rpath=${LOCALBASE}/lib/gcc${_GCC_VER} \
                -L${LOCALBASE}/lib/gcc${_GCC_VER}
CFLAGS_F2018=	-I${LOCALBASE}/include/gcc${_GCC_VER}
# Only needed on riscv64? See PR 287211
.    if ${ARCH} == "riscv64"
FCFLAGS+=  -B${LOCALBASE}/lib/gcc${_GCC_VER}
.    endif
.  else
IGNORE=         USES=fortran: invalid arguments: ${fortran_ARGS}
.  endif

USE_BINUTILS=	yes

CONFIGURE_ENV+=	F77="${F77} ${FC_DEFAULTS}" F90="${FC} ${FC_DEFAULTS}" FC="${FC} ${FC_DEFAULTS}" FFLAGS="${FFLAGS}" F90FLAGS="${FFLAGS}" FCFLAGS="${FCFLAGS}"

MAKE_ENV+=	F77="${F77} ${FC_DEFAULTS}" F90="${FC} ${FC_DEFAULTS}" FC="${FC} ${FC_DEFAULTS}" FFLAGS="${FFLAGS}" F90FLAGS="${FFLAGS}" FCFLAGS="${FCFLAGS}"

.endif
