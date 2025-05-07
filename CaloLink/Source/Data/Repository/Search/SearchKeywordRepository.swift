//
//  SearchKeywordRepository.swift
//  CaloLink
//
//  Created by 김성훈 on 5/6/25.
//

import Foundation

final class SearchKeywordRepository: SearchKeywordRepositoryProtocol {
    private let key = "recentSearchKeywords"

    func fetchKeywords() -> [String] {
        return UserDefaults.standard.stringArray(forKey: key) ?? []
    }

    func saveKeyword(_ keyword: String) {
        var keywords = fetchKeywords()
        keywords.removeAll() { $0 == keyword }
        keywords.insert(keyword, at: 0)

        if keyword.count > 10 {
            keywords = Array(keywords.prefix(10))
        }

        UserDefaults.standard.set(keywords, forKey: key)
    }

    func allDeleteKeywords() {
        UserDefaults.standard.removeObject(forKey: key)
    }

    func deleteKeyword(_ keyword: String) {
        var keywords = fetchKeywords()
        keywords.removeAll { $0 == keyword }
        UserDefaults.standard.set(keywords, forKey: key)
    }
}
