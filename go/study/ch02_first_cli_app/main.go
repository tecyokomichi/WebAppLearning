package main

import (
	"fmt"
	"os"
)

func main() {
	var name = "someone"
	if len(os.Args) > 1 {
		name = os.Args[1]
	}
	fmt.Printf("Hello %s!\n", name)
}
