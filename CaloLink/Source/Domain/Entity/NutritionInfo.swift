//
//  NutritionInfo.swift
//  CaloLink
//
//  Created by 김성훈 on 8/12/25.
//

// MARK: - 상세 영양성분 정보를 구조화한 모델
struct NutritionInfo {
    let totalSize: Double?              // 총 내용량
    let calories: Double?               // kcal

    let sodium: NutrientValue           // 나트륨
    let carbs: NutrientValue            // 탄수화물
    let sugars: NutrientValue           // 당류
    let fat: NutrientValue              // 지방
    let transFat: NutrientValue         // 트랜스지방
    let saturatedFat: NutrientValue     // 포화지방
    let cholesterol: NutrientValue      // 콜레스테롤
    let protein: NutrientValue          // 단백질
}

// MARK: - 개별 영양성분의 양, 단위, 하루 권장량 비율을 담는 모델
struct NutrientValue {
    let amount: Double?             // 양
    let unit: String                // "g" 또는 "mg"
    let percentage: Double?         // 권장량 비율
}
