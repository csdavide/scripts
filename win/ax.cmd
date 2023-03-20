@echo off

if "%JDK_DIR%" == "" goto NERR
if "%1" == "" goto SHOW_USAGE

:PARAMS_LOOP
if "%1" == "-a" goto JAVA
if "%1" == "-c" goto JAVAC
if "%1" == "-e" goto JAVAD
if "%1" == "-j" goto JAR
if "%1" == "-l" goto ADD_LOCAL_LIB_TO_CP
if "%1" == "-p" goto JAVAP
if "%1" == "-r" goto INVOKE
if "%1" == "-s" goto VIEW
if "%1" == "-t" goto TOOLS
if "%1" == "-v" goto VERS
if "%1" == "-x" goto ADD_RES_TO_CP

echo Opzione [%1] non valida
goto SHOW_USAGE

:JAVA
set ARGS=
shift /1
goto loop1

:loop1
if [%1] == [] goto endloop1
set ARGS=%ARGS% %1
shift /1
goto loop1

:endloop1
%JAVA_HOME%\bin\java %ARGS%
goto DONE

:JAVAC
set ARGS=
shift /1
goto loop2

:loop2
 if [%1] == [] goto endloop2
 set ARGS=%ARGS% %1
 shift /1
 goto loop2

:endloop2
%JAVA_HOME%\bin\javac %ARGS%
goto DONE

:JAR
set ARGS=
shift /1

:loop3
 if [%1] == [] goto endloop3
 set ARGS=%ARGS% %1
 shift /1
 goto loop3

:endloop3
%JAVA_HOME%\bin\java -jar %ARGS%
goto DONE

:JAVAP
set ARGS=
shift /1
goto loop4

:loop4
 if [%1] == [] goto endloop4
 set ARGS=%ARGS% %1
 shift /1
 goto loop4

:endloop4
%JAVA_HOME%\bin\javap %ARGS%
goto DONE

:JAVAD
set ARGS=
shift /1
set CMD=%1
shift /1
goto loop5

:loop5
 if [%1] == [] goto endloop5
 set ARGS=%ARGS% %1
 shift /1
 goto loop5

:endloop5
%JAVA_HOME%\bin\%CMD% %ARGS%
goto DONE

:VERS
shift /1

if "%1" == "" (
 if "%JAVA_HOME%" == "" (
  echo JAVA_HOME not set
 ) else (
  echo JAVA_HOME=%JAVA_HOME%
 )

 echo.

 call %SHELL_HOME%\scripts\jdk_list.exe
 echo.

 goto DONE
)

for /f "usebackq" %%x in (`%SHELL_HOME%\scripts\jdk_list.exe %1`) do set JDK_SET=%%x

rem if not "%JDK_SET%" == "" (
set JAVA_HOME=%JDK_SET%
set PATH=%XENV_MPATH%;%JAVA_HOME%\bin
echo Settata JAVA_HOME della versione %JDK_SET%
goto DONE
rem )

echo La jdk specificata (%1) non esiste.
call %SHELL_HOME%\scripts\jdk_list.exe
echo.
goto DONE

:TOOLS
setlocal EnableDelayedExpansion
if "%2"=="" (
call %SHELL_HOME%\scripts\jut.exe
) else (
for /F "tokens=*" %%a in ('cscript //NoLogo %SHELL_HOME%\scripts\source\win\best\jut.vbs %2') do set ARGST=%%a
rem del tf
%JAVA_HOME%\bin\java -jar !ARGST! %3 %4 %5 %6
)
echo.
endlocal
goto DONE

:DOSHIFT
shift /1

if "%1" == "" goto EXIT
goto PARAMS_LOOP

:INVOKE

cls
call %CD%\run.bat
goto DONE

:ADD_LOCAL_LIB_TO_CP

set CLASSPATH=
set LIB_TO_LOAD=%CD%\lib

goto RUN_LOAD_CP

:RUN_LOAD_CP
subst x: %LIB_TO_LOAD%

for %%f in (x:\*.jar) do call %0 -i -d %%~fsf
goto DOSHIFT

:ADD_RES_TO_CP
shift /1
set CLASSPATH=%CLASSPATH%;%1
goto DOSHIFT

:VIEW
echo.
echo    JAVA_HOME :  %JAVA_HOME%
echo.
echo    CLASSPATH :  %CLASSPATH%
echo.
echo    PATH      :  %PATH%
echo.
goto DONE

:SHOW_USAGE
echo.
echo Utilizzo : ax [-opzione] [parametri]
echo.
echo. Le opzioni disponibili sono :
echo.
echo  [a] : java della distribuzione %JAVA_HOME%
echo.
echo  [c] : javac della distribuzione %JAVA_HOME%
echo.
echo  [e] : 'comando' della distribuzione %JAVA_HOME%
echo.
echo  [j] : jar della distribuzione %JAVA_HOME%
echo.
echo  [p] : javap della distribuzione %JAVA_HOME%
echo.
echo  [l] : carica il contenuto di %CD%\lib nel CLASSPATH.
echo.
echo  [r] : setta JAVA_HOME, CLASSPATH, PATH e richiama %CD%\run.bat
echo.
echo  [s] : visualizza JAVA_HOME, CLASSPATH e PATH.
echo.
echo  [t] : jar tools
echo.
echo  [v] : setta la JAVA_HOME della versione [#] specificata
echo       (se non si specifica nessuna versione viene presentata la lista delle jdk presenti nel sistema)
echo.
echo  [x] : aggiunge {risorsa} al classpath.
echo.
goto EXIT

:DONE
if "%JAVA_HOME%" == "" (
 set JAVA_HOME=%JDK_DIR%\jdk1.3.1_08
 echo JAVA_HOME=%JAVA_HOME%
)
goto EXIT

:NERR
echo JDK_DIR non settata

:EXIT
