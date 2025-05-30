# Face Recognition Matrix Edition - Setup Guide

## Para desarrolladores

### Instalación de dependencias:
```bash
pip install -r requirements_clean.txt
```

### Ejecutar en modo desarrollo:
```bash
python src/main.py
```

## Para crear el ejecutable

### Método 1: Script automático (Recomendado)
```bash
./build_executable.bat
```

### Método 2: Manual con PyInstaller
```bash
pyinstaller --onefile --name "FaceRecognitionMatrix" \
    --add-data "reference_images;reference_images" \
    --hidden-import cv2 \
    --hidden-import numpy \
    --hidden-import face_recognition \
    --hidden-import dlib \
    --hidden-import PIL \
    --hidden-import scipy \
    --collect-all face_recognition \
    --collect-all face_recognition_models \
    src/main.py
```

## Estructura final para distribución:
```
FaceRecognitionMatrix/
├── FaceRecognitionMatrix.exe
├── reference_images/
│   ├── juan_01.jpg
│   ├── juan_02.jpg
│   ├── juan_03.jpg
│   └── juan_04.jpg
└── README_USER.txt
```

## Notas importantes:
- El ejecutable debe estar en la misma carpeta que `reference_images/`
- Agregar las 4 imágenes de Juan Pérez antes de distribuir
- El ejecutable funcionará sin Python instalado en el PC destino
