@echo off

IF "%1"=="" GOTO Continue1

IF "%2"=="" GOTO Continue2

set ASEM51INC=%1\ASEM51\MCU
set DPMIMEM=MAXMEM 16383

ASEM51\asemw %2

:Continue2
rem You need to pass a file to compile

:Continue1
rem You need to pass a PATH LOC