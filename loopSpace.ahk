#Requires AutoHotkey v2.0
; #MaxThreadsPerHotkey 2
#SingleInstance Force

rate := 280
open := false
F2:: {
    global open
    open := ~open
}

F3:: {
    global rate
    rate := rate + 20

    ToolTip rate
    SetTimer ToolTip, 2000
}


F4:: {
    global rate
    rate := rate - 20

    ToolTip rate
    SetTimer ToolTip, 2000
}

$Space:: {
    global open
    global rate
    if (open) {
        Loop
        {
            state := GetKeyState("Space", "P")
            ; 长按的情况下触发
            if (state) {
                OutputDebug "连发"
                Send "{Space}"
                Sleep rate
            } else {
                OutputDebug "停止"
                break
            }
        }
    } else {
        OutputDebug "发一下"
        Send "{Space}"
    }

}