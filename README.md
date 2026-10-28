# QR Studio — QR Scanner (repackaged + Adsterra Smartlink)

Fork / repackage of the **QR Studio – QR Scanner** Android app where:

1. The application ID has been changed from `com.nihadapps.qrstudio` →
   `nihadapps.qrstudio` (the leading `com.` segment was removed).
2. An **Adsterra Smartlink** is integrated as a clearly-labelled
   "Sponsored Offers" button in the History tab. The Smartlink opens
   only when the user explicitly taps that button — it is launched in
   the device's default browser via `Intent.ACTION_VIEW`.

> **Nothing else changed.** Same app name, same icon, same permissions,
> same version, same Java/JavaScript code, same WebView shell, same QR
> scanner / generator / camera / gallery / history flow. The only
> behavioural change is: tapping "Sponsored Offers" opens
> `https://asiafilm.org/4/f6fa51c0b2df90b6748dd3ff46b8008c` in the
> system browser.

## What is in this repo

```
.
├── NihadQRScanner.apk      # Final signed APK (v1+v2+v3 signed), ready to install
├── app-src/                # apktool-decoded project (manifest + smali + res + assets)
│   ├── AndroidManifest.xml
│   ├── apktool.yml
│   ├── assets/www/index.html   # QR scanner / generator / history web UI + new sponsor button
│   ├── res/                    # icons + strings + theme
│   └── smali/nihadapps/qrstudio/   # MainActivity + R classes
│       ├── MainActivity.smali
│       ├── MainActivity$1.smali     # WebViewClient — now intercepts asiafilm.org
│       ├── MainActivity$2.smali     # WebChromeClient — file chooser (gallery) — unchanged
│       ├── MainActivity$2$1.smali    # FilePathCallback — unchanged
│       └── R*.smali                 # generated resources — unchanged
├── build.sh                # one-shot rebuild + zipalign + sign script
└── tools/
    └── apktool.jar         # apktool 2.9.3 (build dependency)
```

## What was changed (vs the previous commit)

### `app-src/smali/nihadapps/qrstudio/MainActivity$1.smali`

The `WebViewClient.shouldOverrideUrlLoading` method (both modern
`WebResourceRequest` and legacy `String` variants) was modified to:

1. Get the URL host.
2. If the host is exactly `"asiafilm.org"`, build an
   `Intent(ACTION_VIEW, uri)` and start it via the WebView's Context
   — i.e. hand it off to the user's default browser.
3. Return `true` (we handled it) so the WebView does not load the
   Smartlink itself (which would break Adsterra's redirect/cookie
   tracking and is against their policies).
4. For **every other URL** (including `file:///android_asset/...`,
   `about:blank`, and any other host), return `false` — i.e. the
   exact original behaviour is preserved.

### `app-src/assets/www/index.html`

Two additions:

1. A new icon entry `gift:'<svg ...>'` was added to the inline icon set
   (used only by the sponsor button).
2. A clearly-labelled "Sponsored Offers" `<a class="btn sponsor-btn">`
   was added at the bottom of the History section. The link points to
   the Adsterra Smartlink. It uses `target="_blank"` and
   `rel="noopener noreferrer"`.
3. A small `.sponsor-btn` style was added (smaller, muted purple-cyan
   dashed border, opacity 0.85) so the button is clearly distinguished
   from the primary app CTAs and visually marked as "external".

### `app-src/AndroidManifest.xml` — **unchanged**

No new permissions, no `<queries>` block, no new activities. The
`<queries>` requirement for `Intent.ACTION_VIEW` with `http(s)` schemes
does **not** apply because we call `startActivity()` directly (the
system itself resolves the user's default browser).

## What was NOT changed (verified identical via aapt)

- App label: `QR Studio - QR Scanner`
- App icon (adaptive + per-density PNGs)
- All 5 permissions: `INTERNET`, `ACCESS_NETWORK_STATE`, `CAMERA`,
  `READ_MEDIA_IMAGES`, `READ_EXTERNAL_STORAGE` (maxSdk=32)
- SDK versions: min 23 / target 34 / compile 34
- Version: `versionCode=1`, `versionName=1.0`
- The entire QR scanner / generator / history JavaScript (only one
  new button and one new CSS rule added at the bottom of the
  History section)
- All WebView settings (JS enabled, DOM storage, file access, etc.)
- The Java side of `MainActivity` (`onCreate`, `configureWebView`,
  `loadApp`, `onActivityResult`, `onPause`, `onResume`, `onDestroy`,
  `onRequestPermissionsResult`, `onStart`, `onKeyDown`) — unchanged
- The `WebChromeClient` (file chooser for gallery scanning) — unchanged

## Adsterra policy compliance

| Requirement                                     | Status |
| ----------------------------------------------- | ------ |
| Auto-open ads on app start                      | ❌ NOT done — opens only on explicit tap |
| Auto-open ads on QR scan                        | ❌ NOT done |
| Auto-open ads on QR generate                    | ❌ NOT done |
| Auto-open ads on history view                   | ❌ NOT done |
| Hidden iframes / invisible ads                  | ❌ NOT done |
| Forced redirects                               | ❌ NOT done |
| Forced clicks                                  | ❌ NOT done |
| Personal info collection                       | ❌ NOT done (no new permissions) |
| Additional permissions for ads                  | ❌ NOT added |
| Clearly labelled sponsor button                | ✅ "Sponsored Offers" with gift icon |
| Smartlink opened in default browser (not WebView) | ✅ via `Intent.ACTION_VIEW` |
| Existing camera + gallery permissions preserved | ✅ Verified via aapt diff |

## Reproducing the APK

```bash
# 1. Download Android build-tools (one-time)
mkdir -p tools
curl -fsSL https://dl.google.com/android/repository/build-tools_r34-linux.zip -o tools/bt.zip
unzip -q tools/bt.zip -d tools && rm tools/bt.zip

# 2. Rebuild + sign
./build.sh
```

After it finishes you will have a fresh `NihadQRScanner.apk` in the
repo root.

## Install + test

```bash
adb install -r NihadQRScanner.apk
```

Test matrix (recommended before publishing):

| # | Test                                                  | Expected result |
| - | ----------------------------------------------------- | ---------------- |
| 1 | Launch app                                            | Opens to Scan tab, no ads |
| 2 | Tap "Start camera" → scan a QR code                   | Works as before; no ads |
| 3 | Tap gallery icon → pick image with QR                 | Works as before; no ads |
| 4 | Switch to Create tab → generate a QR                  | Works as before; no ads |
| 5 | Switch to History tab → see scans                     | Scans listed; "Sponsored Offers" button visible at bottom |
| 6 | Tap "Sponsored Offers"                                 | Opens default browser → loads Adsterra Smartlink → redirects to ad |
| 7 | Back to app                                            | App state preserved; no auto-popup |
| 8 | Background → resume                                    | No new ad popups |
| 9 | Cold start with no internet                           | App still loads; sponsor button shows but tapping may fail until online |

## ⚠️ Notes

- **Two-segment package name**: `nihadapps.qrstudio` has only two
  segments. Google Play requires ≥ 3 segments. For sideloading and
  most channels this is fine; for the Play Store use something like
  `pk.nihadapps.qrstudio`.
- **Adsterra Smartlink is a redirect URL**: it requires a real browser
  to handle the redirects, cookies, and JavaScript properly. Opening
  it in a WebView (instead of the system browser) would break tracking
  and may be flagged by Adsterra as invalid traffic. The integration
  in this repo always uses `Intent.ACTION_VIEW` to ensure the
  Smartlink opens in the user's default browser.
- **Signing key**: the APK is signed with a self-signed keystore
  committed to this repo's `tools/` (git-ignored). For production,
  replace `tools/release.keystore` with your own release key and
  re-run `build.sh`.
