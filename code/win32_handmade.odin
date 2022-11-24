/* ====================================================================
    $File: $
    $Date: $
    $Revision: $
    $Creator: John Boyle $
    $Notice: (c) Copyright 2022 by John Boyle. All Rights Reserved*/
package main
import win32 "core:sys/windows"
import "core:fmt"
import "core:runtime"
import "core:intrinsics"
import "core:c"

g_context : runtime.Context 

const_utf16 :: intrinsics.constant_utf16_cstring
window_callback :: proc "std" (window: win32.HWND, msg: u32, wparam: win32.WPARAM, lparam: win32.LPARAM) -> win32.LRESULT {
    return 0
}

foreign import User32 "system:User32.lib"
@(default_calling_convention = "stdcall")
foreign User32 {

    @(link_name = "RegisterClassA")
    RegisterClassA :: proc(lpWndClass: ^win32.WNDCLASSA) -> win32.ATOM ---

    @(link_name = "CreateWindowExA")
    CreateWindowExA :: proc(dwExStyle: win32.DWORD, lpClassName: win32.LPCSTR, lpWindowName: win32.LPCSTR, dwStyle: win32.DWORD, X: c.int, Y: c.int, nWidth: c.int, nHeight: c.int, hWndParent: win32.HWND, hMenu: win32.HMENU, hInstance: win32.HINSTANCE, lpParam: win32.LPVOID) -> win32.HWND ---

}

main :: proc() {
    //g_context = context

    window_instance := cast(win32.HINSTANCE)(win32.GetModuleHandleW(nil))
    assert(window_instance != nil)

    // windows so nice you have to do this to get the actual size you want
    // paid OS btw
    _dummy_rect := win32.RECT{
        left = 0, top = 0,
        right = 1280, bottom = 720,
    }

    win32.AdjustWindowRectEx(&_dummy_rect, win32.WS_OVERLAPPEDWINDOW, true, 0)
    window_width  := _dummy_rect.right - _dummy_rect.left
    window_height := _dummy_rect.bottom - _dummy_rect.top

    window_class := win32.WNDCLASSA {
        style = win32.CS_VREDRAW | win32.CS_HREDRAW,
        lpfnWndProc = window_callback,
        cbClsExtra = {},
        cbWndExtra = {},
        hInstance = window_instance,
        hIcon = {},
        hCursor = win32.LoadCursorA(win32.HINSTANCE(nil), win32.IDC_ARROW),
        hbrBackground = {},
        lpszMenuName = nil,
        lpszClassName = "Handmade Odin",
    }

    if RegisterClassA(&window_class) != 0 {

        window_handle := CreateWindowExA(
            dwExStyle = 0,
            lpClassName = window_class.lpszClassName,
            lpWindowName = "Handmade Odin",
            dwStyle = win32.WS_VISIBLE | win32.WS_OVERLAPPEDWINDOW,
            X = win32.CW_USEDEFAULT,
            Y = win32.CW_USEDEFAULT,
            nWidth  = 1280,
            nHeight = 720,
            hWndParent = nil,
            hMenu = nil,
            lpParam = nil,
            hInstance = window_instance,
        )

        assert(window_handle != nil)
        device_ctx := win32.GetDC(window_handle)
        win32.ShowWindow(window_handle, 1)
    }

    fmt.println("Hello Handmade") 

}


// int WINAPI wWinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, PWSTR pCmdLine, int nCmdShow);