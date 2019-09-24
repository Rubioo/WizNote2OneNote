#NoEnv ;初始化环境
#SingleInstance force
#Persistent
CoordMode Mouse,Screen  ;默认坐标是相对于窗口的，需要改成相对屏幕的
DetectHiddenWindows, Off



^F1::
	start=true
	Gosub,do
return
^F2::start=false
;键还没按下去那边就到下一个了
common_delay:=1000
do:
Loop 
{
	if start != true ;强制退出键
	{
		msgbox,手动停止
		return
	}
	#IfWinActive ahk_class Framework::CFrame
	Sleep, %common_delay%
	mouseclick,right
	Sleep, %common_delay% 
	send d
	Sleep, %common_delay% 
	send y
	#IfWinActive
}
