//
//  ProductDetail.swift
//  CaloLink
//
//  Created by 김성훈 on 8/12/25.
//

import Foundation

// MARK: - 상품 상세 화면에 필요한 모든 정보를 담는 모델
struct ProductDetail {
    let id: String
    let name: String
    let imageURL: URL?
    let nutritionInfo: NutritionInfo
    let shopLinks: [ShopLink]
}
