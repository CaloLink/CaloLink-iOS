//
//  SearchViewModel.swift
//  CaloLink
//
//  Created by 김성훈 on 8/13/25.
//

import Foundation

// MARK: - SearchViewModel
final class SearchViewModel {
    // MARK: - Output to VC
    // 사용자가 검색을 시작했을 때 검색어와 함께 호출될 클로저
    // VC는 이 클로저를 통해 검색 결과 화면으로 전환하는 로직을 실행
    var onSearchTriggered: ((String) -> Void)?

    // MARK: - Initializer
    init() {
        // TODO: - 최근 검색어 기능 추가하면 UseCase의존성 추가
    }

    // MARK: - Input from VC
    // 사용자가 검색 버튼을 눌렀을 때 VC로부터 호출될 메서드
    func search(with searchText: String) {
        onSearchTriggered?(searchText)
    }
}
