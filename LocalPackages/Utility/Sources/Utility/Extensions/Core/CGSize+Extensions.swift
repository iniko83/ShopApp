//
//  CGSize+Extensions.swift
//  Utility
//
//  Created by Igor Nikolaev on 14.06.2025.
//

import CoreFoundation

public extension CGSize {
  func minSide() -> CGFloat {
    min(width, height)
  }
}
