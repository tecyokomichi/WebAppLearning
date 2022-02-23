// Code generated by goa v3.5.2, DO NOT EDIT.
//
// sampleApi HTTP server encoders and decoders
//
// Command:
// $ goa gen sampleApi/design

package server

import (
	"context"
	"net/http"
	sampleapiviews "sampleApi/gen/sample_api/views"
	"strconv"

	goahttp "goa.design/goa/v3/http"
	goa "goa.design/goa/v3/pkg"
)

// EncodeShowResponse returns an encoder for responses returned by the
// sampleApi show endpoint.
func EncodeShowResponse(encoder func(context.Context, http.ResponseWriter) goahttp.Encoder) func(context.Context, http.ResponseWriter, interface{}) error {
	return func(ctx context.Context, w http.ResponseWriter, v interface{}) error {
		res := v.(*sampleapiviews.User)
		enc := encoder(ctx, w)
		body := NewShowResponseBody(res.Projected)
		w.WriteHeader(http.StatusOK)
		return enc.Encode(body)
	}
}

// DecodeShowRequest returns a decoder for requests sent to the sampleApi show
// endpoint.
func DecodeShowRequest(mux goahttp.Muxer, decoder func(*http.Request) goahttp.Decoder) func(*http.Request) (interface{}, error) {
	return func(r *http.Request) (interface{}, error) {
		var (
			id  int
			err error

			params = mux.Vars(r)
		)
		{
			idRaw := params["id"]
			v, err2 := strconv.ParseInt(idRaw, 10, strconv.IntSize)
			if err2 != nil {
				err = goa.MergeErrors(err, goa.InvalidFieldTypeError("id", idRaw, "integer"))
			}
			id = int(v)
		}
		if err != nil {
			return nil, err
		}
		payload := NewShowPayload(id)

		return payload, nil
	}
}
