package sanmpleapi

import (
	"context"
	"database/sql"
	"log"
	sampleapi "sampleApi/gen/sample_api"
)

// sampleApi service example implementation.
// The example methods log the requests and return zero values.
type sampleAPIsrvc struct {
	logger *log.Logger
	DB     *sql.DB
}

// NewSampleAPI returns the sampleApi service implementation.
func NewSampleAPI(logger *log.Logger, db *sql.DB) sampleapi.Service {
	return &sampleAPIsrvc{logger, db}
}

// Show implements show.
func (s *sampleAPIsrvc) Show(ctx context.Context, p *sampleapi.ShowPayload) (res *sampleapi.User, err error) {
	res = &sampleapi.User{}
	s.logger.Print("sampleAPI.show")
	return
}
