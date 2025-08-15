//
//  SearchProductsUseCase.swift
//  CaloLink
//
//  Created by 김성훈 on 8/12/25.
//

// MARK: - SearchProductsUseCaseProtocol
// 상품 목록 검색 비즈니스 로직을 정의하는 프로토콜
protocol SearchProductsUseCaseProtocol {
    func execute(
        query: SearchQuery,
        completion: @escaping (Result<ProductPage, Error>) -> Void
    )
}

// MARK: - SearchProductsUseCase
final class SearchProductsUseCase: SearchProductsUseCaseProtocol {
    // 작업을 전달할 레포지토리 선언
    private let productRepository: ProductRepositoryProtocol
    private let recentKeywordRepository: RecentKeywordRepositoryProtocol

    // 의존성 주입(DI)을 통해 Repository를 받음
    init(
        productRepository: ProductRepositoryProtocol,
        recentKeywordRepository: RecentKeywordRepositoryProtocol
    ) {
        self.productRepository = productRepository
        self.recentKeywordRepository = recentKeywordRepository
    }

    // UseCase의 핵심 로직을 수행하는 메서드
    func execute(
        query: SearchQuery,
        completion: @escaping (Result<ProductPage, Error>) -> Void
    ) {
        // 검색을 실행하기전, 검색어를 로컬에 저장
        if !query.searchText.isEmpty {
            recentKeywordRepository.saveKeyword(query.searchText)
        }

        // Repository에 작업을 그대로 전달
        productRepository.fetchProducts(query: query, completion: completion)
    }
}
