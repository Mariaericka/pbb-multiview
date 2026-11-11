@echo off
rem === PBB Multiview launcher ===
rem Ilagay ang pbb-multiview.ps1 sa PAREHONG folder ng file na ito.
rem Palitan ang 2 link sa ibaba (Dining at External).
set "URL1=https://www.iwanttfc.com/player/09f9149f-acaa-42ca-a18f-5e2735f5de6a"
set "URL2=https://www.iwanttfc.com/player/92c51d43-6652-4d0c-ab8c-f6fb0e3d5f50"
set "URL3=https://www.iwanttfc.com/player/e11152d0-e76b-49ec-8db9-a1e5142f11da"

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0pbb-multiview.ps1"
if errorlevel 1 pause
