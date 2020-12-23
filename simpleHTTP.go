package main

import (
    "fmt"
    "net/http"
    "time"
)

func handler(w http.ResponseWriter, r *http.Request) {
    fmt.Printf("Responding to request with %s at %s\n", r.URL.Path[1:], time.Now().String())
    fmt.Fprintf(w, "Hi there, I love %s!", r.URL.Path[1:])
}

func main() {
    fmt.Printf("Starting at %s\n", time.Now().String())
    http.HandleFunc("/", handler)
    http.ListenAndServe(":8080", nil)
}
