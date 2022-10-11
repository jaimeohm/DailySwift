// Example of nested observable object
class BookViewModel: ObservableObject {
  let bookService = BookService()
}

class BookService: ObservableObject {
  @Published var count = 42
}

// Example failure
// View does not bind & update on count because bookService is nested
viewModel.bookService.count

// 3 Options:
// 1. Propagate object: Observe nested object & publish manually using objectWillChange
// 2. Observe inner property
// 3. Generic extension

// Example solution for nested object
//
// Propagate object: 
// Observe nested object & publish manually using objectWillChange
//
// Pro/Con:
// This propogates the whole object, so may lead to unwanted refreshes in the future (aka on more complex view models)
class BookViewModel {
  init() {
    // Propagate the change from nested ObservableObject
    bookService.objectWillChange
      .receive(on: RunLoop.main)
      .sink { [weak self] in
          self?.objectWillChange.send()
      }
      .store(in: &cancellables)
      
    // If you have multiple services...
    Publishers.Merge(bookService.objectWillChange, anotherService.objectWillChange)
  }
}

// Example solution for nested object
// 
// Observe inner property
// Observe the inner property and not the whole parent object
// 
// Pros/Con
// - Must update propogation when adding a published var
// - Won't lead to unwanted refreshes because we're specifying which property to update

// Example solution for nested object
//
// Use a generic extension
//
// Pro/Con:
// This propogates the whole object, so may lead to unwanted refreshes in the future (aka on more complex view models). Reusable / modular. 
import Combine
extension ObservableObject {
  func republishObservable<child: observableobject="">(child: Child) -> AnyCancellable {
    return child.objectWillChange
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        if let publisher = self?.objectWillChange as? ObservableObjectPublisher {
          publisher.send()
        }
      }
  }
}
republishObservable(child:bookService).store(in: &cancellables)

// Source:
// - https://samwize.com/2023/09/30/pitfall-of-nested-observableobject

