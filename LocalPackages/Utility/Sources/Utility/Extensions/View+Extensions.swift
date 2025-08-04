//
//  View+Extensions.swift
//  Utility
//
//  Created by Igor Nikolaev on 14.06.2025.
//

import SwiftUI

/// Famous
public extension View {
  @ViewBuilder
  func `if`<Content: View>(
    _ condition: Bool,
    transform: (Self) -> Content
  ) -> some View {
    if condition {
      transform(self)
    } else {
      self
    }
  }
}


/// Others
public extension View {
  @inlinable nonisolated func frame(maxSquare: CGFloat) -> some View {
    self.frame(maxWidth: maxSquare, maxHeight: maxSquare)
  }
  
  @inlinable nonisolated func frame(
    square: CGFloat,
    alignment: Alignment = .center
  ) -> some View {
    self.frame(
      width: square,
      height: square,
      alignment: alignment
    )
  }
  
  @inlinable nonisolated func frame(
    size: CGSize,
    alignment: Alignment = .center
  ) -> some View {
    self.frame(
      width: size.width,
      height: size.height,
      alignment: alignment
    )
  }
}

public extension View {
  @ViewBuilder
  func iconSymbolEffect() -> some View {
    if #available(iOS 18, *) {
      self.symbolEffect(
        .wiggle,
        options: .repeat(.periodic(nil, delay: 5)).speed(0.7),
        isActive: true
      )
    } else if #available(iOS 17, *) {
      self.symbolEffect(.pulse, options: .repeating, isActive: true)
    } else {
      self
    }
  }
}
