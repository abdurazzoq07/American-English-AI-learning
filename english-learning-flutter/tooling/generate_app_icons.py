#!/usr/bin/env python3
"""Generate native app icons from the supplied square icon master image."""

from pathlib import Path
from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "assets" / "app_icon_source.png"
ANDROID_RES = ROOT / "android" / "app" / "src" / "main" / "res"
WINDOWS_ICON = ROOT / "windows" / "runner" / "resources" / "app_icon.ico"
APP_ASSET = ROOT / "assets" / "app_icon.png"

ANDROID_SIZES = {
    "mipmap-mdpi": 48,
    "mipmap-hdpi": 72,
    "mipmap-xhdpi": 96,
    "mipmap-xxhdpi": 144,
    "mipmap-xxxhdpi": 192,
}
WINDOWS_SIZES = [(16, 16), (24, 24), (32, 32), (48, 48), (64, 64), (128, 128), (256, 256)]


def main() -> None:
    if not SOURCE.is_file():
        raise SystemExit(f"Icon master image not found: {SOURCE}")

    with Image.open(SOURCE) as source:
        if source.width != source.height:
            raise SystemExit(
                f"Icon master must be square to avoid cropping; got {source.size}"
            )
        rgba = source.convert("RGBA")
        icc = source.info.get("icc_profile")

    APP_ASSET.parent.mkdir(parents=True, exist_ok=True)
    rgba.resize((512, 512), Image.Resampling.LANCZOS).save(
        APP_ASSET, format="PNG", optimize=True, icc_profile=icc
    )

    for folder, size in ANDROID_SIZES.items():
        target_dir = ANDROID_RES / folder
        target_dir.mkdir(parents=True, exist_ok=True)
        rgba.resize((size, size), Image.Resampling.LANCZOS).save(
            target_dir / "ic_launcher.png",
            format="PNG",
            optimize=True,
            icc_profile=icc,
        )

    WINDOWS_ICON.parent.mkdir(parents=True, exist_ok=True)
    rgba.save(
        WINDOWS_ICON,
        format="ICO",
        sizes=WINDOWS_SIZES,
        icc_profile=icc,
    )

    with Image.open(WINDOWS_ICON) as icon:
        ico_sizes = sorted(icon.ico.sizes())
    if not set(WINDOWS_SIZES).issubset(set(ico_sizes)):
        raise SystemExit(f"Windows ICO is missing expected sizes: {ico_sizes}")

    print(f"Master: {SOURCE.relative_to(ROOT)} ({rgba.width}x{rgba.height})")
    print(f"In-app image: {APP_ASSET.relative_to(ROOT)} (512x512)")
    print(f"Android launcher densities: {', '.join(ANDROID_SIZES)}")
    print(f"Windows icon: {WINDOWS_ICON.relative_to(ROOT)} ({ico_sizes})")


if __name__ == "__main__":
    main()
