# Instala os especialistas como regras Cursor no projeto alvo.
param(
    [string]$Destino = (Get-Location).Path
)

$ErrorActionPreference = "Stop"
$rules = Join-Path $Destino ".cursor\rules"
New-Item -ItemType Directory -Force -Path $rules | Out-Null

& (Join-Path $PSScriptRoot "converter.ps1") -Formato cursor -Saida $rules

Write-Host ""
Write-Host "Cursor: regras em $rules"
Write-Host "Chame um especialista com @agency-<id> no chat. Nada fica always-on."
