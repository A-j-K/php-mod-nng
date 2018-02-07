dnl $Id$
dnl config.m4 for extension php-mod-nng

PHP_ARG_WITH(php-mod-nng, for Nanomsg Next Gen support,
[  --with-nng             Include Nanomsg Next Gen support])

if test "$PHP_MOD_NNG" != "no"; then
  SEARCH_PATH="/usr/local /usr"
  SEARCH_FOR="/include/nng/nng.h"
  AC_MSG_CHECKING([for NNG files in default paths])
  for i in $SEARCH_PATH ; do
    if test -r $i/$SEARCH_FOR; then
      NNG_DIR=$i
      AC_MSG_RESULT(found in $i)
    fi
  done
  
  
  if test -z "$NNG_DIR"; then
    AC_MSG_RESULT([NNG_DIR not found])
    AC_MSG_ERROR([Please install the NNG distribution])
  fi

  PHP_ADD_INCLUDE($NNG_DIR/include)

  LIBNAME=nng
  LIBSYMBOL=nng_close

  PHP_CHECK_LIBRARY($LIBNAME,$LIBSYMBOL,
  [
   PHP_ADD_LIBRARY_WITH_PATH($LIBNAME, $NNG_DIR/lib, NNG_SHARED_LIBADD)
    AC_DEFINE(HAVE_NNGLIB,1,[ ])
  ],[
     AC_MSG_ERROR([wrong NNG lib version or lib not found])
  ],[
     -L$NNG_DIR/lib
  ])

  SEARCH_FOR="/include/mbedtls/ssl.h"
  AC_MSG_CHECKING([for Mbed TLS files in default paths])
  for i in $SEARCH_PATH ; do
    if test -r $i/$SEARCH_FOR; then
      MBED_DIR=$i
      AC_MSG_RESULT(found in $i)
    fi
  done

  if test -z "$MBED_DIR"; then
    AC_MSG_RESULT([not found])
    AC_MSG_ERROR([Please install the MbedTLS distribution])
  fi

  PHP_ADD_INCLUDE($MBED_DIR/include)

  LIBNAME=mbedtls
  LIBSYMBOL=mbedtls_ssl_init

  PHP_CHECK_LIBRARY($LIBNAME,$LIBSYMBOL,
  [
   PHP_ADD_LIBRARY_WITH_PATH($LIBNAME, $MBED_DIR/lib, MBED_SHARED_LIBADD)
    AC_DEFINE(HAVE_MBEDTLSLIB,1,[ ])
  ],[
    AC_MSG_ERROR([wrong MbedTLS lib version or lib not found])
  ],[
    -L$MBED_DIR/lib
  ])

  PHP_SUBST(NNG_SHARED_LIBADD)
  PHP_SUBST(MBED_SHARED_LIBADD)

  PHP_NEW_EXTENSION(php_mod_nng, php_mod_nng.c, $ext_shared)
fi

