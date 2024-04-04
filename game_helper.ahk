#Requires AutoHotkey v2.0
#SingleInstance Force
KeyHistory 0

class ConfigManager {

    configFileName := "config.ini"

    ; 内存属性
    configs := []

    ; 初始化，加载配置
    syncConfigsFileToMemory() {
        ; 加载配置到内存
        this.configs := IniRead(this.configFileName)

    }

    ; 显示配置
    showConfigs() {
        configGui := Gui(, "配置面板")
        configGui.Add("Text", , "------------------>>> 当前配置 <<<------------------")
        configGui.Add("Text", , "【按键】-【坐标】-【颜色】")

        ; 编列对象

        Loop this.configs.Length {
            c:=this.configs[A_Index]
            configGui.Add("Text", , "【"+c.k+"】-【坐标】-【颜色】")
            configGui.Add("Button","default" , "删除").OnEvent("Click", bindKeyFunc)


        }


        bindKeyFunc(thisGui, *){
            configGui.Opt("+Disabled")
            thisGui.Text

        }

    }

    ; 删除配置
    deleteConfig(keySection) {
        IniDelete this.configFileName, keySection
        this.syncConfigsFileToMemory()
    }

    ; 生成一条配置数据
    genOneConfig() {
        ; 取坐标
        mouseCoordX := 0
        mouseCoordY := 0
        windowId := 0
        control := 0
        MouseGetPos &mouseCoordX, &mouseCoordY, &windowId, &control

        ; 取色
        ; 返回一个十六进制数字字符串
        color := PixelGetColor(mouseCoordX, mouseCoordY)

        ; 取进程

        storeProcessName := WinGetProcessName(windowId)

        ; 取按键, 弹出框提示输入，确定。就保存。
        ;
        IB := InputBox("输入绑定的按键", "w100 h100")
        if IB.Result == "OK" {
            config := {}
            config.p = storeProcessName
            config.x = mouseCoordX
            config.y = mouseCoordY
            config.c = color
            config.k = "//todo"

            IniWrite config.x, this.configFileName, config.k, "x"
            IniWrite config.p, this.configFileName, config.k, "p"
            IniWrite config.y, this.configFileName, config.k, "y"
            IniWrite config.c, this.configFileName, config.k, "c"
            IniWrite config.k, this.configFileName, config.k, "k"

            this.syncConfigsFileToMemory()
        }

    }

}

; a. 初始化配置
cm := ConfigManager
cm.syncConfigsFileToMemory()


; b. 绑定按键

; 绑定，配置操作
^!1:: {
    cm.genOneConfig()
}

; 绑定，游戏顺序编列按键操作
buttonX1:: {
    ; 绑定按键，按下触发，弹起，停止。
    ; 遍历集合中的元素对象
    Loop cm.configs.Length {
        config := cm.configs[A_Index]
        if (PixelGetColor(config.x, config.y) == config.c) {
            Send config.k
        }
    }

}