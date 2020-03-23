###############################################################################
# Copyright (c) 1991, 2016 IBM Corp. and others
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
# [2] http://openjdk.java.net/legal/assembly-exception.html
#       
# SPDX-License-Identifier: EPL-2.0 OR Apache-2.0 OR GPL-2.0 WITH Classpath-exception-2.0 OR LicenseRef-GPL-2.0 WITH Assembly-exception
###############################################################################

## This macro should be the first statement in every control
## section. The equivalent of CSECT, but without the label.
##

    .macro    START name
    .align    2

##
## Make the symbol externally visible. All the other names are
## local.
##

    .global   \name

##
## On the face of it, this would have seemed to be the right way to
## introduce a control section. But in practise, no symbol gets
## generated. So I've dropped it in favor of a simple text & label
## sequence. Which gives us what we want.
##
##   .section  \name,"ax",@progbits
##

    .text
    .type   \name,@function
\name:
    .endm


##
## Everything this macro does is currently ignored by the assembler.
## But one day there may be something we need to put in here. This
## macro should be placed at the end of every control section.
##

    .macro    END   name
    .ifndef   \name
    .print    "END does not match START"
    .endif
    .size   \name,.-\name
    .ident    "(c) IBM Corp. 2010. JIT compiler support. \name"
    .endm


    .equ r0,0
    .equ r1,1
    .set CARG1,2
    .set CARG2,3
    .set CARG3,4
    .set CARG4,5
    .set CARG5,6
    .equ r2,2
    .equ r3,3
    .equ r4,4
    .equ r5,5
    .equ r8,8
    .equ r9,9
    .equ r10,10
    .equ r11,11
    .equ r12,12
    .equ r13,13
    .set CRA,14
    .equ r15,15

## CARG2 pointer to field
## CARG1 length of the field
## load value to be loaded in r0 0
## load padding value in r1 0

.align 8
       START _j9Z10Zero

         ltgr     CARG2,CARG2
         je       L2L3
         lgr      CARG3,CARG1
         xgr      r1,r0
         xgr      r1,r1
L2L19:
## z6 Limit of three concurrent cache line fetches
         mvcle    CARG2,r0,0(r1)
         jne      L2L19
L2L3:
         br       CRA

       END _j9Z10Zero
