package main

import (
	"fmt"
	"os"
	"strconv"
)

func main() {
	if len(os.Args) < 3 || 3 < len(os.Args) {
		fmt.Println("USAGE:")
		fmt.Println("./ch02_first_cli X Y")
		fmt.Println(" Shows sum of X and Y")
		fmt.Println(" X and Y must be number")
		os.Exit(1)
	} else if len(os.Args) == 3 {
		x, e := strconv.Atoi(os.Args[1])
		if  e != nil {
			fmt.Printf("ERROR: %q is not a number\n", os.Args[1])
			os.Exit(1)
		}
		y, e := strconv.Atoi(os.Args[2])
		if  e != nil {
			fmt.Printf("ERROR: %q is not a number\n", os.Args[2])
			os.Exit(1)
		}
		fmt.Printf("Rrresult: %d\n", x+y)
		os.Exit(0)
	}
}

func showHelp() {
	fmt.Println("USAGE:")
	fmt.Println("./ch02_first_cli (add|subtract) X Y")
	fmt.Println(" Shows addition or subtraction with X and Y")
	fmt.Println(" X and Y must be number")
}
