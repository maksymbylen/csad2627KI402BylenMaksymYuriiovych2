@echo off
setlocal

if not exist ".venv\Scripts\python.exe" (
  py -3 -m venv .venv
)

.venv\Scripts\python.exe -m pip install -r requirements.txt
.venv\Scripts\python.exe src\hello.py
if errorlevel 1 exit /b %errorlevel%
