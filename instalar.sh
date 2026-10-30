#!/bin/bash
set -e

echo "================================"
echo " INSTALACIÓN DE PRÁCTICA OAUTH"
echo "================================"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DESTINO="/var/www/html/oauth"

if ! command -v apache2 >/dev/null 2>&1; then
    sudo apt update
    sudo apt install -y apache2 php libapache2-mod-php
fi

sudo systemctl enable --now apache2
sudo mkdir -p "$DESTINO"
sudo cp "$SCRIPT_DIR"/*.php "$DESTINO/"
sudo chown -R "$USER:$USER" "$DESTINO"
sudo chmod 755 "$DESTINO"
sudo chmod 644 "$DESTINO"/*.php
sudo systemctl restart apache2

echo "Instalación completada."
URL="http://localhost/oauth/oauth_login.php"

if command -v firefox >/dev/null 2>&1; then
    nohup firefox "$URL" >/tmp/oauth_firefox.log 2>&1 &
elif command -v firefox-esr >/dev/null 2>&1; then
    nohup firefox-esr "$URL" >/tmp/oauth_firefox.log 2>&1 &
else
    echo "No se encuentra Firefox."
fi

