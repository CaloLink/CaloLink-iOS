//
//  MockProductRepository.swift
//  CaloLink
//
//  Created by 김성훈 on 8/13/25.
//

import Foundation

// MARK: - MockProductRepository
// UI 개발 및 페이지네이션 테스트를 위해 100개의 가짜 데이터를 생성하고 관리하는 Repository
final class MockProductRepository: ProductRepositoryProtocol {

    // MARK: - 상품 목록 가져오기
    func fetchProducts(
        query: SearchQuery,
        completion: @escaping (Result<ProductPage, Error>) -> Void
    ) {
        // 실제 네트워크 통신처럼 보이도록 0.5초의 딜레이를 부여
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

            // 전체 100개의 목업 데이터에서 필터링/정렬을 수행가능 (지금은 생략)
            let allMockProducts = MockDataSource.products

            // 페이지네이션 로직
            let pageSize = 20 // 한 페이지에 20개의 아이템을 보여줌
            let totalItems = allMockProducts.count
            let totalPages = (totalItems + pageSize - 1) / pageSize // 전체 페이지 수 계산

            let startIndex = (query.page - 1) * pageSize
            let endIndex = min(startIndex + pageSize, totalItems)

            var paginatedProducts: [Product] = []
            if startIndex < endIndex {
                paginatedProducts = Array(allMockProducts[startIndex..<endIndex])
            }

            // 최종 ProductPage 객체를 생성하여 반환
            let productPage = ProductPage(
                products: paginatedProducts,
                currentPage: query.page,
                totalPages: totalPages
            )

            completion(.success(productPage))
        }
    }

    // MARK: - 상품 상세 정보 가져오기
    func fetchProductDetail(
        productId: String,
        completion: @escaping (Result<ProductDetail, Error>) -> Void
    ) {
        // 실제 네트워크 통신처럼 보이도록 0.5초의 딜레이를 부여
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // 전체 100개의 상세 데이터 중에서 id가 일치하는 것을 찾음
            if let detail = MockDataSource.productDetails.first(where: { $0.id == productId }) {
                completion(.success(detail))
            } else {
                // 만약 ID에 해당하는 데이터가 없으면 에러를 반환
                completion(.failure(NSError(domain: "MockError", code: 404, userInfo: [NSLocalizedDescriptionKey: "상품을 찾을 수 없습니다."])))
            }
        }
    }
}

// MARK: - MockDataSource
// 테스트를 위한 100개의 가짜 데이터를 생성하고 보관하는 static 구조체
fileprivate struct MockDataSource {
    
    // 100개의 가짜 상품 목록 데이터
    static let products: [Product] = (1...100).map { i in
        Product(
            id: "P\(i)",
            name: "고단백 식품 No.\(i)",
            imageURL: URL(string: "https://picsum.photos/seed/P\(i)/200"),
            price: 1500 + (i * 100),
            keyNutrients: [
                KeyNutrient(name: "단백질", value: "\(20 + (i % 10))g"),
                KeyNutrient(name: "칼로리", value: "\(100 + i)kcal")
            ]
        )
    }
    
    // 100개의 가짜 상품 상세 데이터
    static let productDetails: [ProductDetail] = (1...100).map { i in
        ProductDetail(
            id: "P\(i)",
            name: "고단백 식품 No.\(i) (상세)",
            imageURL: URL(string: "https://picsum.photos/seed/P\(i)/400"),
            nutritionInfo: NutritionInfo(
                totalSize: 100,
                calories: Double(100 + i),
                sodium: NutrientValue(amount: Double(200 + i), unit: "mg", percentage: Double(10 + (i % 5))),
                carbs: NutrientValue(amount: Double(5 + (i % 10)), unit: "g", percentage: Double(2 + (i % 3))),
                sugars: NutrientValue(amount: Double(i % 5), unit: "g", percentage: nil),
                fat: NutrientValue(amount: Double(3 + (i % 8)), unit: "g", percentage: Double(4 + (i % 4))),
                transFat: NutrientValue(amount: 0, unit: "g", percentage: 0),
                saturatedFat: NutrientValue(amount: 1, unit: "g", percentage: Double(5 + (i % 2))),
                cholesterol: NutrientValue(amount: Double(30 + i), unit: "mg", percentage: Double(10 + (i % 10))),
                protein: NutrientValue(amount: Double(20 + (i % 10)), unit: "g", percentage: Double(40 + (i % 10)))
            ),
            shopLinks: [
                ShopLink(mallName: "쿠팡", price: 1500 + (i * 100), linkURL: URL(string: "https://coupang.com")),
                ShopLink(mallName: "네이버쇼핑", price: 1450 + (i * 100), linkURL: URL(string: "https://shopping.naver.com")),
                ShopLink(mallName: "마켓컬리", price: 1550 + (i * 100), linkURL: URL(string: "https://kurly.com"))
            ]
        )
    }
}
