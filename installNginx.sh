#!/bin/bash

# Directorio donde se ejecuta el script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Actualizar el índice de paquetes
sudo apt update

# Instalar Nginx
sudo apt install nginx -y

# Comprobar si Nginx se ha instalado correctamente
if [ $? -eq 0 ]; then
    echo "Nginx se ha instalado correctamente."
else
    echo "Error al instalar Nginx. Saliendo."
    exit 1
fi

# Crear un directorio para el sitio web
sudo mkdir -p "$DIR/html"

# Crear una página HTML simple para el sitio web
echo "<!DOCTYPE html>
<html>
<head>
    <title>Welcome to My Website</title>
</head>
<body>
    <h1>Hello, world!</h1>
    <p>This is a simple webpage served by Nginx.</p>
</body>
</html>" | sudo tee "$DIR/html/index.html"

# Establecer los permisos adecuados para el directorio del sitio web
sudo chown -R www-data:www-data "$DIR/html"
sudo chmod -R 755 "$DIR/html"

# Configurar un sitio virtual en Nginx
sudo tee "/etc/nginx/sites-available/default" <<EOF
server {
    listen 80;
    listen [::]:80;

    root $DIR/html;
    index index.html index.htm index.nginx-debian.html;

    server_name _;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

# Reiniciar Nginx para aplicar los cambios de configuración
sudo systemctl restart nginx

# Comprobar el estado de Nginx
sudo systemctl status nginx
