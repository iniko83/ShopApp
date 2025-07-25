//
//  CitySearchEngine.swift
//  CitySelectionFeature
//
//  Created by Igor Nikolaev on 20.06.2025.
//

import Utility

/* Results always alphabetically ordered. */

public struct CitySearchEngine: Sendable {
  let cities: [City]
  
  // dependent
  let defaultResponse: CitySearchResponse
  private let searchItems: [CitySearchItem]
  
  init(cities: [City] = []) {
    self.cities = cities
    
    defaultResponse = Self.makeDefaultResponse(cities: cities)
    
    searchItems = cities
      .map { city in
        CitySearchItem(
          index: city.id,
          lowercasedName: city.name.lowercased()
        )
      }
      .sorted(by: { $0.lowercasedName < $1.lowercasedName })
  }
  
  func isEmpty() -> Bool {
    cities.isEmpty
  }
  
  func findNearestCity(to coordinate: Coordinate?) async -> City? {
    guard let coordinate else { return nil }
    return cities.nearest(to: coordinate)
  }
  
  func search(unemptyQuery query: String) async -> CitySearchResult {
    let searchItems = searchItems(query: query)
    return makeResult(searchItems: searchItems)
  }

  private func cities(ids: [Int]) -> [City] {
    ids.map { cities[$0] }
  }

  private func searchItems(query: String) -> [CitySearchItem] {
    let queryParts = query.components(separatedBy: String.space)
    let queryPartsCount = queryParts.count
    let enumeratedQueryParts = queryParts.enumerated()
    
    let range = searchItems.binarySearch { searchItem -> ComparisonResult in
      let name = searchItem.lowercasedName
      let nameParts = name.components(separatedBy: String.space)
      
      var result = ComparisonResult.equal
      if nameParts.count >= queryPartsCount {
        for (index, queryPart) in enumeratedQueryParts {
          let namePart = nameParts[index]
          
          guard
            let lowerBound = namePart.range(of: queryPart)?.lowerBound,
            lowerBound == namePart.startIndex
          else {
            result = namePart.compare(queryPart)
            break
          }
        }
      } else {
        result = name.compare(query)
      }
      return result
    }
    
    return Array(searchItems[safe: range])
  }
  
  private func makeResult(searchItems: [CitySearchItem]) -> CitySearchResult {
    let sortedItems = searchItems
      .map { item -> CitySearchSortItem in
        let size = cities[item.index].size
        return .init(item: item, size: size)
      }
      .sorted(by: { (lhs, rhs) in
        let leftValue = lhs.size.isBigOrMiddle()
        let rightValue = rhs.size.isBigOrMiddle()
        
        let result: Bool
        if leftValue != rightValue {
          result = leftValue
        } else {
          result = false
        }
        return result
      })
    
    let ids = sortedItems.map { $0.item.index }
    
    let threshold = sortedItems.upperBound { item -> ComparisonResult in
      !item.size.isBigOrMiddle() ? .greater : .equal
    }
    let count = sortedItems.count
    let isDivided = threshold > 0 && threshold < count
    
    let sections: [ListSection] = isDivided
      ? ListSection.CombinedCitySizes.allCases
        .map { sizes -> ListSection in
          let range: Range<Int> = sizes == .bigAndMiddle
          ? (0 ..< threshold)
          : (threshold ..< count)
          let citiesSlice = sortedItems[safe: range]
            .map { sortedItem -> City in
              let id = sortedItem.item.index
              return cities[id]
            }
          return .init(kind: .combinedSizes(sizes), cities: Array(citiesSlice))
        }
      : [.init(kind: .untitled, cities: cities(ids: ids))]

    return .init(
      listSections: sections,
      mapIds: Set(ids)
    )
  }
  
  private static func makeDefaultResponse(cities: [City]) -> CitySearchResponse {
    let mapIds = cities.map { $0.id }
    let bigCities = cities
      .prefix(while: { $0.size == .big })
      .sorted(by: { $0.name < $1.name })
    let section = ListSection(kind: .bigCities, cities: bigCities)

    let searchResult = CitySearchResult(
      listSections: [section],
      mapIds: Set(mapIds)
    )
    return searchResult.makeResponse(query: .empty)
  }
}

/*
 Sections will contain [.bigCities] for default and [.untitled] or [CombinedCitySizes.allCases] for search.
 Each section contains alphabetically ordered cities.
*/

public struct CitySearchResponse: Sendable {
  let result: CitySearchResult
  let query: String

  func isFoundNothing() -> Bool {
    !query.isEmpty && result.mapIds.isEmpty
  }
}

public struct CitySearchResult: Sendable {
  let listSections: [ListSection]
  let mapIds: Set<Int>

  func makeResponse(query: String) -> CitySearchResponse {
    .init(result: self, query: query)
  }
}

private struct CitySearchItem {
  let index: Int
  let lowercasedName: String
}

private struct CitySearchSortItem {
  let item: CitySearchItem
  let size: CitySize
}

private extension Array where Element == City {
  func nearest(to coordinate: Coordinate) -> City? {
    var result: City?
    var minimumDistance = Double.greatestFiniteMagnitude
    for city in self {
      let distance = city.coordinate.distance(to: coordinate)
      if distance < minimumDistance {
        minimumDistance = distance
        result = city
      }
    }
    return result
  }
}

private extension CitySize {
  func isBigOrMiddle() -> Bool {
    rawValue < CitySize.small.rawValue
  }
}
