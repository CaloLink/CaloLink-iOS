//
//  SearchViewModel.swift
//  CaloLink
//
//  Created by 김성훈 on 8/13/25.
//

import Foundation

// MARK: - SearchViewModel
final class SearchViewModel {
    // MARK: - 프로퍼티
    private let recentKeywordUseCase: RecentKeywordUseCaseProtocol

    // MARK: - Output to VC
    // 사용자가 검색을 시작했을 때 검색어와 함께 호출될 클로저
    // VC는 이 클로저를 통해 검색 결과 화면으로 전환하는 로직을 실행
    var onSearchTriggered: ((String) -> Void)?

    // 최근 검색어 목록이 변경될 때마다 View에게 알리기 위한 클로저
    var onKeywordsUpdate: (() -> Void)?

    // View에 표시될 최근 검색어 목록
    private(set) var recentKeywords: [String] = [] {
        didSet {
            // 배열이 변경되면 View에 알림
            onKeywordsUpdate?()
        }
    }

    // MARK: - Initializer
    init(recentKeywordUseCase: RecentKeywordUseCaseProtocol) {
        self.recentKeywordUseCase = recentKeywordUseCase
    }

    // MARK: - Input from VC

    // View가 나타날 때 호출되어 최근 검색어를 불러옴
    func viewDidLoad() {
        loadKeywords()
    }

    // 사용자가 검색 버튼을 눌렀을 때 VC로부터 호출될 메서드
    func search(with searchText: String) {
        // 새로운 검색어 저장
        recentKeywordUseCase.saveKeyword(searchText)
        // 변경된 목록을 다시 불러옴
        loadKeywords()
        // 검색 결과 화면으로 이동하라는 신호를 보냄
        onSearchTriggered?(searchText)
    }

    // 특정 위치의 검색어를 삭제
    func deleteKeyword(at index: Int) {
        recentKeywordUseCase.deleteKeyword(at: index)
        loadKeywords()
    }

    // 모든 검색어를 삭제
    func deleteAllKeywords() {
        recentKeywordUseCase.deleteAllKeywords()
        loadKeywords()
    }

    // UseCase를 통해 저장된 최근 검색어를 불러와 프로퍼티를 업데이트
    private func loadKeywords() {
        self.recentKeywords = recentKeywordUseCase.fetchKeywords()
    }
}
