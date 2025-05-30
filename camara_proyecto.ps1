# Solicitar credenciales
$cred = Get-Credential -Message "Introduce usuario y contraseña para continuar"

# Validar credenciales
if ($cred.UserName -ne "usuario" -or ($cred.GetNetworkCredential().Password -ne "usuario")) {
    Write-Host "Credenciales incorrectas. Acceso denegado." -ForegroundColor Red
    exit
}

# Mostrar mensaje de bienvenida personalizado
Write-Host "`n==============================" -ForegroundColor Cyan
Write-Host "     BIENVENIDO $($cred.UserName.ToUpper())" -ForegroundColor Cyan
Write-Host "==============================" -ForegroundColor Cyan

# Rutas
$origen = "C:\prueba_caras"
$destino = "C:\caras_autorizadas"

# Crear carpeta de destino si no existe
if (!(Test-Path $destino)) {
    New-Item -Path $destino -ItemType Directory
}

# Extensiones de imagen válidas
$extensiones = @("*.jpg", "*.jpeg", "*.png", "*.bmp", "*.gif", "*.tiff")
$imagenes = @()
foreach ($ext in $extensiones) {
    $imagenes += Get-ChildItem -Path $origen -Filter $ext -File -ErrorAction SilentlyContinue
}

if ($imagenes.Count -eq 0) {
    Write-Host "No se encontraron imágenes en la carpeta de origen." -ForegroundColor Yellow
    exit
}

# Procesar imágenes una por una
foreach ($img in $imagenes) {
    Write-Host "¿Deseas mover la imagen '$($img.Name)'? (s/n): " -NoNewline
    $respuesta = Read-Host
    if ($respuesta -eq 's') {
        # Solicitar nuevo nombre (sin extensión)
        Write-Host "Introduce nuevo nombre para '$($img.Name)' (sin extensión): " -NoNewline
        $nuevoNombre = Read-Host

        # Obtener extensión original
        $extension = $img.Extension

        # Obtener fecha y hora actual en formato con punto para la hora
        $fechaHora = Get-Date -Format "dd MM yyyy HH.mm"

        # Construir nuevo nombre con fecha y hora
        $nombreFinal = "$nuevoNombre $fechaHora$extension"
        $nuevoPath = Join-Path $destino $nombreFinal

        # Mover y renombrar
        Move-Item -Path $img.FullName -Destination $nuevoPath -Force
        Write-Host "Imagen '$($img.Name)' movida y renombrada como '$nombreFinal'." -ForegroundColor Green
    } else {
        Write-Host "Imagen '$($img.Name)' omitida." -ForegroundColor Gray
    }
}
