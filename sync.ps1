# =============================================================================
#  sync.ps1  -  Sincroniza la config de Claude (claude_config) en un comando.
#  Sube tus cambios locales y baja la ultima version del repo.
#  Uso:   powershell -File "$env:USERPROFILE\.claude\sync.ps1"   (o pwsh si tienes PS7)
#
#  MAQUINA NUEVA (bootstrap, una sola vez): si ~/.claude todavia no esta
#  conectado al repo, este script lo detecta y lo conecta solo la primera vez.
# =============================================================================

# PS 5.1: NO usar ErrorActionPreference=Stop aqui - los warnings normales de git
# (aviso CRLF) irian a stderr y se tratarian como error fatal. Validamos con $LASTEXITCODE.
$ErrorActionPreference = "Continue"
$repo  = "https://github.com/GerardRojas/claude_config.git"
$dir   = "$env:USERPROFILE\.claude"
$files = @("CLAUDE.md", "settings.json", ".gitignore", "sync.ps1")

Set-Location $dir

function Fail($msg) { Write-Host "ERROR: $msg" -ForegroundColor Red; exit 1 }

# --- Bootstrap automatico si no es repo ---
if (-not (Test-Path "$dir\.git")) {
    Write-Host "Conectando $dir al repo por primera vez..." -ForegroundColor Cyan
    foreach ($f in "CLAUDE.md","settings.json") { if (Test-Path $f) { Move-Item $f "$f.bak" -Force } }
    git init | Out-Null
    git remote add origin $repo
    git fetch origin
    if ($LASTEXITCODE -ne 0) { Fail "no se pudo conectar al remoto." }
    git checkout -f -b main origin/main
    if ($LASTEXITCODE -ne 0) { Fail "no se pudo aplicar la config." }
    Write-Host "Listo. Config aplicada en $dir (respaldos *.bak si habia)." -ForegroundColor Green
    exit 0
}

# --- Sincronizacion normal ---
# 1) Sube cambios locales (si hay) en los archivos versionados
git add -- $files
git diff --cached --quiet
if ($LASTEXITCODE -ne 0) {
    $msg = "chore: sync from $env:COMPUTERNAME"
    git commit -m $msg | Out-Null
    Write-Host "Cambios locales commiteados: $msg" -ForegroundColor Yellow
} else {
    Write-Host "Sin cambios locales que subir." -ForegroundColor DarkGray
}

# 2) Baja lo ultimo del remoto (rebase para mantener historial limpio)
Write-Host "Bajando ultima version..." -ForegroundColor Cyan
git pull --rebase origin main
if ($LASTEXITCODE -ne 0) { Fail "el pull/rebase tuvo conflictos - resuelvelos a mano y reintenta." }

# 3) Sube si quedo algo por pushear
git push origin main
if ($LASTEXITCODE -ne 0) { Fail "el push fallo (revisa credenciales/conexion)." }

Write-Host "`nConfig de Claude sincronizada." -ForegroundColor Green
git log --oneline -3
