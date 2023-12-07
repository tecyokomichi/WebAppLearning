package design

import . "goa.design/goa/v3/dsl"

var _ = API("greet", func() {
	Title("Greeting Service")
	Description("Service that manage greeting")
	Server("greet", func() {
		Host("localhost", func() { URI("http://localhost:8001") })
	})
})

var _ = Service("greet", func() {
	Description("Service that manage greeting")
	Method("hello", func() {
		Payload(func() {
			Attribute("name", String, "Name")
			Required("name")
		})

		Result(String)

		HTTP(func() {
			GET("/hello/{name}")
			Response(StatusOK)
		})
	})
})
