#Requires AutoHotkey v2.0
#SingleInstance Force

; 自动提权到管理员
full_command_line := DllCall("GetCommandLine", "str")
if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
{
    try
    {
        Run '*RunAs "' A_ScriptFullPath '" /restart'
    }
    ExitApp
}

KeyHistory 0
SetWorkingDir A_ScriptDir ; Ensures a consistent starting directory
SendMode "Input"
CoordMode "Mouse", "Screen"

#Include %A_ScriptDir%\common.ahk
#Include %A_ScriptDir%\remove-blank-line.ahk
#Include %A_ScriptDir%\better-workflow.ahk
#Include %A_ScriptDir%\xunfei.ahk
#Include %A_ScriptDir%\wechat-star.ahk
#Include %A_ScriptDir%\user-config.ahk

return