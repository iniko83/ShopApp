// The Swift Programming Language
// https://docs.swift.org/swift-book

/*
 Ultralightweight DI container for SwiftUI.
 Support only classes as Services.

 Usage:
  extension YourView {
    @Observable
    final class ViewModel {
      @ObservationIgnored @Injected var someService: SomeService

      ...
    }
  }

 Based on: [ https://tanaschita.com/dependency-injection-building-lightweight-container/ ]
 Notes: @MainActor because all ViewModel's in SwiftUI would be created only on main thread.
*/

fileprivate typealias Key = String

@MainActor
public final class Resolver {
  private var items: [Key: Item] = [:]

  private init() {}

  public func register<Service: AnyObject>(
    _ type: Service.Type,
    lifetime: Lifetime,
    factory: @escaping () -> Service
  ) {
    let key = Self.key(type)
    items[key] = .init(
      lifetime: lifetime,
      factory: factory
    )
  }

  public func resolve<Service: AnyObject>(_ type: Service.Type = Service.self) -> Service {
    guard let result = resolveOptional(type) else {
      fatalError("No dependency registered for \(Service.self)")
    }
    return result
  }

  public func resolveOptional<Service: AnyObject>(_ type: Service.Type = Service.self) -> Service? {
    let key = Self.key(type)

    guard let item = items[key] else { return nil }

    let result: Service
    switch item.lifetime {
    case .transient:
      result = item.factory() as! Service

    case .singleton:
      if let instance = item.singleton {
        result = instance as! Service
      } else {
        result = item.factory() as! Service
        items[key]?.singleton = result
      }
    }
    return result
  }

  static private func key<Service: AnyObject>(_ type: Service.Type) -> Key {
    .init(describing: type)
  }
}

extension Resolver {
  public enum Lifetime: Int {
    case singleton
    case transient
  }

  struct Item {
    let lifetime: Lifetime
    let factory: () -> AnyObject
    var singleton: AnyObject?
  }
}

extension Resolver {
  public static let shared = Resolver()
}
