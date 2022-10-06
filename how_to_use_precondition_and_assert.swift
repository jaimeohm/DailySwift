// USE ASSERTIONS A LOT! MORE! MORE!!!
// I use an assert when I would normally print an error that I don't expect
// Assert runs in debug (-Onone flag), but not in production (-O flag)
assert(true, "optional message")
assertionFailure("optional message")

// I use precondition to force failure in production code
// e.g., to preserve data integrity
precondition(true, "optional message")
preconditionFailure("optional message")
fatalError("optional message")
