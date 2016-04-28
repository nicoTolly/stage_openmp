#!/bin/sh
#-*-sh-*-

#
# Copyright © 2009-2016 Inria.  All rights reserved.
# See COPYING in top-level directory.
#

HWLOC_top_builddir="/home/nico/stage/hwloc/hwloc-1.11.3"
annotate="$HWLOC_top_builddir/utils/hwloc/hwloc-annotate"
HWLOC_top_srcdir="/home/nico/stage/hwloc/hwloc-1.11.3"

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
file="$tmp/test-hwloc-annotate.output"

set -e

$annotate $HWLOC_top_srcdir/utils/hwloc/test-hwloc-annotate.input $file pu:0 misc pumisc
$annotate $file $file root misc rootmisc
$annotate $file $file all info Foo Bar
$annotate --ci $file $file Core:all info Foo2 Bar2
$annotate --ci $file $file L2Cache:0 none
$annotate --ri $file $file pack:all info Foo
$annotate $file $file pack:0 info Foo2 Bar
$annotate $file $file pack:0 info Foo2 Bar2
$annotate --ri $file $file pack:0 info Foo2 Bar3
$annotate $file $file os:2-3 info myosdev byindex
$annotate $file $file pci:4:2 info mypcidev byindex
$annotate $file $file pci=0000:02:00.0 info mypcidev bybusid
$annotate $file $file 'pci[8086:0046]:all' info mypcidev bymatch
$annotate --cu $file $file L1iCache:0 none

diff -u $HWLOC_top_srcdir/utils/hwloc/test-hwloc-annotate.output "$file"
rm -rf "$tmp"
