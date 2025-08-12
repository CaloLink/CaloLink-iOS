//
//  ProductAPI.swift
//  CaloLink
//
//  Created by 김성훈 on 8/12/25.
//

// MARK: - ProductAPI (실제 API 명세서)
// 상품 관련 API들을 네임스페이스로 묶어서 관리
enum ProductAPI {

    // MARK: - 상품 목록을 검색하는 API 명세서
    struct Search: Endpoint {
        // 이 API의 응답 타입은 ProductListResponseDTO
        typealias Response = ProductListResponseDTO

        private let query: SearchQuery

        init(query: SearchQuery) {
            self.query = query
        }

        var path: String { APIConstant.pathSearchProducts }
        var method: HttpMethod { .get }
        var task: NetworkTask {
            // SearchQuery를 [String: Any?] 딕셔너리로 변환하여 파라미터로 전달
            let parameters: [String: Any?] = [
                APIConstant.keyQuery: query.searchText,
                APIConstant.keySort: query.sortOption.rawValue,
                APIConstant.keyPage: query.page,
                APIConstant.keyMinCalories: query.filterOption.minCalories,
                APIConstant.keyMaxCalories: query.filterOption.maxCalories,
                APIConstant.keyMinSodium: query.filterOption.minSodium,
                APIConstant.keyMaxSodium: query.filterOption.maxSodium,
                APIConstant.keyMinCarbs: query.filterOption.minCarbs,
                APIConstant.keyMaxCarbs: query.filterOption.maxCarbs,
                APIConstant.keyMinSugars: query.filterOption.minSugars,
                APIConstant.keyMaxSugars: query.filterOption.maxSugars,
                APIConstant.keyMinFat: query.filterOption.minFat,
                APIConstant.keyMaxFat: query.filterOption.maxFat,
                APIConstant.keyMinTransFat: query.filterOption.minTransFat,
                APIConstant.keyMaxTransFat: query.filterOption.maxTransFat,
                APIConstant.keyMinSaturatedFat: query.filterOption.minSaturatedFat,
                APIConstant.keyMaxSaturatedFat: query.filterOption.maxSaturatedFat,
                APIConstant.keyMinCholesterol: query.filterOption.minCholesterol,
                APIConstant.keyMaxCholesterol: query.filterOption.maxCholesterol,
                APIConstant.keyMinProtein: query.filterOption.minProtein,
                APIConstant.keyMaxProtein: query.filterOption.maxProtein
            ]
            return .requestWithParameters(parameters)
        }
    }

    // MARK: - 상품 상세 정보를 가져오는 API 명세서
    struct Detail: Endpoint {
        // 이 API의 응답 타입은 ProductDetailDTO
        typealias Response = ProductDetailDTO

        private let productId: String

        init(productId: String) {
            self.productId = productId
        }

        var path: String { APIConstant.pathProductDetail + productId }
        var method: HttpMethod { .get }
        var task: NetworkTask { .requestPlain }
    }
}
