package main

import (
	"fmt"
	"strconv"
)

type Calculation interface {
	Do(x, y int) Result
	Kind() string
}

type Result interface {
	Outcome() string
}

type Int int

func (i Int) Outcome() string {
	return strconv.Itoa(int(i))
}

type Addition struct{}

func (*Addition) Kind() string {
	return "addition"	
}

func (*Addition) Do(x, y int) Result {
	return Int(x + y)
}

type Subtraction struct{}

func (*Subtraction) Kind() string {
	return "subtraction"	
}

func (*Subtraction) Do(x, y int) Result {
	return Int(x - y)
}

type Multiplication struct{}

func (*Multiplication) Kind() string {
	return "multiplication"
}

func (*Multiplication) Do(x, y int) Result {
	return Int(x * y)
}

type DivisionResult struct {
	Quotient int
	Remainder int
}

func (d *DivisionResult) Outcome() string {
	return fmt.Sprintf("(quotient: %d, remainder: %d)", d.Quotient, d.Remainder)
}

type InvalidDenominator struct{}

func (i *InvalidDenominator) Outcome() string {
	return "Invalid denominator. It must be not zero"
}

type Division struct{}

func (d *Division) Kind() string {
	return "division"
}

func (d *Division) Do(x, y int) Result {
	if y == 0 {
		return &InvalidDenominator{}
	}
	q, r := x/y, x%y
	return &DivisionResult{q, r}
}
