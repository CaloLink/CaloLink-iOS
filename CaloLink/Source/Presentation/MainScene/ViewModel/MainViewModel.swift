//
//  MainViewModel.swift
//  CaloLink
//
//  Created by 김성훈 on 8/14/25.
//

import Foundation

// MARK: - MainViewModel
final class MainViewModel {
    // MARK: - Output to VC
    // 검색 버튼을 탭했을 때 호출될 클로저
    var onStartSearch: (() -> Void)?

    // 카테고리 버튼을 탭했을 때 선택된 카테고리 이름과 함께 호출될 클로저
    var onSelectCategory: ((String) -> Void)?

    // MARK: - Input from VC
    // 사용자가 검색 버튼을 탭했을 때 VC로부터 호출될 메서드
    func didTapSearchButton() {
        onStartSearch?()
    }

    // 사용자가 카테고리 버튼을 탭했을 때 VC로부터 호출될 메서드
    func didTapCategoryButton(with title: String) {
        onSelectCategory?(title)
    }
}
