# Rutas de origen y destino
$origen = "C:\prueba_caras"
$destino = "C:\caras_autorizadas"

# Crear carpeta de destino si no existe
if (!(Test-Path $destino)) {
    New-Item -Path $destino -ItemType Directory
}

# Extensiones de imagen que se pueden llegar a mover
$extensiones = @("*.jpg", "*.jpeg", "*.png", "*.bmp", "*.gif", "*.tiff")

# Mover imagenes
foreach ($ext in $extensiones) {
    Move-Item -Path (Join-Path $origen $ext) -Destination $destino -Force -ErrorAction SilentlyContinue
}
