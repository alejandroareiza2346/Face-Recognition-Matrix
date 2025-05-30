@echo off
REM ============================================================
REM   PROCESO COMPLETO AUTOMATIZADO
REM   1. Instala dependencias
REM   2. Captura fotos (si hay cámara)
REM   3. Crea ejecutable portable
REM ============================================================

title Face Recognition Matrix - Proceso Automatizado

echo ============================================================
echo   FACE RECOGNITION MATRIX - PROCESO AUTOMATIZADO
echo   Usuario: Alejandro Areiza Alzate
echo ============================================================
echo.
echo Este script hara todo automaticamente:
echo 1. Instalar dependencias necesarias
echo 2. Capturar fotos de referencia (si hay camara)
echo 3. Crear ejecutable portable
echo.
echo Presiona cualquier tecla para continuar...
pause >nul

REM Paso 1: Instalar dependencias
echo.
echo ============================================================
echo   PASO 1: INSTALANDO DEPENDENCIAS
echo ============================================================
pip install -r requirements_clean.txt
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Fallo la instalacion de dependencias
    pause
    exit /b 1
)
echo [OK] Dependencias instaladas

REM Paso 2: Verificar si hay cámara y capturar fotos
echo.
echo ============================================================
echo   PASO 2: CAPTURAR FOTOS DE REFERENCIA
echo ============================================================
echo.
echo Intentando detectar camara web...
python -c "import cv2; cap = cv2.VideoCapture(0); print('Camara detectada' if cap.isOpened() else 'No hay camara'); cap.release()" 2>nul

if %ERRORLEVEL% EQU 0 (
    echo.
    echo Camara detectada! Deseas capturar fotos ahora?
    echo [S] Si, capturar fotos ahora
    echo [N] No, usare fotos que ya tengo
    echo [C] Cancelar proceso
    echo.
    set /p choice="Elige una opcion (S/N/C): "
    
    if /I "%choice%"=="S" (
        echo.
        echo Iniciando captura de fotos...
        python capture_reference_photos.py
        if %ERRORLEVEL% NEQ 0 (
            echo [ERROR] Fallo la captura de fotos
            pause
            exit /b 1
        )
    ) else if /I "%choice%"=="C" (
        echo Proceso cancelado por el usuario
        pause
        exit /b 0
    )
) else (
    echo [INFO] No hay camara detectada
    echo [INFO] Asegurate de tener 4 fotos en reference_images\ antes de continuar
    echo.
    echo Presiona cualquier tecla para continuar con la creacion del ejecutable...
    pause >nul
)

REM Paso 3: Crear ejecutable portable
echo.
echo ============================================================
echo   PASO 3: CREANDO EJECUTABLE PORTABLE
echo ============================================================
call create_portable.bat

echo.
echo ============================================================
echo   PROCESO COMPLETADO!
echo ============================================================
echo.
echo Si todo salio bien, ya tienes:
echo - dist\FaceRecognitionMatrix.exe (ejecutable portable)
echo - reference_images\ (carpeta con fotos)
echo.
echo Para usar en otro PC:
echo 1. Copia ambos archivos al PC nuevo
echo 2. Ejecuta FaceRecognitionMatrix.exe
echo 3. Listo!
echo.
pause
