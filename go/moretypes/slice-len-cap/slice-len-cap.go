package main

import "fmt"

func main() {
    s := []int{2, 3, 5, 7, 11, 13}
    fmt.Println(s)

    // Slice the slice to give it zero length.
    s = s[:0]
    printSlice(s)

    // Extend its length.
    s = s[:4] 
    printSlice(s)

    // Drop its first two values.
    fmt.Printf("cap=%d\n", cap(s))
    s = s[2:]
    printSlice(s)
}

func printSlice(s []int) { 
    fmt.Printf("len=%d cap=%d %v\n", len(s), cap(s), s)
}

