# Crea la estructura base del repositorio en la raíz (la carpeta de este script).
# Uso (desde la raíz):  powershell -ExecutionPolicy Bypass -File .\crear-estructura.ps1
# No sobrescribe nada que ya exista. No crea código.

$ErrorActionPreference = 'Stop'
$raiz = $PSScriptRoot
$utf8 = New-Object System.Text.UTF8Encoding($false)

function Escribir-SiNoExiste([string]$ruta, [string]$contenido) {
    if (Test-Path -LiteralPath $ruta) {
        Write-Host "Ya existe, se omite: $ruta"
        return
    }
    [System.IO.File]::WriteAllText($ruta, $contenido, $utf8)
    Write-Host "Creado: $ruta"
}

# 1. Carpetas (las intermedias se crean solas)
$carpetas = @(
    'docs/adr',
    'docs/vistas',
    'docs/diagramas/secuencias',
    'docs/equipo',
    'docs/ceremonias/iteracion-01',
    'docs/ceremonias/iteracion-02',
    'specs',
    '.github',
    'src/backend/nucleo/dominio',
    'src/backend/nucleo/casos_uso',
    'src/backend/nucleo/puertos',
    'src/backend/adaptadores/entrada/api',
    'src/backend/adaptadores/salida/persistencia',
    'src/backend/adaptadores/salida/pasarelas',
    'src/backend/adaptadores/salida/mensajeria',
    'src/backend/adaptadores/salida/sia',
    'src/backend/adaptadores/salida/reloj',
    'src/backend/scripts',
    'src/frontend'
)
foreach ($c in $carpetas) {
    New-Item -ItemType Directory -Force -Path (Join-Path $raiz $c) | Out-Null
}

# 2. Documentos .md: ruta, título, responsable
$bairon   = 'Bairon Vásquez'
$sergio   = 'Sergio Velásquez'
$mariana  = 'Mariana García'
$documentos = @(
    @('docs/vision.md',                  'Visión',                  $bairon),
    @('docs/drivers.md',                 'Drivers',                 $sergio),
    @('docs/arquitectura.md',            'Arquitectura',            $sergio),
    @('docs/contexto.md',                'Contexto',                $sergio),
    @('docs/USO_IA.md',                  'Declaración de uso de IA', $bairon),
    @('docs/vistas/01-logica.md',        'Vista lógica',            $sergio),
    @('docs/vistas/02-procesos.md',      'Vista de procesos',       $sergio),
    @('docs/vistas/03-desarrollo.md',    'Vista de desarrollo',     $sergio),
    @('docs/vistas/04-fisica.md',        'Vista física',            $sergio),
    @('docs/equipo/normas.md',           'Normas del equipo',       $bairon),
    @('docs/equipo/roles.md',            'Roles del equipo',        $bairon),
    @('docs/equipo/checklist-revision.md', 'Lista de verificación de revisión', $mariana),
    @('docs/equipo/estandares.md',       'Estándares',              $mariana)
)
foreach ($d in $documentos) {
    $contenido = "# $($d[1])`n`nResponsable: $($d[2])`n"
    Escribir-SiNoExiste (Join-Path $raiz $d[0]) $contenido
}

# 3. .gitkeep en las carpetas que quedaron vacías
foreach ($c in $carpetas) {
    $ruta = Join-Path $raiz $c
    if (-not (Get-ChildItem -LiteralPath $ruta -Force)) {
        [System.IO.File]::WriteAllText((Join-Path $ruta '.gitkeep'), '', $utf8)
        Write-Host "Creado: $ruta\.gitkeep"
    }
}

# 4. .gitignore (Python + Angular; excluye .env pero no .env.example)
$gitignore = @'
# Variables de entorno (el .env.example sí se versiona)
.env
!.env.example

# Python
venv/
.venv/
__pycache__/
*.py[cod]
.pytest_cache/

# Angular / Node
node_modules/
dist/
.angular/
'@
Escribir-SiNoExiste (Join-Path $raiz '.gitignore') ($gitignore + "`n")

Write-Host 'Listo.'
