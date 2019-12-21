@ECHO OFF
SETLOCAL

SET THISDIR=%~dp0
SET PYTHONPATH=%THISDIR%;%USERPROFILE%\.virtualenvs\venv_hy_blender\Lib\site-packages;%PYTHONPATH%
SET BLENDER_EXE="C:\Program Files\Blender Foundation\Blender 2.81\blender.exe"

%BLENDER_EXE%