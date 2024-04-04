#Requires AutoHotkey v2.0
#SingleInstance Force
#MaxThreadsPerHotkey 2

Space:: {
    Loop
    {
        state := GetKeyState("Space", "P")
        if (state) {
            Send "{Space}"
            Sleep 280
        } else {
            break
        }

    }
}

F2:: ExitApp