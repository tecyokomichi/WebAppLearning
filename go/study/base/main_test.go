package main

import "testing"

func TestNewCircle(t *testing.T) {
	p := &Point{Px: 100, Py: 200}
	c := NewCircle(p, 300)
	if c.radius != 300 {
		t.FailNow()
	}
}
