// Code generated by goa v3.5.2, DO NOT EDIT.
//
// greet HTTP client CLI support package
//
// Command:
// $ goa gen greet/design

package cli

import (
	"flag"
	"fmt"
	greetc "greet/gen/http/greet/client"
	"net/http"
	"os"

	goahttp "goa.design/goa/v3/http"
	goa "goa.design/goa/v3/pkg"
)

// UsageCommands returns the set of commands and sub-commands using the format
//
//    command (subcommand1|subcommand2|...)
//
func UsageCommands() string {
	return `greet hello
`
}

// UsageExamples produces an example of a valid invocation of the CLI tool.
func UsageExamples() string {
	return os.Args[0] + ` greet hello --name "Deleniti temporibus voluptas eos consectetur impedit explicabo."` + "\n" +
		""
}

// ParseEndpoint returns the endpoint and payload as specified on the command
// line.
func ParseEndpoint(
	scheme, host string,
	doer goahttp.Doer,
	enc func(*http.Request) goahttp.Encoder,
	dec func(*http.Response) goahttp.Decoder,
	restore bool,
) (goa.Endpoint, interface{}, error) {
	var (
		greetFlags = flag.NewFlagSet("greet", flag.ContinueOnError)

		greetHelloFlags    = flag.NewFlagSet("hello", flag.ExitOnError)
		greetHelloNameFlag = greetHelloFlags.String("name", "REQUIRED", "Name")
	)
	greetFlags.Usage = greetUsage
	greetHelloFlags.Usage = greetHelloUsage

	if err := flag.CommandLine.Parse(os.Args[1:]); err != nil {
		return nil, nil, err
	}

	if flag.NArg() < 2 { // two non flag args are required: SERVICE and ENDPOINT (aka COMMAND)
		return nil, nil, fmt.Errorf("not enough arguments")
	}

	var (
		svcn string
		svcf *flag.FlagSet
	)
	{
		svcn = flag.Arg(0)
		switch svcn {
		case "greet":
			svcf = greetFlags
		default:
			return nil, nil, fmt.Errorf("unknown service %q", svcn)
		}
	}
	if err := svcf.Parse(flag.Args()[1:]); err != nil {
		return nil, nil, err
	}

	var (
		epn string
		epf *flag.FlagSet
	)
	{
		epn = svcf.Arg(0)
		switch svcn {
		case "greet":
			switch epn {
			case "hello":
				epf = greetHelloFlags

			}

		}
	}
	if epf == nil {
		return nil, nil, fmt.Errorf("unknown %q endpoint %q", svcn, epn)
	}

	// Parse endpoint flags if any
	if svcf.NArg() > 1 {
		if err := epf.Parse(svcf.Args()[1:]); err != nil {
			return nil, nil, err
		}
	}

	var (
		data     interface{}
		endpoint goa.Endpoint
		err      error
	)
	{
		switch svcn {
		case "greet":
			c := greetc.NewClient(scheme, host, doer, enc, dec, restore)
			switch epn {
			case "hello":
				endpoint = c.Hello()
				data, err = greetc.BuildHelloPayload(*greetHelloNameFlag)
			}
		}
	}
	if err != nil {
		return nil, nil, err
	}

	return endpoint, data, nil
}

// greetUsage displays the usage of the greet command and its subcommands.
func greetUsage() {
	fmt.Fprintf(os.Stderr, `Service that manage greeting
Usage:
    %[1]s [globalflags] greet COMMAND [flags]

COMMAND:
    hello: Hello implements hello.

Additional help:
    %[1]s greet COMMAND --help
`, os.Args[0])
}
func greetHelloUsage() {
	fmt.Fprintf(os.Stderr, `%[1]s [flags] greet hello -name STRING

Hello implements hello.
    -name STRING: Name

Example:
    %[1]s greet hello --name "Deleniti temporibus voluptas eos consectetur impedit explicabo."
`, os.Args[0])
}
