package main
import win32 "core:sys/windows"
import "core:intrinsics"

const_utf16 :: intrinsics.constant_utf16_cstring

window_callback :: proc "std" (window: win32.HWND, msg: u32, wparam: win32.WPARAM, lparam: win32.LPARAM) -> win32.LRESULT {
    return 0
}
main :: proc () {

    // -- Create a window -- //

    // call this to get the current instance
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

    window_class := win32.WNDCLASSW {
        style = win32.CS_VREDRAW | win32.CS_HREDRAW | win32.CS_OWNDC,
        lpfnWndProc = window_callback,
        cbClsExtra = {},
        cbWndExtra = {},
        hInstance = window_instance,
        hIcon = {},
        hCursor = {},
        hbrBackground = {},
        lpszMenuName = nil,
        lpszClassName = const_utf16("my window class"),
    }

    assert(win32.RegisterClassW(&window_class) != 0)

    window_handle := win32.CreateWindowExW(
        dwExStyle = {},
        lpClassName = window_class.lpszClassName,
        lpWindowName = const_utf16("my window"),
        dwStyle = win32.WS_VISIBLE | win32.WS_OVERLAPPEDWINDOW,
        X = win32.CW_USEDEFAULT,
        Y = win32.CW_USEDEFAULT,
        nWidth  = window_width,
        nHeight = window_height,
        hWndParent = nil,
        hMenu = nil,
        lpParam = nil,
        hInstance = window_instance,
    )

    assert(window_handle != nil)
    device_ctx := win32.GetDC(window_handle)
    win32.ShowWindow(window_handle, 1)
}
    // -- done creating window -- //