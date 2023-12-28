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