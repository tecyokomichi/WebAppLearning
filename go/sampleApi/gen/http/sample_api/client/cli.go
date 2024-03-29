// Code generated by goa v3.5.2, DO NOT EDIT.
//
// sampleApi HTTP client CLI support package
//
// Command:
// $ goa gen sampleApi/design

package client

import (
	"fmt"
	sampleapi "sampleApi/gen/sample_api"
	"strconv"
)

// BuildShowPayload builds the payload for the sampleApi show endpoint from CLI
// flags.
func BuildShowPayload(sampleAPIShowID string) (*sampleapi.ShowPayload, error) {
	var err error
	var id int
	{
		var v int64
		v, err = strconv.ParseInt(sampleAPIShowID, 10, 64)
		id = int(v)
		if err != nil {
			return nil, fmt.Errorf("invalid value for id, must be INT")
		}
	}
	v := &sampleapi.ShowPayload{}
	v.ID = id

	return v, nil
}
