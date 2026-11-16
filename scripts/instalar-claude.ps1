# Instala os especialistas como subagentes do Claude Code no projeto alvo.
param(
    [string]$Destino = (Get-Location).Path
)

$ErrorActionPreference = "Stop"
$agents = Join-Path $Destino ".claude\agents"
New-Item -ItemType Directory -Force -Path $agents | Out-Null

& (Join-Path $PSScriptRoot "converter.ps1") -Formato claude -Saida $agents

Write-Host ""
Write-Host "Claude Code: agentes em $agents"
Write-Host "O Claude deve sugerir o subagente quando a tarefa casar com a description."
