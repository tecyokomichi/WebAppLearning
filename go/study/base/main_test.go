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

func TestBiggest(t *testing.T) {
	p := &Point{Px: 100, Py: 200}
	c := NewCircle(p, 300)
	r1 := &Rect{Point: p, width: 300, length: 400}
	r2 := &Rect{Point: p, width: 30, length: 40}
	r3 := &Rect{Point: p, width: 3, length: 4}
	if RecList([]*Rect{r1, r2, r3}).Biggest().Area() != 120000 {
		t.FailNow()
	}
	if Shapes([]Shape{c, r1, r2, r3}).Biggest().Area() < 282743 || Shapes([]Shape{c, r1, r2, r3}).Biggest().Area() > 282744 {
		t.FailNow()
	}
}
