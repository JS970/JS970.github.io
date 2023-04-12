@echo off
REM change USER_NAME to apply system, or set up custom Directory Path
set SRC_DIR="C:\Users\USER_NAME\SynologyDrive\obsidian\roundoff"
set DST_DIR="C:\Users\USER_NAME\Documents\GitHub\JS970.github.io"

set PL_SRC=%SRC_DIR%\PL
set OS_SRC=%SRC_DIR%\OS
set SSD_SRC=%SRC_DIR%\SSD
set ALGO_SRC=%SRC_DIR%\Algorithm

set PL_DST=%DST_DIR%\content
set OS_IMG_DST=%DST_DIR%\static\image\OS
set PL_IMG_DST=%DST_DIR%\static\image\PL
set SSD_IMG_DST=%DST_DIR%\static\image\SSD
set ALGO_IMG_DST=%DST_DIR%\static\image\Algorithm

REM Copy all .md files from PL, OS, SSD, and Algorithm directories to the content directory
xcopy /s /y %PL_SRC%\*.md %PL_DST%
xcopy /s /y %OS_SRC%\*.md %PL_DST%
xcopy /s /y %SSD_SRC%\*.md %PL_DST%
xcopy /s /y %ALGO_SRC%\*.md %PL_DST%

REM Copy all .png files from OS directory to the OS image destination directory
xcopy /s /y %SRC_DIR%\image\OS\*.png %OS_IMG_DST%

REM Copy all .png files from PL directory to the PL image destination directory
xcopy /s /y %SRC_DIR%\image\PL\*.png %PL_IMG_DST%

REM Copy all .png files from SSD directory to the SSD image destination directory
xcopy /s /y %SRC_DIR%\image\SSD\*.png %SSD_IMG_DST%

REM Copy all .png files from Algorithm directory to the Algorithm image destination directory
xcopy /s /y %SRC_DIR%\image\Algorithm\*.png %ALGO_IMG_DST%

echo All files have been copied successfully!
pause
