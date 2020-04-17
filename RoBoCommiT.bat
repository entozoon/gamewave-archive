@echo off
setlocal enabledelayedexpansion
cls

rem ***************************
set committingDir="episodes"
set limit=3
set delay=60
set startPoint=6
rem ***************************

set originalDir=%cd%
 cd %committingDir%

set /a i=0
echo.
echo     RoBoCommiT RoBoCommiT RoBoCommiT RoBoCommiT RoBoCommiT
echo    RoBoCommiT RoBoCommiT RoBoCommiT RoBoCommiT RoBoCommiT
echo   RoBoCommiT RoBoCommiT RoBoCommiT RoBoCommiT RoBoCommiT
echo.
echo  Commits everything in %committingDir%:
echo  - Pushing each %limit% files
echo  - With a %delay%s gap
echo  - Starting at the %startPoint%th file.
echo.
pause
echo.

for /r %%f in (*) do (
  if !i! gtr !startPoint! (
    REM If directory contains .git don't bother
    echo.%%~pf | findstr /C:".git" 1>nul
    if errorlevel 1 (
      echo  !i!  %%~nxf
      git add "%%~f"
      REM Push, every now and then
      Set /a mod = !i! %% %limit%
      REM echo !i!  mod: !mod!
      if !mod! equ 0 (
        if !i! neq 0 (
          echo.
          echo  Pushing chunk...
          echo.
          call :PUSH
          timeout %delay%
        )
      )
    )
  )
  set /a i+=1
)
call :PUSH
echo.
echo  All done!
echo.
goto :EOF

:PUSH
git commit -m "Pushing chunks with robocommit" --quiet
git push
exit /b 0

:EOF
cd %originalDir%
endlocal
