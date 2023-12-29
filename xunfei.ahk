#Requires AutoHotkey v2.0
#SingleInstance Force
KeyHistory 0
SetWorkingDir A_ScriptDir ; Ensures a consistent starting directory

SendMode "Input"
CoordMode "Mouse", "Screen"

sureAtWindow(winId) {
    WinWait winId
    if not WinActive(winId) {
        WinActivate winId
        WinWaitActive winId
    }

    Sleep 50
}


imagePath(imageName) {
    return A_ScriptDir "\imags-apply\" imageName
}

SetCursorPos(x, y) {
    DllCall("SetCursorPos", "int", x, "int", y)
}
; 点击增强版本。前后延迟，应对某些软件的点击失效。为了兼容性更好，推荐全部选择这款。不过，牺牲一点时间而异。
mouseClickBackForX(coordX, coordY) {
    BlockInput 1

    storeMouseCoordX := 0
    storeMouseCoordY := 0
    MouseGetPos &storeMouseCoordX, &storeMouseCoordY
    SetCursorPos(coordX, coordY)
    Sleep 300
    SendEvent "{Click}"
    Sleep 100
    BlockInput 0
}


; F1::sureAtWindow "ahk_exe iFlyVoice.exe"
1:: {
    OutputDebug "xx"
    WinGetClientPos &X, &Y, &W, &H, "ahk_exe iFlyVoice.exe"
    x := X
    y := Y
    a := X + W
    b := Y + H
    if (ImageSearch(&FoundX, &FoundY, x, y, a, b, "*20  *TransBlack " imagePath("xunfei_change.png"))) {
        OutputDebug "zzz"

        DllCall("SetCursorPos", "int", FoundX, "int", FoundY)


        ; mouseClickBackForX(FoundX, FoundY)
        sleep 500
        Click "D"   ;click,x,y
        sleep 40
        Click "U"
        ; clickXY(FoundX, FoundY)
        ; DllCall("SetCursorPos", "int", FoundX, "int", FoundY)
        ; Sleep 500
        ; Click
        ; Sleep 60
    }
}