package main

import "fmt"

func main() {
	p1 := &Point{Px: 100, Py: 50}
	fmt.Printf("%#v\n", p1)

	c1 := NewCircle(p1, 30)
	fmt.Printf("%#v\n", c1)
	fmt.Printf("面積：　%#v\n", c1.Area())
	c1.Expand(10)
	fmt.Printf("%#v\n", c1)

	r1 := &Rect{Point: p1, width: 20, length: 10}
	fmt.Printf("面積：　%#v\n", r1.Area())
	r2 := &Rect{Point: p1, width: 30, length: 20}
	r3 := &Rect{Point: p1, width: 40, length: 30}
	r4 := &Rect{Point: p1, width: 50, length: 40}
	r5 := &Rect{Point: p1, width: 10, length: 5}
	fmt.Printf("%#v\n", r1)
	fmt.Printf("%#v\n", RecList([]*Rect{r1, r2, r3, r4, r5}).Biggest())
	fmt.Printf("%#v\n", Shapes([]Shape{c1, r1, r2, r3, r4, r5}).Biggest())
}
