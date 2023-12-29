#Requires AutoHotkey v2.0
#SingleInstance Force

KeyHistory 0
SetWorkingDir A_ScriptDir ; Ensures a consistent starting directory

SetMouseDelay 100
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
    path := A_ScriptDir "\imags-apply\" imageName
    ; path := A_ScriptDir "\imags-source\" imageName
    ; MsgBox path
    return path
}

SetCursorPos(x, y) {
    DllCall("SetCursorPos", "int", x, "int", y)
}

clickXY(x, y) {
    DllCall("SetCursorPos", "int", x, "int", y)
    Sleep 60
    Click
}


; F1::sureAtWindow "ahk_exe iFlyVoice.exe"

global cache_x := 0
global cache_y := 0
global cache_w := 0
global cache_h := 0
global cache_xunfei_change_x := 0
global cache_xunfei_change_y := 0
global cache_xunfei_putonghua_x := 0
global cache_xunfei_putonghua_y := 0
global cache_xunfei_suishengyi_x := 0
global cache_xunfei_suishengyi_y := 0

; 因为，窗口的特殊性，一般不进行移动。所以，对识别到的图片直接进行缓存。以提升下次使用的性能
toSimpleChinese() {
    CoordMode "Pixel", "Screen"

    sureAtWindow "ahk_exe iFlyVoice.exe"
    global cache_x
    global cache_y
    global cache_w
    global cache_h
    global cache_xunfei_change_x
    global cache_xunfei_change_y
    global cache_xunfei_putonghua_x
    global cache_xunfei_putonghua_y

    ; 缓存窗口位置，增强性能
    if (cache_x > 0) {
        x := cache_x
        y := cache_y
        a := cache_x + cache_w
        b := cache_y + cache_h
    } else {
        WinGetClientPos &X, &Y, &W, &H, "ahk_exe iFlyVoice.exe"

        cache_x := X
        cache_y := Y
        cache_w := W
        cache_h := H

        x := X
        y := Y
        a := X + W
        b := Y + H
    }

    ; CoordMode "Pixel", "Screen"
    ; 图片位置,也进行缓存

    xunfei_change_x := 0
    xunfei_change_y := 0

    if (cache_xunfei_change_x > 0) {
        xunfei_change_x := cache_xunfei_change_x
        xunfei_change_y := cache_xunfei_change_y
    } else {
        ; MsgBox x "xx" y "a:" a "b:" b
        if (ImageSearch(&FoundX, &FoundY, x, y, a, b, "*80  *TransBlack " imagePath("xunfei_change_gray.png"))) {
            cache_xunfei_change_x := FoundX
            cache_xunfei_change_y := FoundY

            xunfei_change_x := FoundX
            xunfei_change_y := FoundY

        } else if (ImageSearch(&FoundX, &FoundY, x, y, a, b, "*80  *TransBlack " imagePath("xunfei_change_blue.png"))) {
            ; 有时候，那个小图标会变成蓝色的。不易察觉。所以判断两次来找
            cache_xunfei_change_x := FoundX
            cache_xunfei_change_y := FoundY

            xunfei_change_x := FoundX
            xunfei_change_y := FoundY
        }
    }

    if (xunfei_change_x == 0) {
        MsgBox "没找到"
        OutputDebug "没找到change图标"
        return
    }

    OutputDebug "change找到了"

    clickXY(xunfei_change_x, xunfei_change_y)

    ; 稍微等待，一级列表展开
    ; Sleep 100
    Sleep 100
    ; 寻找文字
    ; 缩小寻找范围  ; 经过尝试，发现，弹出的列表，宽度小于，界面宽度。通常在左侧
    ; 这个范围，可以有效兼容，二级列表
    left_x := x - (1.5 * cache_w)
    left_y := 0
    right_a := x + (1.5 * cache_w)
    right_b := A_ScreenHeight

    xunfei_putonghua_x := 0
    xunfei_putonghua_y := 0
    if (cache_xunfei_putonghua_x > 0) {
        xunfei_putonghua_x := cache_xunfei_putonghua_x
        xunfei_putonghua_y := cache_xunfei_putonghua_y
    } else {
        ; 这里多加100，结合前面的100.相当于，点击之后，等待200ms，等列表出现。
        ; 因为，从观察上看到，在第一次找图的时候，列表的加载有点慢，容易导致找到位置。
        ; 而，我们采用缓存，所以，只需要在第一次的时候，等时间长一点，之后就不需要了。通过缓存的是100等待，通过识图（即第一次加载）是100+100等待
        Sleep 100
        if (ImageSearch(&p_FoundX, &p_FoundY, left_x, left_y, right_a, right_b, "*20  *TransBlack " imagePath("xunfei_putonghua.png"))) {
            cache_xunfei_putonghua_x := p_FoundX
            cache_xunfei_putonghua_y := p_FoundY
            xunfei_putonghua_x := p_FoundX
            xunfei_putonghua_y := p_FoundY
        }
    }

    if (xunfei_putonghua_x == 0) {
        ; MsgBox "没有找到普通话图标"
        OutputDebug "没找到普通话图标"
        return
    }

    clickXY(xunfei_putonghua_x, xunfei_putonghua_y)

}


toSuiShengYi() {
    CoordMode "Pixel", "Screen"

    sureAtWindow "ahk_exe iFlyVoice.exe"
    global cache_x
    global cache_y
    global cache_w
    global cache_h
    global cache_xunfei_change_x
    global cache_xunfei_change_y
    global cache_xunfei_suishengyi_x
    global cache_xunfei_suishengyi_y
    ; 缓存窗口位置，增强性能
    if (cache_x > 0) {
        x := cache_x
        y := cache_y
        a := cache_x + cache_w
        b := cache_y + cache_h
    } else {
        WinGetClientPos &X, &Y, &W, &H, "ahk_exe iFlyVoice.exe"

        cache_x := X
        cache_y := Y
        cache_w := W
        cache_h := H

        x := X
        y := Y
        a := X + W
        b := Y + H
    }

    ; CoordMode "Pixel", "Screen"
    ; 图片位置,也进行缓存

    xunfei_change_x := 0
    xunfei_change_y := 0

    if (cache_xunfei_change_x > 0) {
        xunfei_change_x := cache_xunfei_change_x
        xunfei_change_y := cache_xunfei_change_y
    } else {
        ; MsgBox x "xx" y "a:" a "b:" b
        if (ImageSearch(&FoundX, &FoundY, x, y, a, b, "*80  *TransBlack " imagePath("xunfei_change_gray.png"))) {
            cache_xunfei_change_x := FoundX
            cache_xunfei_change_y := FoundY

            xunfei_change_x := FoundX
            xunfei_change_y := FoundY

        } else if (ImageSearch(&FoundX, &FoundY, x, y, a, b, "*80  *TransBlack " imagePath("xunfei_change_blue.png"))) {
            ; 有时候，那个小图标会变成蓝色的。不易察觉。所以判断两次来找
            cache_xunfei_change_x := FoundX
            cache_xunfei_change_y := FoundY

            xunfei_change_x := FoundX
            xunfei_change_y := FoundY
        }
    }

    if (xunfei_change_x == 0) {
        MsgBox "没找到"
        OutputDebug "没找到change图标"
        return
    }

    OutputDebug "change找到了"

    clickXY(xunfei_change_x, xunfei_change_y)

    ; 稍微等待，一级列表展开
    Sleep 100
    ; 寻找文字
    ; 缩小寻找范围  ; 经过尝试，发现，弹出的列表，宽度小于，界面宽度。通常在左侧
    ; 这个范围，可以有效兼容，二级列表
    left_x := x - (1.5 * cache_w)
    left_y := 0
    right_a := x + (1.5 * cache_w)
    right_b := A_ScreenHeight

    xunfei_suishengyi_x := 0
    xunfei_suishengyi_y := 0
    if (cache_xunfei_suishengyi_x > 0) {
        xunfei_suishengyi_x := cache_xunfei_suishengyi_x
        xunfei_suishengyi_y := cache_xunfei_suishengyi_y
    } else {
        ; 关键细节
        Sleep 100
        if (ImageSearch(&FoundX, &FoundY, left_x, left_y, right_a, right_b, "*20  *TransBlack " imagePath("xunfei_suishengyi.png"))) {
            cache_xunfei_suishengyi_x := FoundX
            cache_xunfei_suishengyi_y := FoundY
            xunfei_suishengyi_x := FoundX
            xunfei_suishengyi_y := FoundY
        }
    }

    if (xunfei_suishengyi_x == 0) {
        OutputDebug "没找到普通话图标"
        return
    }

    clickXY(xunfei_suishengyi_x, xunfei_suishengyi_y)
}


bootXunFeiFloatWin() {
    if (PID := ProcessExist("iFlyVoice.exe")) {
    } else {
        global config_xunfei_location
        Run config_xunfei_location
        WinWait "ahk_exe iFlyVoice.exe"
    }
}

switchXunFeiFloatWin() {
    global config_xunfei_location
    if (PID := ProcessExist("iFlyVoice.exe")) {
        ProcessClose PID
    } else {
        Run config_xunfei_location
        WinWait "ahk_exe iFlyVoice.exe"
    }
}

; ----------------------------------------

global config_xunfei_location := '"C:\ProgramData\Microsoft\Windows\Start Menu\Programs\讯飞输入法\语音悬浮窗.lnk"'

; --
1:: {
    bootXunFeiFloatWin
    toSimpleChinese
}

2:: {
    bootXunFeiFloatWin
    toSuiShengYi
}

3:: switchXunFeiFloatWin