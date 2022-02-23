package sanmpleapi

import (
	"context"
	"log"
	sampleapi "sampleApi/gen/sample_api"
)

// sampleApi service example implementation.
// The example methods log the requests and return zero values.
type sampleAPIsrvc struct {
	logger *log.Logger
}

// NewSampleAPI returns the sampleApi service implementation.
func NewSampleAPI(logger *log.Logger) sampleapi.Service {
	return &sampleAPIsrvc{logger}
}

// Show implements show.
func (s *sampleAPIsrvc) Show(ctx context.Context, p *sampleapi.ShowPayload) (res *sampleapi.User, err error) {
	res = &sampleapi.User{}
	s.logger.Print("sampleAPI.show")
	return
}
