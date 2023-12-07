// Code generated by goa v3.5.2, DO NOT EDIT.
//
// sampleApi views
//
// Command:
// $ goa gen sampleApi/design

package views

import (
	goa "goa.design/goa/v3/pkg"
)

// User is the viewed result type that is projected based on a view.
type User struct {
	// Type to project
	Projected *UserView
	// View to render
	View string
}

// UserView is a type that runs validations on a projected type.
type UserView struct {
	// ID
	ID *int
	// Email
	Email *string
	// Name
	Name *string
}

var (
	// UserMap is a map indexing the attribute names of User by view name.
	UserMap = map[string][]string{
		"default": {
			"id",
			"email",
			"name",
		},
	}
)

// ValidateUser runs the validations defined on the viewed result type User.
func ValidateUser(result *User) (err error) {
	switch result.View {
	case "default", "":
		err = ValidateUserView(result.Projected)
	default:
		err = goa.InvalidEnumValueError("view", result.View, []interface{}{"default"})
	}
	return
}

// ValidateUserView runs the validations defined on UserView using the
// "default" view.
func ValidateUserView(result *UserView) (err error) {

	return
}
