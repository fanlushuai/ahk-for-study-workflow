#Requires AutoHotkey v2.0
#SingleInstance Force
KeyHistory 0
SetWorkingDir A_ScriptDir ; Ensures a consistent starting directory

SendMode "Input"
CoordMode "Mouse", "Screen"

trimAllBlankLineInClipboard() {
    text := A_Clipboard
    text := StrReplace(text, "`r`n`r`n", "`r`n")
    text := StrReplace(text, "`r`n", "`r`n")
    newContent := ""
    Loop parse, text, "`n", "`r"
    {
        line := A_LoopField
        lineTrim := Trim(line)
        if (lineTrim != "")
            ; newContent .= A_LoopField "`r`n"
            newContent .= lineTrim "`r`n"
    }
    A_Clipboard := newContent
    Sleep 10
    return newContent
}

copyTextSelected() {
    A_Clipboard := ""
    Sleep 10

    Send "^c"
    ClipWait(2)    ; 最多等待 x s
    ; if !ClipWait(2)    ; 最多等待 x s
    ; {
    ;     MsgBox "操作需要先选中了文本", , "Iconi T1.2"
    ;     return
    ; }

    return A_Clipboard
}

; 参考： https://www.autohotkey.com/boards/viewtopic.php?t=97706  鼠标坐标，在多分辨率，多屏幕，多缩放小的问题。
clickXY(x, y) {
    DllCall("SetCursorPos", "int", x, "int", y)
    Sleep 60
    Click
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

SendX(key, time := 50) {
    Send key
    Sleep time
}

sureAtWindow(winId) {
    WinWait winId
    if not WinActive(winId) {
        WinActivate winId
        WinWaitActive winId
    }

    Sleep 50
}

sureAtChrome() {
    sureAtWindow "ahk_exe chrome.exe"
}

sureAtWord() {
    ; sureAtWindow "ahk_exe winword.exe"  ;//todo 解开注解，正式环境
    sureAtWindow "ahk_exe wps.exe"
}

imagePath(imageName) {
    return A_ScriptDir "\imags-apply\" imageName
}

waitForImage(&outputX, &outputY, x, y, a, b, image, maxTime, timePer) {
    ; 时间戳，貌似不好整。就用这种方案吧
    timePass := 0
    while (timePass < maxTime) {
        Sleep timePer
        timePass += timePer
        if (ImageSearch(&outputX, &outputY, x, y, a, b, image)) {
            return true
        }
        OutputDebug "没找到"
    }
    return false
}


wechatStar() {
    CoordMode "Mouse", "Screen"

    sureAtWindow "朋友圈"
    Sleep 300

    WinGetClientPos &X, &Y, &W, &H, "朋友圈"

    ; 搜索的坐标范围（x1,y1）-(x2,y2)
    x := X
    y := Y + 40 ; 缩小范围。防止，在滚动的过程中。moment太靠近顶部，导致误点触
    a := X + W
    b := Y + H - 40 ; 缩小范围。 原因同上

    maxTimes := 40
    counter := 0

    while (counter < maxTimes) {
        CoordMode "Pixel", "Screen"
        Sleep 100

        ; 查找 。。图标
        if ImageSearch(&FoundX, &FoundY, x, y, a, b, "*20  *TransBlack " imagePath("wechat_friend_moment.png")) {
            ; MsgBox FoundX . "找到了！moment！" . FoundY
            clickXY(FoundX, FoundY)
            Sleep 300

            if ImageSearch(&FoundX, &FoundY, x, y, a, b, "*20  *TransBlack " imagePath("wechat_friend_star.png")) {
                ; MsgBox FoundX . "找到了！star！" . FoundY
                clickXY(FoundX, FoundY)
                ; Sleep 300*1000
                Sleep 300
            } else {
                ; MsgBox "没找到点赞,可能已经点赞过了，或者图标识别错误"
            }
        } else {
            ; MsgBox "no find"
        }

        CoordMode "Mouse", "Screen"
        Sleep 100

        ; 鼠标光标，在界面内。不然就阻塞住
        MouseGetPos &mouseCoordX, &mouseCoordY, &storeWindowId, &control
        mouseInWin := mouseCoordX > X and mouseCoordX < X + W and mouseCoordY > Y - 30 and mouseCoordY < Y + H
        ;-30的迷惑行为，原因：xy，坐标不是特别准，在边缘地带，容易导致程序自动停止。所以，扩在范围，来终结影响。

        while (!mouseInWin or getProcessNameAtMousePos() != "WeChat.exe") {
            Sleep 1000

            MouseGetPos &mouseCoordX, &mouseCoordY, &storeWindowId, &control
            mouseInWin := mouseCoordX > X and mouseCoordX < X + W and mouseCoordY > Y - 30 and mouseCoordY < Y + H
        }

        Send "{ WheelDown 6 }"
        Sleep 300
        counter++
    }

    MsgBox "点赞的活 ~ 干完了 ~~~", , "Iconi T1.2"
}

translateSelectionByGoogleWeb() {

    copyTextSelected

    sureAtChrome

    WinGetClientPos &X, &Y, &W, &H, "ahk_exe chrome.exe"
    x := X
    y := Y
    a := X + W
    b := Y + H

    SendX "^1" 100  ; 到第1个tab(是Google翻译)
    CoordMode "Pixel", "Screen"

    ; focus
    Sleep 100
    if ImageSearch(&FoundX, &FoundY, x, y, a, b, "*20  *TransBlack " imagePath("translate_wordsLimit.png")) {
        ; MsgBox FoundX . FoundY
        yUp := FoundY - 40  ; 向上一点，更接近输入框内部。防止点击的位置不准确，在边缘点击，出现失效。
        clickXY(FoundX, yUp)
        Sleep 20

        ; 覆盖内容
        SendX "^a"
        SendX "^v"

        ; 这个图标的变化，只能代表，翻译文本的响应。并不能代表语音接口的响应。所以，这个等待，只能说，差点意思。
        waitForImage(&FoundX, &FoundY, x + W / 2 - 40, y, a, b, "*1  *TransBlack " imagePath("translate_ok.png"), 1501, 300)

        if (ImageSearch(&FoundX, &FoundY, x + W / 2, y, a, b, "*20  *TransBlack " imagePath("translate_speek.png"))) {
            Sleep 50  ; 目前，可调的就这个位置。如果出现时序错乱的话。
            clickXY(FoundX, FoundY)
        }

    }

    CoordMode "Mouse", "Screen"
}

translatePageAllOnChrome() {
    ; 以下方式：任选一种
    ; 1. Ctrl + Shift + L（Windows）/ Command + Shift + L（Mac）：这是Google Chrome浏览器的默认快捷键。按下这个组合键后，浏览器会自动检测当前网页的语言，并将其翻译成你的首选语言。
    ; SendX "^+l"

    ; 2. 鼠标右键，按t。https://github.com/brookhong/Surfingkeys/issues/673
    MouseClick "right"
    Sleep 50
    Send "t"
}
copySelectionToWordTop() {

    copyTextSelected
    trimAllBlankLineInClipboard

    processNameForBack := getProcessNameAtMousePos()

    sureAtWord

    ; 软件可能做了按键的粘滞检查。不可以直接用 SendX  "^{Home}"
    SendInput "{Ctrl Down}{Home Down}"
    Sleep 50
    SendInput "{Ctrl Up}{Home Up}"

    SendX "^v"      ; 粘贴
    SendX "{Enter}"  ; 两次换行
    SendX "{Enter}"

    ; sureAtChrome
    sureAtWindow "ahk_exe " . processNameForBack
}
copySelectionToWordBottom() {
    copyTextSelected
    trimAllBlankLineInClipboard

    processNameForBack := getProcessNameAtMousePos()

    sureAtWord

    ; 软件可能做了按键的粘滞检查。不可以直接用 SendX "^{End}"
    SendInput "{Ctrl Down}{End Down}"
    Sleep 50
    SendInput "{Ctrl Up}{End Up}"

    SendX "{Enter}"
    SendX "^v"

    ; sureAtChrome
    sureAtWindow "ahk_exe " . processNameForBack
}

searchSelectionOnWeb() {

    copyTextSelected

    processNameForBack := getProcessNameAtMousePos()
    sureAtChrome

    SendX "^t"
    SendX "^v"
    SendX "{Enter}"

    ; sureAtWord
    sureAtWindow "ahk_exe " . processNameForBack ; 前面获取鼠标指针处进程。再次回到那里。更加通用！
}

searchSelectionOnWord() {

    SendX "^c"

    sureAtWord
    SendX "^f"

    ; 进行覆盖操作。防止上次操作对话框还在。导致内容进行了追加。
    SendX "^a"
    SendX "^v"

    SendX "{Enter}" ; 让他自己查找一个吧

}
; ====================================键位-功能-映射=======================================

;挂起，这样脚本不用工作。CapsLock靠近手指，方便操作。
#SuspendExempt
CapsLock:: Suspend
#SuspendExempt False

; 切到chrome
7:: sureAtChrome

;自由选择内容复制，利用左键的状态，【讨论？】
`:: copyTextSelected

; 划词翻译 【ok】
F2:: translateSelectionByGoogleWeb

#HotIf WinActive("ahk_exe chrome.exe")
; 翻译整个网页    chrome中   中文翻译成英文的？估计可以在chrome设置一下【讨论？】
F3:: translatePageAllOnChrome
#HotIf

; 文字收集器，追加到文档末尾。 全部搜集到word 【ok】【微调……】
F4:: copySelectionToWordBottom

; 文字收集器，追加到文档首部。 全部搜集到word 【ok】【微调……】
4:: copySelectionToWordTop

;View More 【ok】
5:: SendX "{WheelDown 1}"

F1:: searchSelectionOnWeb ; 网络搜索 选中内容 【ok】

+F2:: searchSelectionOnWord ; word中搜索 选中内容 【ok】

3:: wechatStar  ; 微信点赞桌面版本。操作说明：1. 需要打开，微信朋友圈。2. 光标离开界面，点赞动作，休眠。光标回归，点赞继续。【ok】

; #HotIf WinActive("ahk_exe wps.exe") or WinActive("ahk_exe winword.exe")

;发送分隔线  【ok】
6:: {
    SendText "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
    Send "{Enter}"
}

; 【ok】
0:: {
    SendText "1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1"
    Send "{Enter}"
}

; 【ok】
9:: {
    SendText "2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2"
    Send "{Enter}"
}

; #HotIf

