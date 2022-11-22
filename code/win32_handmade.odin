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

g_context : runtime.Context


main :: proc() {
    g_context = context
    x:=foo()
    fmt.println("Hello Handmade")
}

@(export) 
@(link_name="foo")
foo :: proc"system"() -> f32 {
    context=g_context
    fmt.println("needed")
    return 5.0
}
// int WINAPI wWinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, PWSTR pCmdLine, int nCmdShow);