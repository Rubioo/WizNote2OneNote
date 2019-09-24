#NoEnv ;初始化环境
#SingleInstance force
#Persistent
CoordMode Mouse,Screen  ;默认坐标是相对于窗口的，需要改成相对屏幕的
DetectHiddenWindows, Off


;~ 再在word里面发送一个回车
;~ DebugMessage("hello, world!")
^F1::
	start=true
	Gosub,do
return
^F2::start=false

do:
Loop {
;强制退出键
	if start != true
	{
		msgbox,已停止
		return
	}

	WinWait,ahk_class WizNoteMainFrame
	{
		WinGetTitle, WindowTitle, ahk_class WizNoteMainFrame
		clipboard := WindowTitle
		; msgbox, %lastWindowTitle%,%WindowTitle%,lastWindowTitle = %WindowTitle%
		if lastWindowTitle = %WindowTitle%
		{
			; msgbox, %lastWindowTitle%,%WindowTitle%
			return
		}
		Needle = - 为知笔记
		IfInString, WindowTitle, %Needle%
		{
			; MsgBox, 字符串已找到。
			;激活这个窗口
			;获取标题
			IfInString, WindowTitle, .md 
			{
				StringTrimRight, NoteTitle, WindowTitle, 10 ; 把.md去掉
			}else{
				StringTrimRight, NoteTitle, WindowTitle, 7
			}
			
			
			clipboard := NoteTitle
			WinActivate,ahk_class Framework::CFrame
			
			send ^v
			Sleep, 200 
			send {Enter}
			Sleep, 200 
			
			WinActivate,ahk_class WizNoteMainFrame
			; MouseClick , left,469, 1064
			Sleep, 200 
			ControlFocus ,ATL:0480C1D01
			MouseClick, left
			send ^a
			Sleep, 200 
			send ^c
			Sleep, 200 
			
			WinActivate,ahk_class Framework::CFrame
			send ^v
			Sleep, 200 ;文件内容多的话时间可能不够
			send ^n
			Sleep, 200 
			
			WinActivate,ahk_class WizNoteMainFrame
			send {F8}
			Sleep, 200 
			; return
			lastWindowTitle := WindowTitle
		}
		
	}
}
return