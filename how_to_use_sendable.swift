// Swift 6 prep: turn on SWIFT_STRICT_CONCURRENCY (Build Settings -> Swift Compiler) to Complete to see the warnings likely to be seen in Swift 6. This should save development time, especially on new projects.
SWIFT_STRICT_CONCURRENCY 

// On @unchecked Sendable
// Use @unchecked to override warnings if we know the compiler is wrong
// e.g., if there's a reference type whose read/write is safe
class Example: @unchecked Sendable {}

// On what NOT TO DO
// Compiler warning: Capture of 'cache' with non-sendable type 'FormatterCache' in a @Sendable closure
class FormatterCache { ... }
func performWork() async {
    let cache = FormatterCache()
    let possibleFormatters = ["YYYYMMDD", "YYYY", "YYYY-MM-DD"]

    await withTaskGroup(of: Void.self) { group in
        for _ in 0..<10 {
            group.addTask {
                let format = possibleFormatters.randomElement()!
                let formatter = cache.formatter(for: format)
            }
        }
    }
}

// On class
// To be sendable, a class must be final with immutable objects
final class Movie: Sendable {
    let formattedReleaseDate = "2022"
}

// Optional: mark as Sendable
// Sendable conformance is always inferred
struct Movie: Sendable { ... }

// The return type of a Task must conform to Sendable
struct Task<Success: Sendable, Failure: Error> {
  var value: Success {
    get async throws { … }
  }
}

// On @preconcurrency
// Silence Sendable warnings from imported module
@preconcurrency import FarmAnimals

// On @Sendable
// Sendable function type
func doWork(_ body: @Sendable @escaping () -> Void) {
  DispatchQueue.global().async {
    body()
  }
}

// Sources:
// - https://www.donnywals.com/what-are-sendable-and-sendable-closures-in-swift/?utm_campaign=iOS%2BDev%2BWeekly&utm_medium=rss&utm_source=iOS%2BDev%2BWeekly%2BIssue%2B578
// - https://www.donnywals.com/enabling-concurrency-warnings-in-xcode-14/
// - Swift evolution proposal discussing why no actor inheritance https://forums.swift.org/t/se-0306-actors/45734/4
// - WWDC 2022 Eliminate data races using Swift Concurrency https://developer.apple.com/wwdc22/110351

