#!/bin/sh
#-*-sh-*-

#
# Copyright © 2012-2013 Inria.  All rights reserved.
# See COPYING in top-level directory.
#

HWLOC_top_builddir="/home/nico/stage/hwloc/hwloc-1.11.3"

HWLOC_PLUGINS_PATH=${HWLOC_top_builddir}/src
export HWLOC_PLUGINS_PATH

"$@"
