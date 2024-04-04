#Requires AutoHotkey v2.0
; #MaxThreadsPerHotkey 2
#SingleInstance Force


open := false
F2:: {
    global open
    open := ~open
}

$Space:: {
    global open
    if (open) {
        Loop
        {
            state := GetKeyState("Space", "P")
            ; 长按的情况下触发
            if (A_TimeSinceThisHotkey > 300)
            {
                if (state) {
                    ; OutputDebug "连发"
                    Send "{Space}" 
                    Sleep 280
                } else {
                    OutputDebug "停止"
                    break
                }
            }
        }
    } else {
        ; OutputDebug "发一下"
        Send "{Space}"
    }

}