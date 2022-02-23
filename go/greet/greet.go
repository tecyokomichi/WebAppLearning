package greetapi

import (
	"context"
	greet "greet/gen/greet"
	"log"
)

// greet service example implementation.
// The example methods log the requests and return zero values.
type greetsrvc struct {
	logger *log.Logger
}

// NewGreet returns the greet service implementation.
func NewGreet(logger *log.Logger) greet.Service {
	return &greetsrvc{logger}
}

// Hello implements hello.
func (s *greetsrvc) Hello(ctx context.Context, p *greet.HelloPayload) (res string, err error) {
	s.logger.Print("greet.hello")
	return
}
