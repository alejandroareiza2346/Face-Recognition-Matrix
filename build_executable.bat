@echo off
REM Script para crear ejecutable de Face Recognition Matrix
echo =====================================================
echo   FACE RECOGNITION MATRIX - BUILD SCRIPT
echo   Usuario: Alejandro Areiza Alzate
echo   Configurado para: ESTUDIANTE  
echo =====================================================
echo.

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

echo Instalando PyInstaller compatible...
pip install pyinstaller>=6.10.0
echo.

echo Limpiando archivos anteriores...
if exist dist rmdir /s /q dist
if exist build rmdir /s /q build
echo.

echo Construyendo ejecutable...
pyinstaller FaceRecognitionMatrix.spec --clean --noconfirm
echo.

if exist "dist\FaceRecognitionMatrix.exe" (
    echo =====================================================
    echo   [OK] EJECUTABLE CREADO EXITOSAMENTE!
    echo =====================================================
    echo.
    echo [INFO] Ubicacion: dist\FaceRecognitionMatrix.exe
    echo [INFO] Tamanio aproximado: ~100MB
    echo.
    echo INSTRUCCIONES DE USO:
    echo ================================
    echo 1. Copia la carpeta 'reference_images' con tus fotos
    echo    al mismo directorio que FaceRecognitionMatrix.exe
    echo.
    echo 2. Ejecuta FaceRecognitionMatrix.exe
    echo.
    echo 3. Presiona ESC para salir
    echo.
    echo TIP: Para mejores resultados, usa buena iluminacion
    echo =====================================================
    echo.
    pause
) else (
    echo [ERROR] No se pudo crear el ejecutable
    echo Revisa los mensajes de error arriba
    pause
)