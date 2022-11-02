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
		people := []*Person {
			{
				FirstName: "Blake",
				LastName: "Serild",
				Birthday: "1989-07-10",
				Age: 33,
			},
			{
				FirstName: "Libbie",
				LastName: "Drisko",
				Birthday: "1988-06-15",
				Age: 24,
			},
			{
				FirstName: "Anestassia",
				LastName: "Truc",
				Birthday: "1973-04-02",
				Age: 48,
			},
		}

		b, err := json.MarshalIndent(people, "", "\t")
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