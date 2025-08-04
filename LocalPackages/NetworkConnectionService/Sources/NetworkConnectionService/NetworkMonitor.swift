//
//  NetworkMonitor.swift
//  NetworkStatusObserver
//
//  Created by Igor Nikolaev on 04.08.2025.
//

import Foundation
import Network

@MainActor
final class NetworkMonitor {
  @Published var isConnected = false

  private let monitor = NWPathMonitor(prohibitedInterfaceTypes: .prohibited)
  private let monitorQueue = DispatchQueue(label: "ShopApp.NetworkMonitor")

  nonisolated init() {
    monitor.pathUpdateHandler = { [weak self] path in
      let isConnected = path.status == .satisfied
      Task { @MainActor in
        self?.isConnected = isConnected
      }
    }
    monitor.start(queue: monitorQueue)
  }

  deinit {
    monitor.cancel()
    monitor.pathUpdateHandler = nil
  }
}


/// Constants
private extension Array where Element == NWInterface.InterfaceType {
  static let prohibited: [NWInterface.InterfaceType] = [
    .other,
    .wiredEthernet,
    .loopback
  ]
}
