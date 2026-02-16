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
fortran_ARGS=	lfortran
.  endif

.  if ${fortran_ARGS} == lfortran
BUILD_DEPENDS+=	lfortran:lang/lfortran
RUN_DEPENDS+=	lfortran:lang/lfortran
LF_DEFAULTS=    --backend llvm --fixed-form-infer

F77=	lfortran
F90=	lfortran
FC=	lfortran

FFLAGS+=	-Wl,-rpath=${LLVM_PREFIX}/lib
F90FLAGS+=	-Wl,-rpath=${LLVM_PREFIX}/lib
FCFLAGS+=	-Wl,-rpath=${LLVM_PREFIX}/lib
LDFLAGS+=	-Wl,-rpath=${LLVM_PREFIX}/lib \
		-L${LOCALBASE}/lib -Wl,-rpath=${LLVM_PREFIX}/lib
CFLAGS_F2018=	-I${LLVM_PREFIX}/include
.  else
IGNORE=USES=fortran: invalid arguments: ${fortran_ARGS}
.  endif
USE_BINUTILS=	yes

CONFIGURE_ENV+=	F77="${F77} ${LF_DEFAULTS}" F90="${FC} ${LF_DEFAULTS}" FC="${FC} ${LF_DEFAULTS}" FFLAGS="${FFLAGS}" F90FLAGS="${FFLAGS}" FCFLAGS="${FCFLAGS}"

MAKE_ENV+=	F77="${F77} ${LF_DEFAULTS}" F90="${FC} ${LF_DEFAULTS}" FC="${FC} ${LF_DEFAULTS}" FFLAGS="${FFLAGS}" F90FLAGS="${FFLAGS}" FCFLAGS="${FCFLAGS}"

.endif
