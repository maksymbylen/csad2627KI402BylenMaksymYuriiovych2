@echo off
setlocal

if not exist ".venv\Scripts\python.exe" (
  py -3 -m venv .venv
)

.venv\Scripts\python.exe -m pip install -r requirements.txt
if errorlevel 1 exit /b %errorlevel%

.venv\Scripts\python.exe -m pytest
if errorlevel 1 exit /b %errorlevel%

if not exist "dist" mkdir dist
copy /Y "src\hello.py" "dist\hello.py"
if errorlevel 1 exit /b %errorlevel%
