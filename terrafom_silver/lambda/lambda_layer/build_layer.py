import os
import shutil
import subprocess
from pathlib import Path

# Constants
LAYER_ROOT = Path(__file__).parent
REQUIREMENTS_DIR = LAYER_ROOT / "requirements"
OUTPUT_DIR = LAYER_ROOT / "output"

PYTHON_VERSION = "python3.11"

def build_layer(name: str, requirements_file: Path):
    print(f"📦 Building layer: {name} ...")
    layer_dir = LAYER_ROOT / f"python_{name}"
    python_dir = layer_dir / "python"

    # Clean previous build
    if layer_dir.exists():
        shutil.rmtree(layer_dir)
    python_dir.mkdir(parents=True)

    # Install dependencies
    subprocess.run([
        "pip", "install",
        "-r", str(requirements_file),
        "-t", str(python_dir)
    ], check=True)

    # Zip it
    zip_file = OUTPUT_DIR / f"{name}_layer.zip"
    if zip_file.exists():
        zip_file.unlink()
    shutil.make_archive(zip_file.with_suffix(''), 'zip', root_dir=layer_dir)

    print(f"✅ Created {zip_file.name} ({zip_file.stat().st_size / 1024:.1f} KB)")

    # Clean temp dir
    shutil.rmtree(layer_dir)


def main():
    print("🚀 Starting layer build")
    OUTPUT_DIR.mkdir(exist_ok=True)

    for req_file in REQUIREMENTS_DIR.glob("*.txt"):
        layer_name = req_file.stem
        build_layer(layer_name, req_file)

    print("🎉 All layers built!")


if __name__ == "__main__":
    main()
