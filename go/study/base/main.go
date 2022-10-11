package main

type Point struct {
	Px int
	Py int
}

type Circle struct {
	radius int
	Point *Point
}

type Rect struct {
	width int
	length int
	Point *Point
}
