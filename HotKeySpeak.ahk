
/*
Known Issues
-Occasional Interference with copy and paste with Notepad++ where Notepade++ Pastes [NYL] intead of clipboard content
-  Fix, Restart HotKeySpeak
-Residual speech commands remain active when Application Context changes sometimes.
-  Sometimes when the focus changes from one application to another, the rules for the old application remains acitve. and so it will skip over the first voice command uttered in the newly focused application
-  Fix, This seems to be Microphone Dependent for some reason, so switching microphone may help... In any case if the first Voice command is ignored, repeat it.
- Hot keys On Off issues both with the checkbox and the global f12 key
- Hot Keys break the interface when you bash multiple hot keys multiple times. everything stop.

TODO 
Shit dont work unless I ctrl+click the item!!!
Link the forum in the footer
Hot Keys trigger when editing code
Document Syntax highlighting
Add Js Static classes to syntax
add ColorUV to documentation
add goto line number on code execution error >suplementing the >Item(N) system to include line
move ini and log file to user directory

See if I can fix the Message box beeping


test BlockInput in compiled + Administrator mode


Voice Recognition Icon Derived From: https://icons8.com/icon/41948/Voice-Recognition
All Icons made with vectr: https://vectr.com
And converted to ico with IcoFx: http://icofx.ro/
Windows 10 Logo (c) Microsoft: https://commons.wikimedia.org/wiki/File:Windows_10_Logo.svg



To Fix: Hot key seems to trigger twice when it focuses on the the item first... ctrl+c in notepad pastes twice, ctrl+x cuts twice, econd cut is empty so a beep happens
*/
#NoEnv
;#SingleInstance IGNORE
#SingleInstance, off
#SingleInstance, on
#Warn ALL
#Persistent
SendMode Input 
if(WinExist("Hot Key Speak"))
{
    DllCall("SetForegroundWindow", "int", WinExist("Hot Key Speak"))
    ExitApp
    return
}
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Include Includes\MainUI\RegistryStuff.ahk

global tmcSyntaxhModule := 0
global tmcFuncRemoveHilite := 0
global tmcFuncSetHilite := 0
global tmcCleanupSEB := 0
global tmcGetSelectedLanguage :=0
global tmcLoadLanguage := 0
global gSAPITraining := false
global hMainUIWindow := 0
global hDebugWindow := 0
global gExit = false
global gEditing = false
global gReady = false

global gSAPIMaxErrorCount := 10
global gSAPIWarnedError := false
global gSAPIMinThreshold := .9
global gSAPIIgnoreProblem := false
global gSAPIPaused := false
global gSAPILiveRecognition :=1
global gHKDisabled:=0
global gSAPIVoiceIndex:=0
global gSAPIVoiceEnabled:=1
global gSAPIVoiceRate := 0
global gSAPIVoiceVolume := 100
global gAllowSapiKeyPausing := false
global gSapiPausingKey := "F12"
global gAllowSapiHoldKey := false
global gSapiHoldKey := "m"
global gSapiHoldOnDownOrOnUp := 0 ;0 hold on down, 1 hold on up
global gSapiHold := false
global gHKAllowKeyPausing := false
global gHKPausingKey := "F11"

Debug.SetDebugLevel(5)

DoHelp(Topic)
{
    Run, %gHelpSiteBaseUrl%%Topic%

}
global DebugBackColor := ReadIni("Settings.ini","Debug","BackColor", "272727")
global DebugFontColor := ReadIni("Settings.ini","Debug","FontColor", "CCCCCC")
global DebugFontWeight := ReadIni("Settings.ini","Debug","FontWeight", "400")
global DebugFontSize := ReadIni("Settings.ini","Debug","FontSize", "12")
global DebugFontName := ReadIni("Settings.ini","Debug","FontName", "Arial")
Debug.SetDebugLevel(ReadIni("Settings.ini","DEBUGOPTIONS","LEVEL", "5") +0)
Debug.SetLogToFile(ReadIni("Settings.ini","DEBUGOPTIONS","LogToFile", "0") +0)
Debug.WriteStackPush("System Start",Debug.ErrLevelCore)

global gUpdateTimer := ReadIni("Settings.ini","MAINOPTIONS","UpdateTimer", "100") +0

global gHelpSiteBaseUrl := ReadIni("Settings.ini","MAINOPTIONS","HelpSiteUrl", "http://www.themojocollective.com/AKSHelp/default.html?topic=")

global gSAPIMaxErrorCount := ReadIni("Settings.ini","SAPI","MaxErrorCount", gSAPIMaxErrorCount) +0
global gSAPIMinThreshold := ReadIni("Settings.ini","SAPI","MinThreshold", gSAPIMinThreshold) +0
global gSAPIIgnoreProblem := ReadIni("Settings.ini","SAPI","IgnoreProblem", gSAPIIgnoreProblem) +0
global gSAPIPaused := ReadIni("Settings.ini","SAPI","Paused", gSAPIPaused) +0
global gSAPILiveRecognition := ReadIni("Settings.ini","SAPI","LiveRecognition", gSAPILiveRecognition) +0
global gSAPIVoiceIndex := ReadIni("Settings.ini","SAPI","VoiceIndex", gSAPIVoiceIndex) +0
global gSAPIVoiceEnabled := ReadIni("Settings.ini","SAPI","VoiceEnabled", gSAPIVoiceEnabled) +0

global gAllowSapiKeyPausing := ReadIni("Settings.ini","SAPI","AllowSapiKeyPausing", gAllowSapiKeyPausing) +0
global gAllowSapiHoldKey := ReadIni("Settings.ini","SAPI","AllowSapiHoldKey", gAllowSapiHoldKey) +0
global gSapiHoldOnDownOrOnUp := ReadIni("Settings.ini","SAPI","SapiHoldOnDownOrOnUp", gSapiHoldOnDownOrOnUp) +0
global gSapiPausingKey := ReadIni("Settings.ini","SAPI","SapiPausingKey", gSapiPausingKey)
global gSapiHoldKey := ReadIni("Settings.ini","SAPI","SapiHoldKey", gSapiHoldKey)



global gSAPIVoiceRate := ReadIni("Settings.ini","SAPI","VoiceRate", gSAPIVoiceRate) +0
global gSAPIVoiceVolume := ReadIni("Settings.ini","SAPI","VoiceVolume", gSAPIVoiceVolume) +0

global gHKDisabled := ReadIni("Settings.ini","HotKeys","Disabled", gHKDisabled) +0
global gHKAllowKeyPausing := ReadIni("Settings.ini","HotKeys","HKAllowKeyPausing", gHKAllowKeyPausing) +0
global gHKPausingKey := ReadIni("Settings.ini","HotKeys","HKPausingKey", gHKPausingKey)

global WindowBackColor := ReadIni("Settings.ini","Window","WindowBackColor", "1E1E1E")

global PanelBackColor := ReadIni("Settings.ini","Window","PanelBackColor", "272727")

global LabelFontColor := ReadIni("Settings.ini","Label","FontColor", "CCCCCC")
global LabelFontWeight := ReadIni("Settings.ini","Label","FontWeight", "400")
global LabelFontSize := ReadIni("Settings.ini","Label","FontSize", "12")
global LabelFontName := ReadIni("Settings.ini","Label","FontName", "Arial")

global HeaderFontColor := ReadIni("Settings.ini","Header","FontColor", "CCCCCC")
global HeaderFontWeight := ReadIni("Settings.ini","Header","FontWeight", "400")
global HeaderFontSize := ReadIni("Settings.ini","Header","FontSize", "12")
global HeaderFontName := ReadIni("Settings.ini","Header","FontName", "Arial")

global LinkIconSize := ReadIni("Settings.ini","Link","IconSize", "24") + 0
global LinkFontColor := ReadIni("Settings.ini","Link","FontColor", "CCCCCC")
global LinkFontWeight := ReadIni("Settings.ini","Link","FontWeight", "400")
global LinkFontSize := ReadIni("Settings.ini","Link","FontSize", "12")
global LinkFontName := ReadIni("Settings.ini","Link","FontName", "Arial")

global StatusFontColor := ReadIni("Settings.ini","Status","FontColor", "CCCCCC")
global StatusFontWeight := ReadIni("Settings.ini","Status","FontWeight", "400")
global StatusFontSize := ReadIni("Settings.ini","Status","FontSize", "12")
global StatusFontName := ReadIni("Settings.ini","Status","FontName", "Arial")

global ListViewLargeIcons := ReadIni("Settings.ini","ListView","LargeIcons", "0")
global ListViewBackColor := ReadIni("Settings.ini","ListView","BackColor", "272727")
global ListViewFontColor := ReadIni("Settings.ini","ListView","FontColor", "CCCCCC")
global ListViewFontWeight := ReadIni("Settings.ini","ListView","FontWeight", "400")
global ListViewFontSize := ReadIni("Settings.ini","ListView","FontSize", "12")
global ListViewFontName := ReadIni("Settings.ini","ListView","FontName", "Arial")

global TreeViewLargeIcons := ReadIni("Settings.ini","TreeView","LargeIcons", "0")
global TreeViewBackColor := ReadIni("Settings.ini","TreeView","BackColor", "272727")
global TreeViewFontColor := ReadIni("Settings.ini","TreeView","FontColor", "CCCCCC")
global TreeViewFontWeight := ReadIni("Settings.ini","TreeView","FontWeight", "400")
global TreeViewFontSize := ReadIni("Settings.ini","TreeView","FontSize", "12")
global TreeViewFontName := ReadIni("Settings.ini","TreeView","FontName", "Arial")


global TextBoxBackColor := ReadIni("Settings.ini","TextBox","BackColor", "272727")
global TextBoxFontColor := ReadIni("Settings.ini","TextBox","FontColor", "CCCCCC")
global TextBoxFontWeight := ReadIni("Settings.ini","TextBox","FontWeight", "400")
global TextBoxFontSize := ReadIni("Settings.ini","TextBox","FontSize", "12")
global TextBoxFontName := ReadIni("Settings","TextBox","FontName", "Arial")

global gSyntaxHilighting := ReadIni("Settings.ini","CodeBox","SyntaxHilighting", "0")

global CodeBoxBackColor := ReadIni("Settings.ini","CodeBox","BackColor", "000000")
global CodeBoxFontColor := ReadIni("Settings.ini","CodeBox","FontColor", "CCCCCC")
global CodeBoxFontWeight := ReadIni("Settings.ini","CodeBox","FontWeight", "400")
global CodeBoxFontSize := ReadIni("Settings.ini","CodeBox","FontSize", "11")
global CodeBoxFontName := ReadIni("Settings.ini","CodeBox","FontName", "Courier New")
global CodeBoxSyntax := ReadIni("Settings.ini","CodeBox","Syntax", "HKS + JScript 3.0 Syntax")
global LineNumberBackColor := "0x" . ReadIni("Settings.ini","CodeBox","LineNoBackColor", "272727")
global LineNumberColor := "0x" . ReadIni("Settings.ini","CodeBox","LineNoColor", "4A4A4A")

global ButtonBackColor := ReadIni("Settings.ini","Button","BackColor", "272727")
global ButtonFontColor := ReadIni("Settings.ini","Button","FontColor", "CCCCCC")
global ButtonFontWeight := ReadIni("Settings.ini","Button","FontWeight", "400")
global ButtonFontSize := ReadIni("Settings.ini","Button","FontSize", "12")
global ButtonFontName := ReadIni("Settings.ini","Button","FontName", "Arial")



global ScriptEditor := ReadIni("Settings.ini","ExternalPrograms","CodeEditor","C:\Program Files\Microsoft VS Code\Code.exe")

#Include Includes\Helpers\PopUpMenuFix.ahk

#Include Includes\MainUI\MessageHandlers.ahk



Interpreter.Init()

OnExit("Cleanup")

#Include Includes\Helpers\HelpfulCode.ahk
InitSyntaxModule()

MainUI_Start()



Cleanup(ExitReason, ExitCode)
{

    CleanupHilite()
    Loop, 98 ; is max number of GUIs
    {
        GuiDestroyNum := A_Index+1
        Gui, %GuiDestroyNum%: Destroy	; Destroys all the GUIs
    }
    Debug.WriteStackPush("Cleanup Start",Debug.ErrLevelCore)
    WriteIni("Settings.ini","ExternalPrograms","CodeEditor",ScriptEditor)

    WriteIni("Settings.ini","SAPI","MaxErrorCount", gSAPIMaxErrorCount)
    WriteIni("Settings.ini","SAPI","MinThreshold", gSAPIMinThreshold)
    WriteIni("Settings.ini","SAPI","IgnoreProblem", gSAPIIgnoreProblem)
    WriteIni("Settings.ini","SAPI","Paused", gSAPIPaused)
    WriteIni("Settings.ini","SAPI","LiveRecognition", gSAPILiveRecognition)

    WriteIni("Settings.ini","SAPI","AllowSapiKeyPausing", gAllowSapiKeyPausing)
    WriteIni("Settings.ini","SAPI","AllowSapiHoldKey", gAllowSapiHoldKey)
    WriteIni("Settings.ini","SAPI","SapiHoldOnDownOrOnUp", gSapiHoldOnDownOrOnUp)
    WriteIni("Settings.ini","SAPI","SapiPausingKey", gSapiPausingKey)
    WriteIni("Settings.ini","SAPI","SapiHoldKey", gSapiHoldKey)



    WriteIni("Settings.ini","HotKeys","Disabled", gHKDisabled)
    WriteIni("Settings.ini","HotKeys","HKAllowKeyPausing", gHKAllowKeyPausing)
    WriteIni("Settings.ini","HotKeys","HKPausingKey", gHKPausingKey)

    WriteIni("Settings.ini","SAPI","VoiceIndex", VoiceAgent.GetVoiceIndex())
    WriteIni("Settings.ini","SAPI","VoiceEnabled", VoiceAgent.m_VoiceEnabled) 
    WriteIni("Settings.ini","SAPI","VoiceRate", VoiceAgent.GetSpeakRate())
    WriteIni("Settings.ini","SAPI","VoiceVolume", VoiceAgent.GetSpeakVolume())


    WriteIni("Settings.ini","CodeBox","Syntax", CodeBoxSyntax)

    Debug.WriteStackPop("Cleanup End",Debug.ErrLevelCore)

    WriteIni("Settings.ini","DEBUGOPTIONS","LEVEL", Debug.GetDebugLevel())
    WriteIni("Settings.ini","DEBUGOPTIONS","LogToFile", Debug.GetLogToFile())

    WriteIni("Settings.ini","CodeBox","SyntaxHilighting", gSyntaxHilighting)
    
    FreeSyntaxModule()

}

Debug.WriteStackPop("System Ready",Debug.ErrLevelCore)


Loop %0%  ; For each parameter (or file dropped onto a script):
{
    GivenPath := %A_Index%  ; Fetch the contents of the variable whose name is contained in A_Index.
    Loop %GivenPath%, 1
        LongPath = %A_LoopFileLongPath%
    ;Debug.WriteNL( "The case-corrected long path name of file`n" . GivenPath . "`nis:`n" . LongPath)
    TVHelper.SelectItem(MainUITreeview_Control_Instance.m_RootAppsItem)
    MainUITreeview_Control_Instance.OnLoadFromFile(LongPath)
}

;Generic helpers
#Include Includes\Helpers\DebugHelper.ahk

#Include Includes\Helpers\LinkedListAndHashTable.ahk
#Include Includes\Helpers\MS_XMLDOM\MS_XMLDOM.ahk
#Include Includes\Helpers\StringHelpers.ahk
#Include Includes\Helpers\Class_Base64.ahk

;sha
#Include Includes\Crypto\Crypto.ahk

;Event Manager
#Include Includes\EventManager\EventManager.ahk
#Include Includes\EventManager\GlobalEnventsHandler.ahk
;Interpreter
; Requires Lib\ComDispatch.ahk - https://github.com/cocobelgica/AutoHotkey-ComDispatch
#Include Includes\Interpreter\ActiveScript\ActiveScript.ahk
#Include Includes\Interpreter\ActiveScript\ComDispatch0.ahk
#Include Includes\Interpreter\ActiveScript\ComDispTable.ahk
#Include Includes\Interpreter\ActiveScript\ComVar.ahk

#Include Includes\Interpreter\Interpreter.ahk
#include Includes\Interpreter\AHKWrappers.ahk
#include Includes\Interpreter\MyObjectsWrappers.ahk

#include Includes\Interpreter\WinAPIWrappers.ahk

#include Includes\Interpreter\InterpreterHandler.ahk

;SAPI
#Include Includes\SpeechToText\MS_SAPI\MS_SAPI.ahk
;#Include Includes\SpeechToText\SpeechToText.ahk
#include Includes\SpeechToText\SpeechToTextHandler.ahk
#Include Includes\SpeechToText\VoiceAgent.ahk
;HotKey manager
#Include Includes\HotKeySystem\HotKeySystem.ahk

;Process Monitor
#Include Includes\ProcessMonitor\ProcessMonitor.ahk

;UI
#Include Includes\MainUI\MainUI.ahk
#Include Includes\MainUI\MainUIStatuBar.ahk

;Main Treeview
#Include Includes\MainUI\MainUITreeView\MainUITreeview.ahk
#Include Includes\MainUI\MainUITreeView\MainUITVRCMenu.ahk
#Include Includes\MainUI\MainUITreeView\MainUITVItemTypes.ahk
#Include Includes\MainUI\MainUITreeView\MainTVHelpers.ahk
#Include Includes\MainUI\MainUITreeView\MainTVDOMHelpers.ahk
#Include Includes\MainUI\MainUITreeView\SaveLoadMainTreeview.ahk
#Include Includes\MainUI\MainUITreeView\TVItemSelectorHandler.ahk
;ItemEdit Dialogs
#Include Includes\MainUI\MainUITreeView\ItemEditDialogs\ItemGroupEditDialog.ahk
#Include Includes\MainUI\MainUITreeView\ItemEditDialogs\ItemCommandEditDialog.ahk
#Include Includes\MainUI\MainUITreeView\ItemEditDialogs\ItemContextEditDialog.ahk
#Include Includes\MainUI\MainUITreeView\ItemEditDialogs\ItemWindowContextEditDialog.ahk
#Include Includes\MainUI\MainUITreeView\ItemEditDialogs\ItemExeEditDialog.ahk
;Options Dialogs
#Include Includes\MainUI\Options\OptionsDialog.ahk


;Process Selector
#Include Includes\MainUI\ListProcessDialog\ListProcessDialog.ahk

#Include Includes\MainUI\MainUIIcons.ahk

return
;a::
;InitSyntaxModule()
