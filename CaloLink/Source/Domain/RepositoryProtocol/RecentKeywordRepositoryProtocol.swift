//
//  RecentKeywordRepositoryProtocol.swift
//  CaloLink
//
//  Created by 김성훈 on 8/14/25.
//

// MARK: - 최근 검색어 데이터에 접근하기 위한 저장소의 인터페이스(규칙)
// 데이터의 출처가 로컬(UserDefaults)이므로 비동기 처리가 필요 없어 동기적으로 작동
protocol RecentKeywordRepositoryProtocol {
    // 저장된 모든 최근 검색어를 가져오기
    func fetchKeywords() -> [String]

    // 새로운 검색어를 저장하기
    func saveKeyword(_ keyword: String)

    // 특정 위치(index)의 검색어를 삭제하기
    func deleteKeyword(at index: Int)

    // 모든 검색어를 삭제하기
    func deleteAllKeywords()
}
