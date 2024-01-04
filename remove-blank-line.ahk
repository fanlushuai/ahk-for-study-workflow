#Requires AutoHotkey v2.0

getTextSelected() {
    A_Clipboard := ""
    Sleep 10

    Send "^c"
    Sleep 10
    if !ClipWait(2)    ; 最多等待 x s
    {
        MsgBox "剪切板操作失败。确保您选中了文本"
        return
    }

    return  A_Clipboard
}


paste(text) {
    A_Clipboard := text

    Sleep 10
    Send "^v"
}

trimOneBlankLine(text) {
    text := StrReplace(text, "`r`n`r`n", "`r`n")
    text := StrReplace(text, "`r`n", "`r`n")
    text := StrReplace(text, "`n`n", "`r`n")
    text := StrReplace(text, "`r", "")

    return text
}


trimAllBlankLine(text) {
    text := StrReplace(text, "`r`n`r`n", "`r`n")
    text := StrReplace(text, "`r`n", "`r`n")
    newContent := ""
    Loop parse, text, "`n", "`r"
    {
        line := A_LoopField
        lineTrim := Trim(line)
        if (lineTrim != "")
            newContent .= A_LoopField "`r`n"
    }
    return newContent
}

removeBlankLineOnSelected(){
    text := getTextSelected()
    text := trimAllBlankLine(text)
    paste(text)
}
