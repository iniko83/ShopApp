//
//  Constants.swift
//  CitySelectionFeature
//
//  Created by Igor Nikolaev on 18.06.2025.
//

import SwiftUI
import Utility

typealias ListSection = CitySelectionListSection
typealias Toast = CitySelectionToast
typealias ToastAction = CitySelectionToastAction
typealias ToastItem = CitySelectionToastItem

extension Animation {
  static let rowSelection = Animation.smooth
}

public extension Color {
  static let citySelection = Color.mainAccent
}

extension EdgeInsets {
  static let cityCell = EdgeInsets(horizontal: 16, vertical: 6)
}

extension TimeInterval {
  static let undoTimeout: TimeInterval = 3
  static let warningTimeout: TimeInterval = 3
}
