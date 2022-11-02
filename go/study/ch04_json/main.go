package main

import (
	"encoding/json"
	"fmt"
	"os"
)

type Person struct {
	FirstName	string
	LastName	string
	Birthday	string
	Age			int
}

func main() {
	if len(os.Args) < 2 {
		showHelp()
		os.Exit(1)
	}
	switch os.Args[1] {
	case "example":
		person := &Person{
			FirstName: "Blake",
			LastName: "Serild",
			Birthday: "1989-07-10",
			Age: 33,
		}

		b, err := json.Marshal(person)
		if err != nil {
			fmt.Printf("Error: %v", err)
			os.Exit(1)
		}
		fmt.Println(string(b))
	default:
		showHelp()
		os.Exit(1)
	}
}

func showHelp() {
	fmt.Printf("Usage:\n")
	fmt.Printf("%s example\n", os.Args[0])
	fmt.Printf("Shows an example of JSON data\n")
}