# =============================================================================
#  sync.ps1  —  Sincroniza la config de Claude (claude_config) en un comando.
#  Sube tus cambios locales y baja la ultima version del repo.
#  Uso:   pwsh "$env:USERPROFILE\.claude\sync.ps1"     (o powershell)
#
#  MAQUINA NUEVA (bootstrap, una sola vez): si ~/.claude todavia no esta
#  conectado al repo, corre esto una vez y luego ya usas sync.ps1 normal:
#
#    $c="$env:USERPROFILE\.claude"; Set-Location $c
#    foreach($f in "CLAUDE.md","settings.json"){ if(Test-Path $f){ Move-Item $f "$f.bak" -Force } }
#    git init; git remote add origin https://github.com/GerardRojas/claude_config.git
#    git fetch origin; git checkout -f -b main origin/main
# =============================================================================

$ErrorActionPreference = "Stop"
$repo  = "https://github.com/GerardRojas/claude_config.git"
$dir   = "$env:USERPROFILE\.claude"
$files = @("CLAUDE.md", "settings.json", ".gitignore", "sync.ps1")

Set-Location $dir

# --- Bootstrap automatico si no es repo ---
if (-not (Test-Path "$dir\.git")) {
    Write-Host "Conectando $dir al repo por primera vez..." -ForegroundColor Cyan
    foreach ($f in "CLAUDE.md","settings.json") { if (Test-Path $f) { Move-Item $f "$f.bak" -Force } }
    git init | Out-Null
    git remote add origin $repo
    git fetch origin
    git checkout -f -b main origin/main
    Write-Host "Listo. Config aplicada en $dir (respaldos *.bak si habia)." -ForegroundColor Green
    return
}

# --- Sincronizacion normal ---
# 1) Sube cambios locales (si hay) en los archivos versionados
git add -- $files 2>$null
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

# 3) Sube si quedo algo por pushear
git push origin main

Write-Host "`nConfig de Claude sincronizada." -ForegroundColor Green
git log --oneline -3
