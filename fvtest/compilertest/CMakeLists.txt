###############################################################################
# Copyright IBM Corp. and others 2017
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

include(OmrCompilerSupport)

set(COMPILERTEST_FILES
	compile/ResolvedMethod.cpp
	control/TestJit.cpp
	ilgen/IlInjector.cpp
	ilgen/TestIlGeneratorMethodDetails.cpp
	runtime/TestCodeCacheManager.cpp
)

if(OMR_ARCH_X86)
	list(APPEND COMPILERTEST_FILES
		x/codegen/Evaluator.cpp
	)
elseif(OMR_ARCH_POWER)
	list(APPEND COMPILERTEST_FILES
		#Host
		p/runtime/AsmUtil.spp
		p/runtime/CodeDispatch.spp
		p/runtime/CodeSync.cpp
		${omr_SOURCE_DIR}/compiler/p/runtime/OMRCodeCacheConfig.cpp
		#target
		p/codegen/Evaluator.cpp
		${omr_SOURCE_DIR}/compiler/p/env/OMRDebugEnv.cpp
	)
elseif(OMR_ARCH_S390)
	list(APPEND COMPILERTEST_FILES
		z/codegen/Evaluator.cpp
		${omr_SOURCE_DIR}/compiler/z/env/OMRCPU.cpp
		${omr_SOURCE_DIR}/compiler/z/env/OMRDebugEnv.cpp
	)
endif()

if(OMR_ARCH_X86 OR OMR_ARCH_S390)
	set(OMR_ENHANCED_WARNINGS OFF)
else()
	set(OMR_WARNINGS_AS_ERRORS OFF)
	set(OMR_ENHANCED_WARNINGS OFF)
endif()

# Workaround for deprecated sprintf
if(OMR_OS_OSX)
	set(OMR_WARNINGS_AS_ERRORS OFF)
endif()

create_omr_compiler_library(
	NAME testcompiler
	OBJECTS ${COMPILERTEST_FILES}
	DEFINES
		JITTEST
		TEST_PROJECT_SPECIFIC
		PROD_WITH_ASSUMES
		INCLUDES ${omr_SOURCE_DIR}/fvtest
)

# Export paths for dependent objects
make_compiler_target(testcompiler INTERFACE COMPILER testcompiler)

omr_add_executable(compilertest NOWARNINGS
	tests/main.cpp
	tests/BuilderTest.cpp
	tests/FooBarTest.cpp
	tests/LimitFileTest.cpp
	tests/LogFileTest.cpp
	tests/OMRTestEnv.cpp
	tests/OptionSetTest.cpp
	tests/OpCodesTest.cpp
	tests/Qux2Test.cpp
	tests/SimplifierFoldAndTest.cpp
	tests/OptTestDriver.cpp
	tests/TestDriver.cpp
	tests/SingleBitContainerTest.cpp
	tests/injectors/BarIlInjector.cpp
	tests/injectors/BinaryOpIlInjector.cpp
	tests/injectors/CallIlInjector.cpp
	tests/injectors/ChildlessUnaryOpIlInjector.cpp
	tests/injectors/CmpBranchOpIlInjector.cpp
	tests/injectors/FooIlInjector.cpp
	tests/injectors/IndirectLoadIlInjector.cpp
	tests/injectors/IndirectStoreIlInjector.cpp
	tests/injectors/OpIlInjector.cpp
	tests/injectors/Qux2IlInjector.cpp
	tests/injectors/StoreOpIlInjector.cpp
	tests/injectors/SelectOpIlInjector.cpp
	tests/injectors/UnaryOpIlInjector.cpp
)

if(OMR_ARCH_X86)
	target_sources(compilertest
		PRIVATE
			tests/X86OpCodesTest.cpp
	)
elseif(OMR_ARCH_POWER)
	target_sources(compilertest
		PRIVATE
			tests/PPCOpCodesTest.cpp
	)
elseif(OMR_ARCH_S390)
	target_sources(compilertest
		PRIVATE
			tests/S390OpCodesTest.cpp
	)
endif()

target_link_libraries(compilertest
	testcompiler
	omrGtest
	${CMAKE_DL_LIBS}
	${OMR_PORT_LIB}
)

set_property(TARGET compilertest PROPERTY FOLDER fvtest)

if (NOT OMR_OS_AIX)
	omr_add_test(NAME CompilerTest COMMAND $<TARGET_FILE:compilertest> --gtest_output=xml:${CMAKE_CURRENT_BINARY_DIR}/compilertest-results.xml)
endif()
