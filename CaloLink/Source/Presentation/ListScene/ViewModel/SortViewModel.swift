//
//  SortViewModel.swift
//  CaloLink
//
//  Created by 김성훈 on 6/11/25.
//

import Foundation

final class SortViewModel {
    let sortingOptions = ["추천순", "낮은 가격순", "높은 가격순", "신상품순"]

    // 현재 선택된 인덱스
    private(set) var selectedIndex: Int?

    // 선택된 정렬 옵션 문자열 반환
    var selectedOption: String? {
        guard let index = selectedIndex else { return nil }
        return sortingOptions[index]
    }

    // 정렬 옵션 선택 처리
    func selectOption(at index: Int) {
        selectedIndex = index
    }

    // 해당 인덱스가 현재 선택되었는지 여부
    func isSelected(at index: Int) -> Bool {
        return selectedIndex == index
    }
}
