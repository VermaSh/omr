###############################################################################
# Copyright IBM Corp. and others 2015
#
# This program and the accompanying materials are made available under
# the terms of the Eclipse Public License 2.0 which accompanies this
# distribution and is available at https://www.eclipse.org/legal/epl-2.0/
# or the Apache License, Version 2.0 which accompanies this distribution
# and is available at https://www.apache.org/licenses/LICENSE-2.0.
#
# This Source Code may also be made available under the following Secondary
# Licenses when the conditions for such availability set forth in the
# Eclipse Public License, v. 2.0 are satisfied: GNU General Public License,
# version 2 with the GNU Classpath Exception [1] and GNU General Public
# License, version 2 with the OpenJDK Assembly Exception [2].
#
# [1] https://www.gnu.org/software/classpath/license.html
# [2] https://openjdk.org/legal/assembly-exception.html
#
# SPDX-License-Identifier: EPL-2.0 OR Apache-2.0 OR GPL-2.0-only WITH Classpath-exception-2.0 OR GPL-2.0-only WITH OpenJDK-assembly-exception-1.0
###############################################################################

# Detect 64-bit vs. 32-bit
ifneq (,$(findstring -64,$(SPEC)))
  TEMP_TARGET_DATASIZE:=64
else
  TEMP_TARGET_DATASIZE:=32
endif

include $(CONFIG_INCL_DIR)/configure_common.mk

# Notes (on disabled flags):
# OMR_THR_SPIN_WAKE_CONTROL flag requires OMR_THR_THREE_TIER_LOCKING flag.
# OMR_THR_SPIN_WAKE_CONTROL flag is disabled on AIX since
# OMR_THR_THREE_TIER_LOCKING flag is unavailable on AIX.

ifeq (aix_ppc-64_cmprssptrs, $(SPEC))
  CONFIGURE_ARGS += \
    --enable-OMRTHREAD_LIB_AIX \
    --enable-OMR_ARCH_POWER \
    --enable-OMR_ENV_DATA64 \
    --enable-OMR_PORT_CAN_RESERVE_SPECIFIC_ADDRESS \
    --enable-OMR_THR_FORK_SUPPORT \
    OMR_GC_POINTER_MODE=compressed
endif

ifeq (aix_ppc-64, $(SPEC))
  CONFIGURE_ARGS += \
    --enable-OMRTHREAD_LIB_AIX \
    --enable-OMR_ARCH_POWER \
    --enable-OMR_ENV_DATA64 \
    --enable-OMR_PORT_CAN_RESERVE_SPECIFIC_ADDRESS \
    --enable-OMR_THR_FORK_SUPPORT
endif

ifeq (aix_ppc, $(SPEC))
  CONFIGURE_ARGS += \
    --enable-OMRTHREAD_LIB_AIX \
    --enable-OMR_ARCH_POWER \
    --enable-OMR_PORT_CAN_RESERVE_SPECIFIC_ADDRESS \
    --enable-OMR_THR_FORK_SUPPORT
endif

CONFIGURE_ARGS += libprefix=lib exeext= solibext=.so arlibext=.a objext=.o

CONFIGURE_ARGS += 'AS=as'
CONFIGURE_ARGS += 'CC=xlC_r'
CONFIGURE_ARGS += 'CXX=$$(CC)'
#CONFIGURE_ARGS += 'CPP=$$(CC) -P'
CONFIGURE_ARGS += 'CCLINKEXE=$$(CC)'
CONFIGURE_ARGS += 'CCLINKSHARED=ld'
CONFIGURE_ARGS += 'CXXLINKEXE=$$(CC)'
CONFIGURE_ARGS += 'CXXLINKSHARED=makeC++SharedLib_r'
CONFIGURE_ARGS += 'AR=ar'

CONFIGURE_ARGS += 'OMR_HOST_OS=aix'
CONFIGURE_ARGS += 'OMR_HOST_ARCH=ppc'
CONFIGURE_ARGS += 'OMR_TARGET_DATASIZE=$(TEMP_TARGET_DATASIZE)'
CONFIGURE_ARGS += 'OMR_TOOLCHAIN=$(if $(findstring ibm-clang,$(notdir $(CC))),openxl,xlc)'
