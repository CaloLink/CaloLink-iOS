//
//  FilterViewModel.swift
//  CaloLink
//
//  Created by 김성훈 on 6/11/25.
//

import Foundation

struct Nutrient {
    let title: String
    let unit: String
    let max: Float
    let key: String
}

final class FilterViewModel {
    let nutrients: [Nutrient] = [
        // TODO: 검색 범위 정해서 입력하기
        Nutrient(title: "총칼로리", unit: "kcal", max: 1000, key: "calories"),
        Nutrient(title: "나트륨", unit: "mg", max: 2000, key: "sodium"),
        Nutrient(title: "탄수화물", unit: "g", max: 500, key: "carbs"),
        Nutrient(title: "당류", unit: "g", max: 100, key: "sugar"),
        Nutrient(title: "지방", unit: "g", max: 100, key: "fat"),
        Nutrient(title: "트랜스지방", unit: "g", max: 5, key: "transFat"),
        Nutrient(title: "포화지방", unit: "g", max: 50, key: "saturatedFat"),
        Nutrient(title: "콜레스테롤", unit: "mg", max: 500, key: "cholesterol"),
        Nutrient(title: "단백질", unit: "g", max: 200, key: "protein")
    ]

    // 선택된 필터 값 저장
    private(set) var filterValues: [String: (min: Float, max: Float)] = [:]
}

// MARK: - Interface func
extension FilterViewModel {
    // 필터 설정
    func setFilter(forKey key: String, min: Float, max: Float) {
        filterValues[key] = (min, max)
    }

    // 필터 초기화
    func resetFilters() {
        filterValues.removeAll()
    }
}
