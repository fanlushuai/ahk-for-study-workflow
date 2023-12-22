#SuspendExempt
CapsLock:: Suspend
#SuspendExempt False

5:: SendX "{WheelDown 1}"
6:: inputAndEnter "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
0:: inputAndEnter "1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1"
9:: inputAndEnter "2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2"

`:: copyTextSelected
7:: sureAtChrome
3:: wechatStar

F2:: translateSelectionByGoogleWeb
#HotIf WinActive("ahk_exe chrome.exe")
F3:: translatePageAllOnChrome
#HotIf

F4:: copySelectionToWordBottom
4:: copySelectionToWordTop

F1:: searchSelectionOnWeb
+F2:: searchSelectionOnWord

