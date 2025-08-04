//
//  RequestState.swift
//  Utility
//
//  Created by Igor Nikolaev on 17.06.2025.
//

import NetworkClient

@frozen public enum RequestState: Equatable {
  case `default`
  case loading
  case error(RequestError)
  
  public init() {
    self = .default
  }
  
  public func isRetryableError() -> Bool {
    guard case let .error(error) = self else { return false }
    return error.isRetryable()
  }
}
