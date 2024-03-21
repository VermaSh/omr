###############################################################################
# Copyright IBM Corp. and others 2015
#
# This program and the accompanying materials are made available under
# the terms of the Eclipse Public License 2.0 which accompanies this
# distribution and is available at https://www.eclipse.org/legal/epl-2.0/
# or the Apache License, Version 2.0 which accompanies this distribution and
# is available at https://www.apache.org/licenses/LICENSE-2.0.
#
# This Source Code may also be made available under the following
# Secondary Licenses when the conditions for such availability set
# forth in the Eclipse Public License, v. 2.0 are satisfied: GNU
# General Public License, version 2 with the GNU Classpath
# Exception [1] and GNU General Public License, version 2 with the
# OpenJDK Assembly Exception [2].
#
# [1] https://www.gnu.org/software/classpath/license.html
# [2] https://openjdk.org/legal/assembly-exception.html
#
# SPDX-License-Identifier: EPL-2.0 OR Apache-2.0 OR GPL-2.0-only WITH Classpath-exception-2.0 OR GPL-2.0-only WITH OpenJDK-assembly-exception-1.0
###############################################################################

# If --enable-native-encoding was not passed to configure,
# force USE_NATIVE_ENCODING to 0
ifneq ($(OMR_ALLOW_NATIVE_ENCODING),1)
  USE_NATIVE_ENCODING := 0
endif

ifneq ($(USE_NATIVE_ENCODING),1)
  GLOBAL_INCLUDES+=$(top_srcdir)/util/a2e/headers
endif

# Specify the minimum arch for 64-bit programs
ifeq (xlc,$(OMR_TOOLCHAIN))
  GLOBAL_CFLAGS+=-Wc,"ARCH($(OMR_ZOS_COMPILE_ARCHITECTURE))"
  GLOBAL_CXXFLAGS+=-Wc,"ARCH($(OMR_ZOS_COMPILE_ARCHITECTURE))"
else ifeq (openxl,$(OMR_TOOLCHAIN))
  GLOBAL_CFLAGS+=-march=arch$(OMR_ZOS_COMPILE_ARCHITECTURE)
  GLOBAL_CXXFLAGS+=-march=arch$(OMR_ZOS_COMPILE_ARCHITECTURE)
endif

# Enable Warnings as Errors
ifeq ($(OMR_WARNINGS_AS_ERRORS),1)
endif

# Enable more warnings
ifeq ($(OMR_ENHANCED_WARNINGS),1)
endif

# Enable debugging symbols?
ifeq ($(ENABLE_DDR),yes)
  # Optimization is limited when using '-Wc,debug', but *.dbg files are required for DDR.
  # Override compile commands to compile twice: once with '-Wc,debug', and a second time
  # without that option.

  define COMPILE_C_COMMAND
    $(CC) $(CPPFLAGS) $(MODULE_CPPFLAGS) $(GLOBAL_CPPFLAGS) -c $(GLOBAL_CFLAGS) $(MODULE_CFLAGS) $(CFLAGS) -Wc,debug -o $@ $<
    $(CC) $(CPPFLAGS) $(MODULE_CPPFLAGS) $(GLOBAL_CPPFLAGS) -c $(GLOBAL_CFLAGS) $(MODULE_CFLAGS) $(CFLAGS) -o $@ $<
  endef

  define COMPILE_CXX_COMMAND
    $(CXX) $(CPPFLAGS) $(MODULE_CPPFLAGS) $(GLOBAL_CPPFLAGS) -c $(GLOBAL_CXXFLAGS) $(MODULE_CXXFLAGS) $(CXXFLAGS) -Wc,debug -o $@ $<
    $(CXX) $(CPPFLAGS) $(MODULE_CPPFLAGS) $(GLOBAL_CPPFLAGS) -c $(GLOBAL_CXXFLAGS) $(MODULE_CXXFLAGS) $(CXXFLAGS) -o $@ $<
  endef
endif # ENABLE_DDR

# Enable Optimizations
ifeq ($(OMR_OPTIMIZE),1)
    ifeq(xlc,$(OMR_TOOLCHAIN))
	  COPTFLAGS=-O3 -Wc,"TUNE($(OMR_ZOS_COMPILE_TUNE))" -Wc,"inline(auto,noreport,600,5000)"

    # 28 Feb 2022: ZOSV2R3 is adopted since ZOSV1R13 is discontinued.
    #
    # Note: The COMPAT=ZOSV1R13 option does not appear to be related to
    # optimizations. This linker option is supplied only on the compile line,
    # and never when we link. It might be relevant to note that this was added
    # at the same time as the compilation flag "-Wc,target=ZOSV1R10", which
    # would give a performance boost.
    #
    # COMPAT=ZOSV1R13 is the minimum level that supports conditional sequential RLDs.
    # http://www-01.ibm.com/support/knowledgecenter/SSLTBW_2.1.0/com.ibm.zos.v2r1.ieab100/compat.htm
      COPTFLAGS+=-Wl,compat=$(OMR_ZOS_LINK_COMPAT)
    else ifeq (openxl,$(OMR_TOOLCHAIN))
      COPTFLAGS=-O3
    endif
else
    COPTFLAGS=-0
endif
GLOBAL_CFLAGS+=$(COPTFLAGS)
GLOBAL_CXXFLAGS+=$(COPTFLAGS)

# Preprocessor Flags
GLOBAL_CPPFLAGS+=-DJ9ZOS390 -DLONGLONG -D_ALL_SOURCE -D_XOPEN_SOURCE_EXTENDED -D_POSIX_SOURCE -D__STDC_LIMIT_MACROS

# Global Flags
# xplink   Link with the xplink calling convention
# convlit  Convert all string literals to a codepage
# rostring Place string literals in read only storage
# FLOAT    Use IEEE (instead of IBM Hex Format) style floats
# enum     Specifies how many bytes of storage enums occupy
# a,goff   Assemble into GOFF object files
# NOANSIALIAS Do not generate ALIAS binder control statements
# TARGET   Generate code for the target operating system
ifeq (xlc,$(OMR_TOOLCHAIN))
  GLOBAL_FLAGS+=-Wc,"xplink,rostring,FLOAT(IEEE,FOLD,AFP),enum(4)" -Wa,goff -Wc,NOANSIALIAS -Wc,"TARGET($(OMR_ZOS_COMPILE_TARGET))"
else ifeq (openxl,$(OMR_TOOLCHAIN))
  GLOBAL_FLAGS+=-fno-short-enums -fno-strict-aliasing
endif

ifeq (openxl,$(OMR_TOOLCHAIN))
  # Specify the path to the development headers from openxl. INCLUDE_DIR is an environment variable
    GLOBAL_FLAGS+=-DCOMPILER_HEADER_PATH_PREFIX=$(INCLUDE_DIR)
endif

ifeq (1,$(USE_NATIVE_ENCODING))
  GLOBAL_CPPFLAGS+=-DOMR_EBCDIC
else
  GLOBAL_CPPFLAGS+=-DIBM_ATOE
  ifeq (xlc,$(OMR_TOOLCHAIN))
    GLOBAL_FLAGS+=-Wc,"convlit(ISO8859-1)"
  else ifeq (openxl,$(OMR_TOOLCHAIN))
    GLOBAL_FLAGS+=-fexec-charset=ISO8859-1
  endif
endif

ifeq (1,$(OMR_ENV_DATA64))
  GLOBAL_CPPFLAGS+=-DJ9ZOS39064
  ifeq (xlc,$(OMR_TOOLCHAIN))
    GLOBAL_FLAGS+=-Wc,lp64 -Wa,"SYSPARM(BIT64)"
  else ifeq (openxl,$(OMR_TOOLCHAIN))
    GLOBAL_FLAGS+=-m64
  endif
else
  GLOBAL_CPPFLAGS+=-D_LARGE_FILES
endif

ifeq (xlc,$(OMR_TOOLCHAIN))
  GLOBAL_CFLAGS+=-Wc,"langlvl(extc99)" $(GLOBAL_FLAGS)
  GLOBAL_CXXFLAGS+=-Wc,"langlvl(extended0x)" -+ $(GLOBAL_FLAGS)
else ifeq (openxl,$(OMR_TOOLCHAIN))
  GLOBAL_CFLAGS+=-std=gnu99 $(GLOBAL_FLAGS)
  GLOBAL_CXXFLAGS+=-std=gnu++11 -xc++ $(GLOBAL_FLAGS)
endif

ifneq (,$(findstring archive,$(ARTIFACT_TYPE)))
  DO_LINK:=0
else
  DO_LINK:=1
endif
ifeq (1,$(DO_LINK))
  ifneq (,$(findstring shared,$(ARTIFACT_TYPE)))
    ifeq (xlc,$(OMR_TOOLCHAIN))
      GLOBAL_CPPFLAGS+=-Wc,DLL,EXPORTALL
    else ifeq (openxl,$(OMR_TOOLCHAIN))
      GLOBAL_CPPFLAGS+=-fvisibility=default
    endif
  endif

  # This is the first option applied to the C++ linking command.
  # It is not applied to the C linking command.
  ifeq (xlc,$(OMR_TOOLCHAIN))
    OMR_MK_CXXLINKFLAGS=-Wc,"langlvl(extended0x)" -+
  else ifeq (openxl,$(OMR_TOOLCHAIN))
    OMR_MK_CXXLINKFLAGS=-std=gnu++11
  endif

  ifneq (,$(findstring shared,$(ARTIFACT_TYPE)))
    ifeq(xlc,$(OMR_TOOLCHAIN))
      GLOBAL_LDFLAGS+=-Wl,xplink,dll
    endif
  else
    # Assume we're linking an executable
     ifeq(xlc,$(OMR_TOOLCHAIN))
       GLOBAL_LDFLAGS+=-Wl,xplink
     endif
  endif
  ifeq (1,$(OMR_ENV_DATA64))
    ifeq (xlc,$(OMR_TOOLCHAIN))
      OMR_MK_CXXLINKFLAGS+=-Wc,lp64
      GLOBAL_LDFLAGS+=-Wl,lp64
    else ifeq (openxl,$(OMR_TOOLCHAIN))
      OMR_MK_CXXLINKFLAGS+=-m64
      GLOBAL_LDFLAGS+=-m64
    endif
  endif

  # always link a2e last, unless we are creating the a2e library
  ifneq (j9a2e,$(MODULE_NAME))
    ifneq (1,$(USE_NATIVE_ENCODING))
      GLOBAL_SHARED_LIBS+=j9a2e
    endif
  endif
endif

# compilation for metal-C files.
ifeq (1,$(OMR_ENV_DATA64))
  MCFLAGS=-q64
endif
%$(OBJEXT): %.mc
	cp $< $*.c
	xlc $(MCFLAGS) -qmetal -qlongname -S -o $*.s $*.c > $*.asmlist
	rm -f $*.c
	as -mgoff -I CBC.SCCNSAM $*.s
	rm -f $*.s

# compilation for .s files
ifeq (openxl,$(OMR_TOOLCHAIN))
# Workaround due to clang idiosyncracies
  define AS_COMMAND
  -$(AS) -mgoff -m"SYSPARM(BIT64)" -m64 $<
  endef
else
  define AS_COMMAND
  $(CC) $(CPPFLAGS) $(MODULE_CPPFLAGS) $(GLOBAL_CPPFLAGS) $(GLOBAL_CFLAGS) $(MODULE_CFLAGS) $(CFLAGS) -c $<
  endef
endif

define LINK_CXX_EXE_COMMAND
$(CXXLINKEXE) $(OMR_MK_CXXLINKFLAGS) -o $@ \
  $(LDFLAGS) $(MODULE_LDFLAGS) $(GLOBAL_LDFLAGS) \
  $(LD_SHARED_LIBS) $(OBJECTS) $(LD_STATIC_LIBS)
endef

# Do not create an export file
$(MODULE_NAME)_LINKER_EXPORT_SCRIPT:=

define LINK_C_SHARED_COMMAND
$(CCLINKSHARED) -o $($(MODULE_NAME)_shared) \
  $(LDFLAGS) $(MODULE_LDFLAGS) $(GLOBAL_LDFLAGS) \
  $(LD_SHARED_LIBS) $(OBJECTS) $(LD_STATIC_LIBS) \
  -Wl, -x$(LIBPREFIX)$(MODULE_NAME).x
cp -f $(LIBPREFIX)$(MODULE_NAME).x $(lib_output_dir)
endef

define LINK_CXX_SHARED_COMMAND
$(CXXLINKSHARED) $(OMR_MK_CXXLINKFLAGS) -o $($(MODULE_NAME)_shared) \
  $(LDFLAGS) $(MODULE_LDFLAGS) $(GLOBAL_LDFLAGS) \
  $(LD_SHARED_LIBS) $(OBJECTS) $(LD_STATIC_LIBS) \
  -Wl, -x$(LIBPREFIX)$(MODULE_NAME).x
cp -f $(LIBPREFIX)$(MODULE_NAME).x $(lib_output_dir)
endef

ifneq (,$(findstring shared,$(ARTIFACT_TYPE)))
CLEAN_FILES+=$(LIBPREFIX)$(MODULE_NAME).x
CLEAN_FILES+=$(lib_output_dir)/$(LIBPREFIX)$(MODULE_NAME).x
endif
define CLEAN_COMMAND
-$(RM) $(OBJECTS) $(OBJECTS:$(OBJEXT)=.d) $(CLEAN_FILES)
endef

# The following files cannot be built with clang due to either
# - pragma convlit
# - pragma linkage
ifeq (openxl,$(OMR_TOOLCHAIN))
  ifneq (,$(findstring shared, $(ARTIFACT_TYPE)))
    XLC_VISIBILITY = -Wc,DLL,EXPORTALL
  endif
  XLC_DEFINES=-DJ9ZOS390 -DLONGLONG -D_ALL_SOURCE -D_XOPEN_SOURCE_EXTENDED \
    -D_POSIX_SOURCE -D__STDC_LIMIT_MACROS -DIBM_ATOE -DJ9ZOS39064
  XLC_OPTS=-Wc,"ARCH(8)" -O3 -Wc,"TUNE(10)" \
    -Wc,"inline(auto,noreport,600,5000)" -Wc,"langlvl(extc99)" \
    -Wc,"xplink,FLOAT(IEEE,FOLD,AFP),enum(4)" -Wa,goff -Wc,NOANSIALIAS \
    -Wc,"convlit(ISO8859-1)" -Wc,lp64 -Wa,"SYSPARM(BIT64)"
  # port
  omrsysinfo.o \
  omrmem.o \
  omrintrospect.o \
  omriarv64.o  \
  omrzfs.o \
  omrsignal_context.o \
  omrstorage.o  \
  omrmmap.o \
  omrcel4ro31.o \
  omrsignal_context_ceehdlr.o \
  omrvmem.o \
  omriconvhelpers.o \
  omrfiletext.o \
  j9nls.o \
  omrfilestream.o \
  omrsignal_ceehdlr.o: %.o : %.c
		c89 $(call buildCPPIncludeFlags,$(MODULE_INCLUDES)) \
		$(call buildCPPIncludeFlags,$(GLOBAL_INCLUDES)) $(XLC_VISIBILITY) \
		$(XLC_DEFINES) -DOMRPORT_LIBRARY_DEFINE $(XLC_OPTS) -c -o $@ $<

  # thread
  thrprof.o \
  thrdsup.o \
  omrthread.o: %.o : %.c
		c89 $(call buildCPPIncludeFlags,$(MODULE_INCLUDES)) \
		$(call buildCPPIncludeFlags,$(GLOBAL_INCLUDES)) $(XLC_VISIBILITY) \
		$(XLC_DEFINES) $(XLC_OPTS) -c -o $@ $<

  # atoe
  atoe.o : atoe.c
		c89 $(call buildCPPIncludeFlags,$(MODULE_INCLUDES)) \
		$(call buildCPPIncludeFlags,$(GLOBAL_INCLUDES)) $(XLC_VISIBILITY) \
		$(XLC_DEFINES) $(XLC_OPTS) -c -o $@ $<
endif
