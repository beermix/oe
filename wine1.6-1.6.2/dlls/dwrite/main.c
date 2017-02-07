/*
 *    DWrite
 *
 * Copyright 2012 Nikolay Sivov for CodeWeavers
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

#define COBJMACROS

#include <stdarg.h>

#include "windef.h"
#include "winbase.h"
#include "winuser.h"

#include "initguid.h"
#include "dwrite.h"

#include "dwrite_private.h"
#include "wine/debug.h"

WINE_DEFAULT_DEBUG_CHANNEL(dwrite);

BOOL WINAPI DllMain(HINSTANCE hinstDLL, DWORD reason, LPVOID reserved)
{
    switch (reason)
    {
    case DLL_WINE_PREATTACH:
        return FALSE;  /* prefer native version */
    case DLL_PROCESS_ATTACH:
        DisableThreadLibraryCalls( hinstDLL );
        break;
    case DLL_PROCESS_DETACH:
        if (reserved) break;
        release_system_fontcollection();
        break;
    }
    return TRUE;
}

struct renderingparams {
    IDWriteRenderingParams IDWriteRenderingParams_iface;
    LONG ref;

    FLOAT gamma;
    FLOAT enh_contrast;
    FLOAT cleartype_level;
    DWRITE_PIXEL_GEOMETRY geometry;
    DWRITE_RENDERING_MODE mode;
};

static inline struct renderingparams *impl_from_IDWriteRenderingParams(IDWriteRenderingParams *iface)
{
    return CONTAINING_RECORD(iface, struct renderingparams, IDWriteRenderingParams_iface);
}

static HRESULT WINAPI renderingparams_QueryInterface(IDWriteRenderingParams *iface, REFIID riid, void **obj)
{
    struct renderingparams *This = impl_from_IDWriteRenderingParams(iface);

    TRACE("(%p)->(%s %p)\n", This, debugstr_guid(riid), obj);

    if (IsEqualIID(riid, &IID_IUnknown) || IsEqualIID(riid, &IID_IDWriteRenderingParams))
    {
        *obj = iface;
        IDWriteRenderingParams_AddRef(iface);
        return S_OK;
    }

    *obj = NULL;

    return E_NOINTERFACE;
}

static ULONG WINAPI renderingparams_AddRef(IDWriteRenderingParams *iface)
{
    struct renderingparams *This = impl_from_IDWriteRenderingParams(iface);
    ULONG ref = InterlockedIncrement(&This->ref);
    TRACE("(%p)->(%d)\n", This, ref);
    return ref;
}

static ULONG WINAPI renderingparams_Release(IDWriteRenderingParams *iface)
{
    struct renderingparams *This = impl_from_IDWriteRenderingParams(iface);
    ULONG ref = InterlockedDecrement(&This->ref);

    TRACE("(%p)->(%d)\n", This, ref);

    if (!ref)
        heap_free(This);

    return ref;
}

static FLOAT WINAPI renderingparams_GetGamma(IDWriteRenderingParams *iface)
{
    struct renderingparams *This = impl_from_IDWriteRenderingParams(iface);
    TRACE("(%p)\n", This);
    return This->gamma;
}

static FLOAT WINAPI renderingparams_GetEnhancedContrast(IDWriteRenderingParams *iface)
{
    struct renderingparams *This = impl_from_IDWriteRenderingParams(iface);
    TRACE("(%p)\n", This);
    return This->enh_contrast;
}

static FLOAT WINAPI renderingparams_GetClearTypeLevel(IDWriteRenderingParams *iface)
{
    struct renderingparams *This = impl_from_IDWriteRenderingParams(iface);
    TRACE("(%p)\n", This);
    return This->cleartype_level;
}

static DWRITE_PIXEL_GEOMETRY WINAPI renderingparams_GetPixelGeometry(IDWriteRenderingParams *iface)
{
    struct renderingparams *This = impl_from_IDWriteRenderingParams(iface);
    TRACE("(%p)\n", This);
    return This->geometry;
}

static DWRITE_RENDERING_MODE WINAPI renderingparams_GetRenderingMode(IDWriteRenderingParams *iface)
{
    struct renderingparams *This = impl_from_IDWriteRenderingParams(iface);
    TRACE("(%p)\n", This);
    return This->mode;
}

static const struct IDWriteRenderingParamsVtbl renderingparamsvtbl = {
    renderingparams_QueryInterface,
    renderingparams_AddRef,
    renderingparams_Release,
    renderingparams_GetGamma,
    renderingparams_GetEnhancedContrast,
    renderingparams_GetClearTypeLevel,
    renderingparams_GetPixelGeometry,
    renderingparams_GetRenderingMode
};

static HRESULT create_renderingparams(FLOAT gamma, FLOAT enhancedContrast, FLOAT cleartype_level,
    DWRITE_PIXEL_GEOMETRY geometry, DWRITE_RENDERING_MODE mode, IDWriteRenderingParams **params)
{
    struct renderingparams *This;

    *params = NULL;

    This = heap_alloc(sizeof(struct renderingparams));
    if (!This) return E_OUTOFMEMORY;

    This->IDWriteRenderingParams_iface.lpVtbl = &renderingparamsvtbl;
    This->ref = 1;

    This->gamma = gamma;
    This->enh_contrast = enhancedContrast;
    This->cleartype_level = cleartype_level;
    This->geometry = geometry;
    This->mode = mode;

    *params = &This->IDWriteRenderingParams_iface;

    return S_OK;
}

struct localizedpair {
    WCHAR *locale;
    WCHAR *string;
};

struct localizedstrings {
    IDWriteLocalizedStrings IDWriteLocalizedStrings_iface;
    LONG ref;

    struct localizedpair *data;
    UINT32 count;
    UINT32 alloc;
};

static inline struct localizedstrings *impl_from_IDWriteLocalizedStrings(IDWriteLocalizedStrings *iface)
{
    return CONTAINING_RECORD(iface, struct localizedstrings, IDWriteLocalizedStrings_iface);
}

static HRESULT WINAPI localizedstrings_QueryInterface(IDWriteLocalizedStrings *iface, REFIID riid, void **obj)
{
    struct localizedstrings *This = impl_from_IDWriteLocalizedStrings(iface);

    TRACE("(%p)->(%s %p)\n", This, debugstr_guid(riid), obj);

    if (IsEqualIID(riid, &IID_IUnknown) || IsEqualIID(riid, &IID_IDWriteLocalizedStrings))
    {
        *obj = iface;
        IDWriteLocalizedStrings_AddRef(iface);
        return S_OK;
    }

    *obj = NULL;

    return E_NOINTERFACE;
}

static ULONG WINAPI localizedstrings_AddRef(IDWriteLocalizedStrings *iface)
{
    struct localizedstrings *This = impl_from_IDWriteLocalizedStrings(iface);
    ULONG ref = InterlockedIncrement(&This->ref);
    TRACE("(%p)->(%d)\n", This, ref);
    return ref;
}

static ULONG WINAPI localizedstrings_Release(IDWriteLocalizedStrings *iface)
{
    struct localizedstrings *This = impl_from_IDWriteLocalizedStrings(iface);
    ULONG ref = InterlockedDecrement(&This->ref);

    TRACE("(%p)->(%d)\n", This, ref);

    if (!ref) {
        unsigned int i;

        for (i = 0; i < This->count; i++) {
            heap_free(This->data[i].locale);
            heap_free(This->data[i].string);
        }

        heap_free(This->data);
        heap_free(This);
    }

    return ref;
}

static UINT32 WINAPI localizedstrings_GetCount(IDWriteLocalizedStrings *iface)
{
    struct localizedstrings *This = impl_from_IDWriteLocalizedStrings(iface);
    TRACE("(%p)\n", This);
    return This->count;
}

static HRESULT WINAPI localizedstrings_FindLocaleName(IDWriteLocalizedStrings *iface,
    WCHAR const *locale_name, UINT32 *index, BOOL *exists)
{
    struct localizedstrings *This = impl_from_IDWriteLocalizedStrings(iface);
    FIXME("(%p)->(%s %p %p): stub\n", This, debugstr_w(locale_name), index, exists);
    return E_NOTIMPL;
}

static HRESULT WINAPI localizedstrings_GetLocaleNameLength(IDWriteLocalizedStrings *iface, UINT32 index, UINT32 *length)
{
    struct localizedstrings *This = impl_from_IDWriteLocalizedStrings(iface);
    FIXME("(%p)->(%u %p): stub\n", This, index, length);
    return E_NOTIMPL;
}

static HRESULT WINAPI localizedstrings_GetLocaleName(IDWriteLocalizedStrings *iface, UINT32 index, WCHAR *locale_name, UINT32 size)
{
    struct localizedstrings *This = impl_from_IDWriteLocalizedStrings(iface);
    FIXME("(%p)->(%u %p %u): stub\n", This, index, locale_name, size);
    return E_NOTIMPL;
}

static HRESULT WINAPI localizedstrings_GetStringLength(IDWriteLocalizedStrings *iface, UINT32 index, UINT32 *length)
{
    struct localizedstrings *This = impl_from_IDWriteLocalizedStrings(iface);

    TRACE("(%p)->(%u %p)\n", This, index, length);

    if (index >= This->count) {
        *length = (UINT32)-1;
        return E_FAIL;
    }

    *length = strlenW(This->data[index].string);
    return S_OK;
}

static HRESULT WINAPI localizedstrings_GetString(IDWriteLocalizedStrings *iface, UINT32 index, WCHAR *buffer, UINT32 size)
{
    struct localizedstrings *This = impl_from_IDWriteLocalizedStrings(iface);

    TRACE("(%p)->(%u %p %u)\n", This, index, buffer, size);

    if (index >= This->count) {
        if (buffer) *buffer = 0;
        return E_FAIL;
    }

    if (size < strlenW(This->data[index].string)+1) {
        if (buffer) *buffer = 0;
        return E_NOT_SUFFICIENT_BUFFER;
    }

    strcpyW(buffer, This->data[index].string);
    return S_OK;
}

static const IDWriteLocalizedStringsVtbl localizedstringsvtbl = {
    localizedstrings_QueryInterface,
    localizedstrings_AddRef,
    localizedstrings_Release,
    localizedstrings_GetCount,
    localizedstrings_FindLocaleName,
    localizedstrings_GetLocaleNameLength,
    localizedstrings_GetLocaleName,
    localizedstrings_GetStringLength,
    localizedstrings_GetString
};

HRESULT create_localizedstrings(IDWriteLocalizedStrings **strings)
{
    struct localizedstrings *This;

    *strings = NULL;

    This = heap_alloc(sizeof(struct localizedstrings));
    if (!This) return E_OUTOFMEMORY;

    This->IDWriteLocalizedStrings_iface.lpVtbl = &localizedstringsvtbl;
    This->ref = 1;
    This->count = 0;
    This->data = heap_alloc_zero(sizeof(struct localizedpair));
    if (!This->data) {
        heap_free(This);
        return E_OUTOFMEMORY;
    }
    This->alloc = 1;

    *strings = &This->IDWriteLocalizedStrings_iface;

    return S_OK;
}

HRESULT add_localizedstring(IDWriteLocalizedStrings *iface, const WCHAR *locale, const WCHAR *string)
{
    struct localizedstrings *This = impl_from_IDWriteLocalizedStrings(iface);

    if (This->count == This->alloc) {
        This->alloc *= 2;
        This->data = heap_realloc(This->data, This->alloc*sizeof(struct localizedpair));
    }

    This->data[This->count].locale = heap_strdupW(locale);
    This->data[This->count].string = heap_strdupW(string);
    This->count++;

    return S_OK;
}

static HRESULT WINAPI dwritefactory_QueryInterface(IDWriteFactory *iface, REFIID riid, void **obj)
{
    TRACE("(%s %p)\n", debugstr_guid(riid), obj);

    if (IsEqualIID(riid, &IID_IUnknown) ||
        IsEqualIID(riid, &IID_IDWriteFactory))
    {
        *obj = iface;
        return S_OK;
    }

    *obj = NULL;

    return E_NOINTERFACE;
}

static ULONG WINAPI dwritefactory_AddRef(IDWriteFactory *iface)
{
    return 2;
}

static ULONG WINAPI dwritefactory_Release(IDWriteFactory *iface)
{
    return 1;
}

static HRESULT WINAPI dwritefactory_GetSystemFontCollection(IDWriteFactory *iface,
    IDWriteFontCollection **collection, BOOL check_for_updates)
{
    TRACE("(%p %d)\n", collection, check_for_updates);

    if (check_for_updates)
        FIXME("checking for system font updates not implemented\n");

    return get_system_fontcollection(collection);
}

static HRESULT WINAPI dwritefactory_CreateCustomFontCollection(IDWriteFactory *iface,
    IDWriteFontCollectionLoader *loader, void const *key, UINT32 key_size, IDWriteFontCollection **collection)
{
    FIXME("(%p %p %u %p): stub\n", loader, key, key_size, collection);
    return E_NOTIMPL;
}

static HRESULT WINAPI dwritefactory_RegisterFontCollectionLoader(IDWriteFactory *iface,
    IDWriteFontCollectionLoader *loader)
{
    FIXME("(%p): stub\n", loader);
    return E_NOTIMPL;
}

static HRESULT WINAPI dwritefactory_UnregisterFontCollectionLoader(IDWriteFactory *iface,
    IDWriteFontCollectionLoader *loader)
{
    FIXME("(%p): stub\n", loader);
    return E_NOTIMPL;
}

static HRESULT WINAPI dwritefactory_CreateFontFileReference(IDWriteFactory *iface,
    WCHAR const *path, FILETIME const *writetime, IDWriteFontFile **font_file)
{
    FIXME("(%s %p %p): stub\n", debugstr_w(path), writetime, font_file);
    return E_NOTIMPL;
}

static HRESULT WINAPI dwritefactory_CreateCustomFontFileReference(IDWriteFactory *iface,
    void const *reference_key, UINT32 key_size, IDWriteFontFileLoader *loader, IDWriteFontFile **font_file)
{
    FIXME("(%p %u %p %p): stub\n", reference_key, key_size, loader, font_file);
    return E_NOTIMPL;
}

static HRESULT WINAPI dwritefactory_CreateFontFace(IDWriteFactory *iface,
    DWRITE_FONT_FACE_TYPE facetype, UINT32 files_number, IDWriteFontFile* const* font_files,
    UINT32 index, DWRITE_FONT_SIMULATIONS sim_flags, IDWriteFontFace **font_face)
{
    FIXME("(%d %u %p %u 0x%x %p): stub\n", facetype, files_number, font_files, index, sim_flags, font_face);
    return E_NOTIMPL;
}

static HRESULT WINAPI dwritefactory_CreateRenderingParams(IDWriteFactory *iface, IDWriteRenderingParams **params)
{
    HMONITOR monitor;
    POINT pt;

    TRACE("(%p)\n", params);

    pt.x = pt.y = 0;
    monitor = MonitorFromPoint(pt, MONITOR_DEFAULTTOPRIMARY);
    return IDWriteFactory_CreateMonitorRenderingParams(iface, monitor, params);
}

static HRESULT WINAPI dwritefactory_CreateMonitorRenderingParams(IDWriteFactory *iface, HMONITOR monitor,
    IDWriteRenderingParams **params)
{
    static int fixme_once = 0;

    TRACE("(%p %p)\n", monitor, params);

    if (!fixme_once++)
        FIXME("(%p): monitor setting ignored\n", monitor);
    return IDWriteFactory_CreateCustomRenderingParams(iface, 0.0, 0.0, 0.0, DWRITE_PIXEL_GEOMETRY_FLAT,
        DWRITE_RENDERING_MODE_DEFAULT, params);
}

static HRESULT WINAPI dwritefactory_CreateCustomRenderingParams(IDWriteFactory *iface, FLOAT gamma, FLOAT enhancedContrast,
    FLOAT cleartype_level, DWRITE_PIXEL_GEOMETRY geometry, DWRITE_RENDERING_MODE mode, IDWriteRenderingParams **params)
{
    TRACE("(%f %f %f %d %d %p)\n", gamma, enhancedContrast, cleartype_level, geometry, mode, params);
    return create_renderingparams(gamma, enhancedContrast, cleartype_level, geometry, mode, params);
}

static HRESULT WINAPI dwritefactory_RegisterFontFileLoader(IDWriteFactory *iface, IDWriteFontFileLoader *loader)
{
    FIXME("(%p): stub\n", loader);
    return E_NOTIMPL;
}

static HRESULT WINAPI dwritefactory_UnregisterFontFileLoader(IDWriteFactory *iface, IDWriteFontFileLoader *loader)
{
    FIXME("(%p): stub\n", loader);
    return E_NOTIMPL;
}

static HRESULT WINAPI dwritefactory_CreateTextFormat(IDWriteFactory *iface, WCHAR const* family_name,
    IDWriteFontCollection *collection, DWRITE_FONT_WEIGHT weight, DWRITE_FONT_STYLE style,
    DWRITE_FONT_STRETCH stretch, FLOAT size, WCHAR const *locale, IDWriteTextFormat **format)
{
    TRACE("(%s %p %d %d %d %f %s %p)\n", debugstr_w(family_name), collection, weight, style, stretch,
        size, debugstr_w(locale), format);
    return create_textformat(family_name, collection, weight, style, stretch, size, locale, format);
}

static HRESULT WINAPI dwritefactory_CreateTypography(IDWriteFactory *iface, IDWriteTypography **typography)
{
    FIXME("(%p): stub\n", typography);
    return E_NOTIMPL;
}

static HRESULT WINAPI dwritefactory_GetGdiInterop(IDWriteFactory *iface, IDWriteGdiInterop **gdi_interop)
{
    TRACE("(%p)\n", gdi_interop);
    return get_gdiinterop(gdi_interop);
}

static HRESULT WINAPI dwritefactory_CreateTextLayout(IDWriteFactory *iface, WCHAR const* string,
    UINT32 len, IDWriteTextFormat *format, FLOAT max_width, FLOAT max_height, IDWriteTextLayout **layout)
{
    TRACE("(%s %u %p %f %f %p)\n", debugstr_w(string), len, format, max_width, max_height, layout);

    if (!format) return E_INVALIDARG;
    return create_textlayout(string, len, format, layout);
}

static HRESULT WINAPI dwritefactory_CreateGdiCompatibleTextLayout(IDWriteFactory *iface, WCHAR const* string,
    UINT32 len, IDWriteTextFormat *format, FLOAT layout_width, FLOAT layout_height, FLOAT pixels_per_dip,
    DWRITE_MATRIX const* transform, BOOL use_gdi_natural, IDWriteTextLayout **layout)
{
    FIXME("(%s:%u %p %f %f %f %p %d %p): semi-stub\n", debugstr_wn(string, len), len, format, layout_width, layout_height,
        pixels_per_dip, transform, use_gdi_natural, layout);

    if (!format) return E_INVALIDARG;
    return create_textlayout(string, len, format, layout);
}

static HRESULT WINAPI dwritefactory_CreateEllipsisTrimmingSign(IDWriteFactory *iface, IDWriteTextFormat *format,
    IDWriteInlineObject **trimming_sign)
{
    FIXME("(%p %p): stub\n", format, trimming_sign);
    return E_NOTIMPL;
}

static HRESULT WINAPI dwritefactory_CreateTextAnalyzer(IDWriteFactory *iface, IDWriteTextAnalyzer **analyzer)
{
    TRACE("(%p)\n", analyzer);
    return get_textanalyzer(analyzer);
}

static HRESULT WINAPI dwritefactory_CreateNumberSubstitution(IDWriteFactory *iface, DWRITE_NUMBER_SUBSTITUTION_METHOD method,
    WCHAR const* locale, BOOL ignore_user_override, IDWriteNumberSubstitution **substitution)
{
    FIXME("(%d %s %d %p): stub\n", method, debugstr_w(locale), ignore_user_override, substitution);
    return E_NOTIMPL;
}

static HRESULT WINAPI dwritefactory_CreateGlyphRunAnalysis(IDWriteFactory *iface, DWRITE_GLYPH_RUN const *glyph_run,
    FLOAT pixels_per_dip, DWRITE_MATRIX const* transform, DWRITE_RENDERING_MODE rendering_mode,
    DWRITE_MEASURING_MODE measuring_mode, FLOAT baseline_x, FLOAT baseline_y, IDWriteGlyphRunAnalysis **analysis)
{
    FIXME("(%p %f %p %d %d %f %f %p): stub\n", glyph_run, pixels_per_dip, transform, rendering_mode,
        measuring_mode, baseline_x, baseline_y, analysis);
    return E_NOTIMPL;
}

static const struct IDWriteFactoryVtbl dwritefactoryvtbl = {
    dwritefactory_QueryInterface,
    dwritefactory_AddRef,
    dwritefactory_Release,
    dwritefactory_GetSystemFontCollection,
    dwritefactory_CreateCustomFontCollection,
    dwritefactory_RegisterFontCollectionLoader,
    dwritefactory_UnregisterFontCollectionLoader,
    dwritefactory_CreateFontFileReference,
    dwritefactory_CreateCustomFontFileReference,
    dwritefactory_CreateFontFace,
    dwritefactory_CreateRenderingParams,
    dwritefactory_CreateMonitorRenderingParams,
    dwritefactory_CreateCustomRenderingParams,
    dwritefactory_RegisterFontFileLoader,
    dwritefactory_UnregisterFontFileLoader,
    dwritefactory_CreateTextFormat,
    dwritefactory_CreateTypography,
    dwritefactory_GetGdiInterop,
    dwritefactory_CreateTextLayout,
    dwritefactory_CreateGdiCompatibleTextLayout,
    dwritefactory_CreateEllipsisTrimmingSign,
    dwritefactory_CreateTextAnalyzer,
    dwritefactory_CreateNumberSubstitution,
    dwritefactory_CreateGlyphRunAnalysis
};

static IDWriteFactory dwritefactory = { &dwritefactoryvtbl };

HRESULT WINAPI DWriteCreateFactory(DWRITE_FACTORY_TYPE type, REFIID riid, IUnknown **factory)
{
    TRACE("(%d, %s, %p)\n", type, debugstr_guid(riid), factory);

    if (!IsEqualIID(riid, &IID_IDWriteFactory)) return E_FAIL;

    *factory = (IUnknown*)&dwritefactory;

    return S_OK;
}
