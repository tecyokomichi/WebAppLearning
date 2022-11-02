// Code generated by goa v3.5.2, DO NOT EDIT.
//
// sampleApi endpoints
//
// Command:
// $ goa gen sampleApi/design

package sampleapi

import (
	"context"

	goa "goa.design/goa/v3/pkg"
)

// Endpoints wraps the "sampleApi" service endpoints.
type Endpoints struct {
	Show goa.Endpoint
}

// NewEndpoints wraps the methods of the "sampleApi" service with endpoints.
func NewEndpoints(s Service) *Endpoints {
	return &Endpoints{
		Show: NewShowEndpoint(s),
	}
}

// Use applies the given middleware to all the "sampleApi" service endpoints.
func (e *Endpoints) Use(m func(goa.Endpoint) goa.Endpoint) {
	e.Show = m(e.Show)
}

// NewShowEndpoint returns an endpoint function that calls the method "show" of
// service "sampleApi".
func NewShowEndpoint(s Service) goa.Endpoint {
	return func(ctx context.Context, req interface{}) (interface{}, error) {
		p := req.(*ShowPayload)
		res, err := s.Show(ctx, p)
		if err != nil {
			return nil, err
		}
		vres := NewViewedUser(res, "default")
		return vres, nil
	}
}