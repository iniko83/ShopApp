//
//  Constants.swift
//  Utility
//
//  Created by Igor Nikolaev on 04.08.2025.
//

import SwiftUI

public extension Color {
  static let cellHighlighted = Color.dynamicRgbaHex(dark: 0xd9d9d919, light: 0xcdcdcd19)

  static let mainAccent = Color.dynamicRgbHex(dark: 0xffffff, light: 0x000000)
  static let mainBackground = Color.dynamicRgbHex(dark: 0xf1f1f1, light: 0x101010)

  /// used for buttons, with .clear would be pressed only near visible content (not by edges)
  static let transparentControl = Color(white: 0, opacity: 0.00001)
}

public extension EdgeInsets {
  static let buttonDefaultPadding = EdgeInsets(horizontal: 16, vertical: 8)
  static let zero = EdgeInsets(value: .zero)
}

public extension String {
  static let empty = ""
  static let space = " "

  static let cancellation = "Отмена"
  static let retry = "Повторить"
}
