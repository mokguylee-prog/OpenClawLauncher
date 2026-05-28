#!/usr/bin/env python3
"""OpenClaw favicon.svg → AppIcon.icns 변환 스크립트"""
import subprocess
import shutil
import tempfile
from pathlib import Path
from PIL import Image

OPENCLAW_SVG = Path("/usr/local/lib/node_modules/openclaw/dist/control-ui/favicon.svg")
ROOT = Path(__file__).resolve().parent.parent
RESOURCES = ROOT / "Sources" / "OpenLauncher" / "Resources"
ICONSET = RESOURCES / "AppIcon.iconset"
ICNS = RESOURCES / "AppIcon.icns"

SIZES = [16, 32, 64, 128, 256, 512, 1024]

def svg_to_png(svg_path: Path, size: int, out_path: Path):
    """qlmanage를 사용해 SVG → PNG 변환 (macOS 내장)"""
    with tempfile.TemporaryDirectory() as tmp:
        tmp_svg = Path(tmp) / "icon.svg"
        shutil.copy(svg_path, tmp_svg)
        subprocess.run(
            ["qlmanage", "-t", "-s", str(size), "-o", tmp, str(tmp_svg)],
            check=True, capture_output=True
        )
        generated = Path(tmp) / "icon.svg.png"
        img = Image.open(generated).convert("RGBA").resize((size, size), Image.LANCZOS)
        img.save(out_path)

def main():
    if not OPENCLAW_SVG.exists():
        raise FileNotFoundError(f"OpenClaw SVG not found: {OPENCLAW_SVG}")

    ICONSET.mkdir(parents=True, exist_ok=True)

    for size in SIZES:
        out = ICONSET / f"icon_{size}x{size}.png"
        svg_to_png(OPENCLAW_SVG, size, out)
        print(f"  {out.name}")

    subprocess.run(
        ["iconutil", "-c", "icns", str(ICONSET), "-o", str(ICNS)],
        check=True
    )
    print(f"Generated {ICNS}")

if __name__ == "__main__":
    main()
