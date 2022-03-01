@echo off
@set SHDIR=D:\System\shell\scripts
@for /f "tokens=1-3 delims=/ " %%a in ('date /t') do (set mydate=%%a.%%b.%%c)
@for /f "tokens=1-2 delims=/:" %%a in ('time /t') do (set mytime=%%a.%%b)
@set XENV_DEF_TS=%mydate%_%mytime%
@call %SHDIR%\xenv.exe -c %SHDIR%\source\xenv.ini >nul
@set PATH=%XENV_MPATH%
