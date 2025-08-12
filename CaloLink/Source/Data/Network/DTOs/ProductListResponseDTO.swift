//
//  ProductListResponseDTO.swift
//  CaloLink
//
//  Created by 김성훈 on 8/12/25.
//

/*
 API 요청(Request)과 응답(Response) 예시

 1. 앱이 서버에 보내는 요청 (Request):
    - HTTP Method: GET
    - URL: /products/search?query=닭가슴살&sort=price_asc&page=1

 2. 서버가 앱에 보내주는 응답 (Response):
    - Body (JSON):
      {
          "products": [
              {
                  "id": "P001",
                  "name": "맛있는 닭가슴살 100g",
                  "imageURL": "https://example.com/images/chicken_breast.jpg",
                  "price": 2500,
                  "keyNutrients": [
                      { "name": "단백질", "value": "25g" },
                      { "name": "칼로리", "value": "130kcal" }
                  ]
              }
          ],
          "totalPages": 10,
          "currentPage": 1
      }
*/

import Foundation

// MARK: - ProductListResponseDTO
// 상품 목록 API의 전체 응답을 감싸는 모델
// 상품 배열 외에 페이징 정보 등을 함께 받음
struct ProductListResponseDTO: Decodable {
    let products: [ProductDTO]
    let totalPages: Int
    let currentPage: Int
}

// MARK: - ProductDTO
// 서버로부터 받는 "상품" 데이터 모델
struct ProductDTO: Decodable {
    let id: String
    let name: String
    let imageURL: String?               // 서버에서 URL이 문자열로 올수있음
    let price: Int
    let keyNutrients: [KeyNutrientDTO]

    // 이 DTO를 Domain Layer의 엔티티로 변환하는 메서드
    func toDomain() -> Product {
        return Product(
            id: self.id,
            name: self.name,
            imageURL: URL(string: self.imageURL ?? ""),
            price: self.price,
            keyNutrients: self.keyNutrients.map { $0.toDomain() }
        )
    }
}

// MARK: - KeyNutrientDTO
struct KeyNutrientDTO: Decodable {
    let name: String
    let value: String

    func toDomain() -> KeyNutrient {
        return KeyNutrient(name: self.name, value: self.value)
    }
}
