@echo off

REM If you used the stand Cygwin installer this will be C:\cygwin64
set CYGWIN=C:\cygwin64
set HOME=%CYGWIN%\home\kroonwijk
set PATH=%CYGWIN%\bin;%PATH%
REM You can switch this to work with bash with %CYGWIN%\bin\bash.exe
set SH=%CYGWIN%\bin\zsh.exe

"%SH%" -c "/bin/ansible-playbook %*"
