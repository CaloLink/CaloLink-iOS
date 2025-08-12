//
//  ProductDetailDTO.swift
//  CaloLink
//
//  Created by 김성훈 on 8/12/25.
//

/*
 API 요청(Request)과 응답(Response) 예시

 1. 앱이 서버에 보내는 요청 (Request):
    - HTTP Method: GET
    - URL: /products/P001  (P001은 상품의 고유 ID)

 2. 서버가 앱에 보내주는 응답 (Response):
    - Body (JSON):
      {
          "id": "P001",
          "name": "맛있는 닭가슴살 100g",
          "imageURL": "https://example.com/images/chicken_breast.jpg",
          "nutritionInfo": {
              "totalSize": 100,
              "calories": 130,
              "sodium": { "amount": 300, "unit": "mg", "percentage": 15 },
              "carbs": { "amount": 2, "unit": "g", "percentage": 1 },
              "sugars": { "amount": 1, "unit": "g", "percentage": null },
              "fat": { "amount": 3, "unit": "g", "percentage": 4 },
              "transFat": { "amount": 0, "unit": "g", "percentage": 0 },
              "saturatedFat": { "amount": 1, "unit": "g", "percentage": 5 },
              "cholesterol": { "amount": 80, "unit": "mg", "percentage": 27 },
              "protein": { "amount": 25, "unit": "g", "percentage": 50 }
          },
          "shopLinks": [
              {
                  "mallName": "쿠팡",
                  "price": 2500,
                  "linkURL": "https://coupang.com/products/P001"
              }
          ]
      }
*/

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
// 서버로부터 받는 "상세 영양성분" 데이터 모델
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
// 서버로부터 받는 "개별 영양성분 값" 데이터 모델
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
            linkURL: URL(string: self.linkURL)
        )
    }
}
