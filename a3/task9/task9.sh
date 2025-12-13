#!/bin/bash

ALLOWED_IP="$1"
API_DOMAIN="$2"
API_PORT="8000"
NGINX_CONFIG="/etc/nginx/sites-available/$API_DOMAIN"
LINK_PATH="/etc/nginx/sites-enabled/$API_DOMAIN"


if grep -q "server_name" "$NGINX_CONFIG"; then
    sudo sed -i "/location \//a \ \ \ \ allow $ALLOWED_IP;\n\ \ \ \ deny all;" "$NGINX_CONFIG"

else
    sudo bash -c "cat > $NGINX_CONFIG" << EOL
server {
    listen 80;
    server_name $API_DOMAIN www.$API_DOMAIN;

    location / {
        allow $ALLOWED_IP;
        deny all;

        proxy_pass http://localhost:$API_PORT;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOL
    echo "created with access for one ip."
fi

if [ ! -L "$LINK_PATH" ]; then
    sudo ln -s "$NGINX_CONFIG" "$LINK_PATH"
fi

sudo systemctl restart nginx
