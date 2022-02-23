package design

import (
	. "goa.design/goa/v3/dsl"
)

var User = ResultType("User", func() {
	Attributes(func() {
		Attribute("id", Int, "ID")
		Attribute("email", String, "Email")
		Attribute("name", String, "Name")
	})
})

var _ = API("sanmpleApi", func() {
	Title("Sample API Service")
	Description("Service for sample api")
	Server("sampleApi", func() {
		Host("localhost", func() {
			URI("http://localhost:8002")
		})
	})
})

var _ = Service("sampleApi", func() {
	Description("Sample API Service")

	Method("show", func() {
		Payload(func() {
			Attribute("id", Int, "ID")
			Required("id")
		})

		Result(User)

		HTTP(func() {
			GET("/users/{id}")
			Response(StatusOK)
		})
	})

	Files("/openapi.json", "./gen/http/openapi.json")
})
