//
//  ShopLink.swift
//  CaloLink
//
//  Created by 김성훈 on 8/12/25.
//

import Foundation

// MARK: - 개별 쇼핑몰의 가격과 구매 링크 정보를 담는 모델
struct ShopLink {
    let mallName: String        // 쇼핑몰 이름
    let price: Int              // 해당 쇼핑몰에서의 가격
    let linkURL: URL?           // 구매 페이지로 이동할 URL
}
