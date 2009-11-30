dnl 
dnl AUTHOR: Francesco Chemolli
dnl
dnl SQUID Web Proxy Cache          http://www.squid-cache.org/
dnl ----------------------------------------------------------
dnl Squid is the result of efforts by numerous individuals from
dnl the Internet community; see the CONTRIBUTORS file for full
dnl details.   Many organizations have provided support for Squid's
dnl development; see the SPONSORS file for full details.  Squid is
dnl Copyrighted (C) 2001 by the Regents of the University of
dnl California; see the COPYRIGHT file for full details.  Squid
dnl incorporates software developed and/or copyrighted by other
dnl sources; see the CREDITS file for full details.
dnl
dnl This program is free software; you can redistribute it and/or modify
dnl it under the terms of the GNU General Public License as published by
dnl the Free Software Foundation; either version 2 of the License, or
dnl (at your option) any later version.
dnl
dnl This program is distributed in the hope that it will be useful,
dnl but WITHOUT ANY WARRANTY; without even the implied warranty of
dnl MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
dnl GNU General Public License for more details.
dnl
dnl You should have received a copy of the GNU General Public License
dnl along with this program; if not, write to the Free Software
dnl Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111, USA.

dnl save main environment variables to variables to the namespace defined by the
dnl first argument (prefix)
dnl e.g. SQUID_SAVEFLAGS([foo]) will save CFLAGS to foo_CFLAGS etc.
dnl Saved variables are:
dnl CFLAGS, CXXFLAGS, LDFLAGS, LIBS plus any variables specified as
dnl second argument
AC_DEFUN([SQUID_STATE_SAVE],[
$1_CFLAGS="${CFLAGS}"
$1_CXXFLAGS="${CXXFLAGS}"
$1_LDFLAGS="${LDFLAGS}"
$1_LIBS="${LIBS}"
$1_squid_saved_vars="$2"
for squid_util_var_tosave in $2
do
    squid_util_var_tosave2="$1_${squid_util_var_tosave}"
    eval "${squid_util_var_tosave2}=\"${squid_util_var_tosave}\""
done
])

dnl commit the state changes: deleting the temporary state defined in SQUID_STATE_SAVE
dnl with the same prefix. It's not necessary to specify the extra variables passed
dnl to SQUID_STATE_SAVE again, they will be automatically reclaimed.
AC_DEFUN([SQUID_STATE_COMMIT],[
unset $1_CFLAGS
unset $1_$CXXFLAGS
unset $1_LDFLAGS
unset $1_LIBS
for squid_util_var_tosave in $$1_squid_saved_vars
do
    unset ${squid_util_var_tosave2}
done
])

dnl rollback state to the call of SQUID_STATE_SAVE with the same namespace argument.
dnl all temporary state will be cleared, including the custom variables specified
dnl at call time. It's not necessary to explicitly name them, they will be automatically
dnl cleared.
AC_DEFUN([SQUID_STATE_ROLLBACK],[
CFLAGS="${$1_CFLAGS}"
CXXFLAGS="${$1_CXXFLAGS}"
LDFLAGS="${$1_LDFLAGS}"
LIBS="${$1_LIBS}"
for squid_util_var_tosave in $$1_squid_saved_vars
do
    squid_util_var_tosave2="$1_${squid_util_var_tosave}"
    eval "${squid_util_var_tosave}=\$${squid_util_var_tosave2}"
done
SQUID_STATE_COMMIT($1)
])

