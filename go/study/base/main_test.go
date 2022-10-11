package main

import "testing"

func TestNewCircle(t *testing.T) {
	p := &Point{Px: 100, Py: 200}
	c := NewCircle(p, 300)
	if c.radius != 300 {
		t.FailNow()
	}
}

func TestExpandCircle(t *testing.T) {
	p := &Point{Px: 100, Py: 200}
	c := NewCircle(p, 300)
	c.Expand(400)
	if c.radius != 700 {
		t.FailNow()
	}
}

func TestArea(t *testing.T) {
	p := &Point{Px: 100, Py: 200}
	r := &Rect{Point: p, width: 300, length: 400}
	if r.Area() != 120000 {
		t.FailNow()
	}
}
