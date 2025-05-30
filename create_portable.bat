@echo off
REM ============================================================
REM   CREAR EJECUTABLE PORTABLE - FACE RECOGNITION MATRIX
REM   Usuario: Alejandro Areiza Alzate
REM   Este script crea un ejecutable completamente portable
REM ============================================================

echo ============================================================
echo   CREANDO EJECUTABLE PORTABLE
echo   Para usar en cualquier PC sin instalaciones
echo ============================================================
echo.

REM Verificar archivos necesarios
echo Verificando archivos necesarios...
if not exist "src\main.py" (
    echo [ERROR] No se encuentra src\main.py
    pause
    exit /b 1
)

if not exist "src\config.py" (
    echo [ERROR] No se encuentra src\config.py
    pause
    exit /b 1
)

echo [OK] Archivos verificados
echo.

REM Instalar PyInstaller si no está disponible
echo Instalando/actualizando PyInstaller...
pip install --upgrade pyinstaller
echo.

REM Limpiar archivos anteriores
echo Limpiando archivos anteriores...
if exist dist rmdir /s /q dist
if exist build rmdir /s /q build
echo.

REM Crear ejecutable con todas las dependencias incluidas
echo Construyendo ejecutable portable...
echo Esto puede tomar 3-5 minutos...
echo.

pyinstaller --onefile ^
    --name "FaceRecognitionMatrix" ^
    --add-data "src\config.py;src" ^
    --add-data "reference_images;reference_images" ^
    --hidden-import cv2 ^
    --hidden-import numpy ^
    --hidden-import face_recognition ^
    --hidden-import dlib ^
    --hidden-import PIL ^
    --hidden-import scipy ^
    --hidden-import scipy.spatial.distance ^
    --hidden-import scipy.spatial.transform ^
    --collect-all face_recognition ^
    --collect-all face_recognition_models ^
    --collect-all cv2 ^
    --noconsole ^
    src\main.py

echo.

REM Verificar si se creó el ejecutable
if exist "dist\FaceRecognitionMatrix.exe" (
    echo ============================================================
    echo   [EXITO] EJECUTABLE PORTABLE CREADO!
    echo ============================================================
    echo.
    echo [INFO] Ubicacion: dist\FaceRecognitionMatrix.exe
    echo [INFO] Tamanio: 
    for %%A in ("dist\FaceRecognitionMatrix.exe") do echo        %%~zA bytes
    echo.
    echo ============================================================
    echo   INSTRUCCIONES PARA USAR EN OTRO PC:
    echo ============================================================
    echo.
    echo 1. Copia estos archivos al PC nuevo:
    echo    - dist\FaceRecognitionMatrix.exe
    echo    - reference_images\ (carpeta con tus 4 fotos)
    echo.
    echo 2. En el PC nuevo:
    echo    - Coloca tus 4 fotos en reference_images\
    echo    - Ejecuta FaceRecognitionMatrix.exe
    echo    - Presiona ESC para salir
    echo.
    echo 3. NO NECESITAS instalar Python ni nada mas!
    echo.
    echo ============================================================
    echo   TU APLICACION MATRIX ESTA LISTA!
    echo ============================================================
    echo.
) else (
    echo ============================================================
    echo   [ERROR] NO SE PUDO CREAR EL EJECUTABLE
    echo ============================================================
    echo.
    echo Posibles soluciones:
    echo 1. Verifica que todas las dependencias esten instaladas
    echo 2. Ejecuta: pip install -r requirements_clean.txt
    echo 3. Intenta nuevamente
    echo.
)

pause
