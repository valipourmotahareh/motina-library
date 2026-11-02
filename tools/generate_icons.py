"""Generate launcher assets without redrawing the approved logo.

Requires Python + Pillow, Dart, and `flutter pub get`.
Run from any directory: python3 tools/generate_icons.py
"""
from pathlib import Path
import subprocess
from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
source = Image.open(ROOT / "assets/branding/app_icon.png").convert("RGB")
size = 1024
image = source.resize((size * 4 // 5,) * 2, Image.Resampling.LANCZOS)
canvas = Image.new("RGB", (size, size), source.getpixel((0, 0)))
canvas.paste(image, ((size - image.width) // 2,) * 2)
canvas.save(ROOT / "assets/branding/app_icon_web.png")

project = ROOT / "ios/Runner.xcodeproj/project.pbxproj"
project_before = project.read_bytes()
# This project already selects AppIcon. v0.14.4 also rewrites unrelated
# ASSETCATALOG settings; retain the exact existing project configuration.
assert "ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;" in project_before.decode()
try:
    subprocess.run(["dart", "run", "flutter_launcher_icons"], cwd=ROOT, check=True)
finally:
    if project.read_bytes() != project_before:
        project.write_bytes(project_before)

# A favicon needs the original framing; maskable PWA icons keep extra padding.
source.resize((32, 32), Image.Resampling.LANCZOS).save(ROOT / "web/favicon.png")
source.resize((180, 180), Image.Resampling.LANCZOS).save(
    ROOT / "web/icons/apple-touch-icon.png"
)
