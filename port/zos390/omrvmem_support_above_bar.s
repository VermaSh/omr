***********************************************************************
* Copyright IBM Corp. and others 1991
* 
* This program and the accompanying materials are made available 
* under the terms of the Eclipse Public License 2.0 which accompanies 
* this distribution and is available at  
* https://www.eclipse.org/legal/epl-2.0/ or the Apache License, 
* Version 2.0 which accompanies this distribution and
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
* SPDX-License-Identifier: EPL-2.0 OR Apache-2.0 OR
* GPL-2.0-only WITH Classpath-exception-2.0 OR
* GPL-2.0-only WITH OpenJDK-assembly-exception-1.0
***********************************************************************

         TITLE 'omrvmem_support_above_bar'

*** Please note: This file contains 2 Macros:
*
* NOTE: Each of these macro definitions start with "MACRO" and end
*       with "MEND"
*
* 1. MYPROLOG. This was needed for the METAL C compiler implementation
*       of omrallocate_large_pages and omrfree_large_pages (implemented
*       at bottom).
* 2. MYEPILOG. See explanation for MYPROLOG
*
*** This file also includes multiple HLASM calls to IARV64 HLASM 
* 		macro
*		- These calls were generated using the METAL-C compiler
*		- See omriarv64.c for details/instructions.
*
         MACRO                                                                 
&NAME    MYPROLOG                                                              
         GBLC  &CCN_PRCN                                                       
         GBLC  &CCN_LITN                                                       
         GBLC  &CCN_BEGIN                                                      
         GBLC  &CCN_ARCHLVL                                                    
         GBLA  &CCN_DSASZ                                                      
         GBLA  &CCN_RLOW                                                       
         GBLA  &CCN_RHIGH                                                      
         GBLB  &CCN_NAB                                                        
         GBLB  &CCN_LP64                                                       
         LARL  15,&CCN_LITN                                                    
         USING &CCN_LITN,15                                                    
         GBLA  &MY_DSASZ                                                       
&MY_DSASZ SETA 0                                                                
         AIF   (&CCN_LP64).LP64_1                                               
         STM   14,12,12(13)                                                     
         AGO   .NEXT_1                                                          
.LP64_1  ANOP                                                                   
         STMG  14,12,8(13)                                                      
.NEXT_1  ANOP                                                                   
         AIF   (&CCN_DSASZ LE 0).DROP                                           
&MY_DSASZ SETA &CCN_DSASZ                                                       
         AIF   (&CCN_DSASZ GT 32767).USELIT                                     
         AIF   (&CCN_LP64).LP64_2                                               
         LHI   0,&CCN_DSASZ                                                     
         AGO   .NEXT_2                                                          
.LP64_2  ANOP                                                                   
         LGHI  0,&CCN_DSASZ                                                     
         AGO   .NEXT_2                                                          
.USELIT  ANOP                                                                   
         AIF   (&CCN_LP64).LP64_3                                               
         L     0,=F'&CCN_DSASZ'                                                 
         AGO   .NEXT_2                                                          
.LP64_3  ANOP                                                                   
         LGF   0,=F'&CCN_DSASZ'                                                 
.NEXT_2  AIF   (NOT &CCN_NAB).GETDSA                                            
&MY_DSASZ SETA &MY_DSASZ+1048576                                                
         LA    1,1                                                              
         SLL   1,20                                                             
         AIF   (&CCN_LP64).LP64_4                                               
         AR    0,1                                                              
         AGO   .GETDSA                                                          
.LP64_4  ANOP                                                                   
         AGR   0,1                                                              
.GETDSA ANOP                                                                    
         STORAGE OBTAIN,LENGTH=(0),BNDRY=PAGE                                   
         AIF   (&CCN_LP64).LP64_5                                               
         LR    15,1                                                             
         ST    15,8(,13)                                                        
         L     1,24(,13)                                                        
         ST    13,4(,15)                                                        
         LR    13,15                                                            
         AGO   .DROP                                                            
.LP64_5  ANOP                                                                   
         LGR   15,1                                                             
         STG   15,136(,13)                                                      
         LG    1,32(,13)                                                        
         STG   13,128(,15)                                                      
         LGR   13,15                                                            
.DROP    ANOP                                                                   
         DROP  15                                                               
         MEND                                                                   
         MACRO                                                                  
&NAME    MYEPILOG                                                               
         GBLC  &CCN_PRCN                                                        
         GBLC  &CCN_LITN                                                        
         GBLC  &CCN_BEGIN                                                       
         GBLC  &CCN_ARCHLVL                                                     
         GBLA  &CCN_DSASZ                                                       
         GBLA  &CCN_RLOW                                                        
         GBLA  &CCN_RHIGH                                                       
         GBLB  &CCN_NAB                                                         
         GBLB  &CCN_LP64                                                        
         GBLA  &MY_DSASZ                                                        
         AIF   (&MY_DSASZ EQ 0).NEXT_1                                          
         AIF   (&CCN_LP64).LP64_1                                               
         LR    1,13                                                             
         AGO   .NEXT_1                                                          
.LP64_1  ANOP                                                                   
         LGR   1,13                                                             
.NEXT_1  ANOP                                                                   
         AIF   (&CCN_LP64).LP64_2                                               
         L     13,4(,13)                                                        
         AGO   .NEXT_2                                                          
.LP64_2  ANOP                                                                   
         LG    13,128(,13)                                                      
.NEXT_2  ANOP                                                                   
         AIF   (&MY_DSASZ EQ 0).NODSA                                           
         AIF   (&CCN_LP64).LP64_3                                               
         ST    15,16(,13)                                                       
         AGO   .NEXT_3                                                          
.LP64_3  ANOP                                                                   
         STG   15,16(,13)                                                       
.NEXT_3  ANOP                                                                   
         LARL  15,&CCN_LITN                                                     
         USING &CCN_LITN,15                                                     
         STORAGE RELEASE,LENGTH=&MY_DSASZ,ADDR=(1)                              
         AIF   (&CCN_LP64).LP64_4                                               
         L     15,16(,13)                                                       
         AGO   .NEXT_4                                                          
.LP64_4  ANOP                                                                   
         LG    15,16(,13)                                                       
.NEXT_4  ANOP                                                                   
.NODSA   ANOP                                                                   
         AIF   (&CCN_LP64).LP64_5                                               
         L     14,12(,13)                                                       
         LM    1,12,24(13)                                                      
         AGO   .NEXT_5                                                          
.LP64_5  ANOP                                                                   
         LG    14,8(,13)                                                        
         LMG   1,12,32(13)                                                      
.NEXT_5  ANOP                                                                   
         BR    14                                                              
         DROP  15                                                               
         MEND
*
**************************************************
* Insert contents of omriarv64.s below
**************************************************
*
         ACONTROL AFPR                                                   000000
OMRIARV64 CSECT                                                          000000
OMRIARV64 AMODE 64                                                       000000
OMRIARV64 RMODE ANY                                                      000000
         GBLA  &CCN_DSASZ              DSA size of the function          000000
         GBLA  &CCN_SASZ               Save Area Size of this function   000000
         GBLA  &CCN_ARGS               Number of fixed parameters        000000
         GBLA  &CCN_RLOW               High GPR on STM/STMG              000000
         GBLA  &CCN_RHIGH              Low GPR for STM/STMG              000000
         GBLB  &CCN_MAIN               True if function is main          000000
         GBLB  &CCN_LP64               True if compiled with LP64        000000
         GBLB  &CCN_NAB                True if NAB needed                000000
.* &CCN_NAB is to indicate if there are called functions that depend on  000000
.* stack space being pre-allocated. When &CCN_NAB is true you'll need    000000
.* to add a generous amount to the size set in &CCN_DSASZ when you       000000
.* obtain the stack space.                                               000000
         GBLB  &CCN_ALTGPR(16)         Altered GPRs by the function      000000
         GBLB  &CCN_SASIG              True to gen savearea signature    000000
         GBLC  &CCN_PRCN               Entry symbol of the function      000000
         GBLC  &CCN_CSECT              CSECT name of the file            000000
         GBLC  &CCN_LITN               Symbol name for LTORG             000000
         GBLC  &CCN_BEGIN              Symbol name for function body     000000
         GBLC  &CCN_ARCHLVL            n in ARCH(n) option               000000
         GBLC  &CCN_ASCM               A=AR mode P=Primary mode          000000
         GBLC  &CCN_NAB_OFFSET         Offset to NAB pointer in DSA      000000
         GBLB  &CCN_NAB_STORED         True if NAB pointer stored        000000
         GBLC  &CCN_PRCN_LONG          Full func name up to 1024 chars   000000
         GBLB  &CCN_STATIC             True if function is static        000000
         GBLB  &CCN_RENT               True if compiled with RENT        000000
         GBLB  &CCN_APARSE             True to parse OS PARM             000000
&CCN_SASIG SETB 1                                                        000000
&CCN_LP64 SETB 1                                                         000000
&CCN_RENT SETB 0                                                         000000
&CCN_APARSE SETB 1                                                       000000
&CCN_CSECT SETC 'OMRIARV64'                                              000000
&CCN_ARCHLVL SETC '10'                                                   000000
         SYSSTATE ARCHLVL=2,AMODE64=YES                                  000000
         IEABRCX DEFINE                                                  000000
.* The HLASM GOFF option is needed to assemble this program              000000
@@CCN@113 ALIAS C'omrdiscard_data'                                       000000
@@CCN@104 ALIAS C'omradd_guard'                                          000000
@@CCN@95 ALIAS C'omrremove_guard'                                        000000
@@CCN@87 ALIAS C'omrfree_memory_above_bar'                               000000
@@CCN@78 ALIAS C'omrallocate_4K_pages_guarded_above_bar'                 000000
@@CCN@69 ALIAS C'omrallocate_4K_pages_above_bar'                         000000
@@CCN@58 ALIAS C'omrallocate_4K_pages_guarded_in_userExtendedPrivateAreX 000000
               a'                                                        000000
@@CCN@47 ALIAS C'omrallocate_4K_pages_in_userExtendedPrivateArea'        000000
@@CCN@36 ALIAS C'omrallocate_2G_pages'                                   000000
@@CCN@25 ALIAS C'omrallocate_1M_pageable_pages_guarded_above_bar'        000000
@@CCN@14 ALIAS C'omrallocate_1M_pageable_pages_above_bar'                000000
@@CCN@2  ALIAS C'omrallocate_1M_fixed_pages'                             000000
* /********************************************************************  000001
*  * Copyright IBM Corp. and others 1991                                 000002
*  *                                                                     000003
*  * This program and the accompanying materials are made available und  000004
*  * the terms of the Eclipse Public License 2.0 which accompanies this  000005
*  * distribution and is available at https://www.eclipse.org/legal/epl  000006
*  * or the Apache License, Version 2.0 which accompanies this distribu  000007
*  * is available at https://www.apache.org/licenses/LICENSE-2.0.        000008
*  *                                                                     000009
*  * This Source Code may also be made available under the following     000010
*  * Secondary Licenses when the conditions for such availability set    000011
*  * forth in the Eclipse Public License, v. 2.0 are satisfied: GNU      000012
*  * General Public License, version 2 with the GNU Classpath            000013
*  * Exception [1] and GNU General Public License, version 2 with the    000014
*  * OpenJDK Assembly Exception [2].                                     000015
*  *                                                                     000016
*  * [1] https://www.gnu.org/software/classpath/license.html             000017
*  * [2] https://openjdk.org/legal/assembly-exception.html               000018
*  *                                                                     000019
*  * SPDX-License-Identifier: EPL-2.0 OR Apache-2.0 OR GPL-2.0-only WIT  000020
*  ********************************************************************  000021
*                                                                        000022
* /*                                                                     000023
*  * This file is used to generate the HLASM corresponding to the C cal  000024
*  * that use the IARV64 macro in omrvmem.c                              000025
*  *                                                                     000026
*  * This file is compiled manually using the METAL-C compiler that was  000027
*  * introduced in z/OS V1R9. The generated output (omriarv64.s) is the  000028
*  * inserted into omrvmem_support_above_bar.s which is compiled by our  000029
*  *                                                                     000030
*  * omrvmem_support_above_bar.s indicates where to put the contents of  000031
*  * Search for:                                                         000032
*  *   Insert contents of omriarv64.s below                              000033
*  *                                                                     000034
*  * *******                                                             000035
*  * NOTE!!!!! You must strip the line numbers from any pragma statemen  000036
*  * *******                                                             000037
*  *                                                                     000038
*  * It should be obvious, however, just to be clear be sure to omit th  000039
*  * first two lines from omriarv64.s which will look something like:    000040
*  *                                                                     000041
*  *          TITLE '5694A01 V1.9 z/OS XL C                              000042
*  *                     ./omriarv64.c'                                  000043
*  *                                                                     000044
*  * To compile:                                                         000045
*  *  xlc -S -qmetal -Wc,lp64 -qlongname omriarv64.c                     000046
*  *                                                                     000047
*  * z/OS V1R9 z/OS V1R9.0 Metal C Programming Guide and Reference:      000048
*  *   http://publibz.boulder.ibm.com/epubs/pdf/ccrug100.pdf             000049
*  */                                                                    000050
*                                                                        000051
* #include "omriarv64.h"                                                 000052
*                                                                        000053
* #pragma prolog(omrallocate_1M_fixed_pages,"MYPROLOG")                  000054
* #pragma epilog(omrallocate_1M_fixed_pages,"MYEPILOG")                  000055
*                                                                        000056
* __asm(" IARV64 PLISTVER=MAX,MF=(L,LGETSTOR)":"DS"(lgetstor));          000057
*                                                                        000058
* /*                                                                     000059
*  * Allocate 1MB fixed pages using IARV64 system macro.                 000060
*  * Memory allocated is freed using omrfree_memory_above_bar().         000061
*  *                                                                     000062
*  * @params[in] numMBSegments Number of 1MB segments to be allocated    000063
*  * @params[in] userExtendedPrivateAreaMemoryType capability of OS: 0   000064
*  *                                                                     000065
*  * @return pointer to memory allocated, NULL on failure.               000066
*  */                                                                    000067
* void * omrallocate_1M_fixed_pages(int *numMBSegments, int *userExtend  000068
*  long segments;                                                        000069
*  long origin;                                                          000070
*  long useMemoryType = *userExtendedPrivateAreaMemoryType;              000071
*  int  iarv64_rc = 0;                                                   000072
*  __asm(" IARV64 PLISTVER=MAX,MF=(L,LGETSTOR)":"DS"(wgetstor));         000073
*                                                                        000074
*  segments = *numMBSegments;                                            000075
*  wgetstor = lgetstor;                                                  000076
*                                                                        000077
*  switch (useMemoryType) {                                              000078
*  case ZOS64_VMEM_ABOVE_BAR_GENERAL:                                    000079
*   __asm(" IARV64 REQUEST=GETSTOR,COND=YES,SADMP=NO,CONTROL=UNAUTH,PAG  000080
*     "SEGMENTS=(%2),ORIGIN=(%1),TTOKEN=(%4),RETCODE=%0,MF=(E,(%3))"\    000081
*     ::"m"(iarv64_rc),"r"(&origin),"r"(&segments),"r"(&wgetstor),"r"(t  000082
*   break;                                                               000083
*  case ZOS64_VMEM_2_TO_32G:                                             000084
*   __asm(" IARV64 REQUEST=GETSTOR,COND=YES,SADMP=NO,USE2GTO32G=YES,"\   000085
*     "CONTROL=UNAUTH,PAGEFRAMESIZE=1MEG,"\                              000086
*     "SEGMENTS=(%2),ORIGIN=(%1),TTOKEN=(%4),RETCODE=%0,MF=(E,(%3))"\    000087
*     ::"m"(iarv64_rc),"r"(&origin),"r"(&segments),"r"(&wgetstor),"r"(t  000088
*   break;                                                               000089
*  case ZOS64_VMEM_2_TO_64G:                                             000090
*   __asm(" IARV64 REQUEST=GETSTOR,COND=YES,SADMP=NO,USE2GTO64G=YES,"\   000091
*     "CONTROL=UNAUTH,PAGEFRAMESIZE=1MEG,"\                              000092
*     "SEGMENTS=(%2),ORIGIN=(%1),TTOKEN=(%4),RETCODE=%0,MF=(E,(%3))"\    000093
*     ::"m"(iarv64_rc),"r"(&origin),"r"(&segments),"r"(&wgetstor),"r"(t  000094
*   break;                                                               000095
*  }                                                                     000096
*                                                                        000097
*  if (0 != iarv64_rc) {                                                 000098
*   return (void *)0;                                                    000099
*  }                                                                     000100
*  return (void *)origin;                                                000101
* }                                                                      000102
*                                                                        000103
* #pragma prolog(omrallocate_1M_pageable_pages_above_bar,"MYPROLOG")     000104
* #pragma epilog(omrallocate_1M_pageable_pages_above_bar,"MYEPILOG")     000105
*                                                                        000106
* __asm(" IARV64 PLISTVER=MAX,MF=(L,NGETSTOR)":"DS"(ngetstor));          000107
*                                                                        000108
* /*                                                                     000109
*  * Allocate 1MB pageable pages above 2GB bar using IARV64 system macr  000110
*  * Memory allocated is freed using omrfree_memory_above_bar().         000111
*  *                                                                     000112
*  * @params[in] numMBSegments Number of 1MB segments to be allocated    000113
*  * @params[in] userExtendedPrivateAreaMemoryType capability of OS: 0   000114
*  *                                                                     000115
*  * @return pointer to memory allocated, NULL on failure.               000116
*  */                                                                    000117
* void * omrallocate_1M_pageable_pages_above_bar(int *numMBSegments, in  000118
*  long segments;                                                        000119
*  long origin;                                                          000120
*  long useMemoryType = *userExtendedPrivateAreaMemoryType;              000121
*  int  iarv64_rc = 0;                                                   000122
*                                                                        000123
*  __asm(" IARV64 PLISTVER=MAX,MF=(L,NGETSTOR)":"DS"(wgetstor));         000124
*                                                                        000125
*  segments = *numMBSegments;                                            000126
*  wgetstor = ngetstor;                                                  000127
*                                                                        000128
*  switch (useMemoryType) {                                              000129
*  case ZOS64_VMEM_ABOVE_BAR_GENERAL:                                    000130
*   __asm(" IARV64 REQUEST=GETSTOR,COND=YES,SADMP=NO,CONTROL=UNAUTH,"\   000131
*     "PAGEFRAMESIZE=PAGEABLE1MEG,TYPE=PAGEABLE,SEGMENTS=(%2),"\         000132
*     "ORIGIN=(%1),TTOKEN=(%4),RETCODE=%0,MF=(E,(%3))"\                  000133
*     ::"m"(iarv64_rc),"r"(&origin),"r"(&segments),"r"(&wgetstor),"r"(t  000134
*   break;                                                               000135
*  case ZOS64_VMEM_2_TO_32G:                                             000136
*   __asm(" IARV64 REQUEST=GETSTOR,COND=YES,SADMP=NO,CONTROL=UNAUTH,USE  000137
*     "PAGEFRAMESIZE=PAGEABLE1MEG,TYPE=PAGEABLE,SEGMENTS=(%2),"\         000138
*     "ORIGIN=(%1),TTOKEN=(%4),RETCODE=%0,MF=(E,(%3))"\                  000139
*     ::"m"(iarv64_rc),"r"(&origin),"r"(&segments),"r"(&wgetstor),"r"(t  000140
*   break;                                                               000141
*  case ZOS64_VMEM_2_TO_64G:                                             000142
*   __asm(" IARV64 REQUEST=GETSTOR,COND=YES,SADMP=NO,CONTROL=UNAUTH,USE  000143
*     "PAGEFRAMESIZE=PAGEABLE1MEG,TYPE=PAGEABLE,SEGMENTS=(%2),"\         000144
*     "ORIGIN=(%1),TTOKEN=(%4),RETCODE=%0,MF=(E,(%3))"\                  000145
*     ::"m"(iarv64_rc),"r"(&origin),"r"(&segments),"r"(&wgetstor),"r"(t  000146
*   break;                                                               000147
*  }                                                                     000148
*                                                                        000149
*  if (0 != iarv64_rc) {                                                 000150
*   return (void *)0;                                                    000151
*  }                                                                     000152
*  return (void *)origin;                                                000153
* }                                                                      000154
*                                                                        000155
* #pragma prolog(omrallocate_1M_pageable_pages_guarded_above_bar,"MYPRO  000156
* #pragma epilog(omrallocate_1M_pageable_pages_guarded_above_bar,"MYEPI  000157
*                                                                        000158
* __asm(" IARV64 PLISTVER=MAX,MF=(L,SGETSTOR)":"DS"(sgetstor));          000159
*                                                                        000160
* /*                                                                     000161
*  * Allocate 1MB pageable guarded pages above 2GB bar using IARV64 sys  000162
*  * Memory allocated is freed using omrfree_memory_above_bar().         000163
*  *                                                                     000164
*  * @params[in] numMBSegments Number of 1MB segments to be allocated    000165
*  * @params[in] userExtendedPrivateAreaMemoryType capability of OS: 0   000166
*  *                                                                     000167
*  * @return pointer to memory allocated, NULL on failure.               000168
*  */                                                                    000169
* void *omrallocate_1M_pageable_pages_guarded_above_bar(int *numMBSegme  000170
*  long segments;                                                        000171
*  long origin;                                                          000172
*  long useMemoryType = *userExtendedPrivateAreaMemoryType;              000173
*  int  iarv64_rc = 0;                                                   000174
*                                                                        000175
*  __asm(" IARV64 PLISTVER=MAX,MF=(L,SGETSTOR)":"DS"(wgetstor));         000176
*                                                                        000177
*  segments = *numMBSegments;                                            000178
*  wgetstor = ngetstor;                                                  000179
*                                                                        000180
*  switch (useMemoryType) {                                              000181
*  case ZOS64_VMEM_ABOVE_BAR_GENERAL:                                    000182
*   __asm(" IARV64 REQUEST=GETSTOR,COND=YES,SADMP=NO,CONTROL=UNAUTH,"\   000183
*     "GUARDSIZE64=(%2),"\                                               000184
*     "PAGEFRAMESIZE=PAGEABLE1MEG,TYPE=PAGEABLE,SEGMENTS=(%2),"\         000185
*     "ORIGIN=(%1),TTOKEN=(%4),RETCODE=%0,MF=(E,(%3))"\                  000186
*     ::"m"(iarv64_rc),"r"(&origin),"r"(&segments),"r"(&wgetstor),"r"(t  000187
*   break;                                                               000188
*  case ZOS64_VMEM_2_TO_32G:                                             000189
*   __asm(" IARV64 REQUEST=GETSTOR,COND=YES,SADMP=NO,CONTROL=UNAUTH,USE  000190
*     "GUARDSIZE64=(%2),"\                                               000191
*     "PAGEFRAMESIZE=PAGEABLE1MEG,TYPE=PAGEABLE,SEGMENTS=(%2),"\         000192
*     "ORIGIN=(%1),TTOKEN=(%4),RETCODE=%0,MF=(E,(%3))"\                  000193
*     ::"m"(iarv64_rc),"r"(&origin),"r"(&segments),"r"(&wgetstor),"r"(t  000194
*   break;                                                               000195
*  case ZOS64_VMEM_2_TO_64G:                                             000196
*   __asm(" IARV64 REQUEST=GETSTOR,COND=YES,SADMP=NO,CONTROL=UNAUTH,USE  000197
*     "GUARDSIZE64=(%2),"\                                               000198
*     "PAGEFRAMESIZE=PAGEABLE1MEG,TYPE=PAGEABLE,SEGMENTS=(%2),"\         000199
*     "ORIGIN=(%1),TTOKEN=(%4),RETCODE=%0,MF=(E,(%3))"\                  000200
*     ::"m"(iarv64_rc),"r"(&origin),"r"(&segments),"r"(&wgetstor),"r"(t  000201
*   break;                                                               000202
*  }                                                                     000203
*                                                                        000204
*  if (0 != iarv64_rc) {                                                 000205
*   return (void *)0;                                                    000206
*  }                                                                     000207
*  return (void *)origin;                                                000208
* }                                                                      000209
*                                                                        000210
* #pragma prolog(omrallocate_2G_pages,"MYPROLOG")                        000211
* #pragma epilog(omrallocate_2G_pages,"MYEPILOG")                        000212
*                                                                        000213
* __asm(" IARV64 PLISTVER=MAX,MF=(L,OGETSTOR)":"DS"(ogetstor));          000214
*                                                                        000215
* /*                                                                     000216
*  * Allocate 2GB fixed pages using IARV64 system macro.                 000217
*  * Memory allocated is freed using omrfree_memory_above_bar().         000218
*  *                                                                     000219
*  * @params[in] num2GBUnits Number of 2GB units to be allocated         000220
*  * @params[in] userExtendedPrivateAreaMemoryType capability of OS: 0   000221
*  *                                                                     000222
*  * @return pointer to memory allocated, NULL on failure.               000223
*  */                                                                    000224
* void * omrallocate_2G_pages(int *num2GBUnits, int *userExtendedPrivat  000225
*  long units;                                                           000226
*  long origin;                                                          000227
*  long useMemoryType = *userExtendedPrivateAreaMemoryType;              000228
*  int  iarv64_rc = 0;                                                   000229
*                                                                        000230
*  __asm(" IARV64 PLISTVER=MAX,MF=(L,OGETSTOR)":"DS"(wgetstor));         000231
*                                                                        000232
*  units = *num2GBUnits;                                                 000233
*  wgetstor = ogetstor;                                                  000234
*                                                                        000235
*  switch (useMemoryType) {                                              000236
*  case ZOS64_VMEM_ABOVE_BAR_GENERAL:                                    000237
*   __asm(" IARV64 REQUEST=GETSTOR,COND=YES,SADMP=NO,CONTROL=UNAUTH,"\   000238
*     "PAGEFRAMESIZE=2G,TYPE=FIXED,UNITSIZE=2G,UNITS=(%2),"\             000239
*     "ORIGIN=(%1),TTOKEN=(%4),RETCODE=%0,MF=(E,(%3))"\                  000240
*     ::"m"(iarv64_rc),"r"(&origin),"r"(&units),"r"(&wgetstor),"r"(ttkn  000241
*   break;                                                               000242
*  case ZOS64_VMEM_2_TO_32G:                                             000243
*   __asm(" IARV64 REQUEST=GETSTOR,COND=YES,SADMP=NO,CONTROL=UNAUTH,USE  000244
*     "PAGEFRAMESIZE=2G,TYPE=FIXED,UNITSIZE=2G,UNITS=(%2),"\             000245
*     "ORIGIN=(%1),TTOKEN=(%4),RETCODE=%0,MF=(E,(%3))"\                  000246
*     ::"m"(iarv64_rc),"r"(&origin),"r"(&units),"r"(&wgetstor),"r"(ttkn  000247
*   break;                                                               000248
*  case ZOS64_VMEM_2_TO_64G:                                             000249
*   __asm(" IARV64 REQUEST=GETSTOR,COND=YES,SADMP=NO,CONTROL=UNAUTH,USE  000250
*     "PAGEFRAMESIZE=2G,TYPE=FIXED,UNITSIZE=2G,UNITS=(%2),"\             000251
*     "ORIGIN=(%1),TTOKEN=(%4),RETCODE=%0,MF=(E,(%3))"\                  000252
*     ::"m"(iarv64_rc),"r"(&origin),"r"(&units),"r"(&wgetstor),"r"(ttkn  000253
*   break;                                                               000254
*  }                                                                     000255
*                                                                        000256
*  if (0 != iarv64_rc) {                                                 000257
*   return (void *)0;                                                    000258
*  }                                                                     000259
*  return (void *)origin;                                                000260
* }                                                                      000261
*                                                                        000262
* #pragma prolog(omrallocate_4K_pages_in_userExtendedPrivateArea,"MYPRO  000263
* #pragma epilog(omrallocate_4K_pages_in_userExtendedPrivateArea,"MYEPI  000264
*                                                                        000265
* __asm(" IARV64 PLISTVER=MAX,MF=(L,MGETSTOR)":"DS"(mgetstor));          000266
*                                                                        000267
* /*                                                                     000268
*  * Allocate 4KB pages in 2G-32G range using IARV64 system macro.       000269
*  * Memory allocated is freed using omrfree_memory_above_bar().         000270
*  *                                                                     000271
*  * @params[in] numMBSegments Number of 1MB segments to be allocated    000272
*  * @params[in] userExtendedPrivateAreaMemoryType capability of OS: 0   000273
*  *                                                                     000274
*  * @return pointer to memory allocated, NULL on failure.               000275
*  */                                                                    000276
* void * omrallocate_4K_pages_in_userExtendedPrivateArea(int *numMBSegm  000277
*  long segments;                                                        000278
*  long origin;                                                          000279
*  long useMemoryType = *userExtendedPrivateAreaMemoryType;              000280
*  int  iarv64_rc = 0;                                                   000281
*                                                                        000282
*  __asm(" IARV64 PLISTVER=MAX,MF=(L,MGETSTOR)":"DS"(wgetstor));         000283
*                                                                        000284
*  segments = *numMBSegments;                                            000285
*  wgetstor = mgetstor;                                                  000286
*                                                                        000287
*  switch (useMemoryType) {                                              000288
*  case ZOS64_VMEM_ABOVE_BAR_GENERAL:                                    000289
*   break;                                                               000290
*  case ZOS64_VMEM_2_TO_32G:                                             000291
*   __asm(" IARV64 REQUEST=GETSTOR,COND=YES,SADMP=NO,USE2GTO32G=YES,"\   000292
*     "CONTROL=UNAUTH,PAGEFRAMESIZE=4K,"\                                000293
*     "SEGMENTS=(%2),ORIGIN=(%1),TTOKEN=(%4),RETCODE=%0,MF=(E,(%3))"\    000294
*     ::"m"(iarv64_rc),"r"(&origin),"r"(&segments),"r"(&wgetstor),"r"(t  000295
*   break;                                                               000296
*  case ZOS64_VMEM_2_TO_64G:                                             000297
*   __asm(" IARV64 REQUEST=GETSTOR,COND=YES,SADMP=NO,USE2GTO64G=YES,"\   000298
*     "CONTROL=UNAUTH,PAGEFRAMESIZE=4K,"\                                000299
*     "SEGMENTS=(%2),ORIGIN=(%1),TTOKEN=(%4),RETCODE=%0,MF=(E,(%3))"\    000300
*     ::"m"(iarv64_rc),"r"(&origin),"r"(&segments),"r"(&wgetstor),"r"(t  000301
*   break;                                                               000302
*  }                                                                     000303
*                                                                        000304
*  if (0 != iarv64_rc) {                                                 000305
*   return (void *)0;                                                    000306
*  }                                                                     000307
*  return (void *)origin;                                                000308
* }                                                                      000309
*                                                                        000310
* #pragma prolog(omrallocate_4K_pages_guarded_in_userExtendedPrivateAre  000311
* #pragma epilog(omrallocate_4K_pages_guarded_in_userExtendedPrivateAre  000312
*                                                                        000313
* __asm(" IARV64 PLISTVER=MAX,MF=(L,TGETSTOR)":"DS"(tgetstor));          000314
*                                                                        000315
* /*                                                                     000316
*  * Allocate 4KB pages guarded in 2G-32G range using IARV64 system mac  000317
*  * Memory allocated is freed using omrfree_memory_above_bar().         000318
*  *                                                                     000319
*  * @params[in] numMBSegments Number of 1MB segments to be allocated    000320
*  * @params[in] userExtendedPrivateAreaMemoryType capability of OS: 0   000321
*  *                                                                     000322
*  * @return pointer to memory allocated, NULL on failure.               000323
*  */                                                                    000324
* void *omrallocate_4K_pages_guarded_in_userExtendedPrivateArea(int *nu  000325
*  long segments;                                                        000326
*  long origin;                                                          000327
*  long useMemoryType = *userExtendedPrivateAreaMemoryType;              000328
*  int  iarv64_rc = 0;                                                   000329
*                                                                        000330
*  __asm(" IARV64 PLISTVER=MAX,MF=(L,TGETSTOR)":"DS"(wgetstor));         000331
*                                                                        000332
*  segments = *numMBSegments;                                            000333
*  wgetstor = tgetstor;                                                  000334
*                                                                        000335
*  switch (useMemoryType) {                                              000336
*  case ZOS64_VMEM_ABOVE_BAR_GENERAL:                                    000337
*   break;                                                               000338
*  case ZOS64_VMEM_2_TO_32G:                                             000339
*   __asm(" IARV64 REQUEST=GETSTOR,COND=NO,SADMP=NO,CONTROL=UNAUTH,USE2  000340
*     "GUARDSIZE64=(%2),PAGEFRAMESIZE=4K,SEGMENTS=(%2),"\                000341
*     "ORIGIN=(%1),TTOKEN=(%4),RETCODE=%0,MF=(E,(%3))"\                  000342
*     ::"m"(iarv64_rc),"r"(&origin),"r"(&segments),"r"(&wgetstor),"r"(t  000343
*   break;                                                               000344
*  case ZOS64_VMEM_2_TO_64G:                                             000345
*   __asm(" IARV64 REQUEST=GETSTOR,COND=NO,SADMP=NO,CONTROL=UNAUTH,USE2  000346
*     "GUARDSIZE64=(%2),PAGEFRAMESIZE=4K,SEGMENTS=(%2),"\                000347
*     "ORIGIN=(%1),TTOKEN=(%4),RETCODE=%0,MF=(E,(%3))"\                  000348
*     ::"m"(iarv64_rc),"r"(&origin),"r"(&segments),"r"(&wgetstor),"r"(t  000349
*   break;                                                               000350
*  }                                                                     000351
*                                                                        000352
*  if (0 != iarv64_rc) {                                                 000353
*   return (void *)0;                                                    000354
*  }                                                                     000355
*  return (void *)origin;                                                000356
* }                                                                      000357
*                                                                        000358
* #pragma prolog(omrallocate_4K_pages_above_bar,"MYPROLOG")              000359
* #pragma epilog(omrallocate_4K_pages_above_bar,"MYEPILOG")              000360
*                                                                        000361
* __asm(" IARV64 PLISTVER=MAX,MF=(L,RGETSTOR)":"DS"(rgetstor));          000362
*                                                                        000363
* /*                                                                     000364
*  * Allocate 4KB pages using IARV64 system macro.                       000365
*  * Memory allocated is freed using omrfree_memory_above_bar().         000366
*  *                                                                     000367
*  * @params[in] numMBSegments Number of 1MB segments to be allocated    000368
*  *                                                                     000369
*  * @return pointer to memory allocated, NULL on failure.               000370
*  */                                                                    000371
* void * omrallocate_4K_pages_above_bar(int *numMBSegments, const char   000372
*  long segments;                                                        000373
*  long origin;                                                          000374
*  int  iarv64_rc = 0;                                                   000375
*                                                                        000376
*  __asm(" IARV64 PLISTVER=MAX,MF=(L,RGETSTOR)":"DS"(wgetstor));         000377
*                                                                        000378
*  segments = *numMBSegments;                                            000379
*  wgetstor = rgetstor;                                                  000380
*                                                                        000381
*  __asm(" IARV64 REQUEST=GETSTOR,COND=YES,SADMP=NO,"\                   000382
*    "CONTROL=UNAUTH,PAGEFRAMESIZE=4K,"\                                 000383
*    "SEGMENTS=(%2),ORIGIN=(%1),TTOKEN=(%4),RETCODE=%0,MF=(E,(%3))"\     000384
*    ::"m"(iarv64_rc),"r"(&origin),"r"(&segments),"r"(&wgetstor),"r"(tt  000385
*                                                                        000386
*  if (0 != iarv64_rc) {                                                 000387
*   return (void *)0;                                                    000388
*  }                                                                     000389
*  return (void *)origin;                                                000390
* }                                                                      000391
*                                                                        000392
* #pragma prolog(omrallocate_4K_pages_guarded_above_bar,"MYPROLOG")      000393
* #pragma epilog(omrallocate_4K_pages_guarded_above_bar,"MYEPILOG")      000394
*                                                                        000395
* __asm(" IARV64 PLISTVER=MAX,MF=(L,EGETSTOR)":"DS"(egetstor));          000396
*                                                                        000397
* void *omrallocate_4K_pages_guarded_above_bar(int *numMBSegments, cons  000398
*  long segments;                                                        000399
*  long origin;                                                          000400
*  int  iarv64_rc = 0;                                                   000401
*                                                                        000402
*  __asm(" IARV64 PLISTVER=MAX,MF=(L,EGETSTOR)":"DS"(wgetstor));         000403
*                                                                        000404
*  segments = *numMBSegments;                                            000405
*  wgetstor = rgetstor;                                                  000406
*                                                                        000407
*  __asm(" IARV64 REQUEST=GETSTOR,COND=YES,SADMP=NO,"\                   000408
*    "GUARDSIZE=(%2),"\                                                  000409
*    "CONTROL=UNAUTH,PAGEFRAMESIZE=4K,"\                                 000410
*    "SEGMENTS=(%2),ORIGIN=(%1),TTOKEN=(%4),RETCODE=%0,MF=(E,(%3))"\     000411
*    ::"m"(iarv64_rc),"r"(&origin),"r"(&segments),"r"(&wgetstor),"r"(tt  000412
*                                                                        000413
*  if (0 != iarv64_rc) {                                                 000414
*   return (void *)0;                                                    000415
*  }                                                                     000416
*  return (void *)origin;                                                000417
* }                                                                      000418
*                                                                        000419
* #pragma prolog(omrfree_memory_above_bar,"MYPROLOG")                    000420
* #pragma epilog(omrfree_memory_above_bar,"MYEPILOG")                    000421
*                                                                        000422
* __asm(" IARV64 PLISTVER=MAX,MF=(L,PGETSTOR)":"DS"(pgetstor));          000423
*                                                                        000424
* /*                                                                     000425
*  * Free memory allocated using IARV64 system macro.                    000426
*  *                                                                     000427
*  * @params[in] address pointer to memory region to be freed            000428
*  *                                                                     000429
*  * @return non-zero if memory is not freed successfully, 0 otherwise.  000430
*  */                                                                    000431
* int omrfree_memory_above_bar(void *address, const char * ttkn){        000432
*  void * xmemobjstart;                                                  000433
*  int  iarv64_rc = 0;                                                   000434
*                                                                        000435
*  __asm(" IARV64 PLISTVER=MAX,MF=(L,PGETSTOR)":"DS"(wgetstor));         000436
*                                                                        000437
*  xmemobjstart = address;                                               000438
*  wgetstor = pgetstor;                                                  000439
*                                                                        000440
*  __asm(" IARV64 REQUEST=DETACH,COND=YES,MEMOBJSTART=(%2),TTOKEN=(%3),  000441
*    ::"m"(iarv64_rc),"r"(&wgetstor),"r"(&xmemobjstart),"r"(ttkn));      000442
*  return iarv64_rc;                                                     000443
* }                                                                      000444
*                                                                        000445
* #pragma prolog(omrremove_guard,"MYPROLOG")                             000446
* #pragma epilog(omrremove_guard,"MYEPILOG")                             000447
*                                                                        000448
* __asm(" IARV64 PLISTVER=MAX,MF=(L,FGETSTOR)":"DS"(fgetstor));          000449
*                                                                        000450
* /*                                                                     000451
*  * Remove guard for memory allocated using IARV64 system macro.        000452
*  *                                                                     000453
*  * @params[in] address pointer to memory region to be freed            000454
*   * @params[in] numMBSegments Number of 1MB segments to be allocated   000455
*  *                                                                     000456
*  * @return non-zero if memory is not freed successfully, 0 otherwise.  000457
*  */                                                                    000458
* int omrremove_guard(void *address, int *numMBSegments){                000459
*  void * memObjConvertStart;                                            000460
*  int  iarv64_rc = 0;                                                   000461
*  long segments;                                                        000462
*                                                                        000463
*  __asm(" IARV64 PLISTVER=MAX,MF=(L,FGETSTOR)":"DS"(wgetstor));         000464
*                                                                        000465
*  memObjConvertStart = address;                                         000466
*  wgetstor = fgetstor;                                                  000467
*  segments = *numMBSegments;                                            000468
*                                                                        000469
*  __asm(" IARV64 REQUEST=CHANGEGUARD,CONVERT=FROMGUARD,COND=YES,"\      000470
*    "CONVERTSTART=(%2),CONVERTSIZE64=(%3),"\                            000471
*    "RETCODE=%0,MF=(E,(%1))"\                                           000472
*    ::"m"(iarv64_rc),"r"(&wgetstor),"r"(&memObjConvertStart),"r"(&segm  000473
*  return iarv64_rc;                                                     000474
* }                                                                      000475
*                                                                        000476
* #pragma prolog(omradd_guard,"MYPROLOG")                                000477
* #pragma epilog(omradd_guard,"MYEPILOG")                                000478
*                                                                        000479
* __asm(" IARV64 PLISTVER=MAX,MF=(L,DGETSTOR)":"DS"(dgetstor));          000480
*                                                                        000481
* /*                                                                     000482
*  * Ass guard to memory allocated using IARV64 system macro.            000483
*  *                                                                     000484
*  * @params[in] address pointer to memory region to be freed            000485
*  *                                                                     000486
*  * @return non-zero if memory is not freed successfully, 0 otherwise.  000487
*  */                                                                    000488
* int omradd_guard(void *address, int *numMBSegments) {                  000489
*  void * memObjConvertStart;                                            000490
*  int  iarv64_rc = 0;                                                   000491
*  long segments;                                                        000492
*                                                                        000493
*  __asm(" IARV64 PLISTVER=MAX,MF=(L,DGETSTOR)":"DS"(wgetstor));         000494
*                                                                        000495
*  memObjConvertStart = address;                                         000496
*  wgetstor = dgetstor;                                                  000497
*  segments = *numMBSegments;                                            000498
*                                                                        000499
*  __asm(" IARV64 REQUEST=CHANGEGUARD,CONVERT=TOGUARD,COND=YES,"\        000500
*    "CONVERTSTART=(%2),CONVERTSIZE64=(%3),"\                            000501
*    "RETCODE=%0,MF=(E,(%1))"\                                           000502
*    ::"m"(iarv64_rc),"r"(&wgetstor),"r"(&memObjConvertStart),"r"(&segm  000503
*  return iarv64_rc;                                                     000504
* }                                                                      000505
*                                                                        000506
* #pragma prolog(omrdiscard_data,"MYPROLOG")                             000507
* #pragma epilog(omrdiscard_data,"MYEPILOG")                             000508
*                                                                        000509
* __asm(" IARV64 PLISTVER=MAX,MF=(L,QGETSTOR)":"DS"(qgetstor));          000510
*                                                                        000511
* /* Used to pass parameters to IARV64 DISCARDDATA in omrdiscard_data()  000512
* struct rangeList {                                                     000513
*  void *startAddr;                                                      000514
*  long pageCount;                                                       000515
* };                                                                     000516
*                                                                        000517
* /*                                                                     000518
*  * Discard memory allocated using IARV64 system macro.                 000519
*  *                                                                     000520
*  * @params[in] address pointer to memory region to be discarded        000521
*  * @params[in] numFrames number of frames to be discarded. Frame size  000522
*  *                                                                     000523
*  * @return non-zero if memory is not discarded successfully, 0 otherw  000524
*  */                                                                    000525
* int omrdiscard_data(void *address, int *numFrames) {                   000526
         J     @@CCN@113                                                 000526
@@PFD@@  DC    XL8'00C300C300D50000'   Prefix Data Marker                000526
         DC    CL8'20260605'           Compiled Date YYYYMMDD            000526
         DC    CL6'123330'             Compiled Time HHMMSS              000526
         DC    XL4'42040000'           Compiler Version                  000526
         DC    XL2'0000'               Reserved                          000526
         DC    BL1'00000000'           Flag Set 1                        000526
         DC    BL1'00000000'           Flag Set 2                        000526
         DC    BL1'00000000'           Flag Set 3                        000526
         DC    BL1'00000000'           Flag Set 4                        000526
         DC    XL4'00000000'           Reserved                          000526
         ENTRY @@CCN@113                                                 000526
@@CCN@113 AMODE 64                                                       000526
         DC    0FD                                                       000526
         DC    XL8'00C300C300D50100'   Function Entry Point Marker       000526
         DC    A(@@FPB@1-*+8)          Signed offset to FPB              000526
         DC    XL4'00000000'           Reserved                          000526
@@CCN@113 DS   0FD                                                       000526
&CCN_PRCN SETC '@@CCN@113'                                               000526
&CCN_PRCN_LONG SETC 'omrdiscard_data'                                    000526
&CCN_LITN SETC '@@LIT@1'                                                 000526
&CCN_BEGIN SETC '@@BGN@1'                                                000526
&CCN_ASCM SETC 'P'                                                       000526
&CCN_DSASZ SETA 472                                                      000526
&CCN_SASZ SETA 144                                                       000526
&CCN_ARGS SETA 2                                                         000526
&CCN_RLOW SETA 14                                                        000526
&CCN_RHIGH SETA 4                                                        000526
&CCN_NAB SETB  0                                                         000526
&CCN_MAIN SETB 0                                                         000526
&CCN_NAB_STORED SETB 0                                                   000526
&CCN_STATIC SETB 0                                                       000526
&CCN_ALTGPR(1) SETB 1                                                    000526
&CCN_ALTGPR(2) SETB 1                                                    000526
&CCN_ALTGPR(3) SETB 1                                                    000526
&CCN_ALTGPR(4) SETB 1                                                    000526
&CCN_ALTGPR(5) SETB 1                                                    000526
&CCN_ALTGPR(6) SETB 0                                                    000526
&CCN_ALTGPR(7) SETB 0                                                    000526
&CCN_ALTGPR(8) SETB 0                                                    000526
&CCN_ALTGPR(9) SETB 0                                                    000526
&CCN_ALTGPR(10) SETB 0                                                   000526
&CCN_ALTGPR(11) SETB 0                                                   000526
&CCN_ALTGPR(12) SETB 0                                                   000526
&CCN_ALTGPR(13) SETB 0                                                   000526
&CCN_ALTGPR(14) SETB 1                                                   000526
&CCN_ALTGPR(15) SETB 1                                                   000526
&CCN_ALTGPR(16) SETB 1                                                   000526
         MYPROLOG                                                        000526
@@BGN@1  DS    0H                                                        000526
         AIF   (NOT &CCN_SASIG).@@NOSIG1                                 000526
         LLILH 4,X'C6F4'                                                 000526
         OILL  4,X'E2C1'                                                 000526
         ST    4,4(,13)                                                  000526
.@@NOSIG1 ANOP                                                           000526
         USING @@AUTO@1,13                                               000526
         LARL  3,@@LIT@1                                                 000526
         USING @@LIT@1,3                                                 000526
         STG   1,464(0,13)             #SR_PARM_1                        000526
*  struct rangeList range;                                               000527
*  void *rangePtr;                                                       000528
*  int iarv64_rc = 0;                                                    000529
         MVHI  @117iarv64_rc@67,0                                        000529
*                                                                        000530
*  __asm(" IARV64 PLISTVER=MAX,MF=(L,MGETSTOR)":"DS"(wgetstor));         000531
*                                                                        000532
*  range.startAddr = address;                                            000533
         LG    14,464(0,13)            #SR_PARM_1                        000533
         USING @@PARMD@1,14                                              000533
         LG    14,@114address@65                                         000533
         STG   14,176(0,13)            range_rangeList_startAddr         000533
*  range.pageCount = *numFrames;                                         000534
         LG    14,464(0,13)            #SR_PARM_1                        000534
         LG    14,@115numFrames                                          000534
         LGF   14,0(0,14)              (*)int                            000534
         STG   14,184(0,13)            range_rangeList_pageCount         000534
*  rangePtr = (void *)&range;                                            000535
         LA    14,@119range                                              000535
         STG   14,@122rangePtr                                           000535
*  wgetstor = qgetstor;                                                  000536
         LARL  14,$STATIC                                                000536
         DROP  14                                                        000536
         USING @@STATICD@@,14                                            000536
         MVC   @118wgetstor,@112qgetstor                                 000536
*                                                                        000537
*  __asm(" IARV64 REQUEST=DISCARDDATA,KEEPREAL=NO,"\                     000538
         LA    2,@122rangePtr                                            000538
         DROP  14                                                        000538
         LA    4,@118wgetstor                                            000538
         IARV64 REQUEST=DISCARDDATA,KEEPREAL=NO,RANGLIST=(2),RETCODE=20X 000538
               0(13),MF=(E,(4))                                          000538
*    "RANGLIST=(%1),RETCODE=%0,MF=(E,(%2))"\                             000539
*    ::"m"(iarv64_rc),"r"(&rangePtr),"r"(&wgetstor));                    000540
*                                                                        000541
*  return iarv64_rc;                                                     000542
         LGF   15,@117iarv64_rc@67                                       000542
* }                                                                      000543
@1L37    DS    0H                                                        000543
         DROP                                                            000543
         MYEPILOG                                                        000543
OMRIARV64 CSECT ,                                                        000543
         DS    0FD                                                       000543
@@LIT@1  LTORG                                                           000000
@@FPB@   LOCTR                                                           000000
@@FPB@1  DS    0FD                     Function Property Block           000000
         DC    XL2'CCD5'               Eyecatcher                        000000
         DC    BL2'1111100000000011'   Saved GPR Mask                    000000
         DC    A(@@PFD@@-@@FPB@1)      Signed Offset to Prefix Data      000000
         DC    BL1'10000000'           Flag Set 1                        000000
         DC    BL1'10000001'           Flag Set 2                        000000
         DC    BL1'00000000'           Flag Set 3                        000000
         DC    BL1'00000001'           Flag Set 4                        000000
         DC    XL4'00000000'           Reserved                          000000
         DC    XL4'00000000'           Reserved                          000000
         DC    AL2(15)                 Function Name                     000000
         DC    C'omrdiscard_data'                                        000000
OMRIARV64 LOCTR                                                          000000
         EJECT                                                           000000
@@AUTO@1 DSECT                                                           000000
         DS    59FD                                                      000000
         ORG   @@AUTO@1                                                  000000
#GPR_SA_1 DS   18FD                                                      000000
         DS    FD                                                        000000
         ORG   @@AUTO@1+176                                              000000
@119range DS   XL16                                                      000000
         ORG   @@AUTO@1+192                                              000000
@122rangePtr DS AD                                                       000000
         ORG   @@AUTO@1+200                                              000000
@117iarv64_rc@67 DS F                                                    000000
         ORG   @@AUTO@1+208                                              000000
@118wgetstor DS XL256                                                    000000
         ORG   @@AUTO@1+464                                              000000
#SR_PARM_1 DS  XL8                                                       000000
@@PARMD@1 DSECT                                                          000000
         DS    XL16                                                      000000
         ORG   @@PARMD@1+0                                               000000
         DS    0FD                                                       000000
@114address@65 DS 0XL8                                                   000000
         ORG   @@PARMD@1+8                                               000000
         DS    0FD                                                       000000
@115numFrames DS 0XL8                                                    000000
         EJECT                                                           000000
OMRIARV64 CSECT ,                                                        000000
* void * omrallocate_1M_fixed_pages(int *numMBSegments, int *userExtend  000068
         ENTRY @@CCN@2                                                   000068
@@CCN@2  AMODE 64                                                        000068
         DC    0FD                                                       000068
         DC    XL8'00C300C300D50100'   Function Entry Point Marker       000068
         DC    A(@@FPB@12-*+8)         Signed offset to FPB              000068
         DC    XL4'00000000'           Reserved                          000068
@@CCN@2  DS    0FD                                                       000068
&CCN_PRCN SETC '@@CCN@2'                                                 000068
&CCN_PRCN_LONG SETC 'omrallocate_1M_fixed_pages'                         000068
&CCN_LITN SETC '@@LIT@12'                                                000068
&CCN_BEGIN SETC '@@BGN@12'                                               000068
&CCN_ASCM SETC 'P'                                                       000068
&CCN_DSASZ SETA 480                                                      000068
&CCN_SASZ SETA 144                                                       000068
&CCN_ARGS SETA 3                                                         000068
&CCN_RLOW SETA 14                                                        000068
&CCN_RHIGH SETA 6                                                        000068
&CCN_NAB SETB  0                                                         000068
&CCN_MAIN SETB 0                                                         000068
&CCN_NAB_STORED SETB 0                                                   000068
&CCN_STATIC SETB 0                                                       000068
&CCN_ALTGPR(1) SETB 1                                                    000068
&CCN_ALTGPR(2) SETB 1                                                    000068
&CCN_ALTGPR(3) SETB 1                                                    000068
&CCN_ALTGPR(4) SETB 1                                                    000068
&CCN_ALTGPR(5) SETB 1                                                    000068
&CCN_ALTGPR(6) SETB 1                                                    000068
&CCN_ALTGPR(7) SETB 1                                                    000068
&CCN_ALTGPR(8) SETB 0                                                    000068
&CCN_ALTGPR(9) SETB 0                                                    000068
&CCN_ALTGPR(10) SETB 0                                                   000068
&CCN_ALTGPR(11) SETB 0                                                   000068
&CCN_ALTGPR(12) SETB 0                                                   000068
&CCN_ALTGPR(13) SETB 0                                                   000068
&CCN_ALTGPR(14) SETB 1                                                   000068
&CCN_ALTGPR(15) SETB 1                                                   000068
&CCN_ALTGPR(16) SETB 1                                                   000068
         MYPROLOG                                                        000068
@@BGN@12 DS    0H                                                        000068
         AIF   (NOT &CCN_SASIG).@@NOSIG12                                000068
         LLILH 6,X'C6F4'                                                 000068
         OILL  6,X'E2C1'                                                 000068
         ST    6,4(,13)                                                  000068
.@@NOSIG12 ANOP                                                          000068
         USING @@AUTO@12,13                                              000068
         LARL  3,@@LIT@12                                                000068
         USING @@LIT@12,3                                                000068
         STG   1,464(0,13)             #SR_PARM_12                       000068
*  long segments;                                                        000069
*  long origin;                                                          000070
*  long useMemoryType = *userExtendedPrivateAreaMemoryType;              000071
         LG    14,464(0,13)            #SR_PARM_12                       000071
         USING @@PARMD@12,14                                             000071
         LG    14,@4userExtendedPrivateAreaMemoryType                    000071
         LGF   14,0(0,14)              (*)int                            000071
         STG   14,@7useMemoryType                                        000071
*  int  iarv64_rc = 0;                                                   000072
         MVHI  @9iarv64_rc,0                                             000072
*  __asm(" IARV64 PLISTVER=MAX,MF=(L,LGETSTOR)":"DS"(wgetstor));         000073
*                                                                        000074
*  segments = *numMBSegments;                                            000075
         LG    14,464(0,13)            #SR_PARM_12                       000075
         LG    14,@3numMBSegments                                        000075
         LGF   14,0(0,14)              (*)int                            000075
         STG   14,@11segments                                            000075
*  wgetstor = lgetstor;                                                  000076
         LARL  14,$STATIC                                                000076
         DROP  14                                                        000076
         USING @@STATICD@@,14                                            000076
         MVC   @10wgetstor,@1lgetstor                                    000076
*                                                                        000077
*  switch (useMemoryType) {                                              000078
         LG    14,@7useMemoryType                                        000078
         STG   14,472(0,13)            #SW_WORK12                        000078
         CLG   14,=X'0000000000000002'                                   000078
         BRH   @12L68                                                    000078
         LG    14,472(0,13)            #SW_WORK12                        000078
         SLLG  14,14,2                                                   000078
         LGFR  15,14                                                     000078
         LARL  14,@@CONST@AREA@@                                         000000
         LGF   14,0(15,14)                                               000078
         B     0(3,14)                                                   000078
@12L68   DS    0H                                                        000078
         BRU   @12L73                                                    000078
*  case ZOS64_VMEM_ABOVE_BAR_GENERAL:                                    000079
*   __asm(" IARV64 REQUEST=GETSTOR,COND=YES,SADMP=NO,CONTROL=UNAUTH,PAG  000080
@12L69   DS    0H                                                        000080
         LA    2,@12origin                                               000080
         DROP  14                                                        000080
         LA    4,@11segments                                             000080
         LA    5,@10wgetstor                                             000080
         LG    14,464(0,13)            #SR_PARM_12                       000080
         USING @@PARMD@12,14                                             000080
         LG    6,@5ttkn                                                  000080
         IARV64 REQUEST=GETSTOR,COND=YES,SADMP=NO,CONTROL=UNAUTH,PAGEFRX 000080
               AMESIZE=1MEG,SEGMENTS=(4),ORIGIN=(2),TTOKEN=(6),RETCODE=X 000080
               200(13),MF=(E,(5))                                        000080
*     "SEGMENTS=(%2),ORIGIN=(%1),TTOKEN=(%4),RETCODE=%0,MF=(E,(%3))"\    000081
*     ::"m"(iarv64_rc),"r"(&origin),"r"(&segments),"r"(&wgetstor),"r"(t  000082
*   break;                                                               000083
         BRU   @12L20                                                    000083
*  case ZOS64_VMEM_2_TO_32G:                                             000084
*   __asm(" IARV64 REQUEST=GETSTOR,COND=YES,SADMP=NO,USE2GTO32G=YES,"\   000085
@12L70   DS    0H                                                        000085
         LA    2,@12origin                                               000085
         LA    4,@11segments                                             000085
         LA    5,@10wgetstor                                             000085
         LG    14,464(0,13)            #SR_PARM_12                       000085
         LG    6,@5ttkn                                                  000085
         IARV64 REQUEST=GETSTOR,COND=YES,SADMP=NO,USE2GTO32G=YES,CONTROX 000085
               L=UNAUTH,PAGEFRAMESIZE=1MEG,SEGMENTS=(4),ORIGIN=(2),TTOKX 000085
               EN=(6),RETCODE=200(13),MF=(E,(5))                         000085
*     "CONTROL=UNAUTH,PAGEFRAMESIZE=1MEG,"\                              000086
*     "SEGMENTS=(%2),ORIGIN=(%1),TTOKEN=(%4),RETCODE=%0,MF=(E,(%3))"\    000087
*     ::"m"(iarv64_rc),"r"(&origin),"r"(&segments),"r"(&wgetstor),"r"(t  000088
*   break;                                                               000089
         BRU   @12L20                                                    000089
*  case ZOS64_VMEM_2_TO_64G:                                             000090
*   __asm(" IARV64 REQUEST=GETSTOR,COND=YES,SADMP=NO,USE2GTO64G=YES,"\   000091
@12L71   DS    0H                                                        000091
         LA    2,@12origin                                               000091
         LA    4,@11segments                                             000091
         LA    5,@10wgetstor                                             000091
         LG    14,464(0,13)            #SR_PARM_12                       000091
         LG    6,@5ttkn                                                  000091
         IARV64 REQUEST=GETSTOR,COND=YES,SADMP=NO,USE2GTO64G=YES,CONTROX 000091
               L=UNAUTH,PAGEFRAMESIZE=1MEG,SEGMENTS=(4),ORIGIN=(2),TTOKX 000091
               EN=(6),RETCODE=200(13),MF=(E,(5))                         000091
*     "CONTROL=UNAUTH,PAGEFRAMESIZE=1MEG,"\                              000092
*     "SEGMENTS=(%2),ORIGIN=(%1),TTOKEN=(%4),RETCODE=%0,MF=(E,(%3))"\    000093
*     ::"m"(iarv64_rc),"r"(&origin),"r"(&segments),"r"(&wgetstor),"r"(t  000094
*   break;                                                               000095
@12L20   DS    0H                                                        000078
@12L73   DS    0H                                                        000000
*  }                                                                     000096
*                                                                        000097
*  if (0 != iarv64_rc) {                                                 000098
         LGF   14,@9iarv64_rc                                            000098
         LTR   14,14                                                     000098
         BRE   @12L19                                                    000098
*   return (void *)0;                                                    000099
         LGHI  15,0                                                      000099
         BRU   @12L21                                                    000099
@12L19   DS    0H                                                        000099
*  }                                                                     000100
*  return (void *)origin;                                                000101
         LG    15,@12origin                                              000101
* }                                                                      000102
@12L21   DS    0H                                                        000102
         DROP                                                            000102
         MYEPILOG                                                        000102
OMRIARV64 CSECT ,                                                        000102
         DS    0FD                                                       000102
@@LIT@12 LTORG                                                           000000
@@FPB@   LOCTR                                                           000000
@@FPB@12 DS    0FD                     Function Property Block           000000
         DC    XL2'CCD5'               Eyecatcher                        000000
         DC    BL2'1111111000000011'   Saved GPR Mask                    000000
         DC    A(@@PFD@@-@@FPB@12)     Signed Offset to Prefix Data      000000
         DC    BL1'10000000'           Flag Set 1                        000000
         DC    BL1'10000001'           Flag Set 2                        000000
         DC    BL1'00000000'           Flag Set 3                        000000
         DC    BL1'00000001'           Flag Set 4                        000000
         DC    XL4'00000000'           Reserved                          000000
         DC    XL4'00000000'           Reserved                          000000
         DC    AL2(26)                 Function Name                     000000
         DC    C'omrallocate_1M_fixed_pages'                             000000
OMRIARV64 LOCTR                                                          000000
         EJECT                                                           000000
@@AUTO@12 DSECT                                                          000000
         DS    60FD                                                      000000
         ORG   @@AUTO@12                                                 000000
#GPR_SA_12 DS  18FD                                                      000000
         DS    FD                                                        000000
         ORG   @@AUTO@12+176                                             000000
@11segments DS FD                                                        000000
         ORG   @@AUTO@12+184                                             000000
@12origin DS   FD                                                        000000
         ORG   @@AUTO@12+192                                             000000
@7useMemoryType DS FD                                                    000000
         ORG   @@AUTO@12+200                                             000000
@9iarv64_rc DS F                                                         000000
         ORG   @@AUTO@12+208                                             000000
@10wgetstor DS XL256                                                     000000
         ORG   @@AUTO@12+464                                             000000
#SR_PARM_12 DS XL8                                                       000000
@@PARMD@12 DSECT                                                         000000
         DS    XL24                                                      000000
         ORG   @@PARMD@12+0                                              000000
         DS    0FD                                                       000000
@3numMBSegments DS 0XL8                                                  000000
         ORG   @@PARMD@12+8                                              000000
         DS    0FD                                                       000000
@4userExtendedPrivateAreaMemoryType DS 0XL8                              000000
         ORG   @@PARMD@12+16                                             000000
         DS    0FD                                                       000000
@5ttkn   DS    0XL8                                                      000000
         EJECT                                                           000000
OMRIARV64 CSECT ,                                                        000000
* void * omrallocate_1M_pageable_pages_above_bar(int *numMBSegments, in  000118
         ENTRY @@CCN@14                                                  000118
@@CCN@14 AMODE 64                                                        000118
         DC    0FD                                                       000118
         DC    XL8'00C300C300D50100'   Function Entry Point Marker       000118
         DC    A(@@FPB@11-*+8)         Signed offset to FPB              000118
         DC    XL4'00000000'           Reserved                          000118
@@CCN@14 DS    0FD                                                       000118
&CCN_PRCN SETC '@@CCN@14'                                                000118
&CCN_PRCN_LONG SETC 'omrallocate_1M_pageable_pages_above_bar'            000118
&CCN_LITN SETC '@@LIT@11'                                                000118
&CCN_BEGIN SETC '@@BGN@11'                                               000118
&CCN_ASCM SETC 'P'                                                       000118
&CCN_DSASZ SETA 480                                                      000118
&CCN_SASZ SETA 144                                                       000118
&CCN_ARGS SETA 3                                                         000118
&CCN_RLOW SETA 14                                                        000118
&CCN_RHIGH SETA 6                                                        000118
&CCN_NAB SETB  0                                                         000118
&CCN_MAIN SETB 0                                                         000118
&CCN_NAB_STORED SETB 0                                                   000118
&CCN_STATIC SETB 0                                                       000118
&CCN_ALTGPR(1) SETB 1                                                    000118
&CCN_ALTGPR(2) SETB 1                                                    000118
&CCN_ALTGPR(3) SETB 1                                                    000118
&CCN_ALTGPR(4) SETB 1                                                    000118
&CCN_ALTGPR(5) SETB 1                                                    000118
&CCN_ALTGPR(6) SETB 1                                                    000118
&CCN_ALTGPR(7) SETB 1                                                    000118
&CCN_ALTGPR(8) SETB 0                                                    000118
&CCN_ALTGPR(9) SETB 0                                                    000118
&CCN_ALTGPR(10) SETB 0                                                   000118
&CCN_ALTGPR(11) SETB 0                                                   000118
&CCN_ALTGPR(12) SETB 0                                                   000118
&CCN_ALTGPR(13) SETB 0                                                   000118
&CCN_ALTGPR(14) SETB 1                                                   000118
&CCN_ALTGPR(15) SETB 1                                                   000118
&CCN_ALTGPR(16) SETB 1                                                   000118
         MYPROLOG                                                        000118
@@BGN@11 DS    0H                                                        000118
         AIF   (NOT &CCN_SASIG).@@NOSIG11                                000118
         LLILH 6,X'C6F4'                                                 000118
         OILL  6,X'E2C1'                                                 000118
         ST    6,4(,13)                                                  000118
.@@NOSIG11 ANOP                                                          000118
         USING @@AUTO@11,13                                              000118
         LARL  3,@@LIT@11                                                000118
         USING @@LIT@11,3                                                000118
         STG   1,464(0,13)             #SR_PARM_11                       000118
*  long segments;                                                        000119
*  long origin;                                                          000120
*  long useMemoryType = *userExtendedPrivateAreaMemoryType;              000121
         LG    14,464(0,13)            #SR_PARM_11                       000121
         USING @@PARMD@11,14                                             000121
         LG    14,@16userExtendedPrivateAreaMemoryType@2                 000121
         LGF   14,0(0,14)              (*)int                            000121
         STG   14,@19useMemoryType@7                                     000121
*  int  iarv64_rc = 0;                                                   000122
         MVHI  @20iarv64_rc@8,0                                          000122
*                                                                        000123
*  __asm(" IARV64 PLISTVER=MAX,MF=(L,NGETSTOR)":"DS"(wgetstor));         000124
*                                                                        000125
*  segments = *numMBSegments;                                            000126
         LG    14,464(0,13)            #SR_PARM_11                       000126
         LG    14,@15numMBSegments@1                                     000126
         LGF   14,0(0,14)              (*)int                            000126
         STG   14,@22segments@5                                          000126
*  wgetstor = ngetstor;                                                  000127
         LARL  14,$STATIC                                                000127
         DROP  14                                                        000127
         USING @@STATICD@@,14                                            000127
         MVC   @21wgetstor,@13ngetstor                                   000127
*                                                                        000128
*  switch (useMemoryType) {                                              000129
         LG    14,@19useMemoryType@7                                     000129
         STG   14,472(0,13)            #SW_WORK11                        000129
         CLG   14,=X'0000000000000002'                                   000129
         BRH   @11L62                                                    000129
         LG    14,472(0,13)            #SW_WORK11                        000129
         SLLG  14,14,2                                                   000129
         LGFR  15,14                                                     000129
         LARL  14,@@CONST@AREA@@                                         000000
         LGF   14,12(15,14)                                              000129
         B     0(3,14)                                                   000129
@11L62   DS    0H                                                        000129
         BRU   @11L67                                                    000129
*  case ZOS64_VMEM_ABOVE_BAR_GENERAL:                                    000130
*   __asm(" IARV64 REQUEST=GETSTOR,COND=YES,SADMP=NO,CONTROL=UNAUTH,"\   000131
@11L63   DS    0H                                                        000131
         LA    2,@23origin@6                                             000131
         DROP  14                                                        000131
         LA    4,@22segments@5                                           000131
         LA    5,@21wgetstor                                             000131
         LG    14,464(0,13)            #SR_PARM_11                       000131
         USING @@PARMD@11,14                                             000131
         LG    6,@17ttkn@3                                               000131
         IARV64 REQUEST=GETSTOR,COND=YES,SADMP=NO,CONTROL=UNAUTH,PAGEFRX 000131
               AMESIZE=PAGEABLE1MEG,TYPE=PAGEABLE,SEGMENTS=(4),ORIGIN=(X 000131
               2),TTOKEN=(6),RETCODE=200(13),MF=(E,(5))                  000131
*     "PAGEFRAMESIZE=PAGEABLE1MEG,TYPE=PAGEABLE,SEGMENTS=(%2),"\         000132
*     "ORIGIN=(%1),TTOKEN=(%4),RETCODE=%0,MF=(E,(%3))"\                  000133
*     ::"m"(iarv64_rc),"r"(&origin),"r"(&segments),"r"(&wgetstor),"r"(t  000134
*   break;                                                               000135
         BRU   @11L22                                                    000135
*  case ZOS64_VMEM_2_TO_32G:                                             000136
*   __asm(" IARV64 REQUEST=GETSTOR,COND=YES,SADMP=NO,CONTROL=UNAUTH,USE  000137
@11L64   DS    0H                                                        000137
         LA    2,@23origin@6                                             000137
         LA    4,@22segments@5                                           000137
         LA    5,@21wgetstor                                             000137
         LG    14,464(0,13)            #SR_PARM_11                       000137
         LG    6,@17ttkn@3                                               000137
         IARV64 REQUEST=GETSTOR,COND=YES,SADMP=NO,CONTROL=UNAUTH,USE2GTX 000137
               O32G=YES,PAGEFRAMESIZE=PAGEABLE1MEG,TYPE=PAGEABLE,SEGMENX 000137
               TS=(4),ORIGIN=(2),TTOKEN=(6),RETCODE=200(13),MF=(E,(5))   000137
*     "PAGEFRAMESIZE=PAGEABLE1MEG,TYPE=PAGEABLE,SEGMENTS=(%2),"\         000138
*     "ORIGIN=(%1),TTOKEN=(%4),RETCODE=%0,MF=(E,(%3))"\                  000139
*     ::"m"(iarv64_rc),"r"(&origin),"r"(&segments),"r"(&wgetstor),"r"(t  000140
*   break;                                                               000141
         BRU   @11L22                                                    000141
*  case ZOS64_VMEM_2_TO_64G:                                             000142
*   __asm(" IARV64 REQUEST=GETSTOR,COND=YES,SADMP=NO,CONTROL=UNAUTH,USE  000143
@11L65   DS    0H                                                        000143
         LA    2,@23origin@6                                             000143
         LA    4,@22segments@5                                           000143
         LA    5,@21wgetstor                                             000143
         LG    14,464(0,13)            #SR_PARM_11                       000143
         LG    6,@17ttkn@3                                               000143
         IARV64 REQUEST=GETSTOR,COND=YES,SADMP=NO,CONTROL=UNAUTH,USE2GTX 000143
               O64G=YES,PAGEFRAMESIZE=PAGEABLE1MEG,TYPE=PAGEABLE,SEGMENX 000143
               TS=(4),ORIGIN=(2),TTOKEN=(6),RETCODE=200(13),MF=(E,(5))   000143
*     "PAGEFRAMESIZE=PAGEABLE1MEG,TYPE=PAGEABLE,SEGMENTS=(%2),"\         000144
*     "ORIGIN=(%1),TTOKEN=(%4),RETCODE=%0,MF=(E,(%3))"\                  000145
*     ::"m"(iarv64_rc),"r"(&origin),"r"(&segments),"r"(&wgetstor),"r"(t  000146
*   break;                                                               000147
@11L22   DS    0H                                                        000129
@11L67   DS    0H                                                        000000
*  }                                                                     000148
*                                                                        000149
*  if (0 != iarv64_rc) {                                                 000150
         LGF   14,@20iarv64_rc@8                                         000150
         LTR   14,14                                                     000150
         BRE   @11L17                                                    000150
*   return (void *)0;                                                    000151
         LGHI  15,0                                                      000151
         BRU   @11L23                                                    000151
@11L17   DS    0H                                                        000151
*  }                                                                     000152
*  return (void *)origin;                                                000153
         LG    15,@23origin@6                                            000153
* }                                                                      000154
@11L23   DS    0H                                                        000154
         DROP                                                            000154
         MYEPILOG                                                        000154
OMRIARV64 CSECT ,                                                        000154
         DS    0FD                                                       000154
@@LIT@11 LTORG                                                           000000
@@FPB@   LOCTR                                                           000000
@@FPB@11 DS    0FD                     Function Property Block           000000
         DC    XL2'CCD5'               Eyecatcher                        000000
         DC    BL2'1111111000000011'   Saved GPR Mask                    000000
         DC    A(@@PFD@@-@@FPB@11)     Signed Offset to Prefix Data      000000
         DC    BL1'10000000'           Flag Set 1                        000000
         DC    BL1'10000001'           Flag Set 2                        000000
         DC    BL1'00000000'           Flag Set 3                        000000
         DC    BL1'00000001'           Flag Set 4                        000000
         DC    XL4'00000000'           Reserved                          000000
         DC    XL4'00000000'           Reserved                          000000
         DC    AL2(39)                 Function Name                     000000
         DC    C'omrallocate_1M_pageable_pages_above_bar'                000000
OMRIARV64 LOCTR                                                          000000
         EJECT                                                           000000
@@AUTO@11 DSECT                                                          000000
         DS    60FD                                                      000000
         ORG   @@AUTO@11                                                 000000
#GPR_SA_11 DS  18FD                                                      000000
         DS    FD                                                        000000
         ORG   @@AUTO@11+176                                             000000
@22segments@5 DS FD                                                      000000
         ORG   @@AUTO@11+184                                             000000
@23origin@6 DS FD                                                        000000
         ORG   @@AUTO@11+192                                             000000
@19useMemoryType@7 DS FD                                                 000000
         ORG   @@AUTO@11+200                                             000000
@20iarv64_rc@8 DS F                                                      000000
         ORG   @@AUTO@11+208                                             000000
@21wgetstor DS XL256                                                     000000
         ORG   @@AUTO@11+464                                             000000
#SR_PARM_11 DS XL8                                                       000000
@@PARMD@11 DSECT                                                         000000
         DS    XL24                                                      000000
         ORG   @@PARMD@11+0                                              000000
         DS    0FD                                                       000000
@15numMBSegments@1 DS 0XL8                                               000000
         ORG   @@PARMD@11+8                                              000000
         DS    0FD                                                       000000
@16userExtendedPrivateAreaMemoryType@2 DS 0XL8                           000000
         ORG   @@PARMD@11+16                                             000000
         DS    0FD                                                       000000
@17ttkn@3 DS   0XL8                                                      000000
         EJECT                                                           000000
OMRIARV64 CSECT ,                                                        000000
* void *omrallocate_1M_pageable_pages_guarded_above_bar(int *numMBSegme  000170
         ENTRY @@CCN@25                                                  000170
@@CCN@25 AMODE 64                                                        000170
         DC    0FD                                                       000170
         DC    XL8'00C300C300D50100'   Function Entry Point Marker       000170
         DC    A(@@FPB@10-*+8)         Signed offset to FPB              000170
         DC    XL4'00000000'           Reserved                          000170
@@CCN@25 DS    0FD                                                       000170
&CCN_PRCN SETC '@@CCN@25'                                                000170
&CCN_PRCN_LONG SETC 'omrallocate_1M_pageable_pages_guarded_above_bar'    000170
&CCN_LITN SETC '@@LIT@10'                                                000170
&CCN_BEGIN SETC '@@BGN@10'                                               000170
&CCN_ASCM SETC 'P'                                                       000170
&CCN_DSASZ SETA 480                                                      000170
&CCN_SASZ SETA 144                                                       000170
&CCN_ARGS SETA 3                                                         000170
&CCN_RLOW SETA 14                                                        000170
&CCN_RHIGH SETA 6                                                        000170
&CCN_NAB SETB  0                                                         000170
&CCN_MAIN SETB 0                                                         000170
&CCN_NAB_STORED SETB 0                                                   000170
&CCN_STATIC SETB 0                                                       000170
&CCN_ALTGPR(1) SETB 1                                                    000170
&CCN_ALTGPR(2) SETB 1                                                    000170
&CCN_ALTGPR(3) SETB 1                                                    000170
&CCN_ALTGPR(4) SETB 1                                                    000170
&CCN_ALTGPR(5) SETB 1                                                    000170
&CCN_ALTGPR(6) SETB 1                                                    000170
&CCN_ALTGPR(7) SETB 1                                                    000170
&CCN_ALTGPR(8) SETB 0                                                    000170
&CCN_ALTGPR(9) SETB 0                                                    000170
&CCN_ALTGPR(10) SETB 0                                                   000170
&CCN_ALTGPR(11) SETB 0                                                   000170
&CCN_ALTGPR(12) SETB 0                                                   000170
&CCN_ALTGPR(13) SETB 0                                                   000170
&CCN_ALTGPR(14) SETB 1                                                   000170
&CCN_ALTGPR(15) SETB 1                                                   000170
&CCN_ALTGPR(16) SETB 1                                                   000170
         MYPROLOG                                                        000170
@@BGN@10 DS    0H                                                        000170
         AIF   (NOT &CCN_SASIG).@@NOSIG10                                000170
         LLILH 6,X'C6F4'                                                 000170
         OILL  6,X'E2C1'                                                 000170
         ST    6,4(,13)                                                  000170
.@@NOSIG10 ANOP                                                          000170
         USING @@AUTO@10,13                                              000170
         LARL  3,@@LIT@10                                                000170
         USING @@LIT@10,3                                                000170
         STG   1,464(0,13)             #SR_PARM_10                       000170
*  long segments;                                                        000171
*  long origin;                                                          000172
*  long useMemoryType = *userExtendedPrivateAreaMemoryType;              000173
         LG    14,464(0,13)            #SR_PARM_10                       000173
         USING @@PARMD@10,14                                             000173
         LG    14,@27userExtendedPrivateAreaMemoryType@10                000173
         LGF   14,0(0,14)              (*)int                            000173
         STG   14,@30useMemoryType@15                                    000173
*  int  iarv64_rc = 0;                                                   000174
         MVHI  @31iarv64_rc@16,0                                         000174
*                                                                        000175
*  __asm(" IARV64 PLISTVER=MAX,MF=(L,SGETSTOR)":"DS"(wgetstor));         000176
*                                                                        000177
*  segments = *numMBSegments;                                            000178
         LG    14,464(0,13)            #SR_PARM_10                       000178
         LG    14,@26numMBSegments@9                                     000178
         LGF   14,0(0,14)              (*)int                            000178
         STG   14,@33segments@13                                         000178
*  wgetstor = ngetstor;                                                  000179
         LARL  14,$STATIC                                                000179
         DROP  14                                                        000179
         USING @@STATICD@@,14                                            000179
         MVC   @32wgetstor,@13ngetstor                                   000179
*                                                                        000180
*  switch (useMemoryType) {                                              000181
         LG    14,@30useMemoryType@15                                    000181
         STG   14,472(0,13)            #SW_WORK10                        000181
         CLG   14,=X'0000000000000002'                                   000181
         BRH   @10L56                                                    000181
         LG    14,472(0,13)            #SW_WORK10                        000181
         SLLG  14,14,2                                                   000181
         LGFR  15,14                                                     000181
         LARL  14,@@CONST@AREA@@                                         000000
         LGF   14,24(15,14)                                              000181
         B     0(3,14)                                                   000181
@10L56   DS    0H                                                        000181
         BRU   @10L61                                                    000181
*  case ZOS64_VMEM_ABOVE_BAR_GENERAL:                                    000182
*   __asm(" IARV64 REQUEST=GETSTOR,COND=YES,SADMP=NO,CONTROL=UNAUTH,"\   000183
@10L57   DS    0H                                                        000183
         LA    2,@34origin@14                                            000183
         DROP  14                                                        000183
         LA    4,@33segments@13                                          000183
         LA    5,@32wgetstor                                             000183
         LG    14,464(0,13)            #SR_PARM_10                       000183
         USING @@PARMD@10,14                                             000183
         LG    6,@28ttkn@11                                              000183
         IARV64 REQUEST=GETSTOR,COND=YES,SADMP=NO,CONTROL=UNAUTH,GUARDSX 000183
               IZE64=(4),PAGEFRAMESIZE=PAGEABLE1MEG,TYPE=PAGEABLE,SEGMEX 000183
               NTS=(4),ORIGIN=(2),TTOKEN=(6),RETCODE=200(13),MF=(E,(5))  000183
*     "GUARDSIZE64=(%2),"\                                               000184
*     "PAGEFRAMESIZE=PAGEABLE1MEG,TYPE=PAGEABLE,SEGMENTS=(%2),"\         000185
*     "ORIGIN=(%1),TTOKEN=(%4),RETCODE=%0,MF=(E,(%3))"\                  000186
*     ::"m"(iarv64_rc),"r"(&origin),"r"(&segments),"r"(&wgetstor),"r"(t  000187
*   break;                                                               000188
         BRU   @10L24                                                    000188
*  case ZOS64_VMEM_2_TO_32G:                                             000189
*   __asm(" IARV64 REQUEST=GETSTOR,COND=YES,SADMP=NO,CONTROL=UNAUTH,USE  000190
@10L58   DS    0H                                                        000190
         LA    2,@34origin@14                                            000190
         LA    4,@33segments@13                                          000190
         LA    5,@32wgetstor                                             000190
         LG    14,464(0,13)            #SR_PARM_10                       000190
         LG    6,@28ttkn@11                                              000190
         IARV64 REQUEST=GETSTOR,COND=YES,SADMP=NO,CONTROL=UNAUTH,USE2GTX 000190
               O32G=YES,GUARDSIZE64=(4),PAGEFRAMESIZE=PAGEABLE1MEG,TYPEX 000190
               =PAGEABLE,SEGMENTS=(4),ORIGIN=(2),TTOKEN=(6),RETCODE=200X 000190
               (13),MF=(E,(5))                                           000190
*     "GUARDSIZE64=(%2),"\                                               000191
*     "PAGEFRAMESIZE=PAGEABLE1MEG,TYPE=PAGEABLE,SEGMENTS=(%2),"\         000192
*     "ORIGIN=(%1),TTOKEN=(%4),RETCODE=%0,MF=(E,(%3))"\                  000193
*     ::"m"(iarv64_rc),"r"(&origin),"r"(&segments),"r"(&wgetstor),"r"(t  000194
*   break;                                                               000195
         BRU   @10L24                                                    000195
*  case ZOS64_VMEM_2_TO_64G:                                             000196
*   __asm(" IARV64 REQUEST=GETSTOR,COND=YES,SADMP=NO,CONTROL=UNAUTH,USE  000197
@10L59   DS    0H                                                        000197
         LA    2,@34origin@14                                            000197
         LA    4,@33segments@13                                          000197
         LA    5,@32wgetstor                                             000197
         LG    14,464(0,13)            #SR_PARM_10                       000197
         LG    6,@28ttkn@11                                              000197
         IARV64 REQUEST=GETSTOR,COND=YES,SADMP=NO,CONTROL=UNAUTH,USE2GTX 000197
               O64G=YES,GUARDSIZE64=(4),PAGEFRAMESIZE=PAGEABLE1MEG,TYPEX 000197
               =PAGEABLE,SEGMENTS=(4),ORIGIN=(2),TTOKEN=(6),RETCODE=200X 000197
               (13),MF=(E,(5))                                           000197
*     "GUARDSIZE64=(%2),"\                                               000198
*     "PAGEFRAMESIZE=PAGEABLE1MEG,TYPE=PAGEABLE,SEGMENTS=(%2),"\         000199
*     "ORIGIN=(%1),TTOKEN=(%4),RETCODE=%0,MF=(E,(%3))"\                  000200
*     ::"m"(iarv64_rc),"r"(&origin),"r"(&segments),"r"(&wgetstor),"r"(t  000201
*   break;                                                               000202
@10L24   DS    0H                                                        000181
@10L61   DS    0H                                                        000000
*  }                                                                     000203
*                                                                        000204
*  if (0 != iarv64_rc) {                                                 000205
         LGF   14,@31iarv64_rc@16                                        000205
         LTR   14,14                                                     000205
         BRE   @10L15                                                    000205
*   return (void *)0;                                                    000206
         LGHI  15,0                                                      000206
         BRU   @10L25                                                    000206
@10L15   DS    0H                                                        000206
*  }                                                                     000207
*  return (void *)origin;                                                000208
         LG    15,@34origin@14                                           000208
* }                                                                      000209
@10L25   DS    0H                                                        000209
         DROP                                                            000209
         MYEPILOG                                                        000209
OMRIARV64 CSECT ,                                                        000209
         DS    0FD                                                       000209
@@LIT@10 LTORG                                                           000000
@@FPB@   LOCTR                                                           000000
@@FPB@10 DS    0FD                     Function Property Block           000000
         DC    XL2'CCD5'               Eyecatcher                        000000
         DC    BL2'1111111000000011'   Saved GPR Mask                    000000
         DC    A(@@PFD@@-@@FPB@10)     Signed Offset to Prefix Data      000000
         DC    BL1'10000000'           Flag Set 1                        000000
         DC    BL1'10000001'           Flag Set 2                        000000
         DC    BL1'00000000'           Flag Set 3                        000000
         DC    BL1'00000001'           Flag Set 4                        000000
         DC    XL4'00000000'           Reserved                          000000
         DC    XL4'00000000'           Reserved                          000000
         DC    AL2(47)                 Function Name                     000000
         DC    C'omrallocate_1M_pageable_pages_guarded_above_bar'        000000
OMRIARV64 LOCTR                                                          000000
         EJECT                                                           000000
@@AUTO@10 DSECT                                                          000000
         DS    60FD                                                      000000
         ORG   @@AUTO@10                                                 000000
#GPR_SA_10 DS  18FD                                                      000000
         DS    FD                                                        000000
         ORG   @@AUTO@10+176                                             000000
@33segments@13 DS FD                                                     000000
         ORG   @@AUTO@10+184                                             000000
@34origin@14 DS FD                                                       000000
         ORG   @@AUTO@10+192                                             000000
@30useMemoryType@15 DS FD                                                000000
         ORG   @@AUTO@10+200                                             000000
@31iarv64_rc@16 DS F                                                     000000
         ORG   @@AUTO@10+208                                             000000
@32wgetstor DS XL256                                                     000000
         ORG   @@AUTO@10+464                                             000000
#SR_PARM_10 DS XL8                                                       000000
@@PARMD@10 DSECT                                                         000000
         DS    XL24                                                      000000
         ORG   @@PARMD@10+0                                              000000
         DS    0FD                                                       000000
@26numMBSegments@9 DS 0XL8                                               000000
         ORG   @@PARMD@10+8                                              000000
         DS    0FD                                                       000000
@27userExtendedPrivateAreaMemoryType@10 DS 0XL8                          000000
         ORG   @@PARMD@10+16                                             000000
         DS    0FD                                                       000000
@28ttkn@11 DS  0XL8                                                      000000
         EJECT                                                           000000
OMRIARV64 CSECT ,                                                        000000
* void * omrallocate_2G_pages(int *num2GBUnits, int *userExtendedPrivat  000225
         ENTRY @@CCN@36                                                  000225
@@CCN@36 AMODE 64                                                        000225
         DC    0FD                                                       000225
         DC    XL8'00C300C300D50100'   Function Entry Point Marker       000225
         DC    A(@@FPB@9-*+8)          Signed offset to FPB              000225
         DC    XL4'00000000'           Reserved                          000225
@@CCN@36 DS    0FD                                                       000225
&CCN_PRCN SETC '@@CCN@36'                                                000225
&CCN_PRCN_LONG SETC 'omrallocate_2G_pages'                               000225
&CCN_LITN SETC '@@LIT@9'                                                 000225
&CCN_BEGIN SETC '@@BGN@9'                                                000225
&CCN_ASCM SETC 'P'                                                       000225
&CCN_DSASZ SETA 480                                                      000225
&CCN_SASZ SETA 144                                                       000225
&CCN_ARGS SETA 3                                                         000225
&CCN_RLOW SETA 14                                                        000225
&CCN_RHIGH SETA 6                                                        000225
&CCN_NAB SETB  0                                                         000225
&CCN_MAIN SETB 0                                                         000225
&CCN_NAB_STORED SETB 0                                                   000225
&CCN_STATIC SETB 0                                                       000225
&CCN_ALTGPR(1) SETB 1                                                    000225
&CCN_ALTGPR(2) SETB 1                                                    000225
&CCN_ALTGPR(3) SETB 1                                                    000225
&CCN_ALTGPR(4) SETB 1                                                    000225
&CCN_ALTGPR(5) SETB 1                                                    000225
&CCN_ALTGPR(6) SETB 1                                                    000225
&CCN_ALTGPR(7) SETB 1                                                    000225
&CCN_ALTGPR(8) SETB 0                                                    000225
&CCN_ALTGPR(9) SETB 0                                                    000225
&CCN_ALTGPR(10) SETB 0                                                   000225
&CCN_ALTGPR(11) SETB 0                                                   000225
&CCN_ALTGPR(12) SETB 0                                                   000225
&CCN_ALTGPR(13) SETB 0                                                   000225
&CCN_ALTGPR(14) SETB 1                                                   000225
&CCN_ALTGPR(15) SETB 1                                                   000225
&CCN_ALTGPR(16) SETB 1                                                   000225
         MYPROLOG                                                        000225
@@BGN@9  DS    0H                                                        000225
         AIF   (NOT &CCN_SASIG).@@NOSIG9                                 000225
         LLILH 6,X'C6F4'                                                 000225
         OILL  6,X'E2C1'                                                 000225
         ST    6,4(,13)                                                  000225
.@@NOSIG9 ANOP                                                           000225
         USING @@AUTO@9,13                                               000225
         LARL  3,@@LIT@9                                                 000225
         USING @@LIT@9,3                                                 000225
         STG   1,464(0,13)             #SR_PARM_9                        000225
*  long units;                                                           000226
*  long origin;                                                          000227
*  long useMemoryType = *userExtendedPrivateAreaMemoryType;              000228
         LG    14,464(0,13)            #SR_PARM_9                        000228
         USING @@PARMD@9,14                                              000228
         LG    14,@38userExtendedPrivateAreaMemoryType@17                000228
         LGF   14,0(0,14)              (*)int                            000228
         STG   14,@41useMemoryType@21                                    000228
*  int  iarv64_rc = 0;                                                   000229
         MVHI  @42iarv64_rc@22,0                                         000229
*                                                                        000230
*  __asm(" IARV64 PLISTVER=MAX,MF=(L,OGETSTOR)":"DS"(wgetstor));         000231
*                                                                        000232
*  units = *num2GBUnits;                                                 000233
         LG    14,464(0,13)            #SR_PARM_9                        000233
         LG    14,@37num2GBUnits                                         000233
         LGF   14,0(0,14)              (*)int                            000233
         STG   14,@44units                                               000233
*  wgetstor = ogetstor;                                                  000234
         LARL  14,$STATIC                                                000234
         DROP  14                                                        000234
         USING @@STATICD@@,14                                            000234
         MVC   @43wgetstor,@35ogetstor                                   000234
*                                                                        000235
*  switch (useMemoryType) {                                              000236
         LG    14,@41useMemoryType@21                                    000236
         STG   14,472(0,13)            #SW_WORK9                         000236
         CLG   14,=X'0000000000000002'                                   000236
         BRH   @9L50                                                     000236
         LG    14,472(0,13)            #SW_WORK9                         000236
         SLLG  14,14,2                                                   000236
         LGFR  15,14                                                     000236
         LARL  14,@@CONST@AREA@@                                         000000
         LGF   14,36(15,14)                                              000236
         B     0(3,14)                                                   000236
@9L50    DS    0H                                                        000236
         BRU   @9L55                                                     000236
*  case ZOS64_VMEM_ABOVE_BAR_GENERAL:                                    000237
*   __asm(" IARV64 REQUEST=GETSTOR,COND=YES,SADMP=NO,CONTROL=UNAUTH,"\   000238
@9L51    DS    0H                                                        000238
         LA    2,@45origin@20                                            000238
         DROP  14                                                        000238
         LA    4,@44units                                                000238
         LA    5,@43wgetstor                                             000238
         LG    14,464(0,13)            #SR_PARM_9                        000238
         USING @@PARMD@9,14                                              000238
         LG    6,@39ttkn@18                                              000238
         IARV64 REQUEST=GETSTOR,COND=YES,SADMP=NO,CONTROL=UNAUTH,PAGEFRX 000238
               AMESIZE=2G,TYPE=FIXED,UNITSIZE=2G,UNITS=(4),ORIGIN=(2),TX 000238
               TOKEN=(6),RETCODE=200(13),MF=(E,(5))                      000238
*     "PAGEFRAMESIZE=2G,TYPE=FIXED,UNITSIZE=2G,UNITS=(%2),"\             000239
*     "ORIGIN=(%1),TTOKEN=(%4),RETCODE=%0,MF=(E,(%3))"\                  000240
*     ::"m"(iarv64_rc),"r"(&origin),"r"(&units),"r"(&wgetstor),"r"(ttkn  000241
*   break;                                                               000242
         BRU   @9L26                                                     000242
*  case ZOS64_VMEM_2_TO_32G:                                             000243
*   __asm(" IARV64 REQUEST=GETSTOR,COND=YES,SADMP=NO,CONTROL=UNAUTH,USE  000244
@9L52    DS    0H                                                        000244
         LA    2,@45origin@20                                            000244
         LA    4,@44units                                                000244
         LA    5,@43wgetstor                                             000244
         LG    14,464(0,13)            #SR_PARM_9                        000244
         LG    6,@39ttkn@18                                              000244
         IARV64 REQUEST=GETSTOR,COND=YES,SADMP=NO,CONTROL=UNAUTH,USE2GTX 000244
               O32G=YES,PAGEFRAMESIZE=2G,TYPE=FIXED,UNITSIZE=2G,UNITS=(X 000244
               4),ORIGIN=(2),TTOKEN=(6),RETCODE=200(13),MF=(E,(5))       000244
*     "PAGEFRAMESIZE=2G,TYPE=FIXED,UNITSIZE=2G,UNITS=(%2),"\             000245
*     "ORIGIN=(%1),TTOKEN=(%4),RETCODE=%0,MF=(E,(%3))"\                  000246
*     ::"m"(iarv64_rc),"r"(&origin),"r"(&units),"r"(&wgetstor),"r"(ttkn  000247
*   break;                                                               000248
         BRU   @9L26                                                     000248
*  case ZOS64_VMEM_2_TO_64G:                                             000249
*   __asm(" IARV64 REQUEST=GETSTOR,COND=YES,SADMP=NO,CONTROL=UNAUTH,USE  000250
@9L53    DS    0H                                                        000250
         LA    2,@45origin@20                                            000250
         LA    4,@44units                                                000250
         LA    5,@43wgetstor                                             000250
         LG    14,464(0,13)            #SR_PARM_9                        000250
         LG    6,@39ttkn@18                                              000250
         IARV64 REQUEST=GETSTOR,COND=YES,SADMP=NO,CONTROL=UNAUTH,USE2GTX 000250
               O64G=YES,PAGEFRAMESIZE=2G,TYPE=FIXED,UNITSIZE=2G,UNITS=(X 000250
               4),ORIGIN=(2),TTOKEN=(6),RETCODE=200(13),MF=(E,(5))       000250
*     "PAGEFRAMESIZE=2G,TYPE=FIXED,UNITSIZE=2G,UNITS=(%2),"\             000251
*     "ORIGIN=(%1),TTOKEN=(%4),RETCODE=%0,MF=(E,(%3))"\                  000252
*     ::"m"(iarv64_rc),"r"(&origin),"r"(&units),"r"(&wgetstor),"r"(ttkn  000253
*   break;                                                               000254
@9L26    DS    0H                                                        000236
@9L55    DS    0H                                                        000000
*  }                                                                     000255
*                                                                        000256
*  if (0 != iarv64_rc) {                                                 000257
         LGF   14,@42iarv64_rc@22                                        000257
         LTR   14,14                                                     000257
         BRE   @9L13                                                     000257
*   return (void *)0;                                                    000258
         LGHI  15,0                                                      000258
         BRU   @9L27                                                     000258
@9L13    DS    0H                                                        000258
*  }                                                                     000259
*  return (void *)origin;                                                000260
         LG    15,@45origin@20                                           000260
* }                                                                      000261
@9L27    DS    0H                                                        000261
         DROP                                                            000261
         MYEPILOG                                                        000261
OMRIARV64 CSECT ,                                                        000261
         DS    0FD                                                       000261
@@LIT@9  LTORG                                                           000000
@@FPB@   LOCTR                                                           000000
@@FPB@9  DS    0FD                     Function Property Block           000000
         DC    XL2'CCD5'               Eyecatcher                        000000
         DC    BL2'1111111000000011'   Saved GPR Mask                    000000
         DC    A(@@PFD@@-@@FPB@9)      Signed Offset to Prefix Data      000000
         DC    BL1'10000000'           Flag Set 1                        000000
         DC    BL1'10000001'           Flag Set 2                        000000
         DC    BL1'00000000'           Flag Set 3                        000000
         DC    BL1'00000001'           Flag Set 4                        000000
         DC    XL4'00000000'           Reserved                          000000
         DC    XL4'00000000'           Reserved                          000000
         DC    AL2(20)                 Function Name                     000000
         DC    C'omrallocate_2G_pages'                                   000000
OMRIARV64 LOCTR                                                          000000
         EJECT                                                           000000
@@AUTO@9 DSECT                                                           000000
         DS    60FD                                                      000000
         ORG   @@AUTO@9                                                  000000
#GPR_SA_9 DS   18FD                                                      000000
         DS    FD                                                        000000
         ORG   @@AUTO@9+176                                              000000
@44units DS    FD                                                        000000
         ORG   @@AUTO@9+184                                              000000
@45origin@20 DS FD                                                       000000
         ORG   @@AUTO@9+192                                              000000
@41useMemoryType@21 DS FD                                                000000
         ORG   @@AUTO@9+200                                              000000
@42iarv64_rc@22 DS F                                                     000000
         ORG   @@AUTO@9+208                                              000000
@43wgetstor DS XL256                                                     000000
         ORG   @@AUTO@9+464                                              000000
#SR_PARM_9 DS  XL8                                                       000000
@@PARMD@9 DSECT                                                          000000
         DS    XL24                                                      000000
         ORG   @@PARMD@9+0                                               000000
         DS    0FD                                                       000000
@37num2GBUnits DS 0XL8                                                   000000
         ORG   @@PARMD@9+8                                               000000
         DS    0FD                                                       000000
@38userExtendedPrivateAreaMemoryType@17 DS 0XL8                          000000
         ORG   @@PARMD@9+16                                              000000
         DS    0FD                                                       000000
@39ttkn@18 DS  0XL8                                                      000000
         EJECT                                                           000000
OMRIARV64 CSECT ,                                                        000000
* void * omrallocate_4K_pages_in_userExtendedPrivateArea(int *numMBSegm  000277
         ENTRY @@CCN@47                                                  000277
@@CCN@47 AMODE 64                                                        000277
         DC    0FD                                                       000277
         DC    XL8'00C300C300D50100'   Function Entry Point Marker       000277
         DC    A(@@FPB@8-*+8)          Signed offset to FPB              000277
         DC    XL4'00000000'           Reserved                          000277
@@CCN@47 DS    0FD                                                       000277
&CCN_PRCN SETC '@@CCN@47'                                                000277
&CCN_PRCN_LONG SETC 'omrallocate_4K_pages_in_userExtendedPrivateArea'    000277
&CCN_LITN SETC '@@LIT@8'                                                 000277
&CCN_BEGIN SETC '@@BGN@8'                                                000277
&CCN_ASCM SETC 'P'                                                       000277
&CCN_DSASZ SETA 480                                                      000277
&CCN_SASZ SETA 144                                                       000277
&CCN_ARGS SETA 3                                                         000277
&CCN_RLOW SETA 14                                                        000277
&CCN_RHIGH SETA 6                                                        000277
&CCN_NAB SETB  0                                                         000277
&CCN_MAIN SETB 0                                                         000277
&CCN_NAB_STORED SETB 0                                                   000277
&CCN_STATIC SETB 0                                                       000277
&CCN_ALTGPR(1) SETB 1                                                    000277
&CCN_ALTGPR(2) SETB 1                                                    000277
&CCN_ALTGPR(3) SETB 1                                                    000277
&CCN_ALTGPR(4) SETB 1                                                    000277
&CCN_ALTGPR(5) SETB 1                                                    000277
&CCN_ALTGPR(6) SETB 1                                                    000277
&CCN_ALTGPR(7) SETB 1                                                    000277
&CCN_ALTGPR(8) SETB 0                                                    000277
&CCN_ALTGPR(9) SETB 0                                                    000277
&CCN_ALTGPR(10) SETB 0                                                   000277
&CCN_ALTGPR(11) SETB 0                                                   000277
&CCN_ALTGPR(12) SETB 0                                                   000277
&CCN_ALTGPR(13) SETB 0                                                   000277
&CCN_ALTGPR(14) SETB 1                                                   000277
&CCN_ALTGPR(15) SETB 1                                                   000277
&CCN_ALTGPR(16) SETB 1                                                   000277
         MYPROLOG                                                        000277
@@BGN@8  DS    0H                                                        000277
         AIF   (NOT &CCN_SASIG).@@NOSIG8                                 000277
         LLILH 6,X'C6F4'                                                 000277
         OILL  6,X'E2C1'                                                 000277
         ST    6,4(,13)                                                  000277
.@@NOSIG8 ANOP                                                           000277
         USING @@AUTO@8,13                                               000277
         LARL  3,@@LIT@8                                                 000277
         USING @@LIT@8,3                                                 000277
         STG   1,464(0,13)             #SR_PARM_8                        000277
*  long segments;                                                        000278
*  long origin;                                                          000279
*  long useMemoryType = *userExtendedPrivateAreaMemoryType;              000280
         LG    14,464(0,13)            #SR_PARM_8                        000280
         USING @@PARMD@8,14                                              000280
         LG    14,@49userExtendedPrivateAreaMemoryType@24                000280
         LGF   14,0(0,14)              (*)int                            000280
         STG   14,@52useMemoryType@29                                    000280
*  int  iarv64_rc = 0;                                                   000281
         MVHI  @53iarv64_rc@30,0                                         000281
*                                                                        000282
*  __asm(" IARV64 PLISTVER=MAX,MF=(L,MGETSTOR)":"DS"(wgetstor));         000283
*                                                                        000284
*  segments = *numMBSegments;                                            000285
         LG    14,464(0,13)            #SR_PARM_8                        000285
         LG    14,@48numMBSegments@23                                    000285
         LGF   14,0(0,14)              (*)int                            000285
         STG   14,@55segments@27                                         000285
*  wgetstor = mgetstor;                                                  000286
         LARL  14,$STATIC                                                000286
         DROP  14                                                        000286
         USING @@STATICD@@,14                                            000286
         MVC   @54wgetstor,@46mgetstor                                   000286
*                                                                        000287
*  switch (useMemoryType) {                                              000288
         LG    14,@52useMemoryType@29                                    000288
         STG   14,472(0,13)            #SW_WORK8                         000288
         CLG   14,=X'0000000000000002'                                   000288
         BRH   @8L44                                                     000288
         LG    14,472(0,13)            #SW_WORK8                         000288
         SLLG  14,14,2                                                   000288
         LGFR  15,14                                                     000288
         LARL  14,@@CONST@AREA@@                                         000000
         LGF   14,48(15,14)                                              000288
         B     0(3,14)                                                   000288
@8L44    DS    0H                                                        000288
         BRU   @8L49                                                     000288
*  case ZOS64_VMEM_ABOVE_BAR_GENERAL:                                    000289
*   break;                                                               000290
@8L45    DS    0H                                                        000290
         BRU   @8L28                                                     000290
*  case ZOS64_VMEM_2_TO_32G:                                             000291
*   __asm(" IARV64 REQUEST=GETSTOR,COND=YES,SADMP=NO,USE2GTO32G=YES,"\   000292
@8L46    DS    0H                                                        000292
         LA    2,@56origin@28                                            000292
         DROP  14                                                        000292
         LA    4,@55segments@27                                          000292
         LA    5,@54wgetstor                                             000292
         LG    14,464(0,13)            #SR_PARM_8                        000292
         USING @@PARMD@8,14                                              000292
         LG    6,@50ttkn@25                                              000292
         IARV64 REQUEST=GETSTOR,COND=YES,SADMP=NO,USE2GTO32G=YES,CONTROX 000292
               L=UNAUTH,PAGEFRAMESIZE=4K,SEGMENTS=(4),ORIGIN=(2),TTOKENX 000292
               =(6),RETCODE=200(13),MF=(E,(5))                           000292
*     "CONTROL=UNAUTH,PAGEFRAMESIZE=4K,"\                                000293
*     "SEGMENTS=(%2),ORIGIN=(%1),TTOKEN=(%4),RETCODE=%0,MF=(E,(%3))"\    000294
*     ::"m"(iarv64_rc),"r"(&origin),"r"(&segments),"r"(&wgetstor),"r"(t  000295
*   break;                                                               000296
         BRU   @8L28                                                     000296
*  case ZOS64_VMEM_2_TO_64G:                                             000297
*   __asm(" IARV64 REQUEST=GETSTOR,COND=YES,SADMP=NO,USE2GTO64G=YES,"\   000298
@8L47    DS    0H                                                        000298
         LA    2,@56origin@28                                            000298
         LA    4,@55segments@27                                          000298
         LA    5,@54wgetstor                                             000298
         LG    14,464(0,13)            #SR_PARM_8                        000298
         LG    6,@50ttkn@25                                              000298
         IARV64 REQUEST=GETSTOR,COND=YES,SADMP=NO,USE2GTO64G=YES,CONTROX 000298
               L=UNAUTH,PAGEFRAMESIZE=4K,SEGMENTS=(4),ORIGIN=(2),TTOKENX 000298
               =(6),RETCODE=200(13),MF=(E,(5))                           000298
*     "CONTROL=UNAUTH,PAGEFRAMESIZE=4K,"\                                000299
*     "SEGMENTS=(%2),ORIGIN=(%1),TTOKEN=(%4),RETCODE=%0,MF=(E,(%3))"\    000300
*     ::"m"(iarv64_rc),"r"(&origin),"r"(&segments),"r"(&wgetstor),"r"(t  000301
*   break;                                                               000302
@8L28    DS    0H                                                        000288
@8L49    DS    0H                                                        000000
*  }                                                                     000303
*                                                                        000304
*  if (0 != iarv64_rc) {                                                 000305
         LGF   14,@53iarv64_rc@30                                        000305
         LTR   14,14                                                     000305
         BRE   @8L11                                                     000305
*   return (void *)0;                                                    000306
         LGHI  15,0                                                      000306
         BRU   @8L29                                                     000306
@8L11    DS    0H                                                        000306
*  }                                                                     000307
*  return (void *)origin;                                                000308
         LG    15,@56origin@28                                           000308
* }                                                                      000309
@8L29    DS    0H                                                        000309
         DROP                                                            000309
         MYEPILOG                                                        000309
OMRIARV64 CSECT ,                                                        000309
         DS    0FD                                                       000309
@@LIT@8  LTORG                                                           000000
@@FPB@   LOCTR                                                           000000
@@FPB@8  DS    0FD                     Function Property Block           000000
         DC    XL2'CCD5'               Eyecatcher                        000000
         DC    BL2'1111111000000011'   Saved GPR Mask                    000000
         DC    A(@@PFD@@-@@FPB@8)      Signed Offset to Prefix Data      000000
         DC    BL1'10000000'           Flag Set 1                        000000
         DC    BL1'10000001'           Flag Set 2                        000000
         DC    BL1'00000000'           Flag Set 3                        000000
         DC    BL1'00000001'           Flag Set 4                        000000
         DC    XL4'00000000'           Reserved                          000000
         DC    XL4'00000000'           Reserved                          000000
         DC    AL2(47)                 Function Name                     000000
         DC    C'omrallocate_4K_pages_in_userExtendedPrivateArea'        000000
OMRIARV64 LOCTR                                                          000000
         EJECT                                                           000000
@@AUTO@8 DSECT                                                           000000
         DS    60FD                                                      000000
         ORG   @@AUTO@8                                                  000000
#GPR_SA_8 DS   18FD                                                      000000
         DS    FD                                                        000000
         ORG   @@AUTO@8+176                                              000000
@55segments@27 DS FD                                                     000000
         ORG   @@AUTO@8+184                                              000000
@56origin@28 DS FD                                                       000000
         ORG   @@AUTO@8+192                                              000000
@52useMemoryType@29 DS FD                                                000000
         ORG   @@AUTO@8+200                                              000000
@53iarv64_rc@30 DS F                                                     000000
         ORG   @@AUTO@8+208                                              000000
@54wgetstor DS XL256                                                     000000
         ORG   @@AUTO@8+464                                              000000
#SR_PARM_8 DS  XL8                                                       000000
@@PARMD@8 DSECT                                                          000000
         DS    XL24                                                      000000
         ORG   @@PARMD@8+0                                               000000
         DS    0FD                                                       000000
@48numMBSegments@23 DS 0XL8                                              000000
         ORG   @@PARMD@8+8                                               000000
         DS    0FD                                                       000000
@49userExtendedPrivateAreaMemoryType@24 DS 0XL8                          000000
         ORG   @@PARMD@8+16                                              000000
         DS    0FD                                                       000000
@50ttkn@25 DS  0XL8                                                      000000
         EJECT                                                           000000
OMRIARV64 CSECT ,                                                        000000
* void *omrallocate_4K_pages_guarded_in_userExtendedPrivateArea(int *nu  000325
         ENTRY @@CCN@58                                                  000325
@@CCN@58 AMODE 64                                                        000325
         DC    0FD                                                       000325
         DC    XL8'00C300C300D50100'   Function Entry Point Marker       000325
         DC    A(@@FPB@7-*+8)          Signed offset to FPB              000325
         DC    XL4'00000000'           Reserved                          000325
@@CCN@58 DS    0FD                                                       000325
&CCN_PRCN SETC '@@CCN@58'                                                000325
&CCN_PRCN_LONG SETC 'omrallocate_4K_pages_guarded_in_userExtendedPrivatX 000325
               eArea'                                                    000325
&CCN_LITN SETC '@@LIT@7'                                                 000325
&CCN_BEGIN SETC '@@BGN@7'                                                000325
&CCN_ASCM SETC 'P'                                                       000325
&CCN_DSASZ SETA 480                                                      000325
&CCN_SASZ SETA 144                                                       000325
&CCN_ARGS SETA 3                                                         000325
&CCN_RLOW SETA 14                                                        000325
&CCN_RHIGH SETA 6                                                        000325
&CCN_NAB SETB  0                                                         000325
&CCN_MAIN SETB 0                                                         000325
&CCN_NAB_STORED SETB 0                                                   000325
&CCN_STATIC SETB 0                                                       000325
&CCN_ALTGPR(1) SETB 1                                                    000325
&CCN_ALTGPR(2) SETB 1                                                    000325
&CCN_ALTGPR(3) SETB 1                                                    000325
&CCN_ALTGPR(4) SETB 1                                                    000325
&CCN_ALTGPR(5) SETB 1                                                    000325
&CCN_ALTGPR(6) SETB 1                                                    000325
&CCN_ALTGPR(7) SETB 1                                                    000325
&CCN_ALTGPR(8) SETB 0                                                    000325
&CCN_ALTGPR(9) SETB 0                                                    000325
&CCN_ALTGPR(10) SETB 0                                                   000325
&CCN_ALTGPR(11) SETB 0                                                   000325
&CCN_ALTGPR(12) SETB 0                                                   000325
&CCN_ALTGPR(13) SETB 0                                                   000325
&CCN_ALTGPR(14) SETB 1                                                   000325
&CCN_ALTGPR(15) SETB 1                                                   000325
&CCN_ALTGPR(16) SETB 1                                                   000325
         MYPROLOG                                                        000325
@@BGN@7  DS    0H                                                        000325
         AIF   (NOT &CCN_SASIG).@@NOSIG7                                 000325
         LLILH 6,X'C6F4'                                                 000325
         OILL  6,X'E2C1'                                                 000325
         ST    6,4(,13)                                                  000325
.@@NOSIG7 ANOP                                                           000325
         USING @@AUTO@7,13                                               000325
         LARL  3,@@LIT@7                                                 000325
         USING @@LIT@7,3                                                 000325
         STG   1,464(0,13)             #SR_PARM_7                        000325
*  long segments;                                                        000326
*  long origin;                                                          000327
*  long useMemoryType = *userExtendedPrivateAreaMemoryType;              000328
         LG    14,464(0,13)            #SR_PARM_7                        000328
         USING @@PARMD@7,14                                              000328
         LG    14,@60userExtendedPrivateAreaMemoryType@32                000328
         LGF   14,0(0,14)              (*)int                            000328
         STG   14,@63useMemoryType@37                                    000328
*  int  iarv64_rc = 0;                                                   000329
         MVHI  @64iarv64_rc@38,0                                         000329
*                                                                        000330
*  __asm(" IARV64 PLISTVER=MAX,MF=(L,TGETSTOR)":"DS"(wgetstor));         000331
*                                                                        000332
*  segments = *numMBSegments;                                            000333
         LG    14,464(0,13)            #SR_PARM_7                        000333
         LG    14,@59numMBSegments@31                                    000333
         LGF   14,0(0,14)              (*)int                            000333
         STG   14,@66segments@35                                         000333
*  wgetstor = tgetstor;                                                  000334
         LARL  14,$STATIC                                                000334
         DROP  14                                                        000334
         USING @@STATICD@@,14                                            000334
         MVC   @65wgetstor,@57tgetstor                                   000334
*                                                                        000335
*  switch (useMemoryType) {                                              000336
         LG    14,@63useMemoryType@37                                    000336
         STG   14,472(0,13)            #SW_WORK7                         000336
         CLG   14,=X'0000000000000002'                                   000336
         BRH   @7L38                                                     000336
         LG    14,472(0,13)            #SW_WORK7                         000336
         SLLG  14,14,2                                                   000336
         LGFR  15,14                                                     000336
         LARL  14,@@CONST@AREA@@                                         000000
         LGF   14,60(15,14)                                              000336
         B     0(3,14)                                                   000336
@7L38    DS    0H                                                        000336
         BRU   @7L43                                                     000336
*  case ZOS64_VMEM_ABOVE_BAR_GENERAL:                                    000337
*   break;                                                               000338
@7L39    DS    0H                                                        000338
         BRU   @7L30                                                     000338
*  case ZOS64_VMEM_2_TO_32G:                                             000339
*   __asm(" IARV64 REQUEST=GETSTOR,COND=NO,SADMP=NO,CONTROL=UNAUTH,USE2  000340
@7L40    DS    0H                                                        000340
         LA    2,@67origin@36                                            000340
         DROP  14                                                        000340
         LA    4,@66segments@35                                          000340
         LA    5,@65wgetstor                                             000340
         LG    14,464(0,13)            #SR_PARM_7                        000340
         USING @@PARMD@7,14                                              000340
         LG    6,@61ttkn@33                                              000340
         IARV64 REQUEST=GETSTOR,COND=NO,SADMP=NO,CONTROL=UNAUTH,USE2GTOX 000340
               32G=YES,GUARDSIZE64=(4),PAGEFRAMESIZE=4K,SEGMENTS=(4),ORX 000340
               IGIN=(2),TTOKEN=(6),RETCODE=200(13),MF=(E,(5))            000340
*     "GUARDSIZE64=(%2),PAGEFRAMESIZE=4K,SEGMENTS=(%2),"\                000341
*     "ORIGIN=(%1),TTOKEN=(%4),RETCODE=%0,MF=(E,(%3))"\                  000342
*     ::"m"(iarv64_rc),"r"(&origin),"r"(&segments),"r"(&wgetstor),"r"(t  000343
*   break;                                                               000344
         BRU   @7L30                                                     000344
*  case ZOS64_VMEM_2_TO_64G:                                             000345
*   __asm(" IARV64 REQUEST=GETSTOR,COND=NO,SADMP=NO,CONTROL=UNAUTH,USE2  000346
@7L41    DS    0H                                                        000346
         LA    2,@67origin@36                                            000346
         LA    4,@66segments@35                                          000346
         LA    5,@65wgetstor                                             000346
         LG    14,464(0,13)            #SR_PARM_7                        000346
         LG    6,@61ttkn@33                                              000346
         IARV64 REQUEST=GETSTOR,COND=NO,SADMP=NO,CONTROL=UNAUTH,USE2GTOX 000346
               64G=YES,GUARDSIZE64=(4),PAGEFRAMESIZE=4K,SEGMENTS=(4),ORX 000346
               IGIN=(2),TTOKEN=(6),RETCODE=200(13),MF=(E,(5))            000346
*     "GUARDSIZE64=(%2),PAGEFRAMESIZE=4K,SEGMENTS=(%2),"\                000347
*     "ORIGIN=(%1),TTOKEN=(%4),RETCODE=%0,MF=(E,(%3))"\                  000348
*     ::"m"(iarv64_rc),"r"(&origin),"r"(&segments),"r"(&wgetstor),"r"(t  000349
*   break;                                                               000350
@7L30    DS    0H                                                        000336
@7L43    DS    0H                                                        000000
*  }                                                                     000351
*                                                                        000352
*  if (0 != iarv64_rc) {                                                 000353
         LGF   14,@64iarv64_rc@38                                        000353
         LTR   14,14                                                     000353
         BRE   @7L9                                                      000353
*   return (void *)0;                                                    000354
         LGHI  15,0                                                      000354
         BRU   @7L31                                                     000354
@7L9     DS    0H                                                        000354
*  }                                                                     000355
*  return (void *)origin;                                                000356
         LG    15,@67origin@36                                           000356
* }                                                                      000357
@7L31    DS    0H                                                        000357
         DROP                                                            000357
         MYEPILOG                                                        000357
OMRIARV64 CSECT ,                                                        000357
         DS    0FD                                                       000357
@@LIT@7  LTORG                                                           000000
@@FPB@   LOCTR                                                           000000
@@FPB@7  DS    0FD                     Function Property Block           000000
         DC    XL2'CCD5'               Eyecatcher                        000000
         DC    BL2'1111111000000011'   Saved GPR Mask                    000000
         DC    A(@@PFD@@-@@FPB@7)      Signed Offset to Prefix Data      000000
         DC    BL1'10000000'           Flag Set 1                        000000
         DC    BL1'10000001'           Flag Set 2                        000000
         DC    BL1'00000000'           Flag Set 3                        000000
         DC    BL1'00000001'           Flag Set 4                        000000
         DC    XL4'00000000'           Reserved                          000000
         DC    XL4'00000000'           Reserved                          000000
         DC    AL2(55)                 Function Name                     000000
         DC    C'omrallocate_4K_pages_guarded_in_userExtendedPrivat'     000000
         DC    C'eArea'                                                  000000
OMRIARV64 LOCTR                                                          000000
         EJECT                                                           000000
@@AUTO@7 DSECT                                                           000000
         DS    60FD                                                      000000
         ORG   @@AUTO@7                                                  000000
#GPR_SA_7 DS   18FD                                                      000000
         DS    FD                                                        000000
         ORG   @@AUTO@7+176                                              000000
@66segments@35 DS FD                                                     000000
         ORG   @@AUTO@7+184                                              000000
@67origin@36 DS FD                                                       000000
         ORG   @@AUTO@7+192                                              000000
@63useMemoryType@37 DS FD                                                000000
         ORG   @@AUTO@7+200                                              000000
@64iarv64_rc@38 DS F                                                     000000
         ORG   @@AUTO@7+208                                              000000
@65wgetstor DS XL256                                                     000000
         ORG   @@AUTO@7+464                                              000000
#SR_PARM_7 DS  XL8                                                       000000
@@PARMD@7 DSECT                                                          000000
         DS    XL24                                                      000000
         ORG   @@PARMD@7+0                                               000000
         DS    0FD                                                       000000
@59numMBSegments@31 DS 0XL8                                              000000
         ORG   @@PARMD@7+8                                               000000
         DS    0FD                                                       000000
@60userExtendedPrivateAreaMemoryType@32 DS 0XL8                          000000
         ORG   @@PARMD@7+16                                              000000
         DS    0FD                                                       000000
@61ttkn@33 DS  0XL8                                                      000000
         EJECT                                                           000000
OMRIARV64 CSECT ,                                                        000000
* void * omrallocate_4K_pages_above_bar(int *numMBSegments, const char   000372
         ENTRY @@CCN@69                                                  000372
@@CCN@69 AMODE 64                                                        000372
         DC    0FD                                                       000372
         DC    XL8'00C300C300D50100'   Function Entry Point Marker       000372
         DC    A(@@FPB@6-*+8)          Signed offset to FPB              000372
         DC    XL4'00000000'           Reserved                          000372
@@CCN@69 DS    0FD                                                       000372
&CCN_PRCN SETC '@@CCN@69'                                                000372
&CCN_PRCN_LONG SETC 'omrallocate_4K_pages_above_bar'                     000372
&CCN_LITN SETC '@@LIT@6'                                                 000372
&CCN_BEGIN SETC '@@BGN@6'                                                000372
&CCN_ASCM SETC 'P'                                                       000372
&CCN_DSASZ SETA 464                                                      000372
&CCN_SASZ SETA 144                                                       000372
&CCN_ARGS SETA 2                                                         000372
&CCN_RLOW SETA 14                                                        000372
&CCN_RHIGH SETA 6                                                        000372
&CCN_NAB SETB  0                                                         000372
&CCN_MAIN SETB 0                                                         000372
&CCN_NAB_STORED SETB 0                                                   000372
&CCN_STATIC SETB 0                                                       000372
&CCN_ALTGPR(1) SETB 1                                                    000372
&CCN_ALTGPR(2) SETB 1                                                    000372
&CCN_ALTGPR(3) SETB 1                                                    000372
&CCN_ALTGPR(4) SETB 1                                                    000372
&CCN_ALTGPR(5) SETB 1                                                    000372
&CCN_ALTGPR(6) SETB 1                                                    000372
&CCN_ALTGPR(7) SETB 1                                                    000372
&CCN_ALTGPR(8) SETB 0                                                    000372
&CCN_ALTGPR(9) SETB 0                                                    000372
&CCN_ALTGPR(10) SETB 0                                                   000372
&CCN_ALTGPR(11) SETB 0                                                   000372
&CCN_ALTGPR(12) SETB 0                                                   000372
&CCN_ALTGPR(13) SETB 0                                                   000372
&CCN_ALTGPR(14) SETB 1                                                   000372
&CCN_ALTGPR(15) SETB 1                                                   000372
&CCN_ALTGPR(16) SETB 1                                                   000372
         MYPROLOG                                                        000372
@@BGN@6  DS    0H                                                        000372
         AIF   (NOT &CCN_SASIG).@@NOSIG6                                 000372
         LLILH 6,X'C6F4'                                                 000372
         OILL  6,X'E2C1'                                                 000372
         ST    6,4(,13)                                                  000372
.@@NOSIG6 ANOP                                                           000372
         USING @@AUTO@6,13                                               000372
         LARL  3,@@LIT@6                                                 000372
         USING @@LIT@6,3                                                 000372
         STG   1,456(0,13)             #SR_PARM_6                        000372
*  long segments;                                                        000373
*  long origin;                                                          000374
*  int  iarv64_rc = 0;                                                   000375
         MVHI  @73iarv64_rc@44,0                                         000375
*                                                                        000376
*  __asm(" IARV64 PLISTVER=MAX,MF=(L,RGETSTOR)":"DS"(wgetstor));         000377
*                                                                        000378
*  segments = *numMBSegments;                                            000379
         LG    14,456(0,13)            #SR_PARM_6                        000379
         USING @@PARMD@6,14                                              000379
         LG    14,@70numMBSegments@39                                    000379
         LGF   14,0(0,14)              (*)int                            000379
         STG   14,@75segments@42                                         000379
*  wgetstor = rgetstor;                                                  000380
         LARL  14,$STATIC                                                000380
         DROP  14                                                        000380
         USING @@STATICD@@,14                                            000380
         MVC   @74wgetstor,@68rgetstor                                   000380
*                                                                        000381
*  __asm(" IARV64 REQUEST=GETSTOR,COND=YES,SADMP=NO,"\                   000382
         LA    2,@76origin@43                                            000382
         DROP  14                                                        000382
         LA    4,@75segments@42                                          000382
         LA    5,@74wgetstor                                             000382
         LG    14,456(0,13)            #SR_PARM_6                        000382
         USING @@PARMD@6,14                                              000382
         LG    6,@71ttkn@40                                              000382
         IARV64 REQUEST=GETSTOR,COND=YES,SADMP=NO,CONTROL=UNAUTH,PAGEFRX 000382
               AMESIZE=4K,SEGMENTS=(4),ORIGIN=(2),TTOKEN=(6),RETCODE=19X 000382
               2(13),MF=(E,(5))                                          000382
*    "CONTROL=UNAUTH,PAGEFRAMESIZE=4K,"\                                 000383
*    "SEGMENTS=(%2),ORIGIN=(%1),TTOKEN=(%4),RETCODE=%0,MF=(E,(%3))"\     000384
*    ::"m"(iarv64_rc),"r"(&origin),"r"(&segments),"r"(&wgetstor),"r"(tt  000385
*                                                                        000386
*  if (0 != iarv64_rc) {                                                 000387
         LGF   14,@73iarv64_rc@44                                        000387
         LTR   14,14                                                     000387
         BRE   @6L7                                                      000387
*   return (void *)0;                                                    000388
         LGHI  15,0                                                      000388
         BRU   @6L32                                                     000388
@6L7     DS    0H                                                        000388
*  }                                                                     000389
*  return (void *)origin;                                                000390
         LG    15,@76origin@43                                           000390
* }                                                                      000391
@6L32    DS    0H                                                        000391
         DROP                                                            000391
         MYEPILOG                                                        000391
OMRIARV64 CSECT ,                                                        000391
         DS    0FD                                                       000391
@@LIT@6  LTORG                                                           000000
@@FPB@   LOCTR                                                           000000
@@FPB@6  DS    0FD                     Function Property Block           000000
         DC    XL2'CCD5'               Eyecatcher                        000000
         DC    BL2'1111111000000011'   Saved GPR Mask                    000000
         DC    A(@@PFD@@-@@FPB@6)      Signed Offset to Prefix Data      000000
         DC    BL1'10000000'           Flag Set 1                        000000
         DC    BL1'10000001'           Flag Set 2                        000000
         DC    BL1'00000000'           Flag Set 3                        000000
         DC    BL1'00000001'           Flag Set 4                        000000
         DC    XL4'00000000'           Reserved                          000000
         DC    XL4'00000000'           Reserved                          000000
         DC    AL2(30)                 Function Name                     000000
         DC    C'omrallocate_4K_pages_above_bar'                         000000
OMRIARV64 LOCTR                                                          000000
         EJECT                                                           000000
@@AUTO@6 DSECT                                                           000000
         DS    58FD                                                      000000
         ORG   @@AUTO@6                                                  000000
#GPR_SA_6 DS   18FD                                                      000000
         DS    FD                                                        000000
         ORG   @@AUTO@6+176                                              000000
@75segments@42 DS FD                                                     000000
         ORG   @@AUTO@6+184                                              000000
@76origin@43 DS FD                                                       000000
         ORG   @@AUTO@6+192                                              000000
@73iarv64_rc@44 DS F                                                     000000
         ORG   @@AUTO@6+200                                              000000
@74wgetstor DS XL256                                                     000000
         ORG   @@AUTO@6+456                                              000000
#SR_PARM_6 DS  XL8                                                       000000
@@PARMD@6 DSECT                                                          000000
         DS    XL16                                                      000000
         ORG   @@PARMD@6+0                                               000000
         DS    0FD                                                       000000
@70numMBSegments@39 DS 0XL8                                              000000
         ORG   @@PARMD@6+8                                               000000
         DS    0FD                                                       000000
@71ttkn@40 DS  0XL8                                                      000000
         EJECT                                                           000000
OMRIARV64 CSECT ,                                                        000000
* void *omrallocate_4K_pages_guarded_above_bar(int *numMBSegments, cons  000398
         ENTRY @@CCN@78                                                  000398
@@CCN@78 AMODE 64                                                        000398
         DC    0FD                                                       000398
         DC    XL8'00C300C300D50100'   Function Entry Point Marker       000398
         DC    A(@@FPB@5-*+8)          Signed offset to FPB              000398
         DC    XL4'00000000'           Reserved                          000398
@@CCN@78 DS    0FD                                                       000398
&CCN_PRCN SETC '@@CCN@78'                                                000398
&CCN_PRCN_LONG SETC 'omrallocate_4K_pages_guarded_above_bar'             000398
&CCN_LITN SETC '@@LIT@5'                                                 000398
&CCN_BEGIN SETC '@@BGN@5'                                                000398
&CCN_ASCM SETC 'P'                                                       000398
&CCN_DSASZ SETA 464                                                      000398
&CCN_SASZ SETA 144                                                       000398
&CCN_ARGS SETA 2                                                         000398
&CCN_RLOW SETA 14                                                        000398
&CCN_RHIGH SETA 6                                                        000398
&CCN_NAB SETB  0                                                         000398
&CCN_MAIN SETB 0                                                         000398
&CCN_NAB_STORED SETB 0                                                   000398
&CCN_STATIC SETB 0                                                       000398
&CCN_ALTGPR(1) SETB 1                                                    000398
&CCN_ALTGPR(2) SETB 1                                                    000398
&CCN_ALTGPR(3) SETB 1                                                    000398
&CCN_ALTGPR(4) SETB 1                                                    000398
&CCN_ALTGPR(5) SETB 1                                                    000398
&CCN_ALTGPR(6) SETB 1                                                    000398
&CCN_ALTGPR(7) SETB 1                                                    000398
&CCN_ALTGPR(8) SETB 0                                                    000398
&CCN_ALTGPR(9) SETB 0                                                    000398
&CCN_ALTGPR(10) SETB 0                                                   000398
&CCN_ALTGPR(11) SETB 0                                                   000398
&CCN_ALTGPR(12) SETB 0                                                   000398
&CCN_ALTGPR(13) SETB 0                                                   000398
&CCN_ALTGPR(14) SETB 1                                                   000398
&CCN_ALTGPR(15) SETB 1                                                   000398
&CCN_ALTGPR(16) SETB 1                                                   000398
         MYPROLOG                                                        000398
@@BGN@5  DS    0H                                                        000398
         AIF   (NOT &CCN_SASIG).@@NOSIG5                                 000398
         LLILH 6,X'C6F4'                                                 000398
         OILL  6,X'E2C1'                                                 000398
         ST    6,4(,13)                                                  000398
.@@NOSIG5 ANOP                                                           000398
         USING @@AUTO@5,13                                               000398
         LARL  3,@@LIT@5                                                 000398
         USING @@LIT@5,3                                                 000398
         STG   1,456(0,13)             #SR_PARM_5                        000398
*  long segments;                                                        000399
*  long origin;                                                          000400
*  int  iarv64_rc = 0;                                                   000401
         MVHI  @82iarv64_rc@50,0                                         000401
*                                                                        000402
*  __asm(" IARV64 PLISTVER=MAX,MF=(L,EGETSTOR)":"DS"(wgetstor));         000403
*                                                                        000404
*  segments = *numMBSegments;                                            000405
         LG    14,456(0,13)            #SR_PARM_5                        000405
         USING @@PARMD@5,14                                              000405
         LG    14,@79numMBSegments@45                                    000405
         LGF   14,0(0,14)              (*)int                            000405
         STG   14,@84segments@48                                         000405
*  wgetstor = rgetstor;                                                  000406
         LARL  14,$STATIC                                                000406
         DROP  14                                                        000406
         USING @@STATICD@@,14                                            000406
         MVC   @83wgetstor,@68rgetstor                                   000406
*                                                                        000407
*  __asm(" IARV64 REQUEST=GETSTOR,COND=YES,SADMP=NO,"\                   000408
         LA    2,@85origin@49                                            000408
         DROP  14                                                        000408
         LA    4,@84segments@48                                          000408
         LA    5,@83wgetstor                                             000408
         LG    14,456(0,13)            #SR_PARM_5                        000408
         USING @@PARMD@5,14                                              000408
         LG    6,@80ttkn@46                                              000408
         IARV64 REQUEST=GETSTOR,COND=YES,SADMP=NO,GUARDSIZE=(4),CONTROLX 000408
               =UNAUTH,PAGEFRAMESIZE=4K,SEGMENTS=(4),ORIGIN=(2),TTOKEN=X 000408
               (6),RETCODE=192(13),MF=(E,(5))                            000408
*    "GUARDSIZE=(%2),"\                                                  000409
*    "CONTROL=UNAUTH,PAGEFRAMESIZE=4K,"\                                 000410
*    "SEGMENTS=(%2),ORIGIN=(%1),TTOKEN=(%4),RETCODE=%0,MF=(E,(%3))"\     000411
*    ::"m"(iarv64_rc),"r"(&origin),"r"(&segments),"r"(&wgetstor),"r"(tt  000412
*                                                                        000413
*  if (0 != iarv64_rc) {                                                 000414
         LGF   14,@82iarv64_rc@50                                        000414
         LTR   14,14                                                     000414
         BRE   @5L5                                                      000414
*   return (void *)0;                                                    000415
         LGHI  15,0                                                      000415
         BRU   @5L33                                                     000415
@5L5     DS    0H                                                        000415
*  }                                                                     000416
*  return (void *)origin;                                                000417
         LG    15,@85origin@49                                           000417
* }                                                                      000418
@5L33    DS    0H                                                        000418
         DROP                                                            000418
         MYEPILOG                                                        000418
OMRIARV64 CSECT ,                                                        000418
         DS    0FD                                                       000418
@@LIT@5  LTORG                                                           000000
@@FPB@   LOCTR                                                           000000
@@FPB@5  DS    0FD                     Function Property Block           000000
         DC    XL2'CCD5'               Eyecatcher                        000000
         DC    BL2'1111111000000011'   Saved GPR Mask                    000000
         DC    A(@@PFD@@-@@FPB@5)      Signed Offset to Prefix Data      000000
         DC    BL1'10000000'           Flag Set 1                        000000
         DC    BL1'10000001'           Flag Set 2                        000000
         DC    BL1'00000000'           Flag Set 3                        000000
         DC    BL1'00000001'           Flag Set 4                        000000
         DC    XL4'00000000'           Reserved                          000000
         DC    XL4'00000000'           Reserved                          000000
         DC    AL2(38)                 Function Name                     000000
         DC    C'omrallocate_4K_pages_guarded_above_bar'                 000000
OMRIARV64 LOCTR                                                          000000
         EJECT                                                           000000
@@AUTO@5 DSECT                                                           000000
         DS    58FD                                                      000000
         ORG   @@AUTO@5                                                  000000
#GPR_SA_5 DS   18FD                                                      000000
         DS    FD                                                        000000
         ORG   @@AUTO@5+176                                              000000
@84segments@48 DS FD                                                     000000
         ORG   @@AUTO@5+184                                              000000
@85origin@49 DS FD                                                       000000
         ORG   @@AUTO@5+192                                              000000
@82iarv64_rc@50 DS F                                                     000000
         ORG   @@AUTO@5+200                                              000000
@83wgetstor DS XL256                                                     000000
         ORG   @@AUTO@5+456                                              000000
#SR_PARM_5 DS  XL8                                                       000000
@@PARMD@5 DSECT                                                          000000
         DS    XL16                                                      000000
         ORG   @@PARMD@5+0                                               000000
         DS    0FD                                                       000000
@79numMBSegments@45 DS 0XL8                                              000000
         ORG   @@PARMD@5+8                                               000000
         DS    0FD                                                       000000
@80ttkn@46 DS  0XL8                                                      000000
         EJECT                                                           000000
OMRIARV64 CSECT ,                                                        000000
* int omrfree_memory_above_bar(void *address, const char * ttkn){        000432
         ENTRY @@CCN@87                                                  000432
@@CCN@87 AMODE 64                                                        000432
         DC    0FD                                                       000432
         DC    XL8'00C300C300D50100'   Function Entry Point Marker       000432
         DC    A(@@FPB@4-*+8)          Signed offset to FPB              000432
         DC    XL4'00000000'           Reserved                          000432
@@CCN@87 DS    0FD                                                       000432
&CCN_PRCN SETC '@@CCN@87'                                                000432
&CCN_PRCN_LONG SETC 'omrfree_memory_above_bar'                           000432
&CCN_LITN SETC '@@LIT@4'                                                 000432
&CCN_BEGIN SETC '@@BGN@4'                                                000432
&CCN_ASCM SETC 'P'                                                       000432
&CCN_DSASZ SETA 456                                                      000432
&CCN_SASZ SETA 144                                                       000432
&CCN_ARGS SETA 2                                                         000432
&CCN_RLOW SETA 14                                                        000432
&CCN_RHIGH SETA 5                                                        000432
&CCN_NAB SETB  0                                                         000432
&CCN_MAIN SETB 0                                                         000432
&CCN_NAB_STORED SETB 0                                                   000432
&CCN_STATIC SETB 0                                                       000432
&CCN_ALTGPR(1) SETB 1                                                    000432
&CCN_ALTGPR(2) SETB 1                                                    000432
&CCN_ALTGPR(3) SETB 1                                                    000432
&CCN_ALTGPR(4) SETB 1                                                    000432
&CCN_ALTGPR(5) SETB 1                                                    000432
&CCN_ALTGPR(6) SETB 1                                                    000432
&CCN_ALTGPR(7) SETB 0                                                    000432
&CCN_ALTGPR(8) SETB 0                                                    000432
&CCN_ALTGPR(9) SETB 0                                                    000432
&CCN_ALTGPR(10) SETB 0                                                   000432
&CCN_ALTGPR(11) SETB 0                                                   000432
&CCN_ALTGPR(12) SETB 0                                                   000432
&CCN_ALTGPR(13) SETB 0                                                   000432
&CCN_ALTGPR(14) SETB 1                                                   000432
&CCN_ALTGPR(15) SETB 1                                                   000432
&CCN_ALTGPR(16) SETB 1                                                   000432
         MYPROLOG                                                        000432
@@BGN@4  DS    0H                                                        000432
         AIF   (NOT &CCN_SASIG).@@NOSIG4                                 000432
         LLILH 5,X'C6F4'                                                 000432
         OILL  5,X'E2C1'                                                 000432
         ST    5,4(,13)                                                  000432
.@@NOSIG4 ANOP                                                           000432
         USING @@AUTO@4,13                                               000432
         LARL  3,@@LIT@4                                                 000432
         USING @@LIT@4,3                                                 000432
         STG   1,448(0,13)             #SR_PARM_4                        000432
*  void * xmemobjstart;                                                  000433
*  int  iarv64_rc = 0;                                                   000434
         MVHI  @91iarv64_rc@53,0                                         000434
*                                                                        000435
*  __asm(" IARV64 PLISTVER=MAX,MF=(L,PGETSTOR)":"DS"(wgetstor));         000436
*                                                                        000437
*  xmemobjstart = address;                                               000438
         LG    14,448(0,13)            #SR_PARM_4                        000438
         USING @@PARMD@4,14                                              000438
         LG    14,@88address                                             000438
         STG   14,@93xmemobjstart                                        000438
*  wgetstor = pgetstor;                                                  000439
         LARL  14,$STATIC                                                000439
         DROP  14                                                        000439
         USING @@STATICD@@,14                                            000439
         MVC   @92wgetstor,@86pgetstor                                   000439
*                                                                        000440
*  __asm(" IARV64 REQUEST=DETACH,COND=YES,MEMOBJSTART=(%2),TTOKEN=(%3),  000441
         LA    2,@92wgetstor                                             000441
         DROP  14                                                        000441
         LA    4,@93xmemobjstart                                         000441
         LG    14,448(0,13)            #SR_PARM_4                        000441
         USING @@PARMD@4,14                                              000441
         LG    5,@89ttkn@51                                              000441
         IARV64 REQUEST=DETACH,COND=YES,MEMOBJSTART=(4),TTOKEN=(5),RETCX 000441
               ODE=184(13),MF=(E,(2))                                    000441
*    ::"m"(iarv64_rc),"r"(&wgetstor),"r"(&xmemobjstart),"r"(ttkn));      000442
*  return iarv64_rc;                                                     000443
         LGF   15,@91iarv64_rc@53                                        000443
* }                                                                      000444
@4L34    DS    0H                                                        000444
         DROP                                                            000444
         MYEPILOG                                                        000444
OMRIARV64 CSECT ,                                                        000444
         DS    0FD                                                       000444
@@LIT@4  LTORG                                                           000000
@@FPB@   LOCTR                                                           000000
@@FPB@4  DS    0FD                     Function Property Block           000000
         DC    XL2'CCD5'               Eyecatcher                        000000
         DC    BL2'1111110000000011'   Saved GPR Mask                    000000
         DC    A(@@PFD@@-@@FPB@4)      Signed Offset to Prefix Data      000000
         DC    BL1'10000000'           Flag Set 1                        000000
         DC    BL1'10000001'           Flag Set 2                        000000
         DC    BL1'00000000'           Flag Set 3                        000000
         DC    BL1'00000001'           Flag Set 4                        000000
         DC    XL4'00000000'           Reserved                          000000
         DC    XL4'00000000'           Reserved                          000000
         DC    AL2(24)                 Function Name                     000000
         DC    C'omrfree_memory_above_bar'                               000000
OMRIARV64 LOCTR                                                          000000
         EJECT                                                           000000
@@AUTO@4 DSECT                                                           000000
         DS    57FD                                                      000000
         ORG   @@AUTO@4                                                  000000
#GPR_SA_4 DS   18FD                                                      000000
         DS    FD                                                        000000
         ORG   @@AUTO@4+176                                              000000
@93xmemobjstart DS AD                                                    000000
         ORG   @@AUTO@4+184                                              000000
@91iarv64_rc@53 DS F                                                     000000
         ORG   @@AUTO@4+192                                              000000
@92wgetstor DS XL256                                                     000000
         ORG   @@AUTO@4+448                                              000000
#SR_PARM_4 DS  XL8                                                       000000
@@PARMD@4 DSECT                                                          000000
         DS    XL16                                                      000000
         ORG   @@PARMD@4+0                                               000000
         DS    0FD                                                       000000
@88address DS  0XL8                                                      000000
         ORG   @@PARMD@4+8                                               000000
         DS    0FD                                                       000000
@89ttkn@51 DS  0XL8                                                      000000
         EJECT                                                           000000
OMRIARV64 CSECT ,                                                        000000
* int omrremove_guard(void *address, int *numMBSegments){                000459
         ENTRY @@CCN@95                                                  000459
@@CCN@95 AMODE 64                                                        000459
         DC    0FD                                                       000459
         DC    XL8'00C300C300D50100'   Function Entry Point Marker       000459
         DC    A(@@FPB@3-*+8)          Signed offset to FPB              000459
         DC    XL4'00000000'           Reserved                          000459
@@CCN@95 DS    0FD                                                       000459
&CCN_PRCN SETC '@@CCN@95'                                                000459
&CCN_PRCN_LONG SETC 'omrremove_guard'                                    000459
&CCN_LITN SETC '@@LIT@3'                                                 000459
&CCN_BEGIN SETC '@@BGN@3'                                                000459
&CCN_ASCM SETC 'P'                                                       000459
&CCN_DSASZ SETA 464                                                      000459
&CCN_SASZ SETA 144                                                       000459
&CCN_ARGS SETA 2                                                         000459
&CCN_RLOW SETA 14                                                        000459
&CCN_RHIGH SETA 5                                                        000459
&CCN_NAB SETB  0                                                         000459
&CCN_MAIN SETB 0                                                         000459
&CCN_NAB_STORED SETB 0                                                   000459
&CCN_STATIC SETB 0                                                       000459
&CCN_ALTGPR(1) SETB 1                                                    000459
&CCN_ALTGPR(2) SETB 1                                                    000459
&CCN_ALTGPR(3) SETB 1                                                    000459
&CCN_ALTGPR(4) SETB 1                                                    000459
&CCN_ALTGPR(5) SETB 1                                                    000459
&CCN_ALTGPR(6) SETB 1                                                    000459
&CCN_ALTGPR(7) SETB 0                                                    000459
&CCN_ALTGPR(8) SETB 0                                                    000459
&CCN_ALTGPR(9) SETB 0                                                    000459
&CCN_ALTGPR(10) SETB 0                                                   000459
&CCN_ALTGPR(11) SETB 0                                                   000459
&CCN_ALTGPR(12) SETB 0                                                   000459
&CCN_ALTGPR(13) SETB 0                                                   000459
&CCN_ALTGPR(14) SETB 1                                                   000459
&CCN_ALTGPR(15) SETB 1                                                   000459
&CCN_ALTGPR(16) SETB 1                                                   000459
         MYPROLOG                                                        000459
@@BGN@3  DS    0H                                                        000459
         AIF   (NOT &CCN_SASIG).@@NOSIG3                                 000459
         LLILH 5,X'C6F4'                                                 000459
         OILL  5,X'E2C1'                                                 000459
         ST    5,4(,13)                                                  000459
.@@NOSIG3 ANOP                                                           000459
         USING @@AUTO@3,13                                               000459
         LARL  3,@@LIT@3                                                 000459
         USING @@LIT@3,3                                                 000459
         STG   1,456(0,13)             #SR_PARM_3                        000459
*  void * memObjConvertStart;                                            000460
*  int  iarv64_rc = 0;                                                   000461
         MVHI  @99iarv64_rc@57,0                                         000461
*  long segments;                                                        000462
*                                                                        000463
*  __asm(" IARV64 PLISTVER=MAX,MF=(L,FGETSTOR)":"DS"(wgetstor));         000464
*                                                                        000465
*  memObjConvertStart = address;                                         000466
         LG    14,456(0,13)            #SR_PARM_3                        000466
         USING @@PARMD@3,14                                              000466
         LG    14,@96address@54                                          000466
         STG   14,@101memObjConvertStart                                 000466
*  wgetstor = fgetstor;                                                  000467
         LARL  14,$STATIC                                                000467
         DROP  14                                                        000467
         USING @@STATICD@@,14                                            000467
         MVC   @100wgetstor,@94fgetstor                                  000467
*  segments = *numMBSegments;                                            000468
         LG    14,456(0,13)            #SR_PARM_3                        000468
         DROP  14                                                        000468
         USING @@PARMD@3,14                                              000468
         LG    14,@97numMBSegments@55                                    000468
         LGF   14,0(0,14)              (*)int                            000468
         STG   14,@102segments@58                                        000468
*                                                                        000469
*  __asm(" IARV64 REQUEST=CHANGEGUARD,CONVERT=FROMGUARD,COND=YES,"\      000470
         LA    2,@100wgetstor                                            000470
         LA    4,@101memObjConvertStart                                  000470
         LA    5,@102segments@58                                         000470
         IARV64 REQUEST=CHANGEGUARD,CONVERT=FROMGUARD,COND=YES,CONVERTSX 000470
               TART=(4),CONVERTSIZE64=(5),RETCODE=184(13),MF=(E,(2))     000470
*    "CONVERTSTART=(%2),CONVERTSIZE64=(%3),"\                            000471
*    "RETCODE=%0,MF=(E,(%1))"\                                           000472
*    ::"m"(iarv64_rc),"r"(&wgetstor),"r"(&memObjConvertStart),"r"(&segm  000473
*  return iarv64_rc;                                                     000474
         LGF   15,@99iarv64_rc@57                                        000474
* }                                                                      000475
@3L35    DS    0H                                                        000475
         DROP                                                            000475
         MYEPILOG                                                        000475
OMRIARV64 CSECT ,                                                        000475
         DS    0FD                                                       000475
@@LIT@3  LTORG                                                           000000
@@FPB@   LOCTR                                                           000000
@@FPB@3  DS    0FD                     Function Property Block           000000
         DC    XL2'CCD5'               Eyecatcher                        000000
         DC    BL2'1111110000000011'   Saved GPR Mask                    000000
         DC    A(@@PFD@@-@@FPB@3)      Signed Offset to Prefix Data      000000
         DC    BL1'10000000'           Flag Set 1                        000000
         DC    BL1'10000001'           Flag Set 2                        000000
         DC    BL1'00000000'           Flag Set 3                        000000
         DC    BL1'00000001'           Flag Set 4                        000000
         DC    XL4'00000000'           Reserved                          000000
         DC    XL4'00000000'           Reserved                          000000
         DC    AL2(15)                 Function Name                     000000
         DC    C'omrremove_guard'                                        000000
OMRIARV64 LOCTR                                                          000000
         EJECT                                                           000000
@@AUTO@3 DSECT                                                           000000
         DS    58FD                                                      000000
         ORG   @@AUTO@3                                                  000000
#GPR_SA_3 DS   18FD                                                      000000
         DS    FD                                                        000000
         ORG   @@AUTO@3+176                                              000000
@101memObjConvertStart DS AD                                             000000
         ORG   @@AUTO@3+184                                              000000
@99iarv64_rc@57 DS F                                                     000000
         ORG   @@AUTO@3+192                                              000000
@102segments@58 DS FD                                                    000000
         ORG   @@AUTO@3+200                                              000000
@100wgetstor DS XL256                                                    000000
         ORG   @@AUTO@3+456                                              000000
#SR_PARM_3 DS  XL8                                                       000000
@@PARMD@3 DSECT                                                          000000
         DS    XL16                                                      000000
         ORG   @@PARMD@3+0                                               000000
         DS    0FD                                                       000000
@96address@54 DS 0XL8                                                    000000
         ORG   @@PARMD@3+8                                               000000
         DS    0FD                                                       000000
@97numMBSegments@55 DS 0XL8                                              000000
         EJECT                                                           000000
OMRIARV64 CSECT ,                                                        000000
* int omradd_guard(void *address, int *numMBSegments) {                  000489
         ENTRY @@CCN@104                                                 000489
@@CCN@104 AMODE 64                                                       000489
         DC    0FD                                                       000489
         DC    XL8'00C300C300D50100'   Function Entry Point Marker       000489
         DC    A(@@FPB@2-*+8)          Signed offset to FPB              000489
         DC    XL4'00000000'           Reserved                          000489
@@CCN@104 DS   0FD                                                       000489
&CCN_PRCN SETC '@@CCN@104'                                               000489
&CCN_PRCN_LONG SETC 'omradd_guard'                                       000489
&CCN_LITN SETC '@@LIT@2'                                                 000489
&CCN_BEGIN SETC '@@BGN@2'                                                000489
&CCN_ASCM SETC 'P'                                                       000489
&CCN_DSASZ SETA 464                                                      000489
&CCN_SASZ SETA 144                                                       000489
&CCN_ARGS SETA 2                                                         000489
&CCN_RLOW SETA 14                                                        000489
&CCN_RHIGH SETA 5                                                        000489
&CCN_NAB SETB  0                                                         000489
&CCN_MAIN SETB 0                                                         000489
&CCN_NAB_STORED SETB 0                                                   000489
&CCN_STATIC SETB 0                                                       000489
&CCN_ALTGPR(1) SETB 1                                                    000489
&CCN_ALTGPR(2) SETB 1                                                    000489
&CCN_ALTGPR(3) SETB 1                                                    000489
&CCN_ALTGPR(4) SETB 1                                                    000489
&CCN_ALTGPR(5) SETB 1                                                    000489
&CCN_ALTGPR(6) SETB 1                                                    000489
&CCN_ALTGPR(7) SETB 0                                                    000489
&CCN_ALTGPR(8) SETB 0                                                    000489
&CCN_ALTGPR(9) SETB 0                                                    000489
&CCN_ALTGPR(10) SETB 0                                                   000489
&CCN_ALTGPR(11) SETB 0                                                   000489
&CCN_ALTGPR(12) SETB 0                                                   000489
&CCN_ALTGPR(13) SETB 0                                                   000489
&CCN_ALTGPR(14) SETB 1                                                   000489
&CCN_ALTGPR(15) SETB 1                                                   000489
&CCN_ALTGPR(16) SETB 1                                                   000489
         MYPROLOG                                                        000489
@@BGN@2  DS    0H                                                        000489
         AIF   (NOT &CCN_SASIG).@@NOSIG2                                 000489
         LLILH 5,X'C6F4'                                                 000489
         OILL  5,X'E2C1'                                                 000489
         ST    5,4(,13)                                                  000489
.@@NOSIG2 ANOP                                                           000489
         USING @@AUTO@2,13                                               000489
         LARL  3,@@LIT@2                                                 000489
         USING @@LIT@2,3                                                 000489
         STG   1,456(0,13)             #SR_PARM_2                        000489
*  void * memObjConvertStart;                                            000490
*  int  iarv64_rc = 0;                                                   000491
         MVHI  @108iarv64_rc@63,0                                        000491
*  long segments;                                                        000492
*                                                                        000493
*  __asm(" IARV64 PLISTVER=MAX,MF=(L,DGETSTOR)":"DS"(wgetstor));         000494
*                                                                        000495
*  memObjConvertStart = address;                                         000496
         LG    14,456(0,13)            #SR_PARM_2                        000496
         USING @@PARMD@2,14                                              000496
         LG    14,@105address@59                                         000496
         STG   14,@110memObjConvertStart@62                              000496
*  wgetstor = dgetstor;                                                  000497
         LARL  14,$STATIC                                                000497
         DROP  14                                                        000497
         USING @@STATICD@@,14                                            000497
         MVC   @109wgetstor,@103dgetstor                                 000497
*  segments = *numMBSegments;                                            000498
         LG    14,456(0,13)            #SR_PARM_2                        000498
         DROP  14                                                        000498
         USING @@PARMD@2,14                                              000498
         LG    14,@106numMBSegments@60                                   000498
         LGF   14,0(0,14)              (*)int                            000498
         STG   14,@111segments@64                                        000498
*                                                                        000499
*  __asm(" IARV64 REQUEST=CHANGEGUARD,CONVERT=TOGUARD,COND=YES,"\        000500
         LA    2,@109wgetstor                                            000500
         LA    4,@110memObjConvertStart@62                               000500
         LA    5,@111segments@64                                         000500
         IARV64 REQUEST=CHANGEGUARD,CONVERT=TOGUARD,COND=YES,CONVERTSTAX 000500
               RT=(4),CONVERTSIZE64=(5),RETCODE=184(13),MF=(E,(2))       000500
*    "CONVERTSTART=(%2),CONVERTSIZE64=(%3),"\                            000501
*    "RETCODE=%0,MF=(E,(%1))"\                                           000502
*    ::"m"(iarv64_rc),"r"(&wgetstor),"r"(&memObjConvertStart),"r"(&segm  000503
*  return iarv64_rc;                                                     000504
         LGF   15,@108iarv64_rc@63                                       000504
* }                                                                      000505
@2L36    DS    0H                                                        000505
         DROP                                                            000505
         MYEPILOG                                                        000505
OMRIARV64 CSECT ,                                                        000505
         DS    0FD                                                       000505
@@LIT@2  LTORG                                                           000000
@@FPB@   LOCTR                                                           000000
@@FPB@2  DS    0FD                     Function Property Block           000000
         DC    XL2'CCD5'               Eyecatcher                        000000
         DC    BL2'1111110000000011'   Saved GPR Mask                    000000
         DC    A(@@PFD@@-@@FPB@2)      Signed Offset to Prefix Data      000000
         DC    BL1'10000000'           Flag Set 1                        000000
         DC    BL1'10000001'           Flag Set 2                        000000
         DC    BL1'00000000'           Flag Set 3                        000000
         DC    BL1'00000001'           Flag Set 4                        000000
         DC    XL4'00000000'           Reserved                          000000
         DC    XL4'00000000'           Reserved                          000000
         DC    AL2(12)                 Function Name                     000000
         DC    C'omradd_guard'                                           000000
OMRIARV64 LOCTR                                                          000000
         EJECT                                                           000000
@@AUTO@2 DSECT                                                           000000
         DS    58FD                                                      000000
         ORG   @@AUTO@2                                                  000000
#GPR_SA_2 DS   18FD                                                      000000
         DS    FD                                                        000000
         ORG   @@AUTO@2+176                                              000000
@110memObjConvertStart@62 DS AD                                          000000
         ORG   @@AUTO@2+184                                              000000
@108iarv64_rc@63 DS F                                                    000000
         ORG   @@AUTO@2+192                                              000000
@111segments@64 DS FD                                                    000000
         ORG   @@AUTO@2+200                                              000000
@109wgetstor DS XL256                                                    000000
         ORG   @@AUTO@2+456                                              000000
#SR_PARM_2 DS  XL8                                                       000000
@@PARMD@2 DSECT                                                          000000
         DS    XL16                                                      000000
         ORG   @@PARMD@2+0                                               000000
         DS    0FD                                                       000000
@105address@59 DS 0XL8                                                   000000
         ORG   @@PARMD@2+8                                               000000
         DS    0FD                                                       000000
@106numMBSegments@60 DS 0XL8                                             000000
*                                                                        000544
         EJECT                                                           000000
OMRIARV64 CSECT ,                                                        000000
@@CONST@AREA@@ DS 0D                                                     000000
         DC    XL16'00000000000000000000000000000000'                    000000
         DC    XL16'00000000000000000000000000000000'                    000000
         DC    XL16'00000000000000000000000000000000'                    000000
         DC    XL16'00000000000000000000000000000000'                    000000
         DC    XL8'0000000000000000'                                     000000
         ORG   @@CONST@AREA@@+0                                          000000
         DC    A(@12L69-@@LIT@12)                                        000000
         DC    A(@12L70-@@LIT@12)                                        000000
         DC    A(@12L71-@@LIT@12)                                        000000
         ORG   @@CONST@AREA@@+12                                         000000
         DC    A(@11L63-@@LIT@11)                                        000000
         DC    A(@11L64-@@LIT@11)                                        000000
         DC    A(@11L65-@@LIT@11)                                        000000
         ORG   @@CONST@AREA@@+24                                         000000
         DC    A(@10L57-@@LIT@10)                                        000000
         DC    A(@10L58-@@LIT@10)                                        000000
         DC    A(@10L59-@@LIT@10)                                        000000
         ORG   @@CONST@AREA@@+36                                         000000
         DC    A(@9L51-@@LIT@9)                                          000000
         DC    A(@9L52-@@LIT@9)                                          000000
         DC    A(@9L53-@@LIT@9)                                          000000
         ORG   @@CONST@AREA@@+48                                         000000
         DC    A(@8L45-@@LIT@8)                                          000000
         DC    A(@8L46-@@LIT@8)                                          000000
         DC    A(@8L47-@@LIT@8)                                          000000
         ORG   @@CONST@AREA@@+60                                         000000
         DC    A(@7L39-@@LIT@7)                                          000000
         DC    A(@7L40-@@LIT@7)                                          000000
         DC    A(@7L41-@@LIT@7)                                          000000
         ORG   ,                                                         000000
         EJECT                                                           000000
OMRIARV64 CSECT ,                                                        000000
$STATIC  DS    0D                                                        000000
         DC    (3072)X'00'                                               000000
         LCLC  &DSMAC                                                    000000
         LCLA  &DSSIZE                                                   000000
         LCLA  &MSIZE                                                    000000
         ORG   $STATIC                                                   000000
@@LAB@1  EQU   *                                                         000000
         IARV64 PLISTVER=MAX,MF=(L,LGETSTOR)                             000000
@@LAB@1L EQU   *-@@LAB@1                                                 000000
&DSMAC   SETC  '@@LAB@1'                                                 000000
&DSSIZE  SETA  256                                                       000000
&MSIZE   SETA  @@LAB@1L                                                  000000
         AIF   (&DSSIZE GE &MSIZE).@@OK@1                                000000
         MNOTE 4,'Expanded size(&MSIZE) from &DSMAC exceeds XL:DS size(X 000000
               &DSSIZE)'                                                 000000
.@@OK@1  ANOP                                                            000000
         ORG   $STATIC+256                                               000000
@@LAB@2  EQU   *                                                         000000
         IARV64 PLISTVER=MAX,MF=(L,NGETSTOR)                             000000
@@LAB@2L EQU   *-@@LAB@2                                                 000000
&DSMAC   SETC  '@@LAB@2'                                                 000000
&DSSIZE  SETA  256                                                       000000
&MSIZE   SETA  @@LAB@2L                                                  000000
         AIF   (&DSSIZE GE &MSIZE).@@OK@2                                000000
         MNOTE 4,'Expanded size(&MSIZE) from &DSMAC exceeds XL:DS size(X 000000
               &DSSIZE)'                                                 000000
.@@OK@2  ANOP                                                            000000
         ORG   $STATIC+512                                               000000
@@LAB@3  EQU   *                                                         000000
         IARV64 PLISTVER=MAX,MF=(L,SGETSTOR)                             000000
@@LAB@3L EQU   *-@@LAB@3                                                 000000
&DSMAC   SETC  '@@LAB@3'                                                 000000
&DSSIZE  SETA  256                                                       000000
&MSIZE   SETA  @@LAB@3L                                                  000000
         AIF   (&DSSIZE GE &MSIZE).@@OK@3                                000000
         MNOTE 4,'Expanded size(&MSIZE) from &DSMAC exceeds XL:DS size(X 000000
               &DSSIZE)'                                                 000000
.@@OK@3  ANOP                                                            000000
         ORG   $STATIC+768                                               000000
@@LAB@4  EQU   *                                                         000000
         IARV64 PLISTVER=MAX,MF=(L,OGETSTOR)                             000000
@@LAB@4L EQU   *-@@LAB@4                                                 000000
&DSMAC   SETC  '@@LAB@4'                                                 000000
&DSSIZE  SETA  256                                                       000000
&MSIZE   SETA  @@LAB@4L                                                  000000
         AIF   (&DSSIZE GE &MSIZE).@@OK@4                                000000
         MNOTE 4,'Expanded size(&MSIZE) from &DSMAC exceeds XL:DS size(X 000000
               &DSSIZE)'                                                 000000
.@@OK@4  ANOP                                                            000000
         ORG   $STATIC+1024                                              000000
@@LAB@5  EQU   *                                                         000000
         IARV64 PLISTVER=MAX,MF=(L,MGETSTOR)                             000000
@@LAB@5L EQU   *-@@LAB@5                                                 000000
&DSMAC   SETC  '@@LAB@5'                                                 000000
&DSSIZE  SETA  256                                                       000000
&MSIZE   SETA  @@LAB@5L                                                  000000
         AIF   (&DSSIZE GE &MSIZE).@@OK@5                                000000
         MNOTE 4,'Expanded size(&MSIZE) from &DSMAC exceeds XL:DS size(X 000000
               &DSSIZE)'                                                 000000
.@@OK@5  ANOP                                                            000000
         ORG   $STATIC+1280                                              000000
@@LAB@6  EQU   *                                                         000000
         IARV64 PLISTVER=MAX,MF=(L,TGETSTOR)                             000000
@@LAB@6L EQU   *-@@LAB@6                                                 000000
&DSMAC   SETC  '@@LAB@6'                                                 000000
&DSSIZE  SETA  256                                                       000000
&MSIZE   SETA  @@LAB@6L                                                  000000
         AIF   (&DSSIZE GE &MSIZE).@@OK@6                                000000
         MNOTE 4,'Expanded size(&MSIZE) from &DSMAC exceeds XL:DS size(X 000000
               &DSSIZE)'                                                 000000
.@@OK@6  ANOP                                                            000000
         ORG   $STATIC+1536                                              000000
@@LAB@7  EQU   *                                                         000000
         IARV64 PLISTVER=MAX,MF=(L,RGETSTOR)                             000000
@@LAB@7L EQU   *-@@LAB@7                                                 000000
&DSMAC   SETC  '@@LAB@7'                                                 000000
&DSSIZE  SETA  256                                                       000000
&MSIZE   SETA  @@LAB@7L                                                  000000
         AIF   (&DSSIZE GE &MSIZE).@@OK@7                                000000
         MNOTE 4,'Expanded size(&MSIZE) from &DSMAC exceeds XL:DS size(X 000000
               &DSSIZE)'                                                 000000
.@@OK@7  ANOP                                                            000000
         ORG   $STATIC+1792                                              000000
@@LAB@8  EQU   *                                                         000000
         IARV64 PLISTVER=MAX,MF=(L,EGETSTOR)                             000000
@@LAB@8L EQU   *-@@LAB@8                                                 000000
&DSMAC   SETC  '@@LAB@8'                                                 000000
&DSSIZE  SETA  256                                                       000000
&MSIZE   SETA  @@LAB@8L                                                  000000
         AIF   (&DSSIZE GE &MSIZE).@@OK@8                                000000
         MNOTE 4,'Expanded size(&MSIZE) from &DSMAC exceeds XL:DS size(X 000000
               &DSSIZE)'                                                 000000
.@@OK@8  ANOP                                                            000000
         ORG   $STATIC+2048                                              000000
@@LAB@9  EQU   *                                                         000000
         IARV64 PLISTVER=MAX,MF=(L,PGETSTOR)                             000000
@@LAB@9L EQU   *-@@LAB@9                                                 000000
&DSMAC   SETC  '@@LAB@9'                                                 000000
&DSSIZE  SETA  256                                                       000000
&MSIZE   SETA  @@LAB@9L                                                  000000
         AIF   (&DSSIZE GE &MSIZE).@@OK@9                                000000
         MNOTE 4,'Expanded size(&MSIZE) from &DSMAC exceeds XL:DS size(X 000000
               &DSSIZE)'                                                 000000
.@@OK@9  ANOP                                                            000000
         ORG   $STATIC+2304                                              000000
@@LAB@10 EQU   *                                                         000000
         IARV64 PLISTVER=MAX,MF=(L,FGETSTOR)                             000000
@@LAB@10L EQU  *-@@LAB@10                                                000000
&DSMAC   SETC  '@@LAB@10'                                                000000
&DSSIZE  SETA  256                                                       000000
&MSIZE   SETA  @@LAB@10L                                                 000000
         AIF   (&DSSIZE GE &MSIZE).@@OK@10                               000000
         MNOTE 4,'Expanded size(&MSIZE) from &DSMAC exceeds XL:DS size(X 000000
               &DSSIZE)'                                                 000000
.@@OK@10 ANOP                                                            000000
         ORG   $STATIC+2560                                              000000
@@LAB@11 EQU   *                                                         000000
         IARV64 PLISTVER=MAX,MF=(L,DGETSTOR)                             000000
@@LAB@11L EQU  *-@@LAB@11                                                000000
&DSMAC   SETC  '@@LAB@11'                                                000000
&DSSIZE  SETA  256                                                       000000
&MSIZE   SETA  @@LAB@11L                                                 000000
         AIF   (&DSSIZE GE &MSIZE).@@OK@11                               000000
         MNOTE 4,'Expanded size(&MSIZE) from &DSMAC exceeds XL:DS size(X 000000
               &DSSIZE)'                                                 000000
.@@OK@11 ANOP                                                            000000
         ORG   $STATIC+2816                                              000000
@@LAB@12 EQU   *                                                         000000
         IARV64 PLISTVER=MAX,MF=(L,QGETSTOR)                             000000
@@LAB@12L EQU  *-@@LAB@12                                                000000
&DSMAC   SETC  '@@LAB@12'                                                000000
&DSSIZE  SETA  256                                                       000000
&MSIZE   SETA  @@LAB@12L                                                 000000
         AIF   (&DSSIZE GE &MSIZE).@@OK@12                               000000
         MNOTE 4,'Expanded size(&MSIZE) from &DSMAC exceeds XL:DS size(X 000000
               &DSSIZE)'                                                 000000
.@@OK@12 ANOP                                                            000000
         EJECT                                                           000000
@@STATICD@@ DSECT                                                        000000
         DS    XL3072                                                    000000
         ORG   @@STATICD@@                                               000000
@1lgetstor DS  XL256                                                     000000
         ORG   @@STATICD@@+256                                           000000
@13ngetstor DS XL256                                                     000000
         ORG   @@STATICD@@+512                                           000000
@24sgetstor DS XL256                                                     000000
         ORG   @@STATICD@@+768                                           000000
@35ogetstor DS XL256                                                     000000
         ORG   @@STATICD@@+1024                                          000000
@46mgetstor DS XL256                                                     000000
         ORG   @@STATICD@@+1280                                          000000
@57tgetstor DS XL256                                                     000000
         ORG   @@STATICD@@+1536                                          000000
@68rgetstor DS XL256                                                     000000
         ORG   @@STATICD@@+1792                                          000000
@77egetstor DS XL256                                                     000000
         ORG   @@STATICD@@+2048                                          000000
@86pgetstor DS XL256                                                     000000
         ORG   @@STATICD@@+2304                                          000000
@94fgetstor DS XL256                                                     000000
         ORG   @@STATICD@@+2560                                          000000
@103dgetstor DS XL256                                                    000000
         ORG   @@STATICD@@+2816                                          000000
@112qgetstor DS XL256                                                    000000
         END   ,(5650ZOS   ,2400,26156)                                  000000
