#!/bin/sh
#-*-sh-*-

#
# Copyright © 2009-2015 Inria.  All rights reserved.
# Copyright © 2009, 2011 Université Bordeaux
# See COPYING in top-level directory.
#

HWLOC_VERSION="1.11.3"
HWLOC_top_builddir="/home/nico/stage/hwloc/hwloc-1.11.3"
assembler="$HWLOC_top_builddir/utils/hwloc/hwloc-assembler"
HWLOC_top_srcdir="/home/nico/stage/hwloc/hwloc-1.11.3"
SED="/bin/sed"
EXEEXT=""

HWLOC_PLUGINS_PATH=${HWLOC_top_builddir}/src
export HWLOC_PLUGINS_PATH

if test x0 = x1; then
  # make sure we use default numeric formats
  LANG=C
  LC_ALL=C
  export LANG LC_ALL
fi

: ${TMPDIR=/tmp}
{
  tmp=`
    (umask 077 && mktemp -d "$TMPDIR/fooXXXXXX") 2>/dev/null
  ` &&
  test -n "$tmp" && test -d "$tmp"
} || {
  tmp=$TMPDIR/foo$$-$RANDOM
  (umask 077 && mkdir "$tmp")
} || exit $?
file="$tmp/test-hwloc-assembler.output"

set -e

$assembler $file \
	--name input1 $HWLOC_top_srcdir/utils/hwloc/test-hwloc-assembler.input1 \
	--name input2 $HWLOC_top_srcdir/utils/hwloc/test-hwloc-assembler.input2 \
	--name input1again $HWLOC_top_srcdir/utils/hwloc/test-hwloc-assembler.input1

# filter hwlocVersion since it often changes
# filter ProcessName since it may be hwloc-info or lt-hwloc-info
cat $file \
 | $SED -e '/<info name=\"hwlocVersion\" value=\"'$HWLOC_VERSION'\"\/>/d' \
 | $SED -e '/<info name=\"ProcessName\" value=\"hwloc-assembler'$EXEEXT'\"\/>/d' -e '/<info name=\"ProcessName\" value=\"lt-hwloc-assembler'$EXEEXT'\"\/>/d' \
 > ${file}.tmp
mv -f ${file}.tmp $file

diff -u $HWLOC_top_srcdir/utils/hwloc/test-hwloc-assembler.output "$file"
rm -rf "$tmp"
