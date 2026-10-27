# QR Studio — QR Scanner (repackaged)

Fork / repackage of the **QR Studio – QR Scanner** Android app where the
application ID has been changed from `com.nihadapps.qrstudio` →
`nihadapps.qrstudio` (the leading `com.` segment was removed).

> **Nothing else changed.** Same app name, same icon, same permissions,
> same version, same Java/JavaScript code, same WebView shell. Only the
> package name and the on-disk smali paths were migrated, and the APK
> was re-signed.

## What is in this repo

```
.
├── NihadQRScanner.apk      # Final signed APK (v1+v2+v3 signed), ready to install
├── app-src/                # apktool-decoded project (manifest + smali + res + assets)
│   ├── AndroidManifest.xml
│   ├── apktool.yml
│   ├── assets/www/index.html   # the actual QR scanner / generator / history web UI
│   ├── res/                    # icons + strings + theme
│   └── smali/nihadapps/qrstudio/   # MainActivity + R classes (new package path)
├── build.sh                # one-shot rebuild + zipalign + sign script
└── tools/
    └── apktool.jar         # apktool 2.9.3 (build dependency)
```

You will also need the Android **build-tools** (`aapt`, `aapt2`, `zipalign`,
`apksigner`) — see `build.sh` header for the download URL.

## Reproducing the APK

```bash
# 1. Download Android build-tools (one-time)
mkdir -p tools
curl -fsSL https://dl.google.com/android/repository/build-tools_r34-linux.zip -o tools/bt.zip
unzip -q tools/bt.zip -d tools && rm tools/bt.zip
# now you have tools/android-14/{aapt,aapt2,zipalign,apksigner}

# 2. Rebuild + sign
./build.sh
```

After it finishes you will have a fresh `NihadQRScanner.apk` in the repo
root, byte-for-byte equivalent (modulo signing) to the one already committed.

## What was changed (vs the original APK)

| Item                                | Original                       | New                          |
| ----------------------------------- | ------------------------------ | ---------------------------- |
| `package=` in AndroidManifest.xml   | `com.nihadapps.qrstudio`       | `nihadapps.qrstudio`        |
| Smali directory                     | `smali/com/nihadapps/qrstudio/` | `smali/nihadapps/qrstudio/` |
| Smali class refs (10 files)         | `Lcom/nihadapps/qrstudio/...`  | `Lnihadapps/qrstudio/...`   |
| `MainActivity` (launchable)         | `com.nihadapps.qrstudio.MainActivity` | `nihadapps.qrstudio.MainActivity` |
| Signing key                         | Original developer key         | New self-signed key (this repo) |

## What was NOT changed (verified identical via aapt)

- App label: `QR Studio - QR Scanner`
- App icon (adaptive + per-density PNGs)
- All 5 permissions: `INTERNET`, `ACCESS_NETWORK_STATE`, `CAMERA`,
  `READ_MEDIA_IMAGES`, `READ_EXTERNAL_STORAGE` (maxSdk=32)
- SDK versions: min 23 / target 34 / compile 34
- Version: `versionCode=1`, `versionName=1.0`
- The entire `assets/www/index.html` (where the QR scan / create /
  history logic actually lives) — byte-for-byte identical to the original
- The Java side of `MainActivity` (camera permission + file-chooser
  handlers) — only the package declaration moved, the bytecode is the same

## Install

```bash
adb install -r NihadQRScanner.apk
```

Then grant the **Camera** + **Storage** permissions on first launch.

## ⚠️ Two-segment package name

`nihadapps.qrstudio` has only two segments. Android allows this, but
Google Play enforces reverse-DNS-style names (≥ 3 segments). For
sideloading and most channels this is fine; for the Play Store use
something like `pk.nihadapps.qrstudio`.
