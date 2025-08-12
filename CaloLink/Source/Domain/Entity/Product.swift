//
//  Product.swift
//  CaloLink
//
//  Created by 김성훈 on 8/12/25.
//

import Foundation

// MARK: - 검색 결과 목록 화면에 표시될 상품의 최소 정보를 담을 모델
struct Product {
    let id: String                     // 상품 고유 ID
    let name: String                   // 상품명
    let imageURL: URL?                 // 상품 이미지 URL
    let price: Int                     // 대표 최저가
    let keyNutrients: [KeyNutrient]    // 목록에 표시할 대표 영양성분
}

// MARK: - 검색 결과 목록에서 이름과 값을 함께 보여주기 위한 작은 구조체
struct KeyNutrient {
    let name: String                // "단백질"
    let value: String               // "25g"
}
