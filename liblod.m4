dnl Author: Mo McRoberts <mo.mcroberts@bbc.co.uk>
dnl
dnl Copyright 2016 BBC.
dnl
dnl  Licensed under the Apache License, Version 2.0 (the "License");
dnl  you may not use this file except in compliance with the License.
dnl  You may obtain a copy of the License at
dnl
dnl      http://www.apache.org/licenses/LICENSE-2.0
dnl
dnl  Unless required by applicable law or agreed to in writing, software
dnl  distributed under the License is distributed on an "AS IS" BASIS,
dnl  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
dnl  See the License for the specific language governing permissions and
dnl  limitations under the License.
dnl
m4_pattern_forbid([^BT_])dnl
m4_pattern_forbid([^_BT_])dnl
dnl Internal: _BT_CHECK_LIBLOD([action-if-exists],[action-if-not-exists],[subdir],[preconfigured])
AC_DEFUN([_BT_CHECK_LIBLOD],[
	m4_ifval([$4],[liblod_configured=yes])	
	dnl liblod incorporates liburi
	m4_ifval([$3],[
		BT_CHECK_LIBURI_INCLUDED(,,[$3/liburi])
	],[
		BT_CHECK_LIBURI
	])
	if test x"$have_liburi" = x"yes" ; then
		BT_CHECK_LIB([liblod],[$3],[liblod],[
			AC_CHECK_PROGS([LIBLOD_CONFIG],[liblod-config])
			if test -n "$LIBLOD_CONFIG" ; then
				LIBLOD_CPPFLAGS="`$LIBLOD_CONFIG --cflags`"
				LIBLOD_LIBS="`$LIBLOD_CONFIG --libs`"
				CPPFLAGS="$CPPFLAGS $LIBLOD_CPPFLAGS"
				LIBS="$LIBLOD_LIBS $LIBS"
				AC_CHECK_HEADER([liblod.h],[
					AC_CHECK_LIB([lod],[lod_create],[
						have_liblod=yes
					])
				])
			fi
		],[
			LIBLOD_LOCAL_LIBS="${liblod_builddir}/liblod.la"
			LIBLOD_INSTALLED_LIBS="-L${libdir} -llod"
		],[$1],[$2])
	else
		m4_ifval([$2],[$2],true)
	fi
])dnl
dnl
dnl - BT_CHECK_LIBLOD([action-if-found],[action-if-not-found])
dnl Default action is to update AM_CPPFLAGS, AM_LDFLAGS, LIBS and LOCAL_LIBS
dnl as required, and do nothing if not found
AC_DEFUN([BT_CHECK_LIBLOD],[
_BT_CHECK_LIBLOD([$1],[$2])
])dnl
dnl - BT_CHECK_LIBLOD_INCLUDED([action-if-found],[action-if-not-found],[subdir=liblod],[preconfigured])
AC_DEFUN([BT_CHECK_LIBLOD_INCLUDED],[
AS_LITERAL_IF([$3],,[AC_DIAGNOSE([syntax],[$0: subdir must be a literal])])dnl
_BT_CHECK_LIBLOD([$1],[$2],m4_ifval([$3],[$3],[liblod]),[$4])
])dnl
dnl - BT_REQUIRE_LIBLOD([action-if-found])
AC_DEFUN([BT_REQUIRE_LIBLOD],[
_BT_CHECK_LIBLOD([$1],[
	AC_MSG_ERROR([cannot find required library liblod])
])
])dnl
dnl - BT_REQUIRE_LIBLOD_INCLUDED([action-if-found],[subdir=liblod],[preconfigured])
AC_DEFUN([BT_REQUIRE_LIBLOD_INCLUDED],[
AS_LITERAL_IF([$2],,[AC_DIAGNOSE([syntax],[$0: subdir passed must be a literal])])dnl
_BT_CHECK_LIBLOD([$1],[
	AC_MSG_ERROR([cannot find required library liblod])
],m4_ifval([$2],[$2],[liblod]),[$3])
])dnl
