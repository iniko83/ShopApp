// The Swift Programming Language
// https://docs.swift.org/swift-book

import Combine

public protocol NetworkConnectionService: Sendable {
  @MainActor
  func connectionRelay() -> AnyPublisher<Bool, Never>
}

public enum NetworkConnectionObserver {
  public static let live: NetworkConnectionService = NetworkConnectionLive()
  public static let offline: NetworkConnectionService = NetworkConnectionOffline()
  public static let online: NetworkConnectionService = NetworkConnectionOnline()
}


private final class NetworkConnectionLive: NetworkConnectionService {
  private let monitor = NetworkMonitor()

  func connectionRelay() -> AnyPublisher<Bool, Never> {
    monitor.$isConnected.eraseToAnyPublisher()
  }
}

private struct NetworkConnectionOffline: NetworkConnectionService {
  func connectionRelay() -> AnyPublisher<Bool, Never> {
    Just(false).eraseToAnyPublisher()
  }
}

private struct NetworkConnectionOnline: NetworkConnectionService {
  func connectionRelay() -> AnyPublisher<Bool, Never> {
    Just(true).eraseToAnyPublisher()
  }
}
