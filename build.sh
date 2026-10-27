#!/usr/bin/env bash
# =====================================================================
#  QR Studio - rebuild + sign script
#  Reproduces NihadQRScanner.apk from app-src/ with package name
#  "nihadapps.qrstudio".
#
#  Prerequisites:
#    - Java 17+          (java -version)
#    - Android build-tools (aapt, aapt2, zipalign, apksigner)
#      Download: https://dl.google.com/android/repository/build-tools_r34-linux.zip
#    - apktool 2.9.x     (already included at ./tools/apktool.jar)
#
#  Usage:
#    BUILD_TOOLS=/path/to/android-14 ./build.sh
#    (defaults to ./tools/android-14 if BUILD_TOOLS is unset)
# =====================================================================
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
APKTOOL_JAR="$ROOT/tools/apktool.jar"
SRC_DIR="$ROOT/app-src"
APK_OUT="$ROOT/build/NihadQRScanner.unsigned.apk"
APK_ALIGNED="$ROOT/build/NihadQRScanner.aligned.apk"
APK_FINAL="$ROOT/NihadQRScanner.apk"

BUILD_TOOLS="${BUILD_TOOLS:-$ROOT/tools/android-14}"
AAPT2="$BUILD_TOOLS/aapt2"
ZIPALIGN="$BUILD_TOOLS/zipalign"
APKSIGNER="$BUILD_TOOLS/apksigner"

# ---- 0. Sanity checks ------------------------------------------------
for b in java "$AAPT2" "$ZIPALIGN" "$APKSIGNER"; do
  command -v "$b" >/dev/null 2>&1 || { echo "ERROR: $b not found"; exit 1; }
done
[ -f "$APKTOOL_JAR" ] || { echo "ERROR: apktool.jar missing at $APKTOOL_JAR"; exit 1; }
[ -d "$SRC_DIR" ]    || { echo "ERROR: app-src/ missing"; exit 1; }

# ---- 1. Keystore -----------------------------------------------------
KEYSTORE="${KEYSTORE:-$ROOT/tools/release.keystore}"
ALIAS="${ALIAS:-nihad-key}"
STOREPASS="${STOREPASS:-nihad1234}"
KEYPASS="${KEYPASS:-nihad1234}"

if [ ! -f "$KEYSTORE" ]; then
  echo "[+] Generating new keystore at $KEYSTORE"
  keytool -genkeypair \
    -keystore "$KEYSTORE" -alias "$ALIAS" \
    -keyalg RSA -keysize 2048 -validity 10000 \
    -storepass "$STOREPASS" -keypass "$KEYPASS" \
    -dname "CN=NihadApps, OU=Mobile, O=NihadApps, L=Karachi, ST=Sindh, C=PK"
fi

# ---- 2. Rebuild with apktool ----------------------------------------
mkdir -p "$ROOT/build"
echo "[+] Rebuilding APK from $SRC_DIR ..."
java -jar "$APKTOOL_JAR" b -f -o "$APK_OUT" "$SRC_DIR"

# ---- 3. Zipalign ----------------------------------------------------
echo "[+] Zipaligning (4-byte) ..."
"$ZIPALIGN" -p -f 4 "$APK_OUT" "$APK_ALIGNED"

# ---- 4. Sign --------------------------------------------------------
echo "[+] Signing (v1+v2+v3) ..."
"$APKSIGNER" sign \
  --ks "$KEYSTORE" --ks-key-alias "$ALIAS" \
  --ks-pass "pass:$STOREPASS" --key-pass "pass:$KEYPASS" \
  --v1-signing-enabled true --v2-signing-enabled true --v3-signing-enabled true \
  --out "$APK_FINAL" "$APK_ALIGNED"

# ---- 5. Verify ------------------------------------------------------
echo "[+] Verifying signature ..."
"$APKSIGNER" verify --verbose "$APK_FINAL" | tail -5

# ---- 6. Confirm package name ---------------------------------------
echo "[+] Final package info:"
"$BUILD_TOOLS/aapt" dump badging "$APK_FINAL" 2>/dev/null | head -2

echo
echo "============================================================"
echo " DONE - signed APK at: $APK_FINAL"
echo "============================================================"
