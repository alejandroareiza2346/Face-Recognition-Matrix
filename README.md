# face-recognition-matrix
**Engineering Lead: Alejandro Areiza Alzate**
**Technical Domain: Computer Vision / Biometric Identification / Desktop Application Engineering**

---

## 1. Executive Summary and Architectural Vision

This project implements a **real-time facial recognition desktop application** — Face Recognition Matrix Edition — built on the `face_recognition` library (dlib-backed 128-dimensional face embedding model) and OpenCV's webcam capture pipeline. The system encodes reference face images into fixed-length embedding vectors at startup, then performs live identity matching on each webcam frame by computing L2 distance between the captured face encoding and all stored reference encodings. The application is packaged as a standalone Windows executable via PyInstaller, eliminating the Python runtime dependency on target machines — enabling deployment in access control, attendance verification, or identity verification contexts without environment setup. The architecture separates the encoding reference database (images in `reference_images/`), the recognition engine (`src/main.py`), and the distribution artifact (`.exe` + assets folder) into three independent layers.

---

## 2. Requirement Analysis and Strategic Alignment

- **Functional:** Real-time face detection and identity matching against a configurable reference image set via webcam; face encoding computed using dlib's ResNet-based 128-dimensional face embedding model; identity match determined by L2 distance threshold comparison against all stored reference encodings; visual overlay on webcam feed displaying match result and confidence; standalone Windows executable distribution requiring no Python installation on target machine; automated build pipeline via `build_executable.bat` (PyInstaller) and `create_portable.bat` (distribution package assembly).
- **Non-Functional:** Executable runs without Python runtime — all dependencies bundled by PyInstaller `--onefile` with `--collect-all face_recognition` and `--collect-all face_recognition_models`; reference images loaded from a relative `reference_images/` path co-located with the executable for portability; `AUTOMATICO.bat` provides single-click environment setup and execution for development mode.
- **Strategic Goal:** A portable, no-install biometric identification prototype demonstrating end-to-end computer vision engineering — from raw webcam frames to identity classification — packaged for non-technical end users in access control or attendance management scenarios.

---

## 3. Technical Stack and Infrastructure

- **Core Language:** Python 3.x
- **Face Recognition Engine:** `face_recognition` 1.x — dlib ResNet-34 model producing 128-dimensional face embeddings; `face_recognition.face_encodings()` for reference encoding generation; `face_recognition.compare_faces()` and `face_recognition.face_distance()` for L2-distance identity matching
- **Underlying Model:** dlib — C++ machine learning library providing HOG-based face detector and ResNet-based face landmark predictor and encoder
- **Computer Vision:** OpenCV (`cv2`) — webcam capture (`VideoCapture`), frame processing, bounding box rendering, text overlay
- **Image Processing:** Pillow (PIL) — reference image loading and format normalization
- **Scientific Computing:** NumPy, SciPy — array operations for encoding vectors and distance computations
- **Packaging:** PyInstaller — `--onefile` mode producing a single `.exe`; hidden imports declared for `cv2`, `numpy`, `face_recognition`, `dlib`, `PIL`, `scipy`; `--add-data` for `reference_images/` asset bundling
- **Execution Environment:** Windows (primary — `.bat` build scripts); `src/main.py` runnable on Linux/macOS in development mode
- **Design Pattern:** Data-driven recognition — reference encodings are computed once at startup from the `reference_images/` directory contents; the recognition loop runs frame-by-frame against the pre-computed encoding set, keeping the hot path free of I/O operations

---

## 4. Engineering Logic and Implementation

The system operates in two phases — an initialization phase at startup and a recognition loop at runtime:

**Initialization Phase:** All image files in `reference_images/` are loaded and passed to `face_recognition.face_encodings()`, which runs dlib's HOG face detector to locate faces and then the ResNet-34 encoder to produce a 128-dimensional float vector per detected face. These vectors are stored in memory as the reference encoding set. Each encoding is associated with a label derived from its filename (e.g. `subject_01.jpg` → label `subject_01`). Startup cost is proportional to the number of reference images — O(n) encoding operations, each constant-time relative to image resolution above the minimum face size.

**Recognition Loop:** Each webcam frame is passed to `face_recognition.face_locations()` (HOG or CNN model, configurable) to detect face bounding boxes. For each detected face, `face_recognition.face_encodings()` extracts a 128-dimensional embedding. `face_recognition.face_distance()` computes the L2 distance between the captured embedding and every reference encoding. The minimum distance value identifies the closest reference match; `face_recognition.compare_faces()` applies a configurable tolerance threshold (default 0.6) to determine whether the match is above the identity confidence threshold. Matched identities are annotated on the frame with a bounding box and label; unmatched faces are labelled as unknown.

- **Model:** dlib ResNet-34 pre-trained on a labeled dataset of ~3 million face images. The 128-dimensional embedding space is structured such that embeddings of the same identity cluster tightly and embeddings of different identities are well-separated — enabling reliable threshold-based classification without retraining.
- **Complexity:** O(n × f) per frame where n is the number of reference encodings and f is the number of faces detected in the frame. Distance computation is a vectorized L2 norm — effectively O(128 × n) floating-point operations per face, negligible on modern hardware for small-to-medium reference sets (< 1,000 identities).
- **Data Structures:** List of NumPy float64 arrays (128-dim) for reference encodings; list of label strings; OpenCV `ndarray` for frame buffer.

---

## 5. Quality Assurance and Systematic Testing

- **Analytical Testing:** PyInstaller hidden import declarations (`--hidden-import cv2`, `--hidden-import dlib`, etc.) verified to prevent missing-module errors in the packaged executable; `--collect-all face_recognition` and `--collect-all face_recognition_models` confirmed to bundle the pre-trained dlib model weights required at runtime.
- **Constructive Testing:** Reference encoding loading validated with a minimum of 2 images per identity to confirm multi-image averaging behavior; identity matching validated against both positive (known identity in frame) and negative (unknown face in frame) test conditions; portable distribution package tested on a clean Windows machine without Python installed to confirm zero-dependency execution.
- **Edge Case Handlers:** No faces detected in frame — recognition loop skips encoding and matching, frame displayed without annotation; reference image with no detectable face — `face_encodings()` returns empty list, image skipped with a logged warning at startup; `reference_images/` directory empty or missing — application raises a structured initialization error before opening the webcam.

---

## 6. Security Governance and Compliance

- **Biometric Data Classification:** Face embeddings are biometric data under Colombian data protection law (Ley 1581 de 2012) and GDPR Article 9 (sensitive personal data). Any production deployment of this system that stores, transmits, or logs face encodings or identity match results must implement appropriate legal basis (consent or legitimate interest assessment), data minimization, retention limits, and SIC-compliant data processing agreements.
- **Reference Image Handling:** Reference images are stored as static files in the `reference_images/` directory. In any production deployment, these images must be obtained with explicit informed consent of the subjects. Reference images of real individuals must not be committed to public version control repositories.
- **No Remote Transmission:** The application performs all face detection and recognition locally. No frame data, encoding vectors, or identity match results are transmitted to any external endpoint. All processing is contained within the local process.
- **Executable Distribution:** The `.exe` produced by PyInstaller bundles all Python dependencies and model weights. Recipients of the distributed executable should verify its integrity via checksum before deployment. The executable should not be distributed through untrusted channels, as it contains the reference identity database in its bundled assets.
- **OWASP Alignment:** For any API wrapper built on top of this recognition engine, mitigate A04 (Insecure Design) by enforcing a minimum confidence threshold before acting on identity match results, and logging all match events for audit trail purposes.

---

## 7. Deployment and Initialization

**Prerequisites (development mode):** Python 3.x, Visual Studio Build Tools (required for dlib compilation on Windows), CMake

```bash
# Clone the repository
git clone https://github.com/alejandroareiza2346/face-reco.git

cd face-reco

# Automated environment setup and run (Windows)
AUTOMATICO.bat

# Manual dependency installation
pip install -r requirements_clean.txt

# Run in development mode
python src/main.py
```

**Add reference images:**

```bash
# Place reference images in the reference_images/ directory
# Naming convention: identity_label_NN.jpg (e.g. subject_a_01.jpg)
# Minimum recommended: 3-5 images per identity for reliable encoding
cp your_reference_images/*.jpg reference_images/
```

**Build standalone Windows executable:**

```bash
# Method 1 — Automated build script (recommended)
build_executable.bat

# Method 2 — Manual PyInstaller command
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

**Create portable distribution package:**

```bash
# Assembles executable + reference_images/ + user README into distribution folder
create_portable.bat
```

**Distribution package structure:**

```
FaceRecognitionMatrix/
├── FaceRecognitionMatrix.exe     # Standalone executable — no Python required
├── reference_images/             # Reference identity images (populate before distribution)
│   ├── subject_a_01.jpg
│   ├── subject_a_02.jpg
│   └── subject_a_03.jpg
└── README_USER.txt               # End-user instructions
```

---

## 8. Repository Structure

```
face-reco/
├── src/
│   └── main.py                   # Recognition engine — webcam loop + face matching
├── reference_images/             # Reference identity images (not committed — populate locally)
├── AUTOMATICO.bat                # Single-click dev environment setup and run
├── build_executable.bat          # PyInstaller build pipeline
├── create_portable.bat           # Distribution package assembly
├── BUILD_INSTRUCTIONS.md         # Developer build reference
└── requirements_clean.txt        # Python dependencies
```

---

## 9. Professional Background

Project designed and developed by **Alejandro Areiza Alzate**, Computer Engineering student at Universidad Autónoma Latinoamericana (UNAULA), Medellín, and GitHub Developer Program member.

- **LinkedIn:** [Alejandro A. Alzate](https://www.linkedin.com/in/alejandroareizaa/)
- **Research (ORCID):** [0009-0002-2116-6918](https://orcid.org/0009-0002-2116-6918)
- **Certifications:** Microsoft Learn Level 6 — 26,950 XP (Azure Identity, Network Security & SQL Security); Cisco; Google; IBM; OWASP Top 10

---

## 10. License

Distributed under the **MIT License**. See `LICENSE` for full terms.

**Privacy notice:** This system processes biometric data (face embeddings). Any production deployment must comply with Colombian data protection law (Ley 1581 de 2012) and applicable international frameworks. Reference images of real individuals must be obtained with explicit informed consent and must not be stored in public repositories.
