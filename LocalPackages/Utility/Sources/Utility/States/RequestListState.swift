//
//  RequestListState.swift
//  Utility
//
//  Created by Igor Nikolaev on 04.08.2025.
//

import NetworkClient

@frozen public enum RequestListState: Equatable {
  case `default`
  case loading
  case empty
  case error(RequestError)

  public init() {
    self = .default
  }

  public func isLoadingOrEmpty() -> Bool {
    let result: Bool
    switch self {
    case .loading, .empty:
      result = true
    default:
      result = false
    }
    return result
  }

  public func isRetryableError() -> Bool {
    guard case let .error(error) = self else { return false }
    return error.isRetryable()
  }
}
