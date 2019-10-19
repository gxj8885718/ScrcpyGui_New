#NoEnv
#SingleInstance Force
;Random, , NewSeed
Random, Rand , 1000, 9999
SetWorkingDir %A_ScriptDir%
SettingDir:=A_AppData . "\ScrcpyGui"
Version:=0.1
Changelog=
 (
可用：
   ·连接手机
   ·菜单中的设置选项
   ·镜像配置中的部分设置选项
   ·连接设备后自动隐藏主窗口
   ·打开主程序自动连接上次连接成功设备
暂未实现：
   ·WiFi连接设备
   ·刷新/自动发现设备
   ·镜像配置中部分菜单未实质可用
   ·镜像配置菜单未设保存功能（仅当此可用）
   ·已有scrcpy实例运行时的处理
   ·其他还有很多问题
    )
gosub initdefaultsettings

;--------------------------------------菜单栏------------------------------------
Menu, FileMenu, Add, 退出(&X), FileExit
Menu, SettingsMenu, Add, 显示提示(&T), SwitchTips
Menu, SettingsMenu, Add, 自动隐藏至任务栏(&H), HideToTray
Menu, SettingsMenu, Add, 启动程序时自动尝试打开最近设备(&A), AutoStart
Menu, SettingsMenu, Add, 打开配置文件（高级）(&O), OpeniniFile
Menu, HelpMenu, Add, 更新日志(&L), ShowUpdateLog
Menu, HelpMenu, Add, 帮助(&H), Help
Menu, HelpMenu, Add, 关于(&A), About
Menu, MyMenuBar, Add, 文件(&F), :FileMenu
Menu, MyMenuBar, Add, 设置(&S), :SettingsMenu
Menu, MyMenuBar, Add, 关于(&A), :HelpMenu
Menu, SettingsMenu, %TipsStatus%, 显示提示(&T), SwitchTips
Menu, SettingsMenu, %AutoHideStatus%, 自动隐藏至任务栏(&H), HideToTray
Menu, SettingsMenu, %ConnectLastStatus%, 启动程序时自动尝试打开最近设备(&A), AutoStart
Gui, Menu, MyMenuBar
Menu, Tray, Add, 显示/隐藏窗口, ShowMainWindow
Menu, Tray, Default , 显示/隐藏窗口
;--------------------------------------主窗口------------------------------------
Gui -MaximizeBox -DPIScale
Gui Add, Tab3, , 镜像管理|镜像配置|结果输出
Gui, Add, StatusBar,, 
Gui Tab, 1
Gui Add, GroupBox,x30 y30 w500 h100 , 连接管理
Gui Add, Radio, x40 y60 w70 h23 Group vConnectMethod gChangeConnectMethod, 网络连接
Gui Add, Radio, x40 y+10 w70 h23 Checked gChangeConnectMethod, USB连接
Gui Add, Edit, x110 y60 w150 h21 vAddress HwndAddressHwnd, %LastWiFiAddress%
Gui Add, Button, x110 y+10 w80 h23 gListDevices, 刷新
Gui Add, GroupBox,x30 y160 w500 h240 , 设备清单
Gui Add, ListView, x35 y180 r5 w450 Checked -Multi NoSort gOperationProcess, |ID|连接方式|连接状态|备注

Gui Add, Button, x40 y450 w80 h23 gOpensession, 双击设备连接
Gui Add, Button, x230 y450 w80 h23 gtest, 测试

Gui Tab, 2
Gui Add, Text, x30 y30 w120 h23 +0x200 Right, 窗口标题
Gui Add, Edit, x+50 yp w120 h21 vTitle HwndTitleHwnd gApply, %Title%
Gui Add, CheckBox, x30 y+10 w120 h23 visRecord Checked%isRecord% gApply Right, 镜像录屏
Gui Add, CheckBox, x+50 yp w120 h23 vMirrorWhenRecording Checked%MirrorWhenRecording% %MirrorWhenRecordingStatus% gApply, 录屏时打开镜像
Gui Add, Text, x30 y+10 w120 h23 +0x200 Right, 录屏文件路径
Gui Add, Edit, x+50 yp w120 h21 vRecordingfilePath %MirrorWhenRecordingStatus% HwndFilePathHwnd gApply, %RecordingfilePath%
Gui Add, Text, x30 y+10 w120 h23 +0x200 Right, 镜像传输比特率
Gui Add, Slider, x+50 yp w120 h32, 50
Gui Add, Edit, x+20 yp w50 h21 gApply,
Gui Add, UpDown, vBitrate gApply Range1000-10000, %Bitrate%
Gui Add, Text, x30 y+10 w120 h23 +0x200 Right, 等比最大分辨率
Gui Add, Slider, x+50 yp w120 h32, 50
Gui Add, Edit, x+20 yp w50 h21 gApply,
Gui Add, UpDown, vMaxsize gApply Range0-1920, %Maxsize%
Gui Add, Text, x30 y+10 w120 h23 +0x200 Right, 剪切屏幕
Gui Add, Edit, x+50 yp w120 h21 vcutScreenWidth gApply, %cutScreenWidth%
Gui Add, Edit, x+30 yp w120 h21 vcutScreenHeight gApply, %cutScreenHeight%
Gui Add, Edit, x200 y+10 w120 h21 vcutScreenX gApply, %cutScreenX%
Gui Add, Edit, x+30 yp w120 h21 vcutScreenY gApply, %cutScreenY%
Gui Add, Text, x30 y+10 w120 h23 +0x200 Right, 其他设置
Gui Add, CheckBox, x+50 yp h23 vAlwaysOnTop Checked%AlwaysOnTop% gApply, 窗口置顶
Gui Add, CheckBox, x+50 yp h23 vComputerControl Checked%ComputerControl% gApply, 电脑控制（取消勾选仅查看）
Gui Add, CheckBox, x200 y+10 w120 h23 vShowTaps Checked%ShowTaps% gApply, 显示手机点按位置
Gui Add, CheckBox, xp y+10 w187 h23 vRenderingALL Checked%RenderingALL% gApply, 渲染所有帧（会增加延迟）
Gui Add, CheckBox, xp y+10 w199 h23 vTurnOFFScreen Checked%TurnOFFScreen% gApply, 打开镜像时关闭手机屏幕
Gui Add, Edit, x30 y450 w300 h23 vShowfinalparameter, %finalparameter%

Gui Tab, 3
Gui Add, edit, vResultShow, All result will shown here./n123/n123/n123/n13/n123
Gui Show, w600 h500, ScrcpyGui %Version%
DllCall("SendMessage", "Ptr", AddressHwnd, "UInt", 0x1501, "Ptr", 1, "Str", "域名、IP等均可")
DllCall("SendMessage", "Ptr", TitleHwnd, "UInt", 0x1501, "Ptr", 1, "Str", "默认为手机型号")
SB_SetText("GUI加载完成")

if (ExistVersion<Version)
{
    msgbox , , 更新日志, % Changelog
    IniWrite, %Version%, %SettingDir%\settings.ini, Section, ExistVersion
} ;检查版本并弹出更新日志（仅一次）

;if Lastconnectstate
;{
;    gosub, USBconnect
;} else {
;    gosub, WiFiconnect
;} ;使用上次连接方式
gosub, ListDevices
;2019-10-19 不要自动初始化adb

if (ConnectLast&&LastDevices!="")
{
    gosub Opensession
} ;设置自动连接上次连接成功设备后自动连接


return
;------------------------菜单栏响应相关-------------------------
FileExit:
    ExitApp

SwitchTips:
    Menu, SettingsMenu, ToggleCheck, 1&
    EnableTips:=1-EnableTips
    IniWrite, %EnableTips%, %SettingDir%\settings.ini, Section, EnableTips
    Return ;开关提示并写入设置文件

HideToTray:
    Menu, SettingsMenu, ToggleCheck, 2&
    AutoHide:=1-AutoHide
    IniWrite, %AutoHide%, %SettingDir%\settings.ini, Section, AutoHide
    Return

AutoStart:
    Menu, SettingsMenu, ToggleCheck, 3&
    ConnectLast:=1-ConnectLast
    IniWrite, %ConnectLast%, %SettingDir%\settings.ini, Section, ConnectLast
    if ConnectLast
    {
        if EnableTips
        {
            if (LastDevices="")
            {
                TrayTip , 提示, 已设置启动时自动连接。`n目前未发现已成功连接设备，连接成功将自动记录，下次打开软件时将自动连接。`n禁用提示即可永久隐藏本提示。（菜单栏-设置-显示提示）, 5,
            } else {
                TrayTip , 提示, 已设置启动时自动连接。`n打开软件时将自动连接ID为%LastDevices%的设备。`n禁用提示即可永久隐藏本提示。（菜单栏-设置-显示提示）, 5,
            }
        }
    } else {
        TrayTip , 提示, 已关闭启动时自动连接。`n禁用提示即可永久隐藏本提示。（菜单栏-设置-显示提示）, 5,
    }
    Return

OpeniniFile:
    run, %SettingDir%\settings.ini
    Return ;待增加检测修改并重新加载功能

ShowUpdateLog:
    msgbox , , 更新日志, % Changelog
    Return

Help:
    Help_Shortcuts=
    (
快捷键:
    Ctrl+f：切换全屏模式
    Ctrl+g：窗口大小调整为 1:1 (点对点)
    Ctrl+x/双击黑边：去除黑边
    Ctrl+h/鼠标中键：按实机HOME键(主屏)
    Ctrl+b/Ctrl+Backspace/Right-click (亮屏时)：按实机BACK键(返回)
    Ctrl+s：按实机APP_SWITCH键(多任务切换)
    Ctrl+m：按实机MENU键(菜单)
    Ctrl+Up：按实机VOLUME_UP键(音量+)
    Ctrl+Down：按实机VOLUME_DOWN键(音量-)
    Ctrl+p：按实机POWER键(电源)(打开/关闭屏幕)
    Right-click (黑屏时)：点亮屏幕
    Ctrl+o：关闭设备屏幕（持续电脑端显示）
    Ctrl+n：展开通知栏
    Ctrl+Shift+n：收起通知栏
    Ctrl+c：复制设备剪贴板至电脑
    Ctrl+v：粘贴电脑剪贴板至设备（不支持中文）
    Ctrl+Shift+v：复制电脑剪贴板至设备（需在设备中粘贴，支持中文）
    Ctrl+i：启用/禁用FPS计数（在log中显示每秒帧数）
    拖动APK文件到窗口：从电脑安装APK程序
    拖动其他文件到窗口：复制文件到手机/sdcard目录中
    )
    msgbox , , 帮助, % Help_Shortcuts
    Return

About:
    About_Me=
    (
本应用使用AutoHotKey制作，意在提供轻量化、功能化、图形化地操纵scrcpy工具。本应用完全免费，项目地址：。
支持我：
特别感谢:
      scrcpy制作团队 项目地址：https://github.com/Genymobile/scrcpy
      scrcpy-gui制作团队 项目地址：https://github.com/Tomotoes/scrcpy-gui
      AutoHotKey制作团队 软件官网：https://autohotkey.com
    )
    msgbox , , 关于本软件, % About_Me
    Return

ShowMainWindow:
    Gui, show
return
;----------------------------------------------------------------------------------
;----------------------------------Window---------------------------------------
GuiEscape:
GuiClose:
    ExitApp

GuiSize:
if A_EventInfo
{
    Gui, Hide
    if EnableTips
    {
        TrayTip , 提示, 你戳了最小化，所以程序主界面隐藏到托盘图标咯~`n双击即可显示主界面`n禁用提示即可永久隐藏本提示。（菜单栏-设置-显示提示）, 5,
     }
}
return
;----------------------------------------------------------------------------------

ChangeConnectMethod:
Gui, submit, nohide
if (ConnectMethod=1)
{
  if (Address="")
  {
    msgbox, 请输入地址，如非默认端口，请在地址后输入端口。
  } else {
    gosub WiFiconnect
  }
} else {
  if (ConnectMethod=2)
  {
    gosub USBconnect
  } else {
    msgbox, Null Operation
  }
}

return

WiFiconnect:
SB_SetText("使用网络连接，加载adb中...")
RunWait, %ComSpec% /c adb.exe connect %Address%, , HIDE UseErrorLevel
SetTimer, ListDevices, -1000
Return

USBconnect:
SB_SetText("使用USB连接，加载adb中...")
RunWait, %ComSpec% /c adb.exe usb, ,HIDE  UseErrorLevel
SetTimer, ListDevices, -1000
return

ListDevices:
SB_SetText("刷新设备列表")
LV_Delete() ;刷新时清空原有记录
            if (LastDevices!="")
            {
                LV_Add("", "", LastDevices, "", "设备未在线", "上次连接成功")
            }

RunWait, %ComSpec% /c adb.exe devices, , HIDE UseErrorLevel
if A_LastError=0 
{
    Result := RunWaitMany("
       (
       adb.exe devices
       )")
    GuiControl, Move, MyEdit, x10 y20 w200 h100
    GuiControl,, ResultShow, %Result%
    DevicesCount:=-1
    Loop, parse, Result, `n, `r
    {
        IfInString, A_LoopField, device
        {
            DevicesCount:=DevicesCount+1
            if DevicesCount>=1
            {
                Deviceslist := RTrim(A_LoopField, OmitChars := "`tdevice")
                if (Deviceslist==LastDevices)
                {
                    LV_Modify(1, "", "", Deviceslist, "数据线连接", "当前在线", "上次连接成功")
                } else {
                    LV_Add("", "", Deviceslist, "数据线连接", "当前在线", "新设备")
                }
            }
        }
    }
    LV_ModifyCol()

    SB_SetText("共有" . DevicesCount . "个设备在线。")
} else {
    SB_SetText("错误！错误代码" . A_LastError . "。详情请咨询开发者。")
}
Return



Apply:
    gui, submit, nohide
    if isRecord=1
    {
        GuiControl, Enable, MirrorWhenRecording
        GuiControl, Enable, RecordingfilePath
    } else {
        GuiControl, disabled, MirrorWhenRecording
        GuiControl, disabled, RecordingfilePath
    }
    if ComputerControl=1
    {
        GuiControl, Enable, TurnOFFScreen
    } else {
        GuiControl, disabled, TurnOFFScreen
    }

if (cutScreenWidth="")
cutScreenWidth:=0
if (cutScreenHeight="")
cutScreenHeight:=0
if (cutScreenX="")
cutScreenX:=0
if (cutScreenY="")
cutScreenY:=0

    gosub, SUMfinalparameter
    GuiControl,, Showfinalparameter, %finalparameter%
    return

test:
    reload
    return

Opensession:
    Run, %ComSpec% /c scrcpy.exe %finalparameter%>> D:\scrcpy%Rand%.txt, , HIDE  , processPID


;    Result1 := RunWaitMany("scrcpy.exe " . finalparameter . "`n")
SetTimer , CheckLog, -1000



;if ErrorLevel
;{
;    LogAnalysis()
;    MsgBox, WinWait timed out.
;    return
;}
; MsgBox, succees
    WinActivate , ahk_class SDL_app
    WinWaitActive , ahk_class SDL_app, , 3
    if ErrorLevel
    {
        SB_SetText("连接" . Serial . "失败！")
    } else {
        SB_SetText("已连接" . Serial . "。")
       IniWrite, %Serial%, %SettingDir%\settings.ini, Section, LastDevices
        if AutoHide
        {
            Gui, Hide
        }
    }

    return

CheckLog:
    Loop, read, D:\scrcpy%Rand%.txt
    {
        if InStr(A_LoopReadLine, "error")
        {
            SB_SetText("连接" . Serial . "失败！失败原因：" . A_LoopReadLine)
            Process, Close , scrcpy.exe
        } else {
            SetTimer , ExitStatus, 3000
        }
    }
return

ExitStatus:
Process, Exist , %processPID%
if (ErrorLevel=processPID)
{
return
} else {
SB_SetText("已关闭镜像连接。")
SetTimer , ExitStatus, Delete
return
}
return

OperationProcess:
    if (A_GuiEvent = "DoubleClick")
    {
        LV_GetText(Serial, A_EventInfo,2)
        if (Serial!="ID")
        {
            SB_SetText("正在连接" . Serial . "。")
            parameterSerial:=" -s " . Serial
            gosub Opensession
        }
    }
    return

RunWaitMany(commands) {
    shell := ComObjCreate("WScript.Shell")
    ; 打开 cmd.exe 禁用命令显示
    exec := shell.Exec(ComSpec " /Q /K echo off")
    ; 发送并执行命令,使用新行分隔
    exec.StdIn.WriteLine(commands "`nexit")  ; 保证执行完毕后退出!
    ; 读取并返回所有命令的输出
    return exec.StdOut.ReadAll()
}
;-----------------------------------------读取配置文件并初始化-------------------------------------------------
initdefaultsettings:
    IniRead, Title, %SettingDir%\settings.ini, section, Title, %A_Space%
    IniRead, isRecord, %SettingDir%\settings.ini, section, isRecord, 0
    IniRead, MirrorWhenRecording, %SettingDir%\settings.ini, section, MirrorWhenRecording, 1
    IniRead, RecordingfilePath, %SettingDir%\settings.ini, section, RecordingfilePath, %SettingDir%\%A_Now%.mkv
    IniRead, Bitrate, %SettingDir%\settings.ini, section, Bitrate, 8000
    IniRead, Maxsize, %SettingDir%\settings.ini, section, Maxsize, 0
    IniRead, cutScreenWidth, %SettingDir%\settings.ini, section, cutScreenWidth, 0
    IniRead, cutScreenHeight, %SettingDir%\settings.ini, section, cutScreenHeight, 0
    IniRead, cutScreenX, %SettingDir%\settings.ini, section, cutScreenX, 0
    IniRead, cutScreenY, %SettingDir%\settings.ini, section, cutScreenY, 0
    
    IniRead, AlwaysOnTop, %SettingDir%\settings.ini, section, AlwaysOnTop, 0
    IniRead, ComputerControl, %SettingDir%\settings.ini, section, ComputerControl, 1
    IniRead, ShowTaps, %SettingDir%\settings.ini, section, ShowTaps, 0
    IniRead, RenderingALL, %SettingDir%\settings.ini, section, RenderingALL, 0
    IniRead, TurnOFFScreen, %SettingDir%\settings.ini, section, TurnOFFScreen, 1
    IniRead, Lastconnectstate, %SettingDir%\settings.ini, section, Lastconnectstate, 1
    ;1=USB,0=WiFi
    IniRead, LastWiFiAddress, %SettingDir%\settings.ini, section, LastWiFiAddress, %A_Space%
    IniRead, LastDevices, %SettingDir%\settings.ini, section, LastDevices, %A_Space%
    IniRead, AutoHide, %SettingDir%\settings.ini, section, AutoHide, 1
    IniRead, EnableTips, %SettingDir%\settings.ini, section, EnableTips, 1
    IniRead, ConnectLast, %SettingDir%\settings.ini, section, ConnectLast, 0
    IniRead, ExistVersion, %SettingDir%\settings.ini, section, ExistVersion, 0
    
    if isRecord=0
    {
        MirrorWhenRecordingStatus:="disabled"
    }
    if AutoHide
    {
        AutoHideStatus:="Check"
    } else {
        AutoHideStatus:="Uncheck"
    }
    if EnableTips
    {
        TipsStatus:="Check"
    } else {
        TipsStatus:="Uncheck"
    }
    if ConnectLast
    {
        ConnectLastStatus:="Check"
    } else {
        ConnectLastStatus:="Uncheck"
    }
    gosub, SUMfinalparameter
    return
;--------------------------------------------------------------------------------------------------------
;-----------------------------------------合并参数-------------------------------------------------
SUMfinalparameter:
    parameterBitrate:=" -b " . Bitrate . "k"
    
    if (cutScreenWidth*cutScreenHeight*cutScreenX*cutScreenY=0)
    {
        parametercrop:=
    } else {
        parametercrop:=" -c " . cutScreenWidth . ":" cutScreenHeight . ":" . cutScreenX . ":" . cutScreenY
    }
    parameterMaxsize:=" -m " . Maxsize

    if (ComputerControl)
    {
        parameterComputerControl:=
        if (TurnOFFScreen=0)
        {
            parameterTurnOFFScreen:=
        } else {
            parameterTurnOFFScreen:= " -S"
        }
    } else {
        parameterComputerControl:=" -n"
        parameterTurnOFFScreen:=
    }
    
    if (isRecord=0)
    {
        parameterRecording:=
    } else {
        if (MirrorWhenRecording=0)
        {
            parameterRecording:=" -r " . RecordingfilePath . " -N"
        } else {
            parameterRecording:=" -r " . RecordingfilePath
        }
    }

    if (RenderingALL=0)
    {
        parameterRenderingALL:=
    } else {
        parameterRenderingALL:= " --render-expired-frames"
    }

    if (ShowTaps=0)
    {
        parameterShowTaps:=
    } else {
        parameterShowTaps:= " -t"
    }

    if (AlwaysOnTop=0)
    {
        parameterAlwaysOnTop:=
    } else {
        parameterAlwaysOnTop:= " -T"
    }

    if (Title="")
    {
        parameterTitle:=
    } else {
        parameterTitle:= " --window-title " . Title
    }

    finalparameter:=parameterBitrate . parametercrop . parameterMaxsize . parameterComputerControl . parameterRecording . parameterRenderingALL . parameterTurnOFFScreen . parameterShowTaps . parameterAlwaysOnTop . parameterTitle . parameterSerial
    return
;---------------------------------------------------------------------------------------------------
;-----------------------------------函数--------------------------------------------------
LogAnalysis()
{

msgbox, test
}
;---------------------------------------------------------------------------------------------------