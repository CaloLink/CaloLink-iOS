//
//  SearchViewModel.swift
//  CaloLink
//
//  Created by 김성훈 on 5/6/25.
//

import Foundation

protocol SearchViewModelProtocol {
    var keywords: [String] { get }
    var keywordsUpdatedHandler: (() -> Void)? { get set }

    func loadKeywords()
    func addKeyword(_ keyword: String)
    func allDeleteKeywords()
    func deleteKeyword(_ keyword: String)
}

final class SearchViewModel: SearchViewModelProtocol {
    private let searchKeywordUseCase: SearchKeywordUseCaseProtocol

    var keywords: [String] = [] {
        didSet {
            keywordsUpdatedHandler?()
        }
    }

    var keywordsUpdatedHandler: (() -> Void)?

    init(searchKeywordUseCase: SearchKeywordUseCaseProtocol) {
        self.searchKeywordUseCase = searchKeywordUseCase
    }

    func loadKeywords() {
        keywords = searchKeywordUseCase.fetchKeywords()
    }

    func addKeyword(_ keyword: String) {
        searchKeywordUseCase.saveKeyword(keyword)
        loadKeywords()
    }

    func allDeleteKeywords() {
        searchKeywordUseCase.allDeleteKeywords()
        loadKeywords()
    }

    func deleteKeyword(_ keyword: String) {
        searchKeywordUseCase.deleteKeyword(keyword)
        loadKeywords()
    }
}
