#NoEnv ;初始化环境
#SingleInstance force
#Persistent
CoordMode Mouse,Screen  ;默认坐标是相对于窗口的，需要改成相对屏幕的
DetectHiddenWindows, Off


;前提要求
;把为知笔记的所有目录全部展开
;给onenote新建一个笔记本
; 鼠标放置在个人笔记处
;开始：选中第一个文件夹 lastFolderTitle  lastWindowTitle
; 选中第一条笔记
; 激活wiz F2 到OneNote Ctrl+T 粘贴 回车
; 激活wiz 激活列表 到OneNote 粘贴 切换回来 

; 但是对于切换目录时，需要 先按 下，再按F8 取得笔记
; 结束状态
; 换文件夹 lastWindowTitle = WindowTitle
; 结束 lastFolderTitle = folderTitle & lastWindowTitle = WindowTitle
;

^F1::
	start=true
	IniRead, common_delay, config.ini, Section, common_delay
	IniRead, paste_to_onenote, config.ini, Section, paste_to_onenote
	IniRead, edit_in_wiznote, config.ini, Section, edit_in_wiznote
	IniRead, switch_folder_wiznote, config.ini, Section, switch_folder_wiznote
	Gosub,do
return
^F2::start=false


do:
Loop 
{
	;第一次进入时需要获取folderTitle
	WinActivate,ahk_class WizNoteMainFrame
	ControlFocus ,ATL:CWizMultiSelectTreeCtrl
	MouseClick, left
	send {down}
	send {F2}
	send ^c
	send {enter}
	folderTitle := clipboard
	
	IfInString, folderTitle, - 为知笔记
	{
		msgbox, 全部迁移已完成
		return
	}
	if lastFolderTitle == %folderTitle%
	{
		msgbox, 全部迁移已完成
		return
	}else{
		lastFolderTitle := folderTitle
		;去OneNote 新建分区
		WinActivate,ahk_class Framework::CFrame
		send ^t
		Sleep, %common_delay%
		send ^v
		Sleep, %common_delay% 
		send {enter}
		Sleep, %common_delay% 
		loop {
			;在文件夹内部遍历
			if start != true ;强制退出键
			{
				msgbox,手动停止
				return
			}
			
			
			WinActivate,ahk_class WizNoteMainFrame
			send {F8}
			Sleep, %switch_folder_wiznote%  ;切换文件夹时，如果文件夹中内容很多，时间可能不够
			
			
			WinGetTitle, WindowTitle, ahk_class WizNoteMainFrame
			clipboard := WindowTitle
			if lastWindowTitle = %WindowTitle%
			{
				; msgbox, %lastWindowTitle%,%WindowTitle%
				; 跳文件夹
				break
			}
			;MsgBox, 字符串已找到。
			;激活这个窗口
			if A_OSVersion contains 10. ;win10 title 为  - 为知笔记: 收藏知识，分享快乐
			{
				StringTrimRight, NoteTitle, WindowTitle, 18
			}else{ ;win 7 title 为  - 为知笔记
				StringTrimRight, NoteTitle, WindowTitle, 7
			}
			IfInString, WindowTitle, .md 
			{
				StringTrimRight, NoteTitle, NoteTitle, 3 ; 把.md去掉
			}
			
			clipboard := NoteTitle
			
			;去OneNote 新建笔记
			WinActivate,ahk_class Framework::CFrame
			send ^v
			Sleep, %common_delay% 
			send {Enter}
			Sleep, %common_delay% 
			
			;回到wiz
			WinActivate,ahk_class WizNoteMainFrame
			Sleep, %common_delay% 

			; 编辑内容获得键盘焦点
			send {F4}
			Sleep, %edit_in_wiznote% 
			send {F4}
			Sleep, %edit_in_wiznote%	
			
			send ^a
			Sleep, %common_delay% 
			send ^c
			Sleep, %common_delay% 
			
			;去OneNote 粘贴笔记内容
			WinActivate,ahk_class Framework::CFrame
			send ^v
			Sleep, %paste_to_onenote% ;文件内容多的话时间可能不够
			send ^n
			Sleep, %common_delay% 
			
			
			lastWindowTitle := WindowTitle
			
		}
		
	}
	
	
	
}
return