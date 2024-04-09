#Requires AutoHotkey v2.0
#SingleInstance Force
SetWorkingDir A_ScriptDir
#Include %A_ScriptDir%/UIA.ahk

; load config
global configfileName := "apnConfig.ini"
global config := {}
config.profileName := IniRead(configfileName, "apn", "profileName", "")
config.apnName := IniRead(configfileName, "apn", "apnName", "")
config.userName := IniRead(configfileName, "apn", "userName", "")
config.password := IniRead(configfileName, "apn", "password", "")
config.loginType := IniRead(configfileName, "apn", "loginType", "")
config.ipType := IniRead(configfileName, "apn", "ipType", "")
config.apnType := IniRead(configfileName, "apn", "apnType", "")

; open windows settings
send "#i"
Sleep 1500

; click step by step
ApplicationFrameHostEl := UIA.ElementFromHandle("Definições ahk_exe ApplicationFrameHost.exe")
ApplicationFrameHostEl.ElementFromPath("X/QXYR7s").Click()
ApplicationFrameHostEl.ElementFromPath("X/QY87qRK").Click("left")
ApplicationFrameHostEl.ElementFromPath("X/QR/Y87R/0").ScrollIntoView()
ApplicationFrameHostEl.ElementFromPath("X/QR/Y87R/0").Click()
; find whether has configed //todo fix it
; try
; {
;     ApplicationFrameHostEl.FindElement({ Name: config.profileName }).see(0)
;     MsgBox "has added"
;     ExitApp
; } catch {
; }
; add apn
ApplicationFrameHostEl.ElementFromPath("X/QR/YR0").Click("left")

; input apn info
Sleep 300
ApplicationFrameHostEl.ElementFromPath("X/X/YY4").SetFocus()
ApplicationFrameHostEl.ElementFromPath("X/X/YY4").Value := config.profileName
ApplicationFrameHostEl.ElementFromPath("X/X/YY4q").SetFocus()
ApplicationFrameHostEl.ElementFromPath("X/X/YY4q").Value := config.apnName
ApplicationFrameHostEl.ElementFromPath("X/X/YY4/").SetFocus()
ApplicationFrameHostEl.ElementFromPath("X/X/YY4/").Value := config.userName
ApplicationFrameHostEl.ElementFromPath("X/X/YYR4").SetFocus()
ApplicationFrameHostEl.ElementFromPath("X/X/YYR4").Value := config.password

; click option 1
ApplicationFrameHostEl := UIA.ElementFromHandle("Definições ahk_exe ApplicationFrameHost.exe")
ApplicationFrameHostEl.ElementFromPath("X/X/YY3").Click()
; Sleep 300

switch config.loginType {
    case "PAP":
        OutputDebug "pap"
        ApplicationFrameHostEl.ElementFromPath("X/X/YY37q").Click("left")
    case "CHAP":
        OutputDebug "CHAP"
        ApplicationFrameHostEl.ElementFromPath("X/X/YY37r").Click("left")
    case "Nenhum":
        OutputDebug "Nenhum"
    case "MS-CHAP v2":
        OutputDebug "MS-CHAP v2"
        ApplicationFrameHostEl.ElementFromPath("X/X/YY37/").Click("left")
    default:
        ; MsgBox "please check your loginType config"
        ; Exit
}

;Sleep 300
; click option 2
ApplicationFrameHostEl.ElementFromPath("X/X/YY3q").Click()
PredeFini := "X37"
; Sleep 500
OutputDebug "`n"
switch config.ipType {
    case "IPv4":
        OutputDebug "IPv4"
        ApplicationFrameHostEl.ElementFromPath("X/X/YY3q7q").Click("left")
    case "IPv6":
        OutputDebug "IPv6"
        ApplicationFrameHostEl.ElementFromPath("X/X/YY3q7r").Click("left")
    case "IPv4v6":
        OutputDebug "IPv4v6"
        ApplicationFrameHostEl.ElementFromPath("X/X/YY3q7/").Click("left")
    case "IPv4v6LAT":
        OutputDebug "IPv4v6LAT"
        ApplicationFrameHostEl.ElementFromPath("X/X/YY3q7/").Click("left")
    default:
        ; MsgBox "please check your ipType config"
        ; Exit
}


; click option 3
; Sleep 500
ApplicationFrameHostEl.ElementFromPath("X/X/YY3/7").Click("left")
OutputDebug "`n"
switch config.apnType {
    case "Internet":
        OutputDebug "Internet"
        ApplicationFrameHostEl.ElementFromPath("X/X/YY3/7").Click("left")
    case "Internet e":
        OutputDebug "Internet e"
        ApplicationFrameHostEl.ElementFromPath("X/X/YY3/7q").Click("left")
    case "Anexa":
        OutputDebug "Anexa"
        ApplicationFrameHostEl.ElementFromPath("X/X/YY3/7/").Click("left")
    default:
        ; MsgBox "please check your loginType config"
        ; Exit
}

; save
ApplicationFrameHostEl.ElementFromPath("X/X/0").Click()

; close windows settings
; Sleep 500
ApplicationFrameHostEl.ElementFromPath("X0/").Click()
