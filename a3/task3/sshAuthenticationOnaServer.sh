#!/bin/bash

# Usage: ./sshAuthenticationOnaServer.sh <username> <remote_host>
USERNAME="$1"
REMOTE_HOST="$2"
KEY_PATH="$HOME/.ssh/id_rsa"

# Проверка аргументов
if [[ -z "$USERNAME" || -z "$REMOTE_HOST" ]]; then
    echo "Usage: $0 <username> <remote_host>"
    exit 1
fi

# Генерация ключа, если его нет
if [[ ! -f "$KEY_PATH" ]]; then
    echo "Генерируем SSH ключ..."
    ssh-keygen -t rsa -b 4096 -N "" -f "$KEY_PATH"
fi

# Копируем публичный ключ на сервер
ssh-copy-id -i "$KEY_PATH.pub" "$USERNAME@$REMOTE_HOST"

# Выставляем правильные права на удалённом сервере
ssh "$USERNAME@$REMOTE_HOST" "chmod 700 ~/.ssh; chmod 600 ~/.ssh/authorized_keys"

echo "SSH key-based authentication успешно настроена для $USERNAME@$REMOTE_HOST"
