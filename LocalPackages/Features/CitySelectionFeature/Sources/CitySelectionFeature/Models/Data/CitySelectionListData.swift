//
//  CitySelectionListData.swift
//  CitySelectionFeature
//
//  Created by Igor Nikolaev on 11.07.2025.
//

import Foundation

struct CitySelectionListData: Equatable {
  var isFoundNothing: Bool
  var sections: [ListSection]

  var searchQuery: String // used only for equatable

  static func == (lhs: CitySelectionListData, rhs: CitySelectionListData) -> Bool {
    lhs.searchQuery == rhs.searchQuery
  }
}

extension CitySelectionListData {
  init() {
    self.init(
      isFoundNothing: false,
      sections: [],
      searchQuery: .empty
    )
  }
}
