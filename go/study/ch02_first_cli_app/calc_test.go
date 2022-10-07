package main

import "testing"

func TestAddtion(t *testing.T) {
	calc := &Addition{}
	if calc.Kind() != "addition" {
		t.FailNow()
	}
	if calc.Do(1, 2) != Int(3) {
		t.FailNow()
	}
}

func TestSubtraction(t *testing.T) {
	calc := &Subtraction{}
	if calc.Kind() != "subtraction" {
		t.FailNow()
	}
	if calc.Do(2, 1) != Int(1) {
		t.FailNow()
	}
}

func TestMultiplication(t *testing.T) {
	calc := &Multiplication{}
	if calc.Kind() != "multiplication" {
		t.FailNow()
	}
	if calc.Do(2, 3) != Int(6) {
		t.FailNow()
	}
}

func TestDivision(t *testing.T) {
	calc := &Division{}
	if calc.Kind() != "division" {
		t.FailNow()
	}
	if _, ok := calc.Do(2, 0).(*InvalidDenominator); !ok {
		t.FailNow()
	}
	if r, ok := calc.Do(10, 3).(*DivisionResult); ok {
		if r.Quotient != 3 || r.Remainder != 1 {
			t.FailNow()
		}
	}
}
