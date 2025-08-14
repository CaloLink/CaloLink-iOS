//
//  DefaultRecentKeywordRepository.swift
//  CaloLink
//
//  Created by 김성훈 on 8/14/25.
//

import Foundation

// MARK: - DefaultRecentKeywordRepository
// UserDefaults를 사용하여 최근 검색어를 로컬에 저장하고 관리하는 Repository 구현체
final class DefaultRecentKeywordRepository: RecentKeywordRepositoryProtocol {
    // UserDefaults에 데이터를 저장할 때 사용할 고유 키
    private let userDefaultsKey = "RecentKeywords"
    // 저장할 최대 검색어 개수
    private let maxKeywordsCount = 10

    func fetchKeywords() -> [String] {
        // UserDefaults에서 문자열 배열을 가져옴
        // 저장된 값이 없으면 빈 배열을 반환
        return UserDefaults.standard.stringArray(forKey: userDefaultsKey) ?? []
    }

    func saveKeyword(_ keyword: String) {
        var keywords = fetchKeywords()

        // 이미 저장된 검색어라면 기존 것을 삭제
        keywords.removeAll { $0 == keyword }

        // 새로운 검색어를 맨 앞에 추가
        keywords.insert(keyword, at: 0)

        // 최대 개수(10개)를 초과하면 가장 오래된 검색어를 삭제
        if keywords.count > maxKeywordsCount {
            keywords = Array(keywords.prefix(maxKeywordsCount))
        }

        // 최종 배열을 UserDefaults에 저장
        UserDefaults.standard.set(keywords, forKey: userDefaultsKey)
    }

    func deleteKeyword(at index: Int) {
        var keywords = fetchKeywords()

        // 해당 인덱스의 검색어가 유효한지 확인 후 삭제
        guard keywords.indices.contains(index) else { return }
        keywords.remove(at: index)

        UserDefaults.standard.set(keywords, forKey: userDefaultsKey)
    }

    func deleteAllKeywords() {
        // 해당 키의 모든 데이터를 삭제
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
    }
}
