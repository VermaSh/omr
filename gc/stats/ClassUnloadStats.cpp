/*******************************************************************************
 * Copyright IBM Corp. and others 1991
 *
 * This program and the accompanying materials are made available under
 * the terms of the Eclipse Public License 2.0 which accompanies this
 * distribution and is available at https://www.eclipse.org/legal/epl-2.0/
 * or the Apache License, Version 2.0 which accompanies this distribution and
 * is available at https://www.apache.org/licenses/LICENSE-2.0.
 *
 * This Source Code may also be made available under the following
 * Secondary Licenses when the conditions for such availability set
 * forth in the Eclipse Public License, v. 2.0 are satisfied: GNU
 * General Public License, version 2 with the GNU Classpath
 * Exception [1] and GNU General Public License, version 2 with the
 * OpenJDK Assembly Exception [2].
 *
 * [1] https://www.gnu.org/software/classpath/license.html
 * [2] https://openjdk.org/legal/assembly-exception.html
 *
 * SPDX-License-Identifier: EPL-2.0 OR Apache-2.0 OR GPL-2.0-only WITH Classpath-exception-2.0 OR GPL-2.0-only WITH OpenJDK-assembly-exception-1.0
 *******************************************************************************/

#include "ClassUnloadStats.hpp"

void
MM_ClassUnloadStats::clear()
{
	_classLoaderUnloadedCount = 0;
	_classLoaderCandidates = 0;
	_classesUnloadedCount = 0;
	_anonymousClassesUnloadedCount = 0;
	_startTime = 0;
	_endTime = 0;
	_startSetupTime = 0;
	_endSetupTime = 0;
	_startScanTime = 0;
	_endScanTime = 0;
	_startPostTime = 0;
	_endPostTime = 0;
	_classUnloadMutexQuiesceTime = 0;
}

void
MM_ClassUnloadStats::updateUnloadedCounters(uintptr_t anonymous, uintptr_t classes, uintptr_t classloaders)
{
	_classLoaderUnloadedCount = classloaders;
	_classesUnloadedCount = classes;
	_anonymousClassesUnloadedCount = anonymous;

	_classLoaderUnloadedCountCumulative += classloaders;
	_classesUnloadedCountCumulative += classes;
	_anonymousClassesUnloadedCountCumulative += anonymous;

}

void
MM_ClassUnloadStats::getUnloadedCountersCumulative(uintptr_t *anonymous, uintptr_t *classes, uintptr_t *classloaders)
{
	if (NULL != anonymous) {
		*anonymous = _anonymousClassesUnloadedCountCumulative;
	}
	if (NULL != classes) {
		*classes = _classesUnloadedCountCumulative;
	}
	if (NULL != classloaders) {
		*classloaders = _classLoaderUnloadedCountCumulative;
	}
}
