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
USES-=gmake
BUILD_DEPENDS+=	lfortran:lang/lfortran
RUN_DEPENDS+=	lfortran:lang/lfortran
F77=lfortran
F90=lfortran
FC=lfortran
FFLAGS=         ""
F90FLAGS=       ""
FCFLAGS=        ""
LDFLAGS=        ""
CFLAGS_F2018=""
  .  else
IGNORE=USES=fortran: invalid arguments: ${fortran_ARGS}
  .  endif

USE_BINUTILS=	yes

CONFIGURE_ENV+=	F77="${F77}" F90="${FC}" FC="${FC}"\
	       FFLAGS="${FFLAGS}" F90FLAGS="${FFLAGS}" FCFLAGS="${FCFLAGS}"

MAKE_ENV+=	F77="${F77}" F90="${FC}" FC="${FC}"\
	  FFLAGS="${FFLAGS}" F90FLAGS="${FFLAGS}" FCFLAGS="${FCFLAGS}"

.endif
