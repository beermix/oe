/*
 * Copyright 2008 Luis Busquets
 * Copyright 2011 Travis Athougies
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
 */

#include "wine/test.h"
#include "d3dx9.h"

static const DWORD shader_zero[] = {0x0};

static const DWORD shader_invalid[] = {0xeeee0100};

static const DWORD shader_empty[] = {0xfffeffff, 0x0000ffff};

static const DWORD simple_vs[] = {
    0xfffe0101,                                                             /* vs_1_1                       */
    0x0000001f, 0x80000000, 0x900f0000,                                     /* dcl_position0 v0             */
    0x00000009, 0xc0010000, 0x90e40000, 0xa0e40000,                         /* dp4 oPos.x, v0, c0           */
    0x00000009, 0xc0020000, 0x90e40000, 0xa0e40001,                         /* dp4 oPos.y, v0, c1           */
    0x00000009, 0xc0040000, 0x90e40000, 0xa0e40002,                         /* dp4 oPos.z, v0, c2           */
    0x00000009, 0xc0080000, 0x90e40000, 0xa0e40003,                         /* dp4 oPos.w, v0, c3           */
    0x0000ffff};                                                            /* END                          */

static const DWORD simple_ps[] = {
    0xffff0101,                                                             /* ps_1_1                       */
    0x00000051, 0xa00f0001, 0x3f800000, 0x00000000, 0x00000000, 0x00000000, /* def c1 = 1.0, 0.0, 0.0, 0.0  */
    0x00000042, 0xb00f0000,                                                 /* tex t0                       */
    0x00000008, 0x800f0000, 0xa0e40001, 0xa0e40000,                         /* dp3 r0, c1, c0               */
    0x00000005, 0x800f0000, 0x90e40000, 0x80e40000,                         /* mul r0, v0, r0               */
    0x00000005, 0x800f0000, 0xb0e40000, 0x80e40000,                         /* mul r0, t0, r0               */
    0x0000ffff};                                                            /* END                          */

#define FCC_TEXT MAKEFOURCC('T','E','X','T')
#define FCC_CTAB MAKEFOURCC('C','T','A','B')

static const DWORD shader_with_ctab[] = {
    0xfffe0300,                                                             /* vs_3_0                       */
    0x0002fffe, FCC_TEXT,   0x00000000,                                     /* TEXT comment                 */
    0x0008fffe, FCC_CTAB,   0x0000001c, 0x00000010, 0xfffe0300, 0x00000000, /* CTAB comment                 */
                0x00000000, 0x00000000, 0x00000000,
    0x0004fffe, FCC_TEXT,   0x00000000, 0x00000000, 0x00000000,             /* TEXT comment                 */
    0x0000ffff};                                                            /* END                          */

static const DWORD shader_with_invalid_ctab[] = {
    0xfffe0300,                                                             /* vs_3_0                       */
    0x0005fffe, FCC_CTAB,                                                   /* CTAB comment                 */
                0x0000001c, 0x000000a9, 0xfffe0300,
                0x00000000, 0x00000000,
    0x0000ffff};                                                            /* END                          */

static const DWORD shader_with_ctab_constants[] = {
    0xfffe0300,                                                             /* vs_3_0                       */
    0x002efffe, FCC_CTAB,                                                   /* CTAB comment                 */
    0x0000001c, 0x000000a4, 0xfffe0300, 0x00000003, 0x0000001c, 0x20008100, /* Header                       */
    0x0000009c,
    0x00000058, 0x00070002, 0x00000001, 0x00000064, 0x00000000,             /* Constant 1 desc              */
    0x00000074, 0x00000002, 0x00000004, 0x00000080, 0x00000000,             /* Constant 2 desc              */
    0x00000090, 0x00040002, 0x00000003, 0x00000080, 0x00000000,             /* Constant 3 desc              */
    0x736e6f43, 0x746e6174, 0xabab0031,                                     /* Constant 1 name string       */
    0x00030001, 0x00040001, 0x00000001, 0x00000000,                         /* Constant 1 type desc         */
    0x736e6f43, 0x746e6174, 0xabab0032,                                     /* Constant 2 name string       */
    0x00030003, 0x00040004, 0x00000001, 0x00000000,                         /* Constant 2 & 3 type desc     */
    0x736e6f43, 0x746e6174, 0xabab0033,                                     /* Constant 3 name string       */
    0x335f7376, 0xab00305f,                                                 /* Target name string           */
    0x656e6957, 0x6f727020, 0x7463656a, 0xababab00,                         /* Creator name string          */
    0x0000ffff};                                                            /* END                          */

static const DWORD ctab_basic[] = {
    0xfffe0300,                                                             /* vs_3_0                       */
    0x0040fffe, FCC_CTAB,                                                   /* CTAB comment                 */
    0x0000001c, 0x000000ec, 0xfffe0300, 0x00000005, 0x0000001c, 0x20008100, /* Header                       */
    0x000000e4,
    0x00000080, 0x00060002, 0x00000001, 0x00000084, 0x00000000,             /* Constant 1 desc (f)          */
    0x00000094, 0x00070002, 0x00000001, 0x00000098, 0x00000000,             /* Constant 2 desc (f4)         */
    0x000000A8, 0x00040002, 0x00000001, 0x000000AC, 0x00000000,             /* Constant 3 desc (i)          */
    0x000000BC, 0x00050002, 0x00000001, 0x000000C0, 0x00000000,             /* Constant 4 desc (i4)         */
    0x000000D0, 0x00000002, 0x00000004, 0x000000D4, 0x00000000,             /* Constant 5 desc (mvp)        */
    0xabab0066, 0x00030000, 0x00010001, 0x00000001, 0x00000000,             /* Constant 1 name/type desc    */
    0xab003466, 0x00030001, 0x00040001, 0x00000001, 0x00000000,             /* Constant 2 name/type desc    */
    0xabab0069, 0x00020000, 0x00010001, 0x00000001, 0x00000000,             /* Constant 3 name/type desc    */
    0xab003469, 0x00020001, 0x00040001, 0x00000001, 0x00000000,             /* Constant 4 name/type desc    */
    0x0070766d, 0x00030003, 0x00040004, 0x00000001, 0x00000000,             /* Constant 5 name/type desc    */
    0x335f7376, 0xab00305f,                                                 /* Target name string           */
    0x656e6957, 0x6f727020, 0x7463656a, 0xababab00,                         /* Creator name string          */
    0x0000ffff};                                                            /* END                          */

static const D3DXCONSTANT_DESC ctab_basic_expected[] = {
    {"mvp", D3DXRS_FLOAT4, 0, 4, D3DXPC_MATRIX_COLUMNS, D3DXPT_FLOAT, 4, 4, 1, 0, 64, NULL},
    {"i",   D3DXRS_FLOAT4, 4, 1, D3DXPC_SCALAR,         D3DXPT_INT,   1, 1, 1, 0,  4, NULL},
    {"i4",  D3DXRS_FLOAT4, 5, 1, D3DXPC_VECTOR,         D3DXPT_INT,   1, 4, 1, 0, 16, NULL},
    {"f",   D3DXRS_FLOAT4, 6, 1, D3DXPC_SCALAR,         D3DXPT_FLOAT, 1, 1, 1, 0,  4, NULL},
    {"f4",  D3DXRS_FLOAT4, 7, 1, D3DXPC_VECTOR,         D3DXPT_FLOAT, 1, 4, 1, 0, 16, NULL}};

static const DWORD ctab_matrices[] = {
    0xfffe0300,                                                             /* vs_3_0                       */
    0x0032fffe, FCC_CTAB,                                                   /* CTAB comment                 */
    0x0000001c, 0x000000b4, 0xfffe0300, 0x00000003, 0x0000001c, 0x20008100, /* Header                       */
    0x000000ac,
    0x00000058, 0x00070002, 0x00000001, 0x00000064, 0x00000000,             /* Constant 1 desc (fmatrix3x1) */
    0x00000074, 0x00000002, 0x00000004, 0x00000080, 0x00000000,             /* Constant 2 desc (fmatrix4x4) */
    0x00000090, 0x00040002, 0x00000003, 0x0000009c, 0x00000000,             /* Constant 3 desc (imatrix2x3) */
    0x74616D66, 0x33786972, 0xab003178,                                     /* Constant 1 name              */
    0x00030003, 0x00010003, 0x00000001, 0x00000000,                         /* Constant 1 type desc         */
    0x74616D66, 0x34786972, 0xab003478,                                     /* Constant 2 name              */
    0x00030003, 0x00040004, 0x00000001, 0x00000000,                         /* Constant 2 type desc         */
    0x74616D69, 0x32786972, 0xab003378,                                     /* Constant 3 name              */
    0x00020002, 0x00030002, 0x00000001, 0x00000000,                         /* Constant 3 type desc         */
    0x335f7376, 0xab00305f,                                                 /* Target name string           */
    0x656e6957, 0x6f727020, 0x7463656a, 0xababab00,                         /* Creator name string          */
    0x0000ffff};                                                            /* END                          */

static const D3DXCONSTANT_DESC ctab_matrices_expected[] = {
    {"fmatrix4x4", D3DXRS_FLOAT4, 0, 4, D3DXPC_MATRIX_COLUMNS, D3DXPT_FLOAT, 4, 4, 1, 0, 64, NULL},
    {"imatrix2x3", D3DXRS_FLOAT4, 4, 3, D3DXPC_MATRIX_ROWS,    D3DXPT_INT,   2, 3, 1, 0, 24, NULL},
    {"fmatrix3x1", D3DXRS_FLOAT4, 7, 1, D3DXPC_MATRIX_COLUMNS, D3DXPT_FLOAT, 3, 1, 1, 0, 12, NULL}};

static const DWORD ctab_matrices2[] = {
    0xfffe0200,                                                             /* vs_2_0                        */
    0x0058fffe, FCC_CTAB,                                                   /* CTAB comment                  */
    0x0000001c, 0x0000012b, 0xfffe0200, 0x00000006, 0x0000001c, 0x00000100, /* Header                        */
    0x00000124,
    0x00000094, 0x00070002, 0x00000003, 0x0000009c, 0x00000000,             /* Constant 1 desc (c2x3)        */
    0x000000ac, 0x000d0002, 0x00000002, 0x000000b4, 0x00000000,             /* Constant 2 desc (c3x2)        */
    0x000000c4, 0x000a0002, 0x00000003, 0x000000cc, 0x00000000,             /* Constant 3 desc (c3x3)        */
    0x000000dc, 0x000f0002, 0x00000002, 0x000000e4, 0x00000000,             /* Constant 4 desc (r2x3)        */
    0x000000f4, 0x00040002, 0x00000003, 0x000000fc, 0x00000000,             /* Constant 5 desc (r3x2)        */
    0x0000010c, 0x00000002, 0x00000004, 0x00000114, 0x00000000,             /* Constant 6 desc (r4x4)        */
    0x33783263, 0xababab00,                                                 /* Constant 1 name               */
    0x00030003, 0x00030002, 0x00000001, 0x00000000,                         /* Constant 1 type desc          */
    0x32783363, 0xababab00,                                                 /* Constant 2 name               */
    0x00030003, 0x00020003, 0x00000001, 0x00000000,                         /* Constant 2 type desc          */
    0x33783363, 0xababab00,                                                 /* Constant 3 name               */
    0x00030003, 0x00030003, 0x00000001, 0x00000000,                         /* Constant 3 type desc          */
    0x33783272, 0xababab00,                                                 /* Constant 4 name               */
    0x00030002, 0x00030002, 0x00000001, 0x00000000,                         /* Constant 4 type desc          */
    0x32783372, 0xababab00,                                                 /* Constant 5 name               */
    0x00030002, 0x00020003, 0x00000001, 0x00000000,                         /* Constant 5 type desc          */
    0x34783472, 0xababab00,                                                 /* Constant 6 name               */
    0x00030002, 0x00040004, 0x00000001, 0x00000000,                         /* Constant 6 type desc          */
    0x325f7376, 0x4100305f, 0x41414141, 0x00414141,                         /* Target and Creator name       */
    0x0000ffff};                                                            /* END                           */

static const D3DXCONSTANT_DESC ctab_matrices2_expected[] = {
    {"c2x3", D3DXRS_FLOAT4,  7, 3, D3DXPC_MATRIX_COLUMNS, D3DXPT_FLOAT, 2, 3, 1, 0, 24, NULL},
    {"c3x2", D3DXRS_FLOAT4, 13, 2, D3DXPC_MATRIX_COLUMNS, D3DXPT_FLOAT, 3, 2, 1, 0, 24, NULL},
    {"c3x3", D3DXRS_FLOAT4, 10, 3, D3DXPC_MATRIX_COLUMNS, D3DXPT_FLOAT, 3, 3, 1, 0, 36, NULL},
    {"r2x3", D3DXRS_FLOAT4, 15, 2, D3DXPC_MATRIX_ROWS,    D3DXPT_FLOAT, 2, 3, 1, 0, 24, NULL},
    {"r3x2", D3DXRS_FLOAT4,  4, 3, D3DXPC_MATRIX_ROWS,    D3DXPT_FLOAT, 3, 2, 1, 0, 24, NULL},
    {"r4x4", D3DXRS_FLOAT4,  0, 4, D3DXPC_MATRIX_ROWS,    D3DXPT_FLOAT, 4, 4, 1, 0, 64, NULL}};

static const DWORD ctab_arrays[] = {
    0xfffe0300,                                                             /* vs_3_0                       */
    0x0052fffe, FCC_CTAB,                                                   /* CTAB comment                 */
    0x0000001c, 0x0000013c, 0xfffe0300, 0x00000006, 0x0000001c, 0x20008100, /* Header                       */
    0x00000134,
    0x00000094, 0x000E0002, 0x00000002, 0x0000009c, 0x00000000,             /* Constant 1 desc (barray)     */
    0x000000ac, 0x00100002, 0x00000002, 0x000000b8, 0x00000000,             /* Constant 2 desc (bvecarray)  */
    0x000000c8, 0x00080002, 0x00000004, 0x000000d0, 0x00000000,             /* Constant 3 desc (farray)     */
    0x000000e0, 0x00000002, 0x00000008, 0x000000ec, 0x00000000,             /* Constant 4 desc (fmtxarray)  */
    0x000000fc, 0x000C0002, 0x00000002, 0x00000108, 0x00000000,             /* Constant 5 desc (fvecarray)  */
    0x00000118, 0x00120002, 0x00000001, 0x00000124, 0x00000000,             /* Constant 6 desc (ivecarray)  */
    0x72726162, 0xab007961,                                                 /* Constant 1 name              */
    0x00010000, 0x00010001, 0x00000002, 0x00000000,                         /* Constant 1 type desc         */
    0x63657662, 0x61727261, 0xabab0079,                                     /* Constant 2 name              */
    0x00010001, 0x00030001, 0x00000003, 0x00000000,                         /* Constant 2 type desc         */
    0x72726166, 0xab007961,                                                 /* Constant 3 name              */
    0x00030000, 0x00010001, 0x00000004, 0x00000000,                         /* constant 3 type desc         */
    0x78746d66, 0x61727261, 0xabab0079,                                     /* Constant 4 name              */
    0x00030002, 0x00040004, 0x00000002, 0x00000000,                         /* Constant 4 type desc         */
    0x63657666, 0x61727261, 0xabab0079,                                     /* Constant 5 name              */
    0x00030001, 0x00040001, 0x00000002, 0x00000000,                         /* Constant 5 type desc         */
    0x63657669, 0x61727261, 0xabab0079,                                     /* Constant 6 name              */
    0x00020001, 0x00040001, 0x00000001, 0x00000000,                         /* Constant 6 type desc         */
    0x335f7376, 0xab00305f,                                                 /* Target name string           */
    0x656e6957, 0x6f727020, 0x7463656a, 0xababab00,                         /* Creator name string          */
    0x0000ffff};                                                            /* END                          */

static const D3DXCONSTANT_DESC ctab_arrays_expected[] = {
    {"fmtxarray", D3DXRS_FLOAT4,  0, 8, D3DXPC_MATRIX_ROWS, D3DXPT_FLOAT, 4, 4, 2, 0, 128, NULL},
    {"farray",    D3DXRS_FLOAT4,  8, 4, D3DXPC_SCALAR,      D3DXPT_FLOAT, 1, 1, 4, 0,  16, NULL},
    {"fvecarray", D3DXRS_FLOAT4, 12, 2, D3DXPC_VECTOR,      D3DXPT_FLOAT, 1, 4, 2, 0,  32, NULL},
    {"barray",    D3DXRS_FLOAT4, 14, 2, D3DXPC_SCALAR,      D3DXPT_BOOL,  1, 1, 2, 0,   8, NULL},
    {"bvecarray", D3DXRS_FLOAT4, 16, 2, D3DXPC_VECTOR,      D3DXPT_BOOL,  1, 3, 3, 0,  36, NULL},
    {"ivecarray", D3DXRS_FLOAT4, 18, 1, D3DXPC_VECTOR,      D3DXPT_INT,   1, 4, 1, 0,  16, NULL}};

static const DWORD ctab_with_default_values[] = {
    0xfffe0200,                                                 /* vs_2_0 */
    0x007bfffe, FCC_CTAB,                                       /* CTAB comment */
    0x0000001c, 0x000001b7, 0xfffe0200, 0x00000005, 0x0000001c, /* header */
    0x00000100, 0x000001b0,
    0x00000080, 0x00080002, 0x00000003, 0x00000084, 0x00000094, /* constant 1 desc (arr) */
    0x000000c4, 0x000c0002, 0x00000001, 0x000000c8, 0x000000d8, /* constant 2 desc (flt) */
    0x000000e8, 0x00040002, 0x00000004, 0x000000f0, 0x00000100, /* constant 3 desc (mat3) */
    0x00000140, 0x00000002, 0x00000004, 0x000000f0, 0x00000148, /* constant 4 desc (mat4) */
    0x00000188, 0x000b0002, 0x00000001, 0x00000190, 0x000001a0, /* constant 5 desc (vec4) */
    0x00727261,                                                 /* constant 1 name */
    0x00030000, 0x00010001, 0x00000003, 0x00000000,             /* constant 1 type desc */
    0x42c80000, 0x00000000, 0x00000000, 0x00000000,             /* constant 1 default value */
    0x43480000, 0x00000000, 0x00000000, 0x00000000,
    0x43960000, 0x00000000, 0x00000000, 0x00000000,
    0x00746c66,                                                 /* constant 2 name */
    0x00030000, 0x00010001, 0x00000001, 0x00000000,             /* constant 2 type desc */
    0x411fd70a, 0x00000000, 0x00000000, 0x00000000,             /* constant 2 default value */
    0x3374616d,                                                 /* constant 3 name */
    0xababab00,
    0x00030003, 0x00040004, 0x00000001, 0x00000000,             /* constant 3 & 4 type desc */
    0x41300000, 0x425c0000, 0x42c60000, 0x44a42000,             /* constat 3 default value */
    0x41b00000, 0x42840000, 0x447c8000, 0x44b0c000,
    0x42040000, 0x429a0000, 0x448ae000, 0x44bd6000,
    0x42300000, 0x42b00000, 0x44978000, 0x44ca0000,
    0x3474616d,                                                 /* constant 4 name */
    0xababab00,
    0x3f800000, 0x40a00000, 0x41100000, 0x41500000,             /* constant 4 default value */
    0x40000000, 0x40c00000, 0x41200000, 0x41600000,
    0x40400000, 0x40e00000, 0x41300000, 0x41700000,
    0x40800000, 0x41000000, 0x41400000, 0x41800000,
    0x34636576,                                                 /* constant 5 name */
    0xababab00,
    0x00030001, 0x00040001, 0x00000001, 0x00000000,             /* constant 5 type desc */
    0x41200000, 0x41a00000, 0x41f00000, 0x42200000,             /* constant 5 default value */
    0x325f7376, 0x4d004141, 0x41414141, 0x00000000,             /* target & creator string */
    0x0000ffff};                                                /* END */

static const float mat4_default_value[] = {1, 5, 9, 13, 2, 6, 10, 14, 3, 7, 11, 15, 4, 8, 12, 16};
static const float mat3_default_value[] = {11, 55, 99, 1313, 22, 66, 1010, 1414, 33, 77, 1111, 1515, 44, 88, 1212, 1616};
static const float arr_default_value[] = {100, 0, 0, 0, 200, 0, 0, 0, 300, 0, 0, 0};
static const float vec4_default_value[] = {10, 20, 30, 40};
static const float flt_default_value[] = {9.99, 0, 0, 0};

static const D3DXCONSTANT_DESC ctab_with_default_values_expected[] = {
    {"mat4", D3DXRS_FLOAT4,  0, 4, D3DXPC_MATRIX_COLUMNS, D3DXPT_FLOAT, 4, 4, 1, 0, 64, mat4_default_value},
    {"mat3", D3DXRS_FLOAT4,  4, 4, D3DXPC_MATRIX_COLUMNS, D3DXPT_FLOAT, 4, 4, 1, 0, 64, mat3_default_value},
    {"arr",  D3DXRS_FLOAT4,  8, 3, D3DXPC_SCALAR,         D3DXPT_FLOAT, 1, 1, 3, 0, 12, arr_default_value},
    {"vec4", D3DXRS_FLOAT4, 11, 1, D3DXPC_VECTOR,         D3DXPT_FLOAT, 1, 4, 1, 0, 16, vec4_default_value},
    {"flt",  D3DXRS_FLOAT4, 12, 1, D3DXPC_SCALAR,         D3DXPT_FLOAT, 1, 1, 1, 0,  4, flt_default_value}};

static const DWORD ctab_samplers[] = {
    0xfffe0300,                                                             /* vs_3_0                        */
    0x0032fffe, FCC_CTAB,                                                   /* CTAB comment                  */
    0x0000001c, 0x000000b4, 0xfffe0300, 0x00000003, 0x0000001c, 0x20008100, /* Header                        */
    0x000000ac,
    0x00000058, 0x00020002, 0x00000001, 0x00000064, 0x00000000,             /* Constant 1 desc (notsampler)  */
    0x00000074, 0x00000003, 0x00000001, 0x00000080, 0x00000000,             /* Constant 2 desc (sampler1)    */
    0x00000090, 0x00030003, 0x00000001, 0x0000009c, 0x00000000,             /* Constant 3 desc (sampler2)    */
    0x73746f6e, 0x6c706d61, 0xab007265,                                     /* Constant 1 name               */
    0x00030001, 0x00040001, 0x00000001, 0x00000000,                         /* Constant 1 type desc          */
    0x706d6173, 0x3172656c, 0xababab00,                                     /* Constant 2 name               */
    0x000c0004, 0x00010001, 0x00000001, 0x00000000,                         /* Constant 2 type desc          */
    0x706d6173, 0x3272656c, 0xababab00,                                     /* Constant 3 name               */
    0x000d0004, 0x00010001, 0x00000001, 0x00000000,                         /* Constant 3 type desc          */
    0x335f7376, 0xab00305f,                                                 /* Target name string            */
    0x656e6957, 0x6f727020, 0x7463656a, 0xababab00,                         /* Creator name string           */
    0x0000ffff};                                                            /* END                           */

static const D3DXCONSTANT_DESC ctab_samplers_expected[] = {
    {"sampler1",   D3DXRS_SAMPLER, 0, 1, D3DXPC_OBJECT, D3DXPT_SAMPLER2D, 1, 1, 1, 0, 4,  NULL},
    {"sampler2",   D3DXRS_SAMPLER, 3, 1, D3DXPC_OBJECT, D3DXPT_SAMPLER3D, 1, 1, 1, 0, 4,  NULL},
    {"notsampler", D3DXRS_FLOAT4,  2, 1, D3DXPC_VECTOR, D3DXPT_FLOAT,     1, 4, 1, 0, 16, NULL}};

static void test_get_shader_size(void)
{
    UINT shader_size, expected;

    shader_size = D3DXGetShaderSize(simple_vs);
    expected = sizeof(simple_vs);
    ok(shader_size == expected, "Got shader size %u, expected %u\n", shader_size, expected);

    shader_size = D3DXGetShaderSize(simple_ps);
    expected = sizeof(simple_ps);
    ok(shader_size == expected, "Got shader size %u, expected %u\n", shader_size, expected);

    shader_size = D3DXGetShaderSize(NULL);
    ok(shader_size == 0, "Got shader size %u, expected 0\n", shader_size);
}

static void test_get_shader_version(void)
{
    DWORD shader_version;

    shader_version = D3DXGetShaderVersion(simple_vs);
    ok(shader_version == D3DVS_VERSION(1, 1), "Got shader version 0x%08x, expected 0x%08x\n",
            shader_version, D3DVS_VERSION(1, 1));

    shader_version = D3DXGetShaderVersion(simple_ps);
    ok(shader_version == D3DPS_VERSION(1, 1), "Got shader version 0x%08x, expected 0x%08x\n",
            shader_version, D3DPS_VERSION(1, 1));

    shader_version = D3DXGetShaderVersion(NULL);
    ok(shader_version == 0, "Got shader version 0x%08x, expected 0\n", shader_version);
}

static void test_find_shader_comment(void)
{
    HRESULT hr;
    LPCVOID data = (LPVOID)0xdeadbeef;
    UINT size = 100;

    hr = D3DXFindShaderComment(NULL, MAKEFOURCC('C','T','A','B'), &data, &size);
    ok(hr == D3DERR_INVALIDCALL, "Got result %x, expected %x (D3DERR_INVALIDCALL)\n", hr, D3DERR_INVALIDCALL);
    ok(!data, "Got %p, expected NULL\n", data);
    ok(!size, "Got %u, expected 0\n", size);

    hr = D3DXFindShaderComment(shader_with_ctab, MAKEFOURCC('C','T','A','B'), NULL, &size);
    ok(hr == D3D_OK, "Got result %x, expected 0 (D3D_OK)\n", hr);
    ok(size == 28, "Got %u, expected 28\n", size);

    hr = D3DXFindShaderComment(shader_with_ctab, MAKEFOURCC('C','T','A','B'), &data, NULL);
    ok(hr == D3D_OK, "Got result %x, expected 0 (D3D_OK)\n", hr);
    ok(data == (LPCVOID)(shader_with_ctab + 6), "Got result %p, expected %p\n", data, shader_with_ctab + 6);

    hr = D3DXFindShaderComment(shader_with_ctab, 0, &data, &size);
    ok(hr == S_FALSE, "Got result %x, expected 1 (S_FALSE)\n", hr);
    ok(!data, "Got %p, expected NULL\n", data);
    ok(!size, "Got %u, expected 0\n", size);

    hr = D3DXFindShaderComment(shader_with_ctab, MAKEFOURCC('X','X','X','X'), &data, &size);
    ok(hr == S_FALSE, "Got result %x, expected 1 (S_FALSE)\n", hr);
    ok(!data, "Got %p, expected NULL\n", data);
    ok(!size, "Got %u, expected 0\n", size);

    hr = D3DXFindShaderComment(shader_with_ctab, MAKEFOURCC('C','T','A','B'), &data, &size);
    ok(hr == D3D_OK, "Got result %x, expected 0 (D3D_OK)\n", hr);
    ok(data == (LPCVOID)(shader_with_ctab + 6), "Got result %p, expected %p\n", data, shader_with_ctab + 6);
    ok(size == 28, "Got result %d, expected 28\n", size);

    hr = D3DXFindShaderComment(shader_zero, MAKEFOURCC('C','T','A','B'), &data, &size);
    ok(hr == D3DXERR_INVALIDDATA, "Got result %x, expected %x (D3DXERR_INVALIDDATA)\n", hr, D3DXERR_INVALIDDATA);
    ok(!data, "Got %p, expected NULL\n", data);
    ok(!size, "Got %u, expected 0\n", size);

    hr = D3DXFindShaderComment(shader_invalid, MAKEFOURCC('C','T','A','B'), &data, &size);
    ok(hr == D3DXERR_INVALIDDATA, "Got result %x, expected %x (D3DXERR_INVALIDDATA)\n", hr, D3DXERR_INVALIDDATA);
    ok(!data, "Got %p, expected NULL\n", data);
    ok(!size, "Got %u, expected 0\n", size);

    hr = D3DXFindShaderComment(shader_empty, MAKEFOURCC('C','T','A','B'), &data, &size);
    ok(hr == S_FALSE, "Got result %x, expected %x (S_FALSE)\n", hr, S_FALSE);
    ok(!data, "Got %p, expected NULL\n", data);
    ok(!size, "Got %u, expected 0\n", size);
}

static void test_get_shader_constant_table_ex(void)
{
    ID3DXConstantTable *constant_table;
    HRESULT hr;
    LPVOID data;
    DWORD size;
    D3DXCONSTANTTABLE_DESC desc;

    constant_table = (ID3DXConstantTable *)0xdeadbeef;
    hr = D3DXGetShaderConstantTableEx(NULL, 0, &constant_table);
    ok(hr == D3DERR_INVALIDCALL, "Got result %x, expected %x (D3DERR_INVALIDCALL)\n", hr, D3DERR_INVALIDCALL);
    ok(constant_table == NULL, "D3DXGetShaderConstantTableEx() failed, got %p\n", constant_table);

    constant_table = (ID3DXConstantTable *)0xdeadbeef;
    hr = D3DXGetShaderConstantTableEx(shader_zero, 0, &constant_table);
    ok(hr == D3D_OK, "Got result %x, expected %x (D3D_OK)\n", hr, D3D_OK);
    ok(constant_table == NULL, "D3DXGetShaderConstantTableEx() failed, got %p\n", constant_table);

    constant_table = (ID3DXConstantTable *)0xdeadbeef;
    hr = D3DXGetShaderConstantTableEx(shader_invalid, 0, &constant_table);
    ok(hr == D3D_OK, "Got result %x, expected %x (D3D_OK)\n", hr, D3D_OK);
    ok(constant_table == NULL, "D3DXGetShaderConstantTableEx() failed, got %p\n", constant_table);

    constant_table = (ID3DXConstantTable *)0xdeadbeef;
    hr = D3DXGetShaderConstantTableEx(shader_empty, 0, &constant_table);
    ok(hr == D3DXERR_INVALIDDATA, "Got result %x, expected %x (D3DXERR_INVALIDDATA)\n", hr, D3DXERR_INVALIDDATA);
    ok(constant_table == NULL, "D3DXGetShaderConstantTableEx() failed, got %p\n", constant_table);

    /* No CTAB data */
    constant_table = (ID3DXConstantTable *)0xdeadbeef;
    hr = D3DXGetShaderConstantTableEx(simple_ps, 0, &constant_table);
    ok(hr == D3DXERR_INVALIDDATA, "Got result %x, expected %x (D3DXERR_INVALIDDATA)\n", hr, D3DXERR_INVALIDDATA);
    ok(constant_table == NULL, "D3DXGetShaderConstantTableEx() failed, got %p\n", constant_table);

    /* With invalid CTAB data */
    hr = D3DXGetShaderConstantTableEx(shader_with_invalid_ctab, 0, &constant_table);
    ok(hr == D3DXERR_INVALIDDATA || broken(hr == D3D_OK), /* winxp 64-bit, w2k3 64-bit */
       "Got result %x, expected %x (D3DXERR_INVALIDDATA)\n", hr, D3DXERR_INVALIDDATA);
    if (constant_table) ID3DXConstantTable_Release(constant_table);

    hr = D3DXGetShaderConstantTableEx(shader_with_ctab, 0, &constant_table);
    ok(hr == D3D_OK, "Got result %x, expected 0 (D3D_OK)\n", hr);
    ok(constant_table != NULL, "D3DXGetShaderConstantTableEx() failed, got NULL\n");

    if (constant_table)
    {
        size = ID3DXConstantTable_GetBufferSize(constant_table);
        ok(size == 28, "Got result %x, expected 28\n", size);

        data = ID3DXConstantTable_GetBufferPointer(constant_table);
        ok(!memcmp(data, shader_with_ctab + 6, size), "Retrieved wrong CTAB data\n");

        hr = ID3DXConstantTable_GetDesc(constant_table, NULL);
        ok(hr == D3DERR_INVALIDCALL, "Got result %x, expected %x (D3DERR_INVALIDCALL)\n", hr, D3DERR_INVALIDCALL);

        hr = ID3DXConstantTable_GetDesc(constant_table, &desc);
        ok(hr == D3D_OK, "Got result %x, expected 0 (D3D_OK)\n", hr);
        ok(desc.Creator == (LPCSTR)data + 0x10, "Got result %p, expected %p\n", desc.Creator, (LPCSTR)data + 0x10);
        ok(desc.Version == D3DVS_VERSION(3, 0), "Got result %x, expected %x\n", desc.Version, D3DVS_VERSION(3, 0));
        ok(desc.Constants == 0, "Got result %x, expected 0\n", desc.Constants);

        ID3DXConstantTable_Release(constant_table);
    }

    hr = D3DXGetShaderConstantTableEx(shader_with_ctab_constants, 0, &constant_table);
    ok(hr == D3D_OK, "Got result %x, expected 0 (D3D_OK)\n", hr);
    ok(constant_table != NULL, "D3DXGetShaderConstantTableEx() failed, got NULL\n");

    if (constant_table)
    {
        D3DXHANDLE constant;
        D3DXCONSTANT_DESC constant_desc;
        D3DXCONSTANT_DESC constant_desc_save;
        UINT nb;

        /* Test GetDesc */
        hr = ID3DXConstantTable_GetDesc(constant_table, &desc);
        ok(hr == D3D_OK, "Got result %x, expected 0 (D3D_OK)\n", hr);
        ok(!strcmp(desc.Creator, "Wine project"), "Got result '%s', expected 'Wine project'\n", desc.Creator);
        ok(desc.Version == D3DVS_VERSION(3, 0), "Got result %x, expected %x\n", desc.Version, D3DVS_VERSION(3, 0));
        ok(desc.Constants == 3, "Got result %x, expected 3\n", desc.Constants);

        /* Test GetConstant */
        constant = ID3DXConstantTable_GetConstant(constant_table, NULL, 0);
        ok(constant != NULL, "No constant found\n");
        hr = ID3DXConstantTable_GetConstantDesc(constant_table, constant, &constant_desc, &nb);
        ok(hr == D3D_OK, "Got result %x, expected 0 (D3D_OK)\n", hr);
        ok(!strcmp(constant_desc.Name, "Constant1"), "Got result '%s', expected 'Constant1'\n",
            constant_desc.Name);
        ok(constant_desc.Class == D3DXPC_VECTOR, "Got result %x, expected %u (D3DXPC_VECTOR)\n",
            constant_desc.Class, D3DXPC_VECTOR);
        ok(constant_desc.Type == D3DXPT_FLOAT, "Got result %x, expected %u (D3DXPT_FLOAT)\n",
            constant_desc.Type, D3DXPT_FLOAT);
        ok(constant_desc.Rows == 1, "Got result %x, expected 1\n", constant_desc.Rows);
        ok(constant_desc.Columns == 4, "Got result %x, expected 4\n", constant_desc.Columns);

        constant = ID3DXConstantTable_GetConstant(constant_table, NULL, 1);
        ok(constant != NULL, "No constant found\n");
        hr = ID3DXConstantTable_GetConstantDesc(constant_table, constant, &constant_desc, &nb);
        ok(hr == D3D_OK, "Got result %x, expected 0 (D3D_OK)\n", hr);
        ok(!strcmp(constant_desc.Name, "Constant2"), "Got result '%s', expected 'Constant2'\n",
            constant_desc.Name);
        ok(constant_desc.Class == D3DXPC_MATRIX_COLUMNS, "Got result %x, expected %u (D3DXPC_MATRIX_COLUMNS)\n",
            constant_desc.Class, D3DXPC_MATRIX_COLUMNS);
        ok(constant_desc.Type == D3DXPT_FLOAT, "Got result %x, expected %u (D3DXPT_FLOAT)\n",
            constant_desc.Type, D3DXPT_FLOAT);
        ok(constant_desc.Rows == 4, "Got result %x, expected 1\n", constant_desc.Rows);
        ok(constant_desc.Columns == 4, "Got result %x, expected 4\n", constant_desc.Columns);

        constant = ID3DXConstantTable_GetConstant(constant_table, NULL, 2);
        ok(constant != NULL, "No constant found\n");
        hr = ID3DXConstantTable_GetConstantDesc(constant_table, constant, &constant_desc, &nb);
        ok(hr == D3D_OK, "Got result %x, expected 0 (D3D_OK)\n", hr);
        ok(!strcmp(constant_desc.Name, "Constant3"), "Got result '%s', expected 'Constant3'\n",
            constant_desc.Name);
        ok(constant_desc.Class == D3DXPC_MATRIX_COLUMNS, "Got result %x, expected %u (D3DXPC_MATRIX_COLUMNS)\n",
            constant_desc.Class, D3DXPC_MATRIX_COLUMNS);
        ok(constant_desc.Type == D3DXPT_FLOAT, "Got result %x, expected %u (D3DXPT_FLOAT)\n",
            constant_desc.Type, D3DXPT_FLOAT);
        ok(constant_desc.Rows == 4, "Got result %x, expected 1\n", constant_desc.Rows);
        ok(constant_desc.Columns == 4, "Got result %x, expected 4\n", constant_desc.Columns);
        constant_desc_save = constant_desc; /* For GetConstantDesc test */

        constant = ID3DXConstantTable_GetConstant(constant_table, NULL, 3);
        ok(constant == NULL, "Got result %p, expected NULL\n", constant);

        /* Test GetConstantByName */
        constant = ID3DXConstantTable_GetConstantByName(constant_table, NULL, "Constant unknown");
        ok(constant == NULL, "Got result %p, expected NULL\n", constant);
        constant = ID3DXConstantTable_GetConstantByName(constant_table, NULL, "Constant3");
        ok(constant != NULL, "No constant found\n");
        hr = ID3DXConstantTable_GetConstantDesc(constant_table, constant, &constant_desc, &nb);
        ok(hr == D3D_OK, "Got result %x, expected 0 (D3D_OK)\n", hr);
        ok(!memcmp(&constant_desc, &constant_desc_save, sizeof(D3DXCONSTANT_DESC)), "Got different constant data\n");

        /* Test GetConstantDesc */
        constant = ID3DXConstantTable_GetConstant(constant_table, NULL, 0);
        ok(constant != NULL, "No constant found\n");
        hr = ID3DXConstantTable_GetConstantDesc(constant_table, NULL, &constant_desc, &nb);
        ok(hr == D3DERR_INVALIDCALL, "Got result %x, expected %x (D3DERR_INVALIDCALL)\n", hr, D3DERR_INVALIDCALL);
        hr = ID3DXConstantTable_GetConstantDesc(constant_table, constant, NULL, &nb);
        ok(hr == D3D_OK, "Got result %x, expected 0 (D3D_OK)\n", hr);
        hr = ID3DXConstantTable_GetConstantDesc(constant_table, constant, &constant_desc, NULL);
        ok(hr == D3D_OK, "Got result %x, expected 0 (D3D_OK)\n", hr);
        hr = ID3DXConstantTable_GetConstantDesc(constant_table, "Constant unknow", &constant_desc, &nb);
        ok(hr == D3DERR_INVALIDCALL, "Got result %x, expected %x (D3DERR_INVALIDCALL)\n", hr, D3DERR_INVALIDCALL);
        hr = ID3DXConstantTable_GetConstantDesc(constant_table, "Constant3", &constant_desc, &nb);
        ok(hr == D3D_OK, "Got result %x, expected 0 (D3D_OK)\n", hr);
        ok(!memcmp(&constant_desc, &constant_desc_save, sizeof(D3DXCONSTANT_DESC)), "Got different constant data\n");

        ID3DXConstantTable_Release(constant_table);
    }
}

static void test_constant_table(const char *test_name, const DWORD *ctable_fn,
        const D3DXCONSTANT_DESC *expecteds, UINT count)
{
    UINT i;
    ID3DXConstantTable *ctable;

    HRESULT res;

    /* Get the constant table from the shader itself */
    res = D3DXGetShaderConstantTable(ctable_fn, &ctable);
    ok(res == D3D_OK, "D3DXGetShaderConstantTable failed on %s: got %08x\n", test_name, res);

    for (i = 0; i < count; i++)
    {
        const D3DXCONSTANT_DESC *expected = &expecteds[i];
        D3DXHANDLE const_handle;
        D3DXCONSTANT_DESC actual;
        UINT pCount = 1;

        const_handle = ID3DXConstantTable_GetConstantByName(ctable, NULL, expected->Name);

        res = ID3DXConstantTable_GetConstantDesc(ctable, const_handle, &actual, &pCount);
        ok(SUCCEEDED(res), "%s in %s: ID3DXConstantTable_GetConstantDesc returned %08x\n", expected->Name,
                test_name, res);
        ok(pCount == 1, "%s in %s: Got more or less descriptions: %d\n", expected->Name, test_name, pCount);

        ok(strcmp(actual.Name, expected->Name) == 0,
           "%s in %s: Got different names: Got %s, expected %s\n", expected->Name,
           test_name, actual.Name, expected->Name);
        ok(actual.RegisterSet == expected->RegisterSet,
           "%s in %s: Got different register sets: Got %d, expected %d\n",
           expected->Name, test_name, actual.RegisterSet, expected->RegisterSet);
        ok(actual.RegisterIndex == expected->RegisterIndex,
           "%s in %s: Got different register indices: Got %d, expected %d\n",
           expected->Name, test_name, actual.RegisterIndex, expected->RegisterIndex);
        ok(actual.RegisterCount == expected->RegisterCount,
           "%s in %s: Got different register counts: Got %d, expected %d\n",
           expected->Name, test_name, actual.RegisterCount, expected->RegisterCount);
        ok(actual.Class == expected->Class,
           "%s in %s: Got different classes: Got %d, expected %d\n", expected->Name,
           test_name, actual.Class, expected->Class);
        ok(actual.Type == expected->Type,
           "%s in %s: Got different types: Got %d, expected %d\n", expected->Name,
           test_name, actual.Type, expected->Type);
        ok(actual.Rows == expected->Rows && actual.Columns == expected->Columns,
           "%s in %s: Got different dimensions: Got (%d, %d), expected (%d, %d)\n",
           expected->Name, test_name, actual.Rows, actual.Columns, expected->Rows,
           expected->Columns);
        ok(actual.Elements == expected->Elements,
           "%s in %s: Got different element count: Got %d, expected %d\n",
           expected->Name, test_name, actual.Elements, expected->Elements);
        ok(actual.StructMembers == expected->StructMembers,
           "%s in %s: Got different struct member count: Got %d, expected %d\n",
           expected->Name, test_name, actual.StructMembers, expected->StructMembers);
        ok(actual.Bytes == expected->Bytes,
           "%s in %s: Got different byte count: Got %d, expected %d\n",
           expected->Name, test_name, actual.Bytes, expected->Bytes);

        if (!expected->DefaultValue)
        {
            ok(actual.DefaultValue == NULL,
                "%s in %s: Got different default value: expected NULL\n",
                expected->Name, test_name);
        }
        else
        {
            ok(actual.DefaultValue != NULL,
                "%s in %s: Got different default value: expected non-NULL\n",
                expected->Name, test_name);
            ok(memcmp(actual.DefaultValue, expected->DefaultValue, expected->Bytes) == 0,
                "%s in %s: Got different default value\n", expected->Name, test_name);
        }
    }

    /* Finally, release the constant table */
    ID3DXConstantTable_Release(ctable);
}

static void test_constant_tables(void)
{
    test_constant_table("test_basic", ctab_basic, ctab_basic_expected,
            sizeof(ctab_basic_expected)/sizeof(*ctab_basic_expected));
    test_constant_table("test_matrices", ctab_matrices, ctab_matrices_expected,
            sizeof(ctab_matrices_expected)/sizeof(*ctab_matrices_expected));
    test_constant_table("test_matrices2", ctab_matrices2, ctab_matrices2_expected,
            sizeof(ctab_matrices2_expected)/sizeof(*ctab_matrices2_expected));
    test_constant_table("test_arrays", ctab_arrays, ctab_arrays_expected,
            sizeof(ctab_arrays_expected)/sizeof(*ctab_arrays_expected));
    test_constant_table("test_default_values", ctab_with_default_values, ctab_with_default_values_expected,
            sizeof(ctab_with_default_values_expected)/sizeof(*ctab_with_default_values_expected));
    test_constant_table("test_samplers", ctab_samplers, ctab_samplers_expected,
            sizeof(ctab_samplers_expected)/sizeof(*ctab_samplers_expected));
}

static void test_setting_basic_table(IDirect3DDevice9 *device)
{
    static const D3DXMATRIX mvp = {{{
        0.514f, 0.626f, 0.804f, 0.786f,
        0.238f, 0.956f, 0.374f, 0.483f,
        0.109f, 0.586f, 0.900f, 0.255f,
        0.898f, 0.411f, 0.932f, 0.275f}}};
    static const D3DXVECTOR4 f4 = {0.350f, 0.526f, 0.925f, 0.021f};
    static const float f = 0.12543f;
    static const int i = 321;
    static const D3DXMATRIX *matrix_pointer[] = {&mvp};

    ID3DXConstantTable *ctable;

    HRESULT res;
    float out[16];
    ULONG refcnt;

    /* Get the constant table from the shader itself */
    res = D3DXGetShaderConstantTable(ctab_basic, &ctable);
    ok(res == D3D_OK, "D3DXGetShaderConstantTable failed: got 0x%08x\n", res);

    /* Set constants */
    res = ID3DXConstantTable_SetMatrix(ctable, device, "mvp", &mvp);
    ok(res == D3D_OK, "ID3DXConstantTable_SetMatrix failed on variable mvp: got 0x%08x\n", res);

    res = ID3DXConstantTable_SetInt(ctable, device, "i", i + 1);
    ok(res == D3D_OK, "ID3DXConstantTable_SetInt failed on variable i: got 0x%08x\n", res);

    /* Check that setting i again will overwrite the previous value */
    res = ID3DXConstantTable_SetInt(ctable, device, "i", i);
    ok(res == D3D_OK, "ID3DXConstantTable_SetInt failed on variable i: got 0x%08x\n", res);

    res = ID3DXConstantTable_SetFloat(ctable, device, "f", f);
    ok(res == D3D_OK, "ID3DXConstantTable_SetFloat failed on variable f: got 0x%08x\n", res);

    res = ID3DXConstantTable_SetVector(ctable, device, "f4", &f4);
    ok(res == D3D_OK, "ID3DXConstantTable_SetVector failed on variable f4: got 0x%08x\n", res);

    /* Get constants back and validate */
    IDirect3DDevice9_GetVertexShaderConstantF(device, 0, out, 4);
    ok(out[0] == S(U(mvp))._11 && out[4] == S(U(mvp))._12 && out[8] == S(U(mvp))._13 && out[12] == S(U(mvp))._14,
            "The first row of mvp was not set correctly, got {%f, %f, %f, %f}, should be {%f, %f, %f, %f}\n",
            out[0], out[4], out[8], out[12], S(U(mvp))._11, S(U(mvp))._12, S(U(mvp))._13, S(U(mvp))._14);
    ok(out[1] == S(U(mvp))._21 && out[5] == S(U(mvp))._22 && out[9] == S(U(mvp))._23 && out[13] == S(U(mvp))._24,
            "The second row of mvp was not set correctly, got {%f, %f, %f, %f}, should be {%f, %f, %f, %f}\n",
            out[1], out[5], out[9], out[13], S(U(mvp))._21, S(U(mvp))._22, S(U(mvp))._23, S(U(mvp))._24);
    ok(out[2] == S(U(mvp))._31 && out[6] == S(U(mvp))._32 && out[10] == S(U(mvp))._33 && out[14] == S(U(mvp))._34,
            "The third row of mvp was not set correctly, got {%f, %f, %f, %f}, should be {%f, %f, %f, %f}\n",
            out[2], out[6], out[10], out[14], S(U(mvp))._31, S(U(mvp))._32, S(U(mvp))._33, S(U(mvp))._34);
    ok(out[3] == S(U(mvp))._41 && out[7] == S(U(mvp))._42 && out[11] == S(U(mvp))._43 && out[15] == S(U(mvp))._44,
            "The fourth row of mvp was not set correctly, got {%f, %f, %f, %f}, should be {%f, %f, %f, %f}\n",
            out[3], out[7], out[11], out[15], S(U(mvp))._41, S(U(mvp))._42, S(U(mvp))._43, S(U(mvp))._44);

    IDirect3DDevice9_GetVertexShaderConstantF(device, 4, out, 1);
    ok(out[0] == (float)i && out[1] == 0.0f && out[2] == 0.0f && out[3] == 0.0f,
            "The variable i was not set correctly, out={%f, %f, %f, %f}, should be {%d, 0.0, 0.0, 0.0}\n",
            out[0], out[1], out[2], out[3], i);

    IDirect3DDevice9_GetVertexShaderConstantF(device, 6, out, 1);
    ok(out[0] == f && out[1] == 0.0f && out[2] == 0.0f && out[3] == 0.0f,
            "The variable f was not set correctly, out={%f, %f, %f, %f}, should be {%f, 0.0, 0.0, 0.0}\n",
            out[0], out[1], out[2], out[3], f);

    IDirect3DDevice9_GetVertexShaderConstantF(device, 7, out, 1);
    ok(memcmp(out, &f4, sizeof(f4)) == 0,
            "The variable f4 was not set correctly, out={%f, %f, %f, %f}, should be {%f, %f, %f, %f}\n",
            out[0], out[1], out[2], out[3], f4.x, f4.y, f4.z, f4.w);

    /* Finally test using a set* function for one type to set a variable of another type (should succeed) */
    res = ID3DXConstantTable_SetVector(ctable, device, "f", &f4);
    ok(res == D3D_OK, "ID3DXConstantTable_SetVector failed on variable f: 0x%08x\n", res);

    IDirect3DDevice9_GetVertexShaderConstantF(device, 6, out, 1);
    ok(out[0] == f4.x && out[1] == 0.0f && out[2] == 0.0f && out[3] == 0.0f,
            "The variable f was not set correctly by ID3DXConstantTable_SetVector, got %f, should be %f\n",
            out[0], f4.x);

    memset(out, 0, sizeof(out));
    IDirect3DDevice9_SetVertexShaderConstantF(device, 6, out, 1);
    res = ID3DXConstantTable_SetMatrix(ctable, device, "f", &mvp);
    ok(res == D3D_OK, "ID3DXConstantTable_SetMatrix failed on variable f: 0x%08x\n", res);

    IDirect3DDevice9_GetVertexShaderConstantF(device, 6, out, 1);
    ok(out[0] == S(U(mvp))._11 && out[1] == 0.0f && out[2] == 0.0f && out[3] == 0.0f,
            "The variable f was not set correctly by ID3DXConstantTable_SetMatrix, got %f, should be %f\n",
            out[0], S(U(mvp))._11);

    /* Clear registers */
    memset(out, 0, sizeof(out));
    IDirect3DDevice9_SetVertexShaderConstantF(device, 0, out, 4);
    IDirect3DDevice9_SetVertexShaderConstantF(device, 6, out, 1);
    IDirect3DDevice9_SetVertexShaderConstantF(device, 7, out, 1);

    /* SetVector shouldn't change the value of a matrix constant */
    res = ID3DXConstantTable_SetVector(ctable, device, "mvp", &f4);
    ok(res == D3D_OK, "ID3DXConstantTable_SetVector failed on variable f: 0x%08x\n", res);

    IDirect3DDevice9_GetVertexShaderConstantF(device, 0, out, 4);
    ok(out[0] == 0.0f && out[1] == 0.0f && out[2] == 0.0f && out[3] == 0.0f
            && out[4] == 0.0f && out[5] == 0.0f && out[6] == 0.0f && out[7] == 0.0f
            && out[8] == 0.0f && out[9] == 0.0f && out[10] == 0.0f && out[11] == 0.0f
            && out[12] == 0.0f && out[13] == 0.0f && out[14] == 0.0f && out[15] == 0.0f,
            "The variable mvp was not set correctly by ID3DXConstantTable_SetVector, "
            "got {%f, %f, %f, %f; %f, %f, %f, %f; %f, %f, %f %f; %f, %f, %f, %f}, "
            "should be all 0.0f\n",
            out[0], out[1], out[2], out[3],
            out[4], out[5], out[6], out[7],
            out[8], out[9], out[10], out[11],
            out[12], out[13], out[14], out[15]);

    res = ID3DXConstantTable_SetFloat(ctable, device, "mvp", f);
    ok(res == D3D_OK, "ID3DXConstantTable_SetFloat failed on variable mvp: 0x%08x\n", res);

    IDirect3DDevice9_GetVertexShaderConstantF(device, 0, out, 4);
    ok(out[0] == 0.0f && out[1] == 0.0f && out[2] == 0.0f && out[3] == 0.0f
            && out[4] == 0.0f && out[5] == 0.0f && out[6] == 0.0f && out[7] == 0.0f
            && out[8] == 0.0f && out[9] == 0.0f && out[10] == 0.0f && out[11] == 0.0f
            && out[12] == 0.0f && out[13] == 0.0f && out[14] == 0.0f && out[15] == 0.0f,
            "The variable mvp was not set correctly by ID3DXConstantTable_SetFloat, "
            "got {%f, %f, %f, %f; %f, %f, %f, %f; %f, %f, %f %f; %f, %f, %f, %f}, "
            "should be all 0.0f\n",
            out[0], out[1], out[2], out[3],
            out[4], out[5], out[6], out[7],
            out[8], out[9], out[10], out[11],
            out[12], out[13], out[14], out[15]);

    res = ID3DXConstantTable_SetFloat(ctable, device, "f4", f);
    ok(res == D3D_OK, "ID3DXConstantTable_SetFloat failed on variable f4: 0x%08x\n", res);

    IDirect3DDevice9_GetVertexShaderConstantF(device, 7, out, 1);
    ok(out[0] == 0.0f && out[1] == 0.0f && out[2] == 0.0f && out[3] == 0.0f,
            "The variable f4 was not set correctly by ID3DXConstantTable_SetFloat, "
            "got {%f, %f, %f, %f}, should be all 0.0f\n",
            out[0], out[1], out[2], out[3]);

    res = ID3DXConstantTable_SetMatrixTranspose(ctable, device, "f", &mvp);
    ok(res == D3D_OK, "ID3DXConstantTable_SetMatrixTranspose failed on variable f: 0x%08x\n", res);

    IDirect3DDevice9_GetVertexShaderConstantF(device, 6, out, 1);
    ok(out[0] == S(U(mvp))._11 && out[1] == 0.0f && out[2] == 0.0f && out[3] == 0.0f,
            "The variable f was not set correctly by ID3DXConstantTable_SetMatrixTranspose, got %f, should be %f\n",
            out[0], S(U(mvp))._11);

    res = ID3DXConstantTable_SetMatrixTranspose(ctable, device, "f4", &mvp);
    ok(res == D3D_OK, "ID3DXConstantTable_SetMatrixTranspose failed on variable f4: 0x%08x\n", res);

    IDirect3DDevice9_GetVertexShaderConstantF(device, 7, out, 1);
    ok(out[0] == S(U(mvp))._11 && out[1] == S(U(mvp))._21 && out[2] == S(U(mvp))._31 && out[3] == S(U(mvp))._41,
            "The variable f4 was not set correctly by ID3DXConstantTable_SetMatrixTranspose, "
            "got {%f, %f, %f, %f}, should be {%f, %f, %f, %f}\n",
            out[0], out[1], out[2], out[3],
            S(U(mvp))._11, S(U(mvp))._21, S(U(mvp))._31, S(U(mvp))._41);

    memset(out, 0, sizeof(out));
    IDirect3DDevice9_SetVertexShaderConstantF(device, 6, out, 1);
    res = ID3DXConstantTable_SetMatrixPointerArray(ctable, device, "f", matrix_pointer, 1);
    ok(res == D3D_OK, "ID3DXConstantTable_SetMatrixPointerArray failed on variable f: got %#x\n", res);

    IDirect3DDevice9_GetVertexShaderConstantF(device, 6, out, 1);
    ok(out[0] == S(U(mvp))._11 && out[1] == 0.0f && out[2] == 0.0f && out[3] == 0.0f,
            "The variable f was not set correctly by ID3DXConstantTable_SetMatrixPointerArray, "
            "got %f, should be %f\n",
            out[0], S(U(mvp))._11);

    res = ID3DXConstantTable_SetMatrixPointerArray(ctable, device, "f4", matrix_pointer, 1);
    ok(res == D3D_OK, "ID3DXConstantTable_SetMatrixPointerArray failed on variable f4: got %#x\n", res);

    IDirect3DDevice9_GetVertexShaderConstantF(device, 7, out, 1);
    ok(out[0] == S(U(mvp))._11 && out[1] == S(U(mvp))._12 && out[2] == S(U(mvp))._13 && out[3] == S(U(mvp))._14,
            "The variable f4 was not set correctly by ID3DXConstantTable_SetMatrixPointerArray, "
            "got {%f, %f, %f, %f}, should be {%f, %f, %f, %f}\n",
            out[0], out[1], out[2], out[3],
            S(U(mvp))._11, S(U(mvp))._12, S(U(mvp))._13, S(U(mvp))._14);

    memset(out, 0, sizeof(out));
    IDirect3DDevice9_SetVertexShaderConstantF(device, 6, out, 1);
    res = ID3DXConstantTable_SetMatrixTransposePointerArray(ctable, device, "f", matrix_pointer, 1);
    ok(res == D3D_OK, "ID3DXConstantTable_SetMatrixTransposePointerArray failed on variable f: got %#x\n", res);

    IDirect3DDevice9_GetVertexShaderConstantF(device, 6, out, 1);
    ok(out[0] == S(U(mvp))._11 && out[1] == 0.0f && out[2] == 0.0f && out[3] == 0.0f,
            "The variable f was not set correctly by ID3DXConstantTable_SetMatrixTransposePointerArray, "
            "got %f, should be %f\n",
            out[0], S(U(mvp))._11);

    res = ID3DXConstantTable_SetMatrixTransposePointerArray(ctable, device, "f4", matrix_pointer, 1);
    ok(res == D3D_OK, "ID3DXConstantTable_SetMatrixTransposePointerArray failed on variable f4: got %#x\n", res);

    IDirect3DDevice9_GetVertexShaderConstantF(device, 7, out, 1);
    ok(out[0] == S(U(mvp))._11 && out[1] == S(U(mvp))._21 && out[2] == S(U(mvp))._31 && out[3] == S(U(mvp))._41,
            "The variable f4 was not set correctly by ID3DXConstantTable_SetMatrixTransposePointerArray, "
            "got {%f, %f, %f, %f}, should be {%f, %f, %f, %f}\n",
            out[0], out[1], out[2], out[3],
            S(U(mvp))._11, S(U(mvp))._21, S(U(mvp))._31, S(U(mvp))._41);

    refcnt = ID3DXConstantTable_Release(ctable);
    ok(refcnt == 0, "The constant table reference count was %u, should be 0\n", refcnt);
}

static void test_setting_matrices_table(IDirect3DDevice9 *device)
{
    static const D3DXMATRIX fmatrix =
        {{{2.001f, 1.502f, 9.003f, 1.004f,
           5.005f, 3.006f, 3.007f, 6.008f,
           9.009f, 5.010f, 7.011f, 1.012f,
           5.013f, 5.014f, 5.015f, 9.016f}}};
    static const D3DXMATRIX *matrix_pointer[] = {&fmatrix};

    ID3DXConstantTable *ctable;

    HRESULT res;
    float out[32];

    res = D3DXGetShaderConstantTable(ctab_matrices, &ctable);
    ok(res == D3D_OK, "D3DXGetShaderConstantTable failed: got %#x\n", res);

    res = ID3DXConstantTable_SetMatrix(ctable, device, "imatrix2x3", &fmatrix);
    ok(res == D3D_OK, "ID3DXConstantTable_SetMatrix failed on variable imatrix2x3: got %#x\n", res);

    res = ID3DXConstantTable_SetMatrix(ctable, device, "fmatrix3x1", &fmatrix);
    ok(res == D3D_OK, "ID3DXConstantTable_SetMatrix failed on variable fmatrix3x1: got %#x\n", res);

    IDirect3DDevice9_GetVertexShaderConstantF(device, 4, out, 2);
    todo_wine ok(out[0] == (int)S(U(fmatrix))._11 && out[1] == (int)S(U(fmatrix))._12 && out[2] == (int)S(U(fmatrix))._13
            && out[3] == 0
            && out[4] == (int)S(U(fmatrix))._21 && out[5] == (int)S(U(fmatrix))._22 && out[6] == (int)S(U(fmatrix))._23
            && out[7] == 0,
            "The variable imatrix2x3 was not set correctly, out={%f, %f, %f, %f; %f, %f, %f, %f}, "
            "should be {%d, %d, %d, %d; %d, %d, %d, %d}\n",
            out[0], out[1], out[2], out[3], out[4], out[5], out[6], out[7],
            (int)S(U(fmatrix))._11, (int)S(U(fmatrix))._12, (int)S(U(fmatrix))._13, 0,
            (int)S(U(fmatrix))._21, (int)S(U(fmatrix))._22, (int)S(U(fmatrix))._23, 0);

    IDirect3DDevice9_GetVertexShaderConstantF(device, 7, out, 1);
    ok(out[0] == S(U(fmatrix))._11 && out[1] == S(U(fmatrix))._21 && out[2] == S(U(fmatrix))._31 && out[3] == 0.0f,
            "The variable fmatrix3x1 was not set correctly, out={%f, %f, %f, %f}, should be {%f, %f, %f, %f}\n",
            out[0], out[1], out[2], out[3],
            S(U(fmatrix))._11, S(U(fmatrix))._21, S(U(fmatrix))._31, 0.0f);

    ID3DXConstantTable_Release(ctable);

    res = D3DXGetShaderConstantTable(ctab_matrices2, &ctable);
    ok(res == D3D_OK, "D3DXGetShaderConstantTable failed: got %#x\n", res);

    /* SetMatrix */
    res = ID3DXConstantTable_SetMatrix(ctable, device, "c2x3", &fmatrix);
    ok(res == D3D_OK, "ID3DXConstantTable_SetMatrix failed on variable c2x3: got %#x\n", res);

    res = ID3DXConstantTable_SetMatrix(ctable, device, "r2x3", &fmatrix);
    ok(res == D3D_OK, "ID3DXConstantTable_SetMatrix failed on variable r2x3: got %#x\n", res);

    res = ID3DXConstantTable_SetMatrix(ctable, device, "c3x2", &fmatrix);
    ok(res == D3D_OK, "ID3DXConstantTable_SetMatrix failed on variable c3x2: got %#x\n", res);

    res = ID3DXConstantTable_SetMatrix(ctable, device, "r3x2", &fmatrix);
    ok(res == D3D_OK, "ID3DXConstantTable_SetMatrix failed on variable r3x2: got %#x\n", res);

    res = ID3DXConstantTable_SetMatrix(ctable, device, "c3x3", &fmatrix);
    ok(res == D3D_OK, "ID3DXConstantTable_SetMatrix failed on variable c3x3: got %#x\n", res);

    IDirect3DDevice9_GetVertexShaderConstantF(device, 7, out, 3);
    ok(out[0] == S(U(fmatrix))._11 && out[1] == S(U(fmatrix))._21 && out[2] == 0.0f && out[3] == 0.0f
            && out[4] == S(U(fmatrix))._12 && out[5] == S(U(fmatrix))._22 && out[6] == 0.0f && out[7] == 0.0f
            && out[8] == S(U(fmatrix))._13 && out[9] == S(U(fmatrix))._23 && out[10] == 0.0f && out[11] == 0.0f,
            "The variable c2x3 was not set correctly, out={%f, %f, %f, %f; %f, %f, %f, %f; %f, %f, %f, %f}, "
            "should be {%f, %f, %f, %f; %f, %f, %f, %f; %f, %f, %f, %f}\n",
            out[0], out[1], out[2], out[3],
            out[4], out[5], out[6], out[7],
            out[8], out[9], out[10], out[11],
            S(U(fmatrix))._11, S(U(fmatrix))._21, 0.0f, 0.0f,
            S(U(fmatrix))._12, S(U(fmatrix))._22, 0.0f, 0.0f,
            S(U(fmatrix))._13, S(U(fmatrix))._23, 0.0f, 0.0f);

    res = ID3DXConstantTable_SetMatrix(ctable, device, "r4x4", &fmatrix);
    ok(res == D3D_OK, "ID3DXConstantTable_SetMatrix failed on variable r4x4: got %#x\n", res);

    IDirect3DDevice9_GetVertexShaderConstantF(device, 15, out, 2);
    ok(out[0] == S(U(fmatrix))._11 && out[1] == S(U(fmatrix))._12 && out[2] == S(U(fmatrix))._13 && out[3] == 0.0f
            && out[4] == S(U(fmatrix))._21 && out[5] == S(U(fmatrix))._22 && out[6] == S(U(fmatrix))._23 && out[7] == 0.0f,
            "The variable r2x3 was not set correctly, out={%f, %f, %f, %f; %f, %f, %f, %f}, "
            "should be {%f, %f, %f, %f; %f, %f, %f, %f}\n",
            out[0], out[1], out[2], out[3], out[4], out[5], out[6], out[7],
            S(U(fmatrix))._11, S(U(fmatrix))._12, S(U(fmatrix))._13, 0.0f,
            S(U(fmatrix))._21, S(U(fmatrix))._22, S(U(fmatrix))._23, 0.0f);

    IDirect3DDevice9_GetVertexShaderConstantF(device, 13, out, 2);
    ok(out[0] == S(U(fmatrix))._11 && out[1] == S(U(fmatrix))._21 && out[2] == S(U(fmatrix))._31 && out[3] == 0.0f
            && out[4] == S(U(fmatrix))._12 && out[5] == S(U(fmatrix))._22 && out[6] == S(U(fmatrix))._32 && out[7] == 0.0f,
            "The variable c3x2 was not set correctly, out={%f, %f, %f, %f; %f, %f, %f, %f}, "
            "should be {%f, %f, %f, %f; %f, %f, %f, %f}\n",
            out[0], out[1], out[2], out[3], out[4], out[5], out[6], out[7],
            S(U(fmatrix))._11, S(U(fmatrix))._21, S(U(fmatrix))._31, 0.0f,
            S(U(fmatrix))._12, S(U(fmatrix))._22, S(U(fmatrix))._32, 0.0f);

    IDirect3DDevice9_GetVertexShaderConstantF(device, 4, out, 3);
    ok(out[0] == S(U(fmatrix))._11 && out[1] == S(U(fmatrix))._12 && out[2] == 0.0f && out[3] == 0.0f
            && out[4] == S(U(fmatrix))._21 && out[5] == S(U(fmatrix))._22 && out[6] == 0.0f && out[7] == 0.0f
            && out[8] == S(U(fmatrix))._31 && out[9] == S(U(fmatrix))._32 && out[10] == 0.0f && out[11] == 0.0f,
            "The variable r3x2 was not set correctly, out={%f, %f, %f, %f; %f, %f, %f, %f; %f, %f, %f, %f}, "
            "should be {%f, %f, %f, %f; %f, %f, %f, %f; %f, %f, %f, %f}\n",
            out[0], out[1], out[2], out[3], out[4], out[5], out[6], out[7], out[8], out[9], out[10], out[11],
            S(U(fmatrix))._11, S(U(fmatrix))._12, 0.0f, 0.0f,
            S(U(fmatrix))._21, S(U(fmatrix))._22, 0.0f, 0.0f,
            S(U(fmatrix))._31, S(U(fmatrix))._32, 0.0f, 0.0f);

    IDirect3DDevice9_GetVertexShaderConstantF(device, 10, out, 3);
    ok(out[0] == S(U(fmatrix))._11 && out[1] == S(U(fmatrix))._21 && out[2] == S(U(fmatrix))._31 && out[3] == 0.0f
            && out[4] == S(U(fmatrix))._12 && out[5] == S(U(fmatrix))._22 && out[6] == S(U(fmatrix))._32 && out[7] == 0.0f
            && out[8] == S(U(fmatrix))._13 && out[9] == S(U(fmatrix))._23 && out[10] == S(U(fmatrix))._33 && out[11] == 0.0f,
            "The variable c3x3 was not set correctly, out={%f, %f, %f, %f; %f, %f, %f, %f; %f, %f, %f, %f}, "
            "should be {%f, %f, %f, %f; %f, %f, %f, %f; %f, %f, %f, %f}\n",
            out[0], out[1], out[2], out[3], out[4], out[5], out[6], out[7], out[8], out[9], out[10], out[11],
            S(U(fmatrix))._11, S(U(fmatrix))._21, S(U(fmatrix))._31, 0.0f,
            S(U(fmatrix))._12, S(U(fmatrix))._22, S(U(fmatrix))._32, 0.0f,
            S(U(fmatrix))._13, S(U(fmatrix))._23, S(U(fmatrix))._33, 0.0f);

    IDirect3DDevice9_GetVertexShaderConstantF(device, 0, out, 4);
    ok(out[0] == S(U(fmatrix))._11 && out[1] == S(U(fmatrix))._12 && out[2] == S(U(fmatrix))._13 && out[3] == S(U(fmatrix))._14
            && out[4] == S(U(fmatrix))._21 && out[5] == S(U(fmatrix))._22 && out[6] == S(U(fmatrix))._23 && out[7] == S(U(fmatrix))._24
            && out[8] == S(U(fmatrix))._31 && out[9] == S(U(fmatrix))._32 && out[10] == S(U(fmatrix))._33 && out[11] == S(U(fmatrix))._34
            && out[12] == S(U(fmatrix))._41 && out[13] == S(U(fmatrix))._42 && out[14] == S(U(fmatrix))._43 && out[15] == S(U(fmatrix))._44,
            "The variable r4x4 was not set correctly, out={%f, %f, %f, %f; %f, %f, %f, %f; %f, %f, %f, %f; %f, %f, %f, %f}, "
            "should be {%f, %f, %f, %f; %f, %f, %f, %f; %f, %f, %f, %f; %f, %f, %f, %f}\n",
            out[0], out[1], out[2], out[3], out[4], out[5], out[6], out[7],
            out[8], out[9], out[10], out[11], out[12], out[13], out[14], out[15],
            S(U(fmatrix))._11, S(U(fmatrix))._12, S(U(fmatrix))._13, S(U(fmatrix))._14,
            S(U(fmatrix))._21, S(U(fmatrix))._22, S(U(fmatrix))._23, S(U(fmatrix))._24,
            S(U(fmatrix))._31, S(U(fmatrix))._32, S(U(fmatrix))._33, S(U(fmatrix))._34,
            S(U(fmatrix))._41, S(U(fmatrix))._42, S(U(fmatrix))._43, S(U(fmatrix))._44);

    /* SetMatrixTranspose */
    res = ID3DXConstantTable_SetMatrixTranspose(ctable, device, "c2x3", &fmatrix);
    ok(res == D3D_OK, "ID3DXConstantTable_SetMatrixTranspose failed on variable c2x3: got %#x\n", res);

    res = ID3DXConstantTable_SetMatrixTranspose(ctable, device, "r2x3", &fmatrix);
    ok(res == D3D_OK, "ID3DXConstantTable_SetMatrixTranspose failed on variable r2x3: got %#x\n", res);

    IDirect3DDevice9_GetVertexShaderConstantF(device, 7, out, 3);
    ok(out[0] == S(U(fmatrix))._11 && out[1] == S(U(fmatrix))._12 && out[2] == 0.0f && out[3] == 0.0f
            && out[4] == S(U(fmatrix))._21 && out[5] == S(U(fmatrix))._22 && out[6] == 0.0f && out[7] == 0.0f
            && out[8] == S(U(fmatrix))._31 && out[9] == S(U(fmatrix))._32 && out[10] == 0.0f && out[11] == 0.0f,
            "The variable c2x3 was not set correctly, out={%f, %f, %f, %f; %f, %f, %f, %f; %f, %f, %f, %f}, "
            "should be {%f, %f, %f, %f; %f, %f, %f, %f; %f, %f, %f, %f}\n",
            out[0], out[1], out[2], out[3],
            out[4], out[5], out[6], out[7],
            out[8], out[9], out[10], out[11],
            S(U(fmatrix))._11, S(U(fmatrix))._12, 0.0f, 0.0f,
            S(U(fmatrix))._21, S(U(fmatrix))._22, 0.0f, 0.0f,
            S(U(fmatrix))._31, S(U(fmatrix))._32, 0.0f, 0.0f);

    IDirect3DDevice9_GetVertexShaderConstantF(device, 15, out, 2);
    ok(out[0] == S(U(fmatrix))._11 && out[1] == S(U(fmatrix))._21 && out[2] == S(U(fmatrix))._31 && out[3] == 0.0f
            && out[4] == S(U(fmatrix))._12 && out[5] == S(U(fmatrix))._22 && out[6] == S(U(fmatrix))._32 && out[7] == 0.0f,
            "The variable r2x3 was not set correctly, out={%f, %f, %f, %f; %f, %f, %f, %f}, "
            "should be {%f, %f, %f, %f; %f, %f, %f, %f}\n",
            out[0], out[1], out[2], out[3], out[4], out[5], out[6], out[7],
            S(U(fmatrix))._11, S(U(fmatrix))._21, S(U(fmatrix))._31, 0.0f,
            S(U(fmatrix))._12, S(U(fmatrix))._22, S(U(fmatrix))._32, 0.0f);

    /* SetMatrixPointerArray */
    res = ID3DXConstantTable_SetMatrixPointerArray(ctable, device, "c2x3", matrix_pointer, 1);
    ok(res == D3D_OK, "ID3DXConstantTable_SetMatrixPointerArray failed on variable c2x3: got %#x\n", res);

    res = ID3DXConstantTable_SetMatrixPointerArray(ctable, device, "r2x3", matrix_pointer, 1);
    ok(res == D3D_OK, "ID3DXConstantTable_SetMatrixPointerArray failed on variable r2x3: got %#x\n", res);

    IDirect3DDevice9_GetVertexShaderConstantF(device, 7, out, 3);
    ok(out[0] == S(U(fmatrix))._11 && out[1] == S(U(fmatrix))._21 && out[2] == 0.0f && out[3] == 0.0f
            && out[4] == S(U(fmatrix))._12 && out[5] == S(U(fmatrix))._22 && out[6] == 0.0f && out[7] == 0.0f
            && out[8] == S(U(fmatrix))._13 && out[9] == S(U(fmatrix))._23 && out[10] == 0.0f && out[11] == 0.0f,
            "The variable c2x3 was not set correctly, out={%f, %f, %f, %f; %f, %f, %f, %f; %f, %f, %f, %f}, "
            "should be {%f, %f, %f, %f; %f, %f, %f, %f; %f, %f, %f, %f}\n",
            out[0], out[1], out[2], out[3],
            out[4], out[5], out[6], out[7],
            out[8], out[9], out[10], out[11],
            S(U(fmatrix))._11, S(U(fmatrix))._21, 0.0f, 0.0f,
            S(U(fmatrix))._12, S(U(fmatrix))._22, 0.0f, 0.0f,
            S(U(fmatrix))._13, S(U(fmatrix))._23, 0.0f, 0.0f);

    IDirect3DDevice9_GetVertexShaderConstantF(device, 15, out, 2);
    ok(out[0] == S(U(fmatrix))._11 && out[1] == S(U(fmatrix))._12 && out[2] == S(U(fmatrix))._13 && out[3] == 0.0f
            && out[4] == S(U(fmatrix))._21 && out[5] == S(U(fmatrix))._22 && out[6] == S(U(fmatrix))._23 && out[7] == 0.0f,
            "The variable r2x3 was not set correctly, out={%f, %f, %f, %f; %f, %f, %f, %f}, "
            "should be {%f, %f, %f, %f; %f, %f, %f, %f}\n",
            out[0], out[1], out[2], out[3], out[4], out[5], out[6], out[7],
            S(U(fmatrix))._11, S(U(fmatrix))._12, S(U(fmatrix))._13, 0.0f,
            S(U(fmatrix))._21, S(U(fmatrix))._22, S(U(fmatrix))._23, 0.0f);

    /* SetMatrixTransposePointerArray */
    res = ID3DXConstantTable_SetMatrixTransposePointerArray(ctable, device, "c2x3", matrix_pointer, 1);
    ok(res == D3D_OK, "ID3DXConstantTable_SetMatrixTransposePointerArray failed on variable c2x3: got %#x\n", res);

    res = ID3DXConstantTable_SetMatrixTransposePointerArray(ctable, device, "r2x3", matrix_pointer, 1);
    ok(res == D3D_OK, "ID3DXConstantTable_SetMatrixTransposePointerArray failed on variable r2x3: got %#x\n", res);

    IDirect3DDevice9_GetVertexShaderConstantF(device, 7, out, 3);
    ok(out[0] == S(U(fmatrix))._11 && out[1] == S(U(fmatrix))._12 && out[2] == 0.0f && out[3] == 0.0f
            && out[4] == S(U(fmatrix))._21 && out[5] == S(U(fmatrix))._22 && out[6] == 0.0f && out[7] == 0.0f
            && out[8] == S(U(fmatrix))._31 && out[9] == S(U(fmatrix))._32 && out[10] == 0.0f && out[11] == 0.0f,
            "The variable c2x3 was not set correctly, out={%f, %f, %f, %f; %f, %f, %f, %f; %f, %f, %f, %f}, "
            "should be {%f, %f, %f, %f; %f, %f, %f, %f; %f, %f, %f, %f}\n",
            out[0], out[1], out[2], out[3],
            out[4], out[5], out[6], out[7],
            out[8], out[9], out[10], out[11],
            S(U(fmatrix))._11, S(U(fmatrix))._12, 0.0f, 0.0f,
            S(U(fmatrix))._21, S(U(fmatrix))._22, 0.0f, 0.0f,
            S(U(fmatrix))._31, S(U(fmatrix))._32, 0.0f, 0.0f);

    IDirect3DDevice9_GetVertexShaderConstantF(device, 15, out, 2);
    ok(out[0] == S(U(fmatrix))._11 && out[1] == S(U(fmatrix))._21 && out[2] == S(U(fmatrix))._31 && out[3] == 0.0f
            && out[4] == S(U(fmatrix))._12 && out[5] == S(U(fmatrix))._22 && out[6] == S(U(fmatrix))._32 && out[7] == 0.0f,
            "The variable r2x3 was not set correctly, out={%f, %f, %f, %f; %f, %f, %f, %f}, "
            "should be {%f, %f, %f, %f; %f, %f, %f, %f}\n",
            out[0], out[1], out[2], out[3], out[4], out[5], out[6], out[7],
            S(U(fmatrix))._11, S(U(fmatrix))._21, S(U(fmatrix))._31, 0.0f,
            S(U(fmatrix))._12, S(U(fmatrix))._22, S(U(fmatrix))._32, 0.0f);

    ID3DXConstantTable_Release(ctable);
}

static void test_setting_arrays_table(IDirect3DDevice9 *device)
{
    static const float farray[8] = {
        0.005f, 0.745f, 0.973f, 0.264f,
        0.010f, 0.020f, 0.030f, 0.040f};
    static const D3DXMATRIX fmtxarray[2] = {
        {{{0.001f, 0.002f, 0.003f, 0.004f,
           0.005f, 0.006f, 0.007f, 0.008f,
           0.009f, 0.010f, 0.011f, 0.012f,
           0.013f, 0.014f, 0.015f, 0.016f}}},
        {{{0.010f, 0.020f, 0.030f, 0.040f,
           0.050f, 0.060f, 0.070f, 0.080f,
           0.090f, 0.100f, 0.110f, 0.120f,
           0.130f, 0.140f, 0.150f, 0.160f}}}};
    static const int iarray[4] = {1, 2, 3, 4};
    static const D3DXVECTOR4 fvecarray[2] = {
        {0.745f, 0.997f, 0.353f, 0.237f},
        {0.060f, 0.455f, 0.333f, 0.983f}};
    static BOOL barray[4] = {FALSE, 100, TRUE, TRUE};

    ID3DXConstantTable *ctable;

    HRESULT res;
    float out[32];
    ULONG refcnt;

    /* Clear registers */
    memset(out, 0, sizeof(out));
    IDirect3DDevice9_SetVertexShaderConstantF(device,  8, out, 4);
    IDirect3DDevice9_SetVertexShaderConstantF(device, 12, out, 4);

    /* Get the constant table from the shader */
    res = D3DXGetShaderConstantTable(ctab_arrays, &ctable);
    ok(res == D3D_OK, "D3DXGetShaderConstantTable failed: got 0x%08x\n", res);

    /* Set constants */

    /* Make sure that we cannot set registers that do not belong to this constant */
    res = ID3DXConstantTable_SetFloatArray(ctable, device, "farray", farray, 8);
    ok(res == D3D_OK, "ID3DXConstantTable_SetFloatArray failed: got 0x%08x\n", res);

    IDirect3DDevice9_GetVertexShaderConstantF(device, 8, out, 8);
    ok(out[0] == farray[0] && out[4] == farray[1] && out[8] == farray[2] && out[12] == farray[3],
            "The in-bounds elements of the array were not set, out={%f, %f, %f, %f}, should be {%f, %f, %f, %f}\n",
            out[0], out[4], out[8], out[12], farray[0], farray[1], farray[2], farray[3]);
    ok(out[16] == 0.0f && out[20] == 0.0f && out[24] == 0.0f && out[28] == 0.0f,
            "The excess elements of the array were set, out={%f, %f, %f, %f}, should be all 0.0f\n",
            out[16], out[20], out[24], out[28]);

    /* ivecarray takes up only 1 register, but a matrix takes up 4, so no elements should be set */
    res = ID3DXConstantTable_SetMatrix(ctable, device, "ivecarray", &fmtxarray[0]);
    ok(res == D3D_OK, "ID3DXConstantTable_SetMatrix failed: got 0x%08x\n", res);

    IDirect3DDevice9_GetVertexShaderConstantF(device, 18, out, 4);
    ok(out[0] == 0.0f && out[1] == 0.0f && out[2] == 0.0f && out[3] == 0.0f,
       "The array was set, out={%f, %f, %f, %f}, should be all 0.0f\n", out[0], out[1], out[2], out[3]);

    /* Try setting an integer array to an array declared as a float array */
    res = ID3DXConstantTable_SetIntArray(ctable, device, "farray", iarray, 4);
    ok(res == D3D_OK, "ID3DXConstantTable_SetIntArray failed: got 0x%08x\n", res);

    IDirect3DDevice9_GetVertexShaderConstantF(device, 8, out, 4);
    ok(out[0] == iarray[0] && out[4] == iarray[1] && out[8] == iarray[2] && out[12] == iarray[3],
           "SetIntArray did not properly set a float array: out={%f, %f, %f, %f}, should be {%d, %d, %d, %d}\n",
            out[0], out[4], out[8], out[12], iarray[0], iarray[1], iarray[2], iarray[3]);

    res = ID3DXConstantTable_SetFloatArray(ctable, device, "farray", farray, 4);
    ok(res == D3D_OK, "ID3DXConstantTable_SetFloatArray failed: got x0%08x\n", res);

    res = ID3DXConstantTable_SetVectorArray(ctable, device, "fvecarray", fvecarray, 2);
    ok(res == D3D_OK, "ID3DXConstantTable_SetVectorArray failed: got 0x%08x\n", res);

    res = ID3DXConstantTable_SetMatrixArray(ctable, device, "fmtxarray", fmtxarray, 2);
    ok(res == D3D_OK, "ID3DXConstantTable_SetMatrixArray failed: got 0x%08x\n", res);

    res = ID3DXConstantTable_SetBoolArray(ctable, device, "barray", barray, 2);
    ok(res == D3D_OK, "ID3DXConstantTable_SetBoolArray failed: got 0x%08x\n", res);

    /* Read back constants */
    IDirect3DDevice9_GetVertexShaderConstantF(device, 8, out, 4);
    ok(out[0] == farray[0] && out[4] == farray[1] && out[8] == farray[2] && out[12] == farray[3],
            "The variable farray was not set correctly, out={%f, %f, %f, %f}, should be {%f, %f, %f, %f}\n",
            out[0], out[4], out[8], out[12], farray[0], farray[1], farray[2], farray[3]);

    IDirect3DDevice9_GetVertexShaderConstantF(device, 12, out, 2);
    ok(out[0] == fvecarray[0].x && out[1] == fvecarray[0].y && out[2] == fvecarray[0].z && out[3] == fvecarray[0].w &&
            out[4] == fvecarray[1].x && out[5] == fvecarray[1].y && out[6] == fvecarray[1].z && out[7] == fvecarray[1].w,
            "The variable fvecarray was not set correctly, out={{%f, %f, %f, %f}, {%f, %f, %f, %f}}, should be "
            "{{%f, %f, %f, %f}, {%f, %f, %f, %f}}\n", out[0], out[1], out[2], out[3], out[4], out[5], out[6], out[7],
            fvecarray[0].x, fvecarray[0].y, fvecarray[0].z, fvecarray[0].w, fvecarray[1].x, fvecarray[1].y,
            fvecarray[1].z, fvecarray[1].w);

    IDirect3DDevice9_GetVertexShaderConstantF(device, 14, out, 2);
    ok(out[0] == 0.0f && out[1] == 0.0f && out[2] == 0.0f && out[3] == 0.0f
            && out[4] == 1.0f && out[5] == 0.0f && out[6] == 0.0f && out[7] == 0.0f,
            "The variable barray was not set correctly, out={%f, %f %f, %f; %f, %f, %f, %f}, should be {%f, %f, %f, %f; %f, %f, %f, %f}\n",
            out[0], out[1], out[2], out[3], out[4], out[5], out[6], out[7],
            0.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f);

    IDirect3DDevice9_GetVertexShaderConstantF(device, 0, out, 8);
    /* Just check a few elements in each matrix to make sure fmtxarray was set row-major */
    ok(out[0] == S(U(fmtxarray[0]))._11 && out[1] == S(U(fmtxarray[0]))._12 && out[2] == S(U(fmtxarray[0]))._13 && out[3] == S(U(fmtxarray[0]))._14,
           "The variable fmtxarray was not set row-major, out={%f, %f, %f, %f}, should be {%f, %f, %f, %f}\n",
           out[0], out[1], out[2], out[3], S(U(fmtxarray[0]))._11, S(U(fmtxarray[0]))._12, S(U(fmtxarray[0]))._13, S(U(fmtxarray[0]))._14);
    ok(out[16] == S(U(fmtxarray[1]))._11 && out[17] == S(U(fmtxarray[1]))._12 && out[18] == S(U(fmtxarray[1]))._13 && out[19] == S(U(fmtxarray[1]))._14,
           "The variable fmtxarray was not set row-major, out={%f, %f, %f, %f}, should be {%f, %f, %f, %f}\n",
           out[16], out[17], out[18], out[19], S(U(fmtxarray[1]))._11, S(U(fmtxarray[1]))._12, S(U(fmtxarray[1]))._13, S(U(fmtxarray[1]))._14);

    refcnt = ID3DXConstantTable_Release(ctable);
    ok(refcnt == 0, "The constant table reference count was %u, should be 0\n", refcnt);
}

static void test_SetDefaults(IDirect3DDevice9 *device)
{
    static const D3DXMATRIX mvp = {{{
        0.51f, 0.62f, 0.80f, 0.78f,
        0.23f, 0.95f, 0.37f, 0.48f,
        0.10f, 0.58f, 0.90f, 0.25f,
        0.89f, 0.41f, 0.93f, 0.27f}}};
    static const D3DXVECTOR4 f4 = {0.2f, 0.4f, 0.8f, 1.2f};

    float out[16];

    HRESULT res;
    ID3DXConstantTable *ctable;

    res = D3DXGetShaderConstantTable(ctab_basic, &ctable);
    ok(res == D3D_OK, "D3DXGetShaderConstantTable failed: got %08x\n", res);

    res = ID3DXConstantTable_SetVector(ctable, device, "f4", &f4);
    ok(res == D3D_OK, "ID3DXConstantTable_SetVector failed: got %08x\n", res);

    res = ID3DXConstantTable_SetMatrix(ctable, device, "mvp", &mvp);
    ok(res == D3D_OK, "ID3DXConstantTable_SetMatrix failed: got %08x\n", res);

    res = ID3DXConstantTable_SetDefaults(ctable, device);
    ok(res == D3D_OK, "ID3dXConstantTable_SetDefaults failed: got %08x\n", res);

    /* SetDefaults doesn't change constants without default values */
    IDirect3DDevice9_GetVertexShaderConstantF(device, 0, out, 4);
    ok(out[0] == S(U(mvp))._11 && out[4] == S(U(mvp))._12 && out[8] == S(U(mvp))._13 && out[12] == S(U(mvp))._14,
            "The first row of mvp was not set correctly, got {%f, %f, %f, %f}, should be {%f, %f, %f, %f}\n",
            out[0], out[4], out[8], out[12], S(U(mvp))._11, S(U(mvp))._12, S(U(mvp))._13, S(U(mvp))._14);
    ok(out[1] == S(U(mvp))._21 && out[5] == S(U(mvp))._22 && out[9] == S(U(mvp))._23 && out[13] == S(U(mvp))._24,
            "The second row of mvp was not set correctly, got {%f, %f, %f, %f}, should be {%f, %f, %f, %f}\n",
            out[1], out[5], out[9], out[13], S(U(mvp))._21, S(U(mvp))._22, S(U(mvp))._23, S(U(mvp))._24);
    ok(out[2] == S(U(mvp))._31 && out[6] == S(U(mvp))._32 && out[10] == S(U(mvp))._33 && out[14] == S(U(mvp))._34,
            "The third row of mvp was not set correctly, got {%f, %f, %f, %f}, should be {%f, %f, %f, %f}\n",
            out[2], out[6], out[10], out[14], S(U(mvp))._31, S(U(mvp))._32, S(U(mvp))._33, S(U(mvp))._34);
    ok(out[3] == S(U(mvp))._41 && out[7] == S(U(mvp))._42 && out[11] == S(U(mvp))._43 && out[15] == S(U(mvp))._44,
            "The fourth row of mvp was not set correctly, got {%f, %f, %f, %f}, should be {%f, %f, %f, %f}\n",
            out[3], out[7], out[11], out[15], S(U(mvp))._41, S(U(mvp))._42, S(U(mvp))._43, S(U(mvp))._44);

    IDirect3DDevice9_GetVertexShaderConstantF(device, 7, out, 1);
    ok(memcmp(out, &f4, sizeof(f4)) == 0,
            "The variable f4 was not set correctly, out={%f, %f, %f, %f}, should be {%f, %f, %f, %f}\n",
            out[0], out[1], out[2], out[3], f4.x, f4.y, f4.z, f4.w);

    ID3DXConstantTable_Release(ctable);

    res = D3DXGetShaderConstantTable(ctab_with_default_values, &ctable);
    ok(res == D3D_OK, "D3DXGetShaderConstantTable failed: got %08x\n", res);

    res = ID3DXConstantTable_SetDefaults(ctable, device);
    ok(res == D3D_OK, "ID3DXConstantTable_SetDefaults failed: got %08x\n", res);

    IDirect3DDevice9_GetVertexShaderConstantF(device, 0, out, 4);
    ok(memcmp(out, mat4_default_value, sizeof(mat4_default_value)) == 0,
            "The variable mat4 was not set correctly to default value\n");

    IDirect3DDevice9_GetVertexShaderConstantF(device, 4, out, 4);
    ok(memcmp(out, mat3_default_value, sizeof(mat3_default_value)) == 0,
            "The variable mat3 was not set correctly to default value\n");

    IDirect3DDevice9_GetVertexShaderConstantF(device, 8, out, 3);
    ok(memcmp(out, arr_default_value, sizeof(arr_default_value)) == 0,
        "The variable array was not set correctly to default value\n");

    IDirect3DDevice9_GetVertexShaderConstantF(device, 11, out, 1);
    ok(memcmp(out, vec4_default_value, sizeof(vec4_default_value)) == 0,
        "The variable vec4 was not set correctly to default value\n");

    IDirect3DDevice9_GetVertexShaderConstantF(device, 12, out, 1);
    ok(memcmp(out, flt_default_value, sizeof(flt_default_value)) == 0,
        "The variable flt was not set correctly to default value\n");

    ID3DXConstantTable_Release(ctable);
}

static void test_SetValue(IDirect3DDevice9 *device)
{
    static const D3DXMATRIX mvp = {{{
        0.51f, 0.62f, 0.80f, 0.78f,
        0.23f, 0.95f, 0.37f, 0.48f,
        0.10f, 0.58f, 0.90f, 0.25f,
        0.89f, 0.41f, 0.93f, 0.27f}}};
    static const D3DXVECTOR4 f4 = {0.2f, 0.4f, 0.8f, 1.2f};
    static const FLOAT arr[] = {0.33f, 0.55f, 0.96f, 1.00f,
                                1.00f, 1.00f, 1.00f, 1.00f,
                                1.00f, 1.00f, 1.00f, 1.00f};
    static int imatrix[] = {1, 2, 3, 4, 5, 6};
    static float fmatrix[] = {1.1f, 2.2f, 3.3f, 4.4f};
    static BOOL barray[] = {TRUE, FALSE};
    static float fvecarray[] = {9.1f, 9.2f, 9.3f, 9.4f, 9.5f, 9.6f, 9.7f, 9.8f};
    static float farray[] = {2.2f, 3.3f};

    static const float def[16] = {5.5f, 5.5f, 5.5f, 5.5f,
                                  5.5f, 5.5f, 5.5f, 5.5f,
                                  5.5f, 5.5f, 5.5f, 5.5f,
                                  5.5f, 5.5f, 5.5f, 5.5f};
    float out[16];

    HRESULT res;
    ID3DXConstantTable *ctable;

    res = D3DXGetShaderConstantTable(ctab_basic, &ctable);
    ok(res == D3D_OK, "D3DXGetShaderConstantTable failed: got %08x\n", res);

    IDirect3DDevice9_SetVertexShaderConstantF(device, 7, def, 1);

    /* SetValue called with 0 bytes size doesn't change value */
    res = ID3DXConstantTable_SetValue(ctable, device, "f4", &f4, 0);
    ok(res == D3D_OK, "ID3DXConstantTable_SetValue failed: got %08x\n", res);

    IDirect3DDevice9_GetVertexShaderConstantF(device, 7, out, 1);
    ok(memcmp(out, def, sizeof(f4)) == 0,
            "The variable f4 was not set correctly, out={%f, %f, %f, %f}, should be {%f, %f, %f, %f}\n",
            out[0], out[1], out[2], out[3], def[0], def[1], def[2], def[3]);

    res = ID3DXConstantTable_SetValue(ctable, device, "f4", &f4, sizeof(f4));
    ok(res == D3D_OK, "ID3DXConstantTable_SetValue failed: got %08x\n", res);

    IDirect3DDevice9_GetVertexShaderConstantF(device, 7, out, 1);
    ok(memcmp(out, &f4, sizeof(f4)) == 0,
            "The variable f4 was not set correctly, out={%f, %f, %f, %f}, should be {%f, %f, %f, %f}\n",
            out[0], out[1], out[2], out[3], f4.x, f4.y, f4.z, f4.w);

    IDirect3DDevice9_SetVertexShaderConstantF(device, 0, def, 4);

    /* SetValue called with size smaller than constant size doesn't change value */
    res = ID3DXConstantTable_SetValue(ctable, device, "mvp", &mvp, sizeof(mvp) / 2);
    ok(res == D3D_OK, "ID3DXConstantTable_SetValue returned %08x\n", res);

    IDirect3DDevice9_GetVertexShaderConstantF(device, 0, out, 4);
    ok(memcmp(out, def, sizeof(def)) == 0,
            "The variable mvp was not set correctly, out={%f, %f, %f, %f; %f, %f, %f, %f; %f, %f, %f, %f; %f, %f, %f, %f}, "
            "should be {%f, %f, %f, %f; %f, %f, %f, %f; %f, %f, %f, %f; %f, %f, %f, %f}\n",
            out[0], out[4], out[ 8], out[12],
            out[1], out[5], out[ 9], out[13],
            out[2], out[6], out[10], out[14],
            out[3], out[7], out[11], out[15],
            def[0], def[4], def[ 8], def[12],
            def[1], def[5], def[ 9], def[13],
            def[2], def[6], def[10], def[14],
            def[3], def[7], def[11], def[15]);

    res = ID3DXConstantTable_SetValue(ctable, device, "mvp", &mvp, sizeof(mvp));
    ok(res == D3D_OK, "ID3DXConstantTable_SetValue failed: got %08x\n", res);

    IDirect3DDevice9_GetVertexShaderConstantF(device, 0, out, 4);
    ok(out[0] == S(U(mvp))._11 && out[4] == S(U(mvp))._12 && out[8] == S(U(mvp))._13 && out[12] == S(U(mvp))._14,
            "The first row of mvp was not set correctly, got {%f, %f, %f, %f}, should be {%f, %f, %f, %f}\n",
            out[0], out[4], out[8], out[12], S(U(mvp))._11, S(U(mvp))._12, S(U(mvp))._13, S(U(mvp))._14);
    ok(out[1] == S(U(mvp))._21 && out[5] == S(U(mvp))._22 && out[9] == S(U(mvp))._23 && out[13] == S(U(mvp))._24,
            "The second row of mvp was not set correctly, got {%f, %f, %f, %f}, should be {%f, %f, %f, %f}\n",
            out[1], out[5], out[9], out[13], S(U(mvp))._21, S(U(mvp))._22, S(U(mvp))._23, S(U(mvp))._24);
    ok(out[2] == S(U(mvp))._31 && out[6] == S(U(mvp))._32 && out[10] == S(U(mvp))._33 && out[14] == S(U(mvp))._34,
            "The third row of mvp was not set correctly, got {%f, %f, %f, %f}, should be {%f, %f, %f, %f}\n",
            out[2], out[6], out[10], out[14], S(U(mvp))._31, S(U(mvp))._32, S(U(mvp))._33, S(U(mvp))._34);
    ok(out[3] == S(U(mvp))._41 && out[7] == S(U(mvp))._42 && out[11] == S(U(mvp))._43 && out[15] == S(U(mvp))._44,
            "The fourth row of mvp was not set correctly, got {%f, %f, %f, %f}, should be {%f, %f, %f, %f}\n",
            out[3], out[7], out[11], out[15], S(U(mvp))._41, S(U(mvp))._42, S(U(mvp))._43, S(U(mvp))._44);

    ID3DXConstantTable_Release(ctable);

    res = D3DXGetShaderConstantTable(ctab_with_default_values, &ctable);
    ok(res == D3D_OK, "D3DXGetShaderConstantTable failed: got %08x\n", res);

    res = ID3DXConstantTable_SetValue(ctable, device, "arr", arr, sizeof(arr));
    ok(res == D3D_OK, "ID3DXConstantTable_SetValue failed: got %08x\n", res);

    IDirect3DDevice9_GetVertexShaderConstantF(device, 8, out, 3);
    ok(out[0] == arr[0] && out[4] == arr[1] && out[8] == arr[2]
            && out[1] == 0 &&  out[2] == 0 && out[3] == 0 && out[5] == 0 && out[6] == 0 && out[7] == 0
            && out[9] == 0 && out[10] == 0 && out[11] == 0,
            "The variable arr was not set correctly, out={%f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f}, "
            "should be {0.33, 0, 0, 0, 0.55, 0, 0, 0, 0.96, 0, 0, 0}\n",
            out[0], out[1], out[2], out[3], out[4], out[5], out[6], out[7], out[8], out[9], out[10], out[11]);

    ID3DXConstantTable_Release(ctable);

    res = D3DXGetShaderConstantTable(ctab_matrices, &ctable);
    ok(res == D3D_OK, "D3DXGetShaderConstantTable failed: got %08x\n", res);

    res = ID3DXConstantTable_SetValue(ctable, device, "fmatrix3x1", fmatrix, sizeof(fmatrix));
    ok(res == D3D_OK, "ID3DXConstantTable_SetValue failed: got %08x\n", res);

    res = ID3DXConstantTable_SetValue(ctable, device, "imatrix2x3", imatrix, sizeof(imatrix));
    ok(res == D3D_OK, "ID3DXConstantTable_SetValue failed: got %08x\n", res);

    IDirect3DDevice9_GetVertexShaderConstantF(device, 4, out, 2);
    ok(out[0] == imatrix[0] && out[1] == imatrix[1] && out[2] == imatrix[2] && out[3] == 0.0f
            && out[4] == imatrix[3] && out[5] == imatrix[4] && out[6] == imatrix[5] && out[7] == 0.0f,
            "The variable imatrix2x3 was not set correctly, out={%f, %f, %f, %f, %f, %f, %f, %f}, "
            "should be {%d, %d, %d, 0, %d, %d, %d, 0}\n",
            out[0], out[1], out[2], out[3], out[4], out[5], out[6], out[7],
            imatrix[0], imatrix[1], imatrix[2], imatrix[3], imatrix[4], imatrix[5]);

    IDirect3DDevice9_GetVertexShaderConstantF(device, 7, out, 2);
    ok(out[0] == fmatrix[0] && out[1] == fmatrix[1] && out[2] == fmatrix[2] && out[3] == 0.0f,
            "The variable fmatrix3x1 was not set correctly, out={%f, %f, %f, %f}, should be {%f, %f, %f, %f}\n",
            out[0], out[1] ,out[2], out[4],
            fmatrix[0], fmatrix[1], fmatrix[2], 0.0f);

    ID3DXConstantTable_Release(ctable);

    res = D3DXGetShaderConstantTable(ctab_arrays, &ctable);
    ok(res == D3D_OK, "D3DXGetShaderConstantTable failed: got %08x\n", res);

    res = ID3DXConstantTable_SetValue(ctable, device, "barray", barray, sizeof(barray));
    ok(res == D3D_OK, "ID3DXConstantTable_SetValue failed: got %08x\n", res);

    res = ID3DXConstantTable_SetValue(ctable, device, "fvecarray", fvecarray, sizeof(fvecarray));
    ok(res == D3D_OK, "ID3DXConstantTable_SetValue failed: got %08x\n", res);

    IDirect3DDevice9_SetVertexShaderConstantF(device, 8, def, 4);
    res = ID3DXConstantTable_SetValue(ctable, device, "farray", farray, sizeof(farray));
    ok(res == D3D_OK, "ID3DXConstantTable_SetValue failed: got %08x\n", res);

    /* 2 elements of farray were set */
    IDirect3DDevice9_GetVertexShaderConstantF(device, 8, out, 4);
    ok(out[0] == farray[0] && out[1] == 0.0f && out[2] == 0.0f && out[3] == 0.0f
            && out[4] == farray[1] && out[5] == 0.0f && out[6] == 0.0f && out[7] == 0.0f
            && out[8] == def[8] && out[9] == def[9] && out[10] == def[10] && out[11] == def[11]
            && out[12] == def[12] && out[13] == def[13] && out[14] == def[14] && out[15] == def[15],
            "The variable farray was not set correctly, should be {%f, %f, %f, %f; %f, %f, %f, %f; %f, %f, %f, %f; %f, %f, %f, %f}, "
            "should be {%f, %f, %f, %f; %f, %f, %f, %f; %f, %f, %f, %f; %f, %f, %f, %f}\n",
            out[0], out[1], out[2], out[3], out[4], out[5], out[6], out[7],
            out[8], out[9], out[10], out[11], out[12], out[13], out[14], out[15],
            farray[0], 0.0f, 0.0f, 0.0f,
            farray[1], 0.0f, 0.0f, 0.0f,
            def[8], def[9], def[10], def[11],
            def[12], def[13], def[14], def[15]);

    IDirect3DDevice9_GetVertexShaderConstantF(device, 12, out, 2);
    ok(out[0] == fvecarray[0] && out[1] == fvecarray[1] && out[2] == fvecarray[2] && out[3] == fvecarray[3]
            && out[4] == fvecarray[4] && out[5] == fvecarray[5] && out[6] == fvecarray[6] && out[7] == fvecarray[7],
            "The variable fvecarray was not set correctly, out ={%f, %f, %f, %f, %f, %f, %f, %f}, "
            "should be {%f, %f, %f, %f, %f, %f, %f, %f}\n",
            out[0], out[1], out[2], out[3], out[4], out[5], out[6], out[7],
            fvecarray[0], fvecarray[1], fvecarray[2], fvecarray[3], fvecarray[4], fvecarray[5], fvecarray[6], fvecarray[7]);

    IDirect3DDevice9_GetVertexShaderConstantF(device, 14, out, 2);
    ok(out[0] == 1.0f && out[1] == 0.0f && out[2] == 0.0f && out[3] == 0.0f
            && out[4] == 0.0f && out[5] == 0.0f && out[6] == 0.0f && out[7] == 0.0f,
            "The variable barray was not set correctly, out={%f, %f, %f, %f, %f, %f, %f, %f}, "
            "should be {%f, %f, %f, %f, %f, %f, %f, %f}\n",
            out[0], out[1], out[2], out[3], out[4], out[5], out[6], out[7],
            1.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);

    ID3DXConstantTable_Release(ctable);
}

static void test_setting_constants(void)
{
    HWND wnd;
    IDirect3D9 *d3d;
    IDirect3DDevice9 *device;
    D3DPRESENT_PARAMETERS d3dpp;
    HRESULT hr;
    ULONG refcnt;

    /* Create the device to use for our tests */
    wnd = CreateWindow("static", "d3dx9_test", 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL);
    d3d = Direct3DCreate9(D3D_SDK_VERSION);
    if (!wnd)
    {
        skip("Couldn't create application window\n");
        return;
    }
    if (!d3d)
    {
        skip("Couldn't create IDirect3D9 object\n");
        DestroyWindow(wnd);
        return;
    }

    ZeroMemory(&d3dpp, sizeof(d3dpp));
    d3dpp.Windowed   = TRUE;
    d3dpp.SwapEffect = D3DSWAPEFFECT_DISCARD;
    hr = IDirect3D9_CreateDevice(d3d, D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL, wnd, D3DCREATE_SOFTWARE_VERTEXPROCESSING, &d3dpp, &device);
    if (FAILED(hr))
    {
        skip("Failed to create IDirect3DDevice9 object %#x\n", hr);
        IDirect3D9_Release(d3d);
        DestroyWindow(wnd);
        return;
    }

    test_setting_basic_table(device);
    test_setting_matrices_table(device);
    test_setting_arrays_table(device);
    test_SetDefaults(device);
    test_SetValue(device);

    /* Release resources */
    refcnt = IDirect3DDevice9_Release(device);
    ok(refcnt == 0, "The Direct3D device reference count was %u, should be 0\n", refcnt);

    refcnt = IDirect3D9_Release(d3d);
    ok(refcnt == 0, "The Direct3D object referenct count was %u, should be 0\n", refcnt);

    if (wnd) DestroyWindow(wnd);
}

static void test_get_sampler_index(void)
{
    ID3DXConstantTable *ctable;

    HRESULT res;
    UINT index;

    ULONG refcnt;

    res = D3DXGetShaderConstantTable(ctab_samplers, &ctable);
    ok(res == D3D_OK, "D3DXGetShaderConstantTable failed on ctab_samplers: got %08x\n", res);

    index = ID3DXConstantTable_GetSamplerIndex(ctable, "sampler1");
    ok(index == 0, "ID3DXConstantTable_GetSamplerIndex returned wrong index: Got %d, expected 0\n", index);

    index = ID3DXConstantTable_GetSamplerIndex(ctable, "sampler2");
    ok(index == 3, "ID3DXConstantTable_GetSamplerIndex returned wrong index: Got %d, expected 3\n", index);

    index = ID3DXConstantTable_GetSamplerIndex(ctable, "nonexistent");
    ok(index == -1, "ID3DXConstantTable_GetSamplerIndex found nonexistent sampler: Got %d\n",
            index);

    index = ID3DXConstantTable_GetSamplerIndex(ctable, "notsampler");
    ok(index == -1, "ID3DXConstantTable_GetSamplerIndex succeeded on non-sampler constant: Got %d\n",
            index);

    refcnt = ID3DXConstantTable_Release(ctable);
    ok(refcnt == 0, "The ID3DXConstantTable reference count was %u, should be 0\n", refcnt);
}

/*
 * fxc.exe /Tps_3_0
 */
#if 0
sampler s;
sampler1D s1D;
sampler2D s2D;
sampler3D s3D;
samplerCUBE scube;
float4 init;
float4 main(float3 tex : TEXCOORD0) : COLOR
{
    float4 tmp = init;
    tmp = tmp + tex1D(s1D, tex.x);
    tmp = tmp + tex1D(s1D, tex.y);
    tmp = tmp + tex3D(s3D, tex.xyz);
    tmp = tmp + tex1D(s, tex.x);
    tmp = tmp + tex2D(s2D, tex.xy);
    tmp = tmp + texCUBE(scube, tex.xyz);
    return tmp;
}
#endif
static const DWORD get_shader_samplers_blob[] =
{
    0xffff0300,                                                             /* ps_3_0                        */
    0x0054fffe, FCC_CTAB,                                                   /* CTAB comment                  */
    0x0000001c, 0x0000011b, 0xffff0300, 0x00000006, 0x0000001c, 0x00000100, /* Header                        */
    0x00000114,
    0x00000094, 0x00000002, 0x00000001, 0x0000009c, 0x00000000,             /* Constant 1 desc (init)        */
    0x000000ac, 0x00040003, 0x00000001, 0x000000b0, 0x00000000,             /* Constant 2 desc (s)           */
    0x000000c0, 0x00000003, 0x00000001, 0x000000c4, 0x00000000,             /* Constant 3 desc (s1D)         */
    0x000000d4, 0x00010003, 0x00000001, 0x000000d8, 0x00000000,             /* Constant 4 desc (s2D)         */
    0x000000e8, 0x00030003, 0x00000001, 0x000000ec, 0x00000000,             /* Constant 5 desc (s3D)         */
    0x000000fc, 0x00020003, 0x00000001, 0x00000104, 0x00000000,             /* Constant 6 desc (scube)       */
    0x74696e69, 0xababab00,                                                 /* Constant 1 name               */
    0x00030001, 0x00040001, 0x00000001, 0x00000000,                         /* Constant 1 type desc          */
    0xabab0073,                                                             /* Constant 2 name               */
    0x000c0004, 0x00010001, 0x00000001, 0x00000000,                         /* Constant 2 type desc          */
    0x00443173,                                                             /* Constant 3 name               */
    0x000b0004, 0x00010001, 0x00000001, 0x00000000,                         /* Constant 3 type desc          */
    0x00443273,                                                             /* Constant 4 name               */
    0x000c0004, 0x00010001, 0x00000001, 0x00000000,                         /* Constant 4 type desc          */
    0x00443373,                                                             /* Constant 5 name               */
    0x000d0004, 0x00010001, 0x00000001, 0x00000000,                         /* Constant 5 type desc          */
    0x62756373, 0xabab0065,                                                 /* Constant 6 name               */
    0x000e0004, 0x00010001, 0x00000001, 0x00000000,                         /* Constant 6 type desc          */
    0x335f7370, 0x4d00305f, 0x6f726369, 0x74666f73, 0x29522820, 0x534c4820, /* Target/Creator name string    */
    0x6853204c, 0x72656461, 0x6d6f4320, 0x656c6970, 0x2e392072, 0x392e3932,
    0x332e3235, 0x00313131,
    0x0200001f, 0x80000005, 0x90070000, 0x0200001f, 0x90000000, 0xa00f0800, /* shader                        */
    0x0200001f, 0x90000000, 0xa00f0801, 0x0200001f, 0x98000000, 0xa00f0802,
    0x0200001f, 0xa0000000, 0xa00f0803, 0x0200001f, 0x90000000, 0xa00f0804,
    0x03000042, 0x800f0000, 0x90e40000, 0xa0e40800, 0x03000002, 0x800f0000,
    0x80e40000, 0xa0e40000, 0x03000042, 0x800f0001, 0x90550000, 0xa0e40800,
    0x03000002, 0x800f0000, 0x80e40000, 0x80e40001, 0x03000042, 0x800f0001,
    0x90e40000, 0xa0e40803, 0x03000002, 0x800f0000, 0x80e40000, 0x80e40001,
    0x03000042, 0x800f0001, 0x90e40000, 0xa0e40804, 0x03000002, 0x800f0000,
    0x80e40000, 0x80e40001, 0x03000042, 0x800f0001, 0x90e40000, 0xa0e40801,
    0x03000002, 0x800f0000, 0x80e40000, 0x80e40001, 0x03000042, 0x800f0001,
    0x90e40000, 0xa0e40802, 0x03000002, 0x800f0800, 0x80e40000, 0x80e40001,
    0x0000ffff,                                                             /* END                           */
};

static void test_get_shader_samplers(void)
{
    LPCSTR samplers[16] = {NULL}; /* maximum number of sampler registers v/ps 3.0 = 16 */
    LPCSTR sampler_orig;
    UINT count = 2;
    HRESULT hr;

#if 0
    /* crashes if bytecode is NULL */
    hr = D3DXGetShaderSamplers(NULL, NULL, &count);
    ok(hr == D3D_OK, "D3DXGetShaderSamplers failed, got %x, expected %x\n", hr, D3D_OK);
#endif

    hr = D3DXGetShaderSamplers(get_shader_samplers_blob, NULL, NULL);
    ok(hr == D3D_OK, "D3DXGetShaderSamplers failed, got %x, expected %x\n", hr, D3D_OK);

    samplers[5] = "dummy";

    hr = D3DXGetShaderSamplers(get_shader_samplers_blob, samplers, NULL);
    ok(hr == D3D_OK, "D3DXGetShaderSamplers failed, got %x, expected %x\n", hr, D3D_OK);

    /* check that sampler points to shader blob */
    sampler_orig = (LPCSTR)&get_shader_samplers_blob[0x2E];
    ok(sampler_orig == samplers[0], "D3DXGetShaderSamplers failed, got %p, expected %p\n", samplers[0], sampler_orig);

    sampler_orig = (LPCSTR)&get_shader_samplers_blob[0x33];
    ok(sampler_orig == samplers[1], "D3DXGetShaderSamplers failed, got %p, expected %p\n", samplers[1], sampler_orig);

    sampler_orig = (LPCSTR)&get_shader_samplers_blob[0x38];
    ok(sampler_orig == samplers[2], "D3DXGetShaderSamplers failed, got %p, expected %p\n", samplers[2], sampler_orig);

    sampler_orig = (LPCSTR)&get_shader_samplers_blob[0x3D];
    ok(sampler_orig == samplers[3], "D3DXGetShaderSamplers failed, got %p, expected %p\n", samplers[3], sampler_orig);

    sampler_orig = (LPCSTR)&get_shader_samplers_blob[0x42];
    ok(sampler_orig == samplers[4], "D3DXGetShaderSamplers failed, got %p, expected %p\n", samplers[4], sampler_orig);

    ok(!strcmp(samplers[5], "dummy"), "D3DXGetShaderSamplers failed, got \"%s\", expected \"%s\"\n", samplers[5], "dummy");

    /* reset samplers */
    memset(samplers, 0, sizeof(samplers));
    samplers[5] = "dummy";

    hr = D3DXGetShaderSamplers(get_shader_samplers_blob, NULL, &count);
    ok(hr == D3D_OK, "D3DXGetShaderSamplers failed, got %x, expected %x\n", hr, D3D_OK);
    ok(count == 5, "D3DXGetShaderSamplers failed, got %u, expected %u\n", count, 5);

    hr = D3DXGetShaderSamplers(get_shader_samplers_blob, samplers, &count);
    ok(hr == D3D_OK, "D3DXGetShaderSamplers failed, got %x, expected %x\n", hr, D3D_OK);
    ok(count == 5, "D3DXGetShaderSamplers failed, got %u, expected %u\n", count, 5);

    /* check that sampler points to shader blob */
    sampler_orig = (LPCSTR)&get_shader_samplers_blob[0x2E];
    ok(sampler_orig == samplers[0], "D3DXGetShaderSamplers failed, got %p, expected %p\n", samplers[0], sampler_orig);

    sampler_orig = (LPCSTR)&get_shader_samplers_blob[0x33];
    ok(sampler_orig == samplers[1], "D3DXGetShaderSamplers failed, got %p, expected %p\n", samplers[1], sampler_orig);

    sampler_orig = (LPCSTR)&get_shader_samplers_blob[0x38];
    ok(sampler_orig == samplers[2], "D3DXGetShaderSamplers failed, got %p, expected %p\n", samplers[2], sampler_orig);

    sampler_orig = (LPCSTR)&get_shader_samplers_blob[0x3D];
    ok(sampler_orig == samplers[3], "D3DXGetShaderSamplers failed, got %p, expected %p\n", samplers[3], sampler_orig);

    sampler_orig = (LPCSTR)&get_shader_samplers_blob[0x42];
    ok(sampler_orig == samplers[4], "D3DXGetShaderSamplers failed, got %p, expected %p\n", samplers[4], sampler_orig);

    ok(!strcmp(samplers[5], "dummy"), "D3DXGetShaderSamplers failed, got \"%s\", expected \"%s\"\n", samplers[5], "dummy");

    /* check without ctab */
    hr = D3DXGetShaderSamplers(simple_vs, samplers, &count);
    ok(hr == D3D_OK, "D3DXGetShaderSamplers failed, got %x, expected %x\n", hr, D3D_OK);
    ok(count == 0, "D3DXGetShaderSamplers failed, got %u, expected %u\n", count, 0);

    /* check invalid ctab */
    hr = D3DXGetShaderSamplers(shader_with_invalid_ctab, samplers, &count);
    ok(hr == D3D_OK, "D3DXGetShaderSamplers failed, got %x, expected %x\n", hr, D3D_OK);
    ok(count == 0, "D3DXGetShaderSamplers failed, got %u, expected %u\n", count, 0);
}

/*
 * fxc.exe /Tvs_3_0
 */
#if 0
float f = {1.1f}, f_2[2] = {2.1f, 2.2f};
struct {float f; int i;} s = {3.1f, 31},
s_2[2] = {{4.1f, 41}, {4.2f, 42}},
s_3[3] = {{5.1f, 51}, {5.2f, 52}, {5.3f, 53}};
struct {int i1; int i2; float2 f_2; row_major float3x1 r[2];}
p[2] = {{11, 12, {13.1, 14.1}, {{3.11, 3.21, 3.31}, {3.41, 3.51, 3.61}}},
        {15, 16, {17.1, 18.1}, {{4.11, 4.21, 4.31}, {4.41, 4.51, 4.61}}}};
int i[1] = {6};
float2x3 f23[2] = {{0.11, 0.21, 0.31, 0.41, 0.51, 0.61}, {0.12, 0.22, 0.32, 0.42, 0.52, 0.62}};
float3x2 f32[2] = {{1.11, 1.21, 1.31, 1.41, 1.51, 1.61}, {1.12, 1.22, 1.32, 1.42, 1.52, 1.62}};
float3 v[2] = {{2.11, 2.21, 2.31}, {2.41, 2.51, 2.61}};
row_major float3x1 r31[2] = {{3.11, 3.21, 3.31}, {3.41, 3.51, 3.61}};
row_major float1x3 r13[2] = {{4.11, 4.21, 4.31}, {4.41, 4.51, 4.61}};
float4 main(float4 pos : POSITION) : POSITION
{
    float4 tmp = 0.0f;
    tmp.zyw = v[1] + r13[1] + r31[1] + p[1].r[1];
    tmp.x += f * f_2[1] * pos.x * p[1].f_2.y;
    tmp.y += s.f * pos.y * s_2[0].i;
    tmp.z += s_3[0].f * pos.z * s_3[2].f * i[0] * f23[1]._11 * f32[1]._32;
    return tmp;
}
#endif
static const DWORD test_get_shader_constant_variables_blob[] =
{
0xfffe0300, 0x0185fffe, 0x42415443, 0x0000001c, 0x000005df, 0xfffe0300, 0x0000000c, 0x0000001c,
0x00000100, 0x000005d8, 0x0000010c, 0x002d0002, 0x00000001, 0x00000110, 0x00000120, 0x00000130,
0x001d0002, 0x00000004, 0x00000134, 0x00000144, 0x000001a4, 0x00210002, 0x00000004, 0x000001a8,
0x000001b8, 0x000001f8, 0x00250002, 0x00000002, 0x000001fc, 0x0000020c, 0x0000022c, 0x002f0002,
0x00000001, 0x00000230, 0x00000240, 0x00000250, 0x00000002, 0x00000012, 0x000002b0, 0x000002c0,
0x000003e0, 0x002b0002, 0x00000002, 0x000003e4, 0x000003f4, 0x00000414, 0x00120002, 0x00000006,
0x00000418, 0x00000428, 0x00000488, 0x002e0002, 0x00000001, 0x000004ac, 0x000004bc, 0x000004dc,
0x00270002, 0x00000002, 0x000004e0, 0x000004f0, 0x00000530, 0x00180002, 0x00000005, 0x00000534,
0x00000544, 0x000005a4, 0x00290002, 0x00000002, 0x000005a8, 0x000005b8, 0xabab0066, 0x00030000,
0x00010001, 0x00000001, 0x00000000, 0x3f8ccccd, 0x00000000, 0x00000000, 0x00000000, 0x00333266,
0x00030003, 0x00030002, 0x00000002, 0x00000000, 0x3de147ae, 0x3ed1eb85, 0x00000000, 0x00000000,
0x3e570a3d, 0x3f028f5c, 0x00000000, 0x00000000, 0x3e9eb852, 0x3f1c28f6, 0x00000000, 0x00000000,
0x3df5c28f, 0x3ed70a3d, 0x00000000, 0x00000000, 0x3e6147ae, 0x3f051eb8, 0x00000000, 0x00000000,
0x3ea3d70a, 0x3f1eb852, 0x00000000, 0x00000000, 0x00323366, 0x00030003, 0x00020003, 0x00000002,
0x00000000, 0x3f8e147b, 0x3fa7ae14, 0x3fc147ae, 0x00000000, 0x3f9ae148, 0x3fb47ae1, 0x3fce147b,
0x00000000, 0x3f8f5c29, 0x3fa8f5c3, 0x3fc28f5c, 0x00000000, 0x3f9c28f6, 0x3fb5c28f, 0x3fcf5c29,
0x00000000, 0x00325f66, 0x00030000, 0x00010001, 0x00000002, 0x00000000, 0x40066666, 0x00000000,
0x00000000, 0x00000000, 0x400ccccd, 0x00000000, 0x00000000, 0x00000000, 0xabab0069, 0x00020000,
0x00010001, 0x00000001, 0x00000000, 0x40c00000, 0x00000000, 0x00000000, 0x00000000, 0x31690070,
0xababab00, 0x00020000, 0x00010001, 0x00000001, 0x00000000, 0xab003269, 0x00030001, 0x00020001,
0x00000001, 0x00000000, 0xabab0072, 0x00030002, 0x00010003, 0x00000002, 0x00000000, 0x00000252,
0x00000258, 0x00000268, 0x00000258, 0x000001f8, 0x0000026c, 0x0000027c, 0x00000280, 0x00000005,
0x000a0001, 0x00040002, 0x00000290, 0x41300000, 0x00000000, 0x00000000, 0x00000000, 0x41400000,
0x00000000, 0x00000000, 0x00000000, 0x4151999a, 0x4161999a, 0x00000000, 0x00000000, 0x40470a3d,
0x00000000, 0x00000000, 0x00000000, 0x404d70a4, 0x00000000, 0x00000000, 0x00000000, 0x4053d70a,
0x00000000, 0x00000000, 0x00000000, 0x405a3d71, 0x00000000, 0x00000000, 0x00000000, 0x4060a3d7,
0x00000000, 0x00000000, 0x00000000, 0x40670a3d, 0x00000000, 0x00000000, 0x00000000, 0x41700000,
0x00000000, 0x00000000, 0x00000000, 0x41800000, 0x00000000, 0x00000000, 0x00000000, 0x4188cccd,
0x4190cccd, 0x00000000, 0x00000000, 0x4083851f, 0x00000000, 0x00000000, 0x00000000, 0x4086b852,
0x00000000, 0x00000000, 0x00000000, 0x4089eb85, 0x00000000, 0x00000000, 0x00000000, 0x408d1eb8,
0x00000000, 0x00000000, 0x00000000, 0x409051ec, 0x00000000, 0x00000000, 0x00000000, 0x4093851f,
0x00000000, 0x00000000, 0x00000000, 0x00333172, 0x00030002, 0x00030001, 0x00000002, 0x00000000,
0x4083851f, 0x4086b852, 0x4089eb85, 0x00000000, 0x408d1eb8, 0x409051ec, 0x4093851f, 0x00000000,
0x00313372, 0x00030002, 0x00010003, 0x00000002, 0x00000000, 0x40470a3d, 0x00000000, 0x00000000,
0x00000000, 0x404d70a4, 0x00000000, 0x00000000, 0x00000000, 0x4053d70a, 0x00000000, 0x00000000,
0x00000000, 0x405a3d71, 0x00000000, 0x00000000, 0x00000000, 0x4060a3d7, 0x00000000, 0x00000000,
0x00000000, 0x40670a3d, 0x00000000, 0x00000000, 0x00000000, 0xabab0073, 0x00030000, 0x00010001,
0x00000001, 0x00000000, 0x0000010c, 0x0000048c, 0x0000022c, 0x00000258, 0x00000005, 0x00020001,
0x00020001, 0x0000049c, 0x40466666, 0x00000000, 0x00000000, 0x00000000, 0x41f80000, 0x00000000,
0x00000000, 0x00000000, 0x00325f73, 0x00000005, 0x00020001, 0x00020002, 0x0000049c, 0x40833333,
0x00000000, 0x00000000, 0x00000000, 0x42240000, 0x00000000, 0x00000000, 0x00000000, 0x40866666,
0x00000000, 0x00000000, 0x00000000, 0x42280000, 0x00000000, 0x00000000, 0x00000000, 0x00335f73,
0x00000005, 0x00020001, 0x00020003, 0x0000049c, 0x40a33333, 0x00000000, 0x00000000, 0x00000000,
0x424c0000, 0x00000000, 0x00000000, 0x00000000, 0x40a66666, 0x00000000, 0x00000000, 0x00000000,
0x42500000, 0x00000000, 0x00000000, 0x00000000, 0x40a9999a, 0x00000000, 0x00000000, 0x00000000,
0x42540000, 0x00000000, 0x00000000, 0x00000000, 0xabab0076, 0x00030001, 0x00030001, 0x00000002,
0x00000000, 0x40070a3d, 0x400d70a4, 0x4013d70a, 0x00000000, 0x401a3d71, 0x4020a3d7, 0x40270a3d,
0x00000000, 0x335f7376, 0x4d00305f, 0x6f726369, 0x74666f73, 0x29522820, 0x534c4820, 0x6853204c,
0x72656461, 0x6d6f4320, 0x656c6970, 0x2e392072, 0x392e3932, 0x332e3235, 0x00313131, 0x0200001f,
0x80000000, 0x900f0000, 0x0200001f, 0x80000000, 0xe00f0000, 0x02000001, 0x80070000, 0xa0e4002a,
0x03000002, 0x80070000, 0x80e40000, 0xa0e4002c, 0x03000002, 0x80040000, 0x80aa0000, 0xa0000017,
0x03000002, 0xe0080000, 0x80aa0000, 0xa0000011, 0x02000001, 0x80010001, 0xa000002d, 0x03000005,
0x80040000, 0x80000001, 0xa0000026, 0x03000005, 0x80040000, 0x80aa0000, 0x90000000, 0x03000005,
0xe0010000, 0x80aa0000, 0xa055000b, 0x03000002, 0x80020000, 0x80550000, 0xa0000016, 0x03000002,
0x80010000, 0x80000000, 0xa0000015, 0x03000002, 0x80010000, 0x80000000, 0xa000000f, 0x03000002,
0x80020000, 0x80550000, 0xa0000010, 0x03000005, 0x80040000, 0xa000002e, 0x90550000, 0x04000004,
0xe0020000, 0x80aa0000, 0xa0000028, 0x80550000, 0x03000005, 0x80020000, 0xa0000018, 0x90aa0000,
0x03000005, 0x80020000, 0x80550000, 0xa000001c, 0x03000005, 0x80020000, 0x80550000, 0xa000002f,
0x03000005, 0x80020000, 0x80550000, 0xa0000020, 0x04000004, 0xe0040000, 0x80550000, 0xa0aa0024,
0x80000000, 0x0000ffff,
};

const struct {
    LPCSTR fullname;
    D3DXCONSTANT_DESC desc;
    UINT ctaboffset;
}
test_get_shader_constant_variables_data[] =
{
    {"f",         {"f",   D3DXRS_FLOAT4, 45,  1, D3DXPC_SCALAR,         D3DXPT_FLOAT, 1,  1, 1, 0,  4, NULL},  72},
    {"f23",       {"f23", D3DXRS_FLOAT4, 29,  4, D3DXPC_MATRIX_COLUMNS, D3DXPT_FLOAT, 2,  3, 2, 0, 48, NULL},  81},
    {"f23[0]",    {"f23", D3DXRS_FLOAT4, 29,  3, D3DXPC_MATRIX_COLUMNS, D3DXPT_FLOAT, 2,  3, 1, 0, 24, NULL},  81},
    {"f23[1]",    {"f23", D3DXRS_FLOAT4, 32,  1, D3DXPC_MATRIX_COLUMNS, D3DXPT_FLOAT, 2,  3, 1, 0, 24, NULL},  93},
    {"f32",       {"f32", D3DXRS_FLOAT4, 33,  4, D3DXPC_MATRIX_COLUMNS, D3DXPT_FLOAT, 3,  2, 2, 0, 48, NULL}, 110},
    {"f32[0]",    {"f32", D3DXRS_FLOAT4, 33,  2, D3DXPC_MATRIX_COLUMNS, D3DXPT_FLOAT, 3,  2, 1, 0, 24, NULL}, 110},
    {"f32[1]",    {"f32", D3DXRS_FLOAT4, 35,  2, D3DXPC_MATRIX_COLUMNS, D3DXPT_FLOAT, 3,  2, 1, 0, 24, NULL}, 118},
    {"f_2",       {"f_2", D3DXRS_FLOAT4, 37,  2, D3DXPC_SCALAR,         D3DXPT_FLOAT, 1,  1, 2, 0,  8, NULL}, 131},
    {"f_2[0]",    {"f_2", D3DXRS_FLOAT4, 37,  1, D3DXPC_SCALAR,         D3DXPT_FLOAT, 1,  1, 1, 0,  4, NULL}, 131},
    {"f_2[1]",    {"f_2", D3DXRS_FLOAT4, 38,  1, D3DXPC_SCALAR,         D3DXPT_FLOAT, 1,  1, 1, 0,  4, NULL}, 135},
    {"i",         {"i",   D3DXRS_FLOAT4, 47,  1, D3DXPC_SCALAR,         D3DXPT_INT,   1,  1, 1, 0,  4, NULL}, 144},
    {"i[0]",      {"i",   D3DXRS_FLOAT4, 47,  1, D3DXPC_SCALAR,         D3DXPT_INT,   1,  1, 1, 0,  4, NULL}, 144},
    {"p",         {"p",   D3DXRS_FLOAT4,  0, 18, D3DXPC_STRUCT,         D3DXPT_VOID,  1, 10, 2, 4, 80, NULL}, 176},
    {"p[0]",      {"p",   D3DXRS_FLOAT4,  0,  9, D3DXPC_STRUCT,         D3DXPT_VOID,  1, 10, 1, 4, 40, NULL}, 176},
    {"p[0].i1",   {"i1",  D3DXRS_FLOAT4,  0,  1, D3DXPC_SCALAR,         D3DXPT_INT,   1,  1, 1, 0,  4, NULL}, 176},
    {"p[0].i2",   {"i2",  D3DXRS_FLOAT4,  1,  1, D3DXPC_SCALAR,         D3DXPT_INT,   1,  1, 1, 0,  4, NULL}, 180},
    {"p[0].f_2",  {"f_2", D3DXRS_FLOAT4,  2,  1, D3DXPC_VECTOR,         D3DXPT_FLOAT, 1,  2, 1, 0,  8, NULL}, 184},
    {"p[0].r",    {"r",   D3DXRS_FLOAT4,  3,  6, D3DXPC_MATRIX_ROWS,    D3DXPT_FLOAT, 3,  1, 2, 0, 24, NULL}, 188},
    {"p[0].r[0]", {"r",   D3DXRS_FLOAT4,  3,  3, D3DXPC_MATRIX_ROWS,    D3DXPT_FLOAT, 3,  1, 1, 0, 12, NULL}, 188},
    {"p[0].r[1]", {"r",   D3DXRS_FLOAT4,  6,  3, D3DXPC_MATRIX_ROWS,    D3DXPT_FLOAT, 3,  1, 1, 0, 12, NULL}, 200},
    {"p[1]",      {"p",   D3DXRS_FLOAT4,  9,  9, D3DXPC_STRUCT,         D3DXPT_VOID,  1, 10, 1, 4, 40, NULL}, 212},
    {"p[1].i1",   {"i1",  D3DXRS_FLOAT4,  9,  1, D3DXPC_SCALAR,         D3DXPT_INT,   1,  1, 1, 0,  4, NULL}, 212},
    {"p[1].i2",   {"i2",  D3DXRS_FLOAT4, 10,  1, D3DXPC_SCALAR,         D3DXPT_INT,   1,  1, 1, 0,  4, NULL}, 216},
    {"p[1].f_2",  {"f_2", D3DXRS_FLOAT4, 11,  1, D3DXPC_VECTOR,         D3DXPT_FLOAT, 1,  2, 1, 0,  8, NULL}, 220},
    {"p[1].r",    {"r",   D3DXRS_FLOAT4, 12,  6, D3DXPC_MATRIX_ROWS,    D3DXPT_FLOAT, 3,  1, 2, 0, 24, NULL}, 224},
    {"p[1].r[0]", {"r",   D3DXRS_FLOAT4, 12,  3, D3DXPC_MATRIX_ROWS,    D3DXPT_FLOAT, 3,  1, 1, 0, 12, NULL}, 224},
    {"p[1].r[1]", {"r",   D3DXRS_FLOAT4, 15,  3, D3DXPC_MATRIX_ROWS,    D3DXPT_FLOAT, 3,  1, 1, 0, 12, NULL}, 236},
    {"r13",       {"r13", D3DXRS_FLOAT4, 43,  2, D3DXPC_MATRIX_ROWS,    D3DXPT_FLOAT, 1,  3, 2, 0, 24, NULL}, 253},
    {"r13[0]",    {"r13", D3DXRS_FLOAT4, 43,  1, D3DXPC_MATRIX_ROWS,    D3DXPT_FLOAT, 1,  3, 1, 0, 12, NULL}, 253},
    {"r13[1]",    {"r13", D3DXRS_FLOAT4, 44,  1, D3DXPC_MATRIX_ROWS,    D3DXPT_FLOAT, 1,  3, 1, 0, 12, NULL}, 257},
    {"r31",       {"r31", D3DXRS_FLOAT4, 18,  6, D3DXPC_MATRIX_ROWS,    D3DXPT_FLOAT, 3,  1, 2, 0, 24, NULL}, 266},
    {"r31[0]",    {"r31", D3DXRS_FLOAT4, 18,  3, D3DXPC_MATRIX_ROWS,    D3DXPT_FLOAT, 3,  1, 1, 0, 12, NULL}, 266},
    {"r31[1]",    {"r31", D3DXRS_FLOAT4, 21,  3, D3DXPC_MATRIX_ROWS,    D3DXPT_FLOAT, 3,  1, 1, 0, 12, NULL}, 278},
    {"s",         {"s",   D3DXRS_FLOAT4, 46,  1, D3DXPC_STRUCT,         D3DXPT_VOID,  1,  2, 1, 2,  8, NULL}, 303},
    {"s.f",       {"f",   D3DXRS_FLOAT4, 46,  1, D3DXPC_SCALAR,         D3DXPT_FLOAT, 1,  1, 1, 0,  4, NULL}, 303},
    {"s.i",       {"i",   D3DXRS_FLOAT4, 47,  0, D3DXPC_SCALAR,         D3DXPT_INT,   1,  1, 1, 0,  4, NULL}, 307},
    {"s_2",       {"s_2", D3DXRS_FLOAT4, 39,  2, D3DXPC_STRUCT,         D3DXPT_VOID,  1,  2, 2, 2, 16, NULL}, 316},
    {"s_2[0]",    {"s_2", D3DXRS_FLOAT4, 39,  2, D3DXPC_STRUCT,         D3DXPT_VOID,  1,  2, 1, 2,  8, NULL}, 316},
    {"s_2[0].f",  {"f",   D3DXRS_FLOAT4, 39,  1, D3DXPC_SCALAR,         D3DXPT_FLOAT, 1,  1, 1, 0,  4, NULL}, 316},
    {"s_2[0].i",  {"i",   D3DXRS_FLOAT4, 40,  1, D3DXPC_SCALAR,         D3DXPT_INT,   1,  1, 1, 0,  4, NULL}, 320},
    {"s_2[1]",    {"s_2", D3DXRS_FLOAT4, 41,  0, D3DXPC_STRUCT,         D3DXPT_VOID,  1,  2, 1, 2,  8, NULL}, 324},
    {"s_2[1].f",  {"f",   D3DXRS_FLOAT4, 41,  0, D3DXPC_SCALAR,         D3DXPT_FLOAT, 1,  1, 1, 0,  4, NULL}, 324},
    {"s_2[1].i",  {"i",   D3DXRS_FLOAT4, 41,  0, D3DXPC_SCALAR,         D3DXPT_INT,   1,  1, 1, 0,  4, NULL}, 328},
    {"s_3",       {"s_3", D3DXRS_FLOAT4, 24,  5, D3DXPC_STRUCT,         D3DXPT_VOID,  1,  2, 3, 2, 24, NULL}, 337},
    {"s_3[0]",    {"s_3", D3DXRS_FLOAT4, 24,  2, D3DXPC_STRUCT,         D3DXPT_VOID,  1,  2, 1, 2,  8, NULL}, 337},
    {"s_3[0].f",  {"f",   D3DXRS_FLOAT4, 24,  1, D3DXPC_SCALAR,         D3DXPT_FLOAT, 1,  1, 1, 0,  4, NULL}, 337},
    {"s_3[0].i",  {"i",   D3DXRS_FLOAT4, 25,  1, D3DXPC_SCALAR,         D3DXPT_INT,   1,  1, 1, 0,  4, NULL}, 341},
    {"s_3[1]",    {"s_3", D3DXRS_FLOAT4, 26,  2, D3DXPC_STRUCT,         D3DXPT_VOID,  1,  2, 1, 2,  8, NULL}, 345},
    {"s_3[1].f",  {"f",   D3DXRS_FLOAT4, 26,  1, D3DXPC_SCALAR,         D3DXPT_FLOAT, 1,  1, 1, 0,  4, NULL}, 345},
    {"s_3[1].i",  {"i",   D3DXRS_FLOAT4, 27,  1, D3DXPC_SCALAR,         D3DXPT_INT,   1,  1, 1, 0,  4, NULL}, 349},
    {"s_3[2]",    {"s_3", D3DXRS_FLOAT4, 28,  1, D3DXPC_STRUCT,         D3DXPT_VOID,  1,  2, 1, 2,  8, NULL}, 353},
    {"s_3[2].f",  {"f",   D3DXRS_FLOAT4, 28,  1, D3DXPC_SCALAR,         D3DXPT_FLOAT, 1,  1, 1, 0,  4, NULL}, 353},
    {"s_3[2].i",  {"i",   D3DXRS_FLOAT4, 29,  0, D3DXPC_SCALAR,         D3DXPT_INT,   1,  1, 1, 0,  4, NULL}, 357},
    {"v",         {"v",   D3DXRS_FLOAT4, 41,  2, D3DXPC_VECTOR,         D3DXPT_FLOAT, 1,  3, 2, 0, 24, NULL}, 366},
    {"v[0]",      {"v",   D3DXRS_FLOAT4, 41,  1, D3DXPC_VECTOR,         D3DXPT_FLOAT, 1,  3, 1, 0, 12, NULL}, 366},
    {"v[1]",      {"v",   D3DXRS_FLOAT4, 42,  1, D3DXPC_VECTOR,         D3DXPT_FLOAT, 1,  3, 1, 0, 12, NULL}, 370},
};

static void test_get_shader_constant_variables(void)
{
    ID3DXConstantTable *ctable;
    HRESULT hr;
    ULONG count;
    UINT i;
    UINT nr = 1;
    D3DXHANDLE constant, element;
    D3DXCONSTANT_DESC desc;
    DWORD *ctab;

    hr = D3DXGetShaderConstantTable(test_get_shader_constant_variables_blob, &ctable);
    ok(hr == D3D_OK, "D3DXGetShaderConstantTable failed, got %08x, expected %08x\n", hr, D3D_OK);

    ctab = ID3DXConstantTable_GetBufferPointer(ctable);
    ok(ctab[0] == test_get_shader_constant_variables_blob[3], "ID3DXConstantTable_GetBufferPointer failed\n");

    for (i = 0; i < sizeof(test_get_shader_constant_variables_data) / sizeof(*test_get_shader_constant_variables_data); ++i)
    {
        LPCSTR fullname = test_get_shader_constant_variables_data[i].fullname;
        const D3DXCONSTANT_DESC *expected_desc = &test_get_shader_constant_variables_data[i].desc;
        UINT ctaboffset = test_get_shader_constant_variables_data[i].ctaboffset;

        constant = ID3DXConstantTable_GetConstantByName(ctable, NULL, fullname);
        ok(constant != NULL, "GetConstantByName \"%s\" failed\n", fullname);

        hr = ID3DXConstantTable_GetConstantDesc(ctable, constant, &desc, &nr);
        ok(hr == D3D_OK, "GetConstantDesc \"%s\" failed, got %08x, expected %08x\n", fullname, hr, D3D_OK);

        ok(!strcmp(expected_desc->Name, desc.Name), "GetConstantDesc \"%s\" failed, got \"%s\", expected \"%s\"\n",
                fullname, desc.Name, expected_desc->Name);
        ok(expected_desc->RegisterSet == desc.RegisterSet, "GetConstantDesc \"%s\" failed, got %#x, expected %#x\n",
                fullname, desc.RegisterSet, expected_desc->RegisterSet);
        ok(expected_desc->RegisterIndex == desc.RegisterIndex, "GetConstantDesc \"%s\" failed, got %u, expected %u\n",
                fullname, desc.RegisterIndex, expected_desc->RegisterIndex);
        ok(expected_desc->RegisterCount == desc.RegisterCount, "GetConstantDesc \"%s\" failed, got %u, expected %u\n",
                fullname, desc.RegisterCount, expected_desc->RegisterCount);
        ok(expected_desc->Class == desc.Class, "GetConstantDesc \"%s\" failed, got %u, expected %u\n",
                fullname, desc.Class, expected_desc->Class);
        ok(expected_desc->Type == desc.Type, "GetConstantDesc \"%s\" failed, got %#x, expected %#x\n",
                fullname, desc.Type, expected_desc->Type);
        ok(expected_desc->Rows == desc.Rows, "GetConstantDesc \"%s\" failed, got %#x, expected %#x\n",
                fullname, desc.Rows, expected_desc->Rows);
        ok(expected_desc->Columns == desc.Columns, "GetConstantDesc \"%s\" failed, got %u, expected %u\n",
                fullname, desc.Columns, expected_desc->Columns);
        ok(expected_desc->Elements == desc.Elements, "GetConstantDesc \"%s\" failed, got %u, expected %u\n",
                fullname, desc.Elements, expected_desc->Elements);
        ok(expected_desc->StructMembers == desc.StructMembers, "GetConstantDesc \"%s\" failed, got %u, expected %u\n",
                fullname, desc.StructMembers, expected_desc->StructMembers);
        ok(expected_desc->Bytes == desc.Bytes, "GetConstantDesc \"%s\" failed, got %u, expected %u\n",
                fullname, desc.Bytes, expected_desc->Bytes);
        ok(ctaboffset == (DWORD *)desc.DefaultValue - ctab, "GetConstantDesc \"%s\" failed, got %u, expected %u\n",
           fullname, (UINT)((DWORD *)desc.DefaultValue - ctab), ctaboffset);
    }

    element = ID3DXConstantTable_GetConstantElement(ctable, NULL, 0);
    ok(element == NULL, "GetConstantElement failed\n");

    constant = ID3DXConstantTable_GetConstantByName(ctable, NULL, "i");
    ok(constant != NULL, "GetConstantByName failed\n");

    element = ID3DXConstantTable_GetConstantByName(ctable, NULL, "i[0]");
    ok(constant == element, "GetConstantByName failed, got %p, expected %p\n", element, constant);

    element = ID3DXConstantTable_GetConstantElement(ctable, "i", 0);
    ok(element == constant, "GetConstantElement failed, got %p, expected %p\n", element, constant);

    constant = ID3DXConstantTable_GetConstantByName(ctable, NULL, "f");
    ok(constant != NULL, "GetConstantByName failed\n");

    element = ID3DXConstantTable_GetConstant(ctable, NULL, 0);
    ok(element == constant, "GetConstant failed, got %p, expected %p\n", element, constant);

    element = ID3DXConstantTable_GetConstant(ctable, "invalid", 0);
    ok(element == NULL, "GetConstant failed\n");

    element = ID3DXConstantTable_GetConstant(ctable, "f", 0);
    ok(element == NULL, "GetConstant failed\n");

    element = ID3DXConstantTable_GetConstantByName(ctable, NULL, "f[0]");
    ok(constant == element, "GetConstantByName failed, got %p, expected %p\n", element, constant);

    element = ID3DXConstantTable_GetConstantByName(ctable, NULL, "f[1]");
    ok(NULL == element, "GetConstantByName failed\n");

    element = ID3DXConstantTable_GetConstantByName(ctable, NULL, "f[0][0]");
    ok(constant == element, "GetConstantByName failed, got %p, expected %p\n", element, constant);

    element = ID3DXConstantTable_GetConstantByName(ctable, NULL, "f.");
    ok(element == NULL, "GetConstantByName failed\n");

    element = ID3DXConstantTable_GetConstantElement(ctable, "f", 0);
    ok(element == constant, "GetConstantElement failed, got %p, expected %p\n", element, constant);

    element = ID3DXConstantTable_GetConstantElement(ctable, "f", 1);
    ok(element == NULL, "GetConstantElement failed\n");

    constant = ID3DXConstantTable_GetConstantByName(ctable, NULL, "f_2[0]");
    ok(constant != NULL, "GetConstantByName failed\n");

    element = ID3DXConstantTable_GetConstantByName(ctable, NULL, "f_2");
    ok(element != constant, "GetConstantByName failed, got %p, expected %p\n", element, constant);

    element = ID3DXConstantTable_GetConstantElement(ctable, "f_2", 0);
    ok(element == constant, "GetConstantElement failed, got %p, expected %p\n", element, constant);

    constant = ID3DXConstantTable_GetConstantByName(ctable, NULL, "f_2[1]");
    ok(constant != NULL, "GetConstantByName failed\n");

    element = ID3DXConstantTable_GetConstantElement(ctable, "f_2", 1);
    ok(element == constant, "GetConstantElement failed, got %p, expected %p\n", element, constant);

    constant = ID3DXConstantTable_GetConstantByName(ctable, NULL, "s_2[0].f");
    ok(constant != NULL, "GetConstantByName failed\n");

    element = ID3DXConstantTable_GetConstant(ctable, "s_2[0]", 0);
    ok(element == constant, "GetConstant failed, got %p, expected %p\n", element, constant);

    element = ID3DXConstantTable_GetConstantByName(ctable, "s_2[0]", "f");
    ok(element == constant, "GetConstantByName failed, got %p, expected %p\n", element, constant);

    element = ID3DXConstantTable_GetConstantByName(ctable, "s_2[0]", "invalid");
    ok(element == NULL, "GetConstantByName failed\n");

    constant = ID3DXConstantTable_GetConstantByName(ctable, NULL, "s_2[0]");
    ok(constant != NULL, "GetConstantByName failed\n");

    element = ID3DXConstantTable_GetConstantElement(ctable, "s_2[0]", 0);
    ok(constant == element, "GetConstantByName failed, got %p, expected %p\n", element, constant);

    count = ID3DXConstantTable_Release(ctable);
    ok(count == 0, "Release failed, got %u, expected %u\n", count, 0);
}

START_TEST(shader)
{
    test_get_shader_size();
    test_get_shader_version();
    test_find_shader_comment();
    test_get_shader_constant_table_ex();
    test_constant_tables();
    test_setting_constants();
    test_get_sampler_index();
    test_get_shader_samplers();
    test_get_shader_constant_variables();
}
