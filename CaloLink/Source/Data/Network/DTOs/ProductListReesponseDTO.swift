//
//  ProductListReesponseDTO.swift
//  CaloLink
//
//  Created by 김성훈 on 8/12/25.
//

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
