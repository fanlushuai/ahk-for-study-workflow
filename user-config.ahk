#Requires AutoHotkey v2.0

; -------------------------------- remove-blank-line


#HotIf WinActive("ahk_exe winword.exe") or WinActive("ahk_exe wps.exe") or WinActive("ahk_exe code.exe")

; 删除选中文本。先选中，再调用
^+s:: {
    removeBlankLineOnSelected()
}

F4:: {
    Send "^a"   ;自动帮助用户选中
    removeBlankLineOnSelected()
}

; trimOneBlankLine 没有用武之地，不开森

#HotIf

; --------------------------------better-workflow

#SuspendExempt
CapsLock:: Suspend
#SuspendExempt False

5:: SendX "{WheelDown 1}"
6:: inputAndEnter "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
0:: inputAndEnter "1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1"
9:: inputAndEnter "2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2"

`:: copyTextSelected


; ~^LButton:: {
;     ; 等待左键弹起。超时时间30s
;     if KeyWait("LButton", "T30") {
;         Send "^c"
;     }
; }

; 长按，复制粘贴。
~LButton:: {
    ; 长按时间，只有至少为这个时间，功能才会启动。单位秒
    longPressMinTime := "1.0"

    ; 记录光标初始位置：
    clickDownPosX := 0
    clickDownPosY := 0
    MouseGetPos &clickDownPosX, &clickDownPosY, &winId, &control

    if KeyWait("LButton", "T" . longPressMinTime) {

    } else {
        ; 超时处理
        ; 等待左键弹起。超时时间 s
        if KeyWait("LButton", "T10") {

            ; 判断光标位置是否变化
            clickUpPosX := 0
            clickUpPosY := 0
            MouseGetPos &clickUpPosX, &clickUpPosY, &winId, &control

            ; 坐标没有变化，范围是空的。
            range0 := (clickDownPosX == clickUpPosX && clickDownPosY == clickUpPosY)

            if (!range0) {
                Send "^c"
            } else {
                Send "^v"
            }
        }
    }
}


7:: sureAtChrome

3:: wechatStar
^3:: stopWechatStar

F2:: translateSelectionByGoogleWeb
#HotIf WinActive("ahk_exe chrome.exe")
F3:: translatePageAllOnChrome
#HotIf

F4:: copySelectionToWordBottom
4:: copySelectionToWordTop

F1:: searchSelectionOnWeb
+F2:: searchSelectionOnWord

; --------------------------------xunfei


global config_xunfei_location := '"C:\ProgramData\Microsoft\Windows\Start Menu\Programs\讯飞输入法\语音悬浮窗.lnk"'
global config_xunfei_key_startVoice := "{F10}"

1:: {
    bootXunFeiFloatWin
    toSimpleChinese
    startInputVoice
}

2:: {
    bootXunFeiFloatWin
    toSuiShengYi
    startInputVoice
}


3:: switchXunFeiFloatWin

4:: useSuiShengYiOf "cn2en"

5:: useSuiShengYiOf "cn2yue"

; 如果，浮动窗口，自己给他改变位置了。 发现，脚本点击不到了。
; 那么需要清理一下缓存。 将下面的函数绑定即可。
; 或者，直接重启脚本
; 4::clearCache


