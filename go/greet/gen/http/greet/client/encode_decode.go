// Code generated by goa v3.5.2, DO NOT EDIT.
//
// greet HTTP client encoders and decoders
//
// Command:
// $ goa gen greet/design

package client

import (
	"bytes"
	"context"
	greet "greet/gen/greet"
	"io/ioutil"
	"net/http"
	"net/url"

	goahttp "goa.design/goa/v3/http"
)

// BuildHelloRequest instantiates a HTTP request object with method and path
// set to call the "greet" service "hello" endpoint
func (c *Client) BuildHelloRequest(ctx context.Context, v interface{}) (*http.Request, error) {
	var (
		name string
	)
	{
		p, ok := v.(*greet.HelloPayload)
		if !ok {
			return nil, goahttp.ErrInvalidType("greet", "hello", "*greet.HelloPayload", v)
		}
		name = p.Name
	}
	u := &url.URL{Scheme: c.scheme, Host: c.host, Path: HelloGreetPath(name)}
	req, err := http.NewRequest("GET", u.String(), nil)
	if err != nil {
		return nil, goahttp.ErrInvalidURL("greet", "hello", u.String(), err)
	}
	if ctx != nil {
		req = req.WithContext(ctx)
	}

	return req, nil
}

// DecodeHelloResponse returns a decoder for responses returned by the greet
// hello endpoint. restoreBody controls whether the response body should be
// restored after having been read.
func DecodeHelloResponse(decoder func(*http.Response) goahttp.Decoder, restoreBody bool) func(*http.Response) (interface{}, error) {
	return func(resp *http.Response) (interface{}, error) {
		if restoreBody {
			b, err := ioutil.ReadAll(resp.Body)
			if err != nil {
				return nil, err
			}
			resp.Body = ioutil.NopCloser(bytes.NewBuffer(b))
			defer func() {
				resp.Body = ioutil.NopCloser(bytes.NewBuffer(b))
			}()
		} else {
			defer resp.Body.Close()
		}
		switch resp.StatusCode {
		case http.StatusOK:
			var (
				body string
				err  error
			)
			err = decoder(resp).Decode(&body)
			if err != nil {
				return nil, goahttp.ErrDecodingError("greet", "hello", err)
			}
			return body, nil
		default:
			body, _ := ioutil.ReadAll(resp.Body)
			return nil, goahttp.ErrInvalidResponse("greet", "hello", resp.StatusCode, string(body))
		}
	}
}