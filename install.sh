#!/bin/bash

set -e

if [ -z "$KEY" ]; then
  echo "[ERREUR] Clé manquante (KEY non défini)"
  exit 1
fi

SERVER="http://localhost:7583"
MAIN_URL="${SERVER}/main.go?key=${KEY}"

echo "🔑 Clé = $KEY"
echo "{\"key\": \"${KEY}\"}" > key.json

if ! command -v go &> /dev/null; then
  echo "⏬ Installation de Go..."
  curl -OL https://go.dev/dl/go1.21.5.linux-amd64.tar.gz
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf go1.21.5.linux-amd64.tar.gz
  rm go1.21.5.linux-amd64.tar.gz

  GO_PATH_LINE='export PATH=$PATH:/usr/local/go/bin'
  FILES_TO_UPDATE=("$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.profile")

  echo "🛠️  Configuration du PATH pour Go..."

  for file in "${FILES_TO_UPDATE[@]}"; do
    if [ -f "$file" ]; then
      if ! grep -q "/usr/local/go/bin" "$file"; then
        echo "$GO_PATH_LINE" >> "$file"
        echo "✅ Ajouté à $file"
      else
        echo "✔️ Déjà présent dans $file"
      fi
    else
      echo "$GO_PATH_LINE" >> "$file"
      echo "✅ Créé et mis à jour : $file"
    fi
  done

  if [ "$(id -u)" = "0" ] && [ -f /etc/profile ]; then
    if ! grep -q "/usr/local/go/bin" /etc/profile; then
      echo "$GO_PATH_LINE" >> /etc/profile
      echo "✅ Ajouté à /etc/profile (global)"
    fi
  fi

  export PATH=$PATH:/usr/local/go/bin
fi

echo "🌐 Téléchargement de main.go..."
curl -sSL "$MAIN_URL" -o main.go

echo "🚀 Exécution..."
go run main.go
