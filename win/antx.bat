@echo off
echo BUILD %date% %time%
SETLOCAL
set DIR_SET=.
::set IVY=D:\Develope\u-home\ivy\1.0\ivy-1.0.0.jar
set IVY=D:\Develope\u-home\ivy\2.0\ivy-2.0.0.jar
set ARGS=%*

if "%1" == "-x" goto SET_ANT
goto EXEC

:SET_ANT
SHIFT /1
if [%1] == [] (
 %SHELL_HOME%\scripts\dir_list.exe ANT_DIR
) else (
   set VR=%1
   if /i "%VR:~0,1%" == "-" (
    echo Syntax Error
    goto END
   )
   for /f "usebackq" %%x in (`%SHELL_HOME%\scripts\dir_list.exe ANT_DIR %1`) do (
    set DIR_SET=%%x
   )
	 goto PARS
)

goto END

:PARS
set ARGS=
shift /1
goto LOOP

:LOOP
if [%1] == [] goto EXEC
set ARGS=%ARGS% %1
shift /1
goto LOOP

:EXEC
::echo EXEC:%DIR_SET%
if [%DIR_SET%] == [.] (
 for /f "usebackq" %%y in (`%SHELL_HOME%\scripts\dir_list.exe ANT_DIR 2`) do (
		set DIR_SET=%%y
	)
)
::echo DIR_SET=%DIR_SET%
set ANT_HOME=%DIR_SET%
::echo %ARGS%
%DIR_SET%\bin\ant -lib %IVY% %ARGS%

:END
ENDLOCAL