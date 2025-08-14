//
//  SortViewModel.swift
//  CaloLink
//
//  Created by 김성훈 on 8/14/25.
//

import Foundation

// MARK: - SortViewModel
final class SortViewModel {
    // MARK: - 프로퍼티
    // View에 표시할 모든 정렬 옵션 목록
    let sortingOptions: [SortOption] = SortOption.allCases

    // 현재 ListViewController에 적용되어 있는 정렬 옵션
    private(set) var currentSortOption: SortOption

    // 사용자가 SortVC에서 새로 선택한 정렬 옵션
    private(set) var selectedSortOption: SortOption

    // MARK: - Initializer
    // ListVC로부터 현재 정렬 기준을 받아 초기화
    init(currentSortOption: SortOption) {
        self.currentSortOption = currentSortOption
        self.selectedSortOption = currentSortOption // 처음에는 현재 선택된 값과 동일하게 설정
    }

    // MARK: - 메서드
    // 사용자가 특정 행을 탭했을 때 호출
    func selectOption(at index: Int) {
        guard index < sortingOptions.count else { return }
        self.selectedSortOption = sortingOptions[index]
    }

    // 특정 행이 현재 선택된 옵션인지 확인
    func isSelected(at index: Int) -> Bool {
        guard index < sortingOptions.count else { return false }
        return sortingOptions[index] == selectedSortOption
    }

    // 각 SortOption에 맞는 한글 표시 이름을 반환
    func displayName(for option: SortOption) -> String {
        switch option {
        case .defaultOrder:
            return "기본순"
        case .priceAscending:
            return "가격 낮은 순"
        case .priceDescending:
            return "가격 높은 순"
        case .newest:
            return "신상품순"
        }
    }
}
