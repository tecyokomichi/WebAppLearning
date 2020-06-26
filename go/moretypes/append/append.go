package main

import "fmt"

func main() {
    var s []int
    printSlice(s)

    // append workd on nil slice.
    s = append(s, 0)
    printSlice(s)

    // The slice grows as needed.
    s = append(s, 1)
    printSlice(s)

    // We can add mre than one element ata time
    s = append(s, 2, 3, 4)
    printSlice(s)
}

func printSlice(s []int) {
    fmt.Printf("len=%d, cap=%d, %v\n", len(s), cap(s), s)
}

