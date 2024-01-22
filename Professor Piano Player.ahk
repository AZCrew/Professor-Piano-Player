#NoEnv
#SingleInstance, Force
#Persistent
TrayTip, Professor Piano Player, Script Active!, 5, 1
Menu, tray, NoStandard
Menu, tray, Tip, Professor Piano Player
Menu, tray, Add, Professor Piano Player, Info
Menu, tray, Add
Menu, tray, Add, Info, Info
Menu, tray, Add, Help, Help
Menu, tray, Add, Reload, Reload
Menu, tray, Add, Exit, GuiClose
Menu, Tray, Default, Exit

Delay=250
Gui, Add, Text, x5, Delay:
Gui, Add, Edit, w340
Gui, Add, UpDown, vSettingDelay Range-1-1000000,%Delay%
Gui, Add, Text, , TIP: Delay 1000 equals 1 second.
Gui, Add, Text, , Sheet music
Gui, Add, Edit, w340 h140 vSheetMusic, %SheetMusicDefault%
Gui, Add, Button, Default w55 y245 x5 gF5 section, Play
Gui, Add, Button, Default w55 y245 x65 gF6 section, Pause
Gui, Add, Button, Default w55 y245 x125 gF7 section, Stop
Gui, Add, Button, Default w50 y245 x185 gImportSheetMusic section, Import...
Gui, Add, Button, Default w50 y245 x240 gInfo section, Info
Gui, Add, Button, Default w50 y245 x295 gHelp section, Help
Gui, Add, StatusBar, , Stopping... Press F5 to Start
Gui, Show, w350 h300, Professor Piano
Toggle:=0

F5::
{
    if(Toggle == 0)
    {
        Toggle:=1
		SoundBeep
        SB_SetText("Running... Press F7 to Stop/Press F6 to Pause")
		Gui, Submit, Nohide
		SheetMusic := StrReplace(SheetMusic, "`n")
		SheetMusic := StrReplace(SheetMusic, "`r")
		SheetMusic := StrReplace(SheetMusic, "/")
		SheetMusic := StrReplace(SheetMusic, "|")
		SheetMusic := StrReplace(SheetMusic,  "!", "{!}")
		SheetMusic := StrReplace(SheetMusic,  "^", "{^}")
    }

	if(Toggle == 1){
		Array := StrSplit(SheetMusic, "]")
		LastSheetMusic := Array.pop()
		ArrayLastSheetMusic := StrSplit(LastSheetMusic, "")
		LastSheetMusic := ""
		for index, element in ArrayLastSheetMusic
		{
			LastSheetMusic = %LastSheetMusic% %element%
		}
		stats := 0
		text := ""
		for index, element in Array
		{
			Loop, Parse, element, % "["
			{
				tempSheetMusic := A_LoopField
				if(stats == 0){
					stats := 1
					ArrayTempSheetMusic := StrSplit(tempSheetMusic, "")
					for indexArrayTempSheetMusic, elementArrayTempSheetMusic in ArrayTempSheetMusic
					{
						text = %text% %elementArrayTempSheetMusic%
					}
				}else{
					stats := 0
					text = %text% %tempSheetMusic%
				}
			}
		}
		text = %text% %LastSheetMusic%
		ArrayTwo := StrSplit(text, " ")
		for index, element in ArrayTwo
		{
			if(Toggle == 1)
			{
				Sleep %SettingDelay%
				SendInput % element
			}
		}
		Toggle:=0
		SoundBeep
		SB_SetText("Stopping... Press F6 Start")
	}
	return
}

F7::
{
	Toggle:=0
	SoundBeep
	SB_SetText("Stopping... Press F6 Start")
	return
}

PgUp::
{
	Delay:=Delay+50
	SoundBeep
	GuiControl, , SettingDelay,%Delay%
	Gui, Submit, Nohide
	return
}

PgDn::
{
	Delay:=Delay-50
	SoundBeep
	GuiControl, , SettingDelay,%Delay%
	Gui, Submit, Nohide
	return
}

F6::
Pause
Suspend
return

ImportSheetMusic:
	FileSelectFile, SelectedFileSheetMusic, 3, , Open, Text Documents (*.txt)
	FileRead, FileSheetMusic, %SelectedFileSheetMusic%
	GuiControl, , SheetMusic,%FileSheetMusic%
return

Info:
MsgBox, Made by Namida Kitsune`nModified by AZCrew
return

Help:
MsgBox, Hotkey: `n-F6 to Start `n-CTRL+F6 to Stop
return

Reload:
Reload
Return

GuiClose:
    ExitApp
	return