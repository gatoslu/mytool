@echo off
mode con cols=100 lines=35 & color 0a
title KMS激活工具
echo   ###############################################################################################
echo                                  欢迎使用KMS激活工具!
echo                 本工具可激活VOL版Windows7,8,8.1,10;Office2007,2010,2013,2016
echo                      请按照自己需要激活的软件类型选择对应激活方式
echo         激活后每隔30天自动向远方KMS服务器发送激活请求，理论上无限续杯！（KMS服务端还在的话！）
echo                注意：本脚本需要管理员权限运行，否则可能出现无法激活的现象
echo                    Copyright@Gatoslu   如有问题请联系：lbcfez@gmail.com
echo   ###############################################################################################



ver
echo 当前日期：%DATE%
echo 当前时间：%TIME%
echo 当前目录：%CD%  
echo.
echo Windows版本
 wmic os get caption


echo.
echo  程序正在初始化......
echo.
echo ┌──────────────────────────────────────┐
set/p=  ■<nul
for /L  %%i in (1 1 38) do set /p a=■<nul&ping /n 1 127.0.0.1>nul
echo   100%%
echo └──────────────────────────────────────┘
pause



                         
rem 选择菜单

:menu
echo.
echo              ==============================
echo              请选择要进行的操作，然后按回车
echo              ==============================
echo.
echo              1.激活Windows系统
echo.
echo              2.激活Office办公套件
echo.
echo              3.查询Windows激活状态
echo.
echo              4.查询Office激活状态
echo.
echo              5.清理系统垃圾，加快电脑运行速度
echo.
echo              Q.退出
echo.
echo.
:cho
set choice=
set /p choice=          请选择:
IF NOT "%choice%"=="" SET choice=%choice:~0,1%
if /i "%choice%"=="1" goto windows
if /i "%choice%"=="2" goto office
if /i "%choice%"=="3" goto windows_act_status
if /i "%choice%"=="4" goto office_act_status
if /i "%choice%"=="5" goto clean
if /i "%choice%"=="Q" goto endd
echo 选择无效，请重新输入
echo.
goto cho



rem Windows激活
:windows
echo 当前菜单Windows激活，确认激活请按1
echo 若返回上级请按0键
echo.
set choice=
set /p choice=          请选择:
IF NOT "%choice%"=="" SET choice=%choice:~0,1%
if /i "%choice%"=="1" goto windows_act
if /i "%choice%"=="0" goto menu
echo 选择无效，请重新输入
echo.
goto windows

:windows_act
echo 当前Windows系统版本	
wmic os get caption
echo 准备设置KMS激活服务器
pause
echo 设置Windows激活KMS服务器中...	
slmgr /skms kms.03k.org
echo #################################服务器设置完毕，准备激活#####################################
pause
echo #################################准备向服务发送激活请求中...##################################	
slmgr /ato

echo ####################################向服务发送激活请求中....##################################




echo #############################Windows激活完成！    Enjoy it!##################################
pause
goto menu

:office
echo 当前菜单office激活，确认激活请按1
echo 若返回上级请按0键
echo.
set choice=
set /p choice=          请选择:
IF NOT "%choice%"=="" SET choice=%choice:~0,1%
if /i "%choice%"=="1" goto office_act
if /i "%choice%"=="0" goto menu
echo 选择无效，请重新输入
echo.
goto office

:office_act

echo 准备搜索Office安装目录......
pause
rem 开启本地变量延迟
setlocal enabledelayedexpansion

set "FileName=ospp.vbs"
echo 正在搜索office安装目录，请稍候...
for %%a in (C D) do (
  if exist %%a:\ (
    pushd %%a:\
    for /r %%b in (*%FileName%) do (
      if /i "%%~nxb" equ "%FileName%" (
        set ffile=%%~pb
echo 本机office所在目录
        echo,%%~dpb
		
		goto cd_office
		
  
	  )
    )

    popd
  )
)

:cd_office
echo  尝试定位到Office目录...
cd /d %ffile%

echo %CD%

echo #####################################已进入Office目录#######################################

pause
echo #######################################开始设置服务器...########################################
cscript ospp.vbs /sethst:kms.03k.org
echo ################################设置服务器完成！向服务器发送激活请求...#########################

cscript ospp.vbs /act

echo #################################服务响应激活许可，完成激活中......#############################
echo ##################################Office激活完成！  Enjoy it!###################################
pause
goto menu




:windows_act_status


echo 当前菜单查询Windows激活状态，确认请按1
echo 返回上级请按0键
echo.
set choice=
set /p choice=          请选择:
IF NOT "%choice%"=="" SET choice=%choice:~0,1%
if /i "%choice%"=="1" goto chaw_act
if /i "%choice%"=="0" goto menu
echo 选择无效，请重新输入
echo.
goto Windows_act_status
:chaw_act
echo Windows激活状态查询中......
Winver

slmgr.vbs -dlv

slmgr.vbs -dli

slmgr.vbs -xpr
pause
goto menu


:office_act_status


echo 当前菜单查询Office激活状态，确认请按1
echo 返回上级请按0键
echo.
set choice=
set /p choice=          请选择:
IF NOT "%choice%"=="" SET choice=%choice:~0,1%
if /i "%choice%"=="1" goto chao_act
if /i "%choice%"=="0" goto menu
echo 选择无效，请重新输入
echo.
goto office_act_status

:chao_act
echo Office激活状态查询中......

set "FileName=ospp.vbs"
echo 正在搜索Office安装目录，请稍候...
for %%a in (C D) do (
  if exist %%a:\ (
    pushd %%a:\
    for /r %%b in (*%FileName%) do (
      if /i "%%~nxb" equ "%FileName%" (
        set ffile=%%~pb
echo 本机Office所在目录
        echo,%%~dpb
		
		goto cd_office
		
  
	  )
    )

    popd
  )
)

:cd_office
echo  尝试定位到Office目录......
cd /d %ffile%

echo %CD%
echo #####################################成功进入Office目录#######################################

echo Office激活状态查询中......

cscript ospp.vbs /dstatus
pause

goto menu

rem 垃圾清理
:clean

echo 当前菜单Windows垃圾，确认清理请按1
echo 若返回上级请按0键
echo.
set choice=
set /p choice=          请选择:
IF NOT "%choice%"=="" SET choice=%choice:~0,1%
if /i "%choice%"=="1" goto clean1
if /i "%choice%"=="0" goto menu
echo 选择无效，请重新输入
echo.
goto clean

:clean1

echo 清除系统垃圾过程中，请稍等......
del /f /s /q %systemdrive%\*.tmp
del /f /s /q %systemdrive%\*._mp
del /f /s /q %systemdrive%\*.log
del /f /s /q %systemdrive%\*.gid
del /f /s /q %systemdrive%\*.chk
del /f /s /q %systemdrive%\*.old
del /f /s /q %systemdrive%\recycled\*.*
del /f /s /q %windir%\*.bak
del /f /s /q %windir%\prefetch\*.*
rd /s /q %windir%\temp & md %windir%\temp
del /f /q %userprofile%\cookies\*.*
del /f /q %userprofile%\recent\*.*
del /f /s /q "%userprofile%\Local Settings\Temporary Internet Files\*.*"
del /f /s /q "%userprofile%\Local Settings\Temp\*.*"
del /f /s /q "%userprofile%\recent\*.*"
echo 清除系统垃圾完成!
pause 
goto menu

:endd
echo #################################感谢使用KMS激活脚本，Goodbye！#################################
pause
