//
//  ProductDetailDTO.swift
//  CaloLink
//
//  Created by 김성훈 on 8/12/25.
//

import Foundation

// MARK: - ProductDetailDTO
// 서버로부터 받는 "상품 상세 정보" 데이터 모델
struct ProductDetailDTO: Decodable {
    let id: String
    let name: String
    let imageURL: String?
    let nutritionInfo: NutritionInfoDTO
    let shopLinks: [ShopLinkDTO]

    func toDomain() -> ProductDetail {
        return ProductDetail(
            id: self.id,
            name: self.name,
            imageURL: URL(string: self.imageURL ?? ""),
            nutritionInfo: self.nutritionInfo.toDomain(),
            shopLinks: self.shopLinks.map { $0.toDomain() }
        )
    }
}

// MARK: - NutritionInfoDTO
struct NutritionInfoDTO: Decodable {
    let totalSize: Double?
    let calories: Double?
    let sodium: NutrientValueDTO
    let carbs: NutrientValueDTO
    let sugars: NutrientValueDTO
    let fat: NutrientValueDTO
    let transFat: NutrientValueDTO
    let saturatedFat: NutrientValueDTO
    let cholesterol: NutrientValueDTO
    let protein: NutrientValueDTO
    
    func toDomain() -> NutritionInfo {
        return NutritionInfo(
            totalSize: self.totalSize,
            calories: self.calories,
            sodium: self.sodium.toDomain(),
            carbs: self.carbs.toDomain(),
            sugars: self.sugars.toDomain(),
            fat: self.fat.toDomain(),
            transFat: self.transFat.toDomain(),
            saturatedFat: self.saturatedFat.toDomain(),
            cholesterol: self.cholesterol.toDomain(),
            protein: self.protein.toDomain()
        )
    }
}

// MARK: - NutrientValueDTO
struct NutrientValueDTO: Decodable {
    let amount: Double?
    let unit: String
    let percentage: Double?
    
    func toDomain() -> NutrientValue {
        return NutrientValue(
            amount: self.amount,
            unit: self.unit,
            percentage: self.percentage
        )
    }
}

// MARK: - ShopLinkDTO
struct ShopLinkDTO: Decodable {
    let mallName: String
    let price: Int
    let linkURL: String
    
    func toDomain() -> ShopLink {
        return ShopLink(
            mallName: self.mallName,
            price: self.price,
            linkURL: URL(string: self.linkURL) ?? URL(filePath: "")
        )
    }
}
