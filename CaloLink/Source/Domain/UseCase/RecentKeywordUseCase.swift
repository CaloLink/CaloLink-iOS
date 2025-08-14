//
//  RecentKeywordUseCase.swift
//  CaloLink
//
//  Created by 김성훈 on 8/14/25.
//

// MARK: - 최근 검색어 관련 비즈니스 로직을 정의하는 프로토콜
protocol RecentKeywordUseCaseProtocol {
    func fetchKeywords() -> [String]
    func saveKeyword(_ keyword: String)
    func deleteKeyword(at index: Int)
    func deleteAllKeywords()
}

// RecentKeywordUseCaseProtocol의 기본 구현체
final class DefaultRecentKeywordUseCase: RecentKeywordUseCaseProtocol {
    private let repository: RecentKeywordRepositoryProtocol

    init(repository: RecentKeywordRepositoryProtocol) {
        self.repository = repository
    }

    func fetchKeywords() -> [String] {
        return repository.fetchKeywords()
    }

    func saveKeyword(_ keyword: String) {
        repository.saveKeyword(keyword)
    }

    func deleteKeyword(at index: Int) {
        repository.deleteKeyword(at: index)
    }

    func deleteAllKeywords() {
        repository.deleteAllKeywords()
    }
}
