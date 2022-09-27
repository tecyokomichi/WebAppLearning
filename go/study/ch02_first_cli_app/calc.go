package main

type Calculation interface {
	Do(x, y int) int
	Kind() string
}

type Addition struct{}

func (*Addition) Kind() string {
	return "addition"	
}

func (*Addition) Do(x, y int) int {
	return x + y
}

type Subtraction struct{}

func (*Subtraction) Kind() string {
	return "subtraction"	
}

func (*Subtraction) Do(x, y int) int {
	return x - y
}
