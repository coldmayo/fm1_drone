from pathlib import Path

p = Path("tools/Build-Web-Linux.ps1")
s = p.read_text()

replacements = [
    (
        "$compiler = Join-Path $WasiSdk 'bin/clang.exe'",
        """$compilerName = if ($IsWindows) { 'clang.exe' } else { 'clang' }
    $compiler = Join-Path $WasiSdk ('bin/' + $compilerName)"""
    ),
    (
        """    $scanPath = if ($WasiSdk.StartsWith('\\\\?\\')) { $WasiSdk } elseif ($WasiSdk.StartsWith('\\\\')) {
        '\\\\?\\UNC\\' + $WasiSdk.TrimStart('\\')
    } else { '\\\\?\\' + $WasiSdk }""",
        """    $scanPath = $WasiSdk"""
    ),
]

for old, new in replacements:
    if old not in s:
        print("Could not find expected code; leaving file unchanged:")
        print(old)
        raise SystemExit(1)
    s = s.replace(old, new, 1)

p.write_text(s)
print("Patched Linux build script:", p)
