package main

type Point struct {
	Px, Py int
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

func (r *Rect) Area() int {
	return r.width * r.length
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
