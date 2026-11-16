# Converte perfis canonicos de agentes/ para Cursor (.mdc) ou Claude Code (.md).
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("cursor", "claude")]
    [string]$Formato,

    [Parameter(Mandatory = $true)]
    [string]$Saida
)

$ErrorActionPreference = "Stop"
$utf8 = New-Object System.Text.UTF8Encoding $false
$raiz = Split-Path -Parent $PSScriptRoot
$origem = Join-Path $raiz "agentes"

if (-not (Test-Path $origem)) {
    throw "Pasta de agentes nao encontrada: $origem"
}

New-Item -ItemType Directory -Force -Path $Saida | Out-Null

function Get-FrontMatter {
    param([string]$Texto)
    if ($Texto -notmatch '(?s)^---\r?\n(.*?)\r?\n---\r?\n(.*)$') {
        throw "Front matter YAML ausente ou invalido."
    }
    return @{ Yaml = $Matches[1]; Body = $Matches[2].TrimEnd() }
}

function Get-YamlValue {
    param([string]$Yaml, [string]$Chave)
    $m = [regex]::Match($Yaml, "(?m)^${Chave}:\s*(.+)$")
    if (-not $m.Success) { return "" }
    return $m.Groups[1].Value.Trim().Trim("'").Trim('"')
}

$arquivos = Get-ChildItem -Path $origem -Filter *.md -Recurse |
    Where-Object { $_.Name -notlike "_*" }

foreach ($arquivo in $arquivos) {
    $texto = [IO.File]::ReadAllText($arquivo.FullName, $utf8)
    $partes = Get-FrontMatter $texto
    $id = Get-YamlValue $partes.Yaml "id"
    $nome = Get-YamlValue $partes.Yaml "nome"
    $cargo = Get-YamlValue $partes.Yaml "cargo"
    $quando = Get-YamlValue $partes.Yaml "quando_usar"
    if (-not $id) { $id = [IO.Path]::GetFileNameWithoutExtension($arquivo.Name) }

    if ($quando) { $descricao = $quando } else { $descricao = "$cargo - $nome" }

    $rodapePath = Join-Path $PSScriptRoot "rodape.txt"
    $instrucao = "**$nome**, $cargo.`n" + [IO.File]::ReadAllText($rodapePath, $utf8).Trim()

    if ($Formato -eq "cursor") {
        $destino = Join-Path $Saida "agency-$id.mdc"
        $conteudo = @"
---
description: "$nome - $cargo. $descricao"
alwaysApply: false
---

$($partes.Body)

$instrucao
"@
    }
    else {
        $destino = Join-Path $Saida "$id.md"
        $conteudo = @"
---
name: $id
description: $descricao. Use este agente para o oficio de $cargo ($nome).
---

$($partes.Body)

$instrucao
"@
    }

    [IO.File]::WriteAllText($destino, $conteudo.Trim() + "`n", $utf8)
    Write-Host "OK  $destino"
}

Write-Host ""
Write-Host "Convertidos $($arquivos.Count) agentes -> $Saida ($Formato)"
