package main

import "testing"

func TestAddtion(t *testing.T) {
	calc := &Addition{}
	if calc.Kind() != "addition" {
		t.FailNow()
	}
	if calc.Do(1, 2) != 3 {
		t.FailNow()
	}
}

func TestSubtraction(t *testing.T) {
	calc := &Subtraction{}
	if calc.Kind() != "subtraction" {
		t.FailNow()
	}
	if calc.Do(2, 1) != 1 {
		t.FailNow()
	}
}

func TestMultiplication(t *testing.T) {
	calc := &Multiplication{}
	if calc.Kind() != "multiplication" {
		t.FailNow()
	}
	if calc.Do(2, 3) != 6 {
		t.FailNow()
	}
}
