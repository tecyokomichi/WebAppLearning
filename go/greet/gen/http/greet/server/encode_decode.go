// Code generated by goa v3.5.2, DO NOT EDIT.
//
// greet HTTP server encoders and decoders
//
// Command:
// $ goa gen greet/design

package server

import (
	"context"
	"net/http"

	goahttp "goa.design/goa/v3/http"
)

// EncodeHelloResponse returns an encoder for responses returned by the greet
// hello endpoint.
func EncodeHelloResponse(encoder func(context.Context, http.ResponseWriter) goahttp.Encoder) func(context.Context, http.ResponseWriter, interface{}) error {
	return func(ctx context.Context, w http.ResponseWriter, v interface{}) error {
		res, _ := v.(string)
		enc := encoder(ctx, w)
		body := res
		w.WriteHeader(http.StatusOK)
		return enc.Encode(body)
	}
}

// DecodeHelloRequest returns a decoder for requests sent to the greet hello
// endpoint.
func DecodeHelloRequest(mux goahttp.Muxer, decoder func(*http.Request) goahttp.Decoder) func(*http.Request) (interface{}, error) {
	return func(r *http.Request) (interface{}, error) {
		var (
			name string

			params = mux.Vars(r)
		)
		name = params["name"]
		payload := NewHelloPayload(name)

		return payload, nil
	}
}