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
	s.logger.Print("sampleAPI.show")
	var id int
	var name, email string
	err = s.DB.QueryRow("SELECT id, name, email FROM users WHERE id=?", p.ID).Scan(&id, &name, &email)
	if err != nil {
		s.logger.Print(err)
		return
	}
	s.logger.Print("id: ", id, " | name: ", name, " | email: ", email)
	res = &sampleapi.User{ID: &id, Name: &name, Email: &email}
	return
}
