//
//  APIConstant.swift
//  CaloLink
//
//  Created by 김성훈 on 8/12/25.
//

struct APIConstant {
    // MARK: - Base URL
    // TODO: - 실제 서버 Base URL로 교체하기
    static let baseURL = ""

    // MARK: - API 경로
    static let pathSearchProducts = "/products/search"
    static let pathProductDetail = "/products/"        // 뒤에 productId를 붙여서 사용

    // MARK: - PrameterKey
    static let keyQuery = "query"
    static let keySort = "sort"
    static let keyPage = "page"
    static let keyMinCalories = "minCalories"
    static let keyMaxCalories = "maxCalories"
    static let keyMinSodium = "minSodium"
    static let keyMaxSodium = "maxSodium"
    static let keyMinCarbs = "minCarbs"
    static let keyMaxCarbs = "maxCarbs"
    static let keyMinSugars = "minSugars"
    static let keyMaxSugars = "maxSugars"
    static let keyMinFat = "minFat"
    static let keyMaxFat = "maxFat"
    static let keyMinTransFat = "minTransFat"
    static let keyMaxTransFat = "maxTransFat"
    static let keyMinSaturatedFat = "minSaturatedFat"
    static let keyMaxSaturatedFat = "maxSaturatedFat"
    static let keyMinCholesterol = "minCholesterol"
    static let keyMaxCholesterol = "maxCholesterol"
    static let keyMinProtein = "minProtein"
    static let keyMaxProtein = "maxProtein"
}
