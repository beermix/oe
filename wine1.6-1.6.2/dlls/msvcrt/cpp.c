/*
 * msvcrt.dll C++ objects
 *
 * Copyright 2000 Jon Griffiths
 * Copyright 2003, 2004 Alexandre Julliard
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

#include "config.h"
#include "wine/port.h"

#include <stdarg.h>

#include "windef.h"
#include "winternl.h"
#include "wine/exception.h"
#include "wine/debug.h"
#include "msvcrt.h"
#include "cppexcept.h"
#include "mtdll.h"
#include "cxx.h"

WINE_DEFAULT_DEBUG_CHANNEL(msvcrt);

typedef exception bad_cast;
typedef exception bad_typeid;
typedef exception __non_rtti_object;

extern const vtable_ptr MSVCRT_exception_vtable;
extern const vtable_ptr MSVCRT_bad_typeid_vtable;
extern const vtable_ptr MSVCRT_bad_cast_vtable;
extern const vtable_ptr MSVCRT___non_rtti_object_vtable;
extern const vtable_ptr MSVCRT_type_info_vtable;

/* get the vtable pointer for a C++ object */
static inline const vtable_ptr *get_vtable( void *obj )
{
    return *(const vtable_ptr **)obj;
}

static inline const rtti_object_locator *get_obj_locator( void *cppobj )
{
    const vtable_ptr *vtable = get_vtable( cppobj );
    return (const rtti_object_locator *)vtable[-1];
}

#ifndef __x86_64__
static void dump_obj_locator( const rtti_object_locator *ptr )
{
    int i;
    const rtti_object_hierarchy *h = ptr->type_hierarchy;

    TRACE( "%p: sig=%08x base_offset=%08x flags=%08x type=%p %s hierarchy=%p\n",
           ptr, ptr->signature, ptr->base_class_offset, ptr->flags,
           ptr->type_descriptor, dbgstr_type_info(ptr->type_descriptor), ptr->type_hierarchy );
    TRACE( "  hierarchy: sig=%08x attr=%08x len=%d base classes=%p\n",
           h->signature, h->attributes, h->array_len, h->base_classes );
    for (i = 0; i < h->array_len; i++)
    {
        TRACE( "    base class %p: num %d off %d,%d,%d attr %08x type %p %s\n",
               h->base_classes->bases[i],
               h->base_classes->bases[i]->num_base_classes,
               h->base_classes->bases[i]->offsets.this_offset,
               h->base_classes->bases[i]->offsets.vbase_descr,
               h->base_classes->bases[i]->offsets.vbase_offset,
               h->base_classes->bases[i]->attributes,
               h->base_classes->bases[i]->type_descriptor,
               dbgstr_type_info(h->base_classes->bases[i]->type_descriptor) );
    }
}

#else

static void dump_obj_locator( const rtti_object_locator *ptr )
{
    int i;
    char *base = ptr->signature == 0 ? RtlPcToFileHeader((void*)ptr, (void**)&base) : (char*)ptr - ptr->object_locator;
    const rtti_object_hierarchy *h = (const rtti_object_hierarchy*)(base + ptr->type_hierarchy);
    const type_info *type_descriptor = (const type_info*)(base + ptr->type_descriptor);

    TRACE( "%p: sig=%08x base_offset=%08x flags=%08x type=%p %s hierarchy=%p\n",
            ptr, ptr->signature, ptr->base_class_offset, ptr->flags,
            type_descriptor, dbgstr_type_info(type_descriptor), h );
    TRACE( "  hierarchy: sig=%08x attr=%08x len=%d base classes=%p\n",
            h->signature, h->attributes, h->array_len, base + h->base_classes );
    for (i = 0; i < h->array_len; i++)
    {
        const rtti_base_descriptor *bases = (rtti_base_descriptor*)(base +
                ((const rtti_base_array*)(base + h->base_classes))->bases[i]);

        TRACE( "    base class %p: num %d off %d,%d,%d attr %08x type %p %s\n",
                bases,
                bases->num_base_classes,
                bases->offsets.this_offset,
                bases->offsets.vbase_descr,
                bases->offsets.vbase_offset,
                bases->attributes,
                base + bases->type_descriptor,
                dbgstr_type_info((const type_info*)(base + bases->type_descriptor)) );
    }
}
#endif

/* Internal common ctor for exception */
static void EXCEPTION_ctor(exception *_this, const char** name)
{
  _this->vtable = &MSVCRT_exception_vtable;
  if (*name)
  {
    unsigned int name_len = strlen(*name) + 1;
    _this->name = MSVCRT_malloc(name_len);
    memcpy(_this->name, *name, name_len);
    _this->do_free = TRUE;
  }
  else
  {
    _this->name = NULL;
    _this->do_free = FALSE;
  }
}

/******************************************************************
 *		??0exception@@QAE@ABQBD@Z (MSVCRT.@)
 */
DEFINE_THISCALL_WRAPPER(MSVCRT_exception_ctor,8)
exception * __thiscall MSVCRT_exception_ctor(exception * _this, const char ** name)
{
  TRACE("(%p,%s)\n", _this, *name);
  EXCEPTION_ctor(_this, name);
  return _this;
}

/******************************************************************
 *		??0exception@@QAE@ABQBDH@Z (MSVCRT.@)
 */
DEFINE_THISCALL_WRAPPER(MSVCRT_exception_ctor_noalloc,12)
exception * __thiscall MSVCRT_exception_ctor_noalloc(exception * _this, char ** name, int noalloc)
{
  TRACE("(%p,%s)\n", _this, *name);
  _this->vtable = &MSVCRT_exception_vtable;
  _this->name = *name;
  _this->do_free = FALSE;
  return _this;
}

/******************************************************************
 *		??0exception@@QAE@ABV0@@Z (MSVCRT.@)
 */
DEFINE_THISCALL_WRAPPER(MSVCRT_exception_copy_ctor,8)
exception * __thiscall MSVCRT_exception_copy_ctor(exception * _this, const exception * rhs)
{
  TRACE("(%p,%p)\n", _this, rhs);

  if (!rhs->do_free)
  {
    _this->vtable = &MSVCRT_exception_vtable;
    _this->name = rhs->name;
    _this->do_free = FALSE;
  }
  else
    EXCEPTION_ctor(_this, (const char**)&rhs->name);
  TRACE("name = %s\n", _this->name);
  return _this;
}

/******************************************************************
 *		??0exception@@QAE@XZ (MSVCRT.@)
 */
DEFINE_THISCALL_WRAPPER(MSVCRT_exception_default_ctor,4)
exception * __thiscall MSVCRT_exception_default_ctor(exception * _this)
{
  static const char* empty = NULL;

  TRACE("(%p)\n", _this);
  EXCEPTION_ctor(_this, &empty);
  return _this;
}

/******************************************************************
 *		??1exception@@UAE@XZ (MSVCRT.@)
 */
DEFINE_THISCALL_WRAPPER(MSVCRT_exception_dtor,4)
void __thiscall MSVCRT_exception_dtor(exception * _this)
{
  TRACE("(%p)\n", _this);
  _this->vtable = &MSVCRT_exception_vtable;
  if (_this->do_free) MSVCRT_free(_this->name);
}

/******************************************************************
 *		??4exception@@QAEAAV0@ABV0@@Z (MSVCRT.@)
 */
DEFINE_THISCALL_WRAPPER(MSVCRT_exception_opequals,8)
exception * __thiscall MSVCRT_exception_opequals(exception * _this, const exception * rhs)
{
  TRACE("(%p %p)\n", _this, rhs);
  if (_this != rhs)
  {
      MSVCRT_exception_dtor(_this);
      MSVCRT_exception_copy_ctor(_this, rhs);
  }
  TRACE("name = %s\n", _this->name);
  return _this;
}

/******************************************************************
 *		??_Eexception@@UAEPAXI@Z (MSVCRT.@)
 */
DEFINE_THISCALL_WRAPPER(MSVCRT_exception_vector_dtor,8)
void * __thiscall MSVCRT_exception_vector_dtor(exception * _this, unsigned int flags)
{
    TRACE("(%p %x)\n", _this, flags);
    if (flags & 2)
    {
        /* we have an array, with the number of elements stored before the first object */
        INT_PTR i, *ptr = (INT_PTR *)_this - 1;

        for (i = *ptr - 1; i >= 0; i--) MSVCRT_exception_dtor(_this + i);
        MSVCRT_operator_delete(ptr);
    }
    else
    {
        MSVCRT_exception_dtor(_this);
        if (flags & 1) MSVCRT_operator_delete(_this);
    }
    return _this;
}

/******************************************************************
 *		??_Gexception@@UAEPAXI@Z (MSVCRT.@)
 */
DEFINE_THISCALL_WRAPPER(MSVCRT_exception_scalar_dtor,8)
void * __thiscall MSVCRT_exception_scalar_dtor(exception * _this, unsigned int flags)
{
    TRACE("(%p %x)\n", _this, flags);
    MSVCRT_exception_dtor(_this);
    if (flags & 1) MSVCRT_operator_delete(_this);
    return _this;
}

/******************************************************************
 *		?what@exception@@UBEPBDXZ (MSVCRT.@)
 */
DEFINE_THISCALL_WRAPPER(MSVCRT_what_exception,4)
const char * __thiscall MSVCRT_what_exception(exception * _this)
{
  TRACE("(%p) returning %s\n", _this, _this->name);
  return _this->name ? _this->name : "Unknown exception";
}

/******************************************************************
 *		??0bad_typeid@@QAE@ABV0@@Z (MSVCRT.@)
 */
DEFINE_THISCALL_WRAPPER(MSVCRT_bad_typeid_copy_ctor,8)
bad_typeid * __thiscall MSVCRT_bad_typeid_copy_ctor(bad_typeid * _this, const bad_typeid * rhs)
{
  TRACE("(%p %p)\n", _this, rhs);
  MSVCRT_exception_copy_ctor(_this, rhs);
  _this->vtable = &MSVCRT_bad_typeid_vtable;
  return _this;
}

/******************************************************************
 *		??0bad_typeid@@QAE@PBD@Z (MSVCRT.@)
 */
DEFINE_THISCALL_WRAPPER(MSVCRT_bad_typeid_ctor,8)
bad_typeid * __thiscall MSVCRT_bad_typeid_ctor(bad_typeid * _this, const char * name)
{
  TRACE("(%p %s)\n", _this, name);
  EXCEPTION_ctor(_this, &name);
  _this->vtable = &MSVCRT_bad_typeid_vtable;
  return _this;
}

/******************************************************************
 *		??_Fbad_typeid@@QAEXXZ (MSVCRT.@)
 */
DEFINE_THISCALL_WRAPPER(MSVCRT_bad_typeid_default_ctor,4)
bad_typeid * __thiscall MSVCRT_bad_typeid_default_ctor(bad_typeid * _this)
{
  return MSVCRT_bad_typeid_ctor( _this, "bad typeid" );
}

/******************************************************************
 *		??1bad_typeid@@UAE@XZ (MSVCRT.@)
 */
DEFINE_THISCALL_WRAPPER(MSVCRT_bad_typeid_dtor,4)
void __thiscall MSVCRT_bad_typeid_dtor(bad_typeid * _this)
{
  TRACE("(%p)\n", _this);
  MSVCRT_exception_dtor(_this);
}

/******************************************************************
 *		??4bad_typeid@@QAEAAV0@ABV0@@Z (MSVCRT.@)
 */
DEFINE_THISCALL_WRAPPER(MSVCRT_bad_typeid_opequals,8)
bad_typeid * __thiscall MSVCRT_bad_typeid_opequals(bad_typeid * _this, const bad_typeid * rhs)
{
  TRACE("(%p %p)\n", _this, rhs);
  MSVCRT_exception_opequals(_this, rhs);
  return _this;
}

/******************************************************************
 *              ??_Ebad_typeid@@UAEPAXI@Z (MSVCRT.@)
 */
DEFINE_THISCALL_WRAPPER(MSVCRT_bad_typeid_vector_dtor,8)
void * __thiscall MSVCRT_bad_typeid_vector_dtor(bad_typeid * _this, unsigned int flags)
{
    TRACE("(%p %x)\n", _this, flags);
    if (flags & 2)
    {
        /* we have an array, with the number of elements stored before the first object */
        INT_PTR i, *ptr = (INT_PTR *)_this - 1;

        for (i = *ptr - 1; i >= 0; i--) MSVCRT_bad_typeid_dtor(_this + i);
        MSVCRT_operator_delete(ptr);
    }
    else
    {
        MSVCRT_bad_typeid_dtor(_this);
        if (flags & 1) MSVCRT_operator_delete(_this);
    }
    return _this;
}

/******************************************************************
 *		??_Gbad_typeid@@UAEPAXI@Z (MSVCRT.@)
 */
DEFINE_THISCALL_WRAPPER(MSVCRT_bad_typeid_scalar_dtor,8)
void * __thiscall MSVCRT_bad_typeid_scalar_dtor(bad_typeid * _this, unsigned int flags)
{
    TRACE("(%p %x)\n", _this, flags);
    MSVCRT_bad_typeid_dtor(_this);
    if (flags & 1) MSVCRT_operator_delete(_this);
    return _this;
}

/******************************************************************
 *		??0__non_rtti_object@@QAE@ABV0@@Z (MSVCRT.@)
 */
DEFINE_THISCALL_WRAPPER(MSVCRT___non_rtti_object_copy_ctor,8)
__non_rtti_object * __thiscall MSVCRT___non_rtti_object_copy_ctor(__non_rtti_object * _this,
                                                                 const __non_rtti_object * rhs)
{
  TRACE("(%p %p)\n", _this, rhs);
  MSVCRT_bad_typeid_copy_ctor(_this, rhs);
  _this->vtable = &MSVCRT___non_rtti_object_vtable;
  return _this;
}

/******************************************************************
 *		??0__non_rtti_object@@QAE@PBD@Z (MSVCRT.@)
 */
DEFINE_THISCALL_WRAPPER(MSVCRT___non_rtti_object_ctor,8)
__non_rtti_object * __thiscall MSVCRT___non_rtti_object_ctor(__non_rtti_object * _this,
                                                            const char * name)
{
  TRACE("(%p %s)\n", _this, name);
  EXCEPTION_ctor(_this, &name);
  _this->vtable = &MSVCRT___non_rtti_object_vtable;
  return _this;
}

/******************************************************************
 *		??1__non_rtti_object@@UAE@XZ (MSVCRT.@)
 */
DEFINE_THISCALL_WRAPPER(MSVCRT___non_rtti_object_dtor,4)
void __thiscall MSVCRT___non_rtti_object_dtor(__non_rtti_object * _this)
{
  TRACE("(%p)\n", _this);
  MSVCRT_bad_typeid_dtor(_this);
}

/******************************************************************
 *		??4__non_rtti_object@@QAEAAV0@ABV0@@Z (MSVCRT.@)
 */
DEFINE_THISCALL_WRAPPER(MSVCRT___non_rtti_object_opequals,8)
__non_rtti_object * __thiscall MSVCRT___non_rtti_object_opequals(__non_rtti_object * _this,
                                                                const __non_rtti_object *rhs)
{
  TRACE("(%p %p)\n", _this, rhs);
  MSVCRT_bad_typeid_opequals(_this, rhs);
  return _this;
}

/******************************************************************
 *		??_E__non_rtti_object@@UAEPAXI@Z (MSVCRT.@)
 */
DEFINE_THISCALL_WRAPPER(MSVCRT___non_rtti_object_vector_dtor,8)
void * __thiscall MSVCRT___non_rtti_object_vector_dtor(__non_rtti_object * _this, unsigned int flags)
{
    TRACE("(%p %x)\n", _this, flags);
    if (flags & 2)
    {
        /* we have an array, with the number of elements stored before the first object */
        INT_PTR i, *ptr = (INT_PTR *)_this - 1;

        for (i = *ptr - 1; i >= 0; i--) MSVCRT___non_rtti_object_dtor(_this + i);
        MSVCRT_operator_delete(ptr);
    }
    else
    {
        MSVCRT___non_rtti_object_dtor(_this);
        if (flags & 1) MSVCRT_operator_delete(_this);
    }
    return _this;
}

/******************************************************************
 *		??_G__non_rtti_object@@UAEPAXI@Z (MSVCRT.@)
 */
DEFINE_THISCALL_WRAPPER(MSVCRT___non_rtti_object_scalar_dtor,8)
void * __thiscall MSVCRT___non_rtti_object_scalar_dtor(__non_rtti_object * _this, unsigned int flags)
{
  TRACE("(%p %x)\n", _this, flags);
  MSVCRT___non_rtti_object_dtor(_this);
  if (flags & 1) MSVCRT_operator_delete(_this);
  return _this;
}

/******************************************************************
 *		??0bad_cast@@AAE@PBQBD@Z (MSVCRT.@)
 *		??0bad_cast@@QAE@ABQBD@Z (MSVCRT.@)
 */
DEFINE_THISCALL_WRAPPER(MSVCRT_bad_cast_ctor,8)
bad_cast * __thiscall MSVCRT_bad_cast_ctor(bad_cast * _this, const char ** name)
{
  TRACE("(%p %s)\n", _this, *name);
  EXCEPTION_ctor(_this, name);
  _this->vtable = &MSVCRT_bad_cast_vtable;
  return _this;
}

/******************************************************************
 *		??0bad_cast@@QAE@ABV0@@Z (MSVCRT.@)
 */
DEFINE_THISCALL_WRAPPER(MSVCRT_bad_cast_copy_ctor,8)
bad_cast * __thiscall MSVCRT_bad_cast_copy_ctor(bad_cast * _this, const bad_cast * rhs)
{
  TRACE("(%p %p)\n", _this, rhs);
  MSVCRT_exception_copy_ctor(_this, rhs);
  _this->vtable = &MSVCRT_bad_cast_vtable;
  return _this;
}

/******************************************************************
 *		??0bad_cast@@QAE@PBD@Z (MSVCRT.@)
 */
DEFINE_THISCALL_WRAPPER(MSVCRT_bad_cast_ctor_charptr,8)
bad_cast * __thiscall MSVCRT_bad_cast_ctor_charptr(bad_cast * _this, const char * name)
{
  TRACE("(%p %s)\n", _this, name);
  EXCEPTION_ctor(_this, &name);
  _this->vtable = &MSVCRT_bad_cast_vtable;
  return _this;
}

/******************************************************************
 *		??_Fbad_cast@@QAEXXZ (MSVCRT.@)
 */
DEFINE_THISCALL_WRAPPER(MSVCRT_bad_cast_default_ctor,4)
bad_cast * __thiscall MSVCRT_bad_cast_default_ctor(bad_cast * _this)
{
  return MSVCRT_bad_cast_ctor_charptr( _this, "bad cast" );
}

/******************************************************************
 *		??1bad_cast@@UAE@XZ (MSVCRT.@)
 */
DEFINE_THISCALL_WRAPPER(MSVCRT_bad_cast_dtor,4)
void __thiscall MSVCRT_bad_cast_dtor(bad_cast * _this)
{
  TRACE("(%p)\n", _this);
  MSVCRT_exception_dtor(_this);
}

/******************************************************************
 *		??4bad_cast@@QAEAAV0@ABV0@@Z (MSVCRT.@)
 */
DEFINE_THISCALL_WRAPPER(MSVCRT_bad_cast_opequals,8)
bad_cast * __thiscall MSVCRT_bad_cast_opequals(bad_cast * _this, const bad_cast * rhs)
{
  TRACE("(%p %p)\n", _this, rhs);
  MSVCRT_exception_opequals(_this, rhs);
  return _this;
}

/******************************************************************
 *              ??_Ebad_cast@@UAEPAXI@Z (MSVCRT.@)
 */
DEFINE_THISCALL_WRAPPER(MSVCRT_bad_cast_vector_dtor,8)
void * __thiscall MSVCRT_bad_cast_vector_dtor(bad_cast * _this, unsigned int flags)
{
    TRACE("(%p %x)\n", _this, flags);
    if (flags & 2)
    {
        /* we have an array, with the number of elements stored before the first object */
        INT_PTR i, *ptr = (INT_PTR *)_this - 1;

        for (i = *ptr - 1; i >= 0; i--) MSVCRT_bad_cast_dtor(_this + i);
        MSVCRT_operator_delete(ptr);
    }
    else
    {
        MSVCRT_bad_cast_dtor(_this);
        if (flags & 1) MSVCRT_operator_delete(_this);
    }
    return _this;
}

/******************************************************************
 *		??_Gbad_cast@@UAEPAXI@Z (MSVCRT.@)
 */
DEFINE_THISCALL_WRAPPER(MSVCRT_bad_cast_scalar_dtor,8)
void * __thiscall MSVCRT_bad_cast_scalar_dtor(bad_cast * _this, unsigned int flags)
{
  TRACE("(%p %x)\n", _this, flags);
  MSVCRT_bad_cast_dtor(_this);
  if (flags & 1) MSVCRT_operator_delete(_this);
  return _this;
}

/******************************************************************
 *		??8type_info@@QBEHABV0@@Z (MSVCRT.@)
 */
DEFINE_THISCALL_WRAPPER(MSVCRT_type_info_opequals_equals,8)
int __thiscall MSVCRT_type_info_opequals_equals(type_info * _this, const type_info * rhs)
{
    int ret = !strcmp(_this->mangled + 1, rhs->mangled + 1);
    TRACE("(%p %p) returning %d\n", _this, rhs, ret);
    return ret;
}

/******************************************************************
 *		??9type_info@@QBEHABV0@@Z (MSVCRT.@)
 */
DEFINE_THISCALL_WRAPPER(MSVCRT_type_info_opnot_equals,8)
int __thiscall MSVCRT_type_info_opnot_equals(type_info * _this, const type_info * rhs)
{
    int ret = !!strcmp(_this->mangled + 1, rhs->mangled + 1);
    TRACE("(%p %p) returning %d\n", _this, rhs, ret);
    return ret;
}

/******************************************************************
 *		?before@type_info@@QBEHABV1@@Z (MSVCRT.@)
 */
DEFINE_THISCALL_WRAPPER(MSVCRT_type_info_before,8)
int __thiscall MSVCRT_type_info_before(type_info * _this, const type_info * rhs)
{
    int ret = strcmp(_this->mangled + 1, rhs->mangled + 1) < 0;
    TRACE("(%p %p) returning %d\n", _this, rhs, ret);
    return ret;
}

/******************************************************************
 *		??1type_info@@UAE@XZ (MSVCRT.@)
 */
DEFINE_THISCALL_WRAPPER(MSVCRT_type_info_dtor,4)
void __thiscall MSVCRT_type_info_dtor(type_info * _this)
{
  TRACE("(%p)\n", _this);
  MSVCRT_free(_this->name);
}

/******************************************************************
 *		?name@type_info@@QBEPBDXZ (MSVCRT.@)
 */
DEFINE_THISCALL_WRAPPER(MSVCRT_type_info_name,4)
const char * __thiscall MSVCRT_type_info_name(type_info * _this)
{
  if (!_this->name)
  {
    /* Create and set the demangled name */
    /* Note: mangled name in type_info struct always starts with a '.', while
     * it isn't valid for mangled name.
     * Is this '.' really part of the mangled name, or has it some other meaning ?
     */
    char* name = __unDName(0, _this->mangled + 1, 0,
                           MSVCRT_malloc, MSVCRT_free, UNDNAME_NO_ARGUMENTS | UNDNAME_32_BIT_DECODE);
    if (name)
    {
      unsigned int len = strlen(name);

      /* It seems _unDName may leave blanks at the end of the demangled name */
      while (len && name[--len] == ' ')
        name[len] = '\0';

      if (InterlockedCompareExchangePointer((void**)&_this->name, name, NULL))
      {
        /* Another thread set this member since we checked above - use it */
        MSVCRT_free(name);
      }
    }
  }
  TRACE("(%p) returning %s\n", _this, _this->name);
  return _this->name;
}

/******************************************************************
 *		?raw_name@type_info@@QBEPBDXZ (MSVCRT.@)
 */
DEFINE_THISCALL_WRAPPER(MSVCRT_type_info_raw_name,4)
const char * __thiscall MSVCRT_type_info_raw_name(type_info * _this)
{
  TRACE("(%p) returning %s\n", _this, _this->mangled);
  return _this->mangled;
}

/* Unexported */
DEFINE_THISCALL_WRAPPER(MSVCRT_type_info_vector_dtor,8)
void * __thiscall MSVCRT_type_info_vector_dtor(type_info * _this, unsigned int flags)
{
    TRACE("(%p %x)\n", _this, flags);
    if (flags & 2)
    {
        /* we have an array, with the number of elements stored before the first object */
        INT_PTR i, *ptr = (INT_PTR *)_this - 1;

        for (i = *ptr - 1; i >= 0; i--) MSVCRT_type_info_dtor(_this + i);
        MSVCRT_operator_delete(ptr);
    }
    else
    {
        MSVCRT_type_info_dtor(_this);
        if (flags & 1) MSVCRT_operator_delete(_this);
    }
    return _this;
}

#ifndef __GNUC__
void __asm_dummy_vtables(void) {
#endif

__ASM_VTABLE(type_info,
        VTABLE_ADD_FUNC(MSVCRT_type_info_vector_dtor));
__ASM_VTABLE(exception,
        VTABLE_ADD_FUNC(MSVCRT_exception_vector_dtor)
        VTABLE_ADD_FUNC(MSVCRT_what_exception));
__ASM_VTABLE(bad_typeid,
        VTABLE_ADD_FUNC(MSVCRT_bad_typeid_vector_dtor)
        VTABLE_ADD_FUNC(MSVCRT_what_exception));
__ASM_VTABLE(bad_cast,
        VTABLE_ADD_FUNC(MSVCRT_bad_cast_vector_dtor)
        VTABLE_ADD_FUNC(MSVCRT_what_exception));
__ASM_VTABLE(__non_rtti_object,
        VTABLE_ADD_FUNC(MSVCRT___non_rtti_object_vector_dtor)
        VTABLE_ADD_FUNC(MSVCRT_what_exception));

#ifndef __GNUC__
}
#endif

DEFINE_RTTI_DATA0( type_info, 0, ".?AVtype_info@@" )
DEFINE_RTTI_DATA0( exception, 0, ".?AVexception@@" )
DEFINE_RTTI_DATA1( bad_typeid, 0, &exception_rtti_base_descriptor, ".?AVbad_typeid@@" )
DEFINE_RTTI_DATA1( bad_cast, 0, &exception_rtti_base_descriptor, ".?AVbad_cast@@" )
DEFINE_RTTI_DATA2( __non_rtti_object, 0, &bad_typeid_rtti_base_descriptor, &exception_rtti_base_descriptor, ".?AV__non_rtti_object@@" )

DEFINE_EXCEPTION_TYPE_INFO( exception, 0, NULL, NULL )
DEFINE_EXCEPTION_TYPE_INFO( bad_typeid, 1, &exception_cxx_type_info, NULL )
DEFINE_EXCEPTION_TYPE_INFO( bad_cast, 1, &exception_cxx_type_info, NULL )
DEFINE_EXCEPTION_TYPE_INFO( __non_rtti_object, 2, &bad_typeid_cxx_type_info, &exception_cxx_type_info )

void msvcrt_init_exception(void *base)
{
#ifdef __x86_64__
    init_type_info_rtti(base);
    init_exception_rtti(base);
    init_bad_typeid_rtti(base);
    init_bad_cast_rtti(base);
    init___non_rtti_object_rtti(base);

    init_exception_cxx(base);
    init_bad_typeid_cxx(base);
    init_bad_cast_cxx(base);
    init___non_rtti_object_cxx(base);
#endif
}


/******************************************************************
 *		?set_terminate@@YAP6AXXZP6AXXZ@Z (MSVCRT.@)
 *
 * Install a handler to be called when terminate() is called.
 *
 * PARAMS
 *  func [I] Handler function to install
 *
 * RETURNS
 *  The previously installed handler function, if any.
 */
MSVCRT_terminate_function CDECL MSVCRT_set_terminate(MSVCRT_terminate_function func)
{
    thread_data_t *data = msvcrt_get_thread_data();
    MSVCRT_terminate_function previous = data->terminate_handler;
    TRACE("(%p) returning %p\n",func,previous);
    data->terminate_handler = func;
    return previous;
}

/******************************************************************
 *              _get_terminate (MSVCRT.@)
 */
MSVCRT_terminate_function CDECL MSVCRT__get_terminate(void)
{
    thread_data_t *data = msvcrt_get_thread_data();
    TRACE("returning %p\n", data->terminate_handler);
    return data->terminate_handler;
}

/******************************************************************
 *		?set_unexpected@@YAP6AXXZP6AXXZ@Z (MSVCRT.@)
 *
 * Install a handler to be called when unexpected() is called.
 *
 * PARAMS
 *  func [I] Handler function to install
 *
 * RETURNS
 *  The previously installed handler function, if any.
 */
MSVCRT_unexpected_function CDECL MSVCRT_set_unexpected(MSVCRT_unexpected_function func)
{
    thread_data_t *data = msvcrt_get_thread_data();
    MSVCRT_unexpected_function previous = data->unexpected_handler;
    TRACE("(%p) returning %p\n",func,previous);
    data->unexpected_handler = func;
    return previous;
}

/******************************************************************
 *              _get_unexpected (MSVCRT.@)
 */
MSVCRT_unexpected_function CDECL MSVCRT__get_unexpected(void)
{
    thread_data_t *data = msvcrt_get_thread_data();
    TRACE("returning %p\n", data->unexpected_handler);
    return data->unexpected_handler;
}

/******************************************************************
 *              ?_set_se_translator@@YAP6AXIPAU_EXCEPTION_POINTERS@@@ZP6AXI0@Z@Z  (MSVCRT.@)
 */
MSVCRT__se_translator_function CDECL MSVCRT__set_se_translator(MSVCRT__se_translator_function func)
{
    thread_data_t *data = msvcrt_get_thread_data();
    MSVCRT__se_translator_function previous = data->se_translator;
    TRACE("(%p) returning %p\n",func,previous);
    data->se_translator = func;
    return previous;
}

/******************************************************************
 *		?terminate@@YAXXZ (MSVCRT.@)
 *
 * Default handler for an unhandled exception.
 *
 * PARAMS
 *  None.
 *
 * RETURNS
 *  This function does not return. Either control resumes from any
 *  handler installed by calling set_terminate(), or (by default) abort()
 *  is called.
 */
void CDECL MSVCRT_terminate(void)
{
    thread_data_t *data = msvcrt_get_thread_data();
    if (data->terminate_handler) data->terminate_handler();
    MSVCRT_abort();
}

/******************************************************************
 *		?unexpected@@YAXXZ (MSVCRT.@)
 */
void CDECL MSVCRT_unexpected(void)
{
    thread_data_t *data = msvcrt_get_thread_data();
    if (data->unexpected_handler) data->unexpected_handler();
    MSVCRT_terminate();
}


/******************************************************************
 *		__RTtypeid (MSVCRT.@)
 *
 * Retrieve the Run Time Type Information (RTTI) for a C++ object.
 *
 * PARAMS
 *  cppobj [I] C++ object to get type information for.
 *
 * RETURNS
 *  Success: A type_info object describing cppobj.
 *  Failure: If the object to be cast has no RTTI, a __non_rtti_object
 *           exception is thrown. If cppobj is NULL, a bad_typeid exception
 *           is thrown. In either case, this function does not return.
 *
 * NOTES
 *  This function is usually called by compiler generated code as a result
 *  of using one of the C++ dynamic cast statements.
 */
#ifndef __x86_64__
const type_info* CDECL MSVCRT___RTtypeid(void *cppobj)
{
    const type_info *ret;

    if (!cppobj)
    {
        bad_typeid e;
        MSVCRT_bad_typeid_ctor( &e, "Attempted a typeid of NULL pointer!" );
        _CxxThrowException( &e, &bad_typeid_exception_type );
        return NULL;
    }

    __TRY
    {
        const rtti_object_locator *obj_locator = get_obj_locator( cppobj );
        ret = obj_locator->type_descriptor;
    }
    __EXCEPT_PAGE_FAULT
    {
        __non_rtti_object e;
        MSVCRT___non_rtti_object_ctor( &e, "Bad read pointer - no RTTI data!" );
        _CxxThrowException( &e, &bad_typeid_exception_type );
        return NULL;
    }
    __ENDTRY
    return ret;
}

#else

const type_info* CDECL MSVCRT___RTtypeid(void *cppobj)
{
    const type_info *ret;

    if (!cppobj)
    {
        bad_typeid e;
        MSVCRT_bad_typeid_ctor( &e, "Attempted a typeid of NULL pointer!" );
        _CxxThrowException( &e, &bad_typeid_exception_type );
        return NULL;
    }

    __TRY
    {
        const rtti_object_locator *obj_locator = get_obj_locator( cppobj );
        char *base;

        if(obj_locator->signature == 0)
            base = RtlPcToFileHeader((void*)obj_locator, (void**)&base);
        else
            base = (char*)obj_locator - obj_locator->object_locator;

        ret = (type_info*)(base + obj_locator->type_descriptor);
    }
    __EXCEPT_PAGE_FAULT
    {
        __non_rtti_object e;
        MSVCRT___non_rtti_object_ctor( &e, "Bad read pointer - no RTTI data!" );
        _CxxThrowException( &e, &bad_typeid_exception_type );
        return NULL;
    }
    __ENDTRY
    return ret;
}
#endif

/******************************************************************
 *		__RTDynamicCast (MSVCRT.@)
 *
 * Dynamically cast a C++ object to one of its base classes.
 *
 * PARAMS
 *  cppobj   [I] Any C++ object to cast
 *  unknown  [I] Reserved, set to 0
 *  src      [I] type_info object describing cppobj
 *  dst      [I] type_info object describing the base class to cast to
 *  do_throw [I] TRUE = throw an exception if the cast fails, FALSE = don't
 *
 * RETURNS
 *  Success: The address of cppobj, cast to the object described by dst.
 *  Failure: NULL, If the object to be cast has no RTTI, or dst is not a
 *           valid cast for cppobj. If do_throw is TRUE, a bad_cast exception
 *           is thrown and this function does not return.
 *
 * NOTES
 *  This function is usually called by compiler generated code as a result
 *  of using one of the C++ dynamic cast statements.
 */
#ifndef __x86_64__
void* CDECL MSVCRT___RTDynamicCast(void *cppobj, int unknown,
                                   type_info *src, type_info *dst,
                                   int do_throw)
{
    void *ret;

    if (!cppobj) return NULL;

    TRACE("obj: %p unknown: %d src: %p %s dst: %p %s do_throw: %d)\n",
          cppobj, unknown, src, dbgstr_type_info(src), dst, dbgstr_type_info(dst), do_throw);

    /* To cast an object at runtime:
     * 1.Find out the true type of the object from the typeinfo at vtable[-1]
     * 2.Search for the destination type in the class hierarchy
     * 3.If destination type is found, return base object address + dest offset
     *   Otherwise, fail the cast
     *
     * FIXME: the unknown parameter doesn't seem to be used for anything
     */
    __TRY
    {
        int i;
        const rtti_object_locator *obj_locator = get_obj_locator( cppobj );
        const rtti_object_hierarchy *obj_bases = obj_locator->type_hierarchy;
        const rtti_base_descriptor * const* base_desc = obj_bases->base_classes->bases;

        if (TRACE_ON(msvcrt)) dump_obj_locator(obj_locator);

        ret = NULL;
        for (i = 0; i < obj_bases->array_len; i++)
        {
            const type_info *typ = base_desc[i]->type_descriptor;

            if (!strcmp(typ->mangled, dst->mangled))
            {
                /* compute the correct this pointer for that base class */
                void *this_ptr = (char *)cppobj - obj_locator->base_class_offset;
                ret = get_this_pointer( &base_desc[i]->offsets, this_ptr );
                break;
            }
        }
        /* VC++ sets do_throw to 1 when the result of a dynamic_cast is assigned
         * to a reference, since references cannot be NULL.
         */
        if (!ret && do_throw)
        {
            const char *msg = "Bad dynamic_cast!";
            bad_cast e;
            MSVCRT_bad_cast_ctor( &e, &msg );
            _CxxThrowException( &e, &bad_cast_exception_type );
        }
    }
    __EXCEPT_PAGE_FAULT
    {
        __non_rtti_object e;
        MSVCRT___non_rtti_object_ctor( &e, "Access violation - no RTTI data!" );
        _CxxThrowException( &e, &bad_typeid_exception_type );
        return NULL;
    }
    __ENDTRY
    return ret;
}

#else

void* CDECL MSVCRT___RTDynamicCast(void *cppobj, int unknown,
        type_info *src, type_info *dst,
        int do_throw)
{
    void *ret;

    if (!cppobj) return NULL;

    TRACE("obj: %p unknown: %d src: %p %s dst: %p %s do_throw: %d)\n",
            cppobj, unknown, src, dbgstr_type_info(src), dst, dbgstr_type_info(dst), do_throw);

    __TRY
    {
        int i;
        const rtti_object_locator *obj_locator = get_obj_locator( cppobj );
        const rtti_object_hierarchy *obj_bases;
        const rtti_base_array *base_array;
        char *base;

        if (TRACE_ON(msvcrt)) dump_obj_locator(obj_locator);

        if(obj_locator->signature == 0)
            base = RtlPcToFileHeader((void*)obj_locator, (void**)&base);
        else
            base = (char*)obj_locator - obj_locator->object_locator;

        obj_bases = (const rtti_object_hierarchy*)(base + obj_locator->type_hierarchy);
        base_array = (const rtti_base_array*)(base + obj_bases->base_classes);

        ret = NULL;
        for (i = 0; i < obj_bases->array_len; i++)
        {
            const rtti_base_descriptor *base_desc = (const rtti_base_descriptor*)(base + base_array->bases[i]);
            const type_info *typ = (const type_info*)(base + base_desc->type_descriptor);

            if (!strcmp(typ->mangled, dst->mangled))
            {
                void *this_ptr = (char *)cppobj - obj_locator->base_class_offset;
                ret = get_this_pointer( &base_desc->offsets, this_ptr );
                break;
            }
        }
        if (!ret && do_throw)
        {
            const char *msg = "Bad dynamic_cast!";
            bad_cast e;
            MSVCRT_bad_cast_ctor( &e, &msg );
            _CxxThrowException( &e, &bad_cast_exception_type );
        }
    }
    __EXCEPT_PAGE_FAULT
    {
        __non_rtti_object e;
        MSVCRT___non_rtti_object_ctor( &e, "Access violation - no RTTI data!" );
        _CxxThrowException( &e, &bad_typeid_exception_type );
        return NULL;
    }
    __ENDTRY
    return ret;
}
#endif


/******************************************************************
 *		__RTCastToVoid (MSVCRT.@)
 *
 * Dynamically cast a C++ object to a void*.
 *
 * PARAMS
 *  cppobj [I] The C++ object to cast
 *
 * RETURNS
 *  Success: The base address of the object as a void*.
 *  Failure: NULL, if cppobj is NULL or has no RTTI.
 *
 * NOTES
 *  This function is usually called by compiler generated code as a result
 *  of using one of the C++ dynamic cast statements.
 */
void* CDECL MSVCRT___RTCastToVoid(void *cppobj)
{
    void *ret;

    if (!cppobj) return NULL;

    __TRY
    {
        const rtti_object_locator *obj_locator = get_obj_locator( cppobj );
        ret = (char *)cppobj - obj_locator->base_class_offset;
    }
    __EXCEPT_PAGE_FAULT
    {
        __non_rtti_object e;
        MSVCRT___non_rtti_object_ctor( &e, "Access violation - no RTTI data!" );
        _CxxThrowException( &e, &bad_typeid_exception_type );
        return NULL;
    }
    __ENDTRY
    return ret;
}


/*********************************************************************
 *		_CxxThrowException (MSVCRT.@)
 */
void WINAPI _CxxThrowException( exception *object, const cxx_exception_type *type )
{
    ULONG_PTR args[3];

    args[0] = CXX_FRAME_MAGIC_VC6;
    args[1] = (ULONG_PTR)object;
    args[2] = (ULONG_PTR)type;
    RaiseException( CXX_EXCEPTION, EH_NONCONTINUABLE, 3, args );
}
