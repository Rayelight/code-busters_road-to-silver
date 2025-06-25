from pathlib import Path
import os, shutil, subprocess, zipfile

# 🧭 Répertoire du script (lambda/)
SCRIPT_DIR = Path(__file__).parent.resolve()


def clean(build_dir: Path, package_dir: Path, zip_file: Path):
    print("🧹 Cleaning build directories...")
    shutil.rmtree(build_dir, ignore_errors=True)
    package_dir.mkdir(exist_ok=True)

    if zip_file.exists():
        zip_file.unlink(missing_ok=True)


def install_dependencies(req_file: Path, build_dir: Path):
    if req_file.exists():
        print("📦 Installing dependencies...")
        subprocess.check_call(["pip", "install", "-r", str(req_file), "-t", str(build_dir)])
    else:
        print("⚠️ No requirements.txt found — skipping dependencies.")


def copy_source(build_dir: Path, code_dir: Path):
    print("📁 Copying source files...")
    build_dir.mkdir(parents=True, exist_ok=True)

    for py_file in code_dir.glob("*.py"):
        shutil.copy(py_file, build_dir / py_file.name)


def zip_build(zip_file: Path, build_dir: Path):
    print(f"🗜️ Creating zip at {zip_file}...")
    with zipfile.ZipFile(zip_file, 'w', zipfile.ZIP_DEFLATED) as zf:
        for path in build_dir.rglob('*'):
            archive_name = path.relative_to(build_dir)
            zf.write(path, archive_name)


def build_lambda_package(lambda_dir: Path):
    build_dir = lambda_dir / "build"
    package_dir = lambda_dir / "package"
    zip_file = package_dir / "lambda.zip"
    code_dir = lambda_dir / "lambda_function"
    req_file = code_dir / "requirements.txt"

    clean(build_dir, package_dir, zip_file)
    install_dependencies(req_file, build_dir)
    copy_source(build_dir, code_dir)
    zip_build(zip_file, build_dir)
    print("✅ Lambda package ready:", zip_file)


def main():
    for lambda_dir in SCRIPT_DIR.iterdir():
        if (lambda_dir / "lambda_function").is_dir() and not lambda_dir.name.endswith("_old"):
            build_lambda_package(lambda_dir)


if __name__ == "__main__":
    main()
