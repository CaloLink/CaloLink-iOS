//
//  FilterViewModel.swift
//  CaloLink
//
//  Created by 김성훈 on 8/14/25.
//

import Foundation

// MARK: - FilterViewModel
final class FilterViewModel {
    // MARK: - Nested Types

    // ViewController가 UI를 그리기 위해 사용하는 정보
    struct FilterItem {
        let type: FilterType
        var minValue: String?
        var maxValue: String?

        var title: String { type.title }
        var unit: String { type.unit }
    }

    // 필터링할 각 영양성분의 종류와 메타데이터
    enum FilterType: CaseIterable {
        case calories, sodium, carbs, sugars, fat, transFat, saturatedFat, cholesterol, protein

        var title: String {
            switch self {
            case .calories: "총 칼로리"
            case .sodium: "나트륨"
            case .carbs: "탄수화물"
            case .sugars: "당류"
            case .fat: "지방"
            case .transFat: "트랜스지방"
            case .saturatedFat: "포화지방"
            case .cholesterol: "콜레스테롤"
            case .protein: "단백질"
            }
        }

        var unit: String {
            switch self {
            case .sodium, .cholesterol: "mg"
            default: "g"
            }
        }
    }

    // MARK: - 프로퍼티

    // View에 표시할 필터 항목들의 배열
    private(set) var filterItems: [FilterItem] = []

    // 최종적으로 ListViewController에 전달될 필터 옵션
    var resultingFilterOption: FilterOption {
        // filterItems에 저장된 문자열 값들을 Double로 변환하여 FilterOption을 생성
        var option = FilterOption.default
        for item in filterItems {
            let min = Double(item.minValue ?? "")
            let max = Double(item.maxValue ?? "")

            switch item.type {
            case .calories:
                option.minCalories = min
                option.maxCalories = max
            case .sodium:
                option.minSodium = min
                option.maxSodium = max
            case .carbs:
                option.minCarbs = min
                option.maxCarbs = max
            case .sugars:
                option.minSugars = min
                option.maxSugars = max
            case .fat:
                option.minFat = min
                option.maxFat = max
            case .transFat:
                option.minTransFat = min
                option.maxTransFat = max
            case .saturatedFat:
                option.minSaturatedFat = min
                option.maxSaturatedFat = max
            case .cholesterol:
                option.minCholesterol = min
                option.maxCholesterol = max
            case .protein:
                option.minProtein = min
                option.maxProtein = max
            }
        }
        return option
    }

    // MARK: - Initializer
    init(currentFilterOption: FilterOption) {
        // FilterType의 모든 케이스를 순회하며 filterItems 배열을 초기화
        self.filterItems = FilterType.allCases.map { type in
            var minValue: String?
            var maxValue: String?

            // currentFilterOption에 저장된 값을 문자열로 변환하여 초기값으로 설정
            switch type {
            case .calories:
                minValue = currentFilterOption.minCalories?.description
                maxValue = currentFilterOption.maxCalories?.description
            case .sodium:
                minValue = currentFilterOption.minSodium?.description
                maxValue = currentFilterOption.maxSodium?.description
            case .carbs:
                minValue = currentFilterOption.minCarbs?.description
                maxValue = currentFilterOption.maxCarbs?.description
            case .sugars:
                minValue = currentFilterOption.minSugars?.description
                maxValue = currentFilterOption.maxSugars?.description
            case .fat:
                minValue = currentFilterOption.minFat?.description
                maxValue = currentFilterOption.maxFat?.description
            case .transFat:
                minValue = currentFilterOption.minTransFat?.description
                maxValue = currentFilterOption.maxTransFat?.description
            case .saturatedFat:
                minValue = currentFilterOption.minSaturatedFat?.description
                maxValue = currentFilterOption.maxSaturatedFat?.description
            case .cholesterol:
                minValue = currentFilterOption.minCholesterol?.description
                maxValue = currentFilterOption.maxCholesterol?.description
            case .protein:
                minValue = currentFilterOption.minProtein?.description
                maxValue = currentFilterOption.maxProtein?.description
            }

            return FilterItem(type: type, minValue: minValue, maxValue: maxValue)
        }
    }

    // MARK: - 메서드

    // 사용자가 입력한 값을 업데이트
    func updateValue(at index: Int, minValue: String?, maxValue: String?) {
        guard index < filterItems.count else { return }
        filterItems[index].minValue = minValue
        filterItems[index].maxValue = maxValue
    }

    // 모든 필터 값을 초기화
    func resetFilters() {
        for i in 0..<filterItems.count {
            filterItems[i].minValue = nil
            filterItems[i].maxValue = nil
        }
    }
}
