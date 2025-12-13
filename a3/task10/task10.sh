#!/bin/bash

CONFIG_PATH="/etc/nginx/sites-available/mysite"
LINK_PATH="/etc/nginx/sites-enabled/mysite"

sudo bash -c "cat > $CONFIG_PATH" <<EOL
server {
    listen 80;
    server_name mysite www.mysite;

    location / {
        proxy_pass http://localhost:8000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOL

#символическая ссылка
if [ ! -L "$LINK_PATH" ]; then
    sudo ln -s "$CONFIG_PATH" "$LINK_PATH"
fi

sudo systemctl restart nginx

