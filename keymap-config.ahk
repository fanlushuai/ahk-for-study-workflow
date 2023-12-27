#SuspendExempt
CapsLock:: Suspend
#SuspendExempt False

5:: SendX "{WheelDown 1}"
6:: inputAndEnter "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
0:: inputAndEnter "1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1"
9:: inputAndEnter "2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2"

`:: copyTextSelected


~^LButton:: {
    ; 等待左键弹起。超时时间30s
    if KeyWait("LButton", "T30") {
        Send "^c"
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