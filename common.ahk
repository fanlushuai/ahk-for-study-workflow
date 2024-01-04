#Requires AutoHotkey v2.0


; 参考： https://www.autohotkey.com/boards/viewtopic.php?t=97706  鼠标坐标，在多分辨率，多屏幕，多缩放小的问题。
clickXY(x, y) {
    DllCall("SetCursorPos", "int", x, "int", y)
    Sleep 60
    Click
}


SetCursorPos(x, y) {
    DllCall("SetCursorPos", "int", x, "int", y)
}

getProcessNameAtMousePos() {
    ; 存储刚才的光标位置
    storeMouseCoordX := 0
    storeMouseCoordY := 0
    storeWindowId := 0
    control := 0
    MouseGetPos &storeMouseCoordX, &storeMouseCoordY, &storeWindowId, &control

    storeProcessName := WinGetProcessName(storeWindowId)
    return storeProcessName
}


mouseInRange(x, a, y, b) {
    MouseGetPos &mouseCoordX, &mouseCoordY, &storeWindowId, &control
    return mouseCoordX > x and mouseCoordX < a and mouseCoordY > y and mouseCoordY < b
}


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