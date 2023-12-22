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
6:: line "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"

; 【ok】
0:: line "1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1"

; 【ok】
9:: line "2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2"

; #HotIf