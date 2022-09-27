package main

import (
	"testing"
)

func TestAdd(t *testing.T) {
	s := Add(1, 2)
	if s != 3 {
		t.FailNow()
	}
}

func TestSubtract(t *testing.T) {
	s := Subtract(1, 2)
	if s != -1 {
		t.FailNow()
	}
	s = Subtract(2, 1)
	if s != 1 {
		t.FailNow()
	}
}