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
        completion: @escaping (Result<[Product], Error>) -> Void
    )
}

// MARK: - SearchProductsUseCase
final class SearchProductsUseCase: SearchProductsUseCaseProtocol {
    // 작업을 전달할 레포지토리 선언
    private let productRepository: ProductRepositoryProtocol

    // 의존성 주입(DI)을 통해 Repository를 받음
    init(productRepository: ProductRepositoryProtocol) {
        self.productRepository = productRepository
    }

    // UseCase의 핵심 로직을 수행하는 메서드
    func execute(
        query: SearchQuery,
        completion: @escaping (Result<[Product], Error>) -> Void
    ) {
        // TODO: - 실제 구현은 Data Layer가 완성된 후 작성
        // 지금은 Repository에 작업을 그대로 전달하는 역할만 함
        productRepository.fetchProducts(query: query, completion: completion)
    }
}
