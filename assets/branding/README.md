# App icon assets

`app_icon.png` is the approved source, preserved byte-for-byte:
1254 × 1254, opaque RGB PNG.
SHA-256: `7e92dfe282bbf94b4f74f989641bfbb81229a4cfa7e7619902bcb5e9d2251fb4`.
The art is a flattened illustration, not separate foreground/background layers.

Regenerate using Python with Pillow and the Flutter/Dart SDK installed:

```sh
flutter pub get
python3 tools/generate_icons.py
```

The only added Flutter package is the development tool
`flutter_launcher_icons` 0.14.4 (configuration in the repository root).
The wrapper preserves the Xcode project file because that tool version can
rewrite unrelated ASSETCATALOG settings. AppIcon was already selected.

- Android: existing `@mipmap/ic_launcher`, five legacy densities, and an API 26+
  adaptive foreground over cream `#FAEDDB`. The supplied flattened image is
  retained intact with a 20% foreground inset. This preserves the design, but
  does not provide independent parallax for logo/background. A measured
  dark/green artwork radius is approximately 31.2 dp, within the 33 dp safe
  radius; circular mask previews were inspected. Confirm on actual launchers.
- iOS: opaque RGB AppIcon catalog, including 1024-pixel marketing image.
  No baked rounded corners; iOS applies the mask.
- Web: deterministic `app_icon_web.png` places the full source square at 80%
  scale on a cream canvas. This protects the illustrated mark within the
  maskable 80%-diameter safe circle; it does not redraw the art. PWA icons are
  192/512 pixels. Favicon uses the original framing at 32 pixels; Apple touch
  icon uses 180 pixels. Manifest and HTML reference the generated files.

The silhouette remains recognizable at 16–48 pixels; fine book detail naturally
softens. No monochrome layer is declared: this opaque detailed illustration is
not an approved alpha silhouette, and flattening it into a solid square would
produce an incorrect themed icon. A separately approved monochrome/transparent
master is needed for a faithful Android themed variant. Original artwork is
not bundled into the Flutter UI merely to generate launcher assets.
