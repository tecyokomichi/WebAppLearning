package main

import (
	"fmt"
	"os"
	"strconv"
)

func main() {
	if len(os.Args) < 4 || 4 < len(os.Args) {
		showHelp()
		os.Exit(1)
	} else if len(os.Args) == 4 {
		var calc Calculation
		switch os.Args[1] {
		case "add":
			calc = &Addition{}
		case "subtract":
			calc = &Subtraction{}
		default:
			showHelp()
			os.Exit(1)
		}
		x, e := parseInt(os.Args[2])
		if  e != nil {
			fmt.Printf("%s\n", e.Error())
			os.Exit(1)
		}
		y, e := parseInt(os.Args[3])
		if  e != nil {
			fmt.Printf("%s\n", e.Error())
			os.Exit(1)
		}
		fmt.Printf("%s: %d\n", calc.Kind(), calc.Do(x, y))
		os.Exit(0)
	}
}

func showHelp() {
	fmt.Println("USAGE:")
	fmt.Println("./ch02_first_cli (add|subtract) X Y")
	fmt.Println(" Shows addition or subtraction with X and Y")
	fmt.Println(" X and Y must be number")
}

func parseInt(s string) (int, error) {
	r, err := strconv.Atoi(s)
	if err != nil {
		return 0, fmt.Errorf("ERROR: %q is not a number", s)
	}
	return r, nil
}
