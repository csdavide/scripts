@echo off
@SETLOCAL

if "%1" == "" goto error
if "%JAVA_HOME%" == "" goto nojhome

set DEP_HOME=C:\u2031\env\Exp\jar-util\repo\jar_analyzer
set CP=%DEP_HOME%\lib\filter.jar;%DEP_HOME%\lib\bcel-6.3.jar;%DEP_HOME%\lib\jakarta-regexp-1.3.jar;%DEP_HOME%\jaranalyzer-1.2.jar

if "%2" == "dot" (
"%JAVA_HOME%\bin\java" -cp %CP% com.kirkk.analyzer.textui.DOTSummary %1 %CD%\depend.dot
) else (
"%JAVA_HOME%\bin\java" -cp %CP% com.kirkk.analyzer.textui.XMLUISummary %1 %CD%\depend.xml
)

goto end

:error
echo "usage : jdep <directory lib> <xml|dot>"
goto end

:nojhome
echo "JAVA_HOME is empty"

:end
@ENDLOCAL