# The Agency

Agência de especialistas em Markdown: cada arquivo é um perfil com voz, ofício e critério de pronto. O objetivo é ter um time de IA à mão — não um assistente genérico com chapéu diferente.

Tudo está em **português brasileiro**.

## Divisões

```
agentes/
  engenharia/     Marina, Rafael, Caio, Helena
  design/         Lia, Otávio
  marketing/      Beatriz
  vendas/         Diego
  produto/        Sofia
```

Lista completa: [catalogo.md](catalogo.md). Modelo de perfil: [agentes/_modelo.md](agentes/_modelo.md).

## Como usar sem instalar nada

Abra o `.md` do especialista e cole no chat (Cursor, Claude, outro) como contexto do sistema, ou mencione o arquivo no Cursor com `@`.

## Instalar nos assistentes

Os scripts leem os perfis canônicos em `agentes/` e geram arquivos no formato de cada ferramenta. Por padrão instalam **no diretório atual** (o projeto em que você está trabalhando).

### Cursor (regras `.mdc`)

PowerShell (Windows):

```powershell
# na pasta do seu app
..\the-agency\scripts\instalar-cursor.ps1
```

Bash:

```bash
../the-agency/scripts/instalar-cursor.sh
```

Isso cria `.cursor/rules/agency-<id>.mdc` com `alwaysApply: false`. Chame o especialista com `@` no chat. Nada fica aplicado o tempo todo — senão nove vozes brigam no mesmo prompt.

### Claude Code (subagentes)

```powershell
..\the-agency\scripts\instalar-claude.ps1
```

```bash
../the-agency/scripts/instalar-claude.sh
```

Gera `.claude/agents/<id>.md` no formato que o Claude Code espera (`name` + `description`).

### Só converter (sem copiar para um projeto)

```powershell
.\scripts\converter.ps1 -Formato cursor -Saida .\dist\cursor
.\scripts\converter.ps1 -Formato claude -Saida .\dist\claude
```

```bash
./scripts/converter.sh cursor ./dist/cursor
./scripts/converter.sh claude ./dist/claude
```

## Adicionar um especialista

1. Copie `agentes/_modelo.md` para `agentes/<divisao>/<id>.md`.
2. Preencha o YAML (id, nome, voz, especialidades, quando_usar).
3. Escreva personalidade, método, voz e resultado esperado.
4. Atualize `catalogo.md`.
5. Rode de novo o script de instalação no projeto alvo.

## Princípio

Cada agente entrega **artefato**, não opinião. Se o perfil não diz o que sai pronto das mãos dele, o perfil ainda não está pronto.
