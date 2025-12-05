package main

import (
    "fmt"
    "net/http"
    "sync"
    "time"
)

const (
    url        = "http://localhost:6969/sleep" // change this
    requests   = 200                           // total number of requests
    concurrent = 50                            // number of concurrent workers
)

func sequential() time.Duration {
    start := time.Now()
    for i := 0; i < requests; i++ {
        _, err := http.Get(url)
        if err != nil {
            fmt.Println("error:", err)
        }
    }
    return time.Since(start)
}

func parallel() time.Duration {
    var wg sync.WaitGroup
    wg.Add(requests)

    sem := make(chan struct{}, concurrent)
    start := time.Now()

    for i := 0; i < requests; i++ {
        go func() {
            sem <- struct{}{}
            _, err := http.Get(url)
            if err != nil {
                fmt.Println("error:", err)
            }
            <-sem
            wg.Done()
        }()
    }

    wg.Wait()
    return time.Since(start)
}

func main() {
    fmt.Println("Running sequential test...")
    seq := sequential()
    fmt.Println("Sequential time:", seq)

    fmt.Println("Running parallel test...")
    par := parallel()
    fmt.Println("Parallel time:  ", par)

    fmt.Println()

    if par < seq/2 {
        fmt.Println("Result: server handles concurrent requests.")
    } else {
        fmt.Println("Result: server does NOT appear to be concurrent.")
    }
}
