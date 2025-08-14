//
//  ProductRepositoryProtocol.swift
//  CaloLink
//
//  Created by 김성훈 on 8/12/25.
//

// MARK: - 상품 데이터에 접근하기 위한 인터페이스
// Domain 계층은 이 프로토콜에만 의존, 실제 구현은 Data 계층에서 담당
// 네트워크 통신은 비동기이므로 Completion Handler로 결과를 반환
protocol ProductRepositoryProtocol {
    // 특정 조건에 맞는 상품 목록 가져오기
    func fetchProducts(
        query: SearchQuery,
        completion: @escaping (Result<[Product], Error>) -> Void
    )

    // 특정 상품의 상세 정보 가져오기
    func fetchProductDetail(
        productId: String,
        completion: @escaping (Result<ProductDetail, Error>) -> Void
    )
}

// MARK: - SearchQuery
// 상품 목록을 검색할 때 필요한 모든 조건을 담는 구조체
struct SearchQuery {
    let searchText: String              // 검색어
    var sortOption: SortOption          // 정렬조건
    let filterOption: FilterOption      // 필터조건
    let page: Int                       // 페이지네이션의 페이지 번호

    // 기본값 설정
    static let `default` = SearchQuery(searchText: "",
                                       sortOption: .defaultOrder,
                                       filterOption: .default,
                                       page: 1)
}

// MARK: - SortOption
enum SortOption: String, CaseIterable {
    case defaultOrder                   // 기본순
    case priceAscending                 // 가격 낮은 순
    case priceDescending                // 가격 높은 순
    case newest                         // 신상품순
}

// MARK: - FilterOption
struct FilterOption {
    let minCalories: Double?
    let maxCalories: Double?
    
    let minSodium: Double?
    let maxSodium: Double?
    
    let minCarbs: Double?
    let maxCarbs: Double?
    
    let minSugars: Double?
    let maxSugars: Double?
    
    let minFat: Double?
    let maxFat: Double?
    
    let minTransFat: Double?
    let maxTransFat: Double?
    
    let minSaturatedFat: Double?
    let maxSaturatedFat: Double?
    
    let minCholesterol: Double?
    let maxCholesterol: Double?
    
    let minProtein: Double?
    let maxProtein: Double?

    static let `default` = FilterOption(
        minCalories: nil, maxCalories: nil,
        minSodium: nil, maxSodium: nil,
        minCarbs: nil, maxCarbs: nil,
        minSugars: nil, maxSugars: nil,
        minFat: nil, maxFat: nil,
        minTransFat: nil, maxTransFat: nil,
        minSaturatedFat: nil, maxSaturatedFat: nil,
        minCholesterol: nil, maxCholesterol: nil,
        minProtein: nil, maxProtein: nil
    )
}
