//
//  SearchKeywordUseCase.swift
//  CaloLink
//
//  Created by 김성훈 on 5/6/25.
//

import Foundation

protocol SearchKeywordUseCaseProtocol {
    func fetchKeywords() -> [String]
    func saveKeyword(_ keyword: String)
    func allDeleteKeywords()
    func deleteKeyword(_ keyword: String)
}

final class SearchKeywordUseCase: SearchKeywordUseCaseProtocol {
    private let searchKeywordRepository: SearchKeywordRepositoryProtocol

    init(searchKeywordRepository: SearchKeywordRepositoryProtocol) {
        self.searchKeywordRepository = searchKeywordRepository
    }

    func fetchKeywords() -> [String] {
        return searchKeywordRepository.fetchKeywords()
    }

    func saveKeyword(_ keyword: String) {
        searchKeywordRepository.saveKeyword(keyword)
    }

    func allDeleteKeywords() {
        searchKeywordRepository.allDeleteKeywords()
    }

    func deleteKeyword(_ keyword: String) {
        searchKeywordRepository.deleteKeyword(keyword)
    }
}
