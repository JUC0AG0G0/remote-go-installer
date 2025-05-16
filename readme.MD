# Remote Go Installer 🔐🚀

Un petit projet pour installer Go, télécharger et exécuter un programme distant, **en une seule ligne de commande** – le tout avec un système de clé sécurisé via un serveur Node.js.

---

## 🧩 Fonctionnalités

- 📦 Installation automatique de Go si manquant
- 🔑 Sécurisation via une **clé d’accès**
- 📂 Téléchargement d’un programme Go (`main.go`) via HTTP
- 🏃 Exécution immédiate du programme (`go run`)
- 🧠 Écriture locale de la clé dans `key.json`
- 📁 Mise à jour automatique du `PATH` pour que Go fonctionne dans tous les terminaux

---

## 🧪 Utilisation

### 1. Lance le serveur Node.js

```bash
node server.js
```

### 2. Exécute l'installation en une seule commande :
```bash
curl -sSL "http://localhost:7583/install.sh?key=12345" | bash
```

### 🔐 Clés d’accès
Les clés valides sont définies côté serveur dans server.js :

```js
const VALID_KEYS = ['12345', 'abcde', 'monclesecret'];
```
Si la clé est invalide ou absente, l’installation est refusée.

### 🛠️ Structure du projet
```bash
.
├── install.sh     # Script d'installation côté client
├── main.go        # Programme Go minimal
├── server.js      # Serveur Node.js qui délivre les fichiers
```
### 💡 Exemple de programme Go (main.go)
```go
package main

import (
	"encoding/json"
	"fmt"
	"os"
)

type Key struct {
	Key string `json:"key"`
}

func main() {
	var k Key
	data, err := os.ReadFile("key.json")
	if err != nil {
		fmt.Println("Erreur de lecture de la clé.")
		return
	}
	json.Unmarshal(data, &k)
	fmt.Printf("hello world tu as utilisé cette clé %s\n", k.Key)
}
```