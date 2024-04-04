#Requires AutoHotkey v2.0
#MaxThreadsPerHotkey 2 
#SingleInstance Force

open := false

F2:: {
    global open
    open := ~open
    doIt()
} 

doIt() {
    global open
    loop {
        if (!open) {
            break
        }

        Send "{Space}"
        Sleep 280   
    }

}