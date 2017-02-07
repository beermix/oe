/*
 * Copyright (C) 2006 Vitaliy Margolen
 * Copyright (C) 2006 Chris Robinson
 * Copyright (C) 2006 Louis Lenders
 * Copyright 2006-2007 Henri Verbeet
 * Copyright 2006-2007, 2011-2013 Stefan Dösinger for CodeWeavers
 * Copyright 2013 Henri Verbeet for CodeWeavers
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
#include <windowsx.h>
#include <initguid.h>
#include <d3d8.h>
#include "wine/test.h"

static INT screen_width;
static INT screen_height;

static HRESULT (WINAPI *ValidateVertexShader)(DWORD *, DWORD *, DWORD *, int, DWORD *);
static HRESULT (WINAPI *ValidatePixelShader)(DWORD *, DWORD *, int, DWORD *);
static IDirect3D8 *(WINAPI *pDirect3DCreate8)(UINT);

static BOOL (WINAPI *pGetCursorInfo)(PCURSORINFO);

static const DWORD simple_vs[] = {0xFFFE0101,       /* vs_1_1               */
    0x00000009, 0xC0010000, 0x90E40000, 0xA0E40000, /* dp4 oPos.x, v0, c0   */
    0x00000009, 0xC0020000, 0x90E40000, 0xA0E40001, /* dp4 oPos.y, v0, c1   */
    0x00000009, 0xC0040000, 0x90E40000, 0xA0E40002, /* dp4 oPos.z, v0, c2   */
    0x00000009, 0xC0080000, 0x90E40000, 0xA0E40003, /* dp4 oPos.w, v0, c3   */
    0x0000FFFF};                                    /* END                  */
static const DWORD simple_ps[] = {0xFFFF0101,                               /* ps_1_1                       */
    0x00000051, 0xA00F0001, 0x3F800000, 0x00000000, 0x00000000, 0x00000000, /* def c1 = 1.0, 0.0, 0.0, 0.0  */
    0x00000042, 0xB00F0000,                                                 /* tex t0                       */
    0x00000008, 0x800F0000, 0xA0E40001, 0xA0E40000,                         /* dp3 r0, c1, c0               */
    0x00000005, 0x800F0000, 0x90E40000, 0x80E40000,                         /* mul r0, v0, r0               */
    0x00000005, 0x800F0000, 0xB0E40000, 0x80E40000,                         /* mul r0, t0, r0               */
    0x0000FFFF};                                                            /* END                          */

static int get_refcount(IUnknown *object)
{
    IUnknown_AddRef( object );
    return IUnknown_Release( object );
}

/* try to make sure pending X events have been processed before continuing */
static void flush_events(void)
{
    MSG msg;
    int diff = 200;
    int min_timeout = 100;
    DWORD time = GetTickCount() + diff;

    while (diff > 0)
    {
        if (MsgWaitForMultipleObjects( 0, NULL, FALSE, min_timeout, QS_ALLINPUT ) == WAIT_TIMEOUT) break;
        while (PeekMessage( &msg, 0, 0, 0, PM_REMOVE )) DispatchMessage( &msg );
        diff = time - GetTickCount();
    }
}

static IDirect3DDevice8 *create_device(IDirect3D8 *d3d8, HWND device_window, HWND focus_window, BOOL windowed)
{
    D3DPRESENT_PARAMETERS present_parameters = {0};
    IDirect3DDevice8 *device;

    present_parameters.Windowed = windowed;
    present_parameters.hDeviceWindow = device_window;
    present_parameters.SwapEffect = D3DSWAPEFFECT_DISCARD;
    present_parameters.BackBufferWidth = screen_width;
    present_parameters.BackBufferHeight = screen_height;
    present_parameters.BackBufferFormat = D3DFMT_A8R8G8B8;
    present_parameters.EnableAutoDepthStencil = TRUE;
    present_parameters.AutoDepthStencilFormat = D3DFMT_D24S8;

    if (SUCCEEDED(IDirect3D8_CreateDevice(d3d8, D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL, focus_window,
            D3DCREATE_HARDWARE_VERTEXPROCESSING, &present_parameters, &device))) return device;

    present_parameters.AutoDepthStencilFormat = D3DFMT_D16;
    if (SUCCEEDED(IDirect3D8_CreateDevice(d3d8, D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL, focus_window,
            D3DCREATE_HARDWARE_VERTEXPROCESSING, &present_parameters, &device))) return device;

    if (SUCCEEDED(IDirect3D8_CreateDevice(d3d8, D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL, focus_window,
            D3DCREATE_SOFTWARE_VERTEXPROCESSING, &present_parameters, &device))) return device;

    return NULL;
}

static HRESULT reset_device(IDirect3DDevice8 *device, HWND device_window, BOOL windowed)
{
    D3DPRESENT_PARAMETERS present_parameters = {0};

    present_parameters.Windowed = windowed;
    present_parameters.hDeviceWindow = device_window;
    present_parameters.SwapEffect = D3DSWAPEFFECT_DISCARD;
    present_parameters.BackBufferWidth = screen_width;
    present_parameters.BackBufferHeight = screen_height;
    present_parameters.BackBufferFormat = D3DFMT_A8R8G8B8;
    present_parameters.EnableAutoDepthStencil = TRUE;
    present_parameters.AutoDepthStencilFormat = D3DFMT_D24S8;

    return IDirect3DDevice8_Reset(device, &present_parameters);
}

#define CHECK_CALL(r,c,d,rc) \
    if (SUCCEEDED(r)) {\
        int tmp1 = get_refcount( (IUnknown *)d ); \
        int rc_new = rc; \
        ok(tmp1 == rc_new, "Invalid refcount. Expected %d got %d\n", rc_new, tmp1); \
    } else {\
        trace("%s failed: %#08x\n", c, r); \
    }

#define CHECK_RELEASE(obj,d,rc) \
    if (obj) { \
        int tmp1, rc_new = rc; \
        IUnknown_Release( (IUnknown*)obj ); \
        tmp1 = get_refcount( (IUnknown *)d ); \
        ok(tmp1 == rc_new, "Invalid refcount. Expected %d got %d\n", rc_new, tmp1); \
    }

#define CHECK_REFCOUNT(obj,rc) \
    { \
        int rc_new = rc; \
        int count = get_refcount( (IUnknown *)obj ); \
        ok(count == rc_new, "Invalid refcount. Expected %d got %d\n", rc_new, count); \
    }

#define CHECK_RELEASE_REFCOUNT(obj,rc) \
    { \
        int rc_new = rc; \
        int count = IUnknown_Release( (IUnknown *)obj ); \
        ok(count == rc_new, "Invalid refcount. Expected %d got %d\n", rc_new, count); \
    }

#define CHECK_ADDREF_REFCOUNT(obj,rc) \
    { \
        int rc_new = rc; \
        int count = IUnknown_AddRef( (IUnknown *)obj ); \
        ok(count == rc_new, "Invalid refcount. Expected %d got %d\n", rc_new, count); \
    }

#define CHECK_SURFACE_CONTAINER(obj,iid,expected) \
    { \
        void *container_ptr = (void *)0x1337c0d3; \
        hr = IDirect3DSurface8_GetContainer(obj, &iid, &container_ptr); \
        ok(SUCCEEDED(hr) && container_ptr == expected, "GetContainer returned: hr %#08x, container_ptr %p. " \
            "Expected hr %#08x, container_ptr %p\n", hr, container_ptr, S_OK, expected); \
        if (container_ptr && container_ptr != (void *)0x1337c0d3) IUnknown_Release((IUnknown *)container_ptr); \
    }

static void check_mipmap_levels(IDirect3DDevice8 *device, UINT width, UINT height, UINT count)
{
    IDirect3DBaseTexture8* texture = NULL;
    HRESULT hr = IDirect3DDevice8_CreateTexture( device, width, height, 0, 0,
            D3DFMT_X8R8G8B8, D3DPOOL_DEFAULT, (IDirect3DTexture8**) &texture );

    if (SUCCEEDED(hr)) {
        DWORD levels = IDirect3DBaseTexture8_GetLevelCount(texture);
        ok(levels == count, "Invalid level count. Expected %d got %u\n", count, levels);
    } else
        trace("CreateTexture failed: %#08x\n", hr);

    if (texture) IDirect3DBaseTexture8_Release( texture );
}

static void test_mipmap_levels(void)
{

    HRESULT               hr;
    HWND                  hwnd = NULL;

    IDirect3D8            *pD3d = NULL;
    IDirect3DDevice8      *pDevice = NULL;
    D3DPRESENT_PARAMETERS d3dpp;
    D3DDISPLAYMODE        d3ddm;

    pD3d = pDirect3DCreate8( D3D_SDK_VERSION );
    ok(pD3d != NULL, "Failed to create IDirect3D8 object\n");
    hwnd = CreateWindow( "d3d8_test_wc", "d3d8_test", WS_OVERLAPPEDWINDOW, 100, 100, 160, 160, NULL, NULL, NULL, NULL );
    ok(hwnd != NULL, "Failed to create window\n");
    if (!pD3d || !hwnd) goto cleanup;

    IDirect3D8_GetAdapterDisplayMode( pD3d, D3DADAPTER_DEFAULT, &d3ddm );
    ZeroMemory( &d3dpp, sizeof(d3dpp) );
    d3dpp.Windowed         = TRUE;
    d3dpp.SwapEffect       = D3DSWAPEFFECT_DISCARD;
    d3dpp.BackBufferFormat = d3ddm.Format;

    hr = IDirect3D8_CreateDevice( pD3d, D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL, hwnd,
                                  D3DCREATE_SOFTWARE_VERTEXPROCESSING, &d3dpp, &pDevice );
    if(FAILED(hr))
    {
        skip("could not create device, IDirect3D8_CreateDevice returned %#08x\n", hr);
        goto cleanup;
    }

    check_mipmap_levels(pDevice, 32, 32, 6);
    check_mipmap_levels(pDevice, 256, 1, 9);
    check_mipmap_levels(pDevice, 1, 256, 9);
    check_mipmap_levels(pDevice, 1, 1, 1);

cleanup:
    if (pDevice)
    {
        UINT refcount = IDirect3DDevice8_Release( pDevice );
        ok(!refcount, "Device has %u references left.\n", refcount);
    }
    if (pD3d) IDirect3D8_Release( pD3d );
    DestroyWindow( hwnd );
}

static void test_swapchain(void)
{
    HRESULT                      hr;
    HWND                         hwnd               = NULL;
    IDirect3D8                  *pD3d               = NULL;
    IDirect3DDevice8            *pDevice            = NULL;
    IDirect3DSwapChain8         *swapchain1         = NULL;
    IDirect3DSwapChain8         *swapchain2         = NULL;
    IDirect3DSwapChain8         *swapchain3         = NULL;
    IDirect3DSurface8           *backbuffer         = NULL;
    D3DPRESENT_PARAMETERS        d3dpp;
    D3DDISPLAYMODE               d3ddm;

    pD3d = pDirect3DCreate8( D3D_SDK_VERSION );
    ok(pD3d != NULL, "Failed to create IDirect3D8 object\n");
    hwnd = CreateWindow( "d3d8_test_wc", "d3d8_test", WS_OVERLAPPEDWINDOW, 100, 100, 160, 160, NULL, NULL, NULL, NULL );
    ok(hwnd != NULL, "Failed to create window\n");
    if (!pD3d || !hwnd) goto cleanup;

    IDirect3D8_GetAdapterDisplayMode( pD3d, D3DADAPTER_DEFAULT, &d3ddm );
    ZeroMemory( &d3dpp, sizeof(d3dpp) );
    d3dpp.Windowed         = TRUE;
    d3dpp.SwapEffect       = D3DSWAPEFFECT_DISCARD;
    d3dpp.BackBufferFormat = d3ddm.Format;
    d3dpp.BackBufferCount  = 0;

    hr = IDirect3D8_CreateDevice( pD3d, D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL, hwnd,
                                  D3DCREATE_SOFTWARE_VERTEXPROCESSING, &d3dpp, &pDevice );
    if(FAILED(hr))
    {
        skip("could not create device, IDirect3D8_CreateDevice returned %#08x\n", hr);
        goto cleanup;
    }

    /* Check if the back buffer count was modified */
    ok(d3dpp.BackBufferCount == 1, "The back buffer count in the presentparams struct is %d\n", d3dpp.BackBufferCount);

    /* Create a bunch of swapchains */
    d3dpp.BackBufferCount = 0;
    hr = IDirect3DDevice8_CreateAdditionalSwapChain(pDevice, &d3dpp, &swapchain1);
    ok(SUCCEEDED(hr), "Failed to create a swapchain (%#08x)\n", hr);
    ok(d3dpp.BackBufferCount == 1, "The back buffer count in the presentparams struct is %d\n", d3dpp.BackBufferCount);

    d3dpp.BackBufferCount  = 1;
    hr = IDirect3DDevice8_CreateAdditionalSwapChain(pDevice, &d3dpp, &swapchain2);
    ok(SUCCEEDED(hr), "Failed to create a swapchain (%#08x)\n", hr);

    d3dpp.BackBufferCount  = 2;
    hr = IDirect3DDevice8_CreateAdditionalSwapChain(pDevice, &d3dpp, &swapchain3);
    ok(SUCCEEDED(hr), "Failed to create a swapchain (%#08x)\n", hr);
    if(SUCCEEDED(hr)) {
        /* Swapchain 3, created with backbuffercount 2 */
        backbuffer = (void *) 0xdeadbeef;
        hr = IDirect3DSwapChain8_GetBackBuffer(swapchain3, 0, 0, &backbuffer);
        ok(SUCCEEDED(hr), "Failed to get the 1st back buffer (%#08x)\n", hr);
        ok(backbuffer != NULL && backbuffer != (void *) 0xdeadbeef, "The back buffer is %p\n", backbuffer);
        if(backbuffer && backbuffer != (void *) 0xdeadbeef) IDirect3DSurface8_Release(backbuffer);

        backbuffer = (void *) 0xdeadbeef;
        hr = IDirect3DSwapChain8_GetBackBuffer(swapchain3, 1, 0, &backbuffer);
        ok(SUCCEEDED(hr), "Failed to get the 2nd back buffer (%#08x)\n", hr);
        ok(backbuffer != NULL && backbuffer != (void *) 0xdeadbeef, "The back buffer is %p\n", backbuffer);
        if(backbuffer && backbuffer != (void *) 0xdeadbeef) IDirect3DSurface8_Release(backbuffer);

        backbuffer = (void *) 0xdeadbeef;
        hr = IDirect3DSwapChain8_GetBackBuffer(swapchain3, 2, 0, &backbuffer);
        ok(hr == D3DERR_INVALIDCALL, "GetBackBuffer returned %#08x\n", hr);
        ok(backbuffer == (void *) 0xdeadbeef, "The back buffer pointer was modified (%p)\n", backbuffer);
        if(backbuffer && backbuffer != (void *) 0xdeadbeef) IDirect3DSurface8_Release(backbuffer);

        backbuffer = (void *) 0xdeadbeef;
        hr = IDirect3DSwapChain8_GetBackBuffer(swapchain3, 3, 0, &backbuffer);
        ok(FAILED(hr), "Failed to get the back buffer (%#08x)\n", hr);
        ok(backbuffer == (void *) 0xdeadbeef, "The back buffer pointer was modified (%p)\n", backbuffer);
        if(backbuffer && backbuffer != (void *) 0xdeadbeef) IDirect3DSurface8_Release(backbuffer);
    }

    /* Check the back buffers of the swapchains */
    /* Swapchain 1, created with backbuffercount 0 */
    hr = IDirect3DSwapChain8_GetBackBuffer(swapchain1, 0, D3DBACKBUFFER_TYPE_MONO, &backbuffer);
    ok(SUCCEEDED(hr), "Failed to get the back buffer (%#08x)\n", hr);
    ok(backbuffer != NULL, "The back buffer is NULL (%#08x)\n", hr);
    if(backbuffer) IDirect3DSurface8_Release(backbuffer);

    backbuffer = (void *) 0xdeadbeef;
    hr = IDirect3DSwapChain8_GetBackBuffer(swapchain1, 1, 0, &backbuffer);
    ok(FAILED(hr), "Failed to get the back buffer (%#08x)\n", hr);
    ok(backbuffer == (void *) 0xdeadbeef, "The back buffer pointer was modified (%p)\n", backbuffer);
    if(backbuffer && backbuffer != (void *) 0xdeadbeef) IDirect3DSurface8_Release(backbuffer);

    /* Swapchain 2 - created with backbuffercount 1 */
    backbuffer = (void *) 0xdeadbeef;
    hr = IDirect3DSwapChain8_GetBackBuffer(swapchain2, 0, 0, &backbuffer);
    ok(SUCCEEDED(hr), "Failed to get the back buffer (%#08x)\n", hr);
    ok(backbuffer != NULL && backbuffer != (void *) 0xdeadbeef, "The back buffer is %p\n", backbuffer);
    if(backbuffer && backbuffer != (void *) 0xdeadbeef) IDirect3DSurface8_Release(backbuffer);

    backbuffer = (void *) 0xdeadbeef;
    hr = IDirect3DSwapChain8_GetBackBuffer(swapchain2, 1, 0, &backbuffer);
    ok(hr == D3DERR_INVALIDCALL, "GetBackBuffer returned %#08x\n", hr);
    ok(backbuffer == (void *) 0xdeadbeef, "The back buffer pointer was modified (%p)\n", backbuffer);
    if(backbuffer && backbuffer != (void *) 0xdeadbeef) IDirect3DSurface8_Release(backbuffer);

    backbuffer = (void *) 0xdeadbeef;
    hr = IDirect3DSwapChain8_GetBackBuffer(swapchain2, 2, 0, &backbuffer);
    ok(FAILED(hr), "Failed to get the back buffer (%#08x)\n", hr);
    ok(backbuffer == (void *) 0xdeadbeef, "The back buffer pointer was modified (%p)\n", backbuffer);
    if(backbuffer && backbuffer != (void *) 0xdeadbeef) IDirect3DSurface8_Release(backbuffer);

cleanup:
    if(swapchain1) IDirect3DSwapChain8_Release(swapchain1);
    if(swapchain2) IDirect3DSwapChain8_Release(swapchain2);
    if(swapchain3) IDirect3DSwapChain8_Release(swapchain3);
    if (pDevice)
    {
        UINT refcount = IDirect3DDevice8_Release(pDevice);
        ok(!refcount, "Device has %u references left.\n", refcount);
    }
    if (pD3d) IDirect3D8_Release(pD3d);
    DestroyWindow( hwnd );
}

static void test_refcount(void)
{
    HRESULT                      hr;
    HWND                         hwnd               = NULL;
    IDirect3D8                  *pD3d               = NULL;
    IDirect3D8                  *pD3d2              = NULL;
    IDirect3DDevice8            *pDevice            = NULL;
    IDirect3DVertexBuffer8      *pVertexBuffer      = NULL;
    IDirect3DIndexBuffer8       *pIndexBuffer       = NULL;
    DWORD                       dVertexShader       = -1;
    DWORD                       dPixelShader        = -1;
    IDirect3DCubeTexture8       *pCubeTexture       = NULL;
    IDirect3DTexture8           *pTexture           = NULL;
    IDirect3DVolumeTexture8     *pVolumeTexture     = NULL;
    IDirect3DVolume8            *pVolumeLevel       = NULL;
    IDirect3DSurface8           *pStencilSurface    = NULL;
    IDirect3DSurface8           *pImageSurface      = NULL;
    IDirect3DSurface8           *pRenderTarget      = NULL;
    IDirect3DSurface8           *pRenderTarget2     = NULL;
    IDirect3DSurface8           *pRenderTarget3     = NULL;
    IDirect3DSurface8           *pTextureLevel      = NULL;
    IDirect3DSurface8           *pBackBuffer        = NULL;
    DWORD                       dStateBlock         = -1;
    IDirect3DSwapChain8         *pSwapChain         = NULL;
    D3DCAPS8                    caps;

    D3DPRESENT_PARAMETERS        d3dpp;
    D3DDISPLAYMODE               d3ddm;
    int                          refcount = 0, tmp;

    DWORD decl[] =
    {
        D3DVSD_STREAM(0),
        D3DVSD_REG(D3DVSDE_POSITION, D3DVSDT_FLOAT3),  /* D3DVSDE_POSITION, Register v0 */
        D3DVSD_REG(D3DVSDE_DIFFUSE, D3DVSDT_D3DCOLOR), /* D3DVSDE_DIFFUSE, Register v5 */
        D3DVSD_END()
    };

    pD3d = pDirect3DCreate8( D3D_SDK_VERSION );
    ok(pD3d != NULL, "Failed to create IDirect3D8 object\n");
    hwnd = CreateWindow( "d3d8_test_wc", "d3d8_test", WS_OVERLAPPEDWINDOW, 100, 100, 160, 160, NULL, NULL, NULL, NULL );
    ok(hwnd != NULL, "Failed to create window\n");
    if (!pD3d || !hwnd) goto cleanup;

    CHECK_REFCOUNT( pD3d, 1 );

    IDirect3D8_GetAdapterDisplayMode( pD3d, D3DADAPTER_DEFAULT, &d3ddm );
    ZeroMemory( &d3dpp, sizeof(d3dpp) );
    d3dpp.Windowed         = TRUE;
    d3dpp.SwapEffect       = D3DSWAPEFFECT_DISCARD;
    d3dpp.BackBufferFormat = d3ddm.Format;
    d3dpp.EnableAutoDepthStencil = TRUE;
    d3dpp.AutoDepthStencilFormat = D3DFMT_D16;

    hr = IDirect3D8_CreateDevice( pD3d, D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL, hwnd,
                                  D3DCREATE_SOFTWARE_VERTEXPROCESSING, &d3dpp, &pDevice );
    if(FAILED(hr))
    {
        skip("could not create device, IDirect3D8_CreateDevice returned %#08x\n", hr);
        goto cleanup;
    }
    IDirect3DDevice8_GetDeviceCaps(pDevice, &caps);

    refcount = get_refcount( (IUnknown *)pDevice );
    ok(refcount == 1, "Invalid device RefCount %d\n", refcount);

    CHECK_REFCOUNT( pD3d, 2 );

    hr = IDirect3DDevice8_GetDirect3D(pDevice, &pD3d2);
    CHECK_CALL( hr, "GetDirect3D", pDevice, refcount );

    ok(pD3d2 == pD3d, "Expected IDirect3D8 pointers to be equal\n");
    CHECK_REFCOUNT( pD3d, 3 );
    CHECK_RELEASE_REFCOUNT( pD3d, 2 );

    /**
     * Check refcount of implicit surfaces. Findings:
     *   - the container is the device
     *   - they hold a reference to the device
     *   - they are created with a refcount of 0 (Get/Release returns original refcount)
     *   - they are not freed if refcount reaches 0.
     *   - the refcount is not forwarded to the container.
     */
    hr = IDirect3DDevice8_GetRenderTarget(pDevice, &pRenderTarget);
    CHECK_CALL( hr, "GetRenderTarget", pDevice, ++refcount);
    if(pRenderTarget)
    {
        CHECK_SURFACE_CONTAINER( pRenderTarget, IID_IDirect3DDevice8, pDevice);
        CHECK_REFCOUNT( pRenderTarget, 1);

        CHECK_ADDREF_REFCOUNT(pRenderTarget, 2);
        CHECK_REFCOUNT(pDevice, refcount);
        CHECK_RELEASE_REFCOUNT(pRenderTarget, 1);
        CHECK_REFCOUNT(pDevice, refcount);

        hr = IDirect3DDevice8_GetRenderTarget(pDevice, &pRenderTarget);
        CHECK_CALL( hr, "GetRenderTarget", pDevice, refcount);
        CHECK_REFCOUNT( pRenderTarget, 2);
        CHECK_RELEASE_REFCOUNT( pRenderTarget, 1);
        CHECK_RELEASE_REFCOUNT( pRenderTarget, 0);
        CHECK_REFCOUNT( pDevice, --refcount);

        /* The render target is released with the device, so AddRef with refcount=0 is fine here. */
        CHECK_ADDREF_REFCOUNT(pRenderTarget, 1);
        CHECK_REFCOUNT(pDevice, ++refcount);
        CHECK_RELEASE_REFCOUNT(pRenderTarget, 0);
        CHECK_REFCOUNT(pDevice, --refcount);
    }

    /* Render target and back buffer are identical. */
    hr = IDirect3DDevice8_GetBackBuffer(pDevice, 0, 0, &pBackBuffer);
    CHECK_CALL( hr, "GetBackBuffer", pDevice, ++refcount);
    if(pBackBuffer)
    {
        CHECK_RELEASE_REFCOUNT(pBackBuffer, 0);
        ok(pRenderTarget == pBackBuffer, "RenderTarget=%p and BackBuffer=%p should be the same.\n",
           pRenderTarget, pBackBuffer);
        pBackBuffer = NULL;
    }
    CHECK_REFCOUNT( pDevice, --refcount);

    hr = IDirect3DDevice8_GetDepthStencilSurface(pDevice, &pStencilSurface);
    CHECK_CALL( hr, "GetDepthStencilSurface", pDevice, ++refcount);
    if(pStencilSurface)
    {
        CHECK_SURFACE_CONTAINER( pStencilSurface, IID_IDirect3DDevice8, pDevice);
        CHECK_REFCOUNT( pStencilSurface, 1);

        CHECK_ADDREF_REFCOUNT(pStencilSurface, 2);
        CHECK_REFCOUNT(pDevice, refcount);
        CHECK_RELEASE_REFCOUNT(pStencilSurface, 1);
        CHECK_REFCOUNT(pDevice, refcount);

        CHECK_RELEASE_REFCOUNT( pStencilSurface, 0);
        CHECK_REFCOUNT( pDevice, --refcount);

        /* The stencil surface is released with the device, so AddRef with refcount=0 is fine here. */
        CHECK_ADDREF_REFCOUNT(pStencilSurface, 1);
        CHECK_REFCOUNT(pDevice, ++refcount);
        CHECK_RELEASE_REFCOUNT(pStencilSurface, 0);
        CHECK_REFCOUNT(pDevice, --refcount);
        pStencilSurface = NULL;
    }

    /* Buffers */
    hr = IDirect3DDevice8_CreateIndexBuffer( pDevice, 16, 0, D3DFMT_INDEX32, D3DPOOL_DEFAULT, &pIndexBuffer );
    CHECK_CALL( hr, "CreateIndexBuffer", pDevice, ++refcount );
    if(pIndexBuffer)
    {
        tmp = get_refcount( (IUnknown *)pIndexBuffer );

        hr = IDirect3DDevice8_SetIndices(pDevice, pIndexBuffer, 0);
        CHECK_CALL( hr, "SetIndices", pIndexBuffer, tmp);
        hr = IDirect3DDevice8_SetIndices(pDevice, NULL, 0);
        CHECK_CALL( hr, "SetIndices", pIndexBuffer, tmp);
    }

    hr = IDirect3DDevice8_CreateVertexBuffer( pDevice, 16, 0, D3DFVF_XYZ, D3DPOOL_DEFAULT, &pVertexBuffer );
    CHECK_CALL( hr, "CreateVertexBuffer", pDevice, ++refcount );
    if(pVertexBuffer)
    {
        IDirect3DVertexBuffer8 *pVBuf = (void*)~0;
        UINT stride = ~0;

        tmp = get_refcount( (IUnknown *)pVertexBuffer );

        hr = IDirect3DDevice8_SetStreamSource(pDevice, 0, pVertexBuffer, 3 * sizeof(float));
        CHECK_CALL( hr, "SetStreamSource", pVertexBuffer, tmp);
        hr = IDirect3DDevice8_SetStreamSource(pDevice, 0, NULL, 0);
        CHECK_CALL( hr, "SetStreamSource", pVertexBuffer, tmp);

        hr = IDirect3DDevice8_GetStreamSource(pDevice, 0, &pVBuf, &stride);
        ok(SUCCEEDED(hr), "GetStreamSource did not succeed with NULL stream!\n");
        ok(pVBuf==NULL, "pVBuf not NULL (%p)!\n", pVBuf);
        ok(stride==3*sizeof(float), "stride not 3 floats (got %u)!\n", stride);
    }

    /* Shaders */
    hr = IDirect3DDevice8_CreateVertexShader( pDevice, decl, simple_vs, &dVertexShader, 0 );
    CHECK_CALL( hr, "CreateVertexShader", pDevice, refcount );
    if (caps.PixelShaderVersion >= D3DPS_VERSION(1, 0))
    {
        hr = IDirect3DDevice8_CreatePixelShader( pDevice, simple_ps, &dPixelShader );
        CHECK_CALL( hr, "CreatePixelShader", pDevice, refcount );
    }
    /* Textures */
    hr = IDirect3DDevice8_CreateTexture( pDevice, 32, 32, 3, 0, D3DFMT_X8R8G8B8, D3DPOOL_DEFAULT, &pTexture );
    CHECK_CALL( hr, "CreateTexture", pDevice, ++refcount );
    if (pTexture)
    {
        tmp = get_refcount( (IUnknown *)pTexture );

        /* SetTexture should not increase refcounts */
        hr = IDirect3DDevice8_SetTexture(pDevice, 0, (IDirect3DBaseTexture8 *) pTexture);
        CHECK_CALL( hr, "SetTexture", pTexture, tmp);
        hr = IDirect3DDevice8_SetTexture(pDevice, 0, NULL);
        CHECK_CALL( hr, "SetTexture", pTexture, tmp);

        /* This should not increment device refcount */
        hr = IDirect3DTexture8_GetSurfaceLevel( pTexture, 1, &pTextureLevel );
        CHECK_CALL( hr, "GetSurfaceLevel", pDevice, refcount );
        /* But should increment texture's refcount */
        CHECK_REFCOUNT( pTexture, tmp+1 );
        /* Because the texture and surface refcount are identical */
        if (pTextureLevel)
        {
            CHECK_REFCOUNT        ( pTextureLevel, tmp+1 );
            CHECK_ADDREF_REFCOUNT ( pTextureLevel, tmp+2 );
            CHECK_REFCOUNT        ( pTexture     , tmp+2 );
            CHECK_RELEASE_REFCOUNT( pTextureLevel, tmp+1 );
            CHECK_REFCOUNT        ( pTexture     , tmp+1 );
            CHECK_RELEASE_REFCOUNT( pTexture     , tmp   );
            CHECK_REFCOUNT        ( pTextureLevel, tmp   );
        }
    }
    if(caps.TextureCaps & D3DPTEXTURECAPS_CUBEMAP)
    {
        hr = IDirect3DDevice8_CreateCubeTexture( pDevice, 32, 0, 0, D3DFMT_X8R8G8B8, D3DPOOL_DEFAULT, &pCubeTexture );
        CHECK_CALL( hr, "CreateCubeTexture", pDevice, ++refcount );
    }
    else
    {
        skip("Cube textures not supported\n");
    }
    if(caps.TextureCaps & D3DPTEXTURECAPS_VOLUMEMAP)
    {
        hr = IDirect3DDevice8_CreateVolumeTexture( pDevice, 32, 32, 2, 0, 0, D3DFMT_X8R8G8B8, D3DPOOL_DEFAULT, &pVolumeTexture );
        CHECK_CALL( hr, "CreateVolumeTexture", pDevice, ++refcount );
    }
    else
    {
        skip("Volume textures not supported\n");
    }

    if (pVolumeTexture)
    {
        tmp = get_refcount( (IUnknown *)pVolumeTexture );

        /* This should not increment device refcount */
        hr = IDirect3DVolumeTexture8_GetVolumeLevel(pVolumeTexture, 0, &pVolumeLevel);
        CHECK_CALL( hr, "GetVolumeLevel", pDevice, refcount );
        /* But should increment volume texture's refcount */
        CHECK_REFCOUNT( pVolumeTexture, tmp+1 );
        /* Because the volume texture and volume refcount are identical */
        if (pVolumeLevel)
        {
            CHECK_REFCOUNT        ( pVolumeLevel  , tmp+1 );
            CHECK_ADDREF_REFCOUNT ( pVolumeLevel  , tmp+2 );
            CHECK_REFCOUNT        ( pVolumeTexture, tmp+2 );
            CHECK_RELEASE_REFCOUNT( pVolumeLevel  , tmp+1 );
            CHECK_REFCOUNT        ( pVolumeTexture, tmp+1 );
            CHECK_RELEASE_REFCOUNT( pVolumeTexture, tmp   );
            CHECK_REFCOUNT        ( pVolumeLevel  , tmp   );
        }
    }
    /* Surfaces */
    hr = IDirect3DDevice8_CreateDepthStencilSurface( pDevice, 32, 32, D3DFMT_D16, D3DMULTISAMPLE_NONE, &pStencilSurface );
    CHECK_CALL( hr, "CreateDepthStencilSurface", pDevice, ++refcount );
    CHECK_REFCOUNT( pStencilSurface, 1);
    hr = IDirect3DDevice8_CreateImageSurface( pDevice, 32, 32, D3DFMT_X8R8G8B8, &pImageSurface );
    CHECK_CALL( hr, "CreateImageSurface", pDevice, ++refcount );
    CHECK_REFCOUNT( pImageSurface, 1);
    hr = IDirect3DDevice8_CreateRenderTarget( pDevice, 32, 32, D3DFMT_X8R8G8B8, D3DMULTISAMPLE_NONE, TRUE, &pRenderTarget3 );
    CHECK_CALL( hr, "CreateRenderTarget", pDevice, ++refcount );
    CHECK_REFCOUNT( pRenderTarget3, 1);
    /* Misc */
    hr = IDirect3DDevice8_CreateStateBlock( pDevice, D3DSBT_ALL, &dStateBlock );
    CHECK_CALL( hr, "CreateStateBlock", pDevice, refcount );
    hr = IDirect3DDevice8_CreateAdditionalSwapChain( pDevice, &d3dpp, &pSwapChain );
    CHECK_CALL( hr, "CreateAdditionalSwapChain", pDevice, ++refcount );
    if(pSwapChain)
    {
        /* check implicit back buffer */
        hr = IDirect3DSwapChain8_GetBackBuffer(pSwapChain, 0, 0, &pBackBuffer);
        CHECK_CALL( hr, "GetBackBuffer", pDevice, ++refcount);
        CHECK_REFCOUNT( pSwapChain, 1);
        if(pBackBuffer)
        {
            CHECK_SURFACE_CONTAINER( pBackBuffer, IID_IDirect3DDevice8, pDevice);
            CHECK_REFCOUNT( pBackBuffer, 1);
            CHECK_RELEASE_REFCOUNT( pBackBuffer, 0);
            CHECK_REFCOUNT( pDevice, --refcount);

            /* The back buffer is released with the swapchain, so AddRef with refcount=0 is fine here. */
            CHECK_ADDREF_REFCOUNT(pBackBuffer, 1);
            CHECK_REFCOUNT(pDevice, ++refcount);
            CHECK_RELEASE_REFCOUNT(pBackBuffer, 0);
            CHECK_REFCOUNT(pDevice, --refcount);
            pBackBuffer = NULL;
        }
        CHECK_REFCOUNT( pSwapChain, 1);
    }

    if(pVertexBuffer)
    {
        BYTE *data;
        /* Vertex buffers can be locked multiple times */
        hr = IDirect3DVertexBuffer8_Lock(pVertexBuffer, 0, 0, &data, 0);
        ok(hr == D3D_OK, "IDirect3DVertexBuffer8::Lock failed with %#08x\n", hr);
        hr = IDirect3DVertexBuffer8_Lock(pVertexBuffer, 0, 0, &data, 0);
        ok(hr == D3D_OK, "IDirect3DVertexBuffer8::Lock failed with %#08x\n", hr);
        hr = IDirect3DVertexBuffer8_Unlock(pVertexBuffer);
        ok(hr == D3D_OK, "IDirect3DVertexBuffer8::Unlock failed with %#08x\n", hr);
        hr = IDirect3DVertexBuffer8_Unlock(pVertexBuffer);
        ok(hr == D3D_OK, "IDirect3DVertexBuffer8::Unlock failed with %#08x\n", hr);
    }

    /* The implicit render target is not freed if refcount reaches 0.
     * Otherwise GetRenderTarget would re-allocate it and the pointer would change.*/
    hr = IDirect3DDevice8_GetRenderTarget(pDevice, &pRenderTarget2);
    CHECK_CALL( hr, "GetRenderTarget", pDevice, ++refcount);
    if(pRenderTarget2)
    {
        CHECK_RELEASE_REFCOUNT(pRenderTarget2, 0);
        ok(pRenderTarget == pRenderTarget2, "RenderTarget=%p and RenderTarget2=%p should be the same.\n",
           pRenderTarget, pRenderTarget2);
        CHECK_REFCOUNT( pDevice, --refcount);
        pRenderTarget2 = NULL;
    }
    pRenderTarget = NULL;

cleanup:
    CHECK_RELEASE(pDevice,              pDevice, --refcount);

    /* Buffers */
    CHECK_RELEASE(pVertexBuffer,        pDevice, --refcount);
    CHECK_RELEASE(pIndexBuffer,         pDevice, --refcount);
    /* Shaders */
    if (dVertexShader != ~0U) IDirect3DDevice8_DeleteVertexShader( pDevice, dVertexShader );
    if (dPixelShader != ~0U) IDirect3DDevice8_DeletePixelShader( pDevice, dPixelShader );
    /* Textures */
    CHECK_RELEASE(pTexture,             pDevice, --refcount);
    CHECK_RELEASE(pCubeTexture,         pDevice, --refcount);
    CHECK_RELEASE(pVolumeTexture,       pDevice, --refcount);
    /* Surfaces */
    CHECK_RELEASE(pStencilSurface,      pDevice, --refcount);
    CHECK_RELEASE(pImageSurface,        pDevice, --refcount);
    CHECK_RELEASE(pRenderTarget3,       pDevice, --refcount);
    /* Misc */
    if (dStateBlock != ~0U) IDirect3DDevice8_DeleteStateBlock( pDevice, dStateBlock );
    /* This will destroy device - cannot check the refcount here */
    if (pSwapChain)           CHECK_RELEASE_REFCOUNT( pSwapChain, 0);

    if (pD3d)                 CHECK_RELEASE_REFCOUNT( pD3d, 0);

    DestroyWindow( hwnd );
}

static void test_cursor(void)
{
    HRESULT                      hr;
    HWND                         hwnd               = NULL;
    IDirect3D8                  *pD3d               = NULL;
    IDirect3DDevice8            *pDevice            = NULL;
    D3DPRESENT_PARAMETERS        d3dpp;
    D3DDISPLAYMODE               d3ddm;
    CURSORINFO                   info;
    IDirect3DSurface8 *cursor = NULL;
    HCURSOR cur;
    HMODULE user32_handle = GetModuleHandleA("user32.dll");

    pGetCursorInfo = (void *)GetProcAddress(user32_handle, "GetCursorInfo");
    if (!pGetCursorInfo)
    {
        win_skip("GetCursorInfo is not available\n");
        return;
    }

    memset(&info, 0, sizeof(info));
    info.cbSize = sizeof(info);
    ok(pGetCursorInfo(&info), "GetCursorInfo failed\n");
    cur = info.hCursor;

    pD3d = pDirect3DCreate8( D3D_SDK_VERSION );
    ok(pD3d != NULL, "Failed to create IDirect3D8 object\n");
    hwnd = CreateWindow( "d3d8_test_wc", "d3d8_test", WS_OVERLAPPEDWINDOW, 100, 100, 160, 160, NULL, NULL, NULL, NULL );
    ok(hwnd != NULL, "Failed to create window\n");
    if (!pD3d || !hwnd) goto cleanup;

    IDirect3D8_GetAdapterDisplayMode( pD3d, D3DADAPTER_DEFAULT, &d3ddm );
    ZeroMemory( &d3dpp, sizeof(d3dpp) );
    d3dpp.Windowed         = TRUE;
    d3dpp.SwapEffect       = D3DSWAPEFFECT_DISCARD;
    d3dpp.BackBufferFormat = d3ddm.Format;

    hr = IDirect3D8_CreateDevice( pD3d, D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL, hwnd,
                                  D3DCREATE_SOFTWARE_VERTEXPROCESSING, &d3dpp, &pDevice );
    if(FAILED(hr))
    {
        skip("could not create device, IDirect3D8_CreateDevice returned %#08x\n", hr);
        goto cleanup;
    }

    IDirect3DDevice8_CreateImageSurface(pDevice, 32, 32, D3DFMT_A8R8G8B8, &cursor);
    ok(cursor != NULL, "IDirect3DDevice8_CreateOffscreenPlainSurface failed with %#08x\n", hr);

    /* Initially hidden */
    hr = IDirect3DDevice8_ShowCursor(pDevice, TRUE);
    ok(hr == FALSE, "IDirect3DDevice8_ShowCursor returned %#08x\n", hr);

    /* Not enabled without a surface*/
    hr = IDirect3DDevice8_ShowCursor(pDevice, TRUE);
    ok(hr == FALSE, "IDirect3DDevice8_ShowCursor returned %#08x\n", hr);

    /* Fails */
    hr = IDirect3DDevice8_SetCursorProperties(pDevice, 0, 0, NULL);
    ok(hr == D3DERR_INVALIDCALL, "IDirect3DDevice8_SetCursorProperties returned %#08x\n", hr);

    hr = IDirect3DDevice8_SetCursorProperties(pDevice, 0, 0, cursor);
    ok(hr == D3D_OK, "IDirect3DDevice8_SetCursorProperties returned %#08x\n", hr);

    IDirect3DSurface8_Release(cursor);

    memset(&info, 0, sizeof(info));
    info.cbSize = sizeof(info);
    ok(pGetCursorInfo(&info), "GetCursorInfo failed\n");
    ok(info.flags & CURSOR_SHOWING, "The gdi cursor is hidden (%08x)\n", info.flags);
    ok(info.hCursor == cur, "The cursor handle is %p\n", info.hCursor); /* unchanged */

    /* Still hidden */
    hr = IDirect3DDevice8_ShowCursor(pDevice, TRUE);
    ok(hr == FALSE, "IDirect3DDevice8_ShowCursor returned %#08x\n", hr);

    /* Enabled now*/
    hr = IDirect3DDevice8_ShowCursor(pDevice, TRUE);
    ok(hr == TRUE, "IDirect3DDevice8_ShowCursor returned %#08x\n", hr);

    /* GDI cursor unchanged */
    memset(&info, 0, sizeof(info));
    info.cbSize = sizeof(info);
    ok(pGetCursorInfo(&info), "GetCursorInfo failed\n");
    ok(info.flags & CURSOR_SHOWING, "The gdi cursor is hidden (%08x)\n", info.flags);
    ok(info.hCursor == cur, "The cursor handle is %p\n", info.hCursor); /* unchanged */

cleanup:
    if (pDevice)
    {
        UINT refcount = IDirect3DDevice8_Release(pDevice);
        ok(!refcount, "Device has %u references left.\n", refcount);
    }
    if (pD3d) IDirect3D8_Release(pD3d);
    DestroyWindow(hwnd);
}

static const POINT *expect_pos;

static LRESULT CALLBACK test_cursor_proc(HWND window, UINT message, WPARAM wparam, LPARAM lparam)
{
    if (message == WM_MOUSEMOVE)
    {
        if (expect_pos && expect_pos->x && expect_pos->y)
        {
            POINT p = {GET_X_LPARAM(lparam), GET_Y_LPARAM(lparam)};

            ClientToScreen(window, &p);
            if (expect_pos->x == p.x && expect_pos->y == p.y)
                ++expect_pos;
        }
    }

    return DefWindowProcA(window, message, wparam, lparam);
}

static void test_cursor_pos(void)
{
    IDirect3DSurface8 *cursor;
    IDirect3DDevice8 *device;
    WNDCLASSA wc = {0};
    IDirect3D8 *d3d8;
    UINT refcount;
    HWND window;
    HRESULT hr;
    BOOL ret;

    /* Note that we don't check for movement we're not supposed to receive.
     * That's because it's hard to distinguish from the user accidentally
     * moving the mouse. */
    static const POINT points[] =
    {
        {50, 50},
        {75, 75},
        {100, 100},
        {125, 125},
        {150, 150},
        {125, 125},
        {150, 150},
        {150, 150},
        {0, 0},
    };

    if (!(d3d8 = pDirect3DCreate8(D3D_SDK_VERSION)))
    {
        skip("Failed to create IDirect3D8 object, skipping cursor tests.\n");
        return;
    }

    wc.lpfnWndProc = test_cursor_proc;
    wc.lpszClassName = "d3d8_test_cursor_wc";
    ok(RegisterClassA(&wc), "Failed to register window class.\n");
    window = CreateWindow("d3d8_test_cursor_wc", "d3d8_test", WS_OVERLAPPEDWINDOW,
            0, 0, 320, 240, NULL, NULL, NULL, NULL);
    ShowWindow(window, SW_SHOW);

    device = create_device(d3d8, window, window, TRUE);
    if (!device)
    {
        skip("Failed to create a D3D device, skipping tests.\n");
        goto done;
    }

    hr = IDirect3DDevice8_CreateImageSurface(device, 32, 32, D3DFMT_A8R8G8B8, &cursor);
    ok(SUCCEEDED(hr), "Failed to create cursor surface, hr %#x.\n", hr);
    hr = IDirect3DDevice8_SetCursorProperties(device, 0, 0, cursor);
    ok(SUCCEEDED(hr), "Failed to set cursor properties, hr %#x.\n", hr);
    IDirect3DSurface8_Release(cursor);
    ret = IDirect3DDevice8_ShowCursor(device, TRUE);
    ok(!ret, "Failed to show cursor, hr %#x.\n", ret);

    flush_events();
    expect_pos = points;

    ret = SetCursorPos(50, 50);
    ok(ret, "Failed to set cursor position.\n");
    flush_events();

    IDirect3DDevice8_SetCursorPosition(device, 75, 75, 0);
    flush_events();
    /* SetCursorPosition() eats duplicates. */
    IDirect3DDevice8_SetCursorPosition(device, 75, 75, 0);
    flush_events();

    ret = SetCursorPos(100, 100);
    ok(ret, "Failed to set cursor position.\n");
    flush_events();
    /* Even if the position was set with SetCursorPos(). */
    IDirect3DDevice8_SetCursorPosition(device, 100, 100, 0);
    flush_events();

    IDirect3DDevice8_SetCursorPosition(device, 125, 125, 0);
    flush_events();
    ret = SetCursorPos(150, 150);
    ok(ret, "Failed to set cursor position.\n");
    flush_events();
    IDirect3DDevice8_SetCursorPosition(device, 125, 125, 0);
    flush_events();

    IDirect3DDevice8_SetCursorPosition(device, 150, 150, 0);
    flush_events();
    /* SetCursorPos() doesn't. */
    ret = SetCursorPos(150, 150);
    ok(ret, "Failed to set cursor position.\n");
    flush_events();

    ok(!expect_pos->x && !expect_pos->y, "Didn't receive MOUSEMOVE %u (%d, %d).\n",
       (unsigned)(expect_pos - points), expect_pos->x, expect_pos->y);

    refcount = IDirect3DDevice8_Release(device);
    ok(!refcount, "Device has %u references left.\n", refcount);
done:
    DestroyWindow(window);
    UnregisterClassA("d3d8_test_cursor_wc", GetModuleHandleA(NULL));
    if (d3d8)
        IDirect3D8_Release(d3d8);
}

static void test_states(void)
{
    HRESULT                      hr;
    HWND                         hwnd               = NULL;
    IDirect3D8                  *pD3d               = NULL;
    IDirect3DDevice8            *pDevice            = NULL;
    D3DPRESENT_PARAMETERS        d3dpp;
    D3DDISPLAYMODE               d3ddm;

    pD3d = pDirect3DCreate8( D3D_SDK_VERSION );
    ok(pD3d != NULL, "Failed to create IDirect3D8 object\n");
    hwnd = CreateWindow( "d3d8_test_wc", "d3d8_test", WS_OVERLAPPEDWINDOW, 100, 100, 160, 160, NULL, NULL, NULL, NULL );
    ok(hwnd != NULL, "Failed to create window\n");
    if (!pD3d || !hwnd) goto cleanup;

    IDirect3D8_GetAdapterDisplayMode( pD3d, D3DADAPTER_DEFAULT, &d3ddm );
    ZeroMemory( &d3dpp, sizeof(d3dpp) );
    d3dpp.Windowed         = TRUE;
    d3dpp.SwapEffect       = D3DSWAPEFFECT_DISCARD;
    d3dpp.BackBufferWidth  = screen_width;
    d3dpp.BackBufferHeight = screen_height;
    d3dpp.BackBufferFormat = d3ddm.Format;

    hr = IDirect3D8_CreateDevice( pD3d, D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL /* no NULLREF here */, hwnd,
                                  D3DCREATE_SOFTWARE_VERTEXPROCESSING, &d3dpp, &pDevice );
    if(FAILED(hr))
    {
        skip("could not create device, IDirect3D8_CreateDevice returned %#08x\n", hr);
        goto cleanup;
    }

    hr = IDirect3DDevice8_SetRenderState(pDevice, D3DRS_ZVISIBLE, TRUE);
    ok(hr == D3D_OK, "IDirect3DDevice8_SetRenderState(D3DRS_ZVISIBLE, TRUE) returned %#08x\n", hr);
    hr = IDirect3DDevice8_SetRenderState(pDevice, D3DRS_ZVISIBLE, FALSE);
    ok(hr == D3D_OK, "IDirect3DDevice8_SetRenderState(D3DRS_ZVISIBLE, FALSE) returned %#08x\n", hr);

cleanup:
    if (pDevice)
    {
        UINT refcount = IDirect3DDevice8_Release(pDevice);
        ok(!refcount, "Device has %u references left.\n", refcount);
    }
    if (pD3d) IDirect3D8_Release(pD3d);
    DestroyWindow(hwnd);
}

static void test_shader_versions(void)
{
    HRESULT                      hr;
    IDirect3D8                  *pD3d               = NULL;
    D3DCAPS8                     d3dcaps;

    pD3d = pDirect3DCreate8( D3D_SDK_VERSION );
    ok(pD3d != NULL, "Failed to create IDirect3D8 object\n");
    if (pD3d != NULL) {
        hr = IDirect3D8_GetDeviceCaps(pD3d, D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL, &d3dcaps);
        ok(SUCCEEDED(hr) || hr == D3DERR_NOTAVAILABLE, "Failed to get D3D8 caps (%#08x)\n", hr);
        if (SUCCEEDED(hr)) {
            ok(d3dcaps.VertexShaderVersion <= D3DVS_VERSION(1,1), "Unexpected VertexShaderVersion (%#x > %#x)\n", d3dcaps.VertexShaderVersion, D3DVS_VERSION(1,1));
            ok(d3dcaps.PixelShaderVersion <= D3DPS_VERSION(1,4), "Unexpected PixelShaderVersion (%#x > %#x)\n", d3dcaps.PixelShaderVersion, D3DPS_VERSION(1,4));
        } else {
            skip("No Direct3D support\n");
        }
        IDirect3D8_Release(pD3d);
    }
}


/* Test adapter display modes */
static void test_display_modes(void)
{
    UINT max_modes, i;
    D3DDISPLAYMODE dmode;
    HRESULT res;
    IDirect3D8 *pD3d;

    pD3d = pDirect3DCreate8( D3D_SDK_VERSION );
    ok(pD3d != NULL, "Failed to create IDirect3D8 object\n");
    if(!pD3d) return;

    max_modes = IDirect3D8_GetAdapterModeCount(pD3d, D3DADAPTER_DEFAULT);
    ok(max_modes > 0 ||
       broken(max_modes == 0), /* VMware */
       "GetAdapterModeCount(D3DADAPTER_DEFAULT) returned 0!\n");

    for(i=0; i<max_modes;i++) {
        res = IDirect3D8_EnumAdapterModes(pD3d, D3DADAPTER_DEFAULT, i, &dmode);
        ok(res==D3D_OK, "EnumAdapterModes returned %#08x for mode %u!\n", res, i);
        if(res != D3D_OK)
            continue;

        ok(dmode.Format==D3DFMT_X8R8G8B8 || dmode.Format==D3DFMT_R5G6B5,
           "Unexpected display mode returned for mode %u: %#x\n", i , dmode.Format);
    }

    IDirect3D8_Release(pD3d);
}

static void test_reset(void)
{
    UINT width, orig_width = GetSystemMetrics(SM_CXSCREEN);
    UINT height, orig_height = GetSystemMetrics(SM_CYSCREEN);
    IDirect3DDevice8 *device1 = NULL;
    IDirect3DDevice8 *device2 = NULL;
    D3DDISPLAYMODE d3ddm, d3ddm2;
    D3DSURFACE_DESC surface_desc;
    D3DPRESENT_PARAMETERS d3dpp;
    IDirect3DSurface8 *surface;
    IDirect3DTexture8 *texture;
    UINT adapter_mode_count;
    D3DLOCKED_RECT lockrect;
    IDirect3D8 *d3d8 = NULL;
    UINT mode_count = 0;
    HWND window = NULL;
    RECT winrect;
    D3DVIEWPORT8 vp;
    D3DCAPS8 caps;
    DWORD shader;
    DWORD value;
    HRESULT hr;
    UINT i;

    static const DWORD decl[] =
    {
        D3DVSD_STREAM(0),
        D3DVSD_REG(D3DVSDE_POSITION,  D3DVSDT_FLOAT4),
        D3DVSD_END(),
    };

    struct
    {
        UINT w;
        UINT h;
    } *modes = NULL;

    d3d8 = pDirect3DCreate8(D3D_SDK_VERSION);
    ok(!!d3d8, "Failed to create IDirect3D8 object.\n");
    window = CreateWindowA("d3d8_test_wc", "d3d8_test", WS_OVERLAPPEDWINDOW,
            100, 100, 160, 160, NULL, NULL, NULL, NULL);
    ok(!!window, "Failed to create window.\n");
    if (!d3d8 || !window)
        goto cleanup;

    hr = IDirect3D8_GetAdapterDisplayMode(d3d8, D3DADAPTER_DEFAULT, &d3ddm);
    ok(SUCCEEDED(hr), "GetAdapterDisplayMode failed, hr %#x.\n", hr);
    adapter_mode_count = IDirect3D8_GetAdapterModeCount(d3d8, D3DADAPTER_DEFAULT);
    modes = HeapAlloc(GetProcessHeap(), 0, sizeof(*modes) * adapter_mode_count);
    for (i = 0; i < adapter_mode_count; ++i)
    {
        UINT j;

        memset(&d3ddm2, 0, sizeof(d3ddm2));
        hr = IDirect3D8_EnumAdapterModes(d3d8, D3DADAPTER_DEFAULT, i, &d3ddm2);
        ok(SUCCEEDED(hr), "EnumAdapterModes failed, hr %#x.\n", hr);

        if (d3ddm2.Format != d3ddm.Format)
            continue;

        for (j = 0; j < mode_count; ++j)
        {
            if (modes[j].w == d3ddm2.Width && modes[j].h == d3ddm2.Height)
                break;
        }
        if (j == mode_count)
        {
            modes[j].w = d3ddm2.Width;
            modes[j].h = d3ddm2.Height;
            ++mode_count;
        }

        /* We use them as invalid modes. */
        if ((d3ddm2.Width == 801 && d3ddm2.Height == 600)
                || (d3ddm2.Width == 32 && d3ddm2.Height == 32))
        {
            skip("This system supports a screen resolution of %dx%d, not running mode tests.\n",
                    d3ddm2.Width, d3ddm2.Height);
            goto cleanup;
        }
    }

    if (mode_count < 2)
    {
        skip("Less than 2 modes supported, skipping mode tests.\n");
        goto cleanup;
    }

    i = 0;
    if (modes[i].w == orig_width && modes[i].h == orig_height) ++i;

    memset(&d3dpp, 0, sizeof(d3dpp));
    d3dpp.Windowed = FALSE;
    d3dpp.SwapEffect = D3DSWAPEFFECT_DISCARD;
    d3dpp.BackBufferWidth = modes[i].w;
    d3dpp.BackBufferHeight = modes[i].h;
    d3dpp.BackBufferFormat = d3ddm.Format;
    d3dpp.EnableAutoDepthStencil = TRUE;
    d3dpp.AutoDepthStencilFormat = D3DFMT_D24S8;

    hr = IDirect3D8_CreateDevice(d3d8, D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL,
            window, D3DCREATE_SOFTWARE_VERTEXPROCESSING, &d3dpp, &device1);
    if (FAILED(hr))
    {
        skip("Failed to create device, hr %#x.\n", hr);
        goto cleanup;
    }
    hr = IDirect3DDevice8_TestCooperativeLevel(device1);
    ok(SUCCEEDED(hr), "TestCooperativeLevel failed, hr %#x.\n", hr);

    hr = IDirect3DDevice8_GetDeviceCaps(device1, &caps);
    ok(SUCCEEDED(hr), "GetDeviceCaps failed, hr %#x.\n", hr);

    width = GetSystemMetrics(SM_CXSCREEN);
    height = GetSystemMetrics(SM_CYSCREEN);
    ok(width == modes[i].w, "Screen width is %u, expected %u.\n", width, modes[i].w);
    ok(height == modes[i].h, "Screen height is %u, expected %u.\n", height, modes[i].h);

    hr = IDirect3DDevice8_GetViewport(device1, &vp);
    ok(SUCCEEDED(hr), "GetViewport failed, hr %#x.\n", hr);
    if (SUCCEEDED(hr))
    {
        ok(vp.X == 0, "D3DVIEWPORT->X = %u, expected 0.\n", vp.X);
        ok(vp.Y == 0, "D3DVIEWPORT->Y = %u, expected 0.\n", vp.Y);
        ok(vp.Width == modes[i].w, "D3DVIEWPORT->Width = %u, expected %u.\n", vp.Width, modes[i].w);
        ok(vp.Height == modes[i].h, "D3DVIEWPORT->Height = %u, expected %u.\n", vp.Height, modes[i].h);
        ok(vp.MinZ == 0, "D3DVIEWPORT->MinZ = %.8e, expected 0.\n", vp.MinZ);
        ok(vp.MaxZ == 1, "D3DVIEWPORT->MaxZ = %.8e, expected 1.\n", vp.MaxZ);
    }

    i = 1;
    vp.X = 10;
    vp.Y = 20;
    vp.Width = modes[i].w  / 2;
    vp.Height = modes[i].h / 2;
    vp.MinZ = 0.2f;
    vp.MaxZ = 0.3f;
    hr = IDirect3DDevice8_SetViewport(device1, &vp);
    ok(SUCCEEDED(hr), "SetViewport failed, hr %#x.\n", hr);

    hr = IDirect3DDevice8_GetRenderState(device1, D3DRS_LIGHTING, &value);
    ok(SUCCEEDED(hr), "Failed to get render state, hr %#x.\n", hr);
    ok(!!value, "Got unexpected value %#x for D3DRS_LIGHTING.\n", value);
    hr = IDirect3DDevice8_SetRenderState(device1, D3DRS_LIGHTING, FALSE);
    ok(SUCCEEDED(hr), "Failed to set render state, hr %#x.\n", hr);

    memset(&d3dpp, 0, sizeof(d3dpp));
    d3dpp.SwapEffect = D3DSWAPEFFECT_DISCARD;
    d3dpp.Windowed = FALSE;
    d3dpp.BackBufferWidth = modes[i].w;
    d3dpp.BackBufferHeight = modes[i].h;
    d3dpp.BackBufferFormat = d3ddm.Format;
    hr = IDirect3DDevice8_Reset(device1, &d3dpp);
    ok(SUCCEEDED(hr), "Reset failed, hr %#x.\n", hr);
    hr = IDirect3DDevice8_TestCooperativeLevel(device1);
    ok(SUCCEEDED(hr), "TestCooperativeLevel failed, hr %#x.\n", hr);

    hr = IDirect3DDevice8_GetRenderState(device1, D3DRS_LIGHTING, &value);
    ok(SUCCEEDED(hr), "Failed to get render state, hr %#x.\n", hr);
    ok(!!value, "Got unexpected value %#x for D3DRS_LIGHTING.\n", value);

    memset(&vp, 0, sizeof(vp));
    hr = IDirect3DDevice8_GetViewport(device1, &vp);
    ok(SUCCEEDED(hr), "GetViewport failed, hr %#x.\n", hr);
    if (SUCCEEDED(hr))
    {
        ok(vp.X == 0, "D3DVIEWPORT->X = %u, expected 0.\n", vp.X);
        ok(vp.Y == 0, "D3DVIEWPORT->Y = %u, expected 0.\n", vp.Y);
        ok(vp.Width == modes[i].w, "D3DVIEWPORT->Width = %u, expected %u.\n", vp.Width, modes[i].w);
        ok(vp.Height == modes[i].h, "D3DVIEWPORT->Height = %u, expected %u.\n", vp.Height, modes[i].h);
        ok(vp.MinZ == 0, "D3DVIEWPORT->MinZ = %.8e, expected 0.\n", vp.MinZ);
        ok(vp.MaxZ == 1, "D3DVIEWPORT->MaxZ = %.8e, expected 1.\n", vp.MaxZ);
    }

    width = GetSystemMetrics(SM_CXSCREEN);
    height = GetSystemMetrics(SM_CYSCREEN);
    ok(width == modes[i].w, "Screen width is %u, expected %u.\n", width, modes[i].w);
    ok(height == modes[i].h, "Screen height is %u, expected %u.\n", height, modes[i].h);

    hr = IDirect3DDevice8_GetRenderTarget(device1, &surface);
    ok(SUCCEEDED(hr), "GetRenderTarget failed, hr %#x.\n", hr);
    hr = IDirect3DSurface8_GetDesc(surface, &surface_desc);
    ok(hr == D3D_OK, "GetDesc failed, hr %#x.\n", hr);
    ok(surface_desc.Width == modes[i].w, "Back buffer width is %u, expected %u.\n",
            surface_desc.Width, modes[i].w);
    ok(surface_desc.Height == modes[i].h, "Back buffer height is %u, expected %u.\n",
            surface_desc.Height, modes[i].h);
    IDirect3DSurface8_Release(surface);

    memset(&d3dpp, 0, sizeof(d3dpp));
    d3dpp.SwapEffect = D3DSWAPEFFECT_DISCARD;
    d3dpp.Windowed = TRUE;
    d3dpp.BackBufferWidth = 400;
    d3dpp.BackBufferHeight = 300;
    d3dpp.BackBufferFormat = d3ddm.Format;
    hr = IDirect3DDevice8_Reset(device1, &d3dpp);
    ok(SUCCEEDED(hr), "Reset failed, hr %#x.\n", hr);
    hr = IDirect3DDevice8_TestCooperativeLevel(device1);
    ok(SUCCEEDED(hr), "TestCooperativeLevel failed, hr %#x.\n", hr);

    memset(&vp, 0, sizeof(vp));
    hr = IDirect3DDevice8_GetViewport(device1, &vp);
    ok(SUCCEEDED(hr), "GetViewport failed, hr %#x.\n", hr);
    if (SUCCEEDED(hr))
    {
        ok(vp.X == 0, "D3DVIEWPORT->X = %u, expected 0.\n", vp.X);
        ok(vp.Y == 0, "D3DVIEWPORT->Y = %u, expected 0.\n", vp.Y);
        ok(vp.Width == 400, "D3DVIEWPORT->Width = %u, expected 400.\n", vp.Width);
        ok(vp.Height == 300, "D3DVIEWPORT->Height = %u, expected 300.\n", vp.Height);
        ok(vp.MinZ == 0, "D3DVIEWPORT->MinZ = %.8e, expected 0.\n", vp.MinZ);
        ok(vp.MaxZ == 1, "D3DVIEWPORT->MaxZ = %.8e, expected 1.\n", vp.MaxZ);
    }

    width = GetSystemMetrics(SM_CXSCREEN);
    height = GetSystemMetrics(SM_CYSCREEN);
    ok(width == orig_width, "Screen width is %u, expected %u.\n", width, orig_width);
    ok(height == orig_height, "Screen height is %u, expected %u.\n", height, orig_height);

    hr = IDirect3DDevice8_GetRenderTarget(device1, &surface);
    ok(SUCCEEDED(hr), "GetRenderTarget failed, hr %#x.\n", hr);
    hr = IDirect3DSurface8_GetDesc(surface, &surface_desc);
    ok(hr == D3D_OK, "GetDesc failed, hr %#x.\n", hr);
    ok(surface_desc.Width == 400, "Back buffer width is %u, expected 400.\n",
            surface_desc.Width);
    ok(surface_desc.Height == 300, "Back buffer height is %u, expected 300.\n",
            surface_desc.Height);
    IDirect3DSurface8_Release(surface);

    winrect.left = 0;
    winrect.top = 0;
    winrect.right = 200;
    winrect.bottom = 150;
    ok(AdjustWindowRect(&winrect, WS_OVERLAPPEDWINDOW, FALSE), "AdjustWindowRect failed\n");
    ok(SetWindowPos(window, NULL, 0, 0,
                    winrect.right-winrect.left,
                    winrect.bottom-winrect.top,
                    SWP_NOMOVE|SWP_NOZORDER),
       "SetWindowPos failed\n");

    memset(&d3dpp, 0, sizeof(d3dpp));
    d3dpp.SwapEffect = D3DSWAPEFFECT_DISCARD;
    d3dpp.Windowed = TRUE;
    d3dpp.BackBufferWidth = 0;
    d3dpp.BackBufferHeight = 0;
    d3dpp.BackBufferFormat = d3ddm.Format;
    hr = IDirect3DDevice8_Reset(device1, &d3dpp);
    ok(SUCCEEDED(hr), "Reset failed, hr %#x.\n", hr);
    hr = IDirect3DDevice8_TestCooperativeLevel(device1);
    ok(SUCCEEDED(hr), "TestCooperativeLevel failed, hr %#x.\n", hr);

    memset(&vp, 0, sizeof(vp));
    hr = IDirect3DDevice8_GetViewport(device1, &vp);
    ok(SUCCEEDED(hr), "GetViewport failed, hr %#x.\n", hr);
    if (SUCCEEDED(hr))
    {
        ok(vp.X == 0, "D3DVIEWPORT->X = %u, expected 0.\n", vp.X);
        ok(vp.Y == 0, "D3DVIEWPORT->Y = %u, expected 0.\n", vp.Y);
        ok(vp.Width == 200, "D3DVIEWPORT->Width = %u, expected 200.\n", vp.Width);
        ok(vp.Height == 150, "D3DVIEWPORT->Height = %u, expected 150.\n", vp.Height);
        ok(vp.MinZ == 0, "D3DVIEWPORT->MinZ = %.8e, expected 0.\n", vp.MinZ);
        ok(vp.MaxZ == 1, "D3DVIEWPORT->MaxZ = %.8e, expected 1.\n", vp.MaxZ);
    }

    hr = IDirect3DDevice8_GetRenderTarget(device1, &surface);
    ok(SUCCEEDED(hr), "GetRenderTarget failed, hr %#x.\n", hr);
    hr = IDirect3DSurface8_GetDesc(surface, &surface_desc);
    ok(hr == D3D_OK, "GetDesc failed, hr %#x.\n", hr);
    ok(surface_desc.Width == 200, "Back buffer width is %u, expected 200.\n", surface_desc.Width);
    ok(surface_desc.Height == 150, "Back buffer height is %u, expected 150.\n", surface_desc.Height);
    IDirect3DSurface8_Release(surface);

    memset(&d3dpp, 0, sizeof(d3dpp));
    d3dpp.SwapEffect = D3DSWAPEFFECT_DISCARD;
    d3dpp.Windowed = TRUE;
    d3dpp.BackBufferWidth = 400;
    d3dpp.BackBufferHeight = 300;
    d3dpp.BackBufferFormat = d3ddm.Format;

    /* Reset fails if there is a resource in the default pool. */
    hr = IDirect3DDevice8_CreateTexture(device1, 16, 16, 1, 0, D3DFMT_R5G6B5, D3DPOOL_DEFAULT, &texture);
    ok(SUCCEEDED(hr), "CreateTexture failed, hr %#x.\n", hr);
    hr = IDirect3DDevice8_Reset(device1, &d3dpp);
    ok(hr == D3DERR_DEVICELOST, "Reset returned %#x, expected %#x.\n", hr, D3DERR_DEVICELOST);
    hr = IDirect3DDevice8_TestCooperativeLevel(device1);
    ok(hr == D3DERR_DEVICENOTRESET, "TestCooperativeLevel returned %#x, expected %#x.\n", hr, D3DERR_DEVICENOTRESET);
    IDirect3DTexture8_Release(texture);
    /* Reset again to get the device out of the lost state. */
    hr = IDirect3DDevice8_Reset(device1, &d3dpp);
    ok(SUCCEEDED(hr), "Reset failed, hr %#x.\n", hr);
    hr = IDirect3DDevice8_TestCooperativeLevel(device1);
    ok(SUCCEEDED(hr), "TestCooperativeLevel failed, hr %#x.\n", hr);

    if (caps.TextureCaps & D3DPTEXTURECAPS_VOLUMEMAP)
    {
        IDirect3DVolumeTexture8 *volume_texture;

        hr = IDirect3DDevice8_CreateVolumeTexture(device1, 16, 16, 4, 1, 0,
                D3DFMT_R5G6B5, D3DPOOL_DEFAULT, &volume_texture);
        ok(SUCCEEDED(hr), "CreateVolumeTexture failed, hr %#x.\n", hr);
        hr = IDirect3DDevice8_Reset(device1, &d3dpp);
        ok(hr == D3DERR_DEVICELOST, "Reset returned %#x, expected %#x.\n", hr, D3DERR_INVALIDCALL);
        hr = IDirect3DDevice8_TestCooperativeLevel(device1);
        ok(hr == D3DERR_DEVICENOTRESET, "TestCooperativeLevel returned %#x, expected %#x.\n",
                hr, D3DERR_DEVICENOTRESET);
        IDirect3DVolumeTexture8_Release(volume_texture);
        hr = IDirect3DDevice8_Reset(device1, &d3dpp);
        ok(SUCCEEDED(hr), "Reset failed, hr %#x.\n", hr);
        hr = IDirect3DDevice8_TestCooperativeLevel(device1);
        ok(SUCCEEDED(hr), "TestCooperativeLevel failed, hr %#x.\n", hr);
    }
    else
    {
        skip("Volume textures not supported.\n");
    }

    /* Scratch, sysmem and managed pool resources are fine. */
    hr = IDirect3DDevice8_CreateTexture(device1, 16, 16, 1, 0, D3DFMT_R5G6B5, D3DPOOL_SCRATCH, &texture);
    ok(SUCCEEDED(hr), "CreateTexture failed, hr %#x.\n", hr);
    hr = IDirect3DDevice8_Reset(device1, &d3dpp);
    ok(SUCCEEDED(hr), "Reset failed, hr %#x.\n", hr);
    hr = IDirect3DDevice8_TestCooperativeLevel(device1);
    ok(SUCCEEDED(hr), "TestCooperativeLevel failed, hr %#x.\n", hr);
    IDirect3DTexture8_Release(texture);

    hr = IDirect3DDevice8_CreateTexture(device1, 16, 16, 1, 0, D3DFMT_R5G6B5, D3DPOOL_SYSTEMMEM, &texture);
    ok(SUCCEEDED(hr), "CreateTexture failed, hr %#x.\n", hr);
    hr = IDirect3DDevice8_Reset(device1, &d3dpp);
    ok(SUCCEEDED(hr), "Reset failed, hr %#x.\n", hr);
    hr = IDirect3DDevice8_TestCooperativeLevel(device1);
    ok(SUCCEEDED(hr), "TestCooperativeLevel failed, hr %#x.\n", hr);
    IDirect3DTexture8_Release(texture);

    /* The depth stencil should get reset to the auto depth stencil when present. */
    hr = IDirect3DDevice8_SetRenderTarget(device1, NULL, NULL);
    ok(SUCCEEDED(hr), "SetRenderTarget failed, hr %#x.\n", hr);

    hr = IDirect3DDevice8_GetDepthStencilSurface(device1, &surface);
    ok(hr == D3DERR_NOTFOUND, "GetDepthStencilSurface returned %#x, expected %#x.\n", hr, D3DERR_NOTFOUND);
    ok(!surface, "Depth / stencil buffer should be NULL.\n");

    d3dpp.EnableAutoDepthStencil = TRUE;
    d3dpp.AutoDepthStencilFormat = D3DFMT_D24S8;
    hr = IDirect3DDevice8_Reset(device1, &d3dpp);
    ok(SUCCEEDED(hr), "Reset failed, hr %#x.\n", hr);

    hr = IDirect3DDevice8_GetDepthStencilSurface(device1, &surface);
    ok(SUCCEEDED(hr), "GetDepthStencilSurface failed, hr %#x.\n", hr);
    ok(!!surface, "Depth / stencil buffer should not be NULL.\n");
    if (surface) IDirect3DSurface8_Release(surface);

    d3dpp.EnableAutoDepthStencil = FALSE;
    hr = IDirect3DDevice8_Reset(device1, &d3dpp);
    ok(SUCCEEDED(hr), "Reset failed, hr %#x.\n", hr);

    hr = IDirect3DDevice8_GetDepthStencilSurface(device1, &surface);
    ok(hr == D3DERR_NOTFOUND, "GetDepthStencilSurface returned %#x, expected %#x.\n", hr, D3DERR_NOTFOUND);
    ok(!surface, "Depth / stencil buffer should be NULL.\n");

    /* Will a sysmem or scratch resource survive while locked? */
    hr = IDirect3DDevice8_CreateTexture(device1, 16, 16, 1, 0, D3DFMT_R5G6B5, D3DPOOL_SYSTEMMEM, &texture);
    ok(SUCCEEDED(hr), "CreateTexture failed, hr %#x.\n", hr);
    hr = IDirect3DTexture8_LockRect(texture, 0, &lockrect, NULL, D3DLOCK_DISCARD);
    ok(SUCCEEDED(hr), "LockRect failed, hr %#x.\n", hr);
    hr = IDirect3DDevice8_Reset(device1, &d3dpp);
    ok(SUCCEEDED(hr), "Reset failed, hr %#x.\n", hr);
    hr = IDirect3DDevice8_TestCooperativeLevel(device1);
    ok(SUCCEEDED(hr), "TestCooperativeLevel failed, hr %#x.\n", hr);
    IDirect3DTexture8_UnlockRect(texture, 0);
    IDirect3DTexture8_Release(texture);

    hr = IDirect3DDevice8_CreateTexture(device1, 16, 16, 1, 0, D3DFMT_R5G6B5, D3DPOOL_SCRATCH, &texture);
    ok(SUCCEEDED(hr), "CreateTexture failed, hr %#x.\n", hr);
    hr = IDirect3DTexture8_LockRect(texture, 0, &lockrect, NULL, D3DLOCK_DISCARD);
    ok(SUCCEEDED(hr), "LockRect failed, hr %#x.\n", hr);
    hr = IDirect3DDevice8_Reset(device1, &d3dpp);
    ok(SUCCEEDED(hr), "Reset failed, hr %#x.\n", hr);
    hr = IDirect3DDevice8_TestCooperativeLevel(device1);
    ok(SUCCEEDED(hr), "TestCooperativeLevel failed, hr %#x.\n", hr);
    IDirect3DTexture8_UnlockRect(texture, 0);
    IDirect3DTexture8_Release(texture);

    hr = IDirect3DDevice8_CreateTexture(device1, 16, 16, 1, 0, D3DFMT_R5G6B5, D3DPOOL_MANAGED, &texture);
    ok(SUCCEEDED(hr), "CreateTexture failed, hr %#x.\n", hr);
    hr = IDirect3DDevice8_Reset(device1, &d3dpp);
    ok(SUCCEEDED(hr), "Reset failed, hr %#x.\n", hr);
    hr = IDirect3DDevice8_TestCooperativeLevel(device1);
    ok(SUCCEEDED(hr), "TestCooperativeLevel failed, hr %#x.\n", hr);
    IDirect3DTexture8_Release(texture);

    /* A reference held to an implicit surface causes failures as well. */
    hr = IDirect3DDevice8_GetBackBuffer(device1, 0, D3DBACKBUFFER_TYPE_MONO, &surface);
    ok(SUCCEEDED(hr), "GetBackBuffer failed, hr %#x.\n", hr);
    hr = IDirect3DDevice8_Reset(device1, &d3dpp);
    ok(hr == D3DERR_DEVICELOST, "Reset returned %#x, expected %#x.\n", hr, D3DERR_DEVICELOST);
    hr = IDirect3DDevice8_TestCooperativeLevel(device1);
    ok(hr == D3DERR_DEVICENOTRESET, "TestCooperativeLevel returned %#x, expected %#x.\n", hr, D3DERR_DEVICENOTRESET);
    IDirect3DSurface8_Release(surface);
    hr = IDirect3DDevice8_Reset(device1, &d3dpp);
    ok(SUCCEEDED(hr), "Reset failed, hr %#x.\n", hr);
    hr = IDirect3DDevice8_TestCooperativeLevel(device1);
    ok(SUCCEEDED(hr), "TestCooperativeLevel failed, hr %#x.\n", hr);

    /* Shaders are fine as well. */
    hr = IDirect3DDevice8_CreateVertexShader(device1, decl, simple_vs, &shader, 0);
    ok(SUCCEEDED(hr), "CreateVertexShader failed, hr %#x.\n", hr);
    hr = IDirect3DDevice8_Reset(device1, &d3dpp);
    ok(SUCCEEDED(hr), "Reset failed, hr %#x.\n", hr);
    hr = IDirect3DDevice8_DeleteVertexShader(device1, shader);
    ok(SUCCEEDED(hr), "DeleteVertexShader failed, hr %#x.\n", hr);

    /* Try setting invalid modes. */
    memset(&d3dpp, 0, sizeof(d3dpp));
    d3dpp.SwapEffect = D3DSWAPEFFECT_DISCARD;
    d3dpp.Windowed = FALSE;
    d3dpp.BackBufferWidth = 32;
    d3dpp.BackBufferHeight = 32;
    d3dpp.BackBufferFormat = d3ddm.Format;
    hr = IDirect3DDevice8_Reset(device1, &d3dpp);
    ok(hr == D3DERR_INVALIDCALL, "Reset returned %#x, expected %#x.\n", hr, D3DERR_INVALIDCALL);
    hr = IDirect3DDevice8_TestCooperativeLevel(device1);
    ok(hr == D3DERR_DEVICENOTRESET, "TestCooperativeLevel returned %#x, expected %#x.\n", hr, D3DERR_DEVICENOTRESET);

    memset(&d3dpp, 0, sizeof(d3dpp));
    d3dpp.SwapEffect = D3DSWAPEFFECT_DISCARD;
    d3dpp.Windowed = FALSE;
    d3dpp.BackBufferWidth = 801;
    d3dpp.BackBufferHeight = 600;
    d3dpp.BackBufferFormat = d3ddm.Format;
    hr = IDirect3DDevice8_Reset(device1, &d3dpp);
    ok(hr == D3DERR_INVALIDCALL, "Reset returned %#x, expected %#x.\n", hr, D3DERR_INVALIDCALL);
    hr = IDirect3DDevice8_TestCooperativeLevel(device1);
    ok(hr == D3DERR_DEVICENOTRESET, "TestCooperativeLevel returned %#x, expected %#x.\n", hr, D3DERR_DEVICENOTRESET);

    memset(&d3dpp, 0, sizeof(d3dpp));
    d3dpp.SwapEffect = D3DSWAPEFFECT_DISCARD;
    d3dpp.Windowed = FALSE;
    d3dpp.BackBufferWidth = 0;
    d3dpp.BackBufferHeight = 0;
    d3dpp.BackBufferFormat = d3ddm.Format;
    hr = IDirect3DDevice8_Reset(device1, &d3dpp);
    ok(hr == D3DERR_INVALIDCALL, "Reset returned %#x, expected %#x.\n", hr, D3DERR_INVALIDCALL);
    hr = IDirect3DDevice8_TestCooperativeLevel(device1);
    ok(hr == D3DERR_DEVICENOTRESET, "TestCooperativeLevel returned %#x, expected %#x.\n", hr, D3DERR_DEVICENOTRESET);

    hr = IDirect3D8_GetAdapterDisplayMode(d3d8, D3DADAPTER_DEFAULT, &d3ddm);
    ok(SUCCEEDED(hr), "GetAdapterDisplayMode failed, hr %#x.\n", hr);

    memset(&d3dpp, 0, sizeof(d3dpp));
    d3dpp.Windowed = TRUE;
    d3dpp.SwapEffect = D3DSWAPEFFECT_DISCARD;
    d3dpp.BackBufferFormat = d3ddm.Format;
    d3dpp.EnableAutoDepthStencil = FALSE;
    d3dpp.AutoDepthStencilFormat = D3DFMT_D24S8;

    hr = IDirect3D8_CreateDevice(d3d8, D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL,
            window, D3DCREATE_SOFTWARE_VERTEXPROCESSING, &d3dpp, &device2);
    if (FAILED(hr))
    {
        skip("Failed to create device, hr %#x.\n", hr);
        goto cleanup;
    }

    hr = IDirect3DDevice8_TestCooperativeLevel(device2);
    ok(SUCCEEDED(hr), "TestCooperativeLevel failed, hr %#x.\n", hr);

    d3dpp.Windowed = TRUE;
    d3dpp.SwapEffect = D3DSWAPEFFECT_DISCARD;
    d3dpp.BackBufferWidth = 400;
    d3dpp.BackBufferHeight = 300;
    d3dpp.BackBufferFormat = d3ddm.Format;
    d3dpp.EnableAutoDepthStencil = TRUE;
    d3dpp.AutoDepthStencilFormat = D3DFMT_D24S8;

    hr = IDirect3DDevice8_Reset(device2, &d3dpp);
    ok(SUCCEEDED(hr), "Reset failed, hr %#x.\n", hr);
    if (FAILED(hr))
        goto cleanup;

    hr = IDirect3DDevice8_GetDepthStencilSurface(device2, &surface);
    ok(SUCCEEDED(hr), "GetDepthStencilSurface failed, hr %#x.\n", hr);
    ok(!!surface, "Depth / stencil buffer should not be NULL.\n");
    if (surface)
        IDirect3DSurface8_Release(surface);

cleanup:
    HeapFree(GetProcessHeap(), 0, modes);
    if (device2)
        IDirect3DDevice8_Release(device2);
    if (device1)
        IDirect3DDevice8_Release(device1);
    if (d3d8)
        IDirect3D8_Release(d3d8);
    if (window)
        DestroyWindow(window);
}

static void test_scene(void)
{
    HRESULT                      hr;
    HWND                         hwnd               = NULL;
    IDirect3D8                  *pD3d               = NULL;
    IDirect3DDevice8            *pDevice            = NULL;
    D3DPRESENT_PARAMETERS        d3dpp;
    D3DDISPLAYMODE               d3ddm;

    pD3d = pDirect3DCreate8( D3D_SDK_VERSION );
    ok(pD3d != NULL, "Failed to create IDirect3D8 object\n");
    hwnd = CreateWindow( "d3d8_test_wc", "d3d8_test", WS_OVERLAPPEDWINDOW, 100, 100, 160, 160, NULL, NULL, NULL, NULL );
    ok(hwnd != NULL, "Failed to create window\n");
    if (!pD3d || !hwnd) goto cleanup;

    IDirect3D8_GetAdapterDisplayMode( pD3d, D3DADAPTER_DEFAULT, &d3ddm );
    ZeroMemory( &d3dpp, sizeof(d3dpp) );
    d3dpp.Windowed         = TRUE;
    d3dpp.SwapEffect       = D3DSWAPEFFECT_DISCARD;
    d3dpp.BackBufferWidth  = 800;
    d3dpp.BackBufferHeight = 600;
    d3dpp.BackBufferFormat = d3ddm.Format;


    hr = IDirect3D8_CreateDevice( pD3d, D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL /* no NULLREF here */, hwnd,
                                  D3DCREATE_SOFTWARE_VERTEXPROCESSING, &d3dpp, &pDevice );
    ok(hr == D3D_OK || hr == D3DERR_INVALIDCALL || broken(hr == D3DERR_NOTAVAILABLE), "IDirect3D8_CreateDevice failed with %#08x\n", hr);
    if(!pDevice)
    {
        skip("could not create device, IDirect3D8_CreateDevice returned %#08x\n", hr);
        goto cleanup;
    }

    /* Test an EndScene without BeginScene. Should return an error */
    hr = IDirect3DDevice8_EndScene(pDevice);
    ok(hr == D3DERR_INVALIDCALL, "IDirect3DDevice8_EndScene returned %#08x\n", hr);

    /* Test a normal BeginScene / EndScene pair, this should work */
    hr = IDirect3DDevice8_BeginScene(pDevice);
    ok(hr == D3D_OK, "IDirect3DDevice8_BeginScene failed with %#08x\n", hr);
    if(SUCCEEDED(hr))
    {
        hr = IDirect3DDevice8_EndScene(pDevice);
        ok(hr == D3D_OK, "IDirect3DDevice8_EndScene failed with %#08x\n", hr);
    }

    /* Test another EndScene without having begun a new scene. Should return an error */
    hr = IDirect3DDevice8_EndScene(pDevice);
    ok(hr == D3DERR_INVALIDCALL, "IDirect3DDevice8_EndScene returned %#08x\n", hr);

    /* Two nested BeginScene and EndScene calls */
    hr = IDirect3DDevice8_BeginScene(pDevice);
    ok(hr == D3D_OK, "IDirect3DDevice8_BeginScene failed with %#08x\n", hr);
    hr = IDirect3DDevice8_BeginScene(pDevice);
    ok(hr == D3DERR_INVALIDCALL, "IDirect3DDevice8_BeginScene returned %#08x\n", hr);
    hr = IDirect3DDevice8_EndScene(pDevice);
    ok(hr == D3D_OK, "IDirect3DDevice8_EndScene failed with %#08x\n", hr);
    hr = IDirect3DDevice8_EndScene(pDevice);
    ok(hr == D3DERR_INVALIDCALL, "IDirect3DDevice8_EndScene returned %#08x\n", hr);

    /* StretchRect does not exit in Direct3D8, so no equivalent to the d3d9 stretchrect tests */

cleanup:
    if (pDevice)
    {
        UINT refcount = IDirect3DDevice8_Release(pDevice);
        ok(!refcount, "Device has %u references left.\n", refcount);
    }
    if (pD3d) IDirect3D8_Release(pD3d);
    DestroyWindow(hwnd);
}

static void test_shader(void)
{
    HRESULT                      hr;
    HWND                         hwnd               = NULL;
    IDirect3D8                  *pD3d               = NULL;
    IDirect3DDevice8            *pDevice            = NULL;
    D3DPRESENT_PARAMETERS        d3dpp;
    D3DDISPLAYMODE               d3ddm;
    DWORD                        hPixelShader = 0, hVertexShader = 0;
    DWORD                        hPixelShader2 = 0, hVertexShader2 = 0;
    DWORD                        hTempHandle;
    D3DCAPS8                     caps;
    DWORD fvf = D3DFVF_XYZ | D3DFVF_DIFFUSE;
    DWORD data_size;
    void *data;

    static DWORD dwVertexDecl[] =
    {
        D3DVSD_STREAM(0),
        D3DVSD_REG(D3DVSDE_POSITION,  D3DVSDT_FLOAT3),
        D3DVSD_END()
    };
    DWORD decl_normal_float2[] =
    {
        D3DVSD_STREAM(0),
        D3DVSD_REG(D3DVSDE_POSITION, D3DVSDT_FLOAT3),  /* D3DVSDE_POSITION, Register v0 */
        D3DVSD_REG(D3DVSDE_NORMAL,   D3DVSDT_FLOAT2),  /* D3DVSDE_NORMAL,   Register v1 */
        D3DVSD_END()
    };
    DWORD decl_normal_float4[] =
    {
        D3DVSD_STREAM(0),
        D3DVSD_REG(D3DVSDE_POSITION, D3DVSDT_FLOAT3),  /* D3DVSDE_POSITION, Register v0 */
        D3DVSD_REG(D3DVSDE_NORMAL,   D3DVSDT_FLOAT4),  /* D3DVSDE_NORMAL,   Register v1 */
        D3DVSD_END()
    };
    DWORD decl_normal_d3dcolor[] =
    {
        D3DVSD_STREAM(0),
        D3DVSD_REG(D3DVSDE_POSITION, D3DVSDT_FLOAT3),  /* D3DVSDE_POSITION, Register v0 */
        D3DVSD_REG(D3DVSDE_NORMAL,   D3DVSDT_D3DCOLOR),/* D3DVSDE_NORMAL,   Register v1 */
        D3DVSD_END()
    };
    const DWORD vertex_decl_size = sizeof(dwVertexDecl);
    const DWORD simple_vs_size = sizeof(simple_vs);
    const DWORD simple_ps_size = sizeof(simple_ps);

    pD3d = pDirect3DCreate8( D3D_SDK_VERSION );
    ok(pD3d != NULL, "Failed to create IDirect3D8 object\n");
    hwnd = CreateWindow( "d3d8_test_wc", "d3d8_test", WS_OVERLAPPEDWINDOW, 100, 100, 160, 160, NULL, NULL, NULL, NULL );
    ok(hwnd != NULL, "Failed to create window\n");
    if (!pD3d || !hwnd) goto cleanup;

    IDirect3D8_GetAdapterDisplayMode( pD3d, D3DADAPTER_DEFAULT, &d3ddm );
    ZeroMemory( &d3dpp, sizeof(d3dpp) );
    d3dpp.Windowed         = TRUE;
    d3dpp.SwapEffect       = D3DSWAPEFFECT_DISCARD;
    d3dpp.BackBufferWidth  = 800;
    d3dpp.BackBufferHeight = 600;
    d3dpp.BackBufferFormat = d3ddm.Format;


    hr = IDirect3D8_CreateDevice( pD3d, D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL /* no NULLREF here */, hwnd,
                                  D3DCREATE_SOFTWARE_VERTEXPROCESSING, &d3dpp, &pDevice );
    ok(hr == D3D_OK || hr == D3DERR_INVALIDCALL || broken(hr == D3DERR_NOTAVAILABLE), "IDirect3D8_CreateDevice failed with %#08x\n", hr);
    if(!pDevice)
    {
        skip("could not create device, IDirect3D8_CreateDevice returned %#08x\n", hr);
        goto cleanup;
    }
    IDirect3DDevice8_GetDeviceCaps(pDevice, &caps);

    /* Test setting and retrieving a FVF */
    hr = IDirect3DDevice8_SetVertexShader(pDevice, fvf);
    ok(SUCCEEDED(hr), "IDirect3DDevice8_SetVertexShader returned %#08x\n", hr);
    hr = IDirect3DDevice8_GetVertexShader(pDevice, &hTempHandle);
    ok(SUCCEEDED(hr), "IDirect3DDevice8_GetVertexShader returned %#08x\n", hr);
    ok(hTempHandle == fvf, "Vertex shader %#08x is set, expected %#08x\n", hTempHandle, fvf);

    /* First create a vertex shader */
    hr = IDirect3DDevice8_SetVertexShader(pDevice, 0);
    ok(SUCCEEDED(hr), "IDirect3DDevice8_SetVertexShader returned %#08x\n", hr);
    hr = IDirect3DDevice8_CreateVertexShader(pDevice, dwVertexDecl, simple_vs, &hVertexShader, 0);
    ok(hr == D3D_OK, "IDirect3DDevice8_CreateVertexShader returned %#08x\n", hr);
    /* Msdn says that the new vertex shader is set immediately. This is wrong, apparently */
    hr = IDirect3DDevice8_GetVertexShader(pDevice, &hTempHandle);
    ok(hr == D3D_OK, "IDirect3DDevice8_GetVertexShader returned %#08x\n", hr);
    ok(hTempHandle == 0, "Vertex Shader %d is set, expected shader %d\n", hTempHandle, 0);
    /* Assign the shader, then verify that GetVertexShader works */
    hr = IDirect3DDevice8_SetVertexShader(pDevice, hVertexShader);
    ok(hr == D3D_OK, "IDirect3DDevice8_SetVertexShader returned %#08x\n", hr);
    hr = IDirect3DDevice8_GetVertexShader(pDevice, &hTempHandle);
    ok(hr == D3D_OK, "IDirect3DDevice8_GetVertexShader returned %#08x\n", hr);
    ok(hTempHandle == hVertexShader, "Vertex Shader %d is set, expected shader %d\n", hTempHandle, hVertexShader);
    /* Verify that we can retrieve the declaration */
    hr = IDirect3DDevice8_GetVertexShaderDeclaration(pDevice, hVertexShader, NULL, &data_size);
    ok(hr == D3D_OK, "IDirect3DDevice8_GetVertexShaderDeclaration returned %#08x\n", hr);
    ok(data_size == vertex_decl_size, "Got data_size %u, expected %u\n", data_size, vertex_decl_size);
    data = HeapAlloc(GetProcessHeap(), 0, vertex_decl_size);
    data_size = 1;
    hr = IDirect3DDevice8_GetVertexShaderDeclaration(pDevice, hVertexShader, data, &data_size);
    ok(hr == D3DERR_INVALIDCALL, "IDirect3DDevice8_GetVertexShaderDeclaration returned (%#08x), "
            "expected D3DERR_INVALIDCALL\n", hr);
    ok(data_size == 1, "Got data_size %u, expected 1\n", data_size);
    data_size = vertex_decl_size;
    hr = IDirect3DDevice8_GetVertexShaderDeclaration(pDevice, hVertexShader, data, &data_size);
    ok(hr == D3D_OK, "IDirect3DDevice8_GetVertexShaderDeclaration returned %#08x\n", hr);
    ok(data_size == vertex_decl_size, "Got data_size %u, expected %u\n", data_size, vertex_decl_size);
    ok(!memcmp(data, dwVertexDecl, vertex_decl_size), "data not equal to shader declaration\n");
    HeapFree(GetProcessHeap(), 0, data);
    /* Verify that we can retrieve the shader function */
    hr = IDirect3DDevice8_GetVertexShaderFunction(pDevice, hVertexShader, NULL, &data_size);
    ok(hr == D3D_OK, "IDirect3DDevice8_GetVertexShaderFunction returned %#08x\n", hr);
    ok(data_size == simple_vs_size, "Got data_size %u, expected %u\n", data_size, simple_vs_size);
    data = HeapAlloc(GetProcessHeap(), 0, simple_vs_size);
    data_size = 1;
    hr = IDirect3DDevice8_GetVertexShaderFunction(pDevice, hVertexShader, data, &data_size);
    ok(hr == D3DERR_INVALIDCALL, "IDirect3DDevice8_GetVertexShaderFunction returned (%#08x), "
            "expected D3DERR_INVALIDCALL\n", hr);
    ok(data_size == 1, "Got data_size %u, expected 1\n", data_size);
    data_size = simple_vs_size;
    hr = IDirect3DDevice8_GetVertexShaderFunction(pDevice, hVertexShader, data, &data_size);
    ok(hr == D3D_OK, "IDirect3DDevice8_GetVertexShaderFunction returned %#08x\n", hr);
    ok(data_size == simple_vs_size, "Got data_size %u, expected %u\n", data_size, simple_vs_size);
    ok(!memcmp(data, simple_vs, simple_vs_size), "data not equal to shader function\n");
    HeapFree(GetProcessHeap(), 0, data);
    /* Delete the assigned shader. This is supposed to work */
    hr = IDirect3DDevice8_DeleteVertexShader(pDevice, hVertexShader);
    ok(hr == D3D_OK, "IDirect3DDevice8_DeleteVertexShader returned %#08x\n", hr);
    /* The shader should be unset now */
    hr = IDirect3DDevice8_GetVertexShader(pDevice, &hTempHandle);
    ok(hr == D3D_OK, "IDirect3DDevice8_GetVertexShader returned %#08x\n", hr);
    ok(hTempHandle == 0, "Vertex Shader %d is set, expected shader %d\n", hTempHandle, 0);

    /* Test a broken declaration. 3DMark2001 tries to use normals with 2 components
     * First try the fixed function shader function, then a custom one
     */
    hr = IDirect3DDevice8_CreateVertexShader(pDevice, decl_normal_float2, 0, &hVertexShader, 0);
    ok(hr == D3DERR_INVALIDCALL, "IDirect3DDevice8_CreateVertexShader returned %#08x\n", hr);
    if(SUCCEEDED(hr)) IDirect3DDevice8_DeleteVertexShader(pDevice, hVertexShader);
    hr = IDirect3DDevice8_CreateVertexShader(pDevice, decl_normal_float4, 0, &hVertexShader, 0);
    ok(hr == D3DERR_INVALIDCALL, "IDirect3DDevice8_CreateVertexShader returned %#08x\n", hr);
    if(SUCCEEDED(hr)) IDirect3DDevice8_DeleteVertexShader(pDevice, hVertexShader);
    hr = IDirect3DDevice8_CreateVertexShader(pDevice, decl_normal_d3dcolor, 0, &hVertexShader, 0);
    ok(hr == D3DERR_INVALIDCALL, "IDirect3DDevice8_CreateVertexShader returned %#08x\n", hr);
    if(SUCCEEDED(hr)) IDirect3DDevice8_DeleteVertexShader(pDevice, hVertexShader);

    hr = IDirect3DDevice8_CreateVertexShader(pDevice, decl_normal_float2, simple_vs, &hVertexShader, 0);
    ok(hr == D3D_OK, "IDirect3DDevice8_CreateVertexShader returned %#08x\n", hr);
    if(SUCCEEDED(hr)) IDirect3DDevice8_DeleteVertexShader(pDevice, hVertexShader);

    if (caps.PixelShaderVersion >= D3DPS_VERSION(1, 0))
    {
        /* The same with a pixel shader */
        hr = IDirect3DDevice8_CreatePixelShader(pDevice, simple_ps, &hPixelShader);
        ok(hr == D3D_OK, "IDirect3DDevice8_CreatePixelShader returned %#08x\n", hr);
        /* Msdn says that the new pixel shader is set immediately. This is wrong, apparently */
        hr = IDirect3DDevice8_GetPixelShader(pDevice, &hTempHandle);
        ok(hr == D3D_OK, "IDirect3DDevice8_GetPixelShader returned %#08x\n", hr);
        ok(hTempHandle == 0, "Pixel Shader %d is set, expected shader %d\n", hTempHandle, 0);
        /* Assign the shader, then verify that GetPixelShader works */
        hr = IDirect3DDevice8_SetPixelShader(pDevice, hPixelShader);
        ok(hr == D3D_OK, "IDirect3DDevice8_SetPixelShader returned %#08x\n", hr);
        hr = IDirect3DDevice8_GetPixelShader(pDevice, &hTempHandle);
        ok(hr == D3D_OK, "IDirect3DDevice8_GetPixelShader returned %#08x\n", hr);
        ok(hTempHandle == hPixelShader, "Pixel Shader %d is set, expected shader %d\n", hTempHandle, hPixelShader);
        /* Verify that we can retrieve the shader function */
        hr = IDirect3DDevice8_GetPixelShaderFunction(pDevice, hPixelShader, NULL, &data_size);
        ok(hr == D3D_OK, "IDirect3DDevice8_GetPixelShaderFunction returned %#08x\n", hr);
        ok(data_size == simple_ps_size, "Got data_size %u, expected %u\n", data_size, simple_ps_size);
        data = HeapAlloc(GetProcessHeap(), 0, simple_ps_size);
        data_size = 1;
        hr = IDirect3DDevice8_GetPixelShaderFunction(pDevice, hPixelShader, data, &data_size);
        ok(hr == D3DERR_INVALIDCALL, "IDirect3DDevice8_GetPixelShaderFunction returned (%#08x), "
                "expected D3DERR_INVALIDCALL\n", hr);
        ok(data_size == 1, "Got data_size %u, expected 1\n", data_size);
        data_size = simple_ps_size;
        hr = IDirect3DDevice8_GetPixelShaderFunction(pDevice, hPixelShader, data, &data_size);
        ok(hr == D3D_OK, "IDirect3DDevice8_GetPixelShaderFunction returned %#08x\n", hr);
        ok(data_size == simple_ps_size, "Got data_size %u, expected %u\n", data_size, simple_ps_size);
        ok(!memcmp(data, simple_ps, simple_ps_size), "data not equal to shader function\n");
        HeapFree(GetProcessHeap(), 0, data);
        /* Delete the assigned shader. This is supposed to work */
        hr = IDirect3DDevice8_DeletePixelShader(pDevice, hPixelShader);
        ok(hr == D3D_OK, "IDirect3DDevice8_DeletePixelShader returned %#08x\n", hr);
        /* The shader should be unset now */
        hr = IDirect3DDevice8_GetPixelShader(pDevice, &hTempHandle);
        ok(hr == D3D_OK, "IDirect3DDevice8_GetPixelShader returned %#08x\n", hr);
        ok(hTempHandle == 0, "Pixel Shader %d is set, expected shader %d\n", hTempHandle, 0);

        /* What happens if a non-bound shader is deleted? */
        hr = IDirect3DDevice8_CreatePixelShader(pDevice, simple_ps, &hPixelShader);
        ok(hr == D3D_OK, "IDirect3DDevice8_CreatePixelShader returned %#08x\n", hr);
        hr = IDirect3DDevice8_CreatePixelShader(pDevice, simple_ps, &hPixelShader2);
        ok(hr == D3D_OK, "IDirect3DDevice8_CreatePixelShader returned %#08x\n", hr);

        hr = IDirect3DDevice8_SetPixelShader(pDevice, hPixelShader);
        ok(hr == D3D_OK, "IDirect3DDevice8_SetPixelShader returned %#08x\n", hr);
        hr = IDirect3DDevice8_DeletePixelShader(pDevice, hPixelShader2);
        ok(hr == D3D_OK, "IDirect3DDevice8_DeletePixelShader returned %#08x\n", hr);
        hr = IDirect3DDevice8_GetPixelShader(pDevice, &hTempHandle);
        ok(hr == D3D_OK, "IDirect3DDevice8_GetPixelShader returned %#08x\n", hr);
        ok(hTempHandle == hPixelShader, "Pixel Shader %d is set, expected shader %d\n", hTempHandle, hPixelShader);
        hr = IDirect3DDevice8_DeletePixelShader(pDevice, hPixelShader);
        ok(hr == D3D_OK, "IDirect3DDevice8_DeletePixelShader returned %#08x\n", hr);

        /* Check for double delete. */
        hr = IDirect3DDevice8_DeletePixelShader(pDevice, hPixelShader2);
        ok(hr == D3DERR_INVALIDCALL || broken(hr == D3D_OK), "IDirect3DDevice8_DeletePixelShader returned %#08x\n", hr);
        hr = IDirect3DDevice8_DeletePixelShader(pDevice, hPixelShader);
        ok(hr == D3DERR_INVALIDCALL || broken(hr == D3D_OK), "IDirect3DDevice8_DeletePixelShader returned %#08x\n", hr);
    }
    else
    {
        skip("Pixel shaders not supported\n");
    }

    /* What happens if a non-bound shader is deleted? */
    hr = IDirect3DDevice8_CreateVertexShader(pDevice, dwVertexDecl, NULL, &hVertexShader, 0);
    ok(hr == D3D_OK, "IDirect3DDevice8_CreateVertexShader returned %#08x\n", hr);
    hr = IDirect3DDevice8_CreateVertexShader(pDevice, dwVertexDecl, NULL, &hVertexShader2, 0);
    ok(hr == D3D_OK, "IDirect3DDevice8_CreateVertexShader returned %#08x\n", hr);

    hr = IDirect3DDevice8_SetVertexShader(pDevice, hVertexShader);
    ok(hr == D3D_OK, "IDirect3DDevice8_SetVertexShader returned %#08x\n", hr);
    hr = IDirect3DDevice8_DeleteVertexShader(pDevice, hVertexShader2);
    ok(hr == D3D_OK, "IDirect3DDevice8_DeleteVertexShader returned %#08x\n", hr);
    hr = IDirect3DDevice8_GetVertexShader(pDevice, &hTempHandle);
    ok(hr == D3D_OK, "IDirect3DDevice8_GetVertexShader returned %#08x\n", hr);
    ok(hTempHandle == hVertexShader, "Vertex Shader %d is set, expected shader %d\n", hTempHandle, hVertexShader);
    hr = IDirect3DDevice8_DeleteVertexShader(pDevice, hVertexShader);
    ok(hr == D3D_OK, "IDirect3DDevice8_DeleteVertexShader returned %#08x\n", hr);

    /* Check for double delete. */
    hr = IDirect3DDevice8_DeleteVertexShader(pDevice, hVertexShader2);
    ok(hr == D3DERR_INVALIDCALL, "IDirect3DDevice8_DeleteVertexShader returned %#08x\n", hr);
    hr = IDirect3DDevice8_DeleteVertexShader(pDevice, hVertexShader);
    ok(hr == D3DERR_INVALIDCALL, "IDirect3DDevice8_DeleteVertexShader returned %#08x\n", hr);

cleanup:
    if (pDevice)
    {
        UINT refcount = IDirect3DDevice8_Release(pDevice);
        ok(!refcount, "Device has %u references left.\n", refcount);
    }
    if (pD3d) IDirect3D8_Release(pD3d);
    DestroyWindow(hwnd);
}

static void test_limits(void)
{
    HRESULT                      hr;
    HWND                         hwnd               = NULL;
    IDirect3D8                  *pD3d               = NULL;
    IDirect3DDevice8            *pDevice            = NULL;
    D3DPRESENT_PARAMETERS        d3dpp;
    D3DDISPLAYMODE               d3ddm;
    IDirect3DTexture8           *pTexture           = NULL;
    int i;

    pD3d = pDirect3DCreate8( D3D_SDK_VERSION );
    ok(pD3d != NULL, "Failed to create IDirect3D8 object\n");
    hwnd = CreateWindow( "d3d8_test_wc", "d3d8_test", WS_OVERLAPPEDWINDOW, 100, 100, 160, 160, NULL, NULL, NULL, NULL );
    ok(hwnd != NULL, "Failed to create window\n");
    if (!pD3d || !hwnd) goto cleanup;

    IDirect3D8_GetAdapterDisplayMode( pD3d, D3DADAPTER_DEFAULT, &d3ddm );
    ZeroMemory( &d3dpp, sizeof(d3dpp) );
    d3dpp.Windowed         = TRUE;
    d3dpp.SwapEffect       = D3DSWAPEFFECT_DISCARD;
    d3dpp.BackBufferWidth  = 800;
    d3dpp.BackBufferHeight = 600;
    d3dpp.BackBufferFormat = d3ddm.Format;
    d3dpp.EnableAutoDepthStencil = TRUE;
    d3dpp.AutoDepthStencilFormat = D3DFMT_D16;

    hr = IDirect3D8_CreateDevice( pD3d, D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL /* no NULLREF here */, hwnd,
                                  D3DCREATE_SOFTWARE_VERTEXPROCESSING, &d3dpp, &pDevice );
    ok(hr == D3D_OK || hr == D3DERR_INVALIDCALL || broken(hr == D3DERR_NOTAVAILABLE), "IDirect3D8_CreateDevice failed with %#08x\n", hr);
    if(!pDevice)
    {
        skip("could not create device, IDirect3D8_CreateDevice returned %#08x\n", hr);
        goto cleanup;
    }

    hr = IDirect3DDevice8_CreateTexture(pDevice, 16, 16, 1, 0, D3DFMT_A8R8G8B8, D3DPOOL_MANAGED, &pTexture);
    ok(hr == D3D_OK, "IDirect3DDevice8_CreateTexture failed with %#08x\n", hr);
    if(!pTexture) goto cleanup;

    /* There are 8 texture stages. We should be able to access all of them */
    for(i = 0; i < 8; i++) {
        hr = IDirect3DDevice8_SetTexture(pDevice, i, (IDirect3DBaseTexture8 *) pTexture);
        ok(hr == D3D_OK, "IDirect3DDevice8_SetTexture for sampler %d failed with %#08x\n", i, hr);
        hr = IDirect3DDevice8_SetTexture(pDevice, i, NULL);
        ok(hr == D3D_OK, "IDirect3DDevice8_SetTexture for sampler %d failed with %#08x\n", i, hr);
        hr = IDirect3DDevice8_SetTextureStageState(pDevice, i, D3DTSS_COLOROP, D3DTOP_ADD);
        ok(hr == D3D_OK, "IDirect3DDevice8_SetTextureStageState for texture %d failed with %#08x\n", i, hr);
    }

    /* Investigations show that accessing higher textures stage states does not return an error either. Writing
     * to too high texture stages(approximately texture 40) causes memory corruption in windows, so there is no
     * bounds checking but how do I test that?
     */

cleanup:
    if(pTexture) IDirect3DTexture8_Release(pTexture);
    if (pDevice)
    {
        UINT refcount = IDirect3DDevice8_Release(pDevice);
        ok(!refcount, "Device has %u references left.\n", refcount);
    }
    if (pD3d) IDirect3D8_Release(pD3d);
    DestroyWindow(hwnd);
}

static void test_lights(void)
{
    D3DPRESENT_PARAMETERS d3dpp;
    IDirect3DDevice8 *device = NULL;
    IDirect3D8 *d3d8;
    HWND hwnd;
    HRESULT hr;
    unsigned int i;
    BOOL enabled;
    D3DCAPS8 caps;
    D3DDISPLAYMODE               d3ddm;

    d3d8 = pDirect3DCreate8( D3D_SDK_VERSION );
    ok(d3d8 != NULL, "Failed to create IDirect3D8 object\n");
    hwnd = CreateWindow( "d3d8_test_wc", "d3d8_test", WS_OVERLAPPEDWINDOW, 100, 100, 160, 160, NULL, NULL, NULL, NULL );
    ok(hwnd != NULL, "Failed to create window\n");
    if (!d3d8 || !hwnd) goto cleanup;

    IDirect3D8_GetAdapterDisplayMode( d3d8, D3DADAPTER_DEFAULT, &d3ddm );
    ZeroMemory( &d3dpp, sizeof(d3dpp) );
    d3dpp.Windowed         = TRUE;
    d3dpp.SwapEffect       = D3DSWAPEFFECT_DISCARD;
    d3dpp.BackBufferWidth  = 800;
    d3dpp.BackBufferHeight = 600;
    d3dpp.BackBufferFormat = d3ddm.Format;
    d3dpp.EnableAutoDepthStencil = TRUE;
    d3dpp.AutoDepthStencilFormat = D3DFMT_D16;

    hr = IDirect3D8_CreateDevice( d3d8, D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL /* no NULLREF here */, hwnd,
                                  D3DCREATE_HARDWARE_VERTEXPROCESSING, &d3dpp, &device );
    ok(hr == D3D_OK || hr == D3DERR_NOTAVAILABLE || hr == D3DERR_INVALIDCALL,
       "IDirect3D8_CreateDevice failed with %08x\n", hr);
    if(!device)
    {
        skip("Failed to create a d3d device\n");
        goto cleanup;
    }

    memset(&caps, 0, sizeof(caps));
    hr = IDirect3DDevice8_GetDeviceCaps(device, &caps);
    ok(hr == D3D_OK, "IDirect3DDevice8_GetDeviceCaps failed with %08x\n", hr);

    for(i = 1; i <= caps.MaxActiveLights; i++) {
        hr = IDirect3DDevice8_LightEnable(device, i, TRUE);
        ok(hr == D3D_OK, "Enabling light %u failed with %08x\n", i, hr);
        hr = IDirect3DDevice8_GetLightEnable(device, i, &enabled);
        ok(hr == D3D_OK || broken(hr == D3DERR_INVALIDCALL),
            "GetLightEnable on light %u failed with %08x\n", i, hr);
        ok(enabled, "Light %d is %s\n", i, enabled ? "enabled" : "disabled");
    }

    /* TODO: Test the rendering results in this situation */
    hr = IDirect3DDevice8_LightEnable(device, i + 1, TRUE);
    ok(hr == D3D_OK, "Enabling one light more than supported returned %08x\n", hr);
    hr = IDirect3DDevice8_GetLightEnable(device, i + 1, &enabled);
    ok(hr == D3D_OK, "GetLightEnable on light %u failed with %08x\n", i + 1, hr);
    ok(enabled, "Light %d is %s\n", i + 1, enabled ? "enabled" : "disabled");
    hr = IDirect3DDevice8_LightEnable(device, i + 1, FALSE);
    ok(hr == D3D_OK, "Disabling the additional returned %08x\n", hr);

    for(i = 1; i <= caps.MaxActiveLights; i++) {
        hr = IDirect3DDevice8_LightEnable(device, i, FALSE);
        ok(hr == D3D_OK, "Disabling light %u failed with %08x\n", i, hr);
    }

cleanup:
    if (device)
    {
        UINT refcount = IDirect3DDevice8_Release(device);
        ok(!refcount, "Device has %u references left.\n", refcount);
    }
    if (d3d8) IDirect3D8_Release(d3d8);
    DestroyWindow(hwnd);
}

static void test_render_zero_triangles(void)
{
    D3DPRESENT_PARAMETERS d3dpp;
    IDirect3DDevice8 *device = NULL;
    IDirect3D8 *d3d8;
    HWND hwnd;
    HRESULT hr;
    D3DDISPLAYMODE               d3ddm;

    struct nvertex
    {
        float x, y, z;
        float nx, ny, nz;
        DWORD diffuse;
    }  quad[] =
    {
        { 0.0f, -1.0f,   0.1f,  1.0f,   1.0f,   1.0f,   0xff0000ff},
        { 0.0f,  0.0f,   0.1f,  1.0f,   1.0f,   1.0f,   0xff0000ff},
        { 1.0f,  0.0f,   0.1f,  1.0f,   1.0f,   1.0f,   0xff0000ff},
        { 1.0f, -1.0f,   0.1f,  1.0f,   1.0f,   1.0f,   0xff0000ff},
    };

    d3d8 = pDirect3DCreate8( D3D_SDK_VERSION );
    ok(d3d8 != NULL, "Failed to create IDirect3D8 object\n");
    hwnd = CreateWindow( "d3d8_test_wc", "d3d8_test", WS_OVERLAPPEDWINDOW, 100, 100, 160, 160, NULL, NULL, NULL, NULL );
    ok(hwnd != NULL, "Failed to create window\n");
    if (!d3d8 || !hwnd) goto cleanup;

    IDirect3D8_GetAdapterDisplayMode( d3d8, D3DADAPTER_DEFAULT, &d3ddm );
    ZeroMemory( &d3dpp, sizeof(d3dpp) );
    d3dpp.Windowed         = TRUE;
    d3dpp.SwapEffect       = D3DSWAPEFFECT_DISCARD;
    d3dpp.BackBufferWidth  = 800;
    d3dpp.BackBufferHeight = 600;
    d3dpp.BackBufferFormat = d3ddm.Format;
    d3dpp.EnableAutoDepthStencil = TRUE;
    d3dpp.AutoDepthStencilFormat = D3DFMT_D16;

    hr = IDirect3D8_CreateDevice( d3d8, D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL /* no NULLREF here */, hwnd,
                                  D3DCREATE_HARDWARE_VERTEXPROCESSING | D3DCREATE_PUREDEVICE, &d3dpp, &device );
    ok(hr == D3D_OK || hr == D3DERR_NOTAVAILABLE || hr == D3DERR_INVALIDCALL,
       "IDirect3D8_CreateDevice failed with %08x\n", hr);
    if(!device)
    {
        skip("Failed to create a d3d device\n");
        goto cleanup;
    }

    hr = IDirect3DDevice8_SetVertexShader(device, D3DFVF_XYZ | D3DFVF_DIFFUSE);
    ok(hr == D3D_OK, "IDirect3DDevice8_SetVertexShader returned %#08x\n", hr);

    hr = IDirect3DDevice8_BeginScene(device);
    ok(hr == D3D_OK, "IDirect3DDevice8_BeginScene failed with %#08x\n", hr);
    if(hr == D3D_OK)
    {
        hr = IDirect3DDevice8_DrawIndexedPrimitiveUP(device, D3DPT_TRIANGLELIST, 0 /* MinIndex */, 0 /* NumVerts */,
                                                    0 /*PrimCount */, NULL, D3DFMT_INDEX16, quad, sizeof(quad[0]));
        ok(hr == D3D_OK, "IDirect3DDevice8_DrawIndexedPrimitiveUP failed with %#08x\n", hr);

        hr = IDirect3DDevice8_EndScene(device);
        ok(hr == D3D_OK, "IDirect3DDevice8_EndScene failed with %#08x\n", hr);
    }

    IDirect3DDevice8_Present(device, NULL, NULL, NULL, NULL);

cleanup:
    if (device)
    {
        UINT refcount = IDirect3DDevice8_Release(device);
        ok(!refcount, "Device has %u references left.\n", refcount);
    }
    if (d3d8) IDirect3D8_Release(d3d8);
    DestroyWindow(hwnd);
}

static void test_depth_stencil_reset(void)
{
    D3DPRESENT_PARAMETERS present_parameters;
    D3DDISPLAYMODE display_mode;
    IDirect3DSurface8 *surface, *orig_rt;
    IDirect3DDevice8 *device = NULL;
    IDirect3D8 *d3d8;
    UINT refcount;
    HRESULT hr;
    HWND hwnd;

    d3d8 = pDirect3DCreate8(D3D_SDK_VERSION);
    ok(d3d8 != NULL, "Failed to create IDirect3D8 object\n");
    hwnd = CreateWindow("d3d8_test_wc", "d3d8_test", WS_OVERLAPPEDWINDOW, 100, 100, 160, 160, NULL, NULL, NULL, NULL);
    ok(hwnd != NULL, "Failed to create window\n");
    if (!d3d8 || !hwnd) goto cleanup;

    IDirect3D8_GetAdapterDisplayMode(d3d8, D3DADAPTER_DEFAULT, &display_mode);
    memset(&present_parameters, 0, sizeof(present_parameters));
    present_parameters.Windowed               = TRUE;
    present_parameters.SwapEffect             = D3DSWAPEFFECT_DISCARD;
    present_parameters.BackBufferFormat       = display_mode.Format;
    present_parameters.EnableAutoDepthStencil = TRUE;
    present_parameters.AutoDepthStencilFormat = D3DFMT_D24S8;

    hr = IDirect3D8_CreateDevice(d3d8, D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL, hwnd,
            D3DCREATE_SOFTWARE_VERTEXPROCESSING, &present_parameters, &device);
    if(FAILED(hr))
    {
        skip("could not create device, IDirect3D8_CreateDevice returned %#x\n", hr);
        goto cleanup;
    }

    hr = IDirect3DDevice8_GetRenderTarget(device, &orig_rt);
    ok(hr == D3D_OK, "GetRenderTarget failed with 0x%08x\n", hr);

    hr = IDirect3DDevice8_TestCooperativeLevel(device);
    ok(SUCCEEDED(hr), "TestCooperativeLevel failed with %#x\n", hr);

    hr = IDirect3DDevice8_SetRenderTarget(device, NULL, NULL);
    ok(hr == D3D_OK, "SetRenderTarget failed with 0x%08x\n", hr);

    hr = IDirect3DDevice8_GetRenderTarget(device, &surface);
    ok(hr == D3D_OK, "GetRenderTarget failed with 0x%08x\n", hr);
    ok(surface == orig_rt, "Render target is %p, should be %p\n", surface, orig_rt);
    if (surface) IDirect3DSurface8_Release(surface);
    IDirect3DSurface8_Release(orig_rt);

    hr = IDirect3DDevice8_GetDepthStencilSurface(device, &surface);
    ok(hr == D3DERR_NOTFOUND, "GetDepthStencilSurface returned 0x%08x, expected D3DERR_NOTFOUND\n", hr);
    ok(surface == NULL, "Depth stencil should be NULL\n");

    present_parameters.EnableAutoDepthStencil = TRUE;
    present_parameters.AutoDepthStencilFormat = D3DFMT_D24S8;
    hr = IDirect3DDevice8_Reset(device, &present_parameters);
    ok(hr == D3D_OK, "Reset failed with 0x%08x\n", hr);

    hr = IDirect3DDevice8_GetDepthStencilSurface(device, &surface);
    ok(hr == D3D_OK, "GetDepthStencilSurface failed with 0x%08x\n", hr);
    ok(surface != NULL, "Depth stencil should not be NULL\n");
    if (surface) IDirect3DSurface8_Release(surface);

    present_parameters.EnableAutoDepthStencil = FALSE;
    hr = IDirect3DDevice8_Reset(device, &present_parameters);
    ok(hr == D3D_OK, "Reset failed with 0x%08x\n", hr);

    hr = IDirect3DDevice8_GetDepthStencilSurface(device, &surface);
    ok(hr == D3DERR_NOTFOUND, "GetDepthStencilSurface returned 0x%08x, expected D3DERR_NOTFOUND\n", hr);
    ok(surface == NULL, "Depth stencil should be NULL\n");

    refcount = IDirect3DDevice8_Release(device);
    ok(!refcount, "Device has %u references left.\n", refcount);
    device = NULL;

    IDirect3D8_GetAdapterDisplayMode( d3d8, D3DADAPTER_DEFAULT, &display_mode );

    ZeroMemory( &present_parameters, sizeof(present_parameters) );
    present_parameters.Windowed         = TRUE;
    present_parameters.SwapEffect       = D3DSWAPEFFECT_DISCARD;
    present_parameters.BackBufferFormat = display_mode.Format;
    present_parameters.EnableAutoDepthStencil = FALSE;
    present_parameters.AutoDepthStencilFormat = D3DFMT_D24S8;

    hr = IDirect3D8_CreateDevice( d3d8, D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL, hwnd,
                    D3DCREATE_SOFTWARE_VERTEXPROCESSING, &present_parameters, &device );

    if(FAILED(hr))
    {
        skip("could not create device, IDirect3D8_CreateDevice returned %#x\n", hr);
        goto cleanup;
    }

    hr = IDirect3DDevice8_TestCooperativeLevel(device);
    ok(hr == D3D_OK, "IDirect3DDevice8_TestCooperativeLevel after creation returned %#x\n", hr);

    present_parameters.SwapEffect       = D3DSWAPEFFECT_DISCARD;
    present_parameters.Windowed         = TRUE;
    present_parameters.BackBufferWidth  = 400;
    present_parameters.BackBufferHeight = 300;
    present_parameters.EnableAutoDepthStencil = TRUE;
    present_parameters.AutoDepthStencilFormat = D3DFMT_D24S8;

    hr = IDirect3DDevice8_Reset(device, &present_parameters);
    ok(hr == D3D_OK, "IDirect3DDevice8_Reset failed with 0x%08x\n", hr);

    if (FAILED(hr)) goto cleanup;

    hr = IDirect3DDevice8_GetDepthStencilSurface(device, &surface);
    ok(hr == D3D_OK, "GetDepthStencilSurface failed with 0x%08x\n", hr);
    ok(surface != NULL, "Depth stencil should not be NULL\n");
    if (surface) IDirect3DSurface8_Release(surface);

cleanup:
    if (device)
    {
        refcount = IDirect3DDevice8_Release(device);
        ok(!refcount, "Device has %u references left.\n", refcount);
    }
    if (d3d8) IDirect3D8_Release(d3d8);
    DestroyWindow(hwnd);
}

static HWND filter_messages;

enum message_window
{
    DEVICE_WINDOW,
    FOCUS_WINDOW,
};

struct message
{
    UINT message;
    enum message_window window;
};

static const struct message *expect_messages;
static HWND device_window, focus_window;

struct wndproc_thread_param
{
    HWND dummy_window;
    HANDLE window_created;
    HANDLE test_finished;
    BOOL running_in_foreground;
};

static LRESULT CALLBACK test_proc(HWND hwnd, UINT message, WPARAM wparam, LPARAM lparam)
{
    if (filter_messages && filter_messages == hwnd)
    {
        if (message != WM_DISPLAYCHANGE && message != WM_IME_NOTIFY)
            todo_wine ok(0, "Received unexpected message %#x for window %p.\n", message, hwnd);
    }

    if (expect_messages)
    {
        HWND w;

        switch (expect_messages->window)
        {
            case DEVICE_WINDOW:
                w = device_window;
                break;

            case FOCUS_WINDOW:
                w = focus_window;
                break;

            default:
                w = NULL;
                break;
        };

        if (hwnd == w && expect_messages->message == message) ++expect_messages;
    }

    return DefWindowProcA(hwnd, message, wparam, lparam);
}

static DWORD WINAPI wndproc_thread(void *param)
{
    struct wndproc_thread_param *p = param;
    DWORD res;
    BOOL ret;

    p->dummy_window = CreateWindowA("d3d8_test_wndproc_wc", "d3d8_test",
            WS_MAXIMIZE | WS_VISIBLE | WS_CAPTION, 0, 0, screen_width, screen_height, 0, 0, 0, 0);
    p->running_in_foreground = SetForegroundWindow(p->dummy_window);

    ret = SetEvent(p->window_created);
    ok(ret, "SetEvent failed, last error %#x.\n", GetLastError());

    for (;;)
    {
        MSG msg;

        while (PeekMessage(&msg, 0, 0, 0, PM_REMOVE)) DispatchMessage(&msg);
        res = WaitForSingleObject(p->test_finished, 100);
        if (res == WAIT_OBJECT_0) break;
        if (res != WAIT_TIMEOUT)
        {
            ok(0, "Wait failed (%#x), last error %#x.\n", res, GetLastError());
            break;
        }
    }

    DestroyWindow(p->dummy_window);

    return 0;
}

static void test_wndproc(void)
{
    struct wndproc_thread_param thread_params;
    IDirect3DDevice8 *device;
    WNDCLASSA wc = {0};
    IDirect3D8 *d3d8;
    HANDLE thread;
    LONG_PTR proc;
    ULONG ref;
    DWORD res, tid;
    HWND tmp;

    static const struct message messages[] =
    {
        {WM_WINDOWPOSCHANGING,  FOCUS_WINDOW},
        {WM_ACTIVATE,           FOCUS_WINDOW},
        {WM_SETFOCUS,           FOCUS_WINDOW},
        {WM_WINDOWPOSCHANGING,  DEVICE_WINDOW},
        {WM_MOVE,               DEVICE_WINDOW},
        {WM_SIZE,               DEVICE_WINDOW},
        {0,                     0},
    };

    if (!(d3d8 = pDirect3DCreate8(D3D_SDK_VERSION)))
    {
        skip("Failed to create IDirect3D8 object, skipping tests.\n");
        return;
    }

    wc.lpfnWndProc = test_proc;
    wc.lpszClassName = "d3d8_test_wndproc_wc";
    ok(RegisterClassA(&wc), "Failed to register window class.\n");

    thread_params.window_created = CreateEvent(NULL, FALSE, FALSE, NULL);
    ok(!!thread_params.window_created, "CreateEvent failed, last error %#x.\n", GetLastError());
    thread_params.test_finished = CreateEvent(NULL, FALSE, FALSE, NULL);
    ok(!!thread_params.test_finished, "CreateEvent failed, last error %#x.\n", GetLastError());

    focus_window = CreateWindowA("d3d8_test_wndproc_wc", "d3d8_test",
            WS_MAXIMIZE | WS_VISIBLE | WS_CAPTION , 0, 0, screen_width, screen_height, 0, 0, 0, 0);
    device_window = CreateWindowA("d3d8_test_wndproc_wc", "d3d8_test",
            WS_MAXIMIZE | WS_VISIBLE | WS_CAPTION , 0, 0, screen_width, screen_height, 0, 0, 0, 0);
    thread = CreateThread(NULL, 0, wndproc_thread, &thread_params, 0, &tid);
    ok(!!thread, "Failed to create thread, last error %#x.\n", GetLastError());

    res = WaitForSingleObject(thread_params.window_created, INFINITE);
    ok(res == WAIT_OBJECT_0, "Wait failed (%#x), last error %#x.\n", res, GetLastError());

    proc = GetWindowLongPtrA(device_window, GWLP_WNDPROC);
    ok(proc == (LONG_PTR)test_proc, "Expected wndproc %#lx, got %#lx.\n",
            (LONG_PTR)test_proc, proc);
    proc = GetWindowLongPtrA(focus_window, GWLP_WNDPROC);
    ok(proc == (LONG_PTR)test_proc, "Expected wndproc %#lx, got %#lx.\n",
            (LONG_PTR)test_proc, proc);

    trace("device_window %p, focus_window %p, dummy_window %p.\n",
            device_window, focus_window, thread_params.dummy_window);

    tmp = GetFocus();
    ok(tmp == device_window, "Expected focus %p, got %p.\n", device_window, tmp);
    if (thread_params.running_in_foreground)
    {
        tmp = GetForegroundWindow();
        ok(tmp == thread_params.dummy_window, "Expected foreground window %p, got %p.\n",
                thread_params.dummy_window, tmp);
    }
    else
        skip("Not running in foreground, skip foreground window test\n");

    flush_events();

    expect_messages = messages;

    device = create_device(d3d8, device_window, focus_window, FALSE);
    if (!device)
    {
        skip("Failed to create a D3D device, skipping tests.\n");
        goto done;
    }

    ok(!expect_messages->message, "Expected message %#x for window %#x, but didn't receive it.\n",
            expect_messages->message, expect_messages->window);
    expect_messages = NULL;

    if (0) /* Disabled until we can make this work in a reliable way on Wine. */
    {
        tmp = GetFocus();
        ok(tmp == focus_window, "Expected focus %p, got %p.\n", focus_window, tmp);
        tmp = GetForegroundWindow();
        ok(tmp == focus_window, "Expected foreground window %p, got %p.\n", focus_window, tmp);
    }
    SetForegroundWindow(focus_window);
    flush_events();

    filter_messages = focus_window;

    proc = GetWindowLongPtrA(device_window, GWLP_WNDPROC);
    ok(proc == (LONG_PTR)test_proc, "Expected wndproc %#lx, got %#lx.\n",
            (LONG_PTR)test_proc, proc);

    proc = GetWindowLongPtrA(focus_window, GWLP_WNDPROC);
    ok(proc != (LONG_PTR)test_proc, "Expected wndproc != %#lx, got %#lx.\n",
            (LONG_PTR)test_proc, proc);

    ref = IDirect3DDevice8_Release(device);
    ok(ref == 0, "The device was not properly freed: refcount %u.\n", ref);

    proc = GetWindowLongPtrA(focus_window, GWLP_WNDPROC);
    ok(proc == (LONG_PTR)test_proc, "Expected wndproc %#lx, got %#lx.\n",
            (LONG_PTR)test_proc, proc);

    device = create_device(d3d8, focus_window, focus_window, FALSE);
    if (!device)
    {
        skip("Failed to create a D3D device, skipping tests.\n");
        goto done;
    }

    ref = IDirect3DDevice8_Release(device);
    ok(ref == 0, "The device was not properly freed: refcount %u.\n", ref);

    device = create_device(d3d8, device_window, focus_window, FALSE);
    if (!device)
    {
        skip("Failed to create a D3D device, skipping tests.\n");
        goto done;
    }

    proc = SetWindowLongPtrA(focus_window, GWLP_WNDPROC, (LONG_PTR)DefWindowProcA);
    ok(proc != (LONG_PTR)test_proc, "Expected wndproc != %#lx, got %#lx.\n",
            (LONG_PTR)test_proc, proc);

    ref = IDirect3DDevice8_Release(device);
    ok(ref == 0, "The device was not properly freed: refcount %u.\n", ref);

    proc = GetWindowLongPtrA(focus_window, GWLP_WNDPROC);
    ok(proc == (LONG_PTR)DefWindowProcA, "Expected wndproc %#lx, got %#lx.\n",
            (LONG_PTR)DefWindowProcA, proc);

done:
    filter_messages = NULL;
    IDirect3D8_Release(d3d8);

    SetEvent(thread_params.test_finished);
    WaitForSingleObject(thread, INFINITE);
    CloseHandle(thread_params.test_finished);
    CloseHandle(thread_params.window_created);
    CloseHandle(thread);

    DestroyWindow(device_window);
    DestroyWindow(focus_window);
    UnregisterClassA("d3d8_test_wndproc_wc", GetModuleHandleA(NULL));
}

static void test_wndproc_windowed(void)
{
    struct wndproc_thread_param thread_params;
    IDirect3DDevice8 *device;
    WNDCLASSA wc = {0};
    IDirect3D8 *d3d8;
    HANDLE thread;
    LONG_PTR proc;
    HRESULT hr;
    ULONG ref;
    DWORD res, tid;
    HWND tmp;

    if (!(d3d8 = pDirect3DCreate8(D3D_SDK_VERSION)))
    {
        skip("Failed to create IDirect3D8 object, skipping tests.\n");
        return;
    }

    wc.lpfnWndProc = test_proc;
    wc.lpszClassName = "d3d8_test_wndproc_wc";
    ok(RegisterClassA(&wc), "Failed to register window class.\n");

    thread_params.window_created = CreateEvent(NULL, FALSE, FALSE, NULL);
    ok(!!thread_params.window_created, "CreateEvent failed, last error %#x.\n", GetLastError());
    thread_params.test_finished = CreateEvent(NULL, FALSE, FALSE, NULL);
    ok(!!thread_params.test_finished, "CreateEvent failed, last error %#x.\n", GetLastError());

    focus_window = CreateWindowA("d3d8_test_wndproc_wc", "d3d8_test",
            WS_MAXIMIZE | WS_VISIBLE | WS_CAPTION, 0, 0, screen_width, screen_height, 0, 0, 0, 0);
    device_window = CreateWindowA("d3d8_test_wndproc_wc", "d3d8_test",
            WS_MAXIMIZE | WS_VISIBLE | WS_CAPTION, 0, 0, screen_width, screen_height, 0, 0, 0, 0);
    thread = CreateThread(NULL, 0, wndproc_thread, &thread_params, 0, &tid);
    ok(!!thread, "Failed to create thread, last error %#x.\n", GetLastError());

    res = WaitForSingleObject(thread_params.window_created, INFINITE);
    ok(res == WAIT_OBJECT_0, "Wait failed (%#x), last error %#x.\n", res, GetLastError());

    proc = GetWindowLongPtrA(device_window, GWLP_WNDPROC);
    ok(proc == (LONG_PTR)test_proc, "Expected wndproc %#lx, got %#lx.\n",
            (LONG_PTR)test_proc, proc);
    proc = GetWindowLongPtrA(focus_window, GWLP_WNDPROC);
    ok(proc == (LONG_PTR)test_proc, "Expected wndproc %#lx, got %#lx.\n",
            (LONG_PTR)test_proc, proc);

    trace("device_window %p, focus_window %p, dummy_window %p.\n",
            device_window, focus_window, thread_params.dummy_window);

    tmp = GetFocus();
    ok(tmp == device_window, "Expected focus %p, got %p.\n", device_window, tmp);
    if (thread_params.running_in_foreground)
    {
        tmp = GetForegroundWindow();
        ok(tmp == thread_params.dummy_window, "Expected foreground window %p, got %p.\n",
                thread_params.dummy_window, tmp);
    }
    else
        skip("Not running in foreground, skip foreground window test\n");

    filter_messages = focus_window;

    device = create_device(d3d8, device_window, focus_window, TRUE);
    if (!device)
    {
        skip("Failed to create a D3D device, skipping tests.\n");
        goto done;
    }

    tmp = GetFocus();
    ok(tmp == device_window, "Expected focus %p, got %p.\n", device_window, tmp);
    tmp = GetForegroundWindow();
    ok(tmp == thread_params.dummy_window, "Expected foreground window %p, got %p.\n",
            thread_params.dummy_window, tmp);

    proc = GetWindowLongPtrA(device_window, GWLP_WNDPROC);
    ok(proc == (LONG_PTR)test_proc, "Expected wndproc %#lx, got %#lx.\n",
            (LONG_PTR)test_proc, proc);

    proc = GetWindowLongPtrA(focus_window, GWLP_WNDPROC);
    ok(proc == (LONG_PTR)test_proc, "Expected wndproc %#lx, got %#lx.\n",
            (LONG_PTR)test_proc, proc);

    filter_messages = NULL;

    hr = reset_device(device, device_window, FALSE);
    ok(SUCCEEDED(hr), "Failed to reset device, hr %#x.\n", hr);

    proc = GetWindowLongPtrA(device_window, GWLP_WNDPROC);
    ok(proc == (LONG_PTR)test_proc, "Expected wndproc %#lx, got %#lx.\n",
            (LONG_PTR)test_proc, proc);

    proc = GetWindowLongPtrA(focus_window, GWLP_WNDPROC);
    ok(proc != (LONG_PTR)test_proc, "Expected wndproc %#lx, got %#lx.\n",
            (LONG_PTR)test_proc, proc);

    hr = reset_device(device, device_window, TRUE);
    ok(SUCCEEDED(hr), "Failed to reset device, hr %#x.\n", hr);

    proc = GetWindowLongPtrA(device_window, GWLP_WNDPROC);
    ok(proc == (LONG_PTR)test_proc, "Expected wndproc %#lx, got %#lx.\n",
            (LONG_PTR)test_proc, proc);

    proc = GetWindowLongPtrA(focus_window, GWLP_WNDPROC);
    ok(proc == (LONG_PTR)test_proc, "Expected wndproc %#lx, got %#lx.\n",
            (LONG_PTR)test_proc, proc);

    filter_messages = focus_window;

    ref = IDirect3DDevice8_Release(device);
    ok(ref == 0, "The device was not properly freed: refcount %u.\n", ref);

    filter_messages = device_window;

    device = create_device(d3d8, focus_window, focus_window, TRUE);
    if (!device)
    {
        skip("Failed to create a D3D device, skipping tests.\n");
        goto done;
    }

    filter_messages = NULL;

    hr = reset_device(device, focus_window, FALSE);
    ok(SUCCEEDED(hr), "Failed to reset device, hr %#x.\n", hr);

    proc = GetWindowLongPtrA(device_window, GWLP_WNDPROC);
    ok(proc == (LONG_PTR)test_proc, "Expected wndproc %#lx, got %#lx.\n",
            (LONG_PTR)test_proc, proc);

    proc = GetWindowLongPtrA(focus_window, GWLP_WNDPROC);
    ok(proc != (LONG_PTR)test_proc, "Expected wndproc %#lx, got %#lx.\n",
            (LONG_PTR)test_proc, proc);

    hr = reset_device(device, focus_window, TRUE);
    ok(SUCCEEDED(hr), "Failed to reset device, hr %#x.\n", hr);

    proc = GetWindowLongPtrA(device_window, GWLP_WNDPROC);
    ok(proc == (LONG_PTR)test_proc, "Expected wndproc %#lx, got %#lx.\n",
            (LONG_PTR)test_proc, proc);

    proc = GetWindowLongPtrA(focus_window, GWLP_WNDPROC);
    ok(proc == (LONG_PTR)test_proc, "Expected wndproc %#lx, got %#lx.\n",
            (LONG_PTR)test_proc, proc);

    filter_messages = device_window;

    ref = IDirect3DDevice8_Release(device);
    ok(ref == 0, "The device was not properly freed: refcount %u.\n", ref);

    device = create_device(d3d8, device_window, focus_window, TRUE);
    if (!device)
    {
        skip("Failed to create a D3D device, skipping tests.\n");
        goto done;
    }

    filter_messages = NULL;

    hr = reset_device(device, device_window, FALSE);
    ok(SUCCEEDED(hr), "Failed to reset device, hr %#x.\n", hr);

    proc = GetWindowLongPtrA(device_window, GWLP_WNDPROC);
    ok(proc == (LONG_PTR)test_proc, "Expected wndproc %#lx, got %#lx.\n",
            (LONG_PTR)test_proc, proc);

    proc = GetWindowLongPtrA(focus_window, GWLP_WNDPROC);
    ok(proc != (LONG_PTR)test_proc, "Expected wndproc %#lx, got %#lx.\n",
            (LONG_PTR)test_proc, proc);

    hr = reset_device(device, device_window, TRUE);
    ok(SUCCEEDED(hr), "Failed to reset device, hr %#x.\n", hr);

    proc = GetWindowLongPtrA(device_window, GWLP_WNDPROC);
    ok(proc == (LONG_PTR)test_proc, "Expected wndproc %#lx, got %#lx.\n",
            (LONG_PTR)test_proc, proc);

    proc = GetWindowLongPtrA(focus_window, GWLP_WNDPROC);
    ok(proc == (LONG_PTR)test_proc, "Expected wndproc %#lx, got %#lx.\n",
            (LONG_PTR)test_proc, proc);

    filter_messages = device_window;

    ref = IDirect3DDevice8_Release(device);
    ok(ref == 0, "The device was not properly freed: refcount %u.\n", ref);

done:
    filter_messages = NULL;
    IDirect3D8_Release(d3d8);

    SetEvent(thread_params.test_finished);
    WaitForSingleObject(thread, INFINITE);
    CloseHandle(thread_params.test_finished);
    CloseHandle(thread_params.window_created);
    CloseHandle(thread);

    DestroyWindow(device_window);
    DestroyWindow(focus_window);
    UnregisterClassA("d3d8_test_wndproc_wc", GetModuleHandleA(NULL));
}

static inline void set_fpu_cw(WORD cw)
{
#if defined(__GNUC__) && (defined(__i386__) || defined(__x86_64__))
#define D3D8_TEST_SET_FPU_CW 1
    __asm__ volatile ("fnclex");
    __asm__ volatile ("fldcw %0" : : "m" (cw));
#elif defined(__i386__) && defined(_MSC_VER)
#define D3D8_TEST_SET_FPU_CW 1
    __asm fnclex;
    __asm fldcw cw;
#endif
}

static inline WORD get_fpu_cw(void)
{
    WORD cw = 0;
#if defined(__GNUC__) && (defined(__i386__) || defined(__x86_64__))
#define D3D8_TEST_GET_FPU_CW 1
    __asm__ volatile ("fnstcw %0" : "=m" (cw));
#elif defined(__i386__) && defined(_MSC_VER)
#define D3D8_TEST_GET_FPU_CW 1
    __asm fnstcw cw;
#endif
    return cw;
}

static void test_fpu_setup(void)
{
#if defined(D3D8_TEST_SET_FPU_CW) && defined(D3D8_TEST_GET_FPU_CW)
    D3DPRESENT_PARAMETERS present_parameters;
    IDirect3DDevice8 *device;
    D3DDISPLAYMODE d3ddm;
    HWND window = NULL;
    IDirect3D8 *d3d8;
    HRESULT hr;
    WORD cw;

    d3d8 = pDirect3DCreate8(D3D_SDK_VERSION);
    ok(!!d3d8, "Failed to create a d3d8 object.\n");
    if (!d3d8) return;

    window = CreateWindowA("d3d8_test_wc", "d3d8_test", WS_CAPTION, 0, 0, screen_width, screen_height, 0, 0, 0, 0);
    ok(!!window, "Failed to create a window.\n");
    if (!window) goto done;

    hr = IDirect3D8_GetAdapterDisplayMode(d3d8, D3DADAPTER_DEFAULT, &d3ddm);
    ok(SUCCEEDED(hr), "GetAdapterDisplayMode failed, hr %#x.\n", hr);

    memset(&present_parameters, 0, sizeof(present_parameters));
    present_parameters.Windowed = TRUE;
    present_parameters.hDeviceWindow = window;
    present_parameters.SwapEffect = D3DSWAPEFFECT_DISCARD;
    present_parameters.BackBufferFormat = d3ddm.Format;

    set_fpu_cw(0xf60);
    cw = get_fpu_cw();
    ok(cw == 0xf60, "cw is %#x, expected 0xf60.\n", cw);

    hr = IDirect3D8_CreateDevice(d3d8, D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL, window,
            D3DCREATE_HARDWARE_VERTEXPROCESSING, &present_parameters, &device);
    if (FAILED(hr))
    {
        skip("Failed to create a device, hr %#x.\n", hr);
        set_fpu_cw(0x37f);
        goto done;
    }

    cw = get_fpu_cw();
    ok(cw == 0x7f, "cw is %#x, expected 0x7f.\n", cw);

    IDirect3DDevice8_Release(device);

    cw = get_fpu_cw();
    ok(cw == 0x7f, "cw is %#x, expected 0x7f.\n", cw);
    set_fpu_cw(0xf60);
    cw = get_fpu_cw();
    ok(cw == 0xf60, "cw is %#x, expected 0xf60.\n", cw);

    hr = IDirect3D8_CreateDevice(d3d8, D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL, window,
            D3DCREATE_HARDWARE_VERTEXPROCESSING | D3DCREATE_FPU_PRESERVE, &present_parameters, &device);
    ok(SUCCEEDED(hr), "CreateDevice failed, hr %#x.\n", hr);

    cw = get_fpu_cw();
    ok(cw == 0xf60, "cw is %#x, expected 0xf60.\n", cw);
    set_fpu_cw(0x37f);

    IDirect3DDevice8_Release(device);

done:
    if (window) DestroyWindow(window);
    if (d3d8) IDirect3D8_Release(d3d8);
#endif
}

static void test_ApplyStateBlock(void)
{
    D3DPRESENT_PARAMETERS d3dpp;
    IDirect3DDevice8 *device = NULL;
    IDirect3D8 *d3d8;
    HWND hwnd;
    HRESULT hr;
    D3DDISPLAYMODE d3ddm;
    DWORD received, token;

    d3d8 = pDirect3DCreate8( D3D_SDK_VERSION );
    ok(d3d8 != NULL, "Failed to create IDirect3D8 object\n");
    hwnd = CreateWindow( "d3d8_test_wc", "d3d8_test", WS_OVERLAPPEDWINDOW, 100, 100, 160, 160, NULL, NULL, NULL, NULL );
    ok(hwnd != NULL, "Failed to create window\n");
    if (!d3d8 || !hwnd) goto cleanup;

    IDirect3D8_GetAdapterDisplayMode( d3d8, D3DADAPTER_DEFAULT, &d3ddm );
    ZeroMemory( &d3dpp, sizeof(d3dpp) );
    d3dpp.Windowed         = TRUE;
    d3dpp.SwapEffect       = D3DSWAPEFFECT_DISCARD;
    d3dpp.BackBufferWidth  = 800;
    d3dpp.BackBufferHeight  = 600;
    d3dpp.BackBufferFormat = d3ddm.Format;
    d3dpp.EnableAutoDepthStencil = TRUE;
    d3dpp.AutoDepthStencilFormat = D3DFMT_D16;

    hr = IDirect3D8_CreateDevice( d3d8, D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL, hwnd,
                                  D3DCREATE_HARDWARE_VERTEXPROCESSING, &d3dpp, &device );
    ok(hr == D3D_OK || hr == D3DERR_NOTAVAILABLE || hr == D3DERR_INVALIDCALL,
       "IDirect3D8_CreateDevice failed with %#x\n", hr);
    if(!device)
    {
        skip("Failed to create a d3d device\n");
        goto cleanup;
    }

    IDirect3DDevice8_BeginStateBlock(device);
    IDirect3DDevice8_SetRenderState(device, D3DRS_ZENABLE, TRUE);
    IDirect3DDevice8_EndStateBlock(device, &token);
    ok(token, "Received zero stateblock handle.\n");
    IDirect3DDevice8_SetRenderState(device, D3DRS_ZENABLE, FALSE);

    hr = IDirect3DDevice8_GetRenderState(device, D3DRS_ZENABLE, &received);
    ok(hr == D3D_OK, "Expected D3D_OK, received %#x.\n", hr);
    ok(!received, "Expected = FALSE, received TRUE.\n");

    hr = IDirect3DDevice8_ApplyStateBlock(device, 0);
    ok(hr == D3D_OK, "Expected D3D_OK, received %#x.\n", hr);
    hr = IDirect3DDevice8_GetRenderState(device, D3DRS_ZENABLE, &received);
    ok(hr == D3D_OK, "Expected D3D_OK, received %#x.\n", hr);
    ok(!received, "Expected FALSE, received TRUE.\n");

    hr = IDirect3DDevice8_ApplyStateBlock(device, token);
    ok(hr == D3D_OK, "Expected D3D_OK, received %#x.\n", hr);
    hr = IDirect3DDevice8_GetRenderState(device, D3DRS_ZENABLE, &received);
    ok(hr == D3D_OK, "Expected D3D_OK, received %#x.\n", hr);
    ok(received, "Expected TRUE, received FALSE.\n");

    IDirect3DDevice8_DeleteStateBlock(device, token);
    IDirect3DDevice8_Release(device);
cleanup:
    if (d3d8) IDirect3D8_Release(d3d8);
    DestroyWindow(hwnd);
}

static void test_depth_stencil_size(void)
{
    IDirect3DDevice8 *device;
    IDirect3DSurface8 *ds, *rt, *ds_bigger, *ds_bigger2;
    IDirect3DSurface8 *surf;
    IDirect3D8 *d3d8;
    HRESULT hr;
    HWND hwnd;

    d3d8 = pDirect3DCreate8( D3D_SDK_VERSION );
    ok(d3d8 != NULL, "Failed to create IDirect3D8 object\n");
    hwnd = CreateWindow( "d3d8_test_wc", "d3d8_test", WS_OVERLAPPEDWINDOW, 100, 100, 160, 160, NULL, NULL, NULL, NULL );
    ok(hwnd != NULL, "Failed to create window\n");
    if (!d3d8 || !hwnd) goto cleanup;

    device = create_device(d3d8, hwnd, hwnd, TRUE);
    if (!device) goto cleanup;

    hr = IDirect3DDevice8_CreateRenderTarget(device, 64, 64, D3DFMT_A8R8G8B8, D3DMULTISAMPLE_NONE, FALSE, &rt);
    ok(SUCCEEDED(hr), "IDirect3DDevice8_CreateRenderTarget failed, hr %#x.\n", hr);
    hr = IDirect3DDevice8_CreateDepthStencilSurface(device, 32, 32, D3DFMT_D24X8, D3DMULTISAMPLE_NONE, &ds);
    ok(SUCCEEDED(hr), "IDirect3DDevice8_CreateDepthStencilSurface failed, hr %#x.\n", hr);
    hr = IDirect3DDevice8_CreateDepthStencilSurface(device, 128, 128, D3DFMT_D24X8, D3DMULTISAMPLE_NONE, &ds_bigger);
    ok(SUCCEEDED(hr), "IDirect3DDevice8_CreateDepthStencilSurface failed, hr %#x.\n", hr);
    hr = IDirect3DDevice8_CreateDepthStencilSurface(device, 128, 128, D3DFMT_D24X8, D3DMULTISAMPLE_NONE, &ds_bigger2);
    ok(SUCCEEDED(hr), "IDirect3DDevice8_CreateDepthStencilSurface failed, hr %#x.\n", hr);

    hr = IDirect3DDevice8_SetRenderTarget(device, rt, ds);
    ok(hr == D3DERR_INVALIDCALL, "IDirect3DDevice8_SetRenderTarget returned %#x, expected D3DERR_INVALIDCALL.\n", hr);
    hr = IDirect3DDevice8_SetRenderTarget(device, rt, ds_bigger);
    ok(SUCCEEDED(hr), "IDirect3DDevice8_SetRenderTarget failed, hr %#x.\n", hr);

    /* try to set the small ds without changing the render target at the same time */
    hr = IDirect3DDevice8_SetRenderTarget(device, NULL, ds);
    ok(hr == D3DERR_INVALIDCALL, "IDirect3DDevice8_SetRenderTarget returned %#x, expected D3DERR_INVALIDCALL.\n", hr);
    hr = IDirect3DDevice8_SetRenderTarget(device, NULL, ds_bigger2);
    ok(SUCCEEDED(hr), "IDirect3DDevice8_SetRenderTarget failed, hr %#x.\n", hr);

    hr = IDirect3DDevice8_GetRenderTarget(device, &surf);
    ok(hr == D3D_OK, "IDirect3DDevice8_GetRenderTarget failed, hr %#x.\n", hr);
    ok(surf == rt, "The render target is %p, expected %p\n", surf, rt);
    IDirect3DSurface8_Release(surf);
    hr = IDirect3DDevice8_GetDepthStencilSurface(device, &surf);
    ok(hr == D3D_OK, "IDirect3DDevice8_GetDepthStencilSurface failed, hr %#x.\n", hr);
    ok(surf == ds_bigger2, "The depth stencil is %p, expected %p\n", surf, ds_bigger2);
    IDirect3DSurface8_Release(surf);

    hr = IDirect3DDevice8_SetRenderTarget(device, NULL, NULL);
    ok(SUCCEEDED(hr), "IDirect3DDevice8_SetRenderTarget failed, hr %#x.\n", hr);
    hr = IDirect3DDevice8_GetDepthStencilSurface(device, &surf);
    ok(FAILED(hr), "IDirect3DDevice8_GetDepthStencilSurface should have failed, hr %#x.\n", hr);
    ok(surf == NULL, "The depth stencil is %p, expected NULL\n", surf);
    if (surf) IDirect3DSurface8_Release(surf);

    IDirect3DSurface8_Release(rt);
    IDirect3DSurface8_Release(ds);
    IDirect3DSurface8_Release(ds_bigger);
    IDirect3DSurface8_Release(ds_bigger2);

cleanup:
    if (d3d8) IDirect3D8_Release(d3d8);
    DestroyWindow(hwnd);
}

static void test_window_style(void)
{
    RECT focus_rect, fullscreen_rect, r;
    LONG device_style, device_exstyle;
    LONG focus_style, focus_exstyle;
    LONG style, expected_style;
    IDirect3DDevice8 *device;
    IDirect3D8 *d3d8;
    HRESULT hr;
    ULONG ref;


    if (!(d3d8 = pDirect3DCreate8(D3D_SDK_VERSION)))
    {
        skip("Failed to create IDirect3D8 object, skipping tests.\n");
        return;
    }

    focus_window = CreateWindowA("d3d8_test_wc", "d3d8_test", WS_OVERLAPPEDWINDOW,
            0, 0, screen_width / 2, screen_height / 2, 0, 0, 0, 0);
    device_window = CreateWindowA("d3d8_test_wc", "d3d8_test", WS_OVERLAPPEDWINDOW,
            0, 0, screen_width / 2, screen_height / 2, 0, 0, 0, 0);

    device_style = GetWindowLongA(device_window, GWL_STYLE);
    device_exstyle = GetWindowLongA(device_window, GWL_EXSTYLE);
    focus_style = GetWindowLongA(focus_window, GWL_STYLE);
    focus_exstyle = GetWindowLongA(focus_window, GWL_EXSTYLE);

    SetRect(&fullscreen_rect, 0, 0, screen_width, screen_height);
    GetWindowRect(focus_window, &focus_rect);

    device = create_device(d3d8, device_window, focus_window, FALSE);
    if (!device)
    {
        skip("Failed to create a D3D device, skipping tests.\n");
        goto done;
    }

    style = GetWindowLongA(device_window, GWL_STYLE);
    expected_style = device_style | WS_VISIBLE;
    todo_wine ok(style == expected_style, "Expected device window style %#x, got %#x.\n",
            expected_style, style);
    style = GetWindowLongA(device_window, GWL_EXSTYLE);
    expected_style = device_exstyle | WS_EX_TOPMOST;
    todo_wine ok(style == expected_style, "Expected device window extended style %#x, got %#x.\n",
            expected_style, style);

    style = GetWindowLongA(focus_window, GWL_STYLE);
    ok(style == focus_style, "Expected focus window style %#x, got %#x.\n",
            focus_style, style);
    style = GetWindowLongA(focus_window, GWL_EXSTYLE);
    ok(style == focus_exstyle, "Expected focus window extended style %#x, got %#x.\n",
            focus_exstyle, style);

    GetWindowRect(device_window, &r);
    ok(EqualRect(&r, &fullscreen_rect), "Expected {%d, %d, %d, %d}, got {%d, %d, %d, %d}.\n",
            fullscreen_rect.left, fullscreen_rect.top, fullscreen_rect.right, fullscreen_rect.bottom,
            r.left, r.top, r.right, r.bottom);
    GetClientRect(device_window, &r);
    todo_wine ok(!EqualRect(&r, &fullscreen_rect), "Client rect and window rect are equal.\n");
    GetWindowRect(focus_window, &r);
    ok(EqualRect(&r, &focus_rect), "Expected {%d, %d, %d, %d}, got {%d, %d, %d, %d}.\n",
            focus_rect.left, focus_rect.top, focus_rect.right, focus_rect.bottom,
            r.left, r.top, r.right, r.bottom);

    hr = reset_device(device, device_window, TRUE);
    ok(SUCCEEDED(hr), "Failed to reset device, hr %#x.\n", hr);

    style = GetWindowLongA(device_window, GWL_STYLE);
    expected_style = device_style | WS_VISIBLE;
    ok(style == expected_style, "Expected device window style %#x, got %#x.\n",
            expected_style, style);
    style = GetWindowLongA(device_window, GWL_EXSTYLE);
    expected_style = device_exstyle | WS_EX_TOPMOST;
    ok(style == expected_style, "Expected device window extended style %#x, got %#x.\n",
            expected_style, style);

    style = GetWindowLongA(focus_window, GWL_STYLE);
    ok(style == focus_style, "Expected focus window style %#x, got %#x.\n",
            focus_style, style);
    style = GetWindowLongA(focus_window, GWL_EXSTYLE);
    ok(style == focus_exstyle, "Expected focus window extended style %#x, got %#x.\n",
            focus_exstyle, style);


    ref = IDirect3DDevice8_Release(device);
    ok(ref == 0, "The device was not properly freed: refcount %u.\n", ref);

done:
    IDirect3D8_Release(d3d8);

    DestroyWindow(device_window);
    DestroyWindow(focus_window);
}

static void test_wrong_shader(void)
{
    HRESULT hr;
    HWND hwnd = NULL;
    IDirect3D8 *d3d = NULL;
    IDirect3DDevice8 *device = NULL;
    D3DPRESENT_PARAMETERS d3dpp;
    D3DDISPLAYMODE d3ddm;
    DWORD vs, ps;

    static const DWORD vs_2_0[] =
    {
        0xfffe0200,                                         /* vs_2_0           */
        0x0200001f, 0x80000000, 0x900f0000,                 /* dcl_position v0  */
        0x02000001, 0x800f0001, 0xa0e40001,                 /* mov r1, c1       */
        0x03000002, 0xd00f0000, 0x80e40001, 0xa0e40002,     /* add oD0, r1, c2  */
        0x02000001, 0xc00f0000, 0x90e40000,                 /* mov oPos, v0     */
        0x0000ffff                                          /* end              */
    };
    static const DWORD ps_2_0[] =
    {
        0xffff0200,                                         /* ps_2_0           */
        0x02000001, 0x800f0001, 0xa0e40001,                 /* mov r1, c1       */
        0x03000002, 0x800f0000, 0x80e40001, 0xa0e40002,     /* add r0, r1, c2   */
        0x02000001, 0x800f0800, 0x80e40000,                 /* mov oC0, r0      */
        0x0000ffff                                          /* end              */
    };

    static const DWORD decl[] =
    {
        D3DVSD_STREAM(0),
        D3DVSD_REG(D3DVSDE_POSITION, D3DVSDT_FLOAT3),
        D3DVSD_END()
    };

    d3d = pDirect3DCreate8(D3D_SDK_VERSION);
    ok(d3d != NULL, "Failed to create IDirect3D8 object\n");
    hwnd = CreateWindow("d3d8_test_wc", "d3d8_test", WS_OVERLAPPEDWINDOW, 100, 100, 160, 160, NULL, NULL, NULL, NULL);
    ok(hwnd != NULL, "Failed to create window\n");
    if (!d3d || !hwnd)
        goto cleanup;

    IDirect3D8_GetAdapterDisplayMode(d3d, D3DADAPTER_DEFAULT, &d3ddm);
    ZeroMemory(&d3dpp, sizeof(d3dpp));
    d3dpp.Windowed = TRUE;
    d3dpp.SwapEffect = D3DSWAPEFFECT_DISCARD;
    d3dpp.BackBufferWidth = 800;
    d3dpp.BackBufferHeight = 600;
    d3dpp.BackBufferFormat = d3ddm.Format;

    hr = IDirect3D8_CreateDevice(d3d, D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL, hwnd,
            D3DCREATE_SOFTWARE_VERTEXPROCESSING, &d3dpp, &device);
    ok(hr == D3D_OK || hr == D3DERR_INVALIDCALL || broken(hr == D3DERR_NOTAVAILABLE), "IDirect3D8_CreateDevice failed with %#08x\n", hr);
    if (!device)
    {
        skip("could not create device, IDirect3D8_CreateDevice returned %#08x\n", hr);
        goto cleanup;
    }

    hr = IDirect3DDevice8_CreateVertexShader(device, decl, simple_ps, &vs, 0);
    ok(hr == D3DERR_INVALIDCALL, "IDirect3DDevice8_CreateVertexShader returned %#08x\n", hr);

    hr = IDirect3DDevice8_CreatePixelShader(device, simple_vs, &ps);
    ok(hr == D3DERR_INVALIDCALL, "IDirect3DDevice8_CreatePixelShader returned %#08x\n", hr);

    hr = IDirect3DDevice8_CreateVertexShader(device, decl, vs_2_0, &vs, 0);
    ok(hr == D3DERR_INVALIDCALL, "IDirect3DDevice8_CreateVertexShader returned %#08x\n", hr);

    hr = IDirect3DDevice8_CreatePixelShader(device, ps_2_0, &ps);
    ok(hr == D3DERR_INVALIDCALL, "IDirect3DDevice8_CreatePixelShader returned %#08x\n", hr);

cleanup:
    if (device)
    {
        UINT refcount = IDirect3DDevice8_Release(device);
        ok(!refcount, "Device has %u references left.\n", refcount);
    }
    if (d3d)
        IDirect3D8_Release(d3d);
    DestroyWindow(hwnd);
}

static void test_mode_change(void)
{
    RECT fullscreen_rect, focus_rect, r;
    IDirect3DSurface8 *backbuffer;
    IDirect3DDevice8 *device;
    D3DSURFACE_DESC desc;
    IDirect3D8 *d3d8;
    DEVMODEW devmode;
    UINT refcount;
    HRESULT hr;
    DWORD ret;

    if (!(d3d8 = pDirect3DCreate8(D3D_SDK_VERSION)))
    {
        skip("Failed to create IDirect3D8 object, skipping mode change tests.\n");
        return;
    }

    focus_window = CreateWindowA("d3d8_test_wc", "d3d8_test", WS_OVERLAPPEDWINDOW,
            0, 0, screen_width / 2, screen_height / 2, 0, 0, 0, 0);
    device_window = CreateWindowA("d3d8_test_wc", "d3d8_test", WS_OVERLAPPEDWINDOW,
            0, 0, screen_width / 2, screen_height / 2, 0, 0, 0, 0);

    SetRect(&fullscreen_rect, 0, 0, screen_width, screen_height);
    GetWindowRect(focus_window, &focus_rect);

    device = create_device(d3d8, device_window, focus_window, FALSE);
    if (!device)
    {
        skip("Failed to create a D3D device, skipping tests.\n");
        goto done;
    }

    memset(&devmode, 0, sizeof(devmode));
    devmode.dmSize = sizeof(devmode);
    devmode.dmFields = DM_PELSWIDTH | DM_PELSHEIGHT;
    devmode.dmPelsWidth = 640;
    devmode.dmPelsHeight = 480;

    ret = ChangeDisplaySettingsW(&devmode, CDS_FULLSCREEN);
    ok(ret == DISP_CHANGE_SUCCESSFUL, "Failed to change display mode, ret %#x.\n", ret);

    memset(&devmode, 0, sizeof(devmode));
    devmode.dmSize = sizeof(devmode);
    ret = EnumDisplaySettingsW(NULL, ENUM_CURRENT_SETTINGS, &devmode);
    ok(ret, "Failed to get display mode.\n");
    ok(devmode.dmPelsWidth == 640, "Got unexpect width %u.\n", devmode.dmPelsWidth);
    ok(devmode.dmPelsHeight == 480, "Got unexpect height %u.\n", devmode.dmPelsHeight);

    GetWindowRect(device_window, &r);
    ok(EqualRect(&r, &fullscreen_rect), "Expected {%d, %d, %d, %d}, got {%d, %d, %d, %d}.\n",
            fullscreen_rect.left, fullscreen_rect.top, fullscreen_rect.right, fullscreen_rect.bottom,
            r.left, r.top, r.right, r.bottom);
    GetWindowRect(focus_window, &r);
    ok(EqualRect(&r, &focus_rect), "Expected {%d, %d, %d, %d}, got {%d, %d, %d, %d}.\n",
            focus_rect.left, focus_rect.top, focus_rect.right, focus_rect.bottom,
            r.left, r.top, r.right, r.bottom);

    hr = IDirect3DDevice8_GetBackBuffer(device, 0, D3DBACKBUFFER_TYPE_MONO, &backbuffer);
    ok(SUCCEEDED(hr), "Failed to get backbuffer, hr %#x.\n", hr);
    hr = IDirect3DSurface8_GetDesc(backbuffer, &desc);
    ok(SUCCEEDED(hr), "Failed to get backbuffer desc, hr %#x.\n", hr);
    ok(desc.Width == screen_width, "Got unexpected backbuffer width %u.\n", desc.Width);
    ok(desc.Height == screen_height, "Got unexpected backbuffer height %u.\n", desc.Height);
    IDirect3DSurface8_Release(backbuffer);

    refcount = IDirect3DDevice8_Release(device);
    ok(!refcount, "Device has %u references left.\n", refcount);

    memset(&devmode, 0, sizeof(devmode));
    devmode.dmSize = sizeof(devmode);
    ret = EnumDisplaySettingsW(NULL, ENUM_CURRENT_SETTINGS, &devmode);
    ok(ret, "Failed to get display mode.\n");
    ok(devmode.dmPelsWidth == screen_width, "Got unexpect width %u.\n", devmode.dmPelsWidth);
    ok(devmode.dmPelsHeight == screen_height, "Got unexpect height %u.\n", devmode.dmPelsHeight);

done:
    DestroyWindow(device_window);
    DestroyWindow(focus_window);
    if (d3d8)
        IDirect3D8_Release(d3d8);

    memset(&devmode, 0, sizeof(devmode));
    devmode.dmSize = sizeof(devmode);
    ret = EnumDisplaySettingsW(NULL, ENUM_CURRENT_SETTINGS, &devmode);
    ok(ret, "Failed to get display mode.\n");
    ok(devmode.dmPelsWidth == screen_width, "Got unexpect width %u.\n", devmode.dmPelsWidth);
    ok(devmode.dmPelsHeight == screen_height, "Got unexpect height %u.\n", devmode.dmPelsHeight);
}

static void test_device_window_reset(void)
{
    RECT fullscreen_rect, device_rect, r;
    IDirect3DDevice8 *device;
    WNDCLASSA wc = {0};
    IDirect3D8 *d3d8;
    LONG_PTR proc;
    HRESULT hr;
    ULONG ref;

    if (!(d3d8 = pDirect3DCreate8(D3D_SDK_VERSION)))
    {
        skip("Failed to create IDirect3D8 object, skipping tests.\n");
        return;
    }

    wc.lpfnWndProc = test_proc;
    wc.lpszClassName = "d3d8_test_wndproc_wc";
    ok(RegisterClassA(&wc), "Failed to register window class.\n");

    focus_window = CreateWindowA("d3d8_test_wndproc_wc", "d3d8_test", WS_OVERLAPPEDWINDOW,
            0, 0, screen_width / 2, screen_height / 2, 0, 0, 0, 0);
    device_window = CreateWindowA("d3d8_test_wndproc_wc", "d3d8_test", WS_OVERLAPPEDWINDOW,
            0, 0, screen_width / 2, screen_height / 2, 0, 0, 0, 0);

    SetRect(&fullscreen_rect, 0, 0, screen_width, screen_height);
    GetWindowRect(device_window, &device_rect);

    proc = GetWindowLongPtrA(device_window, GWLP_WNDPROC);
    ok(proc == (LONG_PTR)test_proc, "Expected wndproc %#lx, got %#lx.\n",
            (LONG_PTR)test_proc, proc);
    proc = GetWindowLongPtrA(focus_window, GWLP_WNDPROC);
    ok(proc == (LONG_PTR)test_proc, "Expected wndproc %#lx, got %#lx.\n",
            (LONG_PTR)test_proc, proc);

    device = create_device(d3d8, NULL, focus_window, FALSE);
    if (!device)
    {
        skip("Failed to create a D3D device, skipping tests.\n");
        goto done;
    }

    GetWindowRect(focus_window, &r);
    ok(EqualRect(&r, &fullscreen_rect), "Expected {%d, %d, %d, %d}, got {%d, %d, %d, %d}.\n",
            fullscreen_rect.left, fullscreen_rect.top, fullscreen_rect.right, fullscreen_rect.bottom,
            r.left, r.top, r.right, r.bottom);
    GetWindowRect(device_window, &r);
    ok(EqualRect(&r, &device_rect), "Expected {%d, %d, %d, %d}, got {%d, %d, %d, %d}.\n",
            device_rect.left, device_rect.top, device_rect.right, device_rect.bottom,
            r.left, r.top, r.right, r.bottom);

    proc = GetWindowLongPtrA(device_window, GWLP_WNDPROC);
    ok(proc == (LONG_PTR)test_proc, "Expected wndproc %#lx, got %#lx.\n",
            (LONG_PTR)test_proc, proc);
    proc = GetWindowLongPtrA(focus_window, GWLP_WNDPROC);
    ok(proc != (LONG_PTR)test_proc, "Expected wndproc %#lx, got %#lx.\n",
            (LONG_PTR)test_proc, proc);

    hr = reset_device(device, device_window, FALSE);
    ok(SUCCEEDED(hr), "Failed to reset device.\n");

    GetWindowRect(focus_window, &r);
    ok(EqualRect(&r, &fullscreen_rect), "Expected {%d, %d, %d, %d}, got {%d, %d, %d, %d}.\n",
            fullscreen_rect.left, fullscreen_rect.top, fullscreen_rect.right, fullscreen_rect.bottom,
            r.left, r.top, r.right, r.bottom);
    GetWindowRect(device_window, &r);
    ok(EqualRect(&r, &fullscreen_rect), "Expected {%d, %d, %d, %d}, got {%d, %d, %d, %d}.\n",
            fullscreen_rect.left, fullscreen_rect.top, fullscreen_rect.right, fullscreen_rect.bottom,
            r.left, r.top, r.right, r.bottom);

    proc = GetWindowLongPtrA(device_window, GWLP_WNDPROC);
    ok(proc == (LONG_PTR)test_proc, "Expected wndproc %#lx, got %#lx.\n",
            (LONG_PTR)test_proc, proc);
    proc = GetWindowLongPtrA(focus_window, GWLP_WNDPROC);
    ok(proc != (LONG_PTR)test_proc, "Expected wndproc %#lx, got %#lx.\n",
            (LONG_PTR)test_proc, proc);

    ref = IDirect3DDevice8_Release(device);
    ok(ref == 0, "The device was not properly freed: refcount %u.\n", ref);

done:
    IDirect3D8_Release(d3d8);
    DestroyWindow(device_window);
    DestroyWindow(focus_window);
    UnregisterClassA("d3d8_test_wndproc_wc", GetModuleHandleA(NULL));
}

static void depth_blit_test(void)
{
    HWND hwnd = NULL;
    IDirect3D8 *d3d8 = NULL;
    IDirect3DDevice8 *device = NULL;
    IDirect3DSurface8 *backbuffer, *ds1, *ds2, *ds3;
    RECT src_rect;
    const POINT dst_point = {0, 0};
    HRESULT hr;

    d3d8 = pDirect3DCreate8(D3D_SDK_VERSION);
    ok(d3d8 != NULL, "Direct3DCreate8 failed.\n");
    hwnd = CreateWindow("d3d8_test_wc", "d3d8_test", WS_OVERLAPPEDWINDOW, 100, 100, 160, 160, NULL, NULL, NULL, NULL);
    ok(hwnd != NULL, "CreateWindow failed.\n");
    if (!d3d8 || !hwnd)
        goto done;

    device = create_device(d3d8, hwnd, hwnd, TRUE);
    if (!device)
    {
        skip("Failed to create a D3D device, skipping tests.\n");
        goto done;
    }

    hr = IDirect3DDevice8_GetRenderTarget(device, &backbuffer);
    ok(SUCCEEDED(hr), "GetRenderTarget failed, hr %#x.\n", hr);
    hr = IDirect3DDevice8_GetDepthStencilSurface(device, &ds1);
    ok(SUCCEEDED(hr), "GetDepthStencilSurface failed, hr %#x.\n", hr);
    hr = IDirect3DDevice8_CreateDepthStencilSurface(device, 640, 480, D3DFMT_D24S8, D3DMULTISAMPLE_NONE, &ds2);
    ok(SUCCEEDED(hr), "CreateDepthStencilSurface failed, hr %#x.\n", hr);
    hr = IDirect3DDevice8_CreateDepthStencilSurface(device, 640, 480, D3DFMT_D24S8, D3DMULTISAMPLE_NONE, &ds3);
    ok(SUCCEEDED(hr), "CreateDepthStencilSurface failed, hr %#x.\n", hr);

    hr = IDirect3DDevice8_Clear(device, 0, NULL, D3DCLEAR_ZBUFFER, 0, 0.0f, 0);
    ok(SUCCEEDED(hr), "Clear failed, hr %#x.\n", hr);

    /* Partial blit. */
    SetRect(&src_rect, 0, 0, 320, 240);
    hr = IDirect3DDevice8_CopyRects(device, ds1, &src_rect, 1, ds2, &dst_point);
    ok(hr == D3DERR_INVALIDCALL, "CopyRects returned %#x, expected %#x.\n", hr, D3DERR_INVALIDCALL);
    /* Flipped. */
    SetRect(&src_rect, 0, 480, 640, 0);
    hr = IDirect3DDevice8_CopyRects(device, ds1, &src_rect, 1, ds2, &dst_point);
    ok(hr == D3DERR_INVALIDCALL, "CopyRects returned %#x, expected %#x.\n", hr, D3DERR_INVALIDCALL);
    /* Full, explicit. */
    SetRect(&src_rect, 0, 0, 640, 480);
    hr = IDirect3DDevice8_CopyRects(device, ds1, &src_rect, 1, ds2, &dst_point);
    ok(hr == D3DERR_INVALIDCALL, "CopyRects returned %#x, expected %#x.\n", hr, D3DERR_INVALIDCALL);
    /* Depth -> color blit.*/
    hr = IDirect3DDevice8_CopyRects(device, ds1, &src_rect, 1, backbuffer, &dst_point);
    ok(hr == D3DERR_INVALIDCALL, "CopyRects returned %#x, expected %#x.\n", hr, D3DERR_INVALIDCALL);
    /* Full, NULL rects, current depth stencil -> unbound depth stencil */
    hr = IDirect3DDevice8_CopyRects(device, ds1, NULL, 0, ds2, NULL);
    ok(hr == D3DERR_INVALIDCALL, "CopyRects returned %#x, expected %#x.\n", hr, D3DERR_INVALIDCALL);
    /* Full, NULL rects, unbound depth stencil -> current depth stencil */
    hr = IDirect3DDevice8_CopyRects(device, ds2, NULL, 0, ds1, NULL);
    ok(hr == D3DERR_INVALIDCALL, "CopyRects returned %#x, expected %#x.\n", hr, D3DERR_INVALIDCALL);
    /* Full, NULL rects, unbound depth stencil -> unbound depth stencil */
    hr = IDirect3DDevice8_CopyRects(device, ds2, NULL, 0, ds3, NULL);
    ok(hr == D3DERR_INVALIDCALL, "CopyRects returned %#x, expected %#x.\n", hr, D3DERR_INVALIDCALL);

    IDirect3DSurface8_Release(backbuffer);
    IDirect3DSurface8_Release(ds3);
    IDirect3DSurface8_Release(ds2);
    IDirect3DSurface8_Release(ds1);

done:
    if (device) IDirect3DDevice8_Release(device);
    if (d3d8) IDirect3D8_Release(d3d8);
    if (hwnd) DestroyWindow(hwnd);
}

static void test_reset_resources(void)
{
    IDirect3DSurface8 *surface, *rt;
    IDirect3DTexture8 *texture;
    IDirect3DDevice8 *device;
    IDirect3D8 *d3d8;
    HWND window;
    HRESULT hr;
    ULONG ref;

    window = CreateWindowA("static", "d3d8_test", WS_OVERLAPPEDWINDOW,
            0, 0, 640, 480, 0, 0, 0, 0);

    if (!(d3d8 = pDirect3DCreate8(D3D_SDK_VERSION)))
    {
        skip("Failed to create IDirect3D8 object, skipping tests.\n");
        DestroyWindow(window);
        return;
    }

    if (!(device = create_device(d3d8, window, window, TRUE)))
    {
        skip("Failed to create a D3D device, skipping tests.\n");
        goto done;
    }

    hr = IDirect3DDevice8_CreateDepthStencilSurface(device, 128, 128, D3DFMT_D24S8,
            D3DMULTISAMPLE_NONE, &surface);
    ok(SUCCEEDED(hr), "Failed to create depth/stencil surface, hr %#x.\n", hr);

    hr = IDirect3DDevice8_CreateTexture(device, 128, 128, 1, D3DUSAGE_RENDERTARGET,
            D3DFMT_A8R8G8B8, D3DPOOL_DEFAULT, &texture);
    ok(SUCCEEDED(hr), "Failed to create render target texture, hr %#x.\n", hr);
    hr = IDirect3DTexture8_GetSurfaceLevel(texture, 0, &rt);
    ok(SUCCEEDED(hr), "Failed to get surface, hr %#x.\n", hr);
    IDirect3DTexture8_Release(texture);

    hr = IDirect3DDevice8_SetRenderTarget(device, rt, surface);
    ok(SUCCEEDED(hr), "Failed to set render target surface, hr %#x.\n", hr);
    IDirect3DSurface8_Release(rt);
    IDirect3DSurface8_Release(surface);

    hr = reset_device(device, device_window, TRUE);
    ok(SUCCEEDED(hr), "Failed to reset device.\n");

    hr = IDirect3DDevice8_GetBackBuffer(device, 0, D3DBACKBUFFER_TYPE_MONO, &rt);
    ok(SUCCEEDED(hr), "Failed to get back buffer, hr %#x.\n", hr);
    hr = IDirect3DDevice8_GetRenderTarget(device, &surface);
    ok(SUCCEEDED(hr), "Failed to get render target surface, hr %#x.\n", hr);
    ok(surface == rt, "Got unexpected surface %p for render target.\n", surface);
    IDirect3DSurface8_Release(surface);
    IDirect3DSurface8_Release(rt);

    ref = IDirect3DDevice8_Release(device);
    ok(ref == 0, "The device was not properly freed: refcount %u.\n", ref);

done:
    IDirect3D8_Release(d3d8);
    DestroyWindow(window);
}

static void test_set_rt_vp_scissor(void)
{
    IDirect3DDevice8 *device;
    IDirect3DSurface8 *rt;
    IDirect3D8 *d3d8;
    DWORD stateblock;
    D3DVIEWPORT8 vp;
    UINT refcount;
    HWND window;
    HRESULT hr;

    if (!(d3d8 = pDirect3DCreate8(D3D_SDK_VERSION)))
    {
        skip("Failed to create IDirect3D8 object, skipping tests.\n");
        return;
    }

    window = CreateWindowA("static", "d3d8_test", WS_OVERLAPPEDWINDOW,
            0, 0, 640, 480, 0, 0, 0, 0);
    if (!(device = create_device(d3d8, window, window, TRUE)))
    {
        skip("Failed to create a D3D device, skipping tests.\n");
        DestroyWindow(window);
        return;
    }

    hr = IDirect3DDevice8_CreateRenderTarget(device, 128, 128, D3DFMT_A8R8G8B8,
            D3DMULTISAMPLE_NONE, FALSE, &rt);
    ok(SUCCEEDED(hr), "Failed to create render target, hr %#x.\n", hr);

    hr = IDirect3DDevice8_GetViewport(device, &vp);
    ok(SUCCEEDED(hr), "Failed to get viewport, hr %#x.\n", hr);
    ok(!vp.X, "Got unexpected vp.X %u.\n", vp.X);
    ok(!vp.Y, "Got unexpected vp.Y %u.\n", vp.Y);
    ok(vp.Width == screen_width, "Got unexpected vp.Width %u.\n", vp.Width);
    ok(vp.Height == screen_height, "Got unexpected vp.Height %u.\n", vp.Height);
    ok(vp.MinZ == 0.0f, "Got unexpected vp.MinZ %.8e.\n", vp.MinZ);
    ok(vp.MaxZ == 1.0f, "Got unexpected vp.MaxZ %.8e.\n", vp.MaxZ);

    hr = IDirect3DDevice8_BeginStateBlock(device);
    ok(SUCCEEDED(hr), "Failed to begin stateblock, hr %#x.\n", hr);

    hr = IDirect3DDevice8_SetRenderTarget(device, rt, NULL);
    ok(SUCCEEDED(hr), "Failed to set render target, hr %#x.\n", hr);

    hr = IDirect3DDevice8_EndStateBlock(device, &stateblock);
    ok(SUCCEEDED(hr), "Failed to end stateblock, hr %#x.\n", hr);
    hr = IDirect3DDevice8_DeleteStateBlock(device, stateblock);
    ok(SUCCEEDED(hr), "Failed to delete stateblock, hr %#x.\n", hr);

    hr = IDirect3DDevice8_GetViewport(device, &vp);
    ok(SUCCEEDED(hr), "Failed to get viewport, hr %#x.\n", hr);
    ok(!vp.X, "Got unexpected vp.X %u.\n", vp.X);
    ok(!vp.Y, "Got unexpected vp.Y %u.\n", vp.Y);
    ok(vp.Width == 128, "Got unexpected vp.Width %u.\n", vp.Width);
    ok(vp.Height == 128, "Got unexpected vp.Height %u.\n", vp.Height);
    ok(vp.MinZ == 0.0f, "Got unexpected vp.MinZ %.8e.\n", vp.MinZ);
    ok(vp.MaxZ == 1.0f, "Got unexpected vp.MaxZ %.8e.\n", vp.MaxZ);

    hr = IDirect3DDevice8_SetRenderTarget(device, rt, NULL);
    ok(SUCCEEDED(hr), "Failed to set render target, hr %#x.\n", hr);

    vp.X = 10;
    vp.Y = 20;
    vp.Width = 30;
    vp.Height = 40;
    vp.MinZ = 0.25f;
    vp.MaxZ = 0.75f;
    hr = IDirect3DDevice8_SetViewport(device, &vp);
    ok(SUCCEEDED(hr), "Failed to set viewport, hr %#x.\n", hr);

    hr = IDirect3DDevice8_SetRenderTarget(device, rt, NULL);
    ok(SUCCEEDED(hr), "Failed to set render target, hr %#x.\n", hr);

    hr = IDirect3DDevice8_GetViewport(device, &vp);
    ok(SUCCEEDED(hr), "Failed to get viewport, hr %#x.\n", hr);
    ok(!vp.X, "Got unexpected vp.X %u.\n", vp.X);
    ok(!vp.Y, "Got unexpected vp.Y %u.\n", vp.Y);
    ok(vp.Width == 128, "Got unexpected vp.Width %u.\n", vp.Width);
    ok(vp.Height == 128, "Got unexpected vp.Height %u.\n", vp.Height);
    ok(vp.MinZ == 0.0f, "Got unexpected vp.MinZ %.8e.\n", vp.MinZ);
    ok(vp.MaxZ == 1.0f, "Got unexpected vp.MaxZ %.8e.\n", vp.MaxZ);

    IDirect3DSurface8_Release(rt);
    refcount = IDirect3DDevice8_Release(device);
    ok(!refcount, "Device has %u references left.\n", refcount);
    IDirect3D8_Release(d3d8);
    DestroyWindow(window);
}

static void test_validate_vs(void)
{
    static DWORD vs[] =
    {
        0xfffe0101,                                                             /* vs_1_1                       */
        0x00000009, 0xc0010000, 0x90e40000, 0xa0e40000,                         /* dp4 oPos.x, v0, c0           */
        0x00000009, 0xc0020000, 0x90e40000, 0xa0e40001,                         /* dp4 oPos.y, v0, c1           */
        0x00000009, 0xc0040000, 0x90e40000, 0xa0e40002,                         /* dp4 oPos.z, v0, c2           */
        0x00000009, 0xc0080000, 0x90e40000, 0xa0e40003,                         /* dp4 oPos.w, v0, c3           */
        0x0000ffff,                                                             /* end                          */
    };
    HRESULT hr;

    hr = ValidateVertexShader(0, 0, 0, 0, 0);
    ok(hr == E_FAIL, "Got unexpected hr %#x.\n", hr);
    hr = ValidateVertexShader(0, 0, 0, 1, 0);
    ok(hr == E_FAIL, "Got unexpected hr %#x.\n", hr);
    hr = ValidateVertexShader(vs, 0, 0, 0, 0);
    ok(hr == S_OK, "Got unexpected hr %#x.\n", hr);

    hr = ValidateVertexShader(vs, 0, 0, 1, 0);
    ok(hr == S_OK, "Got unexpected hr %#x.\n", hr);
    /* Seems to do some version checking. */
    *vs = 0xfffe0100;                                                           /* vs_1_0                       */
    hr = ValidateVertexShader(vs, 0, 0, 0, 0);
    ok(hr == S_OK, "Got unexpected hr %#x.\n", hr);

    *vs = 0xfffe0102;                                                           /* bogus version                */
    hr = ValidateVertexShader(vs, 0, 0, 1, 0);
    ok(hr == E_FAIL, "Got unexpected hr %#x.\n", hr);
    /* I've seen that applications always pass the 2nd and 3rd parameter as 0.
     * Simple test with non-zero parameters. */
    *vs = 0xfffe0101;                                                           /* vs_1_1                       */
    hr = ValidateVertexShader(vs, vs, 0, 1, 0);
    ok(hr == E_FAIL, "Got unexpected hr %#x.\n", hr);

    hr = ValidateVertexShader(vs, 0, vs, 1, 0);
    ok(hr == E_FAIL, "Got unexpected hr %#x.\n", hr);
    /* I've seen the 4th parameter always passed as either 0 or 1, but passing
     * other values doesn't seem to hurt. */
    hr = ValidateVertexShader(vs, 0, 0, 12345, 0);
    ok(hr == S_OK, "Got unexpected hr %#x.\n", hr);
    /* What is the 5th parameter? The following seems to work ok. */
    hr = ValidateVertexShader(vs, 0, 0, 1, vs);
    ok(hr == S_OK, "Got unexpected hr %#x.\n", hr);
}

static void test_validate_ps(void)
{
    static DWORD ps[] =
    {
        0xffff0101,                                                             /* ps_1_1                       */
        0x00000051, 0xa00f0001, 0x3f800000, 0x00000000, 0x00000000, 0x00000000, /* def c1 = 1.0, 0.0, 0.0, 0.0  */
        0x00000042, 0xb00f0000,                                                 /* tex t0                       */
        0x00000008, 0x800f0000, 0xa0e40001, 0xa0e40000,                         /* dp3 r0, c1, c0               */
        0x00000005, 0x800f0000, 0x90e40000, 0x80e40000,                         /* mul r0, v0, r0               */
        0x00000005, 0x800f0000, 0xb0e40000, 0x80e40000,                         /* mul r0, t0, r0               */
        0x0000ffff,                                                             /* end                          */
    };
    HRESULT hr;

    hr = ValidatePixelShader(0, 0, 0, 0);
    ok(hr == E_FAIL, "Got unexpected hr %#x.\n", hr);
    hr = ValidatePixelShader(0, 0, 1, 0);
    ok(hr == E_FAIL, "Got unexpected hr %#x.\n", hr);
    hr = ValidatePixelShader(ps, 0, 0, 0);
    ok(hr == S_OK, "Got unexpected hr %#x.\n", hr);

    hr = ValidatePixelShader(ps, 0, 1, 0);
    ok(hr == S_OK, "Got unexpected hr %#x.\n", hr);
    /* Seems to do some version checking. */
    *ps = 0xffff0105;                                                           /* bogus version                */
    hr = ValidatePixelShader(ps, 0, 1, 0);
    ok(hr == E_FAIL, "Got unexpected hr %#x.\n", hr);
    /* I've seen that applications always pass the 2nd parameter as 0.
     * Simple test with a non-zero parameter. */
    *ps = 0xffff0101;                                                           /* ps_1_1                       */
    hr = ValidatePixelShader(ps, ps, 1, 0);
    ok(hr == E_FAIL, "Got unexpected hr %#x.\n", hr);
    /* I've seen th 3rd parameter always passed as either 0 or 1, but passing
     * other values doesn't seem to hurt. */
    hr = ValidatePixelShader(ps, 0, 12345, 0);
    ok(hr == S_OK, "Got unexpected hr %#x.\n", hr);
    /* What is the 4th parameter? The following seems to work ok. */
    hr = ValidatePixelShader(ps, 0, 1, ps);
    ok(hr == S_OK, "Got unexpected hr %#x.\n", hr);
}

static void test_volume_get_container(void)
{
    IDirect3DVolumeTexture8 *texture = NULL;
    IDirect3DVolume8 *volume = NULL;
    IDirect3DDevice8 *device;
    IUnknown *container;
    IDirect3D8 *d3d8;
    ULONG refcount;
    D3DCAPS8 caps;
    HWND window;
    HRESULT hr;

    if (!(d3d8 = pDirect3DCreate8(D3D_SDK_VERSION)))
    {
        skip("Failed to create d3d8 object, skipping tests.\n");
        return;
    }

    window = CreateWindowA("d3d8_test_wc", "d3d8_test", WS_OVERLAPPEDWINDOW,
            0, 0, 640, 480, 0, 0, 0, 0);
    if (!(device = create_device(d3d8, window, window, TRUE)))
    {
        skip("Failed to create a D3D device, skipping tests.\n");
        IDirect3D8_Release(d3d8);
        DestroyWindow(window);
        return;
    }

    hr = IDirect3DDevice8_GetDeviceCaps(device, &caps);
    ok(SUCCEEDED(hr), "Failed to get device caps, hr %#x.\n", hr);
    if (!(caps.TextureCaps & D3DPTEXTURECAPS_VOLUMEMAP))
    {
        skip("No volume texture support, skipping tests.\n");
        IDirect3DDevice8_Release(device);
        IDirect3D8_Release(d3d8);
        DestroyWindow(window);
        return;
    }

    hr = IDirect3DDevice8_CreateVolumeTexture(device, 128, 128, 128, 1, 0,
            D3DFMT_A8R8G8B8, D3DPOOL_DEFAULT, &texture);
    ok(SUCCEEDED(hr), "Failed to create volume texture, hr %#x.\n", hr);
    ok(!!texture, "Got unexpected texture %p.\n", texture);

    hr = IDirect3DVolumeTexture8_GetVolumeLevel(texture, 0, &volume);
    ok(SUCCEEDED(hr), "Failed to get volume level, hr %#x.\n", hr);
    ok(!!volume, "Got unexpected volume %p.\n", volume);

    /* These should work... */
    container = NULL;
    hr = IDirect3DVolume8_GetContainer(volume, &IID_IUnknown, (void **)&container);
    ok(SUCCEEDED(hr), "Failed to get volume container, hr %#x.\n", hr);
    ok(container == (IUnknown *)texture, "Got unexpected container %p, expected %p.\n", container, texture);
    IUnknown_Release(container);

    container = NULL;
    hr = IDirect3DVolume8_GetContainer(volume, &IID_IDirect3DResource8, (void **)&container);
    ok(SUCCEEDED(hr), "Failed to get volume container, hr %#x.\n", hr);
    ok(container == (IUnknown *)texture, "Got unexpected container %p, expected %p.\n", container, texture);
    IUnknown_Release(container);

    container = NULL;
    hr = IDirect3DVolume8_GetContainer(volume, &IID_IDirect3DBaseTexture8, (void **)&container);
    ok(SUCCEEDED(hr), "Failed to get volume container, hr %#x.\n", hr);
    ok(container == (IUnknown *)texture, "Got unexpected container %p, expected %p.\n", container, texture);
    IUnknown_Release(container);

    container = NULL;
    hr = IDirect3DVolume8_GetContainer(volume, &IID_IDirect3DVolumeTexture8, (void **)&container);
    ok(SUCCEEDED(hr), "Failed to get volume container, hr %#x.\n", hr);
    ok(container == (IUnknown *)texture, "Got unexpected container %p, expected %p.\n", container, texture);
    IUnknown_Release(container);

    /* ...and this one shouldn't. This should return E_NOINTERFACE and set container to NULL. */
    hr = IDirect3DVolume8_GetContainer(volume, &IID_IDirect3DVolume8, (void **)&container);
    ok(hr == E_NOINTERFACE, "Got unexpected hr %#x.\n", hr);
    ok(!container, "Got unexpected container %p.\n", container);

    IDirect3DVolume8_Release(volume);
    IDirect3DVolumeTexture8_Release(texture);
    refcount = IDirect3DDevice8_Release(device);
    ok(!refcount, "Device has %u references left.\n", refcount);
    IDirect3D8_Release(d3d8);
    DestroyWindow(window);
}

static void test_vb_lock_flags(void)
{
    static const struct
    {
        DWORD flags;
        const char *debug_string;
        HRESULT result;
    }
    test_data[] =
    {
        {D3DLOCK_READONLY,                          "D3DLOCK_READONLY",                         D3D_OK            },
        {D3DLOCK_DISCARD,                           "D3DLOCK_DISCARD",                          D3D_OK            },
        {D3DLOCK_NOOVERWRITE,                       "D3DLOCK_NOOVERWRITE",                      D3D_OK            },
        {D3DLOCK_NOOVERWRITE | D3DLOCK_DISCARD,     "D3DLOCK_NOOVERWRITE | D3DLOCK_DISCARD",    D3D_OK            },
        {D3DLOCK_NOOVERWRITE | D3DLOCK_READONLY,    "D3DLOCK_NOOVERWRITE | D3DLOCK_READONLY",   D3D_OK            },
        {D3DLOCK_READONLY    | D3DLOCK_DISCARD,     "D3DLOCK_READONLY | D3DLOCK_DISCARD",       D3D_OK            },
        /* Completely bogus flags aren't an error. */
        {0xdeadbeef,                                "0xdeadbeef",                               D3D_OK            },
    };
    IDirect3DVertexBuffer8 *buffer;
    IDirect3DDevice8 *device;
    IDirect3D8 *d3d8;
    unsigned int i;
    ULONG refcount;
    HWND window;
    HRESULT hr;
    BYTE *data;

    if (!(d3d8 = pDirect3DCreate8(D3D_SDK_VERSION)))
    {
        skip("Failed to create d3d8 object, skipping tests.\n");
        return;
    }

    window = CreateWindowA("d3d8_test_wc", "d3d8_test", WS_OVERLAPPEDWINDOW,
            0, 0, 640, 480, 0, 0, 0, 0);
    if (!(device = create_device(d3d8, window, window, TRUE)))
    {
        skip("Failed to create a D3D device, skipping tests.\n");
        IDirect3D8_Release(d3d8);
        DestroyWindow(window);
        return;
    }

    hr = IDirect3DDevice8_CreateVertexBuffer(device, 1024, D3DUSAGE_DYNAMIC, 0, D3DPOOL_DEFAULT, &buffer);
    ok(SUCCEEDED(hr), "Failed to create vertex buffer, hr %#x.\n", hr);

    for (i = 0; i < (sizeof(test_data) / sizeof(*test_data)); ++i)
    {
        hr = IDirect3DVertexBuffer8_Lock(buffer, 0, 0, &data, test_data[i].flags);
        ok(hr == test_data[i].result, "Got unexpected hr %#x for %s.\n",
                hr, test_data[i].debug_string);
        if (SUCCEEDED(hr))
        {
            ok(!!data, "Got unexpected data %p.\n", data);
            hr = IDirect3DVertexBuffer8_Unlock(buffer);
            ok(SUCCEEDED(hr), "Failed to unlock vertex buffer, hr %#x.\n", hr);
        }
    }

    IDirect3DVertexBuffer8_Release(buffer);
    refcount = IDirect3DDevice8_Release(device);
    ok(!refcount, "Device has %u references left.\n", refcount);
    IDirect3D8_Release(d3d8);
    DestroyWindow(window);
}

/* Test the default texture stage state values */
static void test_texture_stage_states(void)
{
    IDirect3DDevice8 *device;
    IDirect3D8 *d3d8;
    unsigned int i;
    ULONG refcount;
    D3DCAPS8 caps;
    DWORD value;
    HWND window;
    HRESULT hr;

    if (!(d3d8 = pDirect3DCreate8(D3D_SDK_VERSION)))
    {
        skip("Failed to create d3d8 object, skipping tests.\n");
        return;
    }

    window = CreateWindowA("d3d8_test_wc", "d3d8_test", WS_OVERLAPPEDWINDOW,
            0, 0, 640, 480, 0, 0, 0, 0);
    if (!(device = create_device(d3d8, window, window, TRUE)))
    {
        skip("Failed to create a D3D device, skipping tests.\n");
        IDirect3D8_Release(d3d8);
        DestroyWindow(window);
        return;
    }

    hr = IDirect3DDevice8_GetDeviceCaps(device, &caps);
    ok(SUCCEEDED(hr), "Failed to get device caps, hr %#x.\n", hr);

    for (i = 0; i < caps.MaxTextureBlendStages; ++i)
    {
        hr = IDirect3DDevice8_GetTextureStageState(device, i, D3DTSS_COLOROP, &value);
        ok(SUCCEEDED(hr), "Failed to get texture stage state, hr %#x.\n", hr);
        ok(value == (i ? D3DTOP_DISABLE : D3DTOP_MODULATE),
                "Got unexpected value %#x for D3DTSS_COLOROP, stage %u.\n", value, i);
        hr = IDirect3DDevice8_GetTextureStageState(device, i, D3DTSS_COLORARG1, &value);
        ok(SUCCEEDED(hr), "Failed to get texture stage state, hr %#x.\n", hr);
        ok(value == D3DTA_TEXTURE, "Got unexpected value %#x for D3DTSS_COLORARG1, stage %u.\n", value, i);
        hr = IDirect3DDevice8_GetTextureStageState(device, i, D3DTSS_COLORARG2, &value);
        ok(SUCCEEDED(hr), "Failed to get texture stage state, hr %#x.\n", hr);
        ok(value == D3DTA_CURRENT, "Got unexpected value %#x for D3DTSS_COLORARG2, stage %u.\n", value, i);
        hr = IDirect3DDevice8_GetTextureStageState(device, i, D3DTSS_ALPHAOP, &value);
        ok(SUCCEEDED(hr), "Failed to get texture stage state, hr %#x.\n", hr);
        ok(value == (i ? D3DTOP_DISABLE : D3DTOP_SELECTARG1),
                "Got unexpected value %#x for D3DTSS_ALPHAOP, stage %u.\n", value, i);
        hr = IDirect3DDevice8_GetTextureStageState(device, i, D3DTSS_ALPHAARG1, &value);
        ok(SUCCEEDED(hr), "Failed to get texture stage state, hr %#x.\n", hr);
        ok(value == D3DTA_TEXTURE, "Got unexpected value %#x for D3DTSS_ALPHAARG1, stage %u.\n", value, i);
        hr = IDirect3DDevice8_GetTextureStageState(device, i, D3DTSS_ALPHAARG2, &value);
        ok(SUCCEEDED(hr), "Failed to get texture stage state, hr %#x.\n", hr);
        ok(value == D3DTA_CURRENT, "Got unexpected value %#x for D3DTSS_ALPHAARG2, stage %u.\n", value, i);
        hr = IDirect3DDevice8_GetTextureStageState(device, i, D3DTSS_BUMPENVMAT00, &value);
        ok(SUCCEEDED(hr), "Failed to get texture stage state, hr %#x.\n", hr);
        ok(!value, "Got unexpected value %#x for D3DTSS_BUMPENVMAT00, stage %u.\n", value, i);
        hr = IDirect3DDevice8_GetTextureStageState(device, i, D3DTSS_BUMPENVMAT01, &value);
        ok(SUCCEEDED(hr), "Failed to get texture stage state, hr %#x.\n", hr);
        ok(!value, "Got unexpected value %#x for D3DTSS_BUMPENVMAT01, stage %u.\n", value, i);
        hr = IDirect3DDevice8_GetTextureStageState(device, i, D3DTSS_BUMPENVMAT10, &value);
        ok(SUCCEEDED(hr), "Failed to get texture stage state, hr %#x.\n", hr);
        ok(!value, "Got unexpected value %#x for D3DTSS_BUMPENVMAT10, stage %u.\n", value, i);
        hr = IDirect3DDevice8_GetTextureStageState(device, i, D3DTSS_BUMPENVMAT11, &value);
        ok(SUCCEEDED(hr), "Failed to get texture stage state, hr %#x.\n", hr);
        ok(!value, "Got unexpected value %#x for D3DTSS_BUMPENVMAT11, stage %u.\n", value, i);
        hr = IDirect3DDevice8_GetTextureStageState(device, i, D3DTSS_TEXCOORDINDEX, &value);
        ok(SUCCEEDED(hr), "Failed to get texture stage state, hr %#x.\n", hr);
        ok(value == i, "Got unexpected value %#x for D3DTSS_TEXCOORDINDEX, stage %u.\n", value, i);
        hr = IDirect3DDevice8_GetTextureStageState(device, i, D3DTSS_BUMPENVLSCALE, &value);
        ok(SUCCEEDED(hr), "Failed to get texture stage state, hr %#x.\n", hr);
        ok(!value, "Got unexpected value %#x for D3DTSS_BUMPENVLSCALE, stage %u.\n", value, i);
        hr = IDirect3DDevice8_GetTextureStageState(device, i, D3DTSS_BUMPENVLOFFSET, &value);
        ok(SUCCEEDED(hr), "Failed to get texture stage state, hr %#x.\n", hr);
        ok(!value, "Got unexpected value %#x for D3DTSS_BUMPENVLOFFSET, stage %u.\n", value, i);
        hr = IDirect3DDevice8_GetTextureStageState(device, i, D3DTSS_TEXTURETRANSFORMFLAGS, &value);
        ok(SUCCEEDED(hr), "Failed to get texture stage state, hr %#x.\n", hr);
        ok(value == D3DTTFF_DISABLE,
                "Got unexpected value %#x for D3DTSS_TEXTURETRANSFORMFLAGS, stage %u.\n", value, i);
        hr = IDirect3DDevice8_GetTextureStageState(device, i, D3DTSS_COLORARG0, &value);
        ok(SUCCEEDED(hr), "Failed to get texture stage state, hr %#x.\n", hr);
        ok(value == D3DTA_CURRENT, "Got unexpected value %#x for D3DTSS_COLORARG0, stage %u.\n", value, i);
        hr = IDirect3DDevice8_GetTextureStageState(device, i, D3DTSS_ALPHAARG0, &value);
        ok(SUCCEEDED(hr), "Failed to get texture stage state, hr %#x.\n", hr);
        ok(value == D3DTA_CURRENT, "Got unexpected value %#x for D3DTSS_ALPHAARG0, stage %u.\n", value, i);
        hr = IDirect3DDevice8_GetTextureStageState(device, i, D3DTSS_RESULTARG, &value);
        ok(SUCCEEDED(hr), "Failed to get texture stage state, hr %#x.\n", hr);
        ok(value == D3DTA_CURRENT, "Got unexpected value %#x for D3DTSS_RESULTARG, stage %u.\n", value, i);
    }

    refcount = IDirect3DDevice8_Release(device);
    ok(!refcount, "Device has %u references left.\n", refcount);
    IDirect3D8_Release(d3d8);
    DestroyWindow(window);
}

static void test_cube_textures(void)
{
    IDirect3DCubeTexture8 *texture;
    IDirect3DDevice8 *device;
    IDirect3D8 *d3d8;
    ULONG refcount;
    D3DCAPS8 caps;
    HWND window;
    HRESULT hr;

    if (!(d3d8 = pDirect3DCreate8(D3D_SDK_VERSION)))
    {
        skip("Failed to create d3d8 object, skipping tests.\n");
        return;
    }

    window = CreateWindowA("d3d8_test_wc", "d3d8_test", WS_OVERLAPPEDWINDOW,
            0, 0, 640, 480, 0, 0, 0, 0);
    if (!(device = create_device(d3d8, window, window, TRUE)))
    {
        skip("Failed to create a D3D device, skipping tests.\n");
        IDirect3D8_Release(d3d8);
        DestroyWindow(window);
        return;
    }

    hr = IDirect3DDevice8_GetDeviceCaps(device, &caps);
    ok(SUCCEEDED(hr), "Failed to get device caps, hr %#x.\n", hr);

    if (caps.TextureCaps & D3DPTEXTURECAPS_CUBEMAP)
    {
        hr = IDirect3DDevice8_CreateCubeTexture(device, 512, 1, 0, D3DFMT_X8R8G8B8, D3DPOOL_DEFAULT, &texture);
        ok(hr == D3D_OK, "Failed to create D3DPOOL_DEFAULT cube texture, hr %#x.\n", hr);
        IDirect3DCubeTexture8_Release(texture);
        hr = IDirect3DDevice8_CreateCubeTexture(device, 512, 1, 0, D3DFMT_X8R8G8B8, D3DPOOL_MANAGED, &texture);
        ok(hr == D3D_OK, "Failed to create D3DPOOL_MANAGED cube texture, hr %#x.\n", hr);
        IDirect3DCubeTexture8_Release(texture);
        hr = IDirect3DDevice8_CreateCubeTexture(device, 512, 1, 0, D3DFMT_X8R8G8B8, D3DPOOL_SYSTEMMEM, &texture);
        ok(hr == D3D_OK, "Failed to create D3DPOOL_SYSTEMMEM cube texture, hr %#x.\n", hr);
        IDirect3DCubeTexture8_Release(texture);
    }
    else
    {
        hr = IDirect3DDevice8_CreateCubeTexture(device, 512, 1, 0, D3DFMT_X8R8G8B8, D3DPOOL_DEFAULT, &texture);
        ok(hr == D3DERR_INVALIDCALL, "Got unexpected hr %#x for D3DPOOL_DEFAULT cube texture.\n", hr);
        hr = IDirect3DDevice8_CreateCubeTexture(device, 512, 1, 0, D3DFMT_X8R8G8B8, D3DPOOL_MANAGED, &texture);
        ok(hr == D3DERR_INVALIDCALL, "Got unexpected hr %#x for D3DPOOL_MANAGED cube texture.\n", hr);
        hr = IDirect3DDevice8_CreateCubeTexture(device, 512, 1, 0, D3DFMT_X8R8G8B8, D3DPOOL_SYSTEMMEM, &texture);
        ok(hr == D3DERR_INVALIDCALL, "Got unexpected hr %#x for D3DPOOL_SYSTEMMEM cube texture.\n", hr);
    }
    hr = IDirect3DDevice8_CreateCubeTexture(device, 512, 1, 0, D3DFMT_X8R8G8B8, D3DPOOL_SCRATCH, &texture);
    ok(hr == D3D_OK, "Failed to create D3DPOOL_SCRATCH cube texture, hr %#x.\n", hr);
    IDirect3DCubeTexture8_Release(texture);

    refcount = IDirect3DDevice8_Release(device);
    ok(!refcount, "Device has %u references left.\n", refcount);
    IDirect3D8_Release(d3d8);
    DestroyWindow(window);
}

/* Test the behaviour of the IDirect3DDevice8::CreateImageSurface() method.
 *
 * The expected behaviour (as documented in the original DX8 docs) is that the
 * call returns a surface in the SYSTEMMEM pool. Games like Max Payne 1 and 2
 * depend on this behaviour.
 *
 * A short remark in the DX9 docs however states that the pool of the returned
 * surface object is D3DPOOL_SCRATCH. This is misinformation and would result
 * in screenshots not appearing in the savegame loading menu of both games
 * mentioned above (engine tries to display a texture from the scratch pool).
 *
 * This test verifies that the behaviour described in the original d3d8 docs
 * is the correct one. For more information about this issue, see the MSDN:
 *     d3d9 docs: "Converting to Direct3D 9"
 *     d3d9 reference: "IDirect3DDevice9::CreateOffscreenPlainSurface"
 *     d3d8 reference: "IDirect3DDevice8::CreateImageSurface" */
static void test_image_surface_pool(void)
{
    IDirect3DSurface8 *surface;
    IDirect3DDevice8 *device;
    D3DSURFACE_DESC desc;
    IDirect3D8 *d3d8;
    ULONG refcount;
    HWND window;
    HRESULT hr;

    if (!(d3d8 = pDirect3DCreate8(D3D_SDK_VERSION)))
    {
        skip("Failed to create d3d8 object, skipping tests.\n");
        return;
    }

    window = CreateWindowA("d3d8_test_wc", "d3d8_test", WS_OVERLAPPEDWINDOW,
            0, 0, 640, 480, 0, 0, 0, 0);
    if (!(device = create_device(d3d8, window, window, TRUE)))
    {
        skip("Failed to create a D3D device, skipping tests.\n");
        IDirect3D8_Release(d3d8);
        DestroyWindow(window);
        return;
    }

    hr = IDirect3DDevice8_CreateImageSurface(device, 128, 128, D3DFMT_A8R8G8B8, &surface);
    ok(SUCCEEDED(hr), "Failed to create surface, hr %#x.\n", hr);
    hr = IDirect3DSurface8_GetDesc(surface, &desc);
    ok(SUCCEEDED(hr), "Failed to get surface desc, hr %#x.\n", hr);
    ok(desc.Pool == D3DPOOL_SYSTEMMEM, "Got unexpected pool %#x.\n", desc.Pool);
    IDirect3DSurface8_Release(surface);

    refcount = IDirect3DDevice8_Release(device);
    ok(!refcount, "Device has %u references left.\n", refcount);
    IDirect3D8_Release(d3d8);
    DestroyWindow(window);
}

static void test_surface_get_container(void)
{
    IDirect3DTexture8 *texture = NULL;
    IDirect3DSurface8 *surface = NULL;
    IDirect3DDevice8 *device;
    IUnknown *container;
    IDirect3D8 *d3d8;
    ULONG refcount;
    HWND window;
    HRESULT hr;

    if (!(d3d8 = pDirect3DCreate8(D3D_SDK_VERSION)))
    {
        skip("Failed to create d3d8 object, skipping tests.\n");
        return;
    }

    window = CreateWindowA("d3d8_test_wc", "d3d8_test", WS_OVERLAPPEDWINDOW,
            0, 0, 640, 480, 0, 0, 0, 0);
    if (!(device = create_device(d3d8, window, window, TRUE)))
    {
        skip("Failed to create a D3D device, skipping tests.\n");
        IDirect3D8_Release(d3d8);
        DestroyWindow(window);
        return;
    }

    hr = IDirect3DDevice8_CreateTexture(device, 128, 128, 1, 0,
            D3DFMT_A8R8G8B8, D3DPOOL_DEFAULT, &texture);
    ok(SUCCEEDED(hr), "Failed to create texture, hr %#x.\n", hr);
    ok(!!texture, "Got unexpected texture %p.\n", texture);

    hr = IDirect3DTexture8_GetSurfaceLevel(texture, 0, &surface);
    ok(SUCCEEDED(hr), "Failed to get surface level, hr %#x.\n", hr);
    ok(!!surface, "Got unexpected surface %p.\n", surface);

    /* These should work... */
    container = NULL;
    hr = IDirect3DSurface8_GetContainer(surface, &IID_IUnknown, (void **)&container);
    ok(SUCCEEDED(hr), "Failed to get surface container, hr %#x.\n", hr);
    ok(container == (IUnknown *)texture, "Got unexpected container %p, expected %p.\n", container, texture);
    IUnknown_Release(container);

    container = NULL;
    hr = IDirect3DSurface8_GetContainer(surface, &IID_IDirect3DResource8, (void **)&container);
    ok(SUCCEEDED(hr), "Failed to get surface container, hr %#x.\n", hr);
    ok(container == (IUnknown *)texture, "Got unexpected container %p, expected %p.\n", container, texture);
    IUnknown_Release(container);

    container = NULL;
    hr = IDirect3DSurface8_GetContainer(surface, &IID_IDirect3DBaseTexture8, (void **)&container);
    ok(SUCCEEDED(hr), "Failed to get surface container, hr %#x.\n", hr);
    ok(container == (IUnknown *)texture, "Got unexpected container %p, expected %p.\n", container, texture);
    IUnknown_Release(container);

    container = NULL;
    hr = IDirect3DSurface8_GetContainer(surface, &IID_IDirect3DTexture8, (void **)&container);
    ok(SUCCEEDED(hr), "Failed to get surface container, hr %#x.\n", hr);
    ok(container == (IUnknown *)texture, "Got unexpected container %p, expected %p.\n", container, texture);
    IUnknown_Release(container);

    /* ...and this one shouldn't. This should return E_NOINTERFACE and set container to NULL. */
    hr = IDirect3DSurface8_GetContainer(surface, &IID_IDirect3DSurface8, (void **)&container);
    ok(hr == E_NOINTERFACE, "Got unexpected hr %#x.\n", hr);
    ok(!container, "Got unexpected container %p.\n", container);

    IDirect3DSurface8_Release(surface);
    IDirect3DTexture8_Release(texture);
    refcount = IDirect3DDevice8_Release(device);
    ok(!refcount, "Device has %u references left.\n", refcount);
    IDirect3D8_Release(d3d8);
    DestroyWindow(window);
}

static void test_lockrect_invalid(void)
{
    static const RECT valid[] =
    {
        {60, 60, 68, 68},
        {120, 60, 128, 68},
        {60, 120, 68, 128},
    };
    static const RECT invalid[] =
    {
        {60, 60, 60, 68},       /* 0 height */
        {60, 60, 68, 60},       /* 0 width */
        {68, 60, 60, 68},       /* left > right */
        {60, 68, 68, 60},       /* top > bottom */
        {-8, 60,  0, 68},       /* left < surface */
        {60, -8, 68,  0},       /* top < surface */
        {-16, 60, -8, 68},      /* right < surface */
        {60, -16, 68, -8},      /* bottom < surface */
        {60, 60, 136, 68},      /* right > surface */
        {60, 60, 68, 136},      /* bottom > surface */
        {136, 60, 144, 68},     /* left > surface */
        {60, 136, 68, 144},     /* top > surface */
    };
    IDirect3DSurface8 *surface = NULL;
    D3DLOCKED_RECT locked_rect;
    IDirect3DDevice8 *device;
    IDirect3D8 *d3d8;
    unsigned int i;
    ULONG refcount;
    HWND window;
    BYTE *base;
    HRESULT hr;

    if (!(d3d8 = pDirect3DCreate8(D3D_SDK_VERSION)))
    {
        skip("Failed to create d3d8 object, skipping tests.\n");
        return;
    }

    window = CreateWindowA("d3d8_test_wc", "d3d8_test", WS_OVERLAPPEDWINDOW,
            0, 0, 640, 480, 0, 0, 0, 0);
    if (!(device = create_device(d3d8, window, window, TRUE)))
    {
        skip("Failed to create a D3D device, skipping tests.\n");
        IDirect3D8_Release(d3d8);
        DestroyWindow(window);
        return;
    }

    hr = IDirect3DDevice8_CreateImageSurface(device, 128, 128, D3DFMT_A8R8G8B8, &surface);
    ok(SUCCEEDED(hr), "Failed to create surface, hr %#x.\n", hr);
    hr = IDirect3DSurface8_LockRect(surface, &locked_rect, NULL, 0);
    ok(SUCCEEDED(hr), "Failed to lock surface, hr %#x.\n", hr);
    base = locked_rect.pBits;
    hr = IDirect3DSurface8_UnlockRect(surface);
    ok(SUCCEEDED(hr), "Failed to unlock surface, hr %#x.\n", hr);

    for (i = 0; i < (sizeof(valid) / sizeof(*valid)); ++i)
    {
        unsigned int offset, expected_offset;
        const RECT *rect = &valid[i];

        locked_rect.pBits = (BYTE *)0xdeadbeef;
        locked_rect.Pitch = 0xdeadbeef;

        hr = IDirect3DSurface8_LockRect(surface, &locked_rect, rect, 0);
        ok(SUCCEEDED(hr), "Failed to lock surface with rect [%d, %d]->[%d, %d], hr %#x.\n",
                rect->left, rect->top, rect->right, rect->bottom, hr);

        offset = (BYTE *)locked_rect.pBits - base;
        expected_offset = rect->top * locked_rect.Pitch + rect->left * 4;
        ok(offset == expected_offset,
                "Got unexpected offset %u (expected %u) for rect [%d, %d]->[%d, %d].\n",
                offset, expected_offset, rect->left, rect->top, rect->right, rect->bottom);

        hr = IDirect3DSurface8_UnlockRect(surface);
        ok(SUCCEEDED(hr), "Failed to unlock surface, hr %#x.\n", hr);
    }

    for (i = 0; i < (sizeof(invalid) / sizeof(*invalid)); ++i)
    {
        const RECT *rect = &invalid[i];

        hr = IDirect3DSurface8_LockRect(surface, &locked_rect, rect, 0);
        ok(hr == D3DERR_INVALIDCALL, "Got unexpected hr %#x for rect [%d, %d]->[%d, %d].\n",
                hr, rect->left, rect->top, rect->right, rect->bottom);
    }

    hr = IDirect3DSurface8_LockRect(surface, &locked_rect, NULL, 0);
    ok(SUCCEEDED(hr), "Failed to lock surface with rect NULL, hr %#x.\n", hr);
    hr = IDirect3DSurface8_LockRect(surface, &locked_rect, NULL, 0);
    ok(hr == D3DERR_INVALIDCALL, "Got unexpected hr %#x.\n", hr);
    hr = IDirect3DSurface8_UnlockRect(surface);
    ok(SUCCEEDED(hr), "Failed to unlock surface, hr %#x.\n", hr);

    hr = IDirect3DSurface8_LockRect(surface, &locked_rect, &valid[0], 0);
    ok(hr == D3D_OK, "Got unexpected hr %#x for rect [%d, %d]->[%d, %d].\n",
            hr, valid[0].left, valid[0].top, valid[0].right, valid[0].bottom);
    hr = IDirect3DSurface8_LockRect(surface, &locked_rect, &valid[0], 0);
    ok(hr == D3DERR_INVALIDCALL, "Got unexpected hr %#x for rect [%d, %d]->[%d, %d].\n",
            hr, valid[0].left, valid[0].top, valid[0].right, valid[0].bottom);
    hr = IDirect3DSurface8_LockRect(surface, &locked_rect, &valid[1], 0);
    ok(hr == D3DERR_INVALIDCALL, "Got unexpected hr %#x for rect [%d, %d]->[%d, %d].\n",
            hr, valid[1].left, valid[1].top, valid[1].right, valid[1].bottom);
    hr = IDirect3DSurface8_UnlockRect(surface);
    ok(SUCCEEDED(hr), "Failed to unlock surface, hr %#x.\n", hr);

    IDirect3DSurface8_Release(surface);
    refcount = IDirect3DDevice8_Release(device);
    ok(!refcount, "Device has %u references left.\n", refcount);
    IDirect3D8_Release(d3d8);
    DestroyWindow(window);
}

static void test_private_data(void)
{
    ULONG refcount, expected_refcount;
    IDirect3DSurface8 *surface;
    IDirect3DDevice8 *device;
    IDirect3D8 *d3d8;
    IUnknown *ptr;
    HWND window;
    HRESULT hr;
    DWORD size;

    if (!(d3d8 = pDirect3DCreate8(D3D_SDK_VERSION)))
    {
        skip("Failed to create d3d8 object, skipping tests.\n");
        return;
    }

    window = CreateWindowA("d3d8_test_wc", "d3d8_test", WS_OVERLAPPEDWINDOW,
            0, 0, 640, 480, 0, 0, 0, 0);
    if (!(device = create_device(d3d8, window, window, TRUE)))
    {
        skip("Failed to create a D3D device, skipping tests.\n");
        IDirect3D8_Release(d3d8);
        DestroyWindow(window);
        return;
    }

    hr = IDirect3DDevice8_CreateImageSurface(device, 4, 4, D3DFMT_A8R8G8B8, &surface);
    ok(SUCCEEDED(hr), "Failed to create surface, hr %#x.\n", hr);

    hr = IDirect3DSurface8_SetPrivateData(surface, &IID_IDirect3DSurface8 /* Abuse this tag */,
            device, 0, D3DSPD_IUNKNOWN);
    ok(hr == D3DERR_INVALIDCALL, "Got unexpected hr %#x.\n", hr);
    hr = IDirect3DSurface8_SetPrivateData(surface, &IID_IDirect3DSurface8 /* Abuse this tag */,
            device, 5, D3DSPD_IUNKNOWN);
    ok(hr == D3DERR_INVALIDCALL, "Got unexpected hr %#x.\n", hr);
    hr = IDirect3DSurface8_SetPrivateData(surface, &IID_IDirect3DSurface8 /* Abuse this tag */,
            device, sizeof(IUnknown *) * 2, D3DSPD_IUNKNOWN);
    ok(hr == D3DERR_INVALIDCALL, "Got unexpected hr %#x.\n", hr);

    refcount = get_refcount((IUnknown *)device);
    hr = IDirect3DSurface8_SetPrivateData(surface, &IID_IDirect3DSurface8 /* Abuse this tag */,
            device, sizeof(IUnknown *), D3DSPD_IUNKNOWN);
    ok(hr == D3D_OK, "Got unexpected hr %#x.\n", hr);
    expected_refcount = refcount + 1;
    refcount = get_refcount((IUnknown *)device);
    ok(refcount == expected_refcount, "Got unexpected refcount %u, expected %u.\n", refcount, expected_refcount);
    hr = IDirect3DSurface8_FreePrivateData(surface, &IID_IDirect3DSurface8);
    ok(hr == D3D_OK, "Got unexpected hr %#x.\n", hr);
    expected_refcount = refcount - 1;
    refcount = get_refcount((IUnknown *)device);
    ok(refcount == expected_refcount, "Got unexpected refcount %u, expected %u.\n", refcount, expected_refcount);

    hr = IDirect3DSurface8_SetPrivateData(surface, &IID_IDirect3DSurface8,
            device, sizeof(IUnknown *), D3DSPD_IUNKNOWN);
    ok(hr == D3D_OK, "Got unexpected hr %#x.\n", hr);
    hr = IDirect3DSurface8_SetPrivateData(surface, &IID_IDirect3DSurface8,
            surface, sizeof(IUnknown *), D3DSPD_IUNKNOWN);
    ok(hr == D3D_OK, "Got unexpected hr %#x.\n", hr);
    refcount = get_refcount((IUnknown *)device);
    ok(refcount == expected_refcount, "Got unexpected refcount %u, expected %u.\n", refcount, expected_refcount);

    hr = IDirect3DSurface8_SetPrivateData(surface, &IID_IDirect3DSurface8,
            device, sizeof(IUnknown *), D3DSPD_IUNKNOWN);
    ok(hr == D3D_OK, "Got unexpected hr %#x.\n", hr);
    size = sizeof(ptr);
    hr = IDirect3DSurface8_GetPrivateData(surface, &IID_IDirect3DSurface8, &ptr, &size);
    ok(hr == D3D_OK, "Got unexpected hr %#x.\n", hr);
    expected_refcount = refcount + 2;
    refcount = get_refcount((IUnknown *)device);
    ok(refcount == expected_refcount, "Got unexpected refcount %u, expected %u.\n", refcount, expected_refcount);
    ok(ptr == (IUnknown *)device, "Got unexpected ptr %p, expected %p.\n", ptr, device);
    IUnknown_Release(ptr);

    /* Destroying the surface frees the held reference. */
    IDirect3DSurface8_Release(surface);
    expected_refcount = refcount - 3;
    refcount = get_refcount((IUnknown *)device);
    ok(refcount == expected_refcount, "Got unexpected refcount %u, expected %u.\n", refcount, expected_refcount);

    refcount = IDirect3DDevice8_Release(device);
    ok(!refcount, "Device has %u references left.\n", refcount);
    IDirect3D8_Release(d3d8);
    DestroyWindow(window);
}

static void test_surface_dimensions(void)
{
    IDirect3DSurface8 *surface;
    IDirect3DDevice8 *device;
    IDirect3D8 *d3d8;
    ULONG refcount;
    HWND window;
    HRESULT hr;

    if (!(d3d8 = pDirect3DCreate8(D3D_SDK_VERSION)))
    {
        skip("Failed to create d3d8 object, skipping tests.\n");
        return;
    }

    window = CreateWindowA("d3d8_test_wc", "d3d8_test", WS_OVERLAPPEDWINDOW,
            0, 0, 640, 480, 0, 0, 0, 0);
    if (!(device = create_device(d3d8, window, window, TRUE)))
    {
        skip("Failed to create a D3D device, skipping tests.\n");
        IDirect3D8_Release(d3d8);
        DestroyWindow(window);
        return;
    }

    hr = IDirect3DDevice8_CreateImageSurface(device, 0, 1, D3DFMT_A8R8G8B8, &surface);
    ok(hr == D3DERR_INVALIDCALL, "Got unexpected hr %#x.\n", hr);
    hr = IDirect3DDevice8_CreateImageSurface(device, 1, 0, D3DFMT_A8R8G8B8, &surface);
    ok(hr == D3DERR_INVALIDCALL, "Got unexpected hr %#x.\n", hr);

    refcount = IDirect3DDevice8_Release(device);
    ok(!refcount, "Device has %u references left.\n", refcount);
    IDirect3D8_Release(d3d8);
    DestroyWindow(window);
}

static void test_surface_format_null(void)
{
    static const D3DFORMAT D3DFMT_NULL = MAKEFOURCC('N','U','L','L');
    IDirect3DTexture8 *texture;
    IDirect3DSurface8 *surface;
    IDirect3DSurface8 *rt, *ds;
    D3DLOCKED_RECT locked_rect;
    IDirect3DDevice8 *device;
    D3DSURFACE_DESC desc;
    IDirect3D8 *d3d;
    ULONG refcount;
    HWND window;
    HRESULT hr;

    if (!(d3d = pDirect3DCreate8(D3D_SDK_VERSION)))
    {
        skip("Failed to create D3D object, skipping tests.\n");
        return;
    }

    hr = IDirect3D8_CheckDeviceFormat(d3d, 0, D3DDEVTYPE_HAL, D3DFMT_X8R8G8B8,
            D3DUSAGE_RENDERTARGET, D3DRTYPE_SURFACE, D3DFMT_NULL);
    if (hr != D3D_OK)
    {
        skip("No D3DFMT_NULL support, skipping test.\n");
        IDirect3D8_Release(d3d);
        return;
    }

    window = CreateWindowA("d3d8_test_wc", "d3d8_test", WS_OVERLAPPEDWINDOW,
            0, 0, 640, 480, 0, 0, 0, 0);
    if (!(device = create_device(d3d, window, window, TRUE)))
    {
        skip("Failed to create a D3D device, skipping tests.\n");
        IDirect3D8_Release(d3d);
        DestroyWindow(window);
        return;
    }

    hr = IDirect3D8_CheckDeviceFormat(d3d, 0, D3DDEVTYPE_HAL, D3DFMT_X8R8G8B8,
            D3DUSAGE_RENDERTARGET, D3DRTYPE_TEXTURE, D3DFMT_NULL);
    ok(hr == D3D_OK, "D3DFMT_NULL should be supported for render target textures, hr %#x.\n", hr);

    hr = IDirect3D8_CheckDepthStencilMatch(d3d, D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL, D3DFMT_X8R8G8B8,
            D3DFMT_NULL, D3DFMT_D24S8);
    ok(SUCCEEDED(hr), "Depth stencil match failed for D3DFMT_NULL, hr %#x.\n", hr);

    hr = IDirect3DDevice8_CreateRenderTarget(device, 128, 128, D3DFMT_NULL,
            D3DMULTISAMPLE_NONE, TRUE, &surface);
    ok(SUCCEEDED(hr), "Failed to create render target, hr %#x.\n", hr);

    hr = IDirect3DDevice8_GetRenderTarget(device, &rt);
    ok(SUCCEEDED(hr), "Failed to get original render target, hr %#x.\n", hr);

    hr = IDirect3DDevice8_GetDepthStencilSurface(device, &ds);
    ok(SUCCEEDED(hr), "Failed to get original depth/stencil, hr %#x.\n", hr);

    hr = IDirect3DDevice8_SetRenderTarget(device, surface, NULL);
    ok(SUCCEEDED(hr), "Failed to set render target, hr %#x.\n", hr);

    hr = IDirect3DDevice8_Clear(device, 0, NULL, D3DCLEAR_TARGET, 0x00000000, 0.0f, 0);
    ok(SUCCEEDED(hr), "Clear failed, hr %#x.\n", hr);

    hr = IDirect3DDevice8_SetRenderTarget(device, rt, ds);
    ok(SUCCEEDED(hr), "Failed to set render target, hr %#x.\n", hr);

    IDirect3DSurface8_Release(rt);
    IDirect3DSurface8_Release(ds);

    hr = IDirect3DSurface8_GetDesc(surface, &desc);
    ok(SUCCEEDED(hr), "Failed to get surface desc, hr %#x.\n", hr);
    ok(desc.Width == 128, "Expected width 128, got %u.\n", desc.Width);
    ok(desc.Height == 128, "Expected height 128, got %u.\n", desc.Height);

    hr = IDirect3DSurface8_LockRect(surface, &locked_rect, NULL, 0);
    ok(SUCCEEDED(hr), "Failed to lock surface, hr %#x.\n", hr);
    ok(locked_rect.Pitch, "Expected non-zero pitch, got %u.\n", locked_rect.Pitch);
    ok(!!locked_rect.pBits, "Expected non-NULL pBits, got %p.\n", locked_rect.pBits);

    hr = IDirect3DSurface8_UnlockRect(surface);
    ok(SUCCEEDED(hr), "Failed to unlock surface, hr %#x.\n", hr);

    IDirect3DSurface8_Release(surface);

    hr = IDirect3DDevice8_CreateTexture(device, 128, 128, 0, D3DUSAGE_RENDERTARGET,
            D3DFMT_NULL, D3DPOOL_DEFAULT, &texture);
    ok(SUCCEEDED(hr), "Failed to create texture, hr %#x.\n", hr);
    IDirect3DTexture8_Release(texture);

    refcount = IDirect3DDevice8_Release(device);
    ok(!refcount, "Device has %u references left.\n", refcount);
    IDirect3D8_Release(d3d);
    DestroyWindow(window);
}

static void test_surface_double_unlock(void)
{
    static const D3DPOOL pools[] =
    {
        D3DPOOL_DEFAULT,
        D3DPOOL_SYSTEMMEM,
    };
    IDirect3DSurface8 *surface;
    IDirect3DDevice8 *device;
    D3DLOCKED_RECT lr;
    IDirect3D8 *d3d;
    unsigned int i;
    ULONG refcount;
    HWND window;
    HRESULT hr;

    if (!(d3d = pDirect3DCreate8(D3D_SDK_VERSION)))
    {
        skip("Failed to create D3D object, skipping tests.\n");
        return;
    }

    window = CreateWindowA("d3d8_test_wc", "d3d8_test", WS_OVERLAPPEDWINDOW,
            0, 0, 640, 480, 0, 0, 0, 0);
    if (!(device = create_device(d3d, window, window, TRUE)))
    {
        skip("Failed to create a D3D device, skipping tests.\n");
        IDirect3D8_Release(d3d);
        DestroyWindow(window);
        return;
    }

    for (i = 0; i < (sizeof(pools) / sizeof(*pools)); ++i)
    {
        switch (pools[i])
        {
            case D3DPOOL_DEFAULT:
                hr = IDirect3D8_CheckDeviceFormat(d3d, 0, D3DDEVTYPE_HAL, D3DFMT_X8R8G8B8,
                        D3DUSAGE_RENDERTARGET, D3DRTYPE_SURFACE, D3DFMT_X8R8G8B8);
                if (FAILED(hr))
                {
                    skip("D3DFMT_X8R8G8B8 render targets not supported, skipping double unlock DEFAULT pool test.\n");
                    continue;
                }

                hr = IDirect3DDevice8_CreateRenderTarget(device, 64, 64, D3DFMT_X8R8G8B8,
                        D3DMULTISAMPLE_NONE, TRUE, &surface);
                ok(SUCCEEDED(hr), "Failed to create render target, hr %#x.\n", hr);
                break;

            case D3DPOOL_SYSTEMMEM:
                hr = IDirect3DDevice8_CreateImageSurface(device, 64, 64, D3DFMT_X8R8G8B8, &surface);
                ok(SUCCEEDED(hr), "Failed to create image surface, hr %#x.\n", hr);
                break;

            default:
                break;
        }

        hr = IDirect3DSurface8_UnlockRect(surface);
        ok(hr == D3DERR_INVALIDCALL, "Got unexpected hr %#x, for surface in pool %#x.\n", hr, pools[i]);
        hr = IDirect3DSurface8_LockRect(surface, &lr, NULL, 0);
        ok(SUCCEEDED(hr), "Failed to lock surface in pool %#x, hr %#x.\n", pools[i], hr);
        hr = IDirect3DSurface8_UnlockRect(surface);
        ok(SUCCEEDED(hr), "Failed to unlock surface in pool %#x, hr %#x.\n", pools[i], hr);
        hr = IDirect3DSurface8_UnlockRect(surface);
        ok(hr == D3DERR_INVALIDCALL, "Got unexpected hr %#x, for surface in pool %#x.\n", hr, pools[i]);

        IDirect3DSurface8_Release(surface);
    }

    refcount = IDirect3DDevice8_Release(device);
    ok(!refcount, "Device has %u references left.\n", refcount);
    IDirect3D8_Release(d3d);
    DestroyWindow(window);
}

static void test_surface_lockrect_blocks(void)
{
    static const struct
    {
        D3DFORMAT fmt;
        const char *name;
        unsigned int block_width;
        unsigned int block_height;
        BOOL broken;
    }
    formats[] =
    {
        {D3DFMT_DXT1,                 "D3DFMT_DXT1", 4, 4, FALSE},
        {D3DFMT_DXT2,                 "D3DFMT_DXT2", 4, 4, FALSE},
        {D3DFMT_DXT3,                 "D3DFMT_DXT3", 4, 4, FALSE},
        {D3DFMT_DXT4,                 "D3DFMT_DXT4", 4, 4, FALSE},
        {D3DFMT_DXT5,                 "D3DFMT_DXT5", 4, 4, FALSE},
        /* ATI2N has 2x2 blocks on all AMD cards and Geforce 7 cards,
         * which doesn't match the format spec. On newer Nvidia cards
         * it has the correct 4x4 block size */
        {MAKEFOURCC('A','T','I','2'), "ATI2N",       4, 4, TRUE},
        /* YUY2 and UYVY are not supported in d3d8, there is no way
         * to use them with this API considering their restrictions */
    };
    static const struct
    {
        D3DPOOL pool;
        const char *name;
        /* Don't check the return value, Nvidia returns D3DERR_INVALIDCALL for some formats
         * and E_INVALIDARG/DDERR_INVALIDPARAMS for others. */
        BOOL success;
    }
    pools[] =
    {
        {D3DPOOL_DEFAULT,       "D3DPOOL_DEFAULT",  FALSE},
        {D3DPOOL_SCRATCH,       "D3DPOOL_SCRATCH",  TRUE},
        {D3DPOOL_SYSTEMMEM,     "D3DPOOL_SYSTEMMEM",TRUE},
        {D3DPOOL_MANAGED,       "D3DPOOL_MANAGED",  TRUE},
    };
    IDirect3DTexture8 *texture;
    IDirect3DSurface8 *surface;
    D3DLOCKED_RECT locked_rect;
    IDirect3DDevice8 *device;
    unsigned int i, j;
    IDirect3D8 *d3d;
    ULONG refcount;
    HWND window;
    HRESULT hr;
    RECT rect;

    if (!(d3d = pDirect3DCreate8(D3D_SDK_VERSION)))
    {
        skip("Failed to create D3D object, skipping tests.\n");
        return;
    }

    window = CreateWindowA("d3d8_test_wc", "d3d8_test", WS_OVERLAPPEDWINDOW,
            0, 0, 640, 480, 0, 0, 0, 0);
    if (!(device = create_device(d3d, window, window, TRUE)))
    {
        skip("Failed to create a D3D device, skipping tests.\n");
        IDirect3D8_Release(d3d);
        DestroyWindow(window);
        return;
    }

    for (i = 0; i < (sizeof(formats) / sizeof(*formats)); ++i)
    {
        hr = IDirect3D8_CheckDeviceFormat(d3d, 0, D3DDEVTYPE_HAL, D3DFMT_X8R8G8B8,
                D3DUSAGE_DYNAMIC, D3DRTYPE_TEXTURE, formats[i].fmt);
        if (FAILED(hr))
        {
            skip("Format %s not supported, skipping lockrect offset tests.\n", formats[i].name);
            continue;
        }

        for (j = 0; j < (sizeof(pools) / sizeof(*pools)); ++j)
        {
            hr = IDirect3DDevice8_CreateTexture(device, 128, 128, 1,
                    pools[j].pool == D3DPOOL_DEFAULT ? D3DUSAGE_DYNAMIC : 0,
                    formats[i].fmt, pools[j].pool, &texture);
            ok(SUCCEEDED(hr), "Failed to create texture, hr %#x.\n", hr);
            hr = IDirect3DTexture8_GetSurfaceLevel(texture, 0, &surface);
            ok(SUCCEEDED(hr), "Failed to get surface level, hr %#x.\n", hr);
            IDirect3DTexture8_Release(texture);

            if (formats[i].block_width > 1)
            {
                SetRect(&rect, formats[i].block_width >> 1, 0, formats[i].block_width, formats[i].block_height);
                hr = IDirect3DSurface8_LockRect(surface, &locked_rect, &rect, 0);
                ok(FAILED(hr) == !pools[j].success || broken(formats[i].broken),
                        "Partial block lock %s, expected %s, format %s, pool %s.\n",
                        SUCCEEDED(hr) ? "succeeded" : "failed",
                        pools[j].success ? "success" : "failure", formats[i].name, pools[j].name);
                if (SUCCEEDED(hr))
                {
                    hr = IDirect3DSurface8_UnlockRect(surface);
                    ok(SUCCEEDED(hr), "Failed to unlock surface, hr %#x.\n", hr);
                }

                SetRect(&rect, 0, 0, formats[i].block_width >> 1, formats[i].block_height);
                hr = IDirect3DSurface8_LockRect(surface, &locked_rect, &rect, 0);
                ok(FAILED(hr) == !pools[j].success || broken(formats[i].broken),
                        "Partial block lock %s, expected %s, format %s, pool %s.\n",
                        SUCCEEDED(hr) ? "succeeded" : "failed",
                        pools[j].success ? "success" : "failure", formats[i].name, pools[j].name);
                if (SUCCEEDED(hr))
                {
                    hr = IDirect3DSurface8_UnlockRect(surface);
                    ok(SUCCEEDED(hr), "Failed to unlock surface, hr %#x.\n", hr);
                }
            }

            if (formats[i].block_height > 1)
            {
                SetRect(&rect, 0, formats[i].block_height >> 1, formats[i].block_width, formats[i].block_height);
                hr = IDirect3DSurface8_LockRect(surface, &locked_rect, &rect, 0);
                ok(FAILED(hr) == !pools[j].success || broken(formats[i].broken),
                        "Partial block lock %s, expected %s, format %s, pool %s.\n",
                        SUCCEEDED(hr) ? "succeeded" : "failed",
                        pools[j].success ? "success" : "failure", formats[i].name, pools[j].name);
                if (SUCCEEDED(hr))
                {
                    hr = IDirect3DSurface8_UnlockRect(surface);
                    ok(SUCCEEDED(hr), "Failed to unlock surface, hr %#x.\n", hr);
                }

                SetRect(&rect, 0, 0, formats[i].block_width, formats[i].block_height >> 1);
                hr = IDirect3DSurface8_LockRect(surface, &locked_rect, &rect, 0);
                ok(FAILED(hr) == !pools[j].success || broken(formats[i].broken),
                        "Partial block lock %s, expected %s, format %s, pool %s.\n",
                        SUCCEEDED(hr) ? "succeeded" : "failed",
                        pools[j].success ? "success" : "failure", formats[i].name, pools[j].name);
                if (SUCCEEDED(hr))
                {
                    hr = IDirect3DSurface8_UnlockRect(surface);
                    ok(SUCCEEDED(hr), "Failed to unlock surface, hr %#x.\n", hr);
                }
            }

            SetRect(&rect, 0, 0, formats[i].block_width, formats[i].block_height);
            hr = IDirect3DSurface8_LockRect(surface, &locked_rect, &rect, 0);
            ok(hr == D3D_OK, "Got unexpected hr %#x for format %s, pool %s.\n", hr, formats[i].name, pools[j].name);
            hr = IDirect3DSurface8_UnlockRect(surface);
            ok(SUCCEEDED(hr), "Failed to unlock surface, hr %#x.\n", hr);

            IDirect3DSurface8_Release(surface);
        }
    }

    refcount = IDirect3DDevice8_Release(device);
    ok(!refcount, "Device has %u references left.\n", refcount);
    IDirect3D8_Release(d3d);
    DestroyWindow(window);
}

static void test_set_palette(void)
{
    IDirect3DDevice8 *device;
    IDirect3D8 *d3d8;
    UINT refcount;
    HWND window;
    HRESULT hr;
    PALETTEENTRY pal[256];
    unsigned int i;
    D3DCAPS8 caps;

    if (!(d3d8 = pDirect3DCreate8(D3D_SDK_VERSION)))
    {
        skip("Failed to create d3d8 object, skipping tests.\n");
        return;
    }

    window = CreateWindowA("d3d8_test_wc", "d3d8_test", WS_OVERLAPPEDWINDOW,
            0, 0, 640, 480, 0, 0, 0, 0);
    if (!(device = create_device(d3d8, window, window, TRUE)))
    {
        skip("Failed to create a D3D device, skipping tests.\n");
        IDirect3D8_Release(d3d8);
        DestroyWindow(window);
        return;
    }

    for (i = 0; i < sizeof(pal) / sizeof(*pal); i++)
    {
        pal[i].peRed = i;
        pal[i].peGreen = i;
        pal[i].peBlue = i;
        pal[i].peFlags = 0xff;
    }
    hr = IDirect3DDevice8_SetPaletteEntries(device, 0, pal);
    ok(SUCCEEDED(hr), "Failed to set palette entries, hr %#x.\n", hr);

    hr = IDirect3DDevice8_GetDeviceCaps(device, &caps);
    ok(SUCCEEDED(hr), "Failed to get device caps, hr %#x.\n", hr);
    for (i = 0; i < sizeof(pal) / sizeof(*pal); i++)
    {
        pal[i].peRed = i;
        pal[i].peGreen = i;
        pal[i].peBlue = i;
        pal[i].peFlags = i;
    }
    if (caps.TextureCaps & D3DPTEXTURECAPS_ALPHAPALETTE)
    {
        hr = IDirect3DDevice8_SetPaletteEntries(device, 0, pal);
        ok(SUCCEEDED(hr), "Failed to set palette entries, hr %#x.\n", hr);
    }
    else
    {
        hr = IDirect3DDevice8_SetPaletteEntries(device, 0, pal);
        ok(hr == D3DERR_INVALIDCALL, "SetPaletteEntries returned %#x, expected D3DERR_INVALIDCALL.\n", hr);
    }

    refcount = IDirect3DDevice8_Release(device);
    ok(!refcount, "Device has %u references left.\n", refcount);
    IDirect3D8_Release(d3d8);
    DestroyWindow(window);
}

static void test_swvp_buffer(void)
{
    IDirect3DDevice8 *device;
    IDirect3D8 *d3d8;
    UINT refcount;
    HWND window;
    HRESULT hr;
    unsigned int i;
    IDirect3DVertexBuffer8 *buffer;
    static const unsigned int bufsize = 1024;
    D3DVERTEXBUFFER_DESC desc;
    D3DPRESENT_PARAMETERS present_parameters = {0};
    struct
    {
        float x, y, z;
    } *ptr, *ptr2;

    if (!(d3d8 = pDirect3DCreate8(D3D_SDK_VERSION)))
    {
        skip("Failed to create d3d8 object, skipping tests.\n");
        return;
    }

    window = CreateWindowA("d3d8_test_wc", "d3d8_test", WS_OVERLAPPEDWINDOW,
            0, 0, 640, 480, 0, 0, 0, 0);

    present_parameters.Windowed = TRUE;
    present_parameters.hDeviceWindow = window;
    present_parameters.SwapEffect = D3DSWAPEFFECT_DISCARD;
    present_parameters.BackBufferWidth = screen_width;
    present_parameters.BackBufferHeight = screen_height;
    present_parameters.BackBufferFormat = D3DFMT_A8R8G8B8;
    present_parameters.EnableAutoDepthStencil = FALSE;
    if (FAILED(IDirect3D8_CreateDevice(d3d8, D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL, window,
            D3DCREATE_SOFTWARE_VERTEXPROCESSING, &present_parameters, &device)))
    {
        skip("Failed to create a D3D device, skipping tests.\n");
        IDirect3D8_Release(d3d8);
        DestroyWindow(window);
        return;
    }

    hr = IDirect3DDevice8_CreateVertexBuffer(device, bufsize * sizeof(*ptr), D3DUSAGE_DYNAMIC | D3DUSAGE_WRITEONLY, 0,
            D3DPOOL_DEFAULT, &buffer);
    ok(SUCCEEDED(hr), "Failed to create buffer, hr %#x.\n", hr);
    hr = IDirect3DVertexBuffer8_GetDesc(buffer, &desc);
    ok(SUCCEEDED(hr), "Failed to get desc, hr %#x.\n", hr);
    ok(desc.Pool == D3DPOOL_DEFAULT, "Got pool %u, expected D3DPOOL_DEFAULT\n", desc.Pool);
    ok(desc.Usage == (D3DUSAGE_DYNAMIC | D3DUSAGE_WRITEONLY),
            "Got usage %u, expected D3DUSAGE_DYNAMIC | D3DUSAGE_WRITEONLY\n", desc.Usage);

    hr = IDirect3DVertexBuffer8_Lock(buffer, 0, bufsize * sizeof(*ptr), (BYTE **)&ptr, D3DLOCK_DISCARD);
    ok(SUCCEEDED(hr), "Failed to lock buffer, hr %#x.\n", hr);
    for (i = 0; i < bufsize; i++)
    {
        ptr[i].x = i * 1.0f;
        ptr[i].y = i * 2.0f;
        ptr[i].z = i * 3.0f;
    }
    hr = IDirect3DVertexBuffer8_Unlock(buffer);
    ok(SUCCEEDED(hr), "Failed to unlock buffer, hr %#x.\n", hr);

    hr = IDirect3DDevice8_SetVertexShader(device, D3DFVF_XYZ);
    ok(SUCCEEDED(hr), "Failed to set fvf, hr %#x.\n", hr);
    hr = IDirect3DDevice8_SetStreamSource(device, 0, buffer, sizeof(*ptr));
    ok(SUCCEEDED(hr), "Failed to set stream source, hr %#x.\n", hr);
    hr = IDirect3DDevice8_BeginScene(device);
    ok(SUCCEEDED(hr), "Failed to begin scene, hr %#x.\n", hr);
    hr = IDirect3DDevice8_DrawPrimitive(device, D3DPT_TRIANGLELIST, 0, 2);
    ok(SUCCEEDED(hr), "Failed to draw, hr %#x.\n", hr);
    hr = IDirect3DDevice8_EndScene(device);
    ok(SUCCEEDED(hr), "Failed to end scene, hr %#x.\n", hr);

    hr = IDirect3DVertexBuffer8_Lock(buffer, 0, bufsize * sizeof(*ptr2), (BYTE **)&ptr2, D3DLOCK_DISCARD);
    ok(SUCCEEDED(hr), "Failed to lock buffer, hr %#x.\n", hr);
    ok(ptr == ptr2, "Lock returned two different pointers: %p, %p\n", ptr, ptr2);
    for (i = 0; i < bufsize; i++)
    {
        if (ptr2[i].x != i * 1.0f || ptr2[i].y != i * 2.0f || ptr2[i].z != i * 3.0f)
        {
            ok(FALSE, "Vertex %u is %f,%f,%f, expected %f,%f,%f\n", i,
                    ptr2[i].x, ptr2[i].y, ptr2[i].z, i * 1.0f, i * 2.0f, i * 3.0f);
            break;
        }
    }
    hr = IDirect3DVertexBuffer8_Unlock(buffer);
    ok(SUCCEEDED(hr), "Failed to unlock buffer, hr %#x.\n", hr);

    IDirect3DVertexBuffer8_Release(buffer);
    refcount = IDirect3DDevice8_Release(device);
    ok(!refcount, "Device has %u references left.\n", refcount);
    IDirect3D8_Release(d3d8);
    DestroyWindow(window);
}

static void test_rtpatch(void)
{
    IDirect3DDevice8 *device;
    IDirect3D8 *d3d8;
    UINT refcount;
    HWND window;
    HRESULT hr;
    IDirect3DVertexBuffer8 *buffer;
    DWORD shader;
    static const unsigned int bufsize = 16;
    struct
    {
        float x, y, z;
    } *data;
    D3DRECTPATCH_INFO patch;
    static const float num_segs[] = {1.0f, 1.0f, 1.0f, 1.0f};
    UINT handle = 0x1234;
    D3DCAPS8 caps;

    /* Position input, this generates tesselated positions, but do not generate normals
     * or texture coordinates. The d3d documentation isn't clear on how to do this */
    static const DWORD decl[] =
    {
        D3DVSD_STREAM(0),
        D3DVSD_REG(D3DVSDE_POSITION, D3DVSDT_FLOAT3),  /* D3DVSDE_POSITION, Register v0 */
        D3DVSD_END()
    };

    if (!(d3d8 = pDirect3DCreate8(D3D_SDK_VERSION)))
    {
        skip("Failed to create d3d8 object, skipping tests.\n");
        return;
    }

    window = CreateWindowA("d3d8_test_wc", "d3d8_test", WS_OVERLAPPEDWINDOW,
            0, 0, 640, 480, 0, 0, 0, 0);
    if (!(device = create_device(d3d8, window, window, TRUE)))
    {
        skip("Failed to create a D3D device, skipping tests.\n");
        IDirect3D8_Release(d3d8);
        DestroyWindow(window);
        return;
    }

    hr = IDirect3DDevice8_GetDeviceCaps(device, &caps);
    ok(SUCCEEDED(hr), "Failed to get caps, hr %#x.\n", hr);
    if (caps.DevCaps & D3DDEVCAPS_RTPATCHES)
    {
        /* The draw methods return the same values, but the patch handle support
         * is different on the refrast, which is the only d3d implementation
         * known to support tri/rect patches */
        skip("Device supports patches, skipping unsupported patch test\n");
        IDirect3DDevice8_Release(device);
        IDirect3D8_Release(d3d8);
        DestroyWindow(window);
        return;
    }

    hr = IDirect3DDevice8_CreateVertexShader(device, decl, NULL, &shader, 0);
    ok(SUCCEEDED(hr), "Failed to create vertex shader, hr %#x.\n", hr);
    hr = IDirect3DDevice8_SetVertexShader(device, shader);
    ok(SUCCEEDED(hr), "Failed to set vertex shader, hr %#x.\n", hr);

    hr = IDirect3DDevice8_CreateVertexBuffer(device, bufsize * sizeof(*data), D3DUSAGE_RTPATCHES, 0,
            D3DPOOL_MANAGED, &buffer);
    ok(SUCCEEDED(hr), "Failed to create buffer, hr %#x.\n", hr);
    hr = IDirect3DVertexBuffer8_Lock(buffer, 0, 0, (BYTE **)&data, 0);
    ok(SUCCEEDED(hr), "Failed to lock buffer, hr %#x.\n", hr);
    memset(data, 0, bufsize * sizeof(*data));
    hr = IDirect3DVertexBuffer8_Unlock(buffer);
    ok(SUCCEEDED(hr), "Failed to unlock buffer, hr %#x.\n", hr);

    hr = IDirect3DDevice8_SetStreamSource(device, 0, buffer, sizeof(*data));
    ok(SUCCEEDED(hr), "Failed to set stream source, hr %#x.\n", hr);
    hr = IDirect3DDevice8_BeginScene(device);
    ok(SUCCEEDED(hr), "Failed to begin scene, hr %#x.\n", hr);

    patch.StartVertexOffsetWidth = 0;
    patch.StartVertexOffsetHeight = 0;
    patch.Width = 4;
    patch.Height = 4;
    patch.Stride = 4;
    patch.Basis = D3DBASIS_BEZIER;
    patch.Order = D3DORDER_CUBIC;
    hr = IDirect3DDevice8_DrawRectPatch(device, handle, num_segs, NULL);
    ok(SUCCEEDED(hr), "Failed to draw rect patch, hr %#x.\n", hr);
    hr = IDirect3DDevice8_DrawRectPatch(device, handle, num_segs, &patch);
    ok(SUCCEEDED(hr), "Failed to draw rect patch, hr %#x.\n", hr);
    hr = IDirect3DDevice8_DrawRectPatch(device, handle, num_segs, NULL);
    ok(SUCCEEDED(hr), "Failed to draw rect patch, hr %#x.\n", hr);
    hr = IDirect3DDevice8_DrawRectPatch(device, 0, num_segs, NULL);
    ok(SUCCEEDED(hr), "Failed to draw rect patch, hr %#x.\n", hr);

    hr = IDirect3DDevice8_EndScene(device);
    ok(SUCCEEDED(hr), "Failed to end scene, hr %#x.\n", hr);

    hr = IDirect3DDevice8_DrawRectPatch(device, 0, num_segs, &patch);
    ok(SUCCEEDED(hr), "Failed to draw rect patch outside scene, hr %#x.\n", hr);

    hr = IDirect3DDevice8_DeletePatch(device, handle);
    ok(hr == D3DERR_INVALIDCALL, "DeletePatch returned hr %#x.\n", hr);
    hr = IDirect3DDevice8_DeletePatch(device, 0);
    ok(hr == D3DERR_INVALIDCALL, "DeletePatch returned hr %#x.\n", hr);
    hr = IDirect3DDevice8_DeletePatch(device, 0x1235);
    ok(hr == D3DERR_INVALIDCALL, "DeletePatch returned hr %#x.\n", hr);

    IDirect3DDevice8_DeleteVertexShader(device, shader);
    IDirect3DVertexBuffer8_Release(buffer);
    refcount = IDirect3DDevice8_Release(device);
    ok(!refcount, "Device has %u references left.\n", refcount);
    IDirect3D8_Release(d3d8);
    DestroyWindow(window);
}

static void test_npot_textures(void)
{
    IDirect3DDevice8 *device = NULL;
    IDirect3D8 *d3d8;
    ULONG refcount;
    HWND window = NULL;
    HRESULT hr;
    D3DCAPS8 caps;
    IDirect3DTexture8 *texture;
    IDirect3DCubeTexture8 *cube_texture;
    IDirect3DVolumeTexture8 *volume_texture;
    struct
    {
        D3DPOOL pool;
        const char *pool_name;
        HRESULT hr;
    }
    pools[] =
    {
        { D3DPOOL_DEFAULT,    "D3DPOOL_DEFAULT",    D3DERR_INVALIDCALL },
        { D3DPOOL_MANAGED,    "D3DPOOL_MANAGED",    D3DERR_INVALIDCALL },
        { D3DPOOL_SYSTEMMEM,  "D3DPOOL_SYSTEMMEM",  D3DERR_INVALIDCALL },
        { D3DPOOL_SCRATCH,    "D3DPOOL_SCRATCH",    D3D_OK             },
    };
    unsigned int i, levels;
    BOOL tex_pow2, cube_pow2, vol_pow2;

    if (!(d3d8 = pDirect3DCreate8(D3D_SDK_VERSION)))
    {
        skip("Failed to create IDirect3D8 object, skipping tests.\n");
        return;
    }

    window = CreateWindowA("static", "d3d8_test", WS_OVERLAPPEDWINDOW,
            0, 0, 640, 480, 0, 0, 0, 0);
    if (!(device = create_device(d3d8, window, window, TRUE)))
    {
        skip("Failed to create a D3D device, skipping tests.\n");
        goto done;
    }

    hr = IDirect3DDevice8_GetDeviceCaps(device, &caps);
    ok(SUCCEEDED(hr), "Failed to get caps, hr %#x.\n", hr);
    tex_pow2 = !!(caps.TextureCaps & D3DPTEXTURECAPS_POW2);
    cube_pow2 = !!(caps.TextureCaps & D3DPTEXTURECAPS_CUBEMAP_POW2);
    vol_pow2 = !!(caps.TextureCaps & D3DPTEXTURECAPS_VOLUMEMAP_POW2);
    ok(cube_pow2 == tex_pow2, "Cube texture and 2d texture pow2 restrictions mismatch.\n");
    ok(vol_pow2 == tex_pow2, "Volume texture and 2d texture pow2 restrictions mismatch.\n");

    for (i = 0; i < sizeof(pools) / sizeof(*pools); i++)
    {
        for (levels = 0; levels <= 2; levels++)
        {
            HRESULT expected;

            hr = IDirect3DDevice8_CreateTexture(device, 10, 10, levels, 0, D3DFMT_X8R8G8B8,
                    pools[i].pool, &texture);
            if (!tex_pow2)
            {
                expected = D3D_OK;
            }
            else if (caps.TextureCaps & D3DPTEXTURECAPS_NONPOW2CONDITIONAL)
            {
                if (levels == 1)
                    expected = D3D_OK;
                else
                    expected = pools[i].hr;
            }
            else
            {
                expected = pools[i].hr;
            }
            ok(hr == expected, "CreateTexture(w=h=10, %s, levels=%u) returned hr %#x, expected %#x.\n",
                    pools[i].pool_name, levels, hr, expected);

            if (SUCCEEDED(hr))
                IDirect3DTexture8_Release(texture);
        }

        hr = IDirect3DDevice8_CreateCubeTexture(device, 3, 1, 0, D3DFMT_X8R8G8B8,
                pools[i].pool, &cube_texture);
        if (tex_pow2)
        {
            ok(hr == pools[i].hr, "CreateCubeTexture(EdgeLength=3, %s) returned hr %#x, expected %#x.\n",
                    pools[i].pool_name, hr, pools[i].hr);
        }
        else
        {
            ok(SUCCEEDED(hr), "CreateCubeTexture(EdgeLength=3, %s) returned hr %#x, expected %#x.\n",
                    pools[i].pool_name, hr, D3D_OK);
        }

        if (SUCCEEDED(hr))
            IDirect3DCubeTexture8_Release(cube_texture);

        hr = IDirect3DDevice8_CreateVolumeTexture(device, 2, 2, 3, 1, 0, D3DFMT_X8R8G8B8,
                pools[i].pool, &volume_texture);
        if (tex_pow2)
        {
            ok(hr == pools[i].hr, "CreateVolumeTextur(Depth=3, %s) returned hr %#x, expected %#x.\n",
                    pools[i].pool_name, hr, pools[i].hr);
        }
        else
        {
            ok(SUCCEEDED(hr), "CreateVolumeTextur(Depth=3, %s) returned hr %#x, expected %#x.\n",
                    pools[i].pool_name, hr, D3D_OK);
        }

        if (SUCCEEDED(hr))
            IDirect3DVolumeTexture8_Release(volume_texture);
    }

done:
    if (device)
    {
        refcount = IDirect3DDevice8_Release(device);
        ok(!refcount, "Device has %u references left.\n", refcount);
    }
    IDirect3D8_Release(d3d8);
    DestroyWindow(window);

}

START_TEST(device)
{
    HMODULE d3d8_handle = LoadLibraryA( "d3d8.dll" );
    WNDCLASS wc = {0};
    if (!d3d8_handle)
    {
        skip("Could not load d3d8.dll\n");
        return;
    }

    wc.lpfnWndProc = DefWindowProc;
    wc.lpszClassName = "d3d8_test_wc";
    RegisterClass(&wc);

    ValidateVertexShader = (void *)GetProcAddress(d3d8_handle, "ValidateVertexShader");
    ValidatePixelShader = (void *)GetProcAddress(d3d8_handle, "ValidatePixelShader");
    pDirect3DCreate8 = (void *)GetProcAddress( d3d8_handle, "Direct3DCreate8" );
    ok(pDirect3DCreate8 != NULL, "Failed to get address of Direct3DCreate8\n");
    if (pDirect3DCreate8)
    {
        IDirect3D8 *d3d8;
        d3d8 = pDirect3DCreate8( D3D_SDK_VERSION );
        if(!d3d8)
        {
            skip("could not create D3D8\n");
            return;
        }
        IDirect3D8_Release(d3d8);

        screen_width = GetSystemMetrics(SM_CXSCREEN);
        screen_height = GetSystemMetrics(SM_CYSCREEN);

        test_fpu_setup();
        test_display_modes();
        test_shader_versions();
        test_swapchain();
        test_refcount();
        test_mipmap_levels();
        test_cursor();
        test_cursor_pos();
        test_states();
        test_reset();
        test_scene();
        test_shader();
        test_limits();
        test_lights();
        test_ApplyStateBlock();
        test_render_zero_triangles();
        test_depth_stencil_reset();
        test_wndproc();
        test_wndproc_windowed();
        test_depth_stencil_size();
        test_window_style();
        test_wrong_shader();
        test_mode_change();
        test_device_window_reset();
        test_reset_resources();
        depth_blit_test();
        test_set_rt_vp_scissor();
        test_validate_vs();
        test_validate_ps();
        test_volume_get_container();
        test_vb_lock_flags();
        test_texture_stage_states();
        test_cube_textures();
        test_image_surface_pool();
        test_surface_get_container();
        test_lockrect_invalid();
        test_private_data();
        test_surface_dimensions();
        test_surface_format_null();
        test_surface_double_unlock();
        test_surface_lockrect_blocks();
        test_set_palette();
        test_swvp_buffer();
        test_rtpatch();
        test_npot_textures();
    }
    UnregisterClassA("d3d8_test_wc", GetModuleHandleA(NULL));
}
