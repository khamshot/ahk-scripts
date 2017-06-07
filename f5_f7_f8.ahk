#UseHook
#InstallKeybdHook
; Lines beginning with ; are comments.
; !=Alt, ^=Ctrl and +=Shift

;Play/Pause
F5::
DetectHiddenWindows , On
;Play/Pause command line for your music player goes here.
;format is "Run <PathToProgram> <CommandLineOption>"
Run C:\Program Files (x86)\foobar2000\foobar2000.exe /playpause
DetectHiddenWindows , Off
return

;Previous track
F7::
DetectHiddenWindows , On
;Previous track command line for your music player goes here.
;format is "Run <PathToProgram> <CommandLineOption>"
Run C:\Program Files (x86)\foobar2000\foobar2000.exe /prev
DetectHiddenWindows , Off
return

;Next Track
F8::
DetectHiddenWindows , On
;Next track command line for your music player goes here.
;format is "Run <PathToProgram> <CommandLineOption>"
Run C:\Program Files (x86)\foobar2000\foobar2000.exe /next
DetectHiddenWindows , Off
return
