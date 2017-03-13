@ECHO OFF
REM  QBFC Project Options Begin
REM  HasVersionInfo: Yes
REM  Companyname: 巨站
REM  Productname: KMS激活工具
REM  Filedescription: Microsoft的产品的KMS激活
REM  Copyrights: Gatoslu
REM  Trademarks: 
REM  Originalname: 
REM  Comments: 
REM  Productversion:  1. 0. 0. 5
REM  Fileversion:  1. 0. 0. 5
REM  Internalname: https://www.github.com/gatoslu
REM  Appicon: microsoft_64px_1202642_easyicon.net.ico
REM  AdministratorManifest: No
REM  QBFC Project Options End
@ECHO ON
@echo off
mode con cols=99 lines=35 & color 2f
title KMS激活工具
setlocal enabledelayedexpansion
set a=▉&set b=69&set c=%% 
set space= 
:startkms

set a=%a%▉
set/a b-=2
set/a num+=3
if %num%==12 set/a b-=1
call set space=%%space:~0,%b%%%
if %num% gtr 100 set num=100%%&&set c=
echo.
echo.
echo   ============================KMS激活工具启动中，请稍后......====================================
echo            ┏—————————————————————————————————————┓
echo            │%a%%space%%num%%c%│
echo            ┗—————————————————————————————————————┛
echo   ===============================================================================================
ping/n 1 127.1>nul
if "%num%" neq "100%%" cls&goto startkms
echo.
echo.

rem 寻找office安装目录
set "FileName=ospp.vbs"
echo   ===============================正在搜索Office安装目录，请稍候...===============================
for %%a in (C D) do (
  if exist %%a:\ (
    pushd %%a:\
    for /r %%b in (*%FileName%) do (
      if /i "%%~nxb" equ "%FileName%" (
        set ffile=%%~pb
echo.	
echo.	
echo   =====================================Office所在目录============================================
        echo,%%~dpb
		goto cd_office 
	  )
    )
    popd
  )
)
echo.
echo.
:cd_office
echo.
echo.
echo   ==================================尝试定位到Office目录......===================================
cd /d %ffile%

echo %CD%
echo.
echo.
echo   ===================================成功定位Office目录==========================================

pause
rem 寻找office安装目录

echo.
echo.


cls
echo   ===============================================================================================
echo                                  欢迎使用KMS激活工具!
echo                 本工具可激活VOL版Windows7,8,8.1,10;Office2007,2010,2013,2016
echo                      请按照自己需要激活的软件类型选择对应激活方式
echo         激活后每隔30天自动向远方KMS服务器发送激活请求，理论上无限续杯！（KMS服务端还在的话！）
echo                注意：本脚本需要管理员权限运行，否则可能出现无法激活的现象
echo                    Copyright@Gatoslu   如有问题请联系：lbcfez@gmail.com
echo   ===============================================================================================



ver 
echo.
echo 当前日期：%DATE%  %TIME%
echo. 
echo 当前目录：%CD%  
echo.
echo.
echo 当前系统版本：
wmic os get caption 



pause

rem 设置KMS服务器地址
:setkms
CLS
SET setkms=
echo   =============================================================================================== 
echo   ============IP地址格式：8.8.8.8 ；域名格式：www.baidu.com  请按格式输入然后按回车键============
echo   =============注意：如输入格式错误将无法完成激活，不知道KMS服务器地址直接按下回车键=============     
echo   ===============================================================================================      
SET /P setkms="请输入KMS域名或IP地址[默认:kms.03k.org]:"
IF "%setkms%"=="" (
SET setkms="kms.03k.org"
echo.
echo 用户未指定KMS地址
 )
echo.
echo 已设置KMS地址为：%setkms%

echo.

echo   ================================正在检测KMS服务及网络，请稍后......============================

echo.
ping -n 2 %setkms%>%temp%\1.ping & ping -n 2 223.6.6.6>>%temp%\1.ping    
findstr "TTL" %temp%\1.ping>nul
if %errorlevel%==0 (echo     √ KMS服务及外网正常) else (echo     × KMS服务器异常或外网不通) 
if exist %temp%\*.ping del %temp%\*.ping          
echo.
pause
goto menu
                        
rem 选择菜单

:menu
cls
echo.
echo              ==============================
echo              请选择要进行的操作，然后按回车
echo              ==============================
echo.
echo              1.设置KMS服务器地址
echo.
echo              2.查询Windows激活状态
echo.
echo              3.查询Office激活状态
echo.
echo              4.激活Windows系统
echo.
echo              5.激活Office办公套件
echo.
echo              6.本机网络检查
echo.
echo              7.清理系统垃圾，加快电脑运行速度
echo.
echo              Q.退出
echo.
echo.
:cho
set choice=
set /p choice=          请选择:
IF NOT "%choice%"=="" SET choice=%choice:~0,1%
if /i "%choice%"=="1" goto setkms
if /i "%choice%"=="2" goto windows_act_status_m
if /i "%choice%"=="3" goto office_act_status_m
if /i "%choice%"=="4" goto windows_m
if /i "%choice%"=="5" goto office_m
if /i "%choice%"=="6" goto checknet
if /i "%choice%"=="7" goto clean
if /i "%choice%"=="Q" goto endd
echo 选择无效，请重新输入
echo.
goto cho



rem Windows激活
:windows_m
cls
echo              ===================
echo              当前菜单Windows激活
echo              ===================
echo              1.确认激活
echo.
echo              0.返回上级
echo.
echo.
:windows
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
echo 准备配置KMS激活服务器
pause
echo   ==================================配置Windows激活KMS服务器中......=============================
slmgr /skms %setkms%
echo   ==================================服务器配置完毕，准备激活=====================================
pause
echo   ==================================准备向服务发送激活请求中......===============================
slmgr /ato

echo   ==================================向服务发送激活请求中......===================================




echo   =================================Windows激活完成！    Enjoy it! ===============================
pause
goto menu

rem office激活
:office_m
cls
echo              ==================
echo              当前菜单Office激活
echo              ==================
echo              1.确认激活
echo.
echo              0.返回上级
echo.

echo.




:office

set choice=
set /p choice=          请选择:
IF NOT "%choice%"=="" SET choice=%choice:~0,1%
if /i "%choice%"=="1" goto office_act
if /i "%choice%"=="0" goto menu
echo 选择无效，请重新输入
echo.
goto office

:office_act

echo   ====================================尝试定位到Office目录...====================================
cd /d %ffile%

echo %CD%
echo   =====================================已进入Office目录==========================================

echo   =====================================开始配置KMS服务器...======================================
cscript ospp.vbs /sethst:%setkms%
echo   ================================配置服务器完成！向服务器发送激活请求...========================

cscript ospp.vbs /act
                                                                        
echo   =================================服务响应激活许可，完成激活中......============================
echo   =================================Office激活完成！  Enjoy it! ==================================
pause
goto menu

:windows_act_status_m
cls

echo              ===========================
echo              当前菜单查询Windows激活状态
echo              ===========================
echo              1.确认查询
echo.
echo              0.返回上级
echo.
echo.

:windows_act_status

set choice=
set /p choice=          请选择:
IF NOT "%choice%"=="" SET choice=%choice:~0,1%
if /i "%choice%"=="1" goto chaw_act
if /i "%choice%"=="0" goto menu
echo 选择无效，请重新输入
echo.
goto Windows_act_status


:chaw_act

echo   =====================================Windows激活状态查询中......===============================

Winver

slmgr.vbs -dlv

slmgr.vbs -dli

slmgr.vbs -xpr
pause
goto menu

:office_act_status_m
cls
echo              ==========================
echo              当前菜单查询Office激活状态
echo              ==========================
echo              1.确认查询
echo.
echo              0.返回上级
echo.

echo.

:office_act_status

set choice=
set /p choice=          请选择:
IF NOT "%choice%"=="" SET choice=%choice:~0,1%
if /i "%choice%"=="1" goto chao_act
if /i "%choice%"=="0" goto menu
echo 选择无效，请重新输入
echo.
goto office_act_status

:chao_act
echo   ======================================尝试定位到Office目录......===============================
cd /d %ffile%

echo %CD%
echo   ======================================成功进入Office目录=======================================
     
echo   ======================================Office激活状态查询中......===============================

cscript ospp.vbs /dstatus
pause

goto menu

:clean_m

cls
echo              =======================
echo              当前菜单Windows垃圾清理
echo              =======================
echo              1.确认清理
echo.
echo              0.返回上级
echo.

echo.

rem 垃圾清理
:clean

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

:checknet
cls
Rem '/*/////设置选项///////////////
set "Space= "
set "IP_cfg=%Space%IP Address "
set "GateWay=%Space%Default Gateway "
set "DNS=%Space%DNS Servers "
Rem '/*////////主程序//////////////
for /f "tokens=1,* delims=." %%i in ('ipconfig /all') do (
     for %%a in (IP_cfg GateWay DNS) do (
         if "%%i"=="!%%a!" (
             Rem '/*-------将结果传回各变量名--------*/
             set %%a=%%j
          )
     )
)
Rem '/*============对结果进行整理===============*/
echo 检查结果：
echo ======================
Rem '/*------处理IP------*/
set IP_cfg=%IP_cfg:*:=%
echo 检查网卡及其配置......

ping %IP_cfg% -n 2|find "Request timed out." && echo 网卡安装或配置有问题 ||echo √ 网卡正常：%IP_cfg%
echo.
Rem '/*-----处理网关-----*/
echo 检查网关......

set GateWay=%GateWay:*:=%
ping %GateWay% -n 2|find "Request timed out." && echo 网关有问题 ||echo √ 网关正常：%GateWay%
echo.
Rem '/*-----处理DNS-----*/
echo 正在检查DNS......
set DNS=%DNS:*:=%
ping %DNS% -n 2|find "Request timed out." &&echo DNS有问题 ||echo √ DNS正常：%DNS%
echo.
echo 正在检查KMS服务器......
set KMS=%setkms%
ping %KMS% -n 2|find "Request timed out." &&echo KMS服务器有问题 ||echo √ KMS服务器正常：%KMS%
echo.
pause
goto menu



:endd

echo   ===============================================================================================
echo   =================================感谢使用KMS激活脚本，Goodbye！================================
echo   ===============================================================================================
pause
@echo on
