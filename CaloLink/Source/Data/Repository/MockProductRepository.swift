//
//  MockProductRepository.swift
//  CaloLink
//
//  Created by 김성훈 on 8/13/25.
//

import Foundation

// MARK: - MockProductRepository
// 테스트를 위해 실제 네트워크 통신 없이 가짜 데이터를 반환하는 Repository
final class MockProductRepository: ProductRepositoryProtocol {
    // MARK: - 상품 목록 가져오기 (가짜 데이터)
    func fetchProducts(
        query: SearchQuery,
        completion: @escaping (Result<[Product], Error>) -> Void
    ) {
        // 실제 네트워크 통신처럼 보이도록 0.5초의 딜레이를 부여
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let mockProducts: [Product] = [
                Product(
                    id: "P001",
                    name: "맛있는 닭가슴살 100g (검색어: \(query.searchText))",
                    imageURL: URL(string: "https://example.com/images/chicken_breast.jpg"),
                    price: 2500,
                    keyNutrients: [
                        KeyNutrient(name: "단백질", value: "25g"),
                        KeyNutrient(name: "칼로리", value: "130kcal")
                    ]
                ),
                Product(
                    id: "P002",
                    name: "고단백 프로틴 쉐이크",
                    imageURL: nil, // 이미지가 없는 경우 테스트
                    price: 3000,
                    keyNutrients: [
                        KeyNutrient(name: "단백질", value: "30g"),
                        KeyNutrient(name: "당류", value: "2g")
                    ]
                ),
                Product(
                    id: "P003",
                    name: "저염 현미밥 도시락",
                    imageURL: URL(string: "https://example.com/images/rice_box.jpg"),
                    price: 4500,
                    keyNutrients: [
                        KeyNutrient(name: "나트륨", value: "250mg"),
                        KeyNutrient(name: "탄수화물", value: "50g")
                    ]
                ),
                Product(
                    id: "P002",
                    name: "고단백 프로틴 쉐이크",
                    imageURL: nil, // 이미지가 없는 경우 테스트
                    price: 3000,
                    keyNutrients: [
                        KeyNutrient(name: "단백질", value: "30g"),
                        KeyNutrient(name: "당류", value: "2g")
                    ]
                ),
                Product(
                    id: "P002",
                    name: "고단백 프로틴 쉐이크",
                    imageURL: nil, // 이미지가 없는 경우 테스트
                    price: 3000,
                    keyNutrients: [
                        KeyNutrient(name: "단백질", value: "30g"),
                        KeyNutrient(name: "당류", value: "2g")
                    ]
                ),
                Product(
                    id: "P002",
                    name: "고단백 프로틴 쉐이크",
                    imageURL: nil, // 이미지가 없는 경우 테스트
                    price: 3000,
                    keyNutrients: [
                        KeyNutrient(name: "단백질", value: "30g"),
                        KeyNutrient(name: "당류", value: "2g")
                    ]
                ),
                Product(
                    id: "P002",
                    name: "고단백 프로틴 쉐이크",
                    imageURL: nil, // 이미지가 없는 경우 테스트
                    price: 3000,
                    keyNutrients: [
                        KeyNutrient(name: "단백질", value: "30g"),
                        KeyNutrient(name: "당류", value: "2g")
                    ]
                ),
                Product(
                    id: "P002",
                    name: "고단백 프로틴 쉐이크",
                    imageURL: nil, // 이미지가 없는 경우 테스트
                    price: 3000,
                    keyNutrients: [
                        KeyNutrient(name: "단백질", value: "30g"),
                        KeyNutrient(name: "당류", value: "2g")
                    ]
                ),
                Product(
                    id: "P002",
                    name: "고단백 프로틴 쉐이크",
                    imageURL: nil, // 이미지가 없는 경우 테스트
                    price: 3000,
                    keyNutrients: [
                        KeyNutrient(name: "단백질", value: "30g"),
                        KeyNutrient(name: "당류", value: "2g")
                    ]
                ),
                Product(
                    id: "P002",
                    name: "고단백 프로틴 쉐이크",
                    imageURL: nil, // 이미지가 없는 경우 테스트
                    price: 3000,
                    keyNutrients: [
                        KeyNutrient(name: "단백질", value: "30g"),
                        KeyNutrient(name: "당류", value: "2g")
                    ]
                ),
                Product(
                    id: "P002",
                    name: "고단백 프로틴 쉐이크",
                    imageURL: nil, // 이미지가 없는 경우 테스트
                    price: 3000,
                    keyNutrients: [
                        KeyNutrient(name: "단백질", value: "30g"),
                        KeyNutrient(name: "당류", value: "2g")
                    ]
                )
            ]

            // 성공적으로 가짜 데이터를 반환
            completion(.success(mockProducts))
        }
    }

    // MARK: - 상품 상세 정보 가져오기 (가짜 데이터)
    func fetchProductDetail(
        productId: String,
        completion: @escaping (Result<ProductDetail, Error>) -> Void
    ) {
        // 실제 네트워크 통신처럼 보이도록 0.5초의 딜레이를 부여
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let mockDetail = ProductDetail(
                id: productId,
                name: "맛있는 닭가슴살 100g (상세)",
                imageURL: URL(string: "https://example.com/images/chicken_breast.jpg"),
                nutritionInfo: NutritionInfo(
                    totalSize: 100,
                    calories: 130,
                    sodium: NutrientValue(amount: 300, unit: "mg", percentage: 15),
                    carbs: NutrientValue(amount: 2, unit: "g", percentage: 1),
                    sugars: NutrientValue(amount: 1, unit: "g", percentage: nil),
                    fat: NutrientValue(amount: 3, unit: "g", percentage: 4),
                    transFat: NutrientValue(amount: 0, unit: "g", percentage: 0),
                    saturatedFat: NutrientValue(amount: 1, unit: "g", percentage: 5),
                    cholesterol: NutrientValue(amount: 80, unit: "mg", percentage: 27),
                    protein: NutrientValue(amount: 25, unit: "g", percentage: 50)
                ),
                shopLinks: [
                    ShopLink(mallName: "쿠팡", price: 2500, linkURL: URL(string: "https://coupang.com")),
                    ShopLink(mallName: "네이버쇼핑", price: 2400, linkURL: URL(string: "https://shopping.naver.com")),
                    ShopLink(mallName: "마켓컬리", price: 2600, linkURL: URL(string: "https://kurly.com")),
                    ShopLink(mallName: "네이버쇼핑", price: 2400, linkURL: URL(string: "https://shopping.naver.com")),
                    ShopLink(mallName: "네이버쇼핑", price: 2400, linkURL: URL(string: "https://shopping.naver.com")),
                    ShopLink(mallName: "네이버쇼핑", price: 2400, linkURL: URL(string: "https://shopping.naver.com")),
                    ShopLink(mallName: "네이버쇼핑", price: 2400, linkURL: URL(string: "https://shopping.naver.com")),
                    ShopLink(mallName: "네이버쇼핑", price: 2400, linkURL: URL(string: "https://shopping.naver.com")),
                    ShopLink(mallName: "네이버쇼핑", price: 2400, linkURL: URL(string: "https://shopping.naver.com")),
                    ShopLink(mallName: "네이버쇼핑", price: 2400, linkURL: URL(string: "https://shopping.naver.com")),
                    ShopLink(mallName: "네이버쇼핑", price: 2400, linkURL: URL(string: "https://shopping.naver.com")),
                    ShopLink(mallName: "네이버쇼핑", price: 2400, linkURL: URL(string: "https://shopping.naver.com"))
                ]
            )

            // 성공적으로 가짜 데이터를 반환
            completion(.success(mockDetail))
        }
    }
}
