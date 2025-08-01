//
//  Injected+PropertyWrapper.swift
//  Resolver
//
//  Created by Igor Nikolaev on 01.08.2025.
//

@MainActor
@propertyWrapper
public struct Injected<T: AnyObject> {
  private let dependency: T

  public init() {
    dependency = Resolver.shared.resolve(T.self)
  }

  public var wrappedValue: T {
    dependency
  }
}
