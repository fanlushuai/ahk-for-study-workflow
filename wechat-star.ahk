#Requires AutoHotkey v2.0
#SingleInstance Force
KeyHistory 0
SetWorkingDir A_ScriptDir ; Ensures a consistent starting directory

SendMode "Input"
CoordMode "Mouse", "Screen"

global exitStar := true

stopWechatStar() {
    global exitStar := true
}

wechatStar() {
    global exitStar := false

    CoordMode "Mouse", "Screen"

    sureAtWindow "朋友圈"
    Sleep 300

    WinGetClientPos &X, &Y, &W, &H, "朋友圈"

    ; 搜索的坐标范围（x1,y1）-(a,b)
    x := X
    y := Y + 40 ; 缩小范围。防止，在滚动的过程中。moment太靠近顶部，导致误点触
    a := X + W
    b := Y + H - 40 ; 缩小范围。 原因同上

    maxTimes := 40
    counter := 0

    while (counter < maxTimes) {
        if exitStar {
            MsgBox "收到，已撤退", , "Iconi T1.2"
            return
        }


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

        ; 鼠标光标，在界面内。不然就阻塞住，并且光标在目标软件上面。
        ;-30的迷惑行为，原因：xy，坐标不是特别准，在边缘地带，容易导致程序自动停止。所以，扩在范围，来终结影响。
        while (!mouseInRange(X, X + W, Y - 30, Y + H) or getProcessNameAtMousePos() != "WeChat.exe") {
            Sleep 1000
        }

        Send "{ WheelDown 6 }"
        Sleep 300
        counter++
    }

    MsgBox "点赞的活 ~ 干完了 ~~~", , "Iconi T1.2"
}

