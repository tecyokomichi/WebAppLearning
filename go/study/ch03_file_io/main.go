package main

import (
	"fmt"
	"os"
	"strings"
)

func main() {
	
	switch os.Args[1] {
	case "cat":
		if len(os.Args) != 3 {
			showHelp()
			os.Exit(1)
		}
		f, err := os.ReadFile(os.Args[2])
		if err != nil {
			fmt.Fprintln(os.Stderr, err)
			os.Exit(1)
		}
		fmt.Println(string(f))
	case "write":
		if len (os.Args) != 4 {
			showHelp()
			os.Exit(1)
		}
		_, e := os.Stat(os.Args[2])
		if e == nil {
			fmt.Printf("%s already exists. Overwrite? (y/n): ", os.Args[2])
			var res string
			fmt.Scanln(&res)
			if !strings.HasPrefix(strings.ToLower(res), "y") {
				fmt.Println("Quit writing")
				os.Exit(1)
			}
		}
		f, err := os.Create(os.Args[2])
		if err != nil {
			fmt.Fprintln(os.Stderr, err)
			os.Exit(1)
		}
		defer f.Close()
		_, ee := fmt.Fprintln(f, os.Args[3])
		if ee != nil{
			fmt.Fprintln(os.Stderr, ee)
			os.Exit(1)
		}

	default:
		showHelp()
		os.Exit(1)
	}
}

func showHelp() {
	fmt.Printf("USAGE:\n")
	fmt.Printf("%s cat FILE\n", os.Args[0])
}
