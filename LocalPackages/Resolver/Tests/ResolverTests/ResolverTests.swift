import Testing
import Foundation

@testable import Resolver

@Suite("Resolver tests")
@MainActor
struct ResolverTests {
  @Test("Lifetime tests")
  func takeSingletonServiceTwoTimesHaveOneAddress() async throws {
    let isSingletonAddressesEqual = isTwoServicesAddressesEqual(lifetime: .singleton)
    let isTrancientAddressesDifferent = !isTwoServicesAddressesEqual(lifetime: .transient)

    #expect(isSingletonAddressesEqual)
    #expect(isTrancientAddressesDifferent)
  }

  private func isTwoServicesAddressesEqual(lifetime: Resolver.Lifetime) -> Bool {
    registerMockService(lifetime: lifetime)

    let serviceA: MockService = Resolver.shared.resolve()
    let serviceB: MockService = Resolver.shared.resolve()

    let addressA = address(serviceA)
    let addressB = address(serviceB)

    let result = addressA == addressB

//    print("addresses A: \(addressA), B: \(addressB), isEqual: \(result)")

    return result
  }

  fileprivate class MockService {}
}

private extension ResolverTests {
  func address<T: AnyObject>(_ object: T) -> UnsafeMutableRawPointer {
    // [ https://stackoverflow.com/a/41666807 ]
    Unmanaged.passUnretained(object).toOpaque()
  }

  func registerMockService(lifetime: Resolver.Lifetime) {
    Resolver.shared.register(
      MockService.self,
      lifetime: lifetime,
      factory: { MockService() }
    )
  }
}
