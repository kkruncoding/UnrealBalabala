@echo off
setlocal enabledelayedexpansion

echo 输入进程的PID:
set /p PID=

REM 获取当前日期时间的其他方式，不依赖系统设置
for /F "tokens=2-4 delims=/ " %%a in ('date /T') do (
    set day=%%a
    set month=%%b
    set year=%%c
)
for /F "tokens=1-2 delims=: " %%a in ('time /T') do (
    set hour=%%a
    set minute=%%b
)
REM 补零操作
if %day% LSS 10 (set day=0%day:~1,1%)
if %month% LSS 10 (set month=0%month:~1,1%)
if %hour% LSS 10 (set hour=0%hour:~1,1%)
if %minute% LSS 10 (set minute=0%minute:~1,1%)

set datetime=%year%%month%%day%-%hour%%minute%

set logFile=%PID%Data%datetime%.log
if exist %logFile% del %logFile%


set /a count=0
set /a sumMemory=0
set /a sumCpu=0
set /a sumGpu=0
set firstRun=true

REM 获取 GPU 利用率（放在循环外，确保只获取一次）
for /f %%m in ('adb shell cat /sys/class/kgsl/kgsl-3d0/gpubusy') do set gpudata=%%m

:loop
echo ------------------------------------------------------
call :getProcessInfo !PID!

if !firstRun! equ true (
    set /a maxMemory=!rss_in_mb!
    set /a minMemory=!rss_in_mb!
    set /a maxCpu=!cpudata!
    set /a minCpu=!cpudata!
    set /a maxGpu=!gpudata!
    set /a minGpu=!gpudata!
    set firstRun=false
)

set /a count+=1
set /a sumMemory+=rss_in_mb
set /a sumCpu+=cpudata
set /a sumGpu+=gpudata

if !gpudata! GTR !maxGpu! set maxGpu=!gpudata!
if !gpudata! LSS !minGpu! set minGpu=!gpudata!
if !rss_in_mb! GTR !maxMemory! set maxMemory=!rss_in_mb!
if !rss_in_mb! LSS !minMemory! set minMemory=!rss_in_mb!
if !cpudata! GTR !maxCpu! set maxCpu=!cpudata!
if !cpudata! LSS !minCpu! set minCpu=!cpudata!

echo GPU利用率:!gpudata!%%

timeout /t 1 > nul
set /a duration=!count!
if !duration! geq 60 goto :calculateAverage
goto loop

:getProcessInfo
set PID=%1
for /f "tokens=5" %%i in ('adb shell ps -p%PID%') do ( 
    set /a rss_in_kb=%%i
    set /a rss_in_mb=rss_in_kb/1024
)
for /f "tokens=9" %%j in ('adb shell top -n 1 -p %PID% ^| findstr /i "%PID%"') do (
    set cpudata=%%j
    set cpudata=!cpudata:~0,-1!
    REM 检查是否有百分号和小数点，如果有小数点，移除它
    if "!cpudata:~-1!" equ "%%" set cpudata=!cpudata:~0,-1!
    if "!cpudata:~-1!" equ "." set cpudata=!cpudata:~0,-1!
)
echo %PID%  -----内存占用:%rss_in_mb%MB   CPU占用:%cpudata%%%-----
goto :eof

:calculateAverage
set /a avgMemory=sumMemory / count
set /a avgCpu=sumCpu / count
set /a avgGpu=sumGpu / count

echo. >> %logFile%
echo -------------------------------------------------------------------------------------------- >> %logFile%
echo ---- 最大内存: !maxMemory! MB >> %logFile% ---- 最小内存: !minMemory! MB >> %logFile% ---- 平均内存: !avgMemory! MB >> %logFile%
echo ---- 最大CPU占用: !maxCpu!%% >> %logFile% ---- 最小CPU占用: !minCpu!%% >> %logFile% ---- 平均CPU占用: !avgCpu!%% >> %logFile%
echo ---- 最大GPU占用: !maxGpu!%% >> %logFile% ---- 最小GPU占用: !minGpu!%% >> %logFile% ---- 平均GPU占用: !avgGpu!%% >> %logFile%
echo -------------------------------------------------------------------------------------------- >> %logFile%

REM 输出结果到控制台，并且等待用户按键后关闭控制台
type %logFile%
pause > nul

:end
endlocal