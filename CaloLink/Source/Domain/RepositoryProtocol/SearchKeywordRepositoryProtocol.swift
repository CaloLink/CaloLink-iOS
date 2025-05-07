//
//  SearchKeywordRepositoryProtocol.swift
//  CaloLink
//
//  Created by 김성훈 on 5/7/25.
//

import Foundation

protocol SearchKeywordRepositoryProtocol {
    func fetchKeywords() -> [String]
    func saveKeyword(_ keyword: String)
    func allDeleteKeywords()
    func deleteKeyword(_ keyword: String)
}
