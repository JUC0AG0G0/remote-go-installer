package main

import (
    "encoding/json"
    "fmt"
    "os"
)

type KeyData struct {
    Key string `json:"key"`
}

func main() {
    file, err := os.Open("key.json")
    if err != nil {
        fmt.Println("Erreur : key.json introuvable")
        return
    }
    defer file.Close()

    var data KeyData
    json.NewDecoder(file).Decode(&data)
    fmt.Printf("hello world tu as utilisé cette clé %s\n", data.Key)
}
