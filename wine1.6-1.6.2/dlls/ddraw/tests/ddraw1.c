/*
 * Copyright 2011-2012 Henri Verbeet for CodeWeavers
 * Copyright 2012-2013 Stefan Dösinger for CodeWeavers
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

#include "wine/test.h"
#include "d3d.h"

struct create_window_thread_param
{
    HWND window;
    HANDLE window_created;
    HANDLE destroy_window;
    HANDLE thread;
};

static BOOL compare_color(D3DCOLOR c1, D3DCOLOR c2, BYTE max_diff)
{
    if (abs((c1 & 0xff) - (c2 & 0xff)) > max_diff) return FALSE;
    c1 >>= 8; c2 >>= 8;
    if (abs((c1 & 0xff) - (c2 & 0xff)) > max_diff) return FALSE;
    c1 >>= 8; c2 >>= 8;
    if (abs((c1 & 0xff) - (c2 & 0xff)) > max_diff) return FALSE;
    c1 >>= 8; c2 >>= 8;
    if (abs((c1 & 0xff) - (c2 & 0xff)) > max_diff) return FALSE;
    return TRUE;
}

static DWORD WINAPI create_window_thread_proc(void *param)
{
    struct create_window_thread_param *p = param;
    DWORD res;
    BOOL ret;

    p->window = CreateWindowA("static", "ddraw_test", WS_OVERLAPPEDWINDOW,
            0, 0, 640, 480, 0, 0, 0, 0);
    ret = SetEvent(p->window_created);
    ok(ret, "SetEvent failed, last error %#x.\n", GetLastError());

    for (;;)
    {
        MSG msg;

        while (PeekMessage(&msg, 0, 0, 0, PM_REMOVE))
            DispatchMessage(&msg);
        res = WaitForSingleObject(p->destroy_window, 100);
        if (res == WAIT_OBJECT_0)
            break;
        if (res != WAIT_TIMEOUT)
        {
            ok(0, "Wait failed (%#x), last error %#x.\n", res, GetLastError());
            break;
        }
    }

    DestroyWindow(p->window);

    return 0;
}

static void create_window_thread(struct create_window_thread_param *p)
{
    DWORD res, tid;

    p->window_created = CreateEvent(NULL, FALSE, FALSE, NULL);
    ok(!!p->window_created, "CreateEvent failed, last error %#x.\n", GetLastError());
    p->destroy_window = CreateEvent(NULL, FALSE, FALSE, NULL);
    ok(!!p->destroy_window, "CreateEvent failed, last error %#x.\n", GetLastError());
    p->thread = CreateThread(NULL, 0, create_window_thread_proc, p, 0, &tid);
    ok(!!p->thread, "Failed to create thread, last error %#x.\n", GetLastError());
    res = WaitForSingleObject(p->window_created, INFINITE);
    ok(res == WAIT_OBJECT_0, "Wait failed (%#x), last error %#x.\n", res, GetLastError());
}

static void destroy_window_thread(struct create_window_thread_param *p)
{
    SetEvent(p->destroy_window);
    WaitForSingleObject(p->thread, INFINITE);
    CloseHandle(p->destroy_window);
    CloseHandle(p->window_created);
    CloseHandle(p->thread);
}

static D3DCOLOR get_surface_color(IDirectDrawSurface *surface, UINT x, UINT y)
{
    RECT rect = {x, y, x + 1, y + 1};
    DDSURFACEDESC surface_desc;
    D3DCOLOR color;
    HRESULT hr;

    memset(&surface_desc, 0, sizeof(surface_desc));
    surface_desc.dwSize = sizeof(surface_desc);

    hr = IDirectDrawSurface_Lock(surface, &rect, &surface_desc, DDLOCK_READONLY | DDLOCK_WAIT, NULL);
    ok(SUCCEEDED(hr), "Failed to lock surface, hr %#x.\n", hr);
    if (FAILED(hr))
        return 0xdeadbeef;

    color = *((DWORD *)surface_desc.lpSurface) & 0x00ffffff;

    hr = IDirectDrawSurface_Unlock(surface, NULL);
    ok(SUCCEEDED(hr), "Failed to unlock surface, hr %#x.\n", hr);

    return color;
}

static void emit_process_vertices(void **ptr, WORD base_idx, DWORD vertex_count)
{
    D3DINSTRUCTION *inst = *ptr;
    D3DPROCESSVERTICES *pv = (D3DPROCESSVERTICES *)(inst + 1);

    inst->bOpcode = D3DOP_PROCESSVERTICES;
    inst->bSize = sizeof(*pv);
    inst->wCount = 1;

    pv->dwFlags = D3DPROCESSVERTICES_COPY;
    pv->wStart = base_idx;
    pv->wDest = 0;
    pv->dwCount = vertex_count;
    pv->dwReserved = 0;

    *ptr = pv + 1;
}

static void emit_set_rs(void **ptr, D3DRENDERSTATETYPE state, DWORD value)
{
    D3DINSTRUCTION *inst = *ptr;
    D3DSTATE *rs = (D3DSTATE *)(inst + 1);

    inst->bOpcode = D3DOP_STATERENDER;
    inst->bSize = sizeof(*rs);
    inst->wCount = 1;

    U1(*rs).drstRenderStateType = state;
    U2(*rs).dwArg[0] = value;

    *ptr = rs + 1;
}

static void emit_tquad(void **ptr, WORD base_idx)
{
    D3DINSTRUCTION *inst = *ptr;
    D3DTRIANGLE *tri = (D3DTRIANGLE *)(inst + 1);

    inst->bOpcode = D3DOP_TRIANGLE;
    inst->bSize = sizeof(*tri);
    inst->wCount = 2;

    U1(*tri).v1 = base_idx;
    U2(*tri).v2 = base_idx + 1;
    U3(*tri).v3 = base_idx + 2;
    tri->wFlags = D3DTRIFLAG_START;
    ++tri;

    U1(*tri).v1 = base_idx + 2;
    U2(*tri).v2 = base_idx + 1;
    U3(*tri).v3 = base_idx + 3;
    tri->wFlags = D3DTRIFLAG_ODD;
    ++tri;

    *ptr = tri;
}

static void emit_end(void **ptr)
{
    D3DINSTRUCTION *inst = *ptr;

    inst->bOpcode = D3DOP_EXIT;
    inst->bSize = 0;
    inst->wCount = 0;

    *ptr = inst + 1;
}

static void set_execute_data(IDirect3DExecuteBuffer *execute_buffer, UINT vertex_count, UINT offset, UINT len)
{
    D3DEXECUTEDATA exec_data;
    HRESULT hr;

    memset(&exec_data, 0, sizeof(exec_data));
    exec_data.dwSize = sizeof(exec_data);
    exec_data.dwVertexCount = vertex_count;
    exec_data.dwInstructionOffset = offset;
    exec_data.dwInstructionLength = len;
    hr = IDirect3DExecuteBuffer_SetExecuteData(execute_buffer, &exec_data);
    ok(SUCCEEDED(hr), "Failed to set execute data, hr %#x.\n", hr);
}

static HRESULT CALLBACK enum_z_fmt(GUID *guid, char *description, char *name,
        D3DDEVICEDESC *hal_desc, D3DDEVICEDESC *hel_desc, void *ctx)
{
    DWORD *z_depth = ctx;

    if (!IsEqualGUID(&IID_IDirect3DHALDevice, guid))
        return D3DENUMRET_OK;

    if (hal_desc->dwDeviceZBufferBitDepth & DDBD_32)
        *z_depth = 32;
    else if (hal_desc->dwDeviceZBufferBitDepth & DDBD_24)
        *z_depth = 24;
    else if (hal_desc->dwDeviceZBufferBitDepth & DDBD_16)
        *z_depth = 16;

    return DDENUMRET_OK;
}

static IDirectDraw *create_ddraw(void)
{
    IDirectDraw *ddraw;

    if (FAILED(DirectDrawCreate(NULL, &ddraw, NULL)))
        return NULL;

    return ddraw;
}

static IDirect3DDevice *create_device(IDirectDraw *ddraw, HWND window, DWORD coop_level)
{
    IDirectDrawSurface *surface, *ds;
    IDirect3DDevice *device = NULL;
    DDSURFACEDESC surface_desc;
    DWORD z_depth = 0;
    IDirect3D *d3d;
    HRESULT hr;

    hr = IDirectDraw_SetCooperativeLevel(ddraw, window, coop_level);
    ok(SUCCEEDED(hr), "Failed to set cooperative level, hr %#x.\n", hr);

    memset(&surface_desc, 0, sizeof(surface_desc));
    surface_desc.dwSize = sizeof(surface_desc);
    surface_desc.dwFlags = DDSD_CAPS | DDSD_WIDTH | DDSD_HEIGHT;
    surface_desc.ddsCaps.dwCaps = DDSCAPS_OFFSCREENPLAIN | DDSCAPS_3DDEVICE;
    surface_desc.dwWidth = 640;
    surface_desc.dwHeight = 480;

    hr = IDirectDraw_CreateSurface(ddraw, &surface_desc, &surface, NULL);
    ok(SUCCEEDED(hr), "Failed to create surface, hr %#x.\n", hr);

    if (coop_level & DDSCL_NORMAL)
    {
        IDirectDrawClipper *clipper;

        hr = IDirectDraw_CreateClipper(ddraw, 0, &clipper, NULL);
        ok(SUCCEEDED(hr), "Failed to create clipper, hr %#x.\n", hr);
        hr = IDirectDrawClipper_SetHWnd(clipper, 0, window);
        ok(SUCCEEDED(hr), "Failed to set clipper window, hr %#x.\n", hr);
        hr = IDirectDrawSurface_SetClipper(surface, clipper);
        ok(SUCCEEDED(hr), "Failed to set surface clipper, hr %#x.\n", hr);
        IDirectDrawClipper_Release(clipper);
    }

    hr = IDirectDraw_QueryInterface(ddraw, &IID_IDirect3D, (void **)&d3d);
    if (FAILED(hr))
    {
        IDirectDrawSurface_Release(surface);
        return NULL;
    }

    hr = IDirect3D_EnumDevices(d3d, enum_z_fmt, &z_depth);
    ok(SUCCEEDED(hr), "Failed to enumerate z-formats, hr %#x.\n", hr);
    IDirect3D_Release(d3d);
    if (FAILED(hr) || !z_depth)
    {
        IDirectDrawSurface_Release(surface);
        return NULL;
    }

    memset(&surface_desc, 0, sizeof(surface_desc));
    surface_desc.dwSize = sizeof(surface_desc);
    surface_desc.dwFlags = DDSD_CAPS | DDSD_ZBUFFERBITDEPTH | DDSD_WIDTH | DDSD_HEIGHT;
    surface_desc.ddsCaps.dwCaps = DDSCAPS_ZBUFFER;
    U2(surface_desc).dwZBufferBitDepth = z_depth;
    surface_desc.dwWidth = 640;
    surface_desc.dwHeight = 480;
    hr = IDirectDraw_CreateSurface(ddraw, &surface_desc, &ds, NULL);
    ok(SUCCEEDED(hr), "Failed to create depth buffer, hr %#x.\n", hr);
    if (FAILED(hr))
    {
        IDirectDrawSurface_Release(surface);
        return NULL;
    }

    hr = IDirectDrawSurface_AddAttachedSurface(surface, ds);
    ok(SUCCEEDED(hr), "Failed to attach depth buffer, hr %#x.\n", hr);
    IDirectDrawSurface_Release(ds);
    if (FAILED(hr))
    {
        IDirectDrawSurface_Release(surface);
        return NULL;
    }

    hr = IDirectDrawSurface_QueryInterface(surface, &IID_IDirect3DHALDevice, (void **)&device);
    IDirectDrawSurface_Release(surface);
    if (FAILED(hr))
        return NULL;

    return device;
}

static IDirect3DViewport *create_viewport(IDirect3DDevice *device, UINT x, UINT y, UINT w, UINT h)
{
    IDirect3DViewport *viewport;
    D3DVIEWPORT vp;
    IDirect3D *d3d;
    HRESULT hr;

    hr = IDirect3DDevice_GetDirect3D(device, &d3d);
    ok(SUCCEEDED(hr), "Failed to get d3d interface, hr %#x.\n", hr);
    hr = IDirect3D_CreateViewport(d3d, &viewport, NULL);
    ok(SUCCEEDED(hr), "Failed to create viewport, hr %#x.\n", hr);
    hr = IDirect3DDevice_AddViewport(device, viewport);
    ok(SUCCEEDED(hr), "Failed to add viewport, hr %#x.\n", hr);
    memset(&vp, 0, sizeof(vp));
    vp.dwSize = sizeof(vp);
    vp.dwX = x;
    vp.dwY = y;
    vp.dwWidth = w;
    vp.dwHeight = h;
    vp.dvScaleX = (float)w / 2.0f;
    vp.dvScaleY = (float)h / 2.0f;
    vp.dvMaxX = 1.0f;
    vp.dvMaxY = 1.0f;
    vp.dvMinZ = 0.0f;
    vp.dvMaxZ = 1.0f;
    hr = IDirect3DViewport_SetViewport(viewport, &vp);
    ok(SUCCEEDED(hr), "Failed to set viewport data, hr %#x.\n", hr);
    IDirect3D_Release(d3d);

    return viewport;
}

static void viewport_set_background(IDirect3DDevice *device, IDirect3DViewport *viewport,
        IDirect3DMaterial *material)
{
    D3DMATERIALHANDLE material_handle;
    HRESULT hr;

    hr = IDirect3DMaterial2_GetHandle(material, device, &material_handle);
    ok(SUCCEEDED(hr), "Failed to get material handle, hr %#x.\n", hr);
    hr = IDirect3DViewport2_SetBackground(viewport, material_handle);
    ok(SUCCEEDED(hr), "Failed to set viewport background, hr %#x.\n", hr);
}

static void destroy_viewport(IDirect3DDevice *device, IDirect3DViewport *viewport)
{
    HRESULT hr;

    hr = IDirect3DDevice_DeleteViewport(device, viewport);
    ok(SUCCEEDED(hr), "Failed to delete viewport, hr %#x.\n", hr);
    IDirect3DViewport_Release(viewport);
}

static IDirect3DMaterial *create_diffuse_material(IDirect3DDevice *device, float r, float g, float b, float a)
{
    IDirect3DMaterial *material;
    D3DMATERIAL mat;
    IDirect3D *d3d;
    HRESULT hr;

    hr = IDirect3DDevice_GetDirect3D(device, &d3d);
    ok(SUCCEEDED(hr), "Failed to get d3d interface, hr %#x.\n", hr);
    hr = IDirect3D_CreateMaterial(d3d, &material, NULL);
    ok(SUCCEEDED(hr), "Failed to create material, hr %#x.\n", hr);
    memset(&mat, 0, sizeof(mat));
    mat.dwSize = sizeof(mat);
    U1(U(mat).diffuse).r = r;
    U2(U(mat).diffuse).g = g;
    U3(U(mat).diffuse).b = b;
    U4(U(mat).diffuse).a = a;
    hr = IDirect3DMaterial_SetMaterial(material, &mat);
    ok(SUCCEEDED(hr), "Failed to set material data, hr %#x.\n", hr);
    IDirect3D_Release(d3d);

    return material;
}

static void destroy_material(IDirect3DMaterial *material)
{
    IDirect3DMaterial_Release(material);
}

static const UINT *expect_messages;

static LRESULT CALLBACK test_proc(HWND hwnd, UINT message, WPARAM wparam, LPARAM lparam)
{
    if (expect_messages && message == *expect_messages)
        ++expect_messages;

    return DefWindowProcA(hwnd, message, wparam, lparam);
}

/* Set the wndproc back to what ddraw expects it to be, and release the ddraw
 * interface. This prevents subsequent SetCooperativeLevel() calls on a
 * different window from failing with DDERR_HWNDALREADYSET. */
static void fix_wndproc(HWND window, LONG_PTR proc)
{
    IDirectDraw *ddraw;
    HRESULT hr;

    if (!(ddraw = create_ddraw()))
        return;

    SetWindowLongPtrA(window, GWLP_WNDPROC, proc);
    hr = IDirectDraw_SetCooperativeLevel(ddraw, window, DDSCL_EXCLUSIVE | DDSCL_FULLSCREEN);
    ok(SUCCEEDED(hr), "SetCooperativeLevel failed, hr %#x.\n", hr);
    hr = IDirectDraw_SetCooperativeLevel(ddraw, window, DDSCL_NORMAL);
    ok(SUCCEEDED(hr), "SetCooperativeLevel failed, hr %#x.\n", hr);

    IDirectDraw_Release(ddraw);
}

static HRESULT CALLBACK restore_callback(IDirectDrawSurface *surface, DDSURFACEDESC *desc, void *context)
{
    HRESULT hr = IDirectDrawSurface_Restore(surface);
    ok(SUCCEEDED(hr), "Failed to restore surface, hr %#x.\n", hr);
    IDirectDrawSurface_Release(surface);

    return DDENUMRET_OK;
}

static HRESULT restore_surfaces(IDirectDraw *ddraw)
{
    return IDirectDraw_EnumSurfaces(ddraw, DDENUMSURFACES_ALL | DDENUMSURFACES_DOESEXIST,
            NULL, NULL, restore_callback);
}

static void test_coop_level_create_device_window(void)
{
    HWND focus_window, device_window;
    IDirectDraw *ddraw;
    HRESULT hr;

    focus_window = CreateWindowA("static", "ddraw_test", WS_OVERLAPPEDWINDOW,
            0, 0, 640, 480, 0, 0, 0, 0);
    if (!(ddraw = create_ddraw()))
    {
        skip("Failed to create a ddraw object, skipping test.\n");
        DestroyWindow(focus_window);
        return;
    }

    hr = IDirectDraw_SetCooperativeLevel(ddraw, NULL, DDSCL_NORMAL);
    ok(hr == DD_OK, "Got unexpected hr %#x.\n", hr);
    device_window = FindWindowA("DirectDrawDeviceWnd", "DirectDrawDeviceWnd");
    ok(!device_window, "Unexpected device window found.\n");
    hr = IDirectDraw_SetCooperativeLevel(ddraw, NULL, DDSCL_CREATEDEVICEWINDOW);
    ok(hr == DDERR_INVALIDPARAMS, "Got unexpected hr %#x.\n", hr);
    device_window = FindWindowA("DirectDrawDeviceWnd", "DirectDrawDeviceWnd");
    ok(!device_window, "Unexpected device window found.\n");
    hr = IDirectDraw_SetCooperativeLevel(ddraw, NULL, DDSCL_CREATEDEVICEWINDOW | DDSCL_NORMAL);
    ok(hr == DDERR_INVALIDPARAMS, "Got unexpected hr %#x.\n", hr);
    device_window = FindWindowA("DirectDrawDeviceWnd", "DirectDrawDeviceWnd");
    ok(!device_window, "Unexpected device window found.\n");
    hr = IDirectDraw_SetCooperativeLevel(ddraw, NULL, DDSCL_CREATEDEVICEWINDOW | DDSCL_NORMAL | DDSCL_FULLSCREEN);
    ok(hr == DDERR_INVALIDPARAMS, "Got unexpected hr %#x.\n", hr);
    device_window = FindWindowA("DirectDrawDeviceWnd", "DirectDrawDeviceWnd");
    ok(!device_window, "Unexpected device window found.\n");
    hr = IDirectDraw_SetCooperativeLevel(ddraw, NULL, DDSCL_CREATEDEVICEWINDOW | DDSCL_EXCLUSIVE | DDSCL_FULLSCREEN);
    ok(hr == DDERR_NOFOCUSWINDOW || broken(hr == DDERR_INVALIDPARAMS), "Got unexpected hr %#x.\n", hr);
    device_window = FindWindowA("DirectDrawDeviceWnd", "DirectDrawDeviceWnd");
    ok(!device_window, "Unexpected device window found.\n");

    /* Windows versions before 98 / NT5 don't support DDSCL_CREATEDEVICEWINDOW. */
    if (broken(hr == DDERR_INVALIDPARAMS))
    {
        win_skip("DDSCL_CREATEDEVICEWINDOW not supported, skipping test.\n");
        IDirectDraw_Release(ddraw);
        DestroyWindow(focus_window);
        return;
    }

    hr = IDirectDraw_SetCooperativeLevel(ddraw, NULL, DDSCL_NORMAL);
    ok(hr == DD_OK, "Got unexpected hr %#x.\n", hr);
    device_window = FindWindowA("DirectDrawDeviceWnd", "DirectDrawDeviceWnd");
    ok(!device_window, "Unexpected device window found.\n");
    hr = IDirectDraw_SetCooperativeLevel(ddraw, focus_window, DDSCL_EXCLUSIVE | DDSCL_FULLSCREEN);
    ok(hr == DD_OK, "Got unexpected hr %#x.\n", hr);
    device_window = FindWindowA("DirectDrawDeviceWnd", "DirectDrawDeviceWnd");
    ok(!device_window, "Unexpected device window found.\n");

    hr = IDirectDraw_SetCooperativeLevel(ddraw, NULL, DDSCL_NORMAL);
    ok(hr == DD_OK, "Got unexpected hr %#x.\n", hr);
    device_window = FindWindowA("DirectDrawDeviceWnd", "DirectDrawDeviceWnd");
    ok(!device_window, "Unexpected device window found.\n");
    hr = IDirectDraw_SetCooperativeLevel(ddraw, NULL, DDSCL_SETFOCUSWINDOW
            | DDSCL_CREATEDEVICEWINDOW | DDSCL_EXCLUSIVE | DDSCL_FULLSCREEN);
    ok(hr == DDERR_NOHWND, "Got unexpected hr %#x.\n", hr);
    device_window = FindWindowA("DirectDrawDeviceWnd", "DirectDrawDeviceWnd");
    ok(!!device_window, "Device window not found.\n");

    hr = IDirectDraw_SetCooperativeLevel(ddraw, NULL, DDSCL_NORMAL);
    ok(hr == DD_OK, "Got unexpected hr %#x.\n", hr);
    device_window = FindWindowA("DirectDrawDeviceWnd", "DirectDrawDeviceWnd");
    ok(!device_window, "Unexpected device window found.\n");
    hr = IDirectDraw_SetCooperativeLevel(ddraw, focus_window, DDSCL_SETFOCUSWINDOW
            | DDSCL_CREATEDEVICEWINDOW | DDSCL_EXCLUSIVE | DDSCL_FULLSCREEN);
    ok(hr == DD_OK, "Got unexpected hr %#x.\n", hr);
    device_window = FindWindowA("DirectDrawDeviceWnd", "DirectDrawDeviceWnd");
    ok(!!device_window, "Device window not found.\n");

    hr = IDirectDraw_SetCooperativeLevel(ddraw, NULL, DDSCL_NORMAL);
    ok(hr == DD_OK, "Got unexpected hr %#x.\n", hr);
    device_window = FindWindowA("DirectDrawDeviceWnd", "DirectDrawDeviceWnd");
    ok(!device_window, "Unexpected device window found.\n");
    hr = IDirectDraw_SetCooperativeLevel(ddraw, NULL, DDSCL_CREATEDEVICEWINDOW | DDSCL_EXCLUSIVE | DDSCL_FULLSCREEN);
    ok(hr == DDERR_NOFOCUSWINDOW, "Got unexpected hr %#x.\n", hr);
    device_window = FindWindowA("DirectDrawDeviceWnd", "DirectDrawDeviceWnd");
    ok(!device_window, "Unexpected device window found.\n");
    hr = IDirectDraw_SetCooperativeLevel(ddraw, focus_window, DDSCL_SETFOCUSWINDOW);
    ok(hr == DD_OK, "Got unexpected hr %#x.\n", hr);
    device_window = FindWindowA("DirectDrawDeviceWnd", "DirectDrawDeviceWnd");
    ok(!device_window, "Unexpected device window found.\n");
    hr = IDirectDraw_SetCooperativeLevel(ddraw, NULL, DDSCL_CREATEDEVICEWINDOW | DDSCL_EXCLUSIVE | DDSCL_FULLSCREEN);
    ok(hr == DD_OK, "Got unexpected hr %#x.\n", hr);
    device_window = FindWindowA("DirectDrawDeviceWnd", "DirectDrawDeviceWnd");
    ok(!!device_window, "Device window not found.\n");

    IDirectDraw_Release(ddraw);
    DestroyWindow(focus_window);
}

static void test_clipper_blt(void)
{
    IDirectDrawSurface *src_surface, *dst_surface;
    RECT client_rect, src_rect;
    IDirectDrawClipper *clipper;
    DDSURFACEDESC surface_desc;
    unsigned int i, j, x, y;
    IDirectDraw *ddraw;
    RGNDATA *rgn_data;
    D3DCOLOR color;
    HRGN r1, r2;
    HWND window;
    DDBLTFX fx;
    HRESULT hr;
    DWORD *ptr;
    DWORD ret;

    static const DWORD src_data[] =
    {
        0xff0000ff, 0xff0000ff, 0xff00ff00, 0xffff0000, 0xffffffff, 0xffffffff,
        0xff0000ff, 0xff0000ff, 0xff00ff00, 0xffff0000, 0xffffffff, 0xffffffff,
        0xff0000ff, 0xff0000ff, 0xff00ff00, 0xffff0000, 0xffffffff, 0xffffffff,
    };
    static const D3DCOLOR expected1[] =
    {
        0x000000ff, 0x0000ff00, 0x00000000, 0x00000000,
        0x000000ff, 0x0000ff00, 0x00000000, 0x00000000,
        0x00000000, 0x00000000, 0x00ff0000, 0x00ffffff,
        0x00000000, 0x00000000, 0x00ff0000, 0x00ffffff,
    };
    static const D3DCOLOR expected2[] =
    {
        0x000000ff, 0x000000ff, 0x00000000, 0x00000000,
        0x000000ff, 0x000000ff, 0x00000000, 0x00000000,
        0x00000000, 0x00000000, 0x000000ff, 0x000000ff,
        0x00000000, 0x00000000, 0x000000ff, 0x000000ff,
    };

    window = CreateWindowA("static", "ddraw_test", WS_OVERLAPPEDWINDOW,
            10, 10, 640, 480, 0, 0, 0, 0);
    ShowWindow(window, SW_SHOW);
    if (!(ddraw = create_ddraw()))
    {
        skip("Failed to create a ddraw object, skipping test.\n");
        DestroyWindow(window);
        return;
    }

    ret = GetClientRect(window, &client_rect);
    ok(ret, "Failed to get client rect.\n");
    ret = MapWindowPoints(window, NULL, (POINT *)&client_rect, 2);
    ok(ret, "Failed to map client rect.\n");

    hr = IDirectDraw_SetCooperativeLevel(ddraw, window, DDSCL_NORMAL);
    ok(SUCCEEDED(hr), "Failed to set cooperative level, hr %#x.\n", hr);

    hr = IDirectDraw_CreateClipper(ddraw, 0, &clipper, NULL);
    ok(SUCCEEDED(hr), "Failed to create clipper, hr %#x.\n", hr);
    hr = IDirectDrawClipper_GetClipList(clipper, NULL, NULL, &ret);
    ok(hr == DDERR_NOCLIPLIST, "Got unexpected hr %#x.\n", hr);
    hr = IDirectDrawClipper_SetHWnd(clipper, 0, window);
    ok(SUCCEEDED(hr), "Failed to set clipper window, hr %#x.\n", hr);
    hr = IDirectDrawClipper_GetClipList(clipper, NULL, NULL, &ret);
    ok(SUCCEEDED(hr), "Failed to get clip list size, hr %#x.\n", hr);
    rgn_data = HeapAlloc(GetProcessHeap(), 0, ret);
    hr = IDirectDrawClipper_GetClipList(clipper, NULL, rgn_data, &ret);
    ok(SUCCEEDED(hr), "Failed to get clip list, hr %#x.\n", hr);
    ok(rgn_data->rdh.dwSize == sizeof(rgn_data->rdh), "Got unexpected structure size %#x.\n", rgn_data->rdh.dwSize);
    ok(rgn_data->rdh.iType == RDH_RECTANGLES, "Got unexpected type %#x.\n", rgn_data->rdh.iType);
    ok(rgn_data->rdh.nCount >= 1, "Got unexpected count %u.\n", rgn_data->rdh.nCount);
    ok(EqualRect(&rgn_data->rdh.rcBound, &client_rect),
            "Got unexpected bounding rect {%d, %d, %d, %d}, expected {%d, %d, %d, %d}.\n",
            rgn_data->rdh.rcBound.left, rgn_data->rdh.rcBound.top,
            rgn_data->rdh.rcBound.right, rgn_data->rdh.rcBound.bottom,
            client_rect.left, client_rect.top, client_rect.right, client_rect.bottom);
    HeapFree(GetProcessHeap(), 0, rgn_data);

    r1 = CreateRectRgn(0, 0, 320, 240);
    ok(!!r1, "Failed to create region.\n");
    r2 = CreateRectRgn(320, 240, 640, 480);
    ok(!!r2, "Failed to create region.\n");
    CombineRgn(r1, r1, r2, RGN_OR);
    ret = GetRegionData(r1, 0, NULL);
    rgn_data = HeapAlloc(GetProcessHeap(), 0, ret);
    ret = GetRegionData(r1, ret, rgn_data);
    ok(!!ret, "Failed to get region data.\n");

    DeleteObject(r2);
    DeleteObject(r1);

    hr = IDirectDrawClipper_SetClipList(clipper, rgn_data, 0);
    ok(hr == DDERR_CLIPPERISUSINGHWND, "Got unexpected hr %#x.\n", hr);
    hr = IDirectDrawClipper_SetHWnd(clipper, 0, NULL);
    ok(SUCCEEDED(hr), "Failed to set clipper window, hr %#x.\n", hr);
    hr = IDirectDrawClipper_SetClipList(clipper, rgn_data, 0);
    ok(SUCCEEDED(hr), "Failed to set clip list, hr %#x.\n", hr);

    HeapFree(GetProcessHeap(), 0, rgn_data);

    memset(&surface_desc, 0, sizeof(surface_desc));
    surface_desc.dwSize = sizeof(surface_desc);
    surface_desc.dwFlags = DDSD_CAPS | DDSD_WIDTH | DDSD_HEIGHT | DDSD_PIXELFORMAT;
    surface_desc.ddsCaps.dwCaps = DDSCAPS_OFFSCREENPLAIN;
    surface_desc.dwWidth = 640;
    surface_desc.dwHeight = 480;
    surface_desc.ddpfPixelFormat.dwSize = sizeof(surface_desc.ddpfPixelFormat);
    surface_desc.ddpfPixelFormat.dwFlags = DDPF_RGB;
    U1(surface_desc.ddpfPixelFormat).dwRGBBitCount = 32;
    U2(surface_desc.ddpfPixelFormat).dwRBitMask = 0x00ff0000;
    U3(surface_desc.ddpfPixelFormat).dwGBitMask = 0x0000ff00;
    U4(surface_desc.ddpfPixelFormat).dwBBitMask = 0x000000ff;

    hr = IDirectDraw_CreateSurface(ddraw, &surface_desc, &src_surface, NULL);
    ok(SUCCEEDED(hr), "Failed to create source surface, hr %#x.\n", hr);
    hr = IDirectDraw_CreateSurface(ddraw, &surface_desc, &dst_surface, NULL);
    ok(SUCCEEDED(hr), "Failed to create destination surface, hr %#x.\n", hr);

    memset(&fx, 0, sizeof(fx));
    fx.dwSize = sizeof(fx);
    hr = IDirectDrawSurface_Blt(src_surface, NULL, NULL, NULL, DDBLT_COLORFILL | DDBLT_WAIT, &fx);
    ok(SUCCEEDED(hr), "Failed to clear source surface, hr %#x.\n", hr);
    hr = IDirectDrawSurface_Blt(dst_surface, NULL, NULL, NULL, DDBLT_COLORFILL | DDBLT_WAIT, &fx);
    ok(SUCCEEDED(hr), "Failed to clear destination surface, hr %#x.\n", hr);

    hr = IDirectDrawSurface_Lock(src_surface, NULL, &surface_desc, DDLOCK_WAIT, NULL);
    ok(SUCCEEDED(hr), "Failed to lock source surface, hr %#x.\n", hr);
    ok(U1(surface_desc).lPitch == 2560, "Got unexpected surface pitch %u.\n", U1(surface_desc).lPitch);
    ptr = surface_desc.lpSurface;
    memcpy(&ptr[   0], &src_data[ 0], 6 * sizeof(DWORD));
    memcpy(&ptr[ 640], &src_data[ 6], 6 * sizeof(DWORD));
    memcpy(&ptr[1280], &src_data[12], 6 * sizeof(DWORD));
    hr = IDirectDrawSurface_Unlock(src_surface, NULL);
    ok(SUCCEEDED(hr), "Failed to unlock source surface, hr %#x.\n", hr);

    hr = IDirectDrawSurface_SetClipper(dst_surface, clipper);
    ok(SUCCEEDED(hr), "Failed to set clipper, hr %#x.\n", hr);

    SetRect(&src_rect, 1, 1, 5, 2);
    hr = IDirectDrawSurface_Blt(dst_surface, NULL, src_surface, &src_rect, DDBLT_WAIT, NULL);
    ok(SUCCEEDED(hr), "Failed to blit, hr %#x.\n", hr);
    for (i = 0; i < 4; ++i)
    {
        for (j = 0; j < 4; ++j)
        {
            x = 80 * ((2 * j) + 1);
            y = 60 * ((2 * i) + 1);
            color = get_surface_color(dst_surface, x, y);
            ok(compare_color(color, expected1[i * 4 + j], 1),
                    "Expected color 0x%08x at %u,%u, got 0x%08x.\n", expected1[i * 4 + j], x, y, color);
        }
    }

    U5(fx).dwFillColor = 0xff0000ff;
    hr = IDirectDrawSurface_Blt(dst_surface, NULL, NULL, NULL, DDBLT_COLORFILL | DDBLT_WAIT, &fx);
    ok(SUCCEEDED(hr), "Failed to clear destination surface, hr %#x.\n", hr);
    for (i = 0; i < 4; ++i)
    {
        for (j = 0; j < 4; ++j)
        {
            x = 80 * ((2 * j) + 1);
            y = 60 * ((2 * i) + 1);
            color = get_surface_color(dst_surface, x, y);
            ok(compare_color(color, expected2[i * 4 + j], 1),
                    "Expected color 0x%08x at %u,%u, got 0x%08x.\n", expected2[i * 4 + j], x, y, color);
        }
    }

    hr = IDirectDrawSurface_BltFast(dst_surface, 0, 0, src_surface, NULL, DDBLTFAST_WAIT);
    ok(hr == DDERR_BLTFASTCANTCLIP || broken(hr == E_NOTIMPL /* NT4 */), "Got unexpected hr %#x.\n", hr);

    hr = IDirectDrawClipper_SetHWnd(clipper, 0, window);
    ok(SUCCEEDED(hr), "Failed to set clipper window, hr %#x.\n", hr);
    hr = IDirectDrawClipper_GetClipList(clipper, NULL, NULL, &ret);
    ok(SUCCEEDED(hr), "Failed to get clip list size, hr %#x.\n", hr);
    DestroyWindow(window);
    hr = IDirectDrawClipper_GetClipList(clipper, NULL, NULL, &ret);
    ok(hr == E_FAIL, "Got unexpected hr %#x.\n", hr);
    hr = IDirectDrawClipper_SetHWnd(clipper, 0, NULL);
    ok(SUCCEEDED(hr), "Failed to set clipper window, hr %#x.\n", hr);
    hr = IDirectDrawClipper_GetClipList(clipper, NULL, NULL, &ret);
    ok(SUCCEEDED(hr), "Failed to get clip list size, hr %#x.\n", hr);
    hr = IDirectDrawClipper_SetClipList(clipper, NULL, 0);
    ok(SUCCEEDED(hr), "Failed to set clip list, hr %#x.\n", hr);
    hr = IDirectDrawClipper_GetClipList(clipper, NULL, NULL, &ret);
    ok(hr == DDERR_NOCLIPLIST, "Got unexpected hr %#x.\n", hr);
    hr = IDirectDrawSurface_Blt(dst_surface, NULL, NULL, NULL, DDBLT_COLORFILL | DDBLT_WAIT, &fx);
    ok(hr == DDERR_NOCLIPLIST, "Got unexpected hr %#x.\n", hr);

    IDirectDrawSurface_Release(dst_surface);
    IDirectDrawSurface_Release(src_surface);
    IDirectDrawClipper_Release(clipper);
    IDirectDraw_Release(ddraw);
}

static void test_coop_level_d3d_state(void)
{
    D3DRECT clear_rect = {{0}, {0}, {640}, {480}};
    IDirectDrawSurface *rt, *surface;
    IDirect3DMaterial *background;
    IDirect3DViewport *viewport;
    IDirect3DDevice *device;
    D3DMATERIAL material;
    IDirectDraw *ddraw;
    D3DCOLOR color;
    HWND window;
    HRESULT hr;

    window = CreateWindowA("static", "ddraw_test", WS_OVERLAPPEDWINDOW,
            0, 0, 640, 480, 0, 0, 0, 0);
    if (!(ddraw = create_ddraw()))
    {
        skip("Failed to create ddraw object, skipping test.\n");
        DestroyWindow(window);
        return;
    }
    if (!(device = create_device(ddraw, window, DDSCL_NORMAL)))
    {
        skip("Failed to create D3D device, skipping test.\n");
        IDirectDraw_Release(ddraw);
        DestroyWindow(window);
        return;
    }

    background = create_diffuse_material(device, 1.0f, 0.0f, 0.0f, 1.0f);
    viewport = create_viewport(device, 0, 0, 640, 480);
    viewport_set_background(device, viewport, background);

    hr = IDirect3DDevice_QueryInterface(device, &IID_IDirectDrawSurface, (void **)&rt);
    ok(SUCCEEDED(hr), "Failed to get render target, hr %#x.\n", hr);
    hr = IDirect3DViewport_Clear(viewport, 1, &clear_rect, D3DCLEAR_TARGET);
    ok(SUCCEEDED(hr), "Failed to clear viewport, hr %#x.\n", hr);
    color = get_surface_color(rt, 320, 240);
    ok(compare_color(color, 0x00ff0000, 1), "Got unexpected color 0x%08x.\n", color);

    hr = IDirectDraw_SetCooperativeLevel(ddraw, window, DDSCL_EXCLUSIVE | DDSCL_FULLSCREEN);
    ok(SUCCEEDED(hr), "Failed to set cooperative level, hr %#x.\n", hr);
    hr = IDirectDrawSurface_IsLost(rt);
    ok(hr == DDERR_SURFACELOST, "Got unexpected hr %#x.\n", hr);
    hr = restore_surfaces(ddraw);
    ok(SUCCEEDED(hr), "Failed to restore surfaces, hr %#x.\n", hr);

    memset(&material, 0, sizeof(material));
    material.dwSize = sizeof(material);
    U1(U(material).diffuse).r = 0.0f;
    U2(U(material).diffuse).g = 1.0f;
    U3(U(material).diffuse).b = 0.0f;
    U4(U(material).diffuse).a = 1.0f;
    hr = IDirect3DMaterial_SetMaterial(background, &material);
    ok(SUCCEEDED(hr), "Failed to set material data, hr %#x.\n", hr);

    hr = IDirect3DDevice_QueryInterface(device, &IID_IDirectDrawSurface, (void **)&surface);
    ok(SUCCEEDED(hr), "Failed to get render target, hr %#x.\n", hr);
    ok(surface == rt, "Got unexpected surface %p.\n", surface);
    hr = IDirect3DViewport_Clear(viewport, 1, &clear_rect, D3DCLEAR_TARGET);
    ok(SUCCEEDED(hr), "Failed to clear viewport, hr %#x.\n", hr);
    color = get_surface_color(rt, 320, 240);
    ok(compare_color(color, 0x0000ff00, 1), "Got unexpected color 0x%08x.\n", color);

    destroy_viewport(device, viewport);
    destroy_material(background);
    IDirectDrawSurface_Release(surface);
    IDirectDrawSurface_Release(rt);
    IDirect3DDevice_Release(device);
    IDirectDraw_Release(ddraw);
    DestroyWindow(window);
}

static void test_surface_interface_mismatch(void)
{
    IDirectDraw *ddraw = NULL;
    IDirect3D *d3d = NULL;
    IDirectDrawSurface *surface = NULL, *ds;
    IDirectDrawSurface3 *surface3 = NULL;
    IDirect3DDevice *device = NULL;
    IDirect3DViewport *viewport = NULL;
    IDirect3DMaterial *background = NULL;
    DDSURFACEDESC surface_desc;
    DWORD z_depth = 0;
    ULONG refcount;
    HRESULT hr;
    D3DCOLOR color;
    HWND window;
    D3DRECT clear_rect = {{0}, {0}, {640}, {480}};

    window = CreateWindowA("static", "ddraw_test", WS_OVERLAPPEDWINDOW,
            0, 0, 640, 480, 0, 0, 0, 0);

    if (!(ddraw = create_ddraw()))
    {
        skip("Failed to create a ddraw object, skipping test.\n");
        goto cleanup;
    }

    hr = IDirectDraw_SetCooperativeLevel(ddraw, window, DDSCL_NORMAL);
    ok(SUCCEEDED(hr), "Failed to set cooperative level, hr %#x.\n", hr);

    memset(&surface_desc, 0, sizeof(surface_desc));
    surface_desc.dwSize = sizeof(surface_desc);
    surface_desc.dwFlags = DDSD_CAPS | DDSD_WIDTH | DDSD_HEIGHT;
    surface_desc.ddsCaps.dwCaps = DDSCAPS_OFFSCREENPLAIN | DDSCAPS_3DDEVICE;
    surface_desc.dwWidth = 640;
    surface_desc.dwHeight = 480;

    hr = IDirectDraw_CreateSurface(ddraw, &surface_desc, &surface, NULL);
    ok(SUCCEEDED(hr), "Failed to create surface, hr %#x.\n", hr);

    hr = IDirectDrawSurface_QueryInterface(surface, &IID_IDirectDrawSurface3, (void **)&surface3);
    if (FAILED(hr))
    {
        skip("Failed to get the IDirectDrawSurface3 interface, skipping test.\n");
        goto cleanup;
    }

    hr = IDirectDraw_QueryInterface(ddraw, &IID_IDirect3D, (void **)&d3d);
    if (FAILED(hr))
    {
        skip("Failed to get the IDirect3D interface, skipping test.\n");
        goto cleanup;
    }

    hr = IDirect3D_EnumDevices(d3d, enum_z_fmt, &z_depth);
    if (FAILED(hr) || !z_depth)
    {
        skip("No depth buffer formats available, skipping test.\n");
        goto cleanup;
    }

    memset(&surface_desc, 0, sizeof(surface_desc));
    surface_desc.dwSize = sizeof(surface_desc);
    surface_desc.dwFlags = DDSD_CAPS | DDSD_ZBUFFERBITDEPTH | DDSD_WIDTH | DDSD_HEIGHT;
    surface_desc.ddsCaps.dwCaps = DDSCAPS_ZBUFFER;
    U2(surface_desc).dwZBufferBitDepth = z_depth;
    surface_desc.dwWidth = 640;
    surface_desc.dwHeight = 480;
    hr = IDirectDraw_CreateSurface(ddraw, &surface_desc, &ds, NULL);
    ok(SUCCEEDED(hr), "Failed to create depth buffer, hr %#x.\n", hr);
    if (FAILED(hr))
        goto cleanup;

    /* Using a different surface interface version still works */
    hr = IDirectDrawSurface3_AddAttachedSurface(surface3, (IDirectDrawSurface3 *)ds);
    ok(SUCCEEDED(hr), "Failed to attach depth buffer, hr %#x.\n", hr);
    refcount = IDirectDrawSurface_Release(ds);
    ok(refcount == 1, "Got unexpected refcount %u.\n", refcount);
    if (FAILED(hr))
        goto cleanup;

    /* Here too */
    hr = IDirectDrawSurface3_QueryInterface(surface3, &IID_IDirect3DHALDevice, (void **)&device);
    ok(SUCCEEDED(hr), "Failed to create d3d device.\n");
    if (FAILED(hr))
        goto cleanup;

    background = create_diffuse_material(device, 1.0f, 0.0f, 0.0f, 1.0f);
    viewport = create_viewport(device, 0, 0, 640, 480);
    viewport_set_background(device, viewport, background);

    hr = IDirect3DViewport_Clear(viewport, 1, &clear_rect, D3DCLEAR_TARGET);
    ok(SUCCEEDED(hr), "Failed to clear render target, hr %#x.\n", hr);
    color = get_surface_color(surface, 320, 240);
    ok(compare_color(color, 0x00ff0000, 1), "Got unexpected color 0x%08x.\n", color);

cleanup:
    if (viewport)
        destroy_viewport(device, viewport);
    if (background)
        destroy_material(background);
    if (surface3) IDirectDrawSurface3_Release(surface3);
    if (surface) IDirectDrawSurface_Release(surface);
    if (device) IDirect3DDevice_Release(device);
    if (d3d) IDirect3D_Release(d3d);
    if (ddraw) IDirectDraw_Release(ddraw);
    DestroyWindow(window);
}

static void test_coop_level_threaded(void)
{
    struct create_window_thread_param p;
    IDirectDraw *ddraw;
    HRESULT hr;

    if (!(ddraw = create_ddraw()))
    {
        skip("Failed to create a ddraw object, skipping test.\n");
        return;
    }
    create_window_thread(&p);

    hr = IDirectDraw_SetCooperativeLevel(ddraw, p.window, DDSCL_EXCLUSIVE | DDSCL_FULLSCREEN);
    ok(SUCCEEDED(hr), "Failed to set cooperative level, hr %#x.\n", hr);

    IDirectDraw_Release(ddraw);
    destroy_window_thread(&p);
}

static ULONG get_refcount(IUnknown *test_iface)
{
    IUnknown_AddRef(test_iface);
    return IUnknown_Release(test_iface);
}

static void test_viewport(void)
{
    IDirectDraw *ddraw;
    IDirect3D *d3d;
    HRESULT hr;
    ULONG ref;
    IDirect3DViewport *viewport, *another_vp;
    IDirect3DViewport2 *viewport2;
    IDirect3DViewport3 *viewport3;
    IDirectDrawGammaControl *gamma;
    IUnknown *unknown;
    IDirect3DDevice *device;
    HWND window;

    if (!(ddraw = create_ddraw()))
    {
        skip("Failed to create ddraw object, skipping test.\n");
        return;
    }
    window = CreateWindowA("static", "ddraw_test", WS_OVERLAPPEDWINDOW,
            0, 0, 640, 480, 0, 0, 0, 0);
    if (!(device = create_device(ddraw, window, DDSCL_NORMAL)))
    {
        skip("Failed to create D3D device, skipping test.\n");
        IDirectDraw_Release(ddraw);
        DestroyWindow(window);
        return;
    }

    hr = IDirectDraw_QueryInterface(ddraw, &IID_IDirect3D, (void **)&d3d);
    ok(SUCCEEDED(hr), "Failed to get d3d interface, hr %#x.\n", hr);
    ref = get_refcount((IUnknown *) d3d);
    ok(ref == 2, "IDirect3D refcount is %d\n", ref);

    hr = IDirect3D_CreateViewport(d3d, &viewport, NULL);
    ok(SUCCEEDED(hr), "Failed to create viewport, hr %#x.\n", hr);
    ref = get_refcount((IUnknown *)viewport);
    ok(ref == 1, "Initial IDirect3DViewport refcount is %u\n", ref);
    ref = get_refcount((IUnknown *)d3d);
    ok(ref == 2, "IDirect3D refcount is %u\n", ref);

    /* E_FAIL return values are returned by Winetestbot Windows NT machines. While not supporting
     * newer interfaces is legitimate for old ddraw versions, E_FAIL violates Microsoft's rules
     * for QueryInterface, hence the broken() */
    gamma = (IDirectDrawGammaControl *)0xdeadbeef;
    hr = IDirect3DViewport_QueryInterface(viewport, &IID_IDirectDrawGammaControl, (void **)&gamma);
    ok(hr == E_NOINTERFACE || broken(hr == E_FAIL), "Got unexpected hr %#x.\n", hr);
    ok(gamma == NULL, "Interface not set to NULL by failed QI call: %p\n", gamma);
    if (SUCCEEDED(hr)) IDirectDrawGammaControl_Release(gamma);
    /* NULL iid: Segfaults */

    hr = IDirect3DViewport_QueryInterface(viewport, &IID_IDirect3DViewport2, (void **)&viewport2);
    ok(SUCCEEDED(hr) || hr == E_NOINTERFACE || broken(hr == E_FAIL),
            "Failed to QI IDirect3DViewport2, hr %#x.\n", hr);
    if (viewport2)
    {
        ref = get_refcount((IUnknown *)viewport);
        ok(ref == 2, "IDirect3DViewport refcount is %u\n", ref);
        ref = get_refcount((IUnknown *)viewport2);
        ok(ref == 2, "IDirect3DViewport2 refcount is %u\n", ref);
        IDirect3DViewport2_Release(viewport2);
        viewport2 = NULL;
    }

    hr = IDirect3DViewport_QueryInterface(viewport, &IID_IDirect3DViewport3, (void **)&viewport3);
    ok(SUCCEEDED(hr) || hr == E_NOINTERFACE || broken(hr == E_FAIL),
            "Failed to QI IDirect3DViewport3, hr %#x.\n", hr);
    if (viewport3)
    {
        ref = get_refcount((IUnknown *)viewport);
        ok(ref == 2, "IDirect3DViewport refcount is %u\n", ref);
        ref = get_refcount((IUnknown *)viewport3);
        ok(ref == 2, "IDirect3DViewport3 refcount is %u\n", ref);
        IDirect3DViewport3_Release(viewport3);
    }

    hr = IDirect3DViewport_QueryInterface(viewport, &IID_IUnknown, (void **)&unknown);
    ok(SUCCEEDED(hr), "Failed to QI IUnknown, hr %#x.\n", hr);
    if (unknown)
    {
        ref = get_refcount((IUnknown *)viewport);
        ok(ref == 2, "IDirect3DViewport refcount is %u\n", ref);
        ref = get_refcount(unknown);
        ok(ref == 2, "IUnknown refcount is %u\n", ref);
        IUnknown_Release(unknown);
    }

    /* AddViewport(NULL): Segfault */
    hr = IDirect3DDevice_DeleteViewport(device, NULL);
    ok(hr == DDERR_INVALIDPARAMS, "Got unexpected hr %#x.\n", hr);

    hr = IDirect3D_CreateViewport(d3d, &another_vp, NULL);
    ok(SUCCEEDED(hr), "Failed to create viewport, hr %#x.\n", hr);

    hr = IDirect3DDevice_AddViewport(device, viewport);
    ok(SUCCEEDED(hr), "Failed to add viewport to device, hr %#x.\n", hr);
    ref = get_refcount((IUnknown *) viewport);
    ok(ref == 2, "IDirect3DViewport refcount is %d\n", ref);
    hr = IDirect3DDevice_AddViewport(device, another_vp);
    ok(SUCCEEDED(hr), "Failed to add viewport to device, hr %#x.\n", hr);
    ref = get_refcount((IUnknown *) another_vp);
    ok(ref == 2, "IDirect3DViewport refcount is %d\n", ref);

    hr = IDirect3DDevice_DeleteViewport(device, another_vp);
    ok(SUCCEEDED(hr), "Failed to delete viewport from device, hr %#x.\n", hr);
    ref = get_refcount((IUnknown *) another_vp);
    ok(ref == 1, "IDirect3DViewport refcount is %d\n", ref);

    IDirect3DDevice_Release(device);
    ref = get_refcount((IUnknown *) viewport);
    ok(ref == 1, "IDirect3DViewport refcount is %d\n", ref);

    IDirect3DViewport_Release(another_vp);
    IDirect3D_Release(d3d);
    IDirect3DViewport_Release(viewport);
    DestroyWindow(window);
    IDirectDraw_Release(ddraw);
}

static void test_zenable(void)
{
    static D3DRECT clear_rect = {{0}, {0}, {640}, {480}};
    static D3DTLVERTEX tquad[] =
    {
        {{  0.0f}, {480.0f}, {-0.5f}, {1.0f}, {0xff00ff00}, {0x00000000}, {0.0f}, {0.0f}},
        {{  0.0f}, {  0.0f}, {-0.5f}, {1.0f}, {0xff00ff00}, {0x00000000}, {0.0f}, {0.0f}},
        {{640.0f}, {480.0f}, { 1.5f}, {1.0f}, {0xff00ff00}, {0x00000000}, {0.0f}, {0.0f}},
        {{640.0f}, {  0.0f}, { 1.5f}, {1.0f}, {0xff00ff00}, {0x00000000}, {0.0f}, {0.0f}},
    };
    IDirect3DExecuteBuffer *execute_buffer;
    D3DEXECUTEBUFFERDESC exec_desc;
    IDirect3DMaterial *background;
    IDirect3DViewport *viewport;
    IDirect3DDevice *device;
    IDirectDrawSurface *rt;
    IDirectDraw *ddraw;
    UINT inst_length;
    D3DCOLOR color;
    HWND window;
    HRESULT hr;
    UINT x, y;
    UINT i, j;
    void *ptr;

    window = CreateWindowA("static", "ddraw_test", WS_OVERLAPPEDWINDOW,
            0, 0, 640, 480, 0, 0, 0, 0);
    if (!(ddraw = create_ddraw()))
    {
        skip("Failed to create ddraw object, skipping test.\n");
        DestroyWindow(window);
        return;
    }
    if (!(device = create_device(ddraw, window, DDSCL_NORMAL)))
    {
        skip("Failed to create D3D device, skipping test.\n");
        IDirectDraw_Release(ddraw);
        DestroyWindow(window);
        return;
    }

    background = create_diffuse_material(device, 1.0f, 0.0f, 0.0f, 1.0f);
    viewport = create_viewport(device, 0, 0, 640, 480);
    viewport_set_background(device, viewport, background);

    memset(&exec_desc, 0, sizeof(exec_desc));
    exec_desc.dwSize = sizeof(exec_desc);
    exec_desc.dwFlags = D3DDEB_BUFSIZE | D3DDEB_CAPS;
    exec_desc.dwBufferSize = 1024;
    exec_desc.dwCaps = D3DDEBCAPS_SYSTEMMEMORY;

    hr = IDirect3DDevice_CreateExecuteBuffer(device, &exec_desc, &execute_buffer, NULL);
    ok(SUCCEEDED(hr), "Failed to create execute buffer, hr %#x.\n", hr);
    hr = IDirect3DExecuteBuffer_Lock(execute_buffer, &exec_desc);
    ok(SUCCEEDED(hr), "Failed to lock execute buffer, hr %#x.\n", hr);
    memcpy(exec_desc.lpData, tquad, sizeof(tquad));
    ptr = ((BYTE *)exec_desc.lpData) + sizeof(tquad);
    emit_process_vertices(&ptr, 0, 4);
    emit_set_rs(&ptr, D3DRENDERSTATE_ZENABLE, D3DZB_FALSE);
    emit_tquad(&ptr, 0);
    emit_end(&ptr);
    inst_length = (BYTE *)ptr - (BYTE *)exec_desc.lpData;
    inst_length -= sizeof(tquad);
    hr = IDirect3DExecuteBuffer_Unlock(execute_buffer);
    ok(SUCCEEDED(hr), "Failed to unlock execute buffer, hr %#x.\n", hr);

    hr = IDirect3DViewport_Clear(viewport, 1, &clear_rect, D3DCLEAR_TARGET);
    ok(SUCCEEDED(hr), "Failed to clear viewport, hr %#x.\n", hr);
    hr = IDirect3DDevice_BeginScene(device);
    ok(SUCCEEDED(hr), "Failed to begin scene, hr %#x.\n", hr);
    set_execute_data(execute_buffer, 4, sizeof(tquad), inst_length);
    hr = IDirect3DDevice_Execute(device, execute_buffer, viewport, D3DEXECUTE_CLIPPED);
    ok(SUCCEEDED(hr), "Failed to execute exec buffer, hr %#x.\n", hr);
    hr = IDirect3DDevice_EndScene(device);
    ok(SUCCEEDED(hr), "Failed to end scene, hr %#x.\n", hr);

    hr = IDirect3DDevice_QueryInterface(device, &IID_IDirectDrawSurface, (void **)&rt);
    ok(SUCCEEDED(hr), "Failed to get render target, hr %#x.\n", hr);
    for (i = 0; i < 4; ++i)
    {
        for (j = 0; j < 4; ++j)
        {
            x = 80 * ((2 * j) + 1);
            y = 60 * ((2 * i) + 1);
            color = get_surface_color(rt, x, y);
            ok(compare_color(color, 0x0000ff00, 1),
                    "Expected color 0x0000ff00 at %u, %u, got 0x%08x.\n", x, y, color);
        }
    }
    IDirectDrawSurface_Release(rt);

    destroy_viewport(device, viewport);
    IDirect3DExecuteBuffer_Release(execute_buffer);
    destroy_material(background);
    IDirect3DDevice_Release(device);
    IDirectDraw_Release(ddraw);
    DestroyWindow(window);
}

static void test_ck_rgba(void)
{
    static D3DRECT clear_rect = {{0}, {0}, {640}, {480}};
    static D3DTLVERTEX tquad[] =
    {
        {{  0.0f}, {480.0f}, {0.25f}, {1.0f}, {0xffffffff}, {0x00000000}, {0.0f}, {0.0f}},
        {{  0.0f}, {  0.0f}, {0.25f}, {1.0f}, {0xffffffff}, {0x00000000}, {0.0f}, {1.0f}},
        {{640.0f}, {480.0f}, {0.25f}, {1.0f}, {0xffffffff}, {0x00000000}, {1.0f}, {0.0f}},
        {{640.0f}, {  0.0f}, {0.25f}, {1.0f}, {0xffffffff}, {0x00000000}, {1.0f}, {1.0f}},
        {{  0.0f}, {480.0f}, {0.75f}, {1.0f}, {0xffffffff}, {0x00000000}, {0.0f}, {0.0f}},
        {{  0.0f}, {  0.0f}, {0.75f}, {1.0f}, {0xffffffff}, {0x00000000}, {0.0f}, {1.0f}},
        {{640.0f}, {480.0f}, {0.75f}, {1.0f}, {0xffffffff}, {0x00000000}, {1.0f}, {0.0f}},
        {{640.0f}, {  0.0f}, {0.75f}, {1.0f}, {0xffffffff}, {0x00000000}, {1.0f}, {1.0f}},
    };
    static const struct
    {
        D3DCOLOR fill_color;
        BOOL color_key;
        BOOL blend;
        D3DCOLOR result1;
        D3DCOLOR result2;
    }
    tests[] =
    {
        {0xff00ff00, TRUE,  TRUE,  0x00ff0000, 0x000000ff},
        {0xff00ff00, TRUE,  FALSE, 0x00ff0000, 0x000000ff},
        {0xff00ff00, FALSE, TRUE,  0x0000ff00, 0x0000ff00},
        {0xff00ff00, FALSE, FALSE, 0x0000ff00, 0x0000ff00},
        {0x7f00ff00, TRUE,  TRUE,  0x00807f00, 0x00807f00},
        {0x7f00ff00, TRUE,  FALSE, 0x0000ff00, 0x0000ff00},
        {0x7f00ff00, FALSE, TRUE,  0x00807f00, 0x00807f00},
        {0x7f00ff00, FALSE, FALSE, 0x0000ff00, 0x0000ff00},
    };

    IDirect3DExecuteBuffer *execute_buffer;
    D3DTEXTUREHANDLE texture_handle;
    D3DEXECUTEBUFFERDESC exec_desc;
    IDirect3DMaterial *background;
    IDirectDrawSurface *surface;
    IDirect3DViewport *viewport;
    DDSURFACEDESC surface_desc;
    IDirect3DTexture *texture;
    IDirect3DDevice *device;
    IDirectDrawSurface *rt;
    IDirectDraw *ddraw;
    D3DCOLOR color;
    HWND window;
    DDBLTFX fx;
    HRESULT hr;
    UINT i;

    window = CreateWindowA("static", "ddraw_test", WS_OVERLAPPEDWINDOW,
            0, 0, 640, 480, 0, 0, 0, 0);
    if (!(ddraw = create_ddraw()))
    {
        skip("Failed to create ddraw object, skipping test.\n");
        DestroyWindow(window);
        return;
    }
    if (!(device = create_device(ddraw, window, DDSCL_NORMAL)))
    {
        skip("Failed to create D3D device, skipping test.\n");
        IDirectDraw_Release(ddraw);
        DestroyWindow(window);
        return;
    }

    background = create_diffuse_material(device, 1.0, 0.0f, 0.0f, 1.0f);
    viewport = create_viewport(device, 0, 0, 640, 480);
    viewport_set_background(device, viewport, background);

    memset(&surface_desc, 0, sizeof(surface_desc));
    surface_desc.dwSize = sizeof(surface_desc);
    surface_desc.dwFlags = DDSD_CAPS | DDSD_WIDTH | DDSD_HEIGHT | DDSD_PIXELFORMAT | DDSD_CKSRCBLT;
    surface_desc.ddsCaps.dwCaps = DDSCAPS_TEXTURE;
    surface_desc.dwWidth = 256;
    surface_desc.dwHeight = 256;
    surface_desc.ddpfPixelFormat.dwSize = sizeof(surface_desc.ddpfPixelFormat);
    surface_desc.ddpfPixelFormat.dwFlags = DDPF_RGB | DDPF_ALPHAPIXELS;
    U1(surface_desc.ddpfPixelFormat).dwRGBBitCount = 32;
    U2(surface_desc.ddpfPixelFormat).dwRBitMask = 0x00ff0000;
    U3(surface_desc.ddpfPixelFormat).dwGBitMask = 0x0000ff00;
    U4(surface_desc.ddpfPixelFormat).dwBBitMask = 0x000000ff;
    U5(surface_desc.ddpfPixelFormat).dwRGBAlphaBitMask = 0xff000000;
    surface_desc.ddckCKSrcBlt.dwColorSpaceLowValue = 0xff00ff00;
    surface_desc.ddckCKSrcBlt.dwColorSpaceHighValue = 0xff00ff00;
    hr = IDirectDraw_CreateSurface(ddraw, &surface_desc, &surface, NULL);
    ok(SUCCEEDED(hr), "Failed to create destination surface, hr %#x.\n", hr);
    hr = IDirectDrawSurface_QueryInterface(surface, &IID_IDirect3DTexture, (void **)&texture);
    ok(SUCCEEDED(hr), "Failed to get texture interface, hr %#x.\n", hr);
    hr = IDirect3DTexture_GetHandle(texture, device, &texture_handle);
    ok(SUCCEEDED(hr), "Failed to get texture handle, hr %#x.\n", hr);
    IDirect3DTexture_Release(texture);

    memset(&exec_desc, 0, sizeof(exec_desc));
    exec_desc.dwSize = sizeof(exec_desc);
    exec_desc.dwFlags = D3DDEB_BUFSIZE | D3DDEB_CAPS;
    exec_desc.dwBufferSize = 1024;
    exec_desc.dwCaps = D3DDEBCAPS_SYSTEMMEMORY;
    hr = IDirect3DDevice_CreateExecuteBuffer(device, &exec_desc, &execute_buffer, NULL);
    ok(SUCCEEDED(hr), "Failed to create execute buffer, hr %#x.\n", hr);

    hr = IDirect3DDevice_QueryInterface(device, &IID_IDirectDrawSurface, (void **)&rt);
    ok(SUCCEEDED(hr), "Failed to get render target, hr %#x.\n", hr);

    for (i = 0; i < sizeof(tests) / sizeof(*tests); ++i)
    {
        UINT draw1_len, draw2_len;
        void *ptr;

        hr = IDirect3DExecuteBuffer_Lock(execute_buffer, &exec_desc);
        ok(SUCCEEDED(hr), "Failed to lock execute buffer, hr %#x.\n", hr);
        memcpy(exec_desc.lpData, tquad, sizeof(tquad));
        ptr = ((BYTE *)exec_desc.lpData) + sizeof(tquad);
        emit_process_vertices(&ptr, 0, 4);
        emit_set_rs(&ptr, D3DRENDERSTATE_TEXTUREHANDLE, texture_handle);
        emit_set_rs(&ptr, D3DRENDERSTATE_SRCBLEND, D3DBLEND_SRCALPHA);
        emit_set_rs(&ptr, D3DRENDERSTATE_DESTBLEND, D3DBLEND_INVSRCALPHA);
        emit_set_rs(&ptr, D3DRENDERSTATE_COLORKEYENABLE, tests[i].color_key);
        emit_set_rs(&ptr, D3DRENDERSTATE_ALPHABLENDENABLE, tests[i].blend);
        emit_tquad(&ptr, 0);
        emit_end(&ptr);
        draw1_len = (BYTE *)ptr - (BYTE *)exec_desc.lpData - sizeof(tquad);
        emit_process_vertices(&ptr, 4, 4);
        emit_tquad(&ptr, 0);
        emit_set_rs(&ptr, D3DRENDERSTATE_TEXTUREHANDLE, 0);
        emit_end(&ptr);
        draw2_len = (BYTE *)ptr - (BYTE *)exec_desc.lpData - draw1_len;
        hr = IDirect3DExecuteBuffer_Unlock(execute_buffer);
        ok(SUCCEEDED(hr), "Failed to unlock execute buffer, hr %#x.\n", hr);

        memset(&fx, 0, sizeof(fx));
        fx.dwSize = sizeof(fx);
        U5(fx).dwFillColor = tests[i].fill_color;
        hr = IDirectDrawSurface_Blt(surface, NULL, NULL, NULL, DDBLT_COLORFILL | DDBLT_WAIT, &fx);
        ok(SUCCEEDED(hr), "Failed to fill texture, hr %#x.\n", hr);

        hr = IDirect3DViewport_Clear(viewport, 1, &clear_rect, D3DCLEAR_TARGET | D3DCLEAR_ZBUFFER);
        ok(SUCCEEDED(hr), "Failed to clear viewport, hr %#x.\n", hr);
        hr = IDirect3DDevice_BeginScene(device);
        ok(SUCCEEDED(hr), "Failed to begin scene, hr %#x.\n", hr);
        set_execute_data(execute_buffer, 8, sizeof(tquad), draw1_len);
        hr = IDirect3DDevice_Execute(device, execute_buffer, viewport, D3DEXECUTE_CLIPPED);
        ok(SUCCEEDED(hr), "Failed to execute exec buffer, hr %#x.\n", hr);
        hr = IDirect3DDevice_EndScene(device);
        ok(SUCCEEDED(hr), "Failed to end scene, hr %#x.\n", hr);

        color = get_surface_color(rt, 320, 240);
        if (i == 2)
            todo_wine ok(compare_color(color, tests[i].result1, 1), "Expected color 0x%08x for test %u, got 0x%08x.\n",
                    tests[i].result1, i, color);
        else
            ok(compare_color(color, tests[i].result1, 1), "Expected color 0x%08x for test %u, got 0x%08x.\n",
                    tests[i].result1, i, color);

        U5(fx).dwFillColor = 0xff0000ff;
        hr = IDirectDrawSurface_Blt(surface, NULL, NULL, NULL, DDBLT_COLORFILL | DDBLT_WAIT, &fx);
        ok(SUCCEEDED(hr), "Failed to fill texture, hr %#x.\n", hr);

        hr = IDirect3DDevice_BeginScene(device);
        ok(SUCCEEDED(hr), "Failed to begin scene, hr %#x.\n", hr);
        set_execute_data(execute_buffer, 8, sizeof(tquad) + draw1_len, draw2_len);
        hr = IDirect3DDevice_Execute(device, execute_buffer, viewport, D3DEXECUTE_CLIPPED);
        ok(SUCCEEDED(hr), "Failed to execute exec buffer, hr %#x.\n", hr);
        hr = IDirect3DDevice_EndScene(device);
        ok(SUCCEEDED(hr), "Failed to end scene, hr %#x.\n", hr);

        /* This tests that fragments that are masked out by the color key are
         * discarded, instead of just fully transparent. */
        color = get_surface_color(rt, 320, 240);
        if (i == 2)
            todo_wine ok(compare_color(color, tests[i].result2, 1), "Expected color 0x%08x for test %u, got 0x%08x.\n",
                    tests[i].result2, i, color);
        else
            ok(compare_color(color, tests[i].result2, 1), "Expected color 0x%08x for test %u, got 0x%08x.\n",
                    tests[i].result2, i, color);
    }

    IDirectDrawSurface_Release(rt);
    IDirect3DExecuteBuffer_Release(execute_buffer);
    IDirectDrawSurface_Release(surface);
    destroy_viewport(device, viewport);
    destroy_material(background);
    IDirect3DDevice_Release(device);
    IDirectDraw_Release(ddraw);
    DestroyWindow(window);
}

static void test_ck_default(void)
{
    static D3DRECT clear_rect = {{0}, {0}, {640}, {480}};
    static D3DTLVERTEX tquad[] =
    {
        {{  0.0f}, {480.0f}, {0.0f}, {1.0f}, {0xffffffff}, {0x00000000}, {0.0f}, {0.0f}},
        {{  0.0f}, {  0.0f}, {0.0f}, {1.0f}, {0xffffffff}, {0x00000000}, {0.0f}, {1.0f}},
        {{640.0f}, {480.0f}, {0.0f}, {1.0f}, {0xffffffff}, {0x00000000}, {1.0f}, {0.0f}},
        {{640.0f}, {  0.0f}, {0.0f}, {1.0f}, {0xffffffff}, {0x00000000}, {1.0f}, {1.0f}},
    };
    IDirect3DExecuteBuffer *execute_buffer;
    IDirectDrawSurface *surface, *rt;
    D3DTEXTUREHANDLE texture_handle;
    D3DEXECUTEBUFFERDESC exec_desc;
    IDirect3DMaterial *background;
    UINT draw1_offset, draw1_len;
    UINT draw2_offset, draw2_len;
    UINT draw3_offset, draw3_len;
    UINT draw4_offset, draw4_len;
    IDirect3DViewport *viewport;
    DDSURFACEDESC surface_desc;
    IDirect3DTexture *texture;
    IDirect3DDevice *device;
    IDirectDraw *ddraw;
    D3DCOLOR color;
    HWND window;
    DDBLTFX fx;
    HRESULT hr;
    void *ptr;

    window = CreateWindowA("static", "ddraw_test", WS_OVERLAPPEDWINDOW,
            0, 0, 640, 480, 0, 0, 0, 0);

    if (!(ddraw = create_ddraw()))
    {
        skip("Failed to create ddraw object, skipping test.\n");
        DestroyWindow(window);
        return;
    }
    if (!(device = create_device(ddraw, window, DDSCL_NORMAL)))
    {
        skip("Failed to create D3D device, skipping test.\n");
        IDirectDraw_Release(ddraw);
        DestroyWindow(window);
        return;
    }

    hr = IDirect3DDevice_QueryInterface(device, &IID_IDirectDrawSurface, (void **)&rt);
    ok(SUCCEEDED(hr), "Failed to get render target, hr %#x.\n", hr);

    background = create_diffuse_material(device, 0.0, 1.0f, 0.0f, 1.0f);
    viewport = create_viewport(device, 0, 0, 640, 480);
    viewport_set_background(device, viewport, background);

    memset(&surface_desc, 0, sizeof(surface_desc));
    surface_desc.dwSize = sizeof(surface_desc);
    surface_desc.dwFlags = DDSD_CAPS | DDSD_WIDTH | DDSD_HEIGHT | DDSD_PIXELFORMAT | DDSD_CKSRCBLT;
    surface_desc.ddsCaps.dwCaps = DDSCAPS_TEXTURE;
    surface_desc.dwWidth = 256;
    surface_desc.dwHeight = 256;
    surface_desc.ddpfPixelFormat.dwSize = sizeof(surface_desc.ddpfPixelFormat);
    surface_desc.ddpfPixelFormat.dwFlags = DDPF_RGB;
    U1(surface_desc.ddpfPixelFormat).dwRGBBitCount = 32;
    U2(surface_desc.ddpfPixelFormat).dwRBitMask = 0x00ff0000;
    U3(surface_desc.ddpfPixelFormat).dwGBitMask = 0x0000ff00;
    U4(surface_desc.ddpfPixelFormat).dwBBitMask = 0x000000ff;
    surface_desc.ddckCKSrcBlt.dwColorSpaceLowValue = 0x000000ff;
    surface_desc.ddckCKSrcBlt.dwColorSpaceHighValue = 0x000000ff;
    hr = IDirectDraw_CreateSurface(ddraw, &surface_desc, &surface, NULL);
    ok(SUCCEEDED(hr), "Failed to create surface, hr %#x.\n", hr);
    hr = IDirectDrawSurface_QueryInterface(surface, &IID_IDirect3DTexture, (void **)&texture);
    ok(SUCCEEDED(hr), "Failed to get texture interface, hr %#x.\n", hr);
    hr = IDirect3DTexture_GetHandle(texture, device, &texture_handle);
    ok(SUCCEEDED(hr), "Failed to get texture handle, hr %#x.\n", hr);
    IDirect3DTexture_Release(texture);

    memset(&fx, 0, sizeof(fx));
    fx.dwSize = sizeof(fx);
    U5(fx).dwFillColor = 0x000000ff;
    hr = IDirectDrawSurface_Blt(surface, NULL, NULL, NULL, DDBLT_COLORFILL | DDBLT_WAIT, &fx);
    ok(SUCCEEDED(hr), "Failed to fill surface, hr %#x.\n", hr);

    memset(&exec_desc, 0, sizeof(exec_desc));
    exec_desc.dwSize = sizeof(exec_desc);
    exec_desc.dwFlags = D3DDEB_BUFSIZE | D3DDEB_CAPS;
    exec_desc.dwBufferSize = 1024;
    exec_desc.dwCaps = D3DDEBCAPS_SYSTEMMEMORY;
    hr = IDirect3DDevice_CreateExecuteBuffer(device, &exec_desc, &execute_buffer, NULL);
    ok(SUCCEEDED(hr), "Failed to create execute buffer, hr %#x.\n", hr);

    hr = IDirect3DExecuteBuffer_Lock(execute_buffer, &exec_desc);
    ok(SUCCEEDED(hr), "Failed to lock execute buffer, hr %#x.\n", hr);
    memcpy(exec_desc.lpData, tquad, sizeof(tquad));
    ptr = (BYTE *)exec_desc.lpData + sizeof(tquad);
    emit_process_vertices(&ptr, 0, 4);
    emit_set_rs(&ptr, D3DRENDERSTATE_TEXTUREHANDLE, texture_handle);
    emit_tquad(&ptr, 0);
    emit_end(&ptr);
    draw1_offset = sizeof(tquad);
    draw1_len = (BYTE *)ptr - (BYTE *)exec_desc.lpData - draw1_offset;
    emit_process_vertices(&ptr, 0, 4);
    emit_set_rs(&ptr, D3DRENDERSTATE_COLORKEYENABLE, FALSE);
    emit_tquad(&ptr, 0);
    emit_end(&ptr);
    draw2_offset = draw1_offset + draw1_len;
    draw2_len = (BYTE *)ptr - (BYTE *)exec_desc.lpData - draw2_offset;
    emit_process_vertices(&ptr, 0, 4);
    emit_tquad(&ptr, 0);
    emit_end(&ptr);
    draw3_offset = draw2_offset + draw2_len;
    draw3_len = (BYTE *)ptr - (BYTE *)exec_desc.lpData - draw3_offset;
    emit_process_vertices(&ptr, 0, 4);
    emit_set_rs(&ptr, D3DRENDERSTATE_COLORKEYENABLE, TRUE);
    emit_tquad(&ptr, 0);
    emit_set_rs(&ptr, D3DRENDERSTATE_TEXTUREHANDLE, 0);
    emit_end(&ptr);
    draw4_offset = draw3_offset + draw3_len;
    draw4_len = (BYTE *)ptr - (BYTE *)exec_desc.lpData - draw4_offset;
    hr = IDirect3DExecuteBuffer_Unlock(execute_buffer);
    ok(SUCCEEDED(hr), "Failed to unlock execute buffer, hr %#x.\n", hr);

    hr = IDirect3DViewport_Clear(viewport, 1, &clear_rect, D3DCLEAR_TARGET);
    ok(SUCCEEDED(hr), "Failed to clear viewport, hr %#x.\n", hr);
    hr = IDirect3DDevice_BeginScene(device);
    ok(SUCCEEDED(hr), "Failed to begin scene, hr %#x.\n", hr);
    set_execute_data(execute_buffer, 4, draw1_offset, draw1_len);
    hr = IDirect3DDevice_Execute(device, execute_buffer, viewport, D3DEXECUTE_CLIPPED);
    ok(SUCCEEDED(hr), "Failed to execute exec buffer, hr %#x.\n", hr);
    hr = IDirect3DDevice_EndScene(device);
    ok(SUCCEEDED(hr), "Failed to end scene, hr %#x.\n", hr);
    color = get_surface_color(rt, 320, 240);
    ok(compare_color(color, 0x0000ff00, 1), "Got unexpected color 0x%08x.\n", color);

    hr = IDirect3DViewport_Clear(viewport, 1, &clear_rect, D3DCLEAR_TARGET);
    ok(SUCCEEDED(hr), "Failed to clear viewport, hr %#x.\n", hr);
    hr = IDirect3DDevice_BeginScene(device);
    ok(SUCCEEDED(hr), "Failed to begin scene, hr %#x.\n", hr);
    set_execute_data(execute_buffer, 4, draw2_offset, draw2_len);
    hr = IDirect3DDevice_Execute(device, execute_buffer, viewport, D3DEXECUTE_CLIPPED);
    ok(SUCCEEDED(hr), "Failed to execute exec buffer, hr %#x.\n", hr);
    hr = IDirect3DDevice_EndScene(device);
    ok(SUCCEEDED(hr), "Failed to end scene, hr %#x.\n", hr);
    color = get_surface_color(rt, 320, 240);
    ok(compare_color(color, 0x000000ff, 1), "Got unexpected color 0x%08x.\n", color);

    hr = IDirect3DViewport_Clear(viewport, 1, &clear_rect, D3DCLEAR_TARGET);
    ok(SUCCEEDED(hr), "Failed to clear viewport, hr %#x.\n", hr);
    hr = IDirect3DDevice_BeginScene(device);
    ok(SUCCEEDED(hr), "Failed to begin scene, hr %#x.\n", hr);
    set_execute_data(execute_buffer, 4, draw3_offset, draw3_len);
    hr = IDirect3DDevice_Execute(device, execute_buffer, viewport, D3DEXECUTE_CLIPPED);
    ok(SUCCEEDED(hr), "Failed to execute exec buffer, hr %#x.\n", hr);
    hr = IDirect3DDevice_EndScene(device);
    ok(SUCCEEDED(hr), "Failed to end scene, hr %#x.\n", hr);
    color = get_surface_color(rt, 320, 240);
    ok(compare_color(color, 0x000000ff, 1), "Got unexpected color 0x%08x.\n", color);

    hr = IDirect3DViewport_Clear(viewport, 1, &clear_rect, D3DCLEAR_TARGET);
    ok(SUCCEEDED(hr), "Failed to clear viewport, hr %#x.\n", hr);
    hr = IDirect3DDevice_BeginScene(device);
    ok(SUCCEEDED(hr), "Failed to begin scene, hr %#x.\n", hr);
    set_execute_data(execute_buffer, 4, draw4_offset, draw4_len);
    hr = IDirect3DDevice_Execute(device, execute_buffer, viewport, D3DEXECUTE_CLIPPED);
    ok(SUCCEEDED(hr), "Failed to execute exec buffer, hr %#x.\n", hr);
    hr = IDirect3DDevice_EndScene(device);
    ok(SUCCEEDED(hr), "Failed to end scene, hr %#x.\n", hr);
    color = get_surface_color(rt, 320, 240);
    ok(compare_color(color, 0x0000ff00, 1), "Got unexpected color 0x%08x.\n", color);

    IDirect3DExecuteBuffer_Release(execute_buffer);
    IDirectDrawSurface_Release(surface);
    destroy_viewport(device, viewport);
    destroy_material(background);
    IDirectDrawSurface_Release(rt);
    IDirect3DDevice_Release(device);
    IDirectDraw_Release(ddraw);
    DestroyWindow(window);
}

struct qi_test
{
    REFIID iid;
    REFIID refcount_iid;
    HRESULT hr;
};

static void test_qi(const char *test_name, IUnknown *base_iface,
        REFIID refcount_iid, const struct qi_test *tests, UINT entry_count)
{
    ULONG refcount, expected_refcount;
    IUnknown *iface1, *iface2;
    HRESULT hr;
    UINT i, j;

    for (i = 0; i < entry_count; ++i)
    {
        hr = IUnknown_QueryInterface(base_iface, tests[i].iid, (void **)&iface1);
        ok(hr == tests[i].hr, "Got hr %#x for test \"%s\" %u.\n", hr, test_name, i);
        if (SUCCEEDED(hr))
        {
            for (j = 0; j < entry_count; ++j)
            {
                hr = IUnknown_QueryInterface(iface1, tests[j].iid, (void **)&iface2);
                ok(hr == tests[j].hr, "Got hr %#x for test \"%s\" %u, %u.\n", hr, test_name, i, j);
                if (SUCCEEDED(hr))
                {
                    expected_refcount = 0;
                    if (IsEqualGUID(refcount_iid, tests[j].refcount_iid))
                        ++expected_refcount;
                    if (IsEqualGUID(tests[i].refcount_iid, tests[j].refcount_iid))
                        ++expected_refcount;
                    refcount = IUnknown_Release(iface2);
                    ok(refcount == expected_refcount, "Got refcount %u for test \"%s\" %u, %u, expected %u.\n",
                            refcount, test_name, i, j, expected_refcount);
                }
            }

            expected_refcount = 0;
            if (IsEqualGUID(refcount_iid, tests[i].refcount_iid))
                ++expected_refcount;
            refcount = IUnknown_Release(iface1);
            ok(refcount == expected_refcount, "Got refcount %u for test \"%s\" %u, expected %u.\n",
                    refcount, test_name, i, expected_refcount);
        }
    }
}

static void test_surface_qi(void)
{
    static const struct qi_test tests[] =
    {
        {&IID_IDirect3DTexture2,        &IID_IDirectDrawSurface,        S_OK         },
        {&IID_IDirect3DTexture,         &IID_IDirectDrawSurface,        S_OK         },
        {&IID_IDirectDrawGammaControl,  &IID_IDirectDrawGammaControl,   S_OK         },
        {&IID_IDirectDrawColorControl,  NULL,                           E_NOINTERFACE},
        {&IID_IDirectDrawSurface7,      &IID_IDirectDrawSurface7,       S_OK         },
        {&IID_IDirectDrawSurface4,      &IID_IDirectDrawSurface4,       S_OK         },
        {&IID_IDirectDrawSurface3,      &IID_IDirectDrawSurface3,       S_OK         },
        {&IID_IDirectDrawSurface2,      &IID_IDirectDrawSurface2,       S_OK         },
        {&IID_IDirectDrawSurface,       &IID_IDirectDrawSurface,        S_OK         },
        {&IID_IDirect3DDevice7,         NULL,                           E_INVALIDARG },
        {&IID_IDirect3DDevice3,         NULL,                           E_INVALIDARG },
        {&IID_IDirect3DDevice2,         NULL,                           E_INVALIDARG },
        {&IID_IDirect3DDevice,          NULL,                           E_INVALIDARG },
        {&IID_IDirect3D7,               NULL,                           E_INVALIDARG },
        {&IID_IDirect3D3,               NULL,                           E_INVALIDARG },
        {&IID_IDirect3D2,               NULL,                           E_INVALIDARG },
        {&IID_IDirect3D,                NULL,                           E_INVALIDARG },
        {&IID_IDirectDraw7,             NULL,                           E_INVALIDARG },
        {&IID_IDirectDraw4,             NULL,                           E_INVALIDARG },
        {&IID_IDirectDraw3,             NULL,                           E_INVALIDARG },
        {&IID_IDirectDraw2,             NULL,                           E_INVALIDARG },
        {&IID_IDirectDraw,              NULL,                           E_INVALIDARG },
        {&IID_IDirect3DLight,           NULL,                           E_INVALIDARG },
        {&IID_IDirect3DMaterial,        NULL,                           E_INVALIDARG },
        {&IID_IDirect3DMaterial2,       NULL,                           E_INVALIDARG },
        {&IID_IDirect3DMaterial3,       NULL,                           E_INVALIDARG },
        {&IID_IDirect3DExecuteBuffer,   NULL,                           E_INVALIDARG },
        {&IID_IDirect3DViewport,        NULL,                           E_INVALIDARG },
        {&IID_IDirect3DViewport2,       NULL,                           E_INVALIDARG },
        {&IID_IDirect3DViewport3,       NULL,                           E_INVALIDARG },
        {&IID_IDirect3DVertexBuffer,    NULL,                           E_INVALIDARG },
        {&IID_IDirect3DVertexBuffer7,   NULL,                           E_INVALIDARG },
        {&IID_IDirectDrawPalette,       NULL,                           E_INVALIDARG },
        {&IID_IDirectDrawClipper,       NULL,                           E_INVALIDARG },
        {&IID_IUnknown,                 &IID_IDirectDrawSurface,        S_OK         },
    };

    IDirectDrawSurface *surface;
    DDSURFACEDESC surface_desc;
    IDirect3DDevice *device;
    IDirectDraw *ddraw;
    HWND window;
    HRESULT hr;

    if (!GetProcAddress(GetModuleHandleA("ddraw.dll"), "DirectDrawCreateEx"))
    {
        win_skip("DirectDrawCreateEx not available, skipping test.\n");
        return;
    }

    window = CreateWindowA("static", "ddraw_test", WS_OVERLAPPEDWINDOW,
            0, 0, 640, 480, 0, 0, 0, 0);
    if (!(ddraw = create_ddraw()))
    {
        skip("Failed to create a ddraw object, skipping test.\n");
        DestroyWindow(window);
        return;
    }
    /* Try to create a D3D device to see if the ddraw implementation supports
     * D3D. 64-bit ddraw in particular doesn't seem to support D3D, and
     * doesn't support e.g. the IDirect3DTexture interfaces. */
    if (!(device = create_device(ddraw, window, DDSCL_NORMAL)))
    {
        skip("Failed to create D3D device, skipping test.\n");
        IDirectDraw_Release(ddraw);
        DestroyWindow(window);
        return;
    }
    IDirect3DDevice_Release(device);

    memset(&surface_desc, 0, sizeof(surface_desc));
    surface_desc.dwSize = sizeof(surface_desc);
    surface_desc.dwFlags = DDSD_CAPS | DDSD_WIDTH | DDSD_HEIGHT;
    surface_desc.ddsCaps.dwCaps = DDSCAPS_TEXTURE;
    surface_desc.dwWidth = 512;
    surface_desc.dwHeight = 512;
    hr = IDirectDraw_CreateSurface(ddraw, &surface_desc, &surface, NULL);
    ok(SUCCEEDED(hr), "Failed to create surface, hr %#x.\n", hr);

    test_qi("surface_qi", (IUnknown *)surface, &IID_IDirectDrawSurface, tests, sizeof(tests) / sizeof(*tests));

    IDirectDrawSurface_Release(surface);
    IDirectDraw_Release(ddraw);
    DestroyWindow(window);
}

static void test_device_qi(void)
{
    static const struct qi_test tests[] =
    {
        {&IID_IDirect3DTexture2,        &IID_IDirectDrawSurface,        S_OK         },
        {&IID_IDirect3DTexture,         &IID_IDirectDrawSurface,        S_OK         },
        {&IID_IDirectDrawGammaControl,  &IID_IDirectDrawGammaControl,   S_OK         },
        {&IID_IDirectDrawColorControl,  NULL,                           E_NOINTERFACE},
        {&IID_IDirectDrawSurface7,      &IID_IDirectDrawSurface7,       S_OK         },
        {&IID_IDirectDrawSurface4,      &IID_IDirectDrawSurface4,       S_OK         },
        {&IID_IDirectDrawSurface3,      &IID_IDirectDrawSurface3,       S_OK         },
        {&IID_IDirectDrawSurface2,      &IID_IDirectDrawSurface2,       S_OK         },
        {&IID_IDirectDrawSurface,       &IID_IDirectDrawSurface,        S_OK         },
        {&IID_IDirect3DDevice7,         NULL,                           E_INVALIDARG },
        {&IID_IDirect3DDevice3,         NULL,                           E_INVALIDARG },
        {&IID_IDirect3DDevice2,         NULL,                           E_INVALIDARG },
        {&IID_IDirect3DDevice,          NULL,                           E_INVALIDARG },
        {&IID_IDirect3DHALDevice,       &IID_IDirectDrawSurface,        S_OK         },
        {&IID_IDirect3D7,               NULL,                           E_INVALIDARG },
        {&IID_IDirect3D3,               NULL,                           E_INVALIDARG },
        {&IID_IDirect3D2,               NULL,                           E_INVALIDARG },
        {&IID_IDirect3D,                NULL,                           E_INVALIDARG },
        {&IID_IDirectDraw7,             NULL,                           E_INVALIDARG },
        {&IID_IDirectDraw4,             NULL,                           E_INVALIDARG },
        {&IID_IDirectDraw3,             NULL,                           E_INVALIDARG },
        {&IID_IDirectDraw2,             NULL,                           E_INVALIDARG },
        {&IID_IDirectDraw,              NULL,                           E_INVALIDARG },
        {&IID_IDirect3DLight,           NULL,                           E_INVALIDARG },
        {&IID_IDirect3DMaterial,        NULL,                           E_INVALIDARG },
        {&IID_IDirect3DMaterial2,       NULL,                           E_INVALIDARG },
        {&IID_IDirect3DMaterial3,       NULL,                           E_INVALIDARG },
        {&IID_IDirect3DExecuteBuffer,   NULL,                           E_INVALIDARG },
        {&IID_IDirect3DViewport,        NULL,                           E_INVALIDARG },
        {&IID_IDirect3DViewport2,       NULL,                           E_INVALIDARG },
        {&IID_IDirect3DViewport3,       NULL,                           E_INVALIDARG },
        {&IID_IDirect3DVertexBuffer,    NULL,                           E_INVALIDARG },
        {&IID_IDirect3DVertexBuffer7,   NULL,                           E_INVALIDARG },
        {&IID_IDirectDrawPalette,       NULL,                           E_INVALIDARG },
        {&IID_IDirectDrawClipper,       NULL,                           E_INVALIDARG },
        {&IID_IUnknown,                 &IID_IDirectDrawSurface,        S_OK         },
    };


    IDirect3DDevice *device;
    IDirectDraw *ddraw;
    HWND window;

    if (!GetProcAddress(GetModuleHandleA("ddraw.dll"), "DirectDrawCreateEx"))
    {
        win_skip("DirectDrawCreateEx not available, skipping test.\n");
        return;
    }

    window = CreateWindowA("static", "ddraw_test", WS_OVERLAPPEDWINDOW,
            0, 0, 640, 480, 0, 0, 0, 0);
    if (!(ddraw = create_ddraw()))
    {
        skip("Failed to create ddraw object, skipping test.\n");
        DestroyWindow(window);
        return;
    }
    if (!(device = create_device(ddraw, window, DDSCL_NORMAL)))
    {
        skip("Failed to create D3D device, skipping test.\n");
        IDirectDraw_Release(ddraw);
        DestroyWindow(window);
        return;
    }

    test_qi("device_qi", (IUnknown *)device, &IID_IDirectDrawSurface, tests, sizeof(tests) / sizeof(*tests));

    IDirect3DDevice_Release(device);
    IDirectDraw_Release(ddraw);
    DestroyWindow(window);
}

static void test_wndproc(void)
{
    LONG_PTR proc, ddraw_proc;
    IDirectDraw *ddraw;
    WNDCLASSA wc = {0};
    HWND window;
    HRESULT hr;
    ULONG ref;

    static const UINT messages[] =
    {
        WM_WINDOWPOSCHANGING,
        WM_MOVE,
        WM_SIZE,
        WM_WINDOWPOSCHANGING,
        WM_ACTIVATE,
        WM_SETFOCUS,
        0,
    };

    /* DDSCL_EXCLUSIVE replaces the window's window proc. */
    if (!(ddraw = create_ddraw()))
    {
        skip("Failed to create IDirectDraw object, skipping tests.\n");
        return;
    }

    wc.lpfnWndProc = test_proc;
    wc.lpszClassName = "ddraw_test_wndproc_wc";
    ok(RegisterClassA(&wc), "Failed to register window class.\n");

    window = CreateWindowA("ddraw_test_wndproc_wc", "ddraw_test",
            WS_MAXIMIZE | WS_CAPTION , 0, 0, 640, 480, 0, 0, 0, 0);

    proc = GetWindowLongPtrA(window, GWLP_WNDPROC);
    ok(proc == (LONG_PTR)test_proc, "Expected wndproc %#lx, got %#lx.\n",
            (LONG_PTR)test_proc, proc);
    expect_messages = messages;
    hr = IDirectDraw_SetCooperativeLevel(ddraw, window, DDSCL_EXCLUSIVE | DDSCL_FULLSCREEN);
    ok(SUCCEEDED(hr), "SetCooperativeLevel failed, hr %#x.\n", hr);
    ok(!*expect_messages, "Expected message %#x, but didn't receive it.\n", *expect_messages);
    expect_messages = NULL;
    proc = GetWindowLongPtrA(window, GWLP_WNDPROC);
    ok(proc != (LONG_PTR)test_proc, "Expected wndproc != %#lx, got %#lx.\n",
            (LONG_PTR)test_proc, proc);
    ref = IDirectDraw_Release(ddraw);
    ok(ref == 0, "The ddraw object was not properly freed: refcount %u.\n", ref);
    proc = GetWindowLongPtrA(window, GWLP_WNDPROC);
    ok(proc == (LONG_PTR)test_proc, "Expected wndproc %#lx, got %#lx.\n",
            (LONG_PTR)test_proc, proc);

    /* DDSCL_NORMAL doesn't. */
    ddraw = create_ddraw();
    proc = GetWindowLongPtrA(window, GWLP_WNDPROC);
    ok(proc == (LONG_PTR)test_proc, "Expected wndproc %#lx, got %#lx.\n",
            (LONG_PTR)test_proc, proc);
    hr = IDirectDraw_SetCooperativeLevel(ddraw, window, DDSCL_NORMAL | DDSCL_FULLSCREEN);
    ok(SUCCEEDED(hr), "SetCooperativeLevel failed, hr %#x.\n", hr);
    proc = GetWindowLongPtrA(window, GWLP_WNDPROC);
    ok(proc == (LONG_PTR)test_proc, "Expected wndproc %#lx, got %#lx.\n",
            (LONG_PTR)test_proc, proc);
    ref = IDirectDraw_Release(ddraw);
    ok(ref == 0, "The ddraw object was not properly freed: refcount %u.\n", ref);
    proc = GetWindowLongPtrA(window, GWLP_WNDPROC);
    ok(proc == (LONG_PTR)test_proc, "Expected wndproc %#lx, got %#lx.\n",
            (LONG_PTR)test_proc, proc);

    /* The original window proc is only restored by ddraw if the current
     * window proc matches the one ddraw set. This also affects switching
     * from DDSCL_NORMAL to DDSCL_EXCLUSIVE. */
    ddraw = create_ddraw();
    proc = GetWindowLongPtrA(window, GWLP_WNDPROC);
    ok(proc == (LONG_PTR)test_proc, "Expected wndproc %#lx, got %#lx.\n",
            (LONG_PTR)test_proc, proc);
    hr = IDirectDraw_SetCooperativeLevel(ddraw, window, DDSCL_EXCLUSIVE | DDSCL_FULLSCREEN);
    ok(SUCCEEDED(hr), "SetCooperativeLevel failed, hr %#x.\n", hr);
    proc = GetWindowLongPtrA(window, GWLP_WNDPROC);
    ok(proc != (LONG_PTR)test_proc, "Expected wndproc != %#lx, got %#lx.\n",
            (LONG_PTR)test_proc, proc);
    ddraw_proc = proc;
    hr = IDirectDraw_SetCooperativeLevel(ddraw, window, DDSCL_NORMAL);
    ok(SUCCEEDED(hr), "SetCooperativeLevel failed, hr %#x.\n", hr);
    proc = GetWindowLongPtrA(window, GWLP_WNDPROC);
    ok(proc == (LONG_PTR)test_proc, "Expected wndproc %#lx, got %#lx.\n",
            (LONG_PTR)test_proc, proc);
    hr = IDirectDraw_SetCooperativeLevel(ddraw, window, DDSCL_EXCLUSIVE | DDSCL_FULLSCREEN);
    ok(SUCCEEDED(hr), "SetCooperativeLevel failed, hr %#x.\n", hr);
    proc = SetWindowLongPtrA(window, GWLP_WNDPROC, (LONG_PTR)DefWindowProcA);
    ok(proc != (LONG_PTR)test_proc, "Expected wndproc != %#lx, got %#lx.\n",
            (LONG_PTR)test_proc, proc);
    hr = IDirectDraw_SetCooperativeLevel(ddraw, window, DDSCL_NORMAL);
    ok(SUCCEEDED(hr), "SetCooperativeLevel failed, hr %#x.\n", hr);
    proc = GetWindowLongPtrA(window, GWLP_WNDPROC);
    ok(proc == (LONG_PTR)DefWindowProcA, "Expected wndproc %#lx, got %#lx.\n",
            (LONG_PTR)DefWindowProcA, proc);
    hr = IDirectDraw_SetCooperativeLevel(ddraw, window, DDSCL_EXCLUSIVE | DDSCL_FULLSCREEN);
    ok(SUCCEEDED(hr), "SetCooperativeLevel failed, hr %#x.\n", hr);
    proc = SetWindowLongPtrA(window, GWLP_WNDPROC, (LONG_PTR)ddraw_proc);
    ok(proc == (LONG_PTR)DefWindowProcA, "Expected wndproc %#lx, got %#lx.\n",
            (LONG_PTR)DefWindowProcA, proc);
    ref = IDirectDraw_Release(ddraw);
    ok(ref == 0, "The ddraw object was not properly freed: refcount %u.\n", ref);
    proc = GetWindowLongPtrA(window, GWLP_WNDPROC);
    ok(proc == (LONG_PTR)test_proc, "Expected wndproc %#lx, got %#lx.\n",
            (LONG_PTR)test_proc, proc);

    ddraw = create_ddraw();
    proc = GetWindowLongPtrA(window, GWLP_WNDPROC);
    ok(proc == (LONG_PTR)test_proc, "Expected wndproc %#lx, got %#lx.\n",
            (LONG_PTR)test_proc, proc);
    hr = IDirectDraw_SetCooperativeLevel(ddraw, window, DDSCL_EXCLUSIVE | DDSCL_FULLSCREEN);
    ok(SUCCEEDED(hr), "SetCooperativeLevel failed, hr %#x.\n", hr);
    proc = SetWindowLongPtrA(window, GWLP_WNDPROC, (LONG_PTR)DefWindowProcA);
    ok(proc != (LONG_PTR)test_proc, "Expected wndproc != %#lx, got %#lx.\n",
            (LONG_PTR)test_proc, proc);
    ref = IDirectDraw_Release(ddraw);
    ok(ref == 0, "The ddraw object was not properly freed: refcount %u.\n", ref);
    proc = GetWindowLongPtrA(window, GWLP_WNDPROC);
    ok(proc == (LONG_PTR)DefWindowProcA, "Expected wndproc %#lx, got %#lx.\n",
            (LONG_PTR)DefWindowProcA, proc);

    fix_wndproc(window, (LONG_PTR)test_proc);
    expect_messages = NULL;
    DestroyWindow(window);
    UnregisterClassA("ddraw_test_wndproc_wc", GetModuleHandleA(NULL));
}

static void test_window_style(void)
{
    LONG style, exstyle, tmp;
    RECT fullscreen_rect, r;
    IDirectDraw *ddraw;
    HWND window;
    HRESULT hr;
    ULONG ref;

    window = CreateWindowA("static", "ddraw_test", WS_OVERLAPPEDWINDOW,
            0, 0, 100, 100, 0, 0, 0, 0);
    if (!(ddraw = create_ddraw()))
    {
        skip("Failed to create a ddraw object, skipping test.\n");
        DestroyWindow(window);
        return;
    }

    style = GetWindowLongA(window, GWL_STYLE);
    exstyle = GetWindowLongA(window, GWL_EXSTYLE);
    SetRect(&fullscreen_rect, 0, 0, GetSystemMetrics(SM_CXSCREEN), GetSystemMetrics(SM_CYSCREEN));

    hr = IDirectDraw_SetCooperativeLevel(ddraw, window, DDSCL_EXCLUSIVE | DDSCL_FULLSCREEN);
    ok(SUCCEEDED(hr), "SetCooperativeLevel failed, hr %#x.\n", hr);

    tmp = GetWindowLongA(window, GWL_STYLE);
    todo_wine ok(tmp == style, "Expected window style %#x, got %#x.\n", style, tmp);
    tmp = GetWindowLongA(window, GWL_EXSTYLE);
    todo_wine ok(tmp == exstyle, "Expected window extended style %#x, got %#x.\n", exstyle, tmp);

    GetWindowRect(window, &r);
    ok(EqualRect(&r, &fullscreen_rect), "Expected {%d, %d, %d, %d}, got {%d, %d, %d, %d}.\n",
            fullscreen_rect.left, fullscreen_rect.top, fullscreen_rect.right, fullscreen_rect.bottom,
            r.left, r.top, r.right, r.bottom);
    GetClientRect(window, &r);
    todo_wine ok(!EqualRect(&r, &fullscreen_rect), "Client rect and window rect are equal.\n");

    hr = IDirectDraw_SetCooperativeLevel(ddraw, window, DDSCL_NORMAL);
    ok(SUCCEEDED(hr), "SetCooperativeLevel failed, hr %#x.\n", hr);

    tmp = GetWindowLongA(window, GWL_STYLE);
    todo_wine ok(tmp == style, "Expected window style %#x, got %#x.\n", style, tmp);
    tmp = GetWindowLongA(window, GWL_EXSTYLE);
    todo_wine ok(tmp == exstyle, "Expected window extended style %#x, got %#x.\n", exstyle, tmp);

    ref = IDirectDraw_Release(ddraw);
    ok(ref == 0, "The ddraw object was not properly freed: refcount %u.\n", ref);

    DestroyWindow(window);
}

static void test_redundant_mode_set(void)
{
    DDSURFACEDESC surface_desc = {0};
    IDirectDraw *ddraw;
    HWND window;
    HRESULT hr;
    RECT r, s;
    ULONG ref;

    window = CreateWindowA("static", "ddraw_test", WS_OVERLAPPEDWINDOW,
            0, 0, 100, 100, 0, 0, 0, 0);
    if (!(ddraw = create_ddraw()))
    {
        skip("Failed to create a ddraw object, skipping test.\n");
        DestroyWindow(window);
        return;
    }

    hr = IDirectDraw_SetCooperativeLevel(ddraw, window, DDSCL_EXCLUSIVE | DDSCL_FULLSCREEN);
    ok(SUCCEEDED(hr), "SetCooperativeLevel failed, hr %#x.\n", hr);

    surface_desc.dwSize = sizeof(surface_desc);
    hr = IDirectDraw_GetDisplayMode(ddraw, &surface_desc);
    ok(SUCCEEDED(hr), "GetDipslayMode failed, hr %#x.\n", hr);

    hr = IDirectDraw_SetDisplayMode(ddraw, surface_desc.dwWidth, surface_desc.dwHeight,
            U1(surface_desc.ddpfPixelFormat).dwRGBBitCount);
    ok(SUCCEEDED(hr), "SetDisplayMode failed, hr %#x.\n", hr);

    GetWindowRect(window, &r);
    r.right /= 2;
    r.bottom /= 2;
    SetWindowPos(window, HWND_TOP, r.left, r.top, r.right, r.bottom, 0);
    GetWindowRect(window, &s);
    ok(EqualRect(&r, &s), "Expected {%d, %d, %d, %d}, got {%d, %d, %d, %d}.\n",
            r.left, r.top, r.right, r.bottom,
            s.left, s.top, s.right, s.bottom);

    hr = IDirectDraw_SetDisplayMode(ddraw, surface_desc.dwWidth, surface_desc.dwHeight,
            U1(surface_desc.ddpfPixelFormat).dwRGBBitCount);
    ok(SUCCEEDED(hr), "SetDisplayMode failed, hr %#x.\n", hr);

    GetWindowRect(window, &s);
    ok(EqualRect(&r, &s), "Expected {%d, %d, %d, %d}, got {%d, %d, %d, %d}.\n",
            r.left, r.top, r.right, r.bottom,
            s.left, s.top, s.right, s.bottom);

    ref = IDirectDraw_Release(ddraw);
    ok(ref == 0, "The ddraw object was not properly freed: refcount %u.\n", ref);

    DestroyWindow(window);
}

static SIZE screen_size;

static LRESULT CALLBACK mode_set_proc(HWND hwnd, UINT message, WPARAM wparam, LPARAM lparam)
{
    if (message == WM_SIZE)
    {
        screen_size.cx = GetSystemMetrics(SM_CXSCREEN);
        screen_size.cy = GetSystemMetrics(SM_CYSCREEN);
    }

    return test_proc(hwnd, message, wparam, lparam);
}

static void test_coop_level_mode_set(void)
{
    IDirectDrawSurface *primary;
    RECT fullscreen_rect, r, s;
    IDirectDraw *ddraw;
    DDSURFACEDESC ddsd;
    WNDCLASSA wc = {0};
    HWND window;
    HRESULT hr;
    ULONG ref;

    static const UINT exclusive_messages[] =
    {
        WM_WINDOWPOSCHANGING,
        WM_WINDOWPOSCHANGED,
        WM_SIZE,
        WM_DISPLAYCHANGE,
        0,
    };

    static const UINT normal_messages[] =
    {
        WM_DISPLAYCHANGE,
        0,
    };

    if (!(ddraw = create_ddraw()))
    {
        skip("Failed to create a ddraw object, skipping test.\n");
        return;
    }

    wc.lpfnWndProc = mode_set_proc;
    wc.lpszClassName = "ddraw_test_wndproc_wc";
    ok(RegisterClassA(&wc), "Failed to register window class.\n");

    window = CreateWindowA("ddraw_test_wndproc_wc", "ddraw_test", WS_OVERLAPPEDWINDOW,
            0, 0, 100, 100, 0, 0, 0, 0);

    SetRect(&fullscreen_rect, 0, 0, GetSystemMetrics(SM_CXSCREEN), GetSystemMetrics(SM_CYSCREEN));
    SetRect(&s, 0, 0, 640, 480);

    hr = IDirectDraw_SetCooperativeLevel(ddraw, window, DDSCL_EXCLUSIVE | DDSCL_FULLSCREEN);
    ok(SUCCEEDED(hr), "SetCooperativeLevel failed, hr %#x.\n", hr);

    GetWindowRect(window, &r);
    ok(EqualRect(&r, &fullscreen_rect), "Expected {%d, %d, %d, %d}, got {%d, %d, %d, %d}.\n",
            fullscreen_rect.left, fullscreen_rect.top, fullscreen_rect.right, fullscreen_rect.bottom,
            r.left, r.top, r.right, r.bottom);

    memset(&ddsd, 0, sizeof(ddsd));
    ddsd.dwSize = sizeof(ddsd);
    ddsd.dwFlags = DDSD_CAPS;
    ddsd.ddsCaps.dwCaps = DDSCAPS_PRIMARYSURFACE;

    hr = IDirectDraw_CreateSurface(ddraw, &ddsd, &primary, NULL);
    ok(SUCCEEDED(hr), "Failed to create surface, hr %#x.\n",hr);
    hr = IDirectDrawSurface_GetSurfaceDesc(primary, &ddsd);
    ok(SUCCEEDED(hr), "Failed to get surface desc, hr %#x.\n", hr);
    ok(ddsd.dwWidth == fullscreen_rect.right - fullscreen_rect.left, "Expected surface width %u, got %u.\n",
            fullscreen_rect.right - fullscreen_rect.left, ddsd.dwWidth);
    ok(ddsd.dwHeight == fullscreen_rect.bottom - fullscreen_rect.top, "Expected surface height %u, got %u.\n",
            fullscreen_rect.bottom - fullscreen_rect.top, ddsd.dwHeight);

    GetWindowRect(window, &r);
    ok(EqualRect(&r, &fullscreen_rect), "Expected {%d, %d, %d, %d}, got {%d, %d, %d, %d}.\n",
            fullscreen_rect.left, fullscreen_rect.top, fullscreen_rect.right, fullscreen_rect.bottom,
            r.left, r.top, r.right, r.bottom);

    expect_messages = exclusive_messages;
    screen_size.cx = 0;
    screen_size.cy = 0;

    hr = IDirectDraw_SetDisplayMode(ddraw, 640, 480, 32);
    ok(SUCCEEDED(hr), "SetDisplayMode failed, hr %#x.\n", hr);

    ok(!*expect_messages, "Expected message %#x, but didn't receive it.\n", *expect_messages);
    expect_messages = NULL;
    ok(screen_size.cx == s.right && screen_size.cy == s.bottom,
            "Expected screen size %ux%u, got %ux%u.\n",
            s.right, s.bottom, screen_size.cx, screen_size.cy);

    GetWindowRect(window, &r);
    ok(EqualRect(&r, &s), "Expected {%d, %d, %d, %d}, got {%d, %d, %d, %d}.\n",
            s.left, s.top, s.right, s.bottom,
            r.left, r.top, r.right, r.bottom);

    hr = IDirectDrawSurface_GetSurfaceDesc(primary, &ddsd);
    ok(SUCCEEDED(hr), "Failed to get surface desc, hr %#x.\n", hr);
    ok(ddsd.dwWidth == fullscreen_rect.right - fullscreen_rect.left, "Expected surface width %u, got %u.\n",
            fullscreen_rect.right - fullscreen_rect.left, ddsd.dwWidth);
    ok(ddsd.dwHeight == fullscreen_rect.bottom - fullscreen_rect.top, "Expected surface height %u, got %u.\n",
            fullscreen_rect.bottom - fullscreen_rect.top, ddsd.dwHeight);
    IDirectDrawSurface_Release(primary);

    memset(&ddsd, 0, sizeof(ddsd));
    ddsd.dwSize = sizeof(ddsd);
    ddsd.dwFlags = DDSD_CAPS;
    ddsd.ddsCaps.dwCaps = DDSCAPS_PRIMARYSURFACE;

    hr = IDirectDraw_CreateSurface(ddraw, &ddsd, &primary, NULL);
    ok(SUCCEEDED(hr), "Failed to create surface, hr %#x.\n",hr);
    hr = IDirectDrawSurface_GetSurfaceDesc(primary, &ddsd);
    ok(SUCCEEDED(hr), "Failed to get surface desc, hr %#x.\n", hr);
    ok(ddsd.dwWidth == s.right - s.left, "Expected surface width %u, got %u.\n",
            s.right - s.left, ddsd.dwWidth);
    ok(ddsd.dwHeight == s.bottom - s.top, "Expected surface height %u, got %u.\n",
            s.bottom - s.top, ddsd.dwHeight);

    GetWindowRect(window, &r);
    ok(EqualRect(&r, &s), "Expected {%d, %d, %d, %d}, got {%d, %d, %d, %d}.\n",
            s.left, s.top, s.right, s.bottom,
            r.left, r.top, r.right, r.bottom);

    expect_messages = exclusive_messages;
    screen_size.cx = 0;
    screen_size.cy = 0;

    hr = IDirectDraw_RestoreDisplayMode(ddraw);
    ok(SUCCEEDED(hr), "RestoreDisplayMode failed, hr %#x.\n", hr);

    ok(!*expect_messages, "Expected message %#x, but didn't receive it.\n", *expect_messages);
    expect_messages = NULL;
    ok(screen_size.cx == fullscreen_rect.right && screen_size.cy == fullscreen_rect.bottom,
            "Expected screen size %ux%u, got %ux%u.\n",
            fullscreen_rect.right, fullscreen_rect.bottom, screen_size.cx, screen_size.cy);

    GetWindowRect(window, &r);
    ok(EqualRect(&r, &fullscreen_rect), "Expected {%d, %d, %d, %d}, got {%d, %d, %d, %d}.\n",
            fullscreen_rect.left, fullscreen_rect.top, fullscreen_rect.right, fullscreen_rect.bottom,
            r.left, r.top, r.right, r.bottom);

    hr = IDirectDrawSurface_GetSurfaceDesc(primary, &ddsd);
    ok(SUCCEEDED(hr), "Failed to get surface desc, hr %#x.\n", hr);
    ok(ddsd.dwWidth == s.right - s.left, "Expected surface width %u, got %u.\n",
            s.right - s.left, ddsd.dwWidth);
    ok(ddsd.dwHeight == s.bottom - s.top, "Expected surface height %u, got %u.\n",
            s.bottom - s.top, ddsd.dwHeight);
    IDirectDrawSurface_Release(primary);

    memset(&ddsd, 0, sizeof(ddsd));
    ddsd.dwSize = sizeof(ddsd);
    ddsd.dwFlags = DDSD_CAPS;
    ddsd.ddsCaps.dwCaps = DDSCAPS_PRIMARYSURFACE;

    hr = IDirectDraw_CreateSurface(ddraw, &ddsd, &primary, NULL);
    ok(SUCCEEDED(hr), "Failed to create surface, hr %#x.\n",hr);
    hr = IDirectDrawSurface_GetSurfaceDesc(primary, &ddsd);
    ok(SUCCEEDED(hr), "Failed to get surface desc, hr %#x.\n", hr);
    ok(ddsd.dwWidth == fullscreen_rect.right - fullscreen_rect.left, "Expected surface width %u, got %u.\n",
            fullscreen_rect.right - fullscreen_rect.left, ddsd.dwWidth);
    ok(ddsd.dwHeight == fullscreen_rect.bottom - fullscreen_rect.top, "Expected surface height %u, got %u.\n",
            fullscreen_rect.bottom - fullscreen_rect.top, ddsd.dwHeight);

    GetWindowRect(window, &r);
    ok(EqualRect(&r, &fullscreen_rect), "Expected {%d, %d, %d, %d}, got {%d, %d, %d, %d}.\n",
            fullscreen_rect.left, fullscreen_rect.top, fullscreen_rect.right, fullscreen_rect.bottom,
            r.left, r.top, r.right, r.bottom);

    hr = IDirectDraw_SetCooperativeLevel(ddraw, window, DDSCL_NORMAL);
    ok(SUCCEEDED(hr), "SetCooperativeLevel failed, hr %#x.\n", hr);

    GetWindowRect(window, &r);
    ok(EqualRect(&r, &fullscreen_rect), "Expected {%d, %d, %d, %d}, got {%d, %d, %d, %d}.\n",
            fullscreen_rect.left, fullscreen_rect.top, fullscreen_rect.right, fullscreen_rect.bottom,
            r.left, r.top, r.right, r.bottom);

    hr = IDirectDrawSurface_GetSurfaceDesc(primary, &ddsd);
    ok(SUCCEEDED(hr), "Failed to get surface desc, hr %#x.\n", hr);
    ok(ddsd.dwWidth == fullscreen_rect.right - fullscreen_rect.left, "Expected surface width %u, got %u.\n",
            fullscreen_rect.right - fullscreen_rect.left, ddsd.dwWidth);
    ok(ddsd.dwHeight == fullscreen_rect.bottom - fullscreen_rect.top, "Expected surface height %u, got %u.\n",
            fullscreen_rect.bottom - fullscreen_rect.top, ddsd.dwHeight);
    IDirectDrawSurface_Release(primary);

    memset(&ddsd, 0, sizeof(ddsd));
    ddsd.dwSize = sizeof(ddsd);
    ddsd.dwFlags = DDSD_CAPS;
    ddsd.ddsCaps.dwCaps = DDSCAPS_PRIMARYSURFACE;

    hr = IDirectDraw_CreateSurface(ddraw, &ddsd, &primary, NULL);
    ok(SUCCEEDED(hr), "Failed to create surface, hr %#x.\n",hr);
    hr = IDirectDrawSurface_GetSurfaceDesc(primary, &ddsd);
    ok(SUCCEEDED(hr), "Failed to get surface desc, hr %#x.\n", hr);
    ok(ddsd.dwWidth == fullscreen_rect.right - fullscreen_rect.left, "Expected surface width %u, got %u.\n",
            fullscreen_rect.right - fullscreen_rect.left, ddsd.dwWidth);
    ok(ddsd.dwHeight == fullscreen_rect.bottom - fullscreen_rect.top, "Expected surface height %u, got %u.\n",
            fullscreen_rect.bottom - fullscreen_rect.top, ddsd.dwHeight);

    GetWindowRect(window, &r);
    ok(EqualRect(&r, &fullscreen_rect), "Expected {%d, %d, %d, %d}, got {%d, %d, %d, %d}.\n",
            fullscreen_rect.left, fullscreen_rect.top, fullscreen_rect.right, fullscreen_rect.bottom,
            r.left, r.top, r.right, r.bottom);

    expect_messages = normal_messages;
    screen_size.cx = 0;
    screen_size.cy = 0;

    hr = IDirectDraw_SetDisplayMode(ddraw, 640, 480, 32);
    ok(SUCCEEDED(hr) || broken(hr == DDERR_NOEXCLUSIVEMODE) /* NT4 testbot */,
            "SetDisplayMode failed, hr %#x.\n", hr);
    if (hr == DDERR_NOEXCLUSIVEMODE)
    {
        win_skip("Broken SetDisplayMode(), skipping remaining tests.\n");
        IDirectDrawSurface_Release(primary);
        IDirectDraw_Release(ddraw);
        goto done;
    }

    ok(!*expect_messages, "Expected message %#x, but didn't receive it.\n", *expect_messages);
    expect_messages = NULL;
    ok(!screen_size.cx && !screen_size.cy, "Got unxpected screen size %ux%u.\n", screen_size.cx, screen_size.cy);

    GetWindowRect(window, &r);
    ok(EqualRect(&r, &fullscreen_rect), "Expected {%d, %d, %d, %d}, got {%d, %d, %d, %d}.\n",
            fullscreen_rect.left, fullscreen_rect.top, fullscreen_rect.right, fullscreen_rect.bottom,
            r.left, r.top, r.right, r.bottom);

    hr = IDirectDrawSurface_GetSurfaceDesc(primary, &ddsd);
    ok(SUCCEEDED(hr), "Failed to get surface desc, hr %#x.\n", hr);
    ok(ddsd.dwWidth == fullscreen_rect.right - fullscreen_rect.left, "Expected surface width %u, got %u.\n",
            fullscreen_rect.right - fullscreen_rect.left, ddsd.dwWidth);
    ok(ddsd.dwHeight == fullscreen_rect.bottom - fullscreen_rect.top, "Expected surface height %u, got %u.\n",
            fullscreen_rect.bottom - fullscreen_rect.top, ddsd.dwHeight);
    IDirectDrawSurface_Release(primary);

    memset(&ddsd, 0, sizeof(ddsd));
    ddsd.dwSize = sizeof(ddsd);
    ddsd.dwFlags = DDSD_CAPS;
    ddsd.ddsCaps.dwCaps = DDSCAPS_PRIMARYSURFACE;

    hr = IDirectDraw_CreateSurface(ddraw, &ddsd, &primary, NULL);
    ok(SUCCEEDED(hr), "Failed to create surface, hr %#x.\n",hr);
    hr = IDirectDrawSurface_GetSurfaceDesc(primary, &ddsd);
    ok(SUCCEEDED(hr), "Failed to get surface desc, hr %#x.\n", hr);
    ok(ddsd.dwWidth == s.right - s.left, "Expected surface width %u, got %u.\n",
            s.right - s.left, ddsd.dwWidth);
    ok(ddsd.dwHeight == s.bottom - s.top, "Expected surface height %u, got %u.\n",
            s.bottom - s.top, ddsd.dwHeight);

    GetWindowRect(window, &r);
    ok(EqualRect(&r, &fullscreen_rect), "Expected {%d, %d, %d, %d}, got {%d, %d, %d, %d}.\n",
            fullscreen_rect.left, fullscreen_rect.top, fullscreen_rect.right, fullscreen_rect.bottom,
            r.left, r.top, r.right, r.bottom);

    expect_messages = normal_messages;
    screen_size.cx = 0;
    screen_size.cy = 0;

    hr = IDirectDraw_RestoreDisplayMode(ddraw);
    ok(SUCCEEDED(hr), "RestoreDisplayMode failed, hr %#x.\n", hr);

    ok(!*expect_messages, "Expected message %#x, but didn't receive it.\n", *expect_messages);
    expect_messages = NULL;
    ok(!screen_size.cx && !screen_size.cy, "Got unxpected screen size %ux%u.\n", screen_size.cx, screen_size.cy);

    GetWindowRect(window, &r);
    ok(EqualRect(&r, &fullscreen_rect), "Expected {%d, %d, %d, %d}, got {%d, %d, %d, %d}.\n",
            fullscreen_rect.left, fullscreen_rect.top, fullscreen_rect.right, fullscreen_rect.bottom,
            r.left, r.top, r.right, r.bottom);

    hr = IDirectDrawSurface_GetSurfaceDesc(primary, &ddsd);
    ok(SUCCEEDED(hr), "Failed to get surface desc, hr %#x.\n", hr);
    ok(ddsd.dwWidth == s.right - s.left, "Expected surface width %u, got %u.\n",
            s.right - s.left, ddsd.dwWidth);
    ok(ddsd.dwHeight == s.bottom - s.top, "Expected surface height %u, got %u.\n",
            s.bottom - s.top, ddsd.dwHeight);
    IDirectDrawSurface_Release(primary);

    memset(&ddsd, 0, sizeof(ddsd));
    ddsd.dwSize = sizeof(ddsd);
    ddsd.dwFlags = DDSD_CAPS;
    ddsd.ddsCaps.dwCaps = DDSCAPS_PRIMARYSURFACE;

    hr = IDirectDraw_CreateSurface(ddraw, &ddsd, &primary, NULL);
    ok(SUCCEEDED(hr), "Failed to create surface, hr %#x.\n",hr);
    hr = IDirectDrawSurface_GetSurfaceDesc(primary, &ddsd);
    ok(SUCCEEDED(hr), "Failed to get surface desc, hr %#x.\n", hr);
    ok(ddsd.dwWidth == fullscreen_rect.right - fullscreen_rect.left, "Expected surface width %u, got %u.\n",
            fullscreen_rect.right - fullscreen_rect.left, ddsd.dwWidth);
    ok(ddsd.dwHeight == fullscreen_rect.bottom - fullscreen_rect.top, "Expected surface height %u, got %u.\n",
            fullscreen_rect.bottom - fullscreen_rect.top, ddsd.dwHeight);

    GetWindowRect(window, &r);
    ok(EqualRect(&r, &fullscreen_rect), "Expected {%d, %d, %d, %d}, got {%d, %d, %d, %d}.\n",
            fullscreen_rect.left, fullscreen_rect.top, fullscreen_rect.right, fullscreen_rect.bottom,
            r.left, r.top, r.right, r.bottom);

    /* DDSCL_NORMAL | DDSCL_FULLSCREEN behaves the same as just DDSCL_NORMAL.
     * Resizing the window on mode changes is a property of DDSCL_EXCLUSIVE,
     * not DDSCL_FULLSCREEN. */
    hr = IDirectDraw_SetCooperativeLevel(ddraw, window, DDSCL_NORMAL | DDSCL_FULLSCREEN);
    ok(SUCCEEDED(hr), "SetCooperativeLevel failed, hr %#x.\n", hr);

    GetWindowRect(window, &r);
    ok(EqualRect(&r, &fullscreen_rect), "Expected {%d, %d, %d, %d}, got {%d, %d, %d, %d}.\n",
            fullscreen_rect.left, fullscreen_rect.top, fullscreen_rect.right, fullscreen_rect.bottom,
            r.left, r.top, r.right, r.bottom);

    hr = IDirectDrawSurface_GetSurfaceDesc(primary, &ddsd);
    ok(SUCCEEDED(hr), "Failed to get surface desc, hr %#x.\n", hr);
    ok(ddsd.dwWidth == fullscreen_rect.right - fullscreen_rect.left, "Expected surface width %u, got %u.\n",
            fullscreen_rect.right - fullscreen_rect.left, ddsd.dwWidth);
    ok(ddsd.dwHeight == fullscreen_rect.bottom - fullscreen_rect.top, "Expected surface height %u, got %u.\n",
            fullscreen_rect.bottom - fullscreen_rect.top, ddsd.dwHeight);
    IDirectDrawSurface_Release(primary);

    memset(&ddsd, 0, sizeof(ddsd));
    ddsd.dwSize = sizeof(ddsd);
    ddsd.dwFlags = DDSD_CAPS;
    ddsd.ddsCaps.dwCaps = DDSCAPS_PRIMARYSURFACE;

    hr = IDirectDraw_CreateSurface(ddraw, &ddsd, &primary, NULL);
    ok(SUCCEEDED(hr), "Failed to create surface, hr %#x.\n",hr);
    hr = IDirectDrawSurface_GetSurfaceDesc(primary, &ddsd);
    ok(SUCCEEDED(hr), "Failed to get surface desc, hr %#x.\n", hr);
    ok(ddsd.dwWidth == fullscreen_rect.right - fullscreen_rect.left, "Expected surface width %u, got %u.\n",
            fullscreen_rect.right - fullscreen_rect.left, ddsd.dwWidth);
    ok(ddsd.dwHeight == fullscreen_rect.bottom - fullscreen_rect.top, "Expected surface height %u, got %u.\n",
            fullscreen_rect.bottom - fullscreen_rect.top, ddsd.dwHeight);

    GetWindowRect(window, &r);
    ok(EqualRect(&r, &fullscreen_rect), "Expected {%d, %d, %d, %d}, got {%d, %d, %d, %d}.\n",
            fullscreen_rect.left, fullscreen_rect.top, fullscreen_rect.right, fullscreen_rect.bottom,
            r.left, r.top, r.right, r.bottom);

    expect_messages = normal_messages;
    screen_size.cx = 0;
    screen_size.cy = 0;

    hr = IDirectDraw_SetDisplayMode(ddraw, 640, 480, 32);
    ok(SUCCEEDED(hr), "SetDisplayMode failed, hr %#x.\n", hr);

    ok(!*expect_messages, "Expected message %#x, but didn't receive it.\n", *expect_messages);
    expect_messages = NULL;
    ok(!screen_size.cx && !screen_size.cy, "Got unxpected screen size %ux%u.\n", screen_size.cx, screen_size.cy);

    GetWindowRect(window, &r);
    ok(EqualRect(&r, &fullscreen_rect), "Expected {%d, %d, %d, %d}, got {%d, %d, %d, %d}.\n",
            fullscreen_rect.left, fullscreen_rect.top, fullscreen_rect.right, fullscreen_rect.bottom,
            r.left, r.top, r.right, r.bottom);

    hr = IDirectDrawSurface_GetSurfaceDesc(primary, &ddsd);
    ok(SUCCEEDED(hr), "Failed to get surface desc, hr %#x.\n", hr);
    ok(ddsd.dwWidth == fullscreen_rect.right - fullscreen_rect.left, "Expected surface width %u, got %u.\n",
            fullscreen_rect.right - fullscreen_rect.left, ddsd.dwWidth);
    ok(ddsd.dwHeight == fullscreen_rect.bottom - fullscreen_rect.top, "Expected surface height %u, got %u.\n",
            fullscreen_rect.bottom - fullscreen_rect.top, ddsd.dwHeight);
    IDirectDrawSurface_Release(primary);

    memset(&ddsd, 0, sizeof(ddsd));
    ddsd.dwSize = sizeof(ddsd);
    ddsd.dwFlags = DDSD_CAPS;
    ddsd.ddsCaps.dwCaps = DDSCAPS_PRIMARYSURFACE;

    hr = IDirectDraw_CreateSurface(ddraw, &ddsd, &primary, NULL);
    ok(SUCCEEDED(hr), "Failed to create surface, hr %#x.\n",hr);
    hr = IDirectDrawSurface_GetSurfaceDesc(primary, &ddsd);
    ok(SUCCEEDED(hr), "Failed to get surface desc, hr %#x.\n", hr);
    ok(ddsd.dwWidth == s.right - s.left, "Expected surface width %u, got %u.\n",
            s.right - s.left, ddsd.dwWidth);
    ok(ddsd.dwHeight == s.bottom - s.top, "Expected surface height %u, got %u.\n",
            s.bottom - s.top, ddsd.dwHeight);

    GetWindowRect(window, &r);
    ok(EqualRect(&r, &fullscreen_rect), "Expected {%d, %d, %d, %d}, got {%d, %d, %d, %d}.\n",
            fullscreen_rect.left, fullscreen_rect.top, fullscreen_rect.right, fullscreen_rect.bottom,
            r.left, r.top, r.right, r.bottom);

    expect_messages = normal_messages;
    screen_size.cx = 0;
    screen_size.cy = 0;

    hr = IDirectDraw_RestoreDisplayMode(ddraw);
    ok(SUCCEEDED(hr), "RestoreDisplayMode failed, hr %#x.\n", hr);

    ok(!*expect_messages, "Expected message %#x, but didn't receive it.\n", *expect_messages);
    expect_messages = NULL;
    ok(!screen_size.cx && !screen_size.cy, "Got unxpected screen size %ux%u.\n", screen_size.cx, screen_size.cy);

    GetWindowRect(window, &r);
    ok(EqualRect(&r, &fullscreen_rect), "Expected {%d, %d, %d, %d}, got {%d, %d, %d, %d}.\n",
            fullscreen_rect.left, fullscreen_rect.top, fullscreen_rect.right, fullscreen_rect.bottom,
            r.left, r.top, r.right, r.bottom);

    hr = IDirectDrawSurface_GetSurfaceDesc(primary, &ddsd);
    ok(SUCCEEDED(hr), "Failed to get surface desc, hr %#x.\n", hr);
    ok(ddsd.dwWidth == s.right - s.left, "Expected surface width %u, got %u.\n",
            s.right - s.left, ddsd.dwWidth);
    ok(ddsd.dwHeight == s.bottom - s.top, "Expected surface height %u, got %u.\n",
            s.bottom - s.top, ddsd.dwHeight);
    IDirectDrawSurface_Release(primary);

    memset(&ddsd, 0, sizeof(ddsd));
    ddsd.dwSize = sizeof(ddsd);
    ddsd.dwFlags = DDSD_CAPS;
    ddsd.ddsCaps.dwCaps = DDSCAPS_PRIMARYSURFACE;

    hr = IDirectDraw_CreateSurface(ddraw, &ddsd, &primary, NULL);
    ok(SUCCEEDED(hr), "Failed to create surface, hr %#x.\n",hr);
    hr = IDirectDrawSurface_GetSurfaceDesc(primary, &ddsd);
    ok(SUCCEEDED(hr), "Failed to get surface desc, hr %#x.\n", hr);
    ok(ddsd.dwWidth == fullscreen_rect.right - fullscreen_rect.left, "Expected surface width %u, got %u.\n",
            fullscreen_rect.right - fullscreen_rect.left, ddsd.dwWidth);
    ok(ddsd.dwHeight == fullscreen_rect.bottom - fullscreen_rect.top, "Expected surface height %u, got %u.\n",
            fullscreen_rect.bottom - fullscreen_rect.top, ddsd.dwHeight);
    IDirectDrawSurface_Release(primary);

    GetWindowRect(window, &r);
    ok(EqualRect(&r, &fullscreen_rect), "Expected {%d, %d, %d, %d}, got {%d, %d, %d, %d}.\n",
            fullscreen_rect.left, fullscreen_rect.top, fullscreen_rect.right, fullscreen_rect.bottom,
            r.left, r.top, r.right, r.bottom);

    /* Unlike ddraw2-7, changing from EXCLUSIVE to NORMAL does not restore the resolution */
    hr = IDirectDraw_SetCooperativeLevel(ddraw, window, DDSCL_EXCLUSIVE | DDSCL_FULLSCREEN);
    ok(SUCCEEDED(hr), "SetCooperativeLevel failed, hr %#x.\n", hr);
    hr = IDirectDraw_SetDisplayMode(ddraw, 640, 480, 32);
    ok(SUCCEEDED(hr), "SetDisplayMode failed, hr %#x.\n", hr);

    hr = IDirectDraw_SetCooperativeLevel(ddraw, window, DDSCL_NORMAL);
    ok(SUCCEEDED(hr), "SetCooperativeLevel failed, hr %#x.\n", hr);

    memset(&ddsd, 0, sizeof(ddsd));
    ddsd.dwSize = sizeof(ddsd);
    ddsd.dwFlags = DDSD_CAPS;
    ddsd.ddsCaps.dwCaps = DDSCAPS_PRIMARYSURFACE;

    hr = IDirectDraw_CreateSurface(ddraw, &ddsd, &primary, NULL);
    ok(SUCCEEDED(hr), "Failed to create surface, hr %#x.\n",hr);
    hr = IDirectDrawSurface_GetSurfaceDesc(primary, &ddsd);
    ok(SUCCEEDED(hr), "Failed to get surface desc, hr %#x.\n", hr);
    ok(ddsd.dwWidth == s.right - s.left, "Expected surface width %u, got %u.\n",
            s.right - s.left, ddsd.dwWidth);
    ok(ddsd.dwHeight == s.bottom - s.top, "Expected surface height %u, got %u.\n",
            s.bottom - s.top, ddsd.dwHeight);
    IDirectDrawSurface_Release(primary);
    hr = IDirectDraw_RestoreDisplayMode(ddraw);
    ok(SUCCEEDED(hr), "RestoreDisplayMode failed, hr %#x.\n", hr);

    ref = IDirectDraw_Release(ddraw);
    ok(ref == 0, "The ddraw object was not properly freed: refcount %u.\n", ref);

    GetWindowRect(window, &r);
    ok(EqualRect(&r, &s), "Expected {%d, %d, %d, %d}, got {%d, %d, %d, %d}.\n",
            fullscreen_rect.left, fullscreen_rect.top, fullscreen_rect.right, fullscreen_rect.bottom,
            r.left, r.top, r.right, r.bottom);

done:
    expect_messages = NULL;
    DestroyWindow(window);
    UnregisterClassA("ddraw_test_wndproc_wc", GetModuleHandleA(NULL));
}

static void test_coop_level_mode_set_multi(void)
{
    IDirectDraw *ddraw1, *ddraw2;
    UINT orig_w, orig_h, w, h;
    HWND window;
    HRESULT hr;
    ULONG ref;

    if (!(ddraw1 = create_ddraw()))
    {
        skip("Failed to create a ddraw object, skipping test.\n");
        return;
    }

    window = CreateWindowA("static", "ddraw_test", WS_OVERLAPPEDWINDOW,
            0, 0, 100, 100, 0, 0, 0, 0);

    orig_w = GetSystemMetrics(SM_CXSCREEN);
    orig_h = GetSystemMetrics(SM_CYSCREEN);

    /* With just a single ddraw object, the display mode is restored on
     * release. */
    hr = IDirectDraw_SetDisplayMode(ddraw1, 800, 600, 32);
    ok(SUCCEEDED(hr) || broken(hr == DDERR_NOEXCLUSIVEMODE) /* NT4 testbot */,
            "SetDisplayMode failed, hr %#x.\n", hr);
    if (hr == DDERR_NOEXCLUSIVEMODE)
    {
        win_skip("Broken SetDisplayMode(), skipping test.\n");
        IDirectDraw_Release(ddraw1);
        DestroyWindow(window);
        return;
    }
    w = GetSystemMetrics(SM_CXSCREEN);
    ok(w == 800, "Got unexpected screen width %u.\n", w);
    h = GetSystemMetrics(SM_CYSCREEN);
    ok(h == 600, "Got unexpected screen height %u.\n", h);

    ref = IDirectDraw_Release(ddraw1);
    ok(ref == 0, "The ddraw object was not properly freed: refcount %u.\n", ref);
    w = GetSystemMetrics(SM_CXSCREEN);
    ok(w == orig_w, "Got unexpected screen width %u.\n", w);
    h = GetSystemMetrics(SM_CYSCREEN);
    ok(h == orig_h, "Got unexpected screen height %u.\n", h);

    /* When there are multiple ddraw objects, the display mode is restored to
     * the initial mode, before the first SetDisplayMode() call. */
    ddraw1 = create_ddraw();
    hr = IDirectDraw_SetDisplayMode(ddraw1, 800, 600, 32);
    ok(SUCCEEDED(hr), "SetDisplayMode failed, hr %#x.\n", hr);
    w = GetSystemMetrics(SM_CXSCREEN);
    ok(w == 800, "Got unexpected screen width %u.\n", w);
    h = GetSystemMetrics(SM_CYSCREEN);
    ok(h == 600, "Got unexpected screen height %u.\n", h);

    ddraw2 = create_ddraw();
    hr = IDirectDraw_SetDisplayMode(ddraw2, 640, 480, 32);
    ok(SUCCEEDED(hr), "SetDisplayMode failed, hr %#x.\n", hr);
    w = GetSystemMetrics(SM_CXSCREEN);
    ok(w == 640, "Got unexpected screen width %u.\n", w);
    h = GetSystemMetrics(SM_CYSCREEN);
    ok(h == 480, "Got unexpected screen height %u.\n", h);

    ref = IDirectDraw_Release(ddraw2);
    ok(ref == 0, "The ddraw object was not properly freed: refcount %u.\n", ref);
    w = GetSystemMetrics(SM_CXSCREEN);
    ok(w == orig_w, "Got unexpected screen width %u.\n", w);
    h = GetSystemMetrics(SM_CYSCREEN);
    ok(h == orig_h, "Got unexpected screen height %u.\n", h);

    ref = IDirectDraw_Release(ddraw1);
    ok(ref == 0, "The ddraw object was not properly freed: refcount %u.\n", ref);
    w = GetSystemMetrics(SM_CXSCREEN);
    ok(w == orig_w, "Got unexpected screen width %u.\n", w);
    h = GetSystemMetrics(SM_CYSCREEN);
    ok(h == orig_h, "Got unexpected screen height %u.\n", h);

    /* Regardless of release ordering. */
    ddraw1 = create_ddraw();
    hr = IDirectDraw_SetDisplayMode(ddraw1, 800, 600, 32);
    ok(SUCCEEDED(hr), "SetDisplayMode failed, hr %#x.\n", hr);
    w = GetSystemMetrics(SM_CXSCREEN);
    ok(w == 800, "Got unexpected screen width %u.\n", w);
    h = GetSystemMetrics(SM_CYSCREEN);
    ok(h == 600, "Got unexpected screen height %u.\n", h);

    ddraw2 = create_ddraw();
    hr = IDirectDraw_SetDisplayMode(ddraw2, 640, 480, 32);
    ok(SUCCEEDED(hr), "SetDisplayMode failed, hr %#x.\n", hr);
    w = GetSystemMetrics(SM_CXSCREEN);
    ok(w == 640, "Got unexpected screen width %u.\n", w);
    h = GetSystemMetrics(SM_CYSCREEN);
    ok(h == 480, "Got unexpected screen height %u.\n", h);

    ref = IDirectDraw_Release(ddraw1);
    ok(ref == 0, "The ddraw object was not properly freed: refcount %u.\n", ref);
    w = GetSystemMetrics(SM_CXSCREEN);
    ok(w == orig_w, "Got unexpected screen width %u.\n", w);
    h = GetSystemMetrics(SM_CYSCREEN);
    ok(h == orig_h, "Got unexpected screen height %u.\n", h);

    ref = IDirectDraw_Release(ddraw2);
    ok(ref == 0, "The ddraw object was not properly freed: refcount %u.\n", ref);
    w = GetSystemMetrics(SM_CXSCREEN);
    ok(w == orig_w, "Got unexpected screen width %u.\n", w);
    h = GetSystemMetrics(SM_CYSCREEN);
    ok(h == orig_h, "Got unexpected screen height %u.\n", h);

    /* But only for ddraw objects that called SetDisplayMode(). */
    ddraw1 = create_ddraw();
    ddraw2 = create_ddraw();
    hr = IDirectDraw_SetDisplayMode(ddraw2, 640, 480, 32);
    ok(SUCCEEDED(hr), "SetDisplayMode failed, hr %#x.\n", hr);
    w = GetSystemMetrics(SM_CXSCREEN);
    ok(w == 640, "Got unexpected screen width %u.\n", w);
    h = GetSystemMetrics(SM_CYSCREEN);
    ok(h == 480, "Got unexpected screen height %u.\n", h);

    ref = IDirectDraw_Release(ddraw1);
    ok(ref == 0, "The ddraw object was not properly freed: refcount %u.\n", ref);
    w = GetSystemMetrics(SM_CXSCREEN);
    ok(w == 640, "Got unexpected screen width %u.\n", w);
    h = GetSystemMetrics(SM_CYSCREEN);
    ok(h == 480, "Got unexpected screen height %u.\n", h);

    ref = IDirectDraw_Release(ddraw2);
    ok(ref == 0, "The ddraw object was not properly freed: refcount %u.\n", ref);
    w = GetSystemMetrics(SM_CXSCREEN);
    ok(w == orig_w, "Got unexpected screen width %u.\n", w);
    h = GetSystemMetrics(SM_CYSCREEN);
    ok(h == orig_h, "Got unexpected screen height %u.\n", h);

    /* If there's a ddraw object that's currently in exclusive mode, it blocks
     * restoring the display mode. */
    ddraw1 = create_ddraw();
    hr = IDirectDraw_SetDisplayMode(ddraw1, 800, 600, 32);
    ok(SUCCEEDED(hr), "SetDisplayMode failed, hr %#x.\n", hr);
    w = GetSystemMetrics(SM_CXSCREEN);
    ok(w == 800, "Got unexpected screen width %u.\n", w);
    h = GetSystemMetrics(SM_CYSCREEN);
    ok(h == 600, "Got unexpected screen height %u.\n", h);

    ddraw2 = create_ddraw();
    hr = IDirectDraw_SetDisplayMode(ddraw2, 640, 480, 32);
    ok(SUCCEEDED(hr), "SetDisplayMode failed, hr %#x.\n", hr);
    w = GetSystemMetrics(SM_CXSCREEN);
    ok(w == 640, "Got unexpected screen width %u.\n", w);
    h = GetSystemMetrics(SM_CYSCREEN);
    ok(h == 480, "Got unexpected screen height %u.\n", h);

    hr = IDirectDraw_SetCooperativeLevel(ddraw2, window, DDSCL_EXCLUSIVE | DDSCL_FULLSCREEN);
    ok(SUCCEEDED(hr), "SetCooperativeLevel failed, hr %#x.\n", hr);

    ref = IDirectDraw_Release(ddraw1);
    ok(ref == 0, "The ddraw object was not properly freed: refcount %u.\n", ref);
    w = GetSystemMetrics(SM_CXSCREEN);
    ok(w == 640, "Got unexpected screen width %u.\n", w);
    h = GetSystemMetrics(SM_CYSCREEN);
    ok(h == 480, "Got unexpected screen height %u.\n", h);

    ref = IDirectDraw_Release(ddraw2);
    ok(ref == 0, "The ddraw object was not properly freed: refcount %u.\n", ref);
    w = GetSystemMetrics(SM_CXSCREEN);
    ok(w == orig_w, "Got unexpected screen width %u.\n", w);
    h = GetSystemMetrics(SM_CYSCREEN);
    ok(h == orig_h, "Got unexpected screen height %u.\n", h);

    /* Exclusive mode blocks mode setting on other ddraw objects in general. */
    ddraw1 = create_ddraw();
    hr = IDirectDraw_SetDisplayMode(ddraw1, 800, 600, 32);
    ok(SUCCEEDED(hr), "SetDisplayMode failed, hr %#x.\n", hr);
    w = GetSystemMetrics(SM_CXSCREEN);
    ok(w == 800, "Got unexpected screen width %u.\n", w);
    h = GetSystemMetrics(SM_CYSCREEN);
    ok(h == 600, "Got unexpected screen height %u.\n", h);

    hr = IDirectDraw_SetCooperativeLevel(ddraw1, window, DDSCL_EXCLUSIVE | DDSCL_FULLSCREEN);
    ok(SUCCEEDED(hr), "SetCooperativeLevel failed, hr %#x.\n", hr);

    ddraw2 = create_ddraw();
    hr = IDirectDraw_SetDisplayMode(ddraw2, 640, 480, 32);
    ok(hr == DDERR_NOEXCLUSIVEMODE, "Got unexpected hr %#x.\n", hr);

    ref = IDirectDraw_Release(ddraw1);
    ok(ref == 0, "The ddraw object was not properly freed: refcount %u.\n", ref);
    w = GetSystemMetrics(SM_CXSCREEN);
    ok(w == orig_w, "Got unexpected screen width %u.\n", w);
    h = GetSystemMetrics(SM_CYSCREEN);
    ok(h == orig_h, "Got unexpected screen height %u.\n", h);

    ref = IDirectDraw_Release(ddraw2);
    ok(ref == 0, "The ddraw object was not properly freed: refcount %u.\n", ref);
    w = GetSystemMetrics(SM_CXSCREEN);
    ok(w == orig_w, "Got unexpected screen width %u.\n", w);
    h = GetSystemMetrics(SM_CYSCREEN);
    ok(h == orig_h, "Got unexpected screen height %u.\n", h);

    DestroyWindow(window);
}

static void test_initialize(void)
{
    IDirectDraw *ddraw;
    IDirect3D *d3d;
    HRESULT hr;

    if (!(ddraw = create_ddraw()))
    {
        skip("Failed to create a ddraw object, skipping test.\n");
        return;
    }

    hr = IDirectDraw_Initialize(ddraw, NULL);
    ok(hr == DDERR_ALREADYINITIALIZED, "Initialize returned hr %#x.\n", hr);
    IDirectDraw_Release(ddraw);

    CoInitialize(NULL);
    hr = CoCreateInstance(&CLSID_DirectDraw, NULL, CLSCTX_INPROC_SERVER, &IID_IDirectDraw, (void **)&ddraw);
    ok(SUCCEEDED(hr), "Failed to create IDirectDraw instance, hr %#x.\n", hr);
    hr = IDirectDraw_QueryInterface(ddraw, &IID_IDirect3D, (void **)&d3d);
    if (SUCCEEDED(hr))
    {
        /* IDirect3D_Initialize() just returns DDERR_ALREADYINITIALIZED. */
        hr = IDirect3D_Initialize(d3d, NULL);
        ok(hr == DDERR_ALREADYINITIALIZED, "Initialize returned hr %#x, expected DDERR_ALREADYINITIALIZED.\n", hr);
        IDirect3D_Release(d3d);
    }
    else skip("Failed to query IDirect3D interface, skipping tests.\n");
    hr = IDirectDraw_Initialize(ddraw, NULL);
    ok(hr == DD_OK, "Initialize returned hr %#x, expected DD_OK.\n", hr);
    hr = IDirectDraw_Initialize(ddraw, NULL);
    ok(hr == DDERR_ALREADYINITIALIZED, "Initialize returned hr %#x, expected DDERR_ALREADYINITIALIZED.\n", hr);
    IDirectDraw_Release(ddraw);
    CoUninitialize();

    if (0) /* This crashes on the W2KPROSP4 testbot. */
    {
        CoInitialize(NULL);
        hr = CoCreateInstance(&CLSID_DirectDraw, NULL, CLSCTX_INPROC_SERVER, &IID_IDirect3D, (void **)&d3d);
        ok(hr == E_NOINTERFACE, "CoCreateInstance returned hr %#x, expected E_NOINTERFACE.\n", hr);
        CoUninitialize();
    }
}

static void test_coop_level_surf_create(void)
{
    IDirectDrawSurface *surface;
    IDirectDraw *ddraw;
    DDSURFACEDESC ddsd;
    HRESULT hr;

    if (!(ddraw = create_ddraw()))
    {
        skip("Failed to create a ddraw object, skipping test.\n");
        return;
    }

    memset(&ddsd, 0, sizeof(ddsd));
    ddsd.dwSize = sizeof(ddsd);
    ddsd.dwFlags = DDSD_CAPS;
    ddsd.ddsCaps.dwCaps = DDSCAPS_PRIMARYSURFACE;
    hr = IDirectDraw_CreateSurface(ddraw, &ddsd, &surface, NULL);
    ok(hr == DDERR_NOCOOPERATIVELEVELSET, "Surface creation returned hr %#x.\n", hr);

    IDirectDraw_Release(ddraw);
}

static void test_coop_level_multi_window(void)
{
    HWND window1, window2;
    IDirectDraw *ddraw;
    HRESULT hr;

    window1 = CreateWindowA("static", "ddraw_test1", WS_OVERLAPPEDWINDOW,
            0, 0, 640, 480, 0, 0, 0, 0);
    window2 = CreateWindowA("static", "ddraw_test2", WS_OVERLAPPEDWINDOW,
            0, 0, 640, 480, 0, 0, 0, 0);
    if (!(ddraw = create_ddraw()))
    {
        skip("Failed to create a ddraw object, skipping test.\n");
        DestroyWindow(window2);
        DestroyWindow(window1);
        return;
    }

    hr = IDirectDraw_SetCooperativeLevel(ddraw, window1, DDSCL_NORMAL);
    ok(SUCCEEDED(hr), "Failed to set cooperative level, hr %#x.\n", hr);
    hr = IDirectDraw_SetCooperativeLevel(ddraw, window2, DDSCL_NORMAL);
    ok(SUCCEEDED(hr), "Failed to set cooperative level, hr %#x.\n", hr);
    ok(IsWindow(window1), "Window 1 was destroyed.\n");
    ok(IsWindow(window2), "Window 2 was destroyed.\n");

    IDirectDraw_Release(ddraw);
    DestroyWindow(window2);
    DestroyWindow(window1);
}

static void test_clear_rect_count(void)
{
    static D3DRECT clear_rect = {{0}, {0}, {640}, {480}};
    IDirect3DMaterial *white, *red, *green, *blue;
    IDirect3DViewport *viewport;
    IDirect3DDevice *device;
    IDirectDrawSurface *rt;
    IDirectDraw *ddraw;
    D3DCOLOR color;
    HWND window;
    HRESULT hr;

    window = CreateWindowA("static", "ddraw_test", WS_OVERLAPPEDWINDOW,
            0, 0, 640, 480, 0, 0, 0, 0);
    if (!(ddraw = create_ddraw()))
    {
        skip("Failed to create ddraw object, skipping test.\n");
        DestroyWindow(window);
        return;
    }
    if (!(device = create_device(ddraw, window, DDSCL_NORMAL)))
    {
        skip("Failed to create D3D device, skipping test.\n");
        IDirectDraw_Release(ddraw);
        DestroyWindow(window);
        return;
    }

    hr = IDirect3DDevice_QueryInterface(device, &IID_IDirectDrawSurface, (void **)&rt);
    ok(SUCCEEDED(hr), "Failed to get render target, hr %#x.\n", hr);

    white = create_diffuse_material(device, 1.0f, 1.0f, 1.0f, 1.0f);
    red   = create_diffuse_material(device, 1.0f, 0.0f, 0.0f, 1.0f);
    green = create_diffuse_material(device, 0.0f, 1.0f, 0.0f, 1.0f);
    blue  = create_diffuse_material(device, 0.0f, 0.0f, 1.0f, 1.0f);
    viewport = create_viewport(device, 0, 0, 640, 480);

    viewport_set_background(device, viewport, white);
    hr = IDirect3DViewport_Clear(viewport, 1, &clear_rect, D3DCLEAR_TARGET);
    ok(SUCCEEDED(hr), "Failed to clear viewport, hr %#x.\n", hr);
    viewport_set_background(device, viewport, red);
    hr = IDirect3DViewport_Clear(viewport, 0, &clear_rect, D3DCLEAR_TARGET);
    ok(SUCCEEDED(hr), "Failed to clear viewport, hr %#x.\n", hr);
    viewport_set_background(device, viewport, green);
    hr = IDirect3DViewport_Clear(viewport, 0, NULL, D3DCLEAR_TARGET);
    ok(SUCCEEDED(hr), "Failed to clear viewport, hr %#x.\n", hr);
    viewport_set_background(device, viewport, blue);
    hr = IDirect3DViewport_Clear(viewport, 1, NULL, D3DCLEAR_TARGET);
    ok(SUCCEEDED(hr), "Failed to clear viewport, hr %#x.\n", hr);

    color = get_surface_color(rt, 320, 240);
    ok(compare_color(color, 0x00ffffff, 1), "Got unexpected color 0x%08x.\n", color);

    IDirectDrawSurface_Release(rt);
    destroy_viewport(device, viewport);
    destroy_material(white);
    destroy_material(red);
    destroy_material(green);
    destroy_material(blue);
    IDirect3DDevice_Release(device);
    IDirectDraw_Release(ddraw);
    DestroyWindow(window);
}

START_TEST(ddraw1)
{
    test_coop_level_create_device_window();
    test_clipper_blt();
    test_coop_level_d3d_state();
    test_surface_interface_mismatch();
    test_coop_level_threaded();
    test_viewport();
    test_zenable();
    test_ck_rgba();
    test_ck_default();
    test_surface_qi();
    test_device_qi();
    test_wndproc();
    test_window_style();
    test_redundant_mode_set();
    test_coop_level_mode_set();
    test_coop_level_mode_set_multi();
    test_initialize();
    test_coop_level_surf_create();
    test_coop_level_multi_window();
    test_clear_rect_count();
}
