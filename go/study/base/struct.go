package main

import "math"

type Point struct {
	Px, Py int
}

type Shape interface {
	Area() float64
}

type Circle struct {
	radius int
	Point  *Point
}

type Rect struct {
	width, length int
	Point  *Point
}

func NewCircle(p *Point, r int) *Circle {
	return &Circle{Point: p, radius: r}
}

func (c *Circle) Expand(dr int){
	c.radius += dr
}

func (c *Circle) Area() float64 {
	return float64(c.radius * c.radius) * math.Pi
}

func (r *Rect) Area() float64 {
	return float64(r.width * r.length)
}

type RecList []*Rect

func (rl RecList) Biggest() *Rect {
	var b *Rect
	for _, r := range rl {
		if b == nil || r.Area() > b.Area(){
			b = r
		}
	}
	return b
}

type Shapes []Shape

func (sha Shapes) Biggest() Shape {
	var b Shape
	for _, r := range sha {
		if b == nil || r.Area() > b.Area(){
			b = r
		}
	}
	return b
}
