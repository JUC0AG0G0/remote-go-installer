const express = require('express');
const fs = require('fs');
const path = require('path');

const app = express();
const PORT = 7583;

const VALID_KEYS = ['12345', 'abcde', 'monclesecret'];

function verifyKey(req, res, next) {
    const key = req.query.key;
    if (!VALID_KEYS.includes(key)) {
        return res.status(403).send('echo "❌ Clé incorrecte." && exit 1');
    }
    next();
}

app.get('/install.sh', verifyKey, (req, res) => {
    const filePath = path.join(__dirname, 'install.sh');
    const key = req.query.key;

    res.set('Content-Type', 'text/x-shellscript; charset=utf-8');

    const injectedLine = `KEY="${key}"\n`;

    const originalScript = fs.readFileSync(filePath, 'utf-8');
    const finalScript = injectedLine + originalScript;

    res.send(finalScript);
});


app.get('/main.go', verifyKey, (req, res) => {
    const filePath = path.join(__dirname, 'main.go');
    res.sendFile(filePath);
});

app.listen(PORT, () => {
    console.log(`🚀 Serveur Node en écoute sur http://localhost:${PORT}`);
});
